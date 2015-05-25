require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
  test "flash should display correctly on invalid login" do
  	get login_path
  	assert_template 'sessions/new'
  	post login_path session: { email: 'foobar@foo.com', password: "foobar"}
  	assert_template 'sessions/new'
  	assert_select "div[class='alert alert-danger'", "Email/password don't match"
  	get root_path
  	assert flash.empty? 
  end
end
