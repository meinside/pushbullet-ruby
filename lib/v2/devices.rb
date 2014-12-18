# coding: UTF-8

# lib/v2/devices.rb
# 
# functions for Pushbullet devices api
# 
# created on : 2014.12.18
# last update: 2014.12.18
# 
# by meinside@gmail.com

require 'json'
require 'mimemagic'

module Pushbullet
  module V2
    class Devices
      API_URL = 'https://api.pushbullet.com/v2/devices'

      public

      # get devices list
      #
      # @return [JSON] result as json
      def self.get
        result = Pushbullet::V2::request_get(API_URL, {})

        JSON.parse(result.body)
      end

      # create a new device
      #
      # @param nickname [String] nickname of the device
      # @param type [String] type of the device
      # @return [JSON] result as json
      def self.register(nickname, type)
        result = Pushbullet::V2::request(API_URL, {
          nickname: nickname,
          type: type,
        })

        JSON.parse(result.body)
      end
      
      # update a device
      #
      # @param device_iden [String] device identifier
      # @param values [Hash] values to update
      # @return [JSON] result as json
      def self.update(device_iden, values)
        result = Pushbullet::V2::request(API_URL + '/' + device_iden, values)

        JSON.parse(result.body)
      end

      # delete a device
      #
      # @param device_iden [String] device identifier
      # @return [JSON] result as json
      def self.delete(device_iden)
        result = Pushbullet::V2::request_delete(API_URL + '/' + device_iden, {})

        JSON.parse(result.body)
      end
    end
  end
end

