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
#          log :info, "req-u: <%s>" % [u]
#          log :info, "req-p: <%s>" % [p]

          os = OpenStack::Connection.create({
		:username => u,
		:api_key=> p,
		:auth_method=>"password",
		:auth_url => options.auth_url})
        rescue Exception => e
          #log :info, "--Callback phase (3)."
          #log :info, e.message
          return fail!(:keystone_error, e)
        end
        #log :info, "--Callback phase (4)."
	@user = u
	@user_email = u
        @user_info = {
            'name' => @user
        }
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

