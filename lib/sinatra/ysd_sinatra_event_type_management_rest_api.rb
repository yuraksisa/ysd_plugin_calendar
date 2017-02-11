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

            page = [params[:page].to_i, 1].max
            page_size = 20
            offset_order_query = {:offset => (page - 1)  * page_size, :limit => page_size, :order => [:name.asc]}

            if request.media_type == "application/json"
              request.body.rewind
              search_request = JSON.parse(URI.unescape(request.body.read))
              search_text = search_request['search']
              conditions = Conditions::JoinComparison.new('$or',
                                                          [Conditions::Comparison.new(:name, '$like', "%#{search_text}%"),
                                                           Conditions::Comparison.new(:description, '$like', "%#{search_text}%")
                                                          ])

              total = conditions.build_datamapper(::Yito::Model::Calendar::EventType).all.count
              data = conditions.build_datamapper(::Yito::Model::Calendar::EventType).all(offset_order_query)

            else
              total = ::Yito::Model::Calendar::EventType.count
              data  = ::Yito::Model::Calendar::EventType.all(offset_order_query)
            end

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