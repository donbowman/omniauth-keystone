require "omniauth-keystone/version"
require 'openstack'
require 'omniauth'


module OmniAuth
  module Strategies
    class Keystone
      include OmniAuth::Strategy

      #args [:auth_url]

      option :auth_url, nil
      option :name, 'keystone'
      option :setup, false
      option :skip_info, true


      def log(level, message)
        OmniAuth.logger.send(level, "(#{name}) #{message}")
      end

      def request_phase
        log :info, "--Request phase initiated."
        f = OmniAuth::Form.new(:title => (options[:title] || "OpenStack Authentication"), :url => callback_path)
        f.text_field 'Login', 'username'
        f.password_field 'Password', 'password'
        f.button "Make it so"
        f.to_response
      end

      def callback_phase
        log :info, "--Callback phase initiated."
        begin
          log :info, "--Callback phase (1)."
          log :info, "auth_url: %s" % [options.auth_url]
          log :info, "args: %s" % [options]
          os = OpenStack::Connection.create({:username => request['username'],
                                             :api_key=>request['password'],
                                             :auth_method=>"password",
                                             :auth_url => options.auth_url,
                                             :authtenant_name => request['username']})
          log :info, "--Callback phase (2)."
        rescue Exception => e
          log :info, "--Callback phase (3)."
          log :info, e.message
          return fail!(:keystone_error, e)
        end
        log :info, "--Callback phase (4)."
	@user = request['username']
	@user_email = request['username']
        log :info, "--Callback phase (5)."
        @user_info = {
            'name' => @user
        }
        log :info, "--Callback phase (6) %s" % [@user]
      end

      uid do 
	@user
      end
      info do {
        :name => @user,
        :email => @user_email
      }
      end
    end
  end
end

