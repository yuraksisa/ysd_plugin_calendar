module GuiBlock
  #
  # It allows to adapt the timetable information to the Aspects system 
  #
  class Timetable

    def weight
      101
    end

    def in_group
      true
    end

    def show_on_new
      true
    end

    def show_on_edit
      true
    end

    def show_on_view
      true
    end

    def get_aspect_definition(context={})
      return self
    end

    #
    # Information
    #
    def element_info(context={})
      app = context[:app]
      {:id => 'timetable', :description => "#{app.t.guiblock.timetable.description}"} 
    end

    #
    # Edit Form tab
    #
    def element_form_tab(context={}, aspect_model)
      app = context[:app]
      info = element_info(context)
      app.render_tab("#{info[:id]}_template", info[:description])
    end

    #
    # Edition form
    #
    def element_form(context={}, aspect_model)
      
      app = context[:app]
      renderer = ::UI::FieldSetRender.new('timetable', app)      
      renderer.render('form', 'em')     

    end

    #
    # Editing support
    #
    def element_form_extension(context={}, aspect_model)
    
      app = context[:app]

      renderer = ::UI::FieldSetRender.new('timetable', app)      
      renderer.render('formextension', 'em')      

    end   

    #
    # View tab
    #
    def element_template_tab(context={}, aspect_model)

      app = context[:app]
      info = element_info(context)
      app.render_tab("#{info[:id]}_template", info[:description])

    end    
    
    #
    # View
    #
    def element_template(context={}, aspect_model)
    
      app = context[:app]
      renderer = ::UI::FieldSetRender.new('timetable', app)      
      renderer.render('view', 'em')

    end    

  end
end