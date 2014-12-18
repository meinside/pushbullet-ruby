#!/usr/bin/env ruby
# coding: UTF-8

# test_subscriptions.rb
# 
# test script for lib/v2/subscriptions.rb
# 
# created on : 2014.12.18
# last update: 2014.12.18
# 
# by meinside@gmail.com

require 'test/unit'

require 'io/console'

require_relative '../../pushbullet'

class TestSubscriptions < Test::Unit::TestCase

  def setup
    # do nothing
  end

  def test_subscriptions
    print '> input your Pushbullet access token: '
    input = STDIN.noecho(&:gets)

    assert_not_nil(input)
    access_token = input.chomp
    
    Pushbullet.set_access_token(access_token)

    # subscribe
    channel_tag = 'pushbullet'
    subscribed = Pushbullet::V2::Subscriptions.subscribe(channel_tag)
    assert_not_nil(subscribed)  # XXX - should check its result (it can be 'Already subscribed to this channel.' error)

    # get
    subscriptions = Pushbullet::V2::Subscriptions.get
    assert_not_nil(subscriptions)

    subscribed = subscriptions['subscriptions'].first

    # channel info
    assert_not_nil(Pushbullet::V2::Subscriptions.channel_info(subscribed['channel']['tag']))

    # unsubscribe
    assert_not_nil(Pushbullet::V2::Subscriptions.unsubscribe(subscribed['iden']))
  end

  def teardown
    # do nothing
  end
end

