#require 'ysd_md_calendar' unless defined?Yito::Model::Calendar::Event

module Sinatra
  module YitoExtension
    module EventManagementRESTApi

      def self.registered(app)

        #                    
        # Query events of a calendar
        #
        ["/api/events/:calendar_id","/api/events/:calendar_id/page/:page"].each do |path|
          
          app.post path do

            page = params[:page].to_i || 1
            limit = settings.contents_page_size
            offset = (page-1) * settings.contents_page_size
            
            conditions = {:calendar => {:id => params[:calendar_id]}}
            data  = ::Yito::Model::Calendar::Event.all(:conditions => conditions, :limit => limit, :offset => offset)
            total = ::Yito::Model::Calendar::Event.count(:conditions => conditions)
          
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get events of a calendar
        #
        app.get "/api/events/:calendar_id" do

          if params.has_key?('start') and params.has_key?('end')
            from = Time.at(params['start'].to_i)
            to = Time.at(params['end'].to_i)
            condition = condition = Conditions::JoinComparison.new('$and',
              [Conditions::Comparison.new(:calendar_id, '$eq', params[:calendar_id]),
               Conditions::JoinComparison.new('$or', 
                  [Conditions::JoinComparison.new('$and', 
                     [Conditions::Comparison.new(:from,'$lte', from),
                      Conditions::Comparison.new(:to,'$gte', from)
                     ]),
                   Conditions::JoinComparison.new('$and',
                     [Conditions::Comparison.new(:from,'$lte', to),
                      Conditions::Comparison.new(:to,'$gte', to)
                     ]),
                   Conditions::JoinComparison.new('$and',
                     [Conditions::Comparison.new(:from,'$eq', from),
                      Conditions::Comparison.new(:to,'$eq', to)
                     ]),
                   Conditions::JoinComparison.new('$and',
                     [Conditions::Comparison.new(:from, '$gte', from),
                      Conditions::Comparison.new(:to, '$lte', to)])               
                  ]
               ),
              ]
            )
            events = condition.build_datamapper(::Yito::Model::Calendar::Event).map do |event|
            {:id => event.id,
             :title => "#{event.event_type.description} #{event.description.empty? ? '': ' - ' + event.description}",
             :start => event.from,
             :end => event.to,
             :editable => false,
             :backgroundColor => event.event_type.name == 'not_available' ? 'rgb(255, 0, 0)' : 
               event.event_type.name == 'payment_enabled' ? 'rgb(21, 202, 9)' : 
               evnet.event_type.name == 'activity' ? 'rgb(20, 22, 207)' : 'rgb(0,0,0)' ,
             :textColor => 'white'}
          end

          else
            events = ::Yito::Model::Calendar::Event.all({:calendar => {:id => params[:calendar_id]}})
          end

          status 200
          content_type :json
          events.to_json

        end

        #
        # Get an event
        #
        app.get "/api/event/:id" do
        
          event = ::Yito::Model::Calendar::Event.get(params['id'].to_i)
          
          status 200
          content_type :json
          event.to_json
        
        end
        
        #
        # Create a new event
        #
        app.post "/api/event" do
        
          event_request = body_as_json(::Yito::Model::Calendar::Event)
          event = ::Yito::Model::Calendar::Event.create(event_request)
         
          status 200
          content_type :json
          event.to_json          
        
        end
        
        #
        # Updates an event
        #
        app.put "/api/event" do
          
          event_request = body_as_json(::Yito::Model::Calendar::Event)
                              
          if event = ::Yito::Model::Calendar::Event.get(event_request.delete(:id).to_i)     
            event.attributes=(event_request)  
            event.save
          end
      
          content_type :json
          event.to_json        
        
        end
        
        #
        # Deletes an event
        #
        app.delete "/api/event" do
        
          event_request = body_as_json(::Yito::Model::Calendar::Event)
          
          key = event_request.delete(:id).to_i
          
          if event = ::Yito::Model::Calendar::Event.get(key)
            event.destroy
          end
          
          content_type :json
          true.to_json
        
        end

      end
    end
  end
end