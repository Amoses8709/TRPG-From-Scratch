if (gridX < 0 || gridY < 0 || gridX >= oRoomController.columns || gridY >= oRoomController.rows) {
    hoverNode=noone;
}
else {
    hoverNode = global.nodeMap[gridX,gridY];
    hoverNode.occupant = global.nodeMap[gridX,gridY].occupant;
}

var _xMove = keyboard_check(ord("D")) + keyboard_check(vk_right) - keyboard_check(ord("A")) - keyboard_check(vk_left);
var _yMove = keyboard_check(ord("S")) + keyboard_check(vk_down) - keyboard_check(ord("W")) - keyboard_check(vk_up);
var _pause = keyboard_check(vk_enter);
var _accept = keyboard_check(vk_space);
    
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
    _pause = gamepad_button_check(_gp,gp_start);
    _accept = gamepad_button_check(_gp,gp_face1);
} 

if(_pause){
    // Main menu tbd
}

if(_accept){
    if(hoverNode.occupant != noone){
        selectedActor = hoverNode.occupant;
        selectedNode = global.nodeMap[gridX,gridY];
        show_message(selectedActor + string(selectedNode))
        
    }
 
       
}

if(!selectorPaused){
    //Checks for directional input and ignores if opposite directions are pushed
    if(InputCheck(INPUT_VERB.RIGHT) xor InputCheck(INPUT_VERB.LEFT)){
        if(InputCheck(INPUT_VERB.RIGHT)) {inputX=1;}
        else if(InputCheck(INPUT_VERB.LEFT)) {inputX=-1;}
    }
    else if(InputCheck(INPUT_VERB.UP) xor InputCheck(INPUT_VERB.DOWN)){
        if(InputCheck(INPUT_VERB.DOWN)) {inputY=1;}
        else if(InputCheck(INPUT_VERB.UP)) {inputY=-1;}
    }
    else{
        inputX=0;
        inputY=0;
    }
    // Input
    if (inputX!=0||inputY!=0){
        
        //show_message(string(oRoomController.columns)+" : "+string(oRoomController.rows));
        gridX = clamp(gridX+inputX,0,oRoomController.columns);
        gridY = clamp(gridY+inputY,0,oRoomController.rows);
        
    }
    
    x= gridX * GRIDSIZE;
    y= gridY * GRIDSIZE;
    selectorPaused = true;
    alarm[0] = 8;
}
