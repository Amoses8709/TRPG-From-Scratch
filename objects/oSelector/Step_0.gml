if(!selectorPaused){
    if(InputCheck(INPUT_VERB.PAUSE)){
        // Main menu tbd
        selectorPaused = true;
        alarm[0] = alarmPause;  
    }
            
    // Xbox Y, PS5 triangle. switch X, PC shift - Toggles showing all enemy ranges
    if(InputCheck(INPUT_VERB.SPECIAL)){
        show_range = !show_range;
        
        if(show_range) {selectedEnemies = array_length(oRoomController.enemyChars);}
        else{selectedEnemies=0;}
        
        with(oNode){
            // If show range was just turned on show_range = true now
            // sets all enemies to selected to show range and save attack
            if(other.show_range && occupant != noone){
                
                if(occupant.army = REDARMY){
                    occupant.selected = true;
                    scrMovementRange(id, occupant.selected, id.occupant.move, id.occupant.attackRange);
                }
            }
            // If show range was just turned off show_range = false now
            // sets all enemy node's saveNode and selected = false and then wipes the nodes.
            else if(!other.show_range){
                selected = false;
                saveNode = false;
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
    
    
    // If hovernode is occupied it shows the occupantss range
    if(hoverNode.occupant != noone){
        // If hovering over a different actor than the selected actor, don't do anything
        if(!(selectedActor != noone && hoverNode.occupant != selectedActor)){
            scrMovementRange(hoverNode,hoverNode.occupant.selected, hoverNode.occupant.move, hoverNode.occupant.attackRange);    
        } 
    }
    //if hovernode is occupied, by the seleected actor
    
    
    // If hovernode isn't occupied but a hero is selected
    else if(hoverNode.occupant == noone && selectedActor != noone && selectedActor.army = BLUEARMY){
        // don't wipe nodes
        
    }
    // If hovernode isn't occupied and a hero isn't selected then wipe nodes
    else{
         scrWipeNodes(); 
    }
    
    inputX=0;
    inputY=0;
    selectorPaused = true;
    alarm[0] = alarmPause;
    
    // Selecting a non-empty hovered over node
    if((InputCheck(INPUT_VERB.ACCEPT) && global.nodeMap[gridX,gridY].occupant != noone)){
        selectedNode = global.nodeMap[gridX,gridY];
        selectedActor = global.nodeMap[gridX,gridY].occupant;
        
        //the selected actor is blue and they were already selected
        if(selectedActor.army = BLUEARMY && selectedActor.selected){
            //player options stuff tbd
        }
        else if(selectedActor.army =BLUEARMY){
            if(selectedActor.selected == false){
                selectedActor.selected = true;
            }
        }
            
        // If the actor is already selected and is an enemy, decrement selected enemies
        else if(selectedActor.army =REDARMY && selectedActor.selected){
                //unselect it and decrement selected enemies
                selectedActor.selected = false;
                selectedEnemies -=1;
                show_range = false;
                scrMovementRange(selectedNode, selectedActor.selected, selectedActor.move, selectedActor.attackRange);
                scrWipeNodes();           
                
                // This will redraw the range for any remaining enemies incase the removed enemy had overlapping ranges
                if(selectedEnemies > 0){
                    with(oNode){
                        if(occupant != noone){
                            if(occupant.army=REDARMY && occupant.selected){
                                scrMovementRange(self, occupant.selected, occupant.move, occupant.attackRange);
                            }
                        }
                    }
                } 
                //scrWipeNodes();
             }
             // If the node isn't already selected and the occupant was an enemy, increment selected enemies
            else if(selectedActor.selected == false && selectedActor.army =REDARMY){
                 selectedActor.selected = true;
                 selectedEnemies +=1;
            }
            //IF the selected actor is blue and there wasn't already a selected actor
            else if(selectedActor.army =BLUEARMY){
                if(selectedActor.selected == false){
                     selectedActor.selected = true;
                 }
                 //Need to replace this when implement
                 else{
                     selectedActor.selected = false;
                     //player options stuff tbd
                 }
            }
             
            scrMovementRange(selectedNode, selectedActor.selected, selectedActor.move, selectedActor.attackRange);
             
            selectedActor = hoverNode.occupant;
            selectedNode = global.nodeMap[gridX,gridY];
        }
        selectorPaused = true;
        alarm[0] = alarmPause; 
    
    
    if(InputCheck(INPUT_VERB.CANCEL)){
        if(selectedActor != noone && selectedActor.army = BLUEARMY) {
            with(oNode){
                if(occupant == other.selectedActor){
                    scrMovementRange(self, false, other.selectedActor.move, other.selectedActor.attackRange);
                }
            }
            selectedActor = noone;
            selectedNode = noone;
            scrWipeNodes();
        }
    }
}

// If the player has manually selected all of the enemies, show range is flipped to true
// this is because it is essentially the same as show range and prevents needing a second button push.
activeEnemies = array_length(oRoomController.enemyChars);

if(selectedEnemies = activeEnemies){ 
    show_range = true;
}
