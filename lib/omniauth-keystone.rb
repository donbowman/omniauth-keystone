require "omniauth-keystone/version"
require 'openstack'
require 'omniauth'


module OmniAuth
  module Strategies
    class Keystone
      include OmniAuth::Strategy

      args [:api_token]

      option :auth_url, nil
      option :name, 'keystone'
      option :app_id, nil
      option :app_secret, nil

      attr_accessor :auth_token

      def request_phase
        OmniAuth::Form.build(
          :title => (options[:title] || "Authenticate"), 
          :url => callback_path
        ) do |field|
          field.text_field 'Username', 'username'
          field.password_field 'Password', 'password'
        end.to_response
      end

      def callback_phase
        os = OpenStack::Connection.create({:username => request['username'],
                                           :api_key=>request['password'],
                                           :auth_method=>"password",
                                           :auth_url => auth_url,
                                           :authtenant_name => request['username']})
        super
      end

      def callback_phase
        rpam_opts = Hash.new
        rpam_opts[:service] = options[:service] unless options[:service].nil?

        unless Rpam.auth(request['username'], request['password'], rpam_opts)
          return fail!(:invalid_credentials)
        end

        super
      end

      uid do
        raw_info['user']['user_id']
      end

      info do
        {
          :name     => raw_info['user']['uid'],
          :nickname => raw_info['user']['uid'],
          :email    => raw_info['user']['email'],
          :nickname => raw_info['user']['login'],
        }
      end
    end
  end
end

