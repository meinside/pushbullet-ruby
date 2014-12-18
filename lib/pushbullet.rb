# coding: UTF-8

# lib/pushbullet.rb
# 
# library for sending various messages through Pushbullet
# (api: https://docs.pushbullet.com/http/)
# 
# created on : 2014.12.17
# last update: 2014.12.18
# 
# by meinside@gmail.com

require 'net/http'
require 'uri'
require 'base64'
require 'json'

# v2 api
require_relative 'v2/push'
require_relative 'v2/users'
require_relative 'v2/devices'
require_relative 'v2/contacts'

module Pushbullet
  @@verbose = false
  @@access_token = nil

  module V2
    private

    # post request to Pushbullet with given url and params
    # @param url [String] api url
    # @param params [Hash] post parameters
    # @return [Net::HTTPResponse]
    def self.request(url, params)
      Pushbullet.post_data(url, params.to_json, 'application/json', {
        'Authorization' => "Basic #{Base64.encode64(Pushbullet::get_access_token).chomp}",
      })
    end

    # get request to Pushbullet with given url and params
    # @param url [String] api url
    # @param params [Hash] get parameters
    # @return [Net::HTTPResponse]
    def self.request_get(url, params)
      Pushbullet.get(url, params, {
        'Authorization' => "Basic #{Base64.encode64(Pushbullet::get_access_token).chomp}",
      })
    end

    # delete request to Pushbullet with given url and params
    # @param url [String] api url
    # @param params [Hash] delete parameters
    # @return [Net::HTTPResponse]
    def self.request_delete(url, params)
      Pushbullet.delete(url, params, {
        'Authorization' => "Basic #{Base64.encode64(Pushbullet::get_access_token).chomp}",
      })
    end
  end
  
  public

  def self.set_verbose(is_verbose = true)
    @@verbose = is_verbose
  end

  def self.set_access_token(token)
    @@access_token = token
  end

  private

  def self.is_verbose
    @@verbose
  end

  def self.get_access_token
    unless @@access_token
      puts "* Pushbullet's access token should be set first. (can be found at: https://www.pushbullet.com/account)"
      exit 1
    end
    @@access_token
  end

  # urlencode given string
  # http://tools.ietf.org/html/rfc3986#section-2.3
  #
  # @param str [String] string to urlencode
  # @param conform_to_rfc3986 [true,false]
  # @return [String] urlencoded string
  def self.urlencode(str, conform_to_rfc3986 = true)
    URI.escape(str.to_s, conform_to_rfc3986 ? Regexp.new("[^#{"-_.~a-zA-Z\\d"}]") : Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))
  end

  # http get
  #
  # @param url [String] get url
  # @param parameters [Hash] post parameters
  # @param additional_headers [Hash] additional HTTP headers
  # @return [Net::HTTPResponse]
  def self.get(url, parameters, additional_headers)
    parameters.each_pair{|key, value|
      unless url.include?("?")
        url += "?" 
      else
        url += "&"
      end
      url += "#{Pushbullet.urlencode(key)}=#{Pushbullet.urlencode(value)}"
    }
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https'){|http|
      req = Net::HTTP::Get.new(uri.request_uri)
      unless additional_headers.nil?
        additional_headers.each_pair{|key, value|
          req.add_field(key, value)
        }
      end
      return http.request(req)
    }
  end

  # http delete
  #
  # @param url [String] delete url
  # @param parameters [Hash] post parameters
  # @param additional_headers [Hash] additional HTTP headers
  # @return [Net::HTTPResponse]
  def self.delete(url, parameters, additional_headers)
    parameters.each_pair{|key, value|
      unless url.include?("?")
        url += "?" 
      else
        url += "&"
      end
      url += "#{Pushbullet.urlencode(key)}=#{Pushbullet.urlencode(value)}"
    }
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https'){|http|
      req = Net::HTTP::Delete.new(uri.request_uri)
      unless additional_headers.nil?
        additional_headers.each_pair{|key, value|
          req.add_field(key, value)
        }
      end
      return http.request(req)
    }
  end

  # http post
  #
  # @param url [String] post url
  # @param parameters [Hash] post parameters
  # @param additional_headers [Hash] additional HTTP headers
  # @return [Net::HTTPResponse]
  def self.post(url, parameters, additional_headers)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https'){|http|
      req = Net::HTTP::Post.new(uri.request_uri)
      req.set_form_data(parameters, ';')
      additional_headers.each_pair{|key, value|
        req.add_field(key.to_s, value.to_s)
      }
      return http.request(req)
    }
  end

  # http post data
  #
  # @param url [String] post url
  # @param data [Object] data
  # @param content_type [String] mime type of data
  # @param additional_headers [Hash] additional HTTP headers
  # @return [Net::HTTPResponse]
  def self.post_data(url, data, content_type, additional_headers)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https'){|http|
      req = Net::HTTP::Post.new(uri.request_uri)
      req.body = data
      req['Content-Type'] = content_type
      additional_headers.each_pair{|key, value|
        req.add_field(key.to_s, value.to_s)
      }
      return http.request(req)
    }
  end
  
  # http post multipart
  #
  # @param url [String] post url
  # @param parameters [Hash] post parameters
  # @param additional_headers [Hash] additional HTTP headers
  # @return [Net::HTTPResponse]
  def self.post_multipart(url, parameters, additional_headers)
    uri = URI.parse(url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https'){|http|
      req = Net::HTTP::Post.new(uri.request_uri)
      boundary = "____boundary_#{Time.now.to_i.to_s}____"
      req["Content-Type"] = "multipart/form-data; boundary=#{boundary}"
      body = ""
      parameters.each_pair{|key, value|
        body << "--#{boundary}\r\n"
        if value.respond_to?(:read)	# check if it's a File object
          body << "Content-Disposition: form-data; name=\"#{Pushbullet.urlencode(key)}\"; filename=\"#{File.basename(value.path)}\"\r\n"
          body << "Content-Type: #{MimeMagic.by_path(value.path)}\r\n\r\n"
          body << value.read
        else
          body << "Content-Disposition: form-data; name=\"#{Pushbullet.urlencode(key)}\"\r\n"
          body << "Content-Type: text/plain\r\n\r\n"
          body << value
        end
        body << "\r\n"
      }
      body << "--#{boundary}--\r\n"
      req.body = body
      req["Content-Length"] = req.body.size
      additional_headers.each_pair{|key, value|
        req.add_field(key.to_s, value.to_s)
      }
      return http.request(req)
    }
  end
end

