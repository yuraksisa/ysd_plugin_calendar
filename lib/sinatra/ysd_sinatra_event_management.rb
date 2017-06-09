module Sinatra
  module YitoExtension
    module EventManagement

      def self.registered(app)
        #
        # Events of a calendar page
        #
        app.get '/admin/calendar/events/:calendar_id/?*', :allowed_usergroups => ['calendar_manager','staff'] do 

          today = DateTime.now
          year = params[:year] || today.year
          month = params[:month] || (today.month - 1)

          if calendar = ::Yito::Model::Calendar::Calendar.get(params[:calendar_id])
            locals = {:calendar => calendar,
                      :year => year, 
                      :month => month,
                      :mode => (params[:mode] || 'date')}
            load_page :events_management, {:locals => locals}
          else
            status 401
          end

        end

      end

    end
  end
end