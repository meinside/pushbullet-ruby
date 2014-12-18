#!/usr/bin/env ruby
# coding: UTF-8

# test_users.rb
# 
# test script for lib/v2/users.rb
# 
# created on : 2014.12.18
# last update: 2014.12.18
# 
# by meinside@gmail.com

require 'test/unit'

require 'io/console'

require_relative '../../pushbullet'

class TestUsers < Test::Unit::TestCase

  def setup
    # do nothing
  end

  def test_users
    print '> input your Pushbullet access token: '
    input = STDIN.noecho(&:gets)

    assert_not_nil(input)
    access_token = input.chomp
    
    Pushbullet.set_access_token(access_token)

    # my info
    info = Pushbullet::V2::Users.me
    assert_not_nil(info)

    # update my preference
    test_flag = 'test_flag'
    test_value = 'this is a flag for testing'
    updated = Pushbullet::V2::Users.update_my_preferences({test_flag => test_value})
    assert_not_nil(updated)
    assert_equal(updated['preferences'][test_flag], test_value)

    # rollback my preference
    assert_not_nil(Pushbullet::V2::Users.update_my_preferences(info['preferences']))
  end

  def teardown
    # do nothing
  end
end

