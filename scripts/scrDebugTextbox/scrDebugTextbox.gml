function scrDebugTextbox(_node){
    
    var _tempTitle = "walkable: " + string(_node.walkable) + " Occupant: "+ string(_node.occupant) + "G: "+string(_node.G);
    
    draw_set_colour(c_black);
    draw_rectangle(_node.x+2, _node.y+2, _node.x+2 + string_width(_tempTitle), _node.y+20,false);
    draw_set_colour(c_white);
    draw_text(_node.x+2, _node.y+2, _tempTitle);
}