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
        f.button "Sign in"
        f.to_response
      end

      def callback_phase
        log :info, "--Callback phase initiated."
        begin
	  u = request.env["rack.request.form_hash"]["username"]
	  p = request.env["rack.request.form_hash"]["password"]
          log :info, "--Callback phase (1)."
#          log :info, "req: %s" % [request.inspect]
          log :info, "auth_url: <%s>" % [options.auth_url]
          log :info, "req-u: <%s>" % [u]
          log :info, "req-p: <%s>" % [p]
# OpenStack::Connection.create({:username => 'don', :api_key=>'random-password',:auth_method=>'password',:auth_url => 'https://nubo.sandvine.rocks:5000/v2.0', :authtenant_name => 'don'})

          os = OpenStack::Connection.create({
		:username => u,
		:api_key=> p,
		:auth_method=>"password",
		:auth_url => options.auth_url})
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

