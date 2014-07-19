module Sinatra
  module YitoExtension
    module EventTypeManagement

      def self.registered(app)
        #
        # Event type management
        #
        app.get '/admin/event-types/?*', :allowed_usergroups => ['calendar_manager','staff'] do 

          load_em_page :calendars_management, nil, false

        end

      end

    end
  end
end