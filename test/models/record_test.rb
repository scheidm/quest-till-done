require "test_helper"

class RecordTest < ActiveSupport::TestCase
  def setup 
    Record.reindex
  end

  test "Search record fields verbatim" do
    x=Record.search "Red"
    assert_equal 1, x.results.length
    x=Record.search "thorns"
    assert_equal 1, x.results.length
  end

  test "Assign encounter id" do
    x = Record.new
    x.description = 'test'
    x.assign_encounter
    x.save
    assert_not_nil x.encounter_id
  end

  test "Inherited child" do
    child = Record.child_classes
    expectedChild = [Link, Note, Image, Commit]
    assert_equal expectedChild.size, child.size
    assert(expectedChild.all?{|i| child.include? i })
  end

  test "Valid to_link" do
    x = Record.find(1)
    assert_equal(Quest.find(x.quest_id).to_link, x.to_link)
  end
end
