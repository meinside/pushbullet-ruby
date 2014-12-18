# coding: UTF-8

# lib/v2/subscriptions.rb
# 
# functions for Pushbullet subscriptions api
# 
# created on : 2014.12.18
# last update: 2014.12.18
# 
# by meinside@gmail.com

require 'json'
require 'mimemagic'

module Pushbullet
  module V2
    class Subscriptions
      API_URL = 'https://api.pushbullet.com/v2/subscriptions'

      public

      # get subscriptions list
      #
      # @return [JSON] result as json
      def self.get
        result = Pushbullet::V2::request_get(API_URL, {})

        JSON.parse(result.body)
      end

      # subscribe a new subscription
      #
      # @param channel_tag [String] channel tag to subscribe
      # @return [JSON] result as json
      def self.subscribe(channel_tag)
        result = Pushbullet::V2::request(API_URL, {
          channel_tag: channel_tag,
        })

        JSON.parse(result.body)
      end

      # unsubscribe a subscription
      #
      # @param subscription_iden [String] subscription identifier
      # @return [JSON] result as json
      def self.unsubscribe(subscription_iden)
        result = Pushbullet::V2::request_delete(API_URL + '/' + subscription_iden, {})

        JSON.parse(result.body)
      end

      # get information on given channel
      #
      # @param channel_tag [String] channel tag
      # @return [JSON] result as json
      def self.channel_info(channel_tag)
        result = Pushbullet::V2::request_get('https://api.pushbullet.com/v2/channel-info', {
          tag: channel_tag,
        })

        JSON.parse(result.body)
      end
    end
  end
end

