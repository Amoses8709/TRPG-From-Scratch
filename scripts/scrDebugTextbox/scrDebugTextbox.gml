function scrDebugTextbox(_object){
    
    var _tempTitle = "Instances of " +_object +" : " + string(instance_number(_object));
    
    draw_set_colour(c_black);
    draw_rectangle(x+20, 0, x+20 + string_width(_tempTitle), 20,false);
    draw_set_colour(c_white);
    draw_text(x+20, 0, _tempTitle);
}