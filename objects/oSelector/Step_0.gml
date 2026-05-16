activeEnemies = array_length(oRoomController.enemyChars);
if(selectedEnemies+heroSelected=0){
    noOneSelected = true;
    }
else{
    noOneSelected = false;
}

if(!selectorPaused){
    if(InputCheck(INPUT_VERB.PAUSE)){
        // Main menu tbd
        selectorPaused = true;
        alarm[0] = alarmPause;  
    }
            
    // Xbox Y, PS5 triangle. switch X, PC shift - Toggles showing all enemy ranges
    if(InputCheck(INPUT_VERB.SPECIAL)){
        show_range = !show_range;
        
        if(show_range) {
            selectedEnemies = array_length(oRoomController.enemyChars);
        }
        else{
            selectedEnemies=0;
        }
        
        with(oNode){ 
            // If show range was just turned on show_range = true now
            //Go through and check all node occupants
            for(aa=0;aa<other.sHeight;aa++){
                // if the node is occupied
                if(occupant != noone){
                    //and the occupant matches the current actor
                    if(other.selected[aa][0] = occupant){
                        //and show range is on and occupant is red army
                        if(other.show_range && occupant.army = REDARMY){
                            //set them to selected
                            other.selected[aa][0].selected = true;
                            other.selected[aa][1] = self;
                            scrMovementRange(id, occupant.selected, occupant.move, occupant.attackRange,false);
                        }
                        // lse if show range is off and occupant is red army
                        else if(!other.show_range && occupant.army = REDARMY){
                            //unselect them
                            other.selected[aa][0].selected = false;
                            other.selected[aa][1] = self;
                            scrMovementRange(id, occupant.selected, occupant.move, occupant.attackRange,false);
                        }
                    }
                    
                }
            }
        }
        
        selectorPaused = true;
        alarm[0] = alarmPause; 
        scrWipeNodes();
        exit;   
    }
         
    // Selecting a non-empty hovered over node
    if((InputCheck(INPUT_VERB.ACCEPT) && global.nodeMap[gridX,gridY].occupant != noone)){
        
        // if there are no selected actors selected 
        if(selectedEnemies+heroSelected=0){
            // loop through selected array and find matching id
            for(aa=0;aa<sHeight;aa++){
                if(global.nodeMap[gridX,gridY].occupant == selected[aa][0]){
                    global.nodeMap[gridX,gridY].occupant.selected = true;
                    selected[aa][1] = global.nodeMap[gridX,gridY]; // SelectedNode
                    selected[aa][0].selected = true; 
                    //if the newly selected actor is a hero
                    if(selected[aa][0].army =BLUEARMY){
                        selectedHero = selected[aa][0]
                        heroIndex=aa;
                        heroSelected = true;
                    }
                    //if the newly selected actor is an enemy
                    else {
                        selectedEnemies +=1;
                    }
                    scrMovementRange(selected[aa][1], selected[aa][0].selected, selected[aa][0].move, selected[aa][0].attackRange,false); 
                }
            }
             
        }
            
        //else there is at least 1 selected actor
        else {
            // if a hero is selected, only can do stuff with that hero unless you hit cancel or complete turn
            if(heroSelected){
                if(global.nodeMap[gridX,gridY].occupant = selectedHero){
                //do play option stuff later//Show hero options, but don't unselect or add selections.
                //Player must cancel selcection before selection anything else.
                }
            }
            //if no heroes are selected
            else {
                // if there is 1 or more enemies selected
                if(selectedEnemies > 0 ){
                    //check all occupants in the array
                    for(aa=0;aa<sHeight;aa++){
                        //Find the occupant of the selected node in selected array
                        //if occupant matches the actor for the array
                        if(selected[aa][0] = global.nodeMap[gridX,gridY].occupant){
                            //and the node isn't already selected, then select it
                            if(selected[aa][1]==noone){ 
                                global.nodeMap[gridX,gridY].occupant.selected = true;
                                selected[aa][1] = global.nodeMap[gridX,gridY];
                                scrMovementRange(selected[aa][1], selected[aa][0].selected, selected[aa][0].move, selected[aa][0].attackRange,false);
                                
                                //if the newly selected actor is red army
                                if(selected[aa][0].army = REDARMY){
                                    selectedEnemies +=1; 
                                }
                                //if the newly selected actor is blue army
                                else{
                                    heroSelected = true;
                                    selectedHero = selected[aa][0];
                                    heroIndex = aa;
                                    scrMovementRange(selected[aa][1], false, selected[aa][0].move, selected[aa][0].attackRange,false);
                                }
                            }
                            // the node is already selected, then deselect it
                            else {    //(selected[aa][1]!=noone)
                                global.nodeMap[gridX,gridY].occupant.selected = false;
                                scrMovementRange(selected[aa][1], false, selected[aa][0].move, selected[aa][0].attackRange,false);
                                if(global.nodeMap[gridX,gridY].occupant.army = REDARMY){
                                    selectedEnemies -=1;
                                    show_range = false; 
                                }
                                selected[aa][1] = noone;
                            }
                        } 
                        //for selected actors who aren't the occupant
                        else if(selected[aa][1] != noone){
                            scrMovementRange(selected[aa][1], selected[aa][0].selected, selected[aa][0].move, selected[aa][0].attackRange,false)
                        }
                    }
                }
            }
        }
             
        }
        selectorPaused = true;
        alarm[0] = alarmPause; 
    
    
    if(InputCheck(INPUT_VERB.CANCEL)){
        
        // if there is an actor selected
        if(noOneSelected == false){
            // then loop through selected array 
            for(aa=0;aa<sHeight;aa++){
                //and find blue actor with non-noone node
                if(selected[aa][1] != noone){
                    if(selected[aa][0].army = BLUEARMY){
                        //then redraw range as not selected, so it can be wiped
                        
                        scrMovementRange(selected[aa][1], false, selected[aa][0].move, selected[aa][0].attackRange,true);
                        selected[aa][1]= noone;
                        selected[aa][0].selected = false;
                        heroSelected = false;
                        selectedHero = noone;
                        heroIndex = pointer_null;
                    }
                }
            }
        }
        //else if no one is selected do nothing
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
    
    //Handles hovering and no button pushes.
    
    // If there is directional input
    if (inputX!=0||inputY!=0){
        
        //show_message(string(oRoomController.columns)+" : "+string(oRoomController.rows));
        gridX = clamp(gridX+inputX,0,oRoomController.columns-1);
        gridY = clamp(gridY+inputY,0,oRoomController.rows-1);
        
    }
    
    x= gridX * GRIDSIZE;
    y= gridY * GRIDSIZE;
    hoverNode = global.nodeMap[gridX,gridY];
    hoverNode.occupant = global.nodeMap[gridX,gridY].occupant;
    
    //Hovering treats red and blue army the same
    // If hovernode is occupied 
    if(hoverNode.occupant != noone){
         // And there are no selected actors, draw occupants range
        if(noOneSelected){
            scrMovementRange(hoverNode,false, hoverNode.occupant.move, hoverNode.occupant.attackRange,false);    
        }
        //else someone is selected
        else {
            //loop through selected array and find matching id
            //for(aa=0;aa<sHeight;aa++){
                ////if hovernode is occupied, by a selected actor
                //if(hoverNode.occupant == selected[aa][0]){
                    //hoverNode.occupant.selected=true
                    //scrMovementRange(hoverNode,true, hoverNode.occupant.move, hoverNode.occupant.attackRange,false);    
                //}
            //}
        } 
        //else the hovernode is occupied, but not by any selected actors so do nothing
    } 
    // If hovernode isn't occupied
    else{
        //And there are no selected actors wipe nodes
        if(selectedEnemies+heroSelected =0){
            scrWipeNodes(); 
        }
    }   
    
    inputX=0;
    inputY=0;
    selectorPaused = true;
    alarm[0] = alarmPause;
}

// If the player has manually selected all of the enemies, show range is flipped to true
// this is because it is essentially the same as show range and prevents needing a second button push.


if(selectedEnemies = activeEnemies){ 
    show_range = true;
}
