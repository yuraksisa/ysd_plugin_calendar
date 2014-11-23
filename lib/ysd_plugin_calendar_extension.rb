require 'ysd-plugins_viewlistener' unless defined?Plugins::ViewListener

#
# Huasi CMS Extension
#
module Huasi
  class CalendarExtension < Plugins::ViewListener

    # ========= Installation =================

    # 
    # Install the plugin
    #
    def install(context={})

    end
    

    # --------- Menus --------------------
    
    #
    # It defines the admin menu menu items
    #
    # @return [Array]
    #  Menu definition
    #
    def menu(context={})
      
      app = context[:app]

      menu_items = [{:path => '/apps/calendar',              
                     :options => {:title => app.t.system_admin_menu.apps.calendar_menu.title,
                                  :description => 'Calendars',
                                  :module => :calendar,
                                  :weight => 6}
                    },
                    {:path => '/apps/calendar/calendars',              
                     :options => {:title => app.t.system_admin_menu.apps.calendar_menu.calendars,
                                  :link_route => "/admin/calendar/calendars",
                                  :description => 'Calendars management',
                                  :module => :booking,
                                  :weight => 7}
                    },
                     ]                      
    
    end  

    # ========= Routes ===================
            
    # routes
    #
    # Define the module routes, that is the url that allow to access the funcionality defined in the module
    #
    #
    def routes(context={})
    
      routes = [                                            
               ]
        
    end
    
  end
end