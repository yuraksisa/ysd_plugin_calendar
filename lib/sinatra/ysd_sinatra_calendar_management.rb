module Sinatra
  module YitoExtension
    module CalendarManagement

      def self.registered(app)

        app.settings.views = Array(app.settings.views).push(
          File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 
          'views')))
        app.settings.translations = Array(app.settings.translations).push(File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'i18n')))      

        #
        # Calendars page
        #
        app.get '/admin/calendars/?*', :allowed_usergroups => ['calendar_manager','staff'] do 

          locals = {:calendar_page_size => 20}
          load_em_page :calendars_management, nil, false, :locals => locals

        end

      end

    end
  end
end