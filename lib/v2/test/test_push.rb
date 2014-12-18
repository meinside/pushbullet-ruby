#!/usr/bin/env ruby
# coding: UTF-8

# test_push.rb
# 
# test script for lib/v2/push.rb
# 
# created on : 2014.12.18
# last update: 2014.12.18
# 
# by meinside@gmail.com

require 'test/unit'

require 'io/console'

require_relative '../../pushbullet'

class TestPush < Test::Unit::TestCase

  def setup
    # do nothing
  end

  def test_push
    print '> input your Pushbullet access token: '
    input = STDIN.noecho(&:gets)

    assert_not_nil(input)
    access_token = input.chomp
    
    Pushbullet.set_access_token(access_token)

    assert_not_nil(Pushbullet::V2::Push.note('Testing pushbullet-ruby push.note', 'This note is for testing.'))
    assert_not_nil(Pushbullet::V2::Push.link('Testing pushbullet-ruby push.link', 'This link is for testing.', 'https://docs.pushbullet.com/v2/pushes/'))
    assert_not_nil(Pushbullet::V2::Push.address('Testing pushbullet-ruby push.address', 'Google Korea LLC. 22nd Floor, Gangnam Finance Center 152 Teheran-ro, Gangnam-gu'))
    assert_not_nil(Pushbullet::V2::Push.checklist('Testing pushbullet-ruby push.list', ['Test 1', 'Test 2', 'Test 3']))
    assert_not_nil(Pushbullet::V2::Push.file(__FILE__, 'Testing pushbullet-ruby push.file'))
  end

  def teardown
    # do nothing
  end

end

