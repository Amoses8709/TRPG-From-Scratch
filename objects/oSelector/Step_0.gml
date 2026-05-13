activeEnemies = array_length(oRoomController.enemyChars);
if(selectedEnemies+selectedHero=0){
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
            scrMovementRange(hoverNode,false, hoverNode.occupant.move, hoverNode.occupant.attackRange);    
        }
        //else someone is selected
        else {
            //loop through selected array and find matching id
            //for(ii=0;ii<sHeight;ii++){
                ////if hovernode is occupied, by a selected actor
                //if(hoverNode.occupant == selected[ii][0]){
                    //hoverNode.occupant.selected=true
                    //scrMovementRange(hoverNode,true, hoverNode.occupant.move, hoverNode.occupant.attackRange);    
                //}
            //}
        } 
        //else the hovernode is occupied, but not by any selected actors so do nothing
    } 
    // If hovernode isn't occupied
    else{
        //And there are no selected actors wipe nodes
        if(selectedEnemies+selectedHero =0){
            scrWipeNodes(); 
        }
    }   
    
    inputX=0;
    inputY=0;
    selectorPaused = true;
    alarm[0] = alarmPause;
    
    // Selecting a non-empty hovered over node
    if((InputCheck(INPUT_VERB.ACCEPT) && global.nodeMap[gridX,gridY].occupant != noone)){
        
        // if there are no selected actors selected 
        if(selectedEnemies+selectedHero=0){
            //if the newly selected actor is an enemy
            if(global.nodeMap[gridX,gridY].occupant.army = REDARMY){
                selectedEnemies +=1;
            }
            //if the newly selected actor is a hero
            else{selectedHero = true;}
            
            // then loop through selected array and find matching id
            for(ii=0;ii<sHeight;ii++){
                if(global.nodeMap[gridX,gridY].occupant == selected[ii][0]){
                    global.nodeMap[gridX,gridY].occupant.selected = true;
                    selected[ii][1] = global.nodeMap[gridX,gridY]; // SelectedNode 
                    scrMovementRange(selected[ii][1], true, selected[ii][0].move, selected[ii][0].attackRange); 
                }
            }
             
        }
            
        //else there is at least 1 selected actor
        else {
            // if there is 1 or more enemies selected
            if(selectedEnemies > 0){
                //check all enemies in the array
                for(ii=0;ii<sHeight;ii++){
                    //Find the occupant of the selected node in selected array
                    if(selected[ii][0] = global.nodeMap[gridX,gridY].occupant){
                        //if this node isn't already selected, then select it
                        if(selected[ii][1]==noone){ 
                            global.nodeMap[gridX,gridY].occupant.selected = true;
                            selected[ii][1] = global.nodeMap[gridX,gridY];
                            selectedEnemies +=1;
                            //skip drawing it here, selected enemies will be drawn after
                            //scrMovementRange(selected[ii][1], true, selected[ii][0].move, selected[ii][0].attackRange);
                        }
                        //else the node is already selected and deselect it
                        else{
                            global.nodeMap[gridX,gridY].occupant.selected = false;
                            scrMovementRange(selected[ii][1], false, selected[ii][0].move, selected[ii][0].attackRange);
                            selected[ii][1] = noone;
                            selectedEnemies -=1;
                            show_range = false;
                        }
                    }
                }
                // This will redraw the range for any remaining enemies incase the removed enemy had overlapping ranges
                for(ii=0;ii<sHeight;ii++){
                    //if this node is still selected, then redraw
                    if(selected[ii][1]!=noone){ 
                        scrMovementRange(selected[ii][1], true, selected[ii][0].move, selected[ii][0].attackRange);
                    }
                }
            }
            if(selectedHero){
                //Show hero options, but don't unselect or add selections.
                //Player must cancel selcection before selection anything else.
            }
                
        }
             
        }
        selectorPaused = true;
        alarm[0] = alarmPause; 
    
    
    if(InputCheck(INPUT_VERB.CANCEL)){
        
        // if there is an actor selected
        if(noOneSelected = false){
            // then loop through selected array 
            for(ii=0;ii<sHeight;ii++){
                //and find blue actor with non-noone node
                if(selected[ii][1]!= noone){
                    if(selected[ii][0].army = BLUEARMY){
                        //then redraw range as not selected, so it can be wiped
                        scrMovementRange(selected[ii][1], false, selected[ii][0].move, selected[ii][0].attackRange);
                        selected[ii][1]= noone;
                        selected[ii][0].selected = false;
                        selectedHero = false;
                    }
                }
            }
        scrWipeNodes();    
        }
        //else if no one is selected do nothing
    }
}

// If the player has manually selected all of the enemies, show range is flipped to true
// this is because it is essentially the same as show range and prevents needing a second button push.


if(selectedEnemies = activeEnemies){ 
    show_range = true;
}
