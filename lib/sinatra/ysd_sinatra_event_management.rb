module Sinatra
  module YitoExtension
    module EventManagement

      def self.registered(app)
        #
        # Events of a calendar page
        #
        app.get '/admin/calendar/events/:calendar_id/?*', :allowed_usergroups => ['calendar_manager','staff'] do 

          locals = {:calendar_id => params[:calendar_id], :calendar_event_page_size => 20}

          load_em_page :events_management, nil, false, {:locals => locals}

        end

      end

    end
  end
end