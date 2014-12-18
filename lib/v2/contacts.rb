# coding: UTF-8

# lib/v2/contacts.rb
# 
# functions for Pushbullet contacts api
# 
# created on : 2014.12.18
# last update: 2014.12.18
# 
# by meinside@gmail.com

require 'json'
require 'mimemagic'

module Pushbullet
  module V2
    class Contacts
      API_URL = 'https://api.pushbullet.com/v2/contacts'

      public

      # get contacts list
      #
      # @return [JSON] result as json
      def self.get
        result = Pushbullet::V2::request_get(API_URL, {})

        JSON.parse(result.body)
      end

      # create a new contact
      #
      # @param name [String] nickname of the contact
      # @param email [String] email of the contact
      # @return [JSON] result as json
      def self.create(name, email)
        result = Pushbullet::V2::request(API_URL, {
          name: name,
          email: email,
        })

        JSON.parse(result.body)
      end
      
      # update a contact
      #
      # @param contact_iden [String] contact identifier
      # @param name [String] name of the contact
      # @return [JSON] result as json
      def self.update(contact_iden, name)
        result = Pushbullet::V2::request(API_URL + '/' + contact_iden, {
          name: name,
        })

        JSON.parse(result.body)
      end

      # delete a contact
      #
      # @param contact_iden [String] contact identifier
      # @return [JSON] result as json
      def self.delete(contact_iden)
        result = Pushbullet::V2::request_delete(API_URL + '/' + contact_iden, {})

        JSON.parse(result.body)
      end
    end
  end
end

