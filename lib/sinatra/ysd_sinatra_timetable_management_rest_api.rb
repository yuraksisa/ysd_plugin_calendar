#require 'ysd_md_calendar' unless defined?Yito::Model::Calendar::Calendar

module Sinatra
  module YitoExtension
    module TimetableManagementRESTApi

      def self.registered(app)

        #                    
        # Query rate timetables
        #
        ["/api/timetables","/api/timetables/page/:page"].each do |path|
          
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

              total = conditions.build_datamapper(::Yito::Model::Calendar::Timetable).all.count
              data = conditions.build_datamapper(::Yito::Model::Calendar::Timetable).all(offset_order_query)

            else
              total = ::Yito::Model::Calendar::Timetable.count
              data  = ::Yito::Model::Calendar::Timetable.all(offset_order_query)
            end
            
          
            content_type :json
            {:data => data, :summary => {:total => total}}.to_json
          
          end
        
        end
        
        #
        # Get timetable
        #
        app.get "/api/timetable" do

          data = ::Yito::Model::Calendar::Timetable.all

          status 200
          content_type :json
          data.to_json

        end

        #
        # Get a timetable
        #
        app.get "/api/timetable/:id" do
        
          data = ::Yito::Model::Calendar::Timetable.get(params[:id].to_i)
          
          status 200
          content_type :json
          data.to_json
        
        end
        
        #
        # Create a new timetable
        #
        app.post "/api/timetable" do
        
          data_request = body_as_json(::Yito::Model::Calendar::Timetable)

          begin
            data = ::Yito::Model::Calendar::Timetable.new(data_request)
            data.save
           rescue DataMapper::SaveFailureError => error
             p "Error saving timetable #{error} #{data.inspect} #{data.errors.inspect}"
             raise error 
           end
          status 200
          content_type :json
          data.to_json          
        
        end
        
        #
        # Updates a timetable
        #
        app.put "/api/timetable" do
          
          data_request = body_as_json(::Yito::Model::Calendar::Timetable)
                              
          if data = ::Yito::Model::Calendar::Timetable.get(data_request.delete(:id).to_i)     
            data.attributes=data_request  
            data.save
          end
      
          content_type :json
          data.to_json        
        
        end
        
        #
        # Deletes a timetable 
        #
        app.delete "/api/timetable" do
        
          data_request = body_as_json(::Yito::Model::Calendar::Timetable)
          
          key = data_request.delete(:id).to_i
          
          if data = ::Yito::Model::Calendar::Timetable.get(key)
            data.destroy
          end
          
          content_type :json
          true.to_json
        
        end

      end
    end
  end
end