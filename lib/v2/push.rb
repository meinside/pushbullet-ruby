# coding: UTF-8

# lib/v2/push.rb
# 
# functions for Pushbullet push api
# 
# created on : 2014.12.18
# last update: 2015.07.01
# 
# by meinside@gmail.com

require 'mimemagic'
require 'json'

module Pushbullet
  module V2
    class Push
      API_URL = 'https://api.pushbullet.com/v2/pushes'

      public

      # push note
      #
      # @param title [String] title of note
      # @param text [String] body text of note
      # @param recipient [Hash] key-value of either one of: 'email', 'device_iden', 'channel_tag', or 'client_iden' (can be nil)
      # @return [JSON] result as json (nil if error)
      def self.note(title, text, recipient = nil)
        params = {
          type: :note,
          title: title,
          body: text,
        }
        params.merge!(recipient) if recipient

        result = Pushbullet::V2::request(API_URL, params)

        case result
        when Net::HTTPOK
          return JSON.parse(result.body)
        else
          puts result.body if Pushbullet.is_verbose
          return nil
        end
      end

      # push link
      #
      # @param title [String] title of note
      # @param text [String] body text of note
      # @param link [String] url of the link
      # @param recipient [Hash] key-value of either one of: 'email', 'device_iden', 'channel_tag', or 'client_iden' (can be nil)
      # @return [JSON] result as json (nil if error)
      def self.link(title, text, link, recipient = nil)
        params = {
          type: :link,
          title: title,
          body: text,
          url: link,
        }
        params.merge!(recipient) if recipient

        result = Pushbullet::V2::request(API_URL, params)

        case result
        when Net::HTTPOK
          return JSON.parse(result.body)
        else
          puts result.body if Pushbullet.is_verbose
          return nil
        end
      end
      
      # push file
      #
      # @param filepath [String] absolute path of file
      # @param text [String] body text
      # @param recipient [Hash] key-value of either one of: 'email', 'device_iden', 'channel_tag', or 'client_iden' (can be nil)
      # @return [JSON] result as json (nil if error)
      def self.file(filepath, text, recipient = nil)
        to_upload = _request_upload_file(filepath)
        if _upload_file(filepath, to_upload['upload_url'], to_upload['data'])
          params = {
            type: :file,
            file_name: to_upload['file_name'],
            file_type: to_upload['file_type'],
            file_url: to_upload['file_url'],
            body: text,
          }
          params.merge!(recipient) if recipient

          result = Pushbullet::V2::request(API_URL, params)

          case result
          when Net::HTTPOK
            return JSON.parse(result.body)
          else
            puts result.body if Pushbullet.is_verbose
            return nil
          end
        end

        false
      end

      private

      def self._request_upload_file(filepath)
        result = Pushbullet::post('https://api.pushbullet.com/v2/upload-request', {
            file_name: File.basename(filepath),
            file_type: MimeMagic.by_path(filepath),
          }, {
            'Authorization' => "Basic #{Base64.encode64(Pushbullet::get_access_token).chomp}",
          })
        
        JSON.parse(result.body)
      end

      def self._upload_file(filepath, upload_url, auth_data)
        File.open(filepath, 'rb'){|file|
          result = Pushbullet::post_multipart(upload_url, {
              awsaccesskeyid: auth_data['awsaccesskeyid'],
              acl: auth_data['acl'],
              key: auth_data['key'],
              signature: auth_data['signature'],
              policy: auth_data['policy'],
              'content-type' => auth_data['content-type'],
              file: file,
            }, {})

          case result
          when Net::HTTPNoContent
            return true
          else
            puts result.body if Pushbullet.is_verbose
            return false
          end
        }

        false
      end
    end
  end
end

