#require 'ysd_md_calendar' unless defined?Yito::Model::Calendar::EventType

module Sinatra
  module YitoExtension
    module EventTypeManagementRESTApi

      def self.registered(app)

        #                    
        # Query event types
        #
        ["/api/event-types","/api/event-types/page/:page"].each do |path|
          
          app.post path do

            conditions = {}         
            
            if request.media_type == "application/x-www-form-urlencoded" # Just the text
              request.body.rewind
              search = JSON.parse(URI.unescape(request.body.read))
              if search.is_a?(Hash)
                search.each do |property, value| 
                end
              end
            end

            page = params[:page].to_i || 1
            limit = 20
            offset = (page-1) * 20
            
            data  = ::Yito::Model::Calendar::EventType.all(:conditions => conditions, :limit => limit, :offset => offset)
            total = ::Yito::Model::Calendar::EventType.count(conditions)
          
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get event types
        #
        app.get "/api/event-types" do

          event_types = ::Yito::Model::Calendar::EventType.all

          status 200
          content_type :json
          event_types.to_json

        end

        #
        # Get an event type
        #
        app.get "/api/event-type/:id" do
        
          event_type = ::Yito::Model::Calendar::EventType.get(params['id'].to_i)
          
          status 200
          content_type :json
          event_type.to_json
        
        end
        
        #
        # Create a new event type
        #
        app.post "/api/event-type" do
        
          event_type_request = body_as_json(::Yito::Model::Calendar::EventType)
          event_type = ::Yito::Model::Calendar::EventType.create(event_type_request)
         
          status 200
          content_type :json
          event_type.to_json          
        
        end
        
        #
        # Updates an event type
        #
        app.put "/api/event-type" do
          
          event_type_request = body_as_json(::Yito::Model::Calendar::EventType)
                              
          if event_type = ::Yito::Model::Calendar::EventType.get(event_type_request.delete(:id).to_i)     
            event_type.attributes=(event_type_request)  
            event_type.save
          end
      
          content_type :json
          event_type.to_json        
        
        end
        
        #
        # Deletes an event type
        #
        app.delete "/api/event-type" do
        
          event_type_request = body_as_json(::Yito::Model::Calendar::EventType)
          
          key = event_type_request.delete(:id).to_i
          
          if event_type = ::Yito::Model::Calendar::EventType.get(key)
            event_type.destroy
          end
          
          content_type :json
          true.to_json
        
        end

      end
    end
  end
end