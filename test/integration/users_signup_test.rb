require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
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

  test "valid sign should create new user" do
  	assert_difference 'User.count', 1 do
  		post_via_redirect users_path, user: { name:  "Example User",
                                        email: "user@example.com",
                                        password:              "password",
                                        password_confirmation: "password" }
    end
    assert_template 'users/show'
    assert_select "div[class='alert alert-success]", "Welcome to my app!"
  end 
end
