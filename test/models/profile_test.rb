require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test "should not save profile without name and url" do
    profile = Profile.new(name: 'example')

    assert_not profile.valid?
    assert_not profile.save
  end

  test "should not save profile without git url" do
    profile = Profile.new(git_url: 'example')

    assert_not profile.valid?
    assert_not profile.save
  end

  test "should save valid profile" do
    profile = Profile.new(name: 'example', git_url: 'https://github.com/example')
    refute profile.valid?, 'Valid profile without opt attributes'
    assert_not_nil profile.errors[:name]
  end
end
