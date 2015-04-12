require 'ysd-plugins' unless defined?Plugins::Plugin
require 'ysd_plugin_booking_extension'

Plugins::SinatraAppPlugin.register :calendar do

   name=        'calendar'
   author=      'yurak sisa'
   description= 'Calendar integration'
   version=     '0.1'
   hooker       Huasi::CalendarExtension
   sinatra_extension Sinatra::YitoExtension::CalendarManagement
   sinatra_extension Sinatra::YitoExtension::CalendarManagementRESTApi
   sinatra_extension Sinatra::YitoExtension::EventTypeManagement
   sinatra_extension Sinatra::YitoExtension::EventTypeManagementRESTApi   
   sinatra_extension Sinatra::YitoExtension::EventManagement
   sinatra_extension Sinatra::YitoExtension::EventManagementRESTApi
   sinatra_extension Sinatra::YitoExtension::TimetableManagement
   sinatra_extension Sinatra::YitoExtension::TimetableManagementRESTApi

end