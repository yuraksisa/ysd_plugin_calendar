module Sinatra
  module YitoExtension
    module TimetableManagement

      def self.registered(app)

        #
        # Edit a timetable
        #
        app.get '/admin/calendar/timetables/:id', :allowed_usergroups => ['calendar_manager', 'staff'] do

          if @timetable = ::Yito::Model::Calendar::Timetable.get(params[:id])
            load_page :timetable_edition
          else
            status 404
          end

        end


        #
        # Timetables page
        #
        app.get '/admin/calendar/timetables/?*', :allowed_usergroups => ['calendar_manager','staff'] do 

          context = {:app => self}
          aspects = [] 
          aspects << UI::GuiBlockEntityAspectAdapter.new(GuiBlock::Timetable.new, {:weight => 99, :in_group => false})
          aspects_render = UI::EntityManagementAspectRender.new(context, aspects)
          locals = aspects_render.render(nil)
          locals.store(:timetable_page_size, 20)

          load_em_page :timetables_management, nil, false, :locals => locals

        end


      end

    end
  end
end