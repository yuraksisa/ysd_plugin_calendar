module Sinatra
  module YitoExtension
    module EventTypeManagement

      def self.registered(app)
        #
        # Event type management
        #
        app.get '/admin/calendar/event-types/?*', :allowed_usergroups => ['calendar_manager','staff'] do 

          locals = {:event_type_page_size => 20}
          load_em_page :calendars_management, nil, false, :locals => locals

        end

      end

    end
  end
end