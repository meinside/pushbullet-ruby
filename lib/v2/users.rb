# coding: UTF-8

# lib/v2/users.rb
# 
# functions for Pushbullet users api
# 
# created on : 2014.12.18
# last update: 2014.12.18
# 
# by meinside@gmail.com

require 'json'
require 'mimemagic'

module Pushbullet
  module V2
    class Users
      API_URL = 'https://api.pushbullet.com/v2/users'

      public

      # get my information
      #
      # @return [JSON] result as json
      def self.me
        result = Pushbullet::V2::request_get(API_URL + '/me', {})

        JSON.parse(result.body)
      end
      
      # update my preferences
      #
      # @param preferences [Hash] values to overwrite
      # @return [JSON] result as json
      def self.update_my_preferences(preferences)
        result = Pushbullet::V2::request(API_URL + '/me', {preferences: preferences})

        JSON.parse(result.body)
      end
    end
  end
end

