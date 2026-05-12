function scrDebugTextbox(oSelector){
    
    var _tempTitle = "Selected Enemies: "+string(selectedEnemies);
    
    draw_set_colour(c_black);
    draw_rectangle(x+2, y+2, x+2 + string_width(_tempTitle), y+20,false);
    draw_set_colour(c_white);
    draw_text(x+2, y+2, _tempTitle);
}