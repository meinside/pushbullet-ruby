#!/usr/bin/env ruby
# coding: UTF-8

# test_contacts.rb
# 
# test script for lib/v2/contacts.rb
# 
# created on : 2014.12.18
# last update: 2014.12.18
# 
# by meinside@gmail.com

require 'test/unit'

require 'io/console'

require_relative '../../pushbullet'

class TestContacts < Test::Unit::TestCase

  def setup
    # do nothing
  end

  def test_contacts
    print '> input your Pushbullet access token: '
    input = STDIN.noecho(&:gets)

    assert_not_nil(input)
    access_token = input.chomp
    
    Pushbullet.set_access_token(access_token)

    # get
    assert_not_nil(Pushbullet::V2::Contacts.get)

    # create
    created = Pushbullet::V2::Contacts.create('test contact', 'email-that-does-not-exist@earth.com')
    assert_not_nil(created)

    # update
    new_name = 'test contact 2'
    updated = Pushbullet::V2::Contacts.update(created['iden'], new_name)
    assert_not_nil(updated)
    assert_equal(updated['name'], new_name)

    # delete
    assert_not_nil(Pushbullet::V2::Contacts.delete(created['iden']))
  end

  def teardown
    # do nothing
  end
end

