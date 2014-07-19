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
                                  :link_route => "/admin/calendars",
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
    
      routes = [{:path => '/reserva',
                  :regular_expression => /^\/reserva/, 
                 :title => 'Reserva' , 
                 :description => 'Formulario para realizar reserva',
                 :fit => 1,
                 :module => :booking},
               {:path => '/apps/bookings/booking-categories',
                  :regular_expression => /^\/admin\/booking-categories/,
                  :title => 'Booking categories',
                  :fit => 1,
                  :module => :booking}, 
                {:path => '/apps/bookings/booking-items',
                  :regular_expression => /^\/admin\/booking-items/,
                  :title => 'Booking items',
                  :fit => 1,
                  :module => :booking},                 
                {:path => '/apps/bookings/bookings',
                 :regular_expression => /^\/admin\/bookings/, 
                 :title => 'Bookings', 
                 :description => 'Booking management',
                 :fit => 1,
                 :module => :booking },   
                {:path => '/apps/bookings/scheduler',
                 :regular_expression => /^\/admin\/bookings\/scheduler/, 
                 :title => 'Scheduler', 
                 :description => 'Booking scheduler',
                 :fit => 1,
                 :module => :booking }                                                  
               ]
        
    end
    
  end
end