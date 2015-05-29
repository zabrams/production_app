require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:michael)
    @other_user = users(:archer)
  end

  test "paginated index page should be present with delete" do
  	log_in_as(@user)
  	get users_path
  	assert_template 'users/index'
  	assert_select 'div.pagination'
  	User.paginate(page:1).each do |user|
  		assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @user
        assert_select "a[href=?]", user_path(user), text: 'Delete'
      end
  	end
    assert_difference 'User.count', -1 do
      delete user_path(@other_user)
    end
  end

  test "index as non admin" do
    log_in_as(@other_user)
    get users_path 
    assert_select "a[href=?]", text: 'delete', count: 0
  end
  
end
