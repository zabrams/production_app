require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  
  def setup 
  	ActionMailer::Base.deliveries.clear
  	@user = users(:michael)
  end

  test "password resets" do
  	get new_password_reset_path
  	#reset for non existant user
  	post password_resets_path, password_reset: {email: ""} 
  	assert_not flash.empty? 
  	assert_template 'password_resets/new'
  	#valid email 
  	post password_resets_path, password_reset: {email: @user.email}
  	assert_not_equal @user.reset_digest, @user.reload.reset_digest
  	assert_equal 1, ActionMailer::Base.deliveries.size
  	assert_not flash.empty?
  	assert_redirected_to root_url
  	#password reset form
  	user = assigns(:user)
  	#wrong email 
  	get edit_password_reset_path(user.reset_token, email: "")
  	assert_redirected_to root_url
  	#inactive user
  	user.toggle!(:activated)
  	get edit_password_reset_path(user.reset_token, email: user.email)
  	assert_redirected_to root_url
  	user.toggle!(:activated)
  	#right email, wrong token 
  	get edit_password_reset_path("wrong token", email: user.email)
  	assert_redirected_to root_url
  	#correct email 
  	get edit_password_reset_path(user.reset_token, email: user.email)
  	assert_template 'password_resets/edit'
  	assert_select "input[name=email][type=hidden][value=?]", user.email
  	#invalid password combination
  	patch password_reset_path(user.reset_token), email: user.email, user: { password: "foobar", password_confirmation: "barfoo"}
  	assert_select 'div#error_explanation'
  	#empty password
	patch password_reset_path(user.reset_token), email: user.email, user: { password: "", password_confirmation: ""}
  	assert_not flash.empty? 
  	assert_template "password_resets/edit"
  	#correct 
  	patch password_reset_path(user.reset_token), email: user.email, user: { password: "foobar", password_confirmation: "foobar"}
  	assert is_logged_in? 
  	assert_not flash.empty? 
  	assert_redirected_to user
  end


end
