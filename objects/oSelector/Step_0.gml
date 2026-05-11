if(!selectorPaused){
    if(InputCheck(INPUT_VERB.PAUSE)){
        // Main menu tbd
        selectorPaused = true;
        alarm[0] = alarmPause;  
    }
            
    // Xbox Y, PS5 triangle. switch X, PC shift - Toggles showing all enemy ranges
    if(InputCheck(INPUT_VERB.SPECIAL)){
        show_range = !show_range;
         
        with(oNode){
            // If show range was just turned on show_range = true now
            // sets all enemies to selected to show range and save attack
            if(other.show_range && occupant != noone){
                if(occupant.army = REDARMY){
                    selected = true;
                    scrMovementRange(id, id.selected, id.occupant.move, id.occupant.attackRange);
                }
            }
            // If show range was just turned off show_range = false now
            // sets all enemy node's saveattack and selected = false and then wipes the nodes.
            else if(!other.show_range){
                selected = false;
                saveAttack = false;
            }
        }
        selectorPaused = true;
        alarm[0] = alarmPause; 
        scrWipeNodes();
        exit;   
    }
         
    //Checks for directional input and ignores if opposite directions are pushed
    if((InputCheck(INPUT_VERB.RIGHT) xor InputCheck(INPUT_VERB.LEFT))){
        if(InputCheck(INPUT_VERB.RIGHT)) {inputX=1;}
        else if(InputCheck(INPUT_VERB.LEFT)) {inputX=-1;}
        selectorPaused = true;
        alarm[0] = alarmPause; 
    }
    else if((InputCheck(INPUT_VERB.UP) xor InputCheck(INPUT_VERB.DOWN))){
        if(InputCheck(INPUT_VERB.DOWN)) {inputY=1;}
        else if(InputCheck(INPUT_VERB.UP)) {inputY=-1;}
        selectorPaused = true;
        alarm[0] = alarmPause; 
    }
    else{
        inputX=0;
        inputY=0;
        selectorPaused = true;
        alarm[0] = alarmPause; 
    }
    
    
    // If there is input
    if (inputX!=0||inputY!=0){
        
        //show_message(string(oRoomController.columns)+" : "+string(oRoomController.rows));
        gridX = clamp(gridX+inputX,0,oRoomController.columns-1);
        gridY = clamp(gridY+inputY,0,oRoomController.rows-1);
        
    }
    
    x= gridX * GRIDSIZE;
    y= gridY * GRIDSIZE;
    hoverNode = global.nodeMap[gridX,gridY];
    hoverNode.occupant = global.nodeMap[gridX,gridY].occupant;
    
    
    // If hovernode is occupied it shows the occupants range
    if(hoverNode.occupant != noone){
        scrMovementRange(hoverNode,hoverNode.selected, hoverNode.occupant.move, hoverNode.occupant.attackRange);    
    }
    // If hovernode isn't occupied then wipe nodes
    else{ 
         scrWipeNodes(); 
    }
    
    inputX=0;
    inputY=0;
    selectorPaused = true;
    alarm[0] = alarmPause;
    
    // Selecting a hovered over node
    if((InputCheck(INPUT_VERB.ACCEPT) && global.nodeMap[gridX,gridY].occupant != noone)){
        selectedNode = global.nodeMap[gridX,gridY];
        selectedActor = global.nodeMap[gridX,gridY].occupant;
        // If the node is already selected and the occupant was an enemy, decrement selected enemies
        if(selectedNode.selected == true && selectedActor.army =REDARMY){
            //unselect it and decrement selected enemies
            selectedNode.selected = false;
            selectedEnemies -=1;
            show_range = false;
            scrWipeNodes();
        }
        // If the node isn't already selected and the occupant was an enemy, increment selected enemies
        else if(selectedNode.selected == false && selectedActor.army =REDARMY){
            selectedNode.selected = true;
            selectedEnemies +=1;
        }
        else if(selectedActor.army =BLUEARMY){
            if(selectedNode.selected == false){
                selectedNode.selected = true;
            }
            //Need to replace this when implementing cancel
            else{
                selectedNode.selected = false;
                //player options stuff tbd
            }
        }
        
        scrMovementRange(selectedNode, selectedNode.selected, selectedActor.move, selectedActor.attackRange);
        
        selectedActor = hoverNode.occupant;
        selectedNode = global.nodeMap[gridX,gridY];
        
        selectorPaused = true;
        alarm[0] = alarmPause; 
    }
    
}

// If the player has manually selected all of the enemies, show range is flipped to true
// this is because it is essentially the same as show range and prevents needing a second button push.
activeEnemies = array_length(oRoomController.enemyChars);

if(selectedEnemies = activeEnemies){ 
    show_range = true;
}
