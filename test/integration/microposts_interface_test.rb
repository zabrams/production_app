require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:michael)
  end

  test "microposts interface" do
  	log_in_as(@user)
  	get root_path
  	assert_select 'div.pagination'
  	#invalid submission 
  	assert_no_difference "Micropost.count" do
  		post microposts_path, micropost: { content: "" }
  	end
  	#valid submission 
  	content = "lorem ipsum"
  	assert_difference 'Micropost.count', 1 do
  		post microposts_path, micropost: { content: content }
  	end
  	assert_redirected_to root_url
  	follow_redirect!
  	assert_match content, response.body
  	#delete post
  	first_micropost = @user.microposts.paginate(page: 1).first
  	assert_select 'a', text: 'Delete'
  	assert_difference 'Micropost.count', -1 do
  		delete micropost_path(first_micropost)
  	end
  	#visit second users page / ensure no delete links
  	other_user = users(:archer)
  	get user_path(other_user)
  	assert_select 'a', text: 'Delete', count: 0
  end
end
