## First attempt of an interactive selection.
## Using code from "Automatic SketchUp" and the SketchUp API docs.

require 'sketchup.rb'

#------------------------------------------------------------------------------#
#
#                            Face_Selector Class
#
#------------------------------------------------------------------------------#
class Face_Selector
    
    def initialize
        puts "Initialized"
        @obj = nil
        @point = nil
    end
    
    def activate
        @point = Sketchup::InputPoint.new
        @obj = Sketchup::InputPoint.new
    end
    
    def onLButtonDown(flags, x, y, view)
        @point.pick(view, x, y)
        @obj = @point.face
        coords = @point.position
        puts coords
        if @obj == nil
            Sketchup::set_status_text("Position ", SB_VCB_LABEL)
            status_msg = "%.2f, %.2f, %.2f" % [coords.x, coords.y, coords.z]
            Sketchup::set_status_text(status_msg, SB_VCB_VALUE)
        else
            Sketchup::set_status_text("Face Area", SB_VCB_LABEL)
            status_msg = @obj.area.to_s
            Sketchup::set_status_text(status_msg, SB_VCB_VALUE)
        end # if
    end # onLButtonDown
    
    # Returns nil if no face selected.
    def get_face
        return @obj
    end

end # class Face_Selector