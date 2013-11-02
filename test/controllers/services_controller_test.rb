require 'test_helper'

class ServicesControllerTest < ActionController::TestCase
  setup do
    @service = services(:one)
    @admin_openid_url = openid_urls(:profile_one_primary)
    @admin_profile = @admin_openid_url.profile
    
    @user = profiles(:two)
  end

  test "should get index" do
    get :index, {}, {:login_profile_id => @admin_profile.id}
    assert_response :success
  end

  test "should get new" do
    get :new, {}, {:login_profile_id => @admin_profile.id}
    assert_response :success
  end

  test "should create service" do
    assert_difference('Service.count') do
      post :create, {service: {  }}, {:login_profile_id => @admin_profile.id}
    end

    assert_redirected_to service_path(assigns(:service))
  end

  test "should show service" do
    get :show, {id: @service}, {:login_profile_id => @admin_profile.id}
    assert_response :success
  end

  test "should get edit" do
    get :edit, {id: @service}, {:login_profile_id => @admin_profile.id}
    assert_response :success
  end

  test "should update service" do
    patch :update, {id: @service, service: {  }}, {:login_profile_id => @admin_profile.id}
    assert_redirected_to service_path(assigns(:service))
  end

  test "should destroy service" do
    assert_difference('Service.count', -1) do
      delete :destroy, {id: @service}, {:login_profile_id => @admin_profile.id}
    end

    assert_redirected_to services_path
  end

  test "shouldn't get index by guest" do
    get :index
    assert_response :forbidden
  end

  test "shouldn't get new by guest" do
    get :new
    assert_response :forbidden
  end

  test "shouldn't create service by guest" do
    assert_no_difference('Service.count') do
      post :create, service: {  }
    end

    assert_response :forbidden
  end

  test "shouldn't show service by guest" do
    get :show, id: @service
    assert_response :forbidden
  end

  test "shouldn't get edit by guest" do
    get :edit, id: @service
    assert_response :forbidden
  end

  test "shouldn't update service by guest" do
    patch :update, id: @service, service: {  }
    assert_response :forbidden
  end

  test "shouldn't destroy service by guest" do
    assert_no_difference('Service.count', -1) do
      delete :destroy, id: @service
    end

    assert_response :forbidden
  end

  test "shouldn't get index by user" do
    get :index, {}, {:login_profile_id => @user.id}
    assert_response :forbidden
  end

  test "shouldn't get new by user" do
    get :new, {}, {:login_profile_id => @user.id}
    assert_response :forbidden
  end

  test "shouldn't create service by user" do
    assert_no_difference('Service.count') do
      post :create, {service: {  }}, {:login_profile_id => @user.id}
    end

    assert_response :forbidden
  end

  test "shouldn't show service by user" do
    get :show, {id: @service}, {:login_profile_id => @user.id}
    assert_response :forbidden
  end

  test "shouldn't get edit by user" do
    get :edit, {id: @service}, {:login_profile_id => @user.id}
    assert_response :forbidden
  end

  test "shouldn't update service by user" do
    patch :update, {id: @service, service: {  }}, {:login_profile_id => @user.id}
    assert_response :forbidden
  end

  test "shouldn't destroy service by user" do
    assert_no_difference('Service.count', -1) do
      delete :destroy, {id: @service}, {:login_profile_id => @user.id}
    end

    assert_response :forbidden
  end
end
