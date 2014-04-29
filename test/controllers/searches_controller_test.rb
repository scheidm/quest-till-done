require 'test_helper'
require 'will_paginate/array'
include Devise::TestHelpers

class SearchesControllerTest < ActionController::TestCase

  def setup
    Record.reindex
    Quest.reindex
    Campaign.reindex
    sign_in User.first
    Campaign.reindex
    Record.reindex
    Quest.reindex
  end

  def teardown
    @results = nil;
  end

  test "Get index with quest" do
    get :index, :query => "panda"
    Rails.logger.info assigns(:results)
    assert_response :success
    assert_not_nil assigns(:results)
    assert assigns(:results).size > 0
    assigns(:results).each do |item|
      assert_equal Quest, item.class
    end
  end

  test "Get index with record and parent quest" do
    get :index, :query => "squirrel"
    Rails.logger.info assigns(:results)
    assert_response :success
    assert_not_nil assigns(:results)
    assert assigns(:results).size > 1
    assert Record.child_classes.include? assigns(:results)[1].class
    assert_equal Quest, assigns(:results)[0].class

    note = Note.find(assigns(:results)[1])
    assert_equal assigns(:results)[0].id, note.quest_id
  end

  test "Get index with quest and type" do
    get :index, :query => "squirrel", :type => "Note"
    Rails.logger.info assigns(:results)
    assert_response :success
    assert_not_nil assigns(:results)
    assert assigns(:results).size == 1
    assigns(:results).each do |item|
      assert_equal Note, item.class
    end
  end

  test "Get index with no query" do
    get :index, :query => ""
    assert_response :success
    assert_not_nil assigns(:results)
    assert_equal assigns(:results).size, 0
  end

  test "Get auto complete" do
    get :quest_autocomplete, :format => :json, :query => "panda"
    body = JSON.parse(response.body)

    assert_response :success
    assert body.size > 0
    assert body[0]["name"].to_s.include?("panda")
  end

  test "Get all complete" do
    get :all_autocomplete, :format => :json, :query => "squirrel"
    body = JSON.parse(response.body)

    assert_response :success
    assert body.size == 2
  end
end
