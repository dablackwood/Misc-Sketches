## First attempt to generate a dynamic component via Ruby extension.

require 'sketchup.rb'
require 'dynamicCubeTry/faceSelector.rb'

SKETCHUP_CONSOLE.show

UI.menu("Plugins").add_item("Make Cube") {
    Sketchup.active_model.select_tool(Face_Extruder.new)
}


#------------------------------------------------------------------------------#
#
#                            Face_Extruder Class
#
#------------------------------------------------------------------------------#
class Face_Extruder < Face_Selector
    
    def initialize
        puts "Face_Extruder initialized"
        @face = nil
        @box = nil
        @obj = nil
        @point = nil
    end
    
    def activate
        puts "Face_Extruder activated"
        Sketchup::set_status_text("Select a face to extrude.", SB_PROMPT)
        @point = Sketchup::InputPoint.new
    end
    
    def set_dialog
        prompts =   ["Height", "Flip Z?"] #["Length", "Width", "Height"]
        #TODO Preview of Z direction.
        defaults =  [1, "False"] #[9, 3, 1]
        list =      ["", "False|True"]
        results = UI.inputbox(prompts, defaults, list, "Inputbox Example")
        puts results.class
        puts results
        if results != false
            height, flip_z = results
            [height, flip_z]
        else
            nil
        end #if
    end
    
    def optional_on_left_fn
        @face = get_face
        if @face.class != Sketchup::Face
            puts get_face.class
        else # Face object selected successfully.
            puts @face.class
            # Start dialog box.
            Sketchup::set_status_text("Set extrusion parameters.", SB_PROMPT)
            results = set_dialog
            if results == nil
                return
            end
            height, flip_z = results
            @box = extrude_box(@face, height, flip_z)
        end #if
    end # optional_on_left_fn
    
    # Absorbs the input face.
    def extrude_box(face, height, flip_z)
        if flip_z
            face.reverse!
        end
        model = Sketchup.active_model
        entities = model.entities
        face.pushpull(height)
        box = entities.add_group(face.all_connected)
        b_box = box.local_bounds
        x_dim = b_box.width  # Along X
        y_dim = b_box.height # Along Y
        z_dim = b_box.depth  # Along Z
        box.name = "Box"
        box.description = "New box"
        puts box.name
        set_all_box_attributes(box, x_dim, y_dim, z_dim)
        box
    end # extrude_box
    
    def set_all_box_attributes(box, x_dim, y_dim, z_dim)
        box.set_attribute("dynamic_attributes", "_lengthunits", "INCHES")
        box.set_attribute("dynamic_attributes", "_lenx_label", "LenX")
        box.set_attribute("dynamic_attributes", "_leny_label", "LenY")
        box.set_attribute("dynamic_attributes", "_lenz_label", "LenZ")
        box.set_attribute("dynamic_attributes", "_lenx_access", "TEXTBOX")
        box.set_attribute("dynamic_attributes", "_leny_access", "TEXTBOX")
        box.set_attribute("dynamic_attributes", "_lenz_access", "TEXTBOX")
#         box.set_attribute("dynamic_attributes", "_lenx_units", "MM")
#         box.set_attribute("dynamic_attributes", "_leny_units", "MM")
#         box.set_attribute("dynamic_attributes", "_lenz_units", "MM")
        box.set_attribute("dynamic_attributes", "lenx", x_dim)
        box.set_attribute("dynamic_attributes", "leny", y_dim)
        box.set_attribute("dynamic_attributes", "lenz", z_dim)
        dc_attr = box.attribute_dictionaries["dynamic_attributes"]
        puts "Set attributes:"
        dc_attr.each { |k, v| puts "\t" + k.to_s + " " + v.to_s }
        box.set_attribute("divide_and_conquer_attributes", "type", "cube")
        cust_attr = box.attribute_dictionaries["divide_and_conquer_attributes"]
        puts "Set attributes:"
        cust_attr.each { |k, v| puts "\t" + k.to_s + " " + v.to_s }
        dcs = $dc_observers.get_latest_class
        dcs.redraw_with_undo(box)
    end # set_all_box_attributes

end # class Face_Extruder