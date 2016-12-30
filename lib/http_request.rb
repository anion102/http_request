# encoding:utf-8
# author:anion
require 'net/http'
require 'uri'
require 'uri/generic'
require 'json'
require_relative 'http_request/version'

module HttpRequest
  #公用函数请求封装
  # http:post  request's data can be json string
  def post *args
    begin
      uri = URI.parse args[0]
      req = Net::HTTP::Post.new(uri.request_uri,args[2])
      req.body = args[1]
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      return JSON.parse(res.body)
    rescue Exception=>e
      if e.message!=''
        p res.code
        p e.message
        return false
      end
    end
  end

# http:post  request's data can be data form
  def post_form(*args)
    begin
      uri = URI.parse(args[0])
      Net::HTTP.start(uri.host,uri.port){|http|
        req = Net::HTTP::Post.new(uri.path,args[2])
        req.set_form_data args[1]
        @res = http.request(req)
        # return JSON.parse(res.body)
      }
      return JSON.parse(@res.body)
    rescue Exception=>e
      puts e.message
    end
  end

#http:get  request's data can be json string
  def get_json *args
    begin
      uri = URI.parse args[0]
      req = Net::HTTP::Get.new(uri.request_uri,args[2])
      req.body = args[1]
      res = Net::HTTP.start(uri.hostname, uri.port) do |http|
        http.request(req)
      end
      return JSON.parse(res.body)
    rescue Exception=>e
      if e.message!=''
        p res.code
        p e.message
        return false
      end
    end
  end

#get请求 请求包是表单格式，返回body并转换成json对象text/html;charset=UTF-8
  def get_form *args
    uri = URI.parse(args[0])
    uri.query=URI.encode_www_form(args[1])
    res = Net::HTTP.get_response(uri)
    begin
      return JSON.parse(res.body)
    rescue Exception=>e
      puts e.message
    end
  end

# directly go to url
  def get url
    uri = URI(url)
    response = Net::HTTP.get_response(uri)
    return JSON.parse(response.body)
  end

end
