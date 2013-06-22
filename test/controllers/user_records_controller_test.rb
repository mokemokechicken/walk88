require 'test_helper'

class UserRecordsControllerTest < ActionController::TestCase
  setup do
    @user_record = user_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_record" do
    assert_difference('UserRecord.count') do
      post :create, user_record: { day: @user_record.day, distance: @user_record.distance, steps: @user_record.steps, user_id: @user_record.user_id }
    end

    assert_redirected_to user_record_path(assigns(:user_record))
  end

  test "should show user_record" do
    get :show, id: @user_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_record
    assert_response :success
  end

  test "should update user_record" do
    patch :update, id: @user_record, user_record: { day: @user_record.day, distance: @user_record.distance, steps: @user_record.steps, user_id: @user_record.user_id }
    assert_redirected_to user_record_path(assigns(:user_record))
  end

  test "should destroy user_record" do
    assert_difference('UserRecord.count', -1) do
      delete :destroy, id: @user_record
    end

    assert_redirected_to user_records_path
  end
end
