#require 'ysd_md_calendar' unless defined?Yito::Model::Calendar::Calendar

module Sinatra
  module YitoExtension
    module CalendarManagementRESTApi

      def self.registered(app)

        #                    
        # Query calendars
        #
        ["/api/calendars","/api/calendars/page/:page"].each do |path|
          
          app.post path do

            page = params[:page].to_i || 1
            limit = 20
            offset = (page-1) * 20

            conditions = {}         
            
            if request.media_type == "application/x-www-form-urlencoded" # Just the text
              search_text = if params[:search]
                              params[:search]
                            else
                              request.body.rewind
                              request.body.read
                            end
              conditions = Conditions::JoinComparison.new('$or', 
                              [Conditions::Comparison.new(:id, '$eq', search_text.to_i),
                               Conditions::Comparison.new(:name, '$eq', search_text.upcase)])   

              total = conditions.build_datamapper(::Yito::Model::Calendar::Calendar).all.count 
              data = conditions.build_datamapper(::Yito::Model::Calendar::Calendar).all(:limit => limit, :offset => offset) 
            else
              data  = ::Yito::Model::Calendar::Calendar.all(:limit => limit, :offset => offset)
              total = ::Yito::Model::Calendar::Calendar.count
                                          
            end
            
          
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get calendars
        #
        app.get "/api/calendars" do

          calendars = ::Yito::Model::Calendar::Calendar.all

          status 200
          content_type :json
          calendars.to_json

        end

        #
        # Get a calendar
        #
        app.get "/api/calendar/:id" do
        
          calendar = ::Yito::Model::Calendar::Calendar.get(params['id'].to_i)
          
          status 200
          content_type :json
          calendar.to_json
        
        end
        
        #
        # Create a new calendar
        #
        app.post "/api/calendar" do
        
          calendar_request = body_as_json(::Yito::Model::Calendar::Calendar)
          calendar = ::Yito::Model::Calendar::Calendar.create(calendar_request)
         
          status 200
          content_type :json
          calendar.to_json          
        
        end
        
        #
        # Updates a calendar
        #
        app.put "/api/calendar" do
          
          calendar_request = body_as_json(::Yito::Model::Calendar::Calendar)
                              
          if calendar = ::Yito::Model::Calendar::Calendar.get(calendar_request.delete(:id).to_i)     
            calendar.attributes=(calendar_request)  
            calendar.save
          end
      
          content_type :json
          calendar.to_json        
        
        end
        
        #
        # Deletes a calendar
        #
        app.delete "/api/calendar" do
        
          calendar_request = body_as_json(::Yito::Model::Calendar::Calendar)
          
          key = calendar_request.delete(:id).to_i
          
          if calendar = ::Yito::Model::Calendar::Calendar.get(key)
            calendar.destroy
          end
          
          content_type :json
          true.to_json
        
        end

      end
    end
  end
end