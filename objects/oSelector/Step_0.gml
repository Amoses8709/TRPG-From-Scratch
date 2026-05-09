if (gridX < 0 || gridY < 0 || gridX >= oRoomController.columns || gridY >= oRoomController.rows) {
    hoverNode=noone;
}
else {
    hoverNode = global.nodeMap[gridX,gridY];
    hoverNode.occupant = global.nodeMap[gridX,gridY].occupant;
}


if(InputCheck(INPUT_VERB.PAUSE)){
    // Main menu tbd
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
        gridX = clamp(gridX+inputX,0,oRoomController.columns-1);
        gridY = clamp(gridY+inputY,0,oRoomController.rows-1);
        
    }
    
    x= gridX * GRIDSIZE;
    y= gridY * GRIDSIZE;
    selectorPaused = true;
    inputX=0;
    inputY=0;
    alarm[0] = 8;
}

if(InputCheck(INPUT_VERB.ACCEPT) && global.nodeMap[gridX,gridY].occupant != noone){
    selectedNode = global.nodeMap[gridX,gridY];
    selectedActor = global.nodeMap[gridX,gridY].occupant;
    //show_message(string(selectedNode) + string(selectedActor));
    
    scrMovementRange(selectedNode,selectedActor.move);
    
    selectedActor = hoverNode.occupant;
    selectedNode = global.nodeMap[gridX,gridY];

}
