require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup should not create user" do
  	get signup_path
  	assert_no_difference 'User.count' do
  		post users_path, user: {name: "", email: "user@invalid", 
  			password: "foo", password_confirmation: "bar"}
  	end
  	assert_template 'users/new' 
    assert_select "div[class='alert alert-danger']" 
    assert_select "4 errors"
  end

  test "valid sign up and activation should create new user" do
  	assert_difference 'User.count', 1 do
  		post users_path, user: { name:  "Example User",
                                        email: "user@example.com",
                                        password:              "password",
                                        password_confirmation: "password" }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated? 
    log_in_as(user)
    assert_not is_logged_in?
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end 
end
