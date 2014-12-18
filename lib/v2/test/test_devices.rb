#!/usr/bin/env ruby
# coding: UTF-8

# test_devices.rb
# 
# test script for lib/v2/devices.rb
# 
# created on : 2014.12.18
# last update: 2014.12.18
# 
# by meinside@gmail.com

require 'test/unit'

require 'io/console'

require_relative '../../pushbullet'

class TestDevices < Test::Unit::TestCase

  def setup
    # do nothing
  end

  def test_users
    print '> input your Pushbullet access token: '
    input = STDIN.noecho(&:gets)

    assert_not_nil(input)
    access_token = input.chomp
    
    Pushbullet.set_access_token(access_token)

    # get
    assert_not_nil(Pushbullet::V2::Devices.get)

    # register
    registered = Pushbullet::V2::Devices.register('test device', 'android')
    assert_not_nil(registered)

    # update
    new_name = 'test device 2'
    updated = Pushbullet::V2::Devices.update(registered['iden'], {nickname: new_name})
    assert_not_nil(updated)
    assert_equal(updated['nickname'], new_name)

    # delete
    assert_not_nil(Pushbullet::V2::Devices.delete(registered['iden']))
  end

  def teardown
    # do nothing
  end
end

