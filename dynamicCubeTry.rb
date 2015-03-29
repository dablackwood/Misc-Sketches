## First attempt to generate a dynamic component via Ruby extension.

require 'sketchup.rb'
require 'dynamicCubeTry/faceSelector.rb'

SKETCHUP_CONSOLE.show

UI.menu("Plugins").add_item("Make Cube") {
    prompts =   ["Height", "Flip Z?"] #["Length", "Width", "Height"]
    #TODO Preview of Z direction.
    defaults =  [1, "False"] #[9, 3, 1]
    list =      ["", "False|True"]
    try = 0

    Sketchup::set_status_text("Select a face to extrude.", SB_PROMPT)
    face_sel = Face_Selector.new
    my_face = face_sel.get_face 
    while try < 5 and my_face == nil
        puts try
        my_face = face_sel.get_face
        try += 1
    end
    puts my_face.class
    results = UI.inputbox(prompts, defaults, list, "Inputbox Example")
    puts results.class
    puts results
    height = results[0]
    flip_z = results[1]
    extrude_box(my_face, height, flip_z)
}

# def select_face
#     #TODO use pick_helper
#     sel = Sketchup.active_model.selection
#     # For now, only one face is permitted.
#     return nil if sel.count != 1
#     face = sel[0]
#     return nil if not face.instance_of? Sketchup::Face
#     return face
# end # select_face

def make_cube(length, width, height)    
    # Get entities
    model = Sketchup.active_model
    entities = model.entities
    
    # Make geometry
    p1 = [0, 0, 0]
    p2 = [length, 0, 0]
    p3 = [length, width, 0]
    p4 = [0, width, 0]
    
    face = entities.add_face p1, p2, p3, p4
    face.pushpull height
    puts entities.length
end # make_cube

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
    box.set_attribute("dynamic_attributes", "_lengthunits", "INCHES")
    box.set_attribute("dynamic_attributes", "_lenx_label", "LenX")
    box.set_attribute("dynamic_attributes", "_leny_label", "LenY")
    box.set_attribute("dynamic_attributes", "_lenz_label", "LenZ")
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
    
end # extrude_box