require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "flash should display correctly on invalid login" do
  	get login_path
  	assert_template 'sessions/new'
  	post login_path session: { email: 'foobar@foo.com', password: "foobar"}
  	assert_template 'sessions/new'
  	assert_select "div[class='alert alert-danger'", "Email/password don't match"
  	get root_path
  	assert flash.empty? 
  end

  test "should properly log in user" do
  	get login_path
  	post_via_redirect login_path, session: { email: @user.email, password: 'password' }
  	assert_template 'users/show'
  	assert_select "a[href=?]", login_path, count: 0
  	assert_select "a[href=?]", user_path(@user)
  	assert_select "a[href=?]", logout_path
  end

end
