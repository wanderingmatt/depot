require 'test_helper'
require 'nokogiri'
require 'json'

class InfoControllerTest < ActionController::TestCase
  test "who_bought returns correct HTML by default" do
    get :who_bought, :id => products(:one).id
    
    assert_response :success
    assert_tag :tag => 'h3', :content => "People Who Bought #{products(:one).title}"
  end
  
  test "who_bought returns correct XML" do
    get :who_bought, :id => products(:one).id, :format => 'xml'
    doc = Nokogiri::XML(@response.body)
    
    assert_response :success
    assert_tag :tag => 'title', :content => products(:one).title
  end
  
  test "who_bought returns correct ATOM" do
    get :who_bought, :id => products(:one).id, :format => 'atom'
    doc = Nokogiri::XML(@response.body)
    
    assert_response :success
    assert_tag :tag => 'title', :content => "Who bought #{products(:one).title}"
  end
  
  test "who_bought returns correct JSON" do
    get :who_bought, :id => products(:one).id, :format => 'json'
    doc = ActiveSupport::JSON(@response.body)
    
    assert_response :success
    assert_equal products(:one).title, doc['product']['title']
  end
end
