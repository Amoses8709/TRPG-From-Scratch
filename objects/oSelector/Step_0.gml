var _xMove = keyboard_check(ord("D")) + keyboard_check(vk_right) - keyboard_check(ord("A")) - keyboard_check(vk_left);
var _yMove = keyboard_check(ord("S")) + keyboard_check(vk_down) - keyboard_check(ord("W")) - keyboard_check(vk_up);
    
var _gp = global.gamepad_main;   
if(_gp != undefined){
    if(abs(gamepad_axis_value(_gp,gp_axislh))>abs(gamepad_axis_value(_gp,gp_axislv))){
        _xMove = gamepad_button_check(_gp,gp_padr) + sign(gamepad_axis_value(_gp,gp_axislh)) - gamepad_button_check(_gp,gp_padl);
        _yMove = 0;
    }
    else{
        _xMove = gamepad_button_check(_gp,gp_padr) - gamepad_button_check(_gp,gp_padl);
        _yMove = gamepad_button_check(_gp,gp_padd) + sign(gamepad_axis_value(_gp,gp_axislv)) - gamepad_button_check(_gp,gp_padu);
    }    
 } 





if(!selectorPaused){
    //User Input    
    inputX = _xMove;
    inputY = _yMove;
    
    // Input
    if (inputX!=0||inputY!=0){
        
        //Prefer X over Y
        if (inputX !=0) {inputY=0;}
        
        //New Position 
        var _newTileX = to_tile(x) + inputX;
        var _newTileY = to_tile(y) + inputY;    
        
        //show_message(string(oRoomController.columns)+" : "+string(oRoomController.rows));
        gridX = clamp(gridX+inputX,0,oRoomController.columns);
        gridY = clamp(gridY+inputY,0,oRoomController.rows);
        
        
    }
    
    x= gridX * GRIDSIZE;
    y= gridY * GRIDSIZE;
    selectorPaused = true;
    alarm[0] = 8;
}

if(selectedActor != noone){
    gridX = selectedActor.gridX;
    gridY = selectedActor.gridX;
}