require 'openid-connect'

class OpenidUrlsController < ApplicationController
  before_action :login_required, :only => [:destroy]

  def login
    begin
      openid_url = params[:openid_url].gsub("#", "%23")
      request = consumer.begin(openid_url)
      trust_root = root_url
      return_to = url_for(:action=> 'complete', :service_id => params[:service_id])

      url = request.redirect_url(trust_root, return_to)
      redirect_to(url)

      flash[:auth_mode] = params[:mode]

    rescue OpenID::OpenIDError, OpenID::DiscoveryFailure
      flash[:notice] = "認証に失敗しました"
      flash[:service_id] = params[:service_id]
      redirect_to profile_authenticate_path
    end
  end

  def complete
    current_url = url_for(:service_id => params[:service_id])
    parameters =
      params.tap{|p| p.permit(p.keys.select{|k| k.start_with?('openid.') }) }
      .reject{ |k,v| request.path_parameters[k] or request.path_parameters[k.to_sym] }
    parameters.delete(:service_id)
    response = consumer.complete(parameters, current_url)

    begin
      @service = Service.find(params[:service_id])
    rescue ActiveRecord::RecordNotFound
      # do nothing
    end

    case response.status
    when OpenID::Consumer::SUCCESS
      identity_retrieved_after(response.identity_url)

    else
      if @service.present?
        redirect_to @service.authenticate_failure
      else
        flash[:notice] = "認証できませんでした。"
        redirect_to :controller => :profiles, :action => :authenticate
      end
    end
  end

  # DELETE /openid_urls/1
  # DELETE /openid_urls/1.json
  def destroy
    @openid_url = OpenidUrl.find(params[:id])

    if @login_profile == @openid_url.profile
      @openid_url.destroy unless @openid_url.primary_openid

      respond_to do |format|
        format.html { redirect_to profile_path }
        format.json { render :json => {:status => 200 } }
      end
    else
      forbidden
    end
  end

  private
  # OpenID::Consumerオブジェクトを取得
  def consumer
    if @consumer.nil?
      dir = "#{::Rails.root.to_s}/tmp/"
      store = OpenID::Store::Filesystem.new(dir)
      @consumer = OpenID::Consumer.new(session, store)
    end

    return @consumer
  end
end
