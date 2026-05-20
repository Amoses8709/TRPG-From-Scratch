activeEnemies = array_length(oRoomController.enemyChars);

if(!selectorPaused){
    if(heroMoving){
        if(InputCheck(INPUT_VERB.CANCEL)){
            scrHeroCancelMove();
            scrRedrawAllRanges(noone);
        }
        exit;
    }
    if(InputCheck(INPUT_VERB.PAUSE)){
        // Main menu tbd
        selectorPaused = true;
        alarm[0] = alarmPause;  
    }
            
    // Xbox Y, PS5 triangle. switch X, PC shift - Toggles showing all enemy ranges
    if(InputCheck(INPUT_VERB.SPECIAL)){
        show_range = !show_range;
        
        if(show_range) {
            selectedEnemies = activeEnemies;
        }
        else{
            selectedEnemies=0;
        }
        
        if(show_range) {
            with(oNode){ 
                if(occupant != noone){
                    for(aa=0;aa<other.sHeight;aa++){
                        if(other.selected[aa][0] = occupant && occupant.army = REDARMY){
                            other.selected[aa][0].selected = true;
                            other.selected[aa][1] = self;
                        }
                    }
                }
            }
            scrRedrawAllRanges(noone);
        }
        else {
            with(oNode){ 
                if(occupant != noone){
                    for(aa=0;aa<other.sHeight;aa++){
                        if(other.selected[aa][0] = occupant && occupant.army = REDARMY){
                            other.selected[aa][0].selected = false;
                            other.selected[aa][1] = noone;
                        }
                    }
                }
            }
            scrWipeNodes(true);
        }
        
        selectorPaused = true;
        alarm[0] = alarmPause; 
        exit;   
    }
         
    // Hero: confirm move to highlighted tile
    if(InputCheck(INPUT_VERB.ACCEPT) && heroSelected){
        var _targetNode = global.nodeMap[gridX, gridY];
        if(scrIsValidHeroMoveDest(gridX, gridY, selected[heroIndex][1])
            && (gridX != selectedHero.gridX || gridY != selectedHero.gridY)){
            scrHeroCommitMove(_targetNode);
            selectorPaused = true;
            alarm[0] = alarmPause;
            exit;
        }
        selectorPaused = true;
        alarm[0] = alarmPause;
    }
    // Selecting a non-empty hovered over node
    else if((InputCheck(INPUT_VERB.ACCEPT) && global.nodeMap[gridX,gridY].occupant != noone)){
        
        // if there are no selected actors selected 
        if(selectedEnemies+heroSelected=0){
            // loop through selected array and find matching id
            for(aa=0;aa<sHeight;aa++){
                if(global.nodeMap[gridX,gridY].occupant == selected[aa][0]){
                    global.nodeMap[gridX,gridY].occupant.selected = true;
                    selected[aa][1] = global.nodeMap[gridX,gridY]; // SelectedNode
                    selected[aa][0].selected = true; 
                    //if the newly selected actor is a hero
                    if(selected[aa][0].army == BLUEARMY){
                        scrSelectorBeginHero(selected[aa][0], aa, global.nodeMap[gridX, gridY]);
                    }
                    //if the newly selected actor is an enemy
                    else {
                        selectedEnemies +=1;
                        if(selectedEnemies == activeEnemies){
                            show_range = true;
                        }
                        
                    }
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
                    
                    // This is a big complicated process to unselect a selected enemy 
                    // and then redraw the rest of the enemy ranges
                    
                    
                    
                    //it checks if the occupant is an already selected enemy
                    for(aa=0;aa<sHeight;aa++){
                        //finds the actor in the array the occupant matches and deselects then exits the for loop
                        if(selected[aa][0] = global.nodeMap[gridX,gridY].occupant){
                            // if the node is already selected, then deselect it
                            if(selected[aa][1]!=noone){
                                deselectedEnemy = global.nodeMap[gridX,gridY].occupant;
                                global.nodeMap[gridX,gridY].occupant.selected = false;
                                if(global.nodeMap[gridX,gridY].occupant.army = REDARMY){
                                    selectedEnemies -=1;
                                    show_range = false; 
                                }
                                selected[aa][1] = noone;
                                scrWipeNodes(true);
                                //Stops looking for the selected actor to deselect
                                break;
                            }
                            //This doesn't deal with finding selected enemies that are the occupant
                            //that will be dealt with in the following loop
                            
                        }
                    } 
                    
                    
                    // loops through all of the remaining selected enemies and redraws range
                    // do this to fix any deleted overlap from the deselected enemy
                    // this will also do the selecting for if the occupant wasn't originally selected
                    for(aa=0;aa<sHeight;aa++){
                        // if noone was deselected, then look for who to select
                        if(deselectedEnemy = noone){
                            //if occupant matches the actor for the array
                            if(selected[aa][0] = global.nodeMap[gridX,gridY].occupant){
                                //and the node isn't already selected, then select it
                                if(selected[aa][1]==noone){ 
                                    global.nodeMap[gridX,gridY].occupant.selected = true;
                                    selected[aa][1] = global.nodeMap[gridX,gridY];
                                    
                                    //if the newly selected actor is red army
                                    if(selected[aa][0].army = REDARMY){
                                        selectedEnemies +=1; 
                                        if(selectedEnemies == activeEnemies){
                                            show_range = true;
                                        }
                                    }
                                    //if the newly selected actor is blue army
                                    else{
                                        scrSelectorBeginHero(selected[aa][0], aa, global.nodeMap[gridX, gridY]);
                                    }
                                }
                            }
                            
                        }
                        
                        // If the occupant isn't the actor who was just deselected
                        if(global.nodeMap[gridX,gridY].occupant != deselectedEnemy){
                            // If the occupant matches the selected Actor
                            if(global.nodeMap[gridX,gridY].occupant == selected[aa][0]){
                                //and the node isn't already selected, then select it
                                if(selected[aa][1]==noone){ 
                                    global.nodeMap[gridX,gridY].occupant.selected = true;
                                    selected[aa][1] = global.nodeMap[gridX,gridY];
                                    
                                    //if the newly selected actor is red army
                                    if(selected[aa][0].army = REDARMY){
                                        selectedEnemies +=1;
                                        if(selectedEnemies == activeEnemies){
                                            show_range = true;
                                        }
                                    }
                                    //if the newly selected actor is blue army
                                    else{
                                        scrSelectorBeginHero(selected[aa][0], aa, global.nodeMap[gridX, gridY]);
                                    }
                                }
                               //for selected actors who aren't the occupant
                               else if(selected[aa][1] != noone){
                                   // ranges redrawn at end of step via scrRedrawAllRanges
                               }
                            }
                        }

                    }
                }
            }
        }
             
        }
        selectorPaused = true;
        alarm[0] = alarmPause; 
    
    
    if(InputCheck(INPUT_VERB.CANCEL)){
        
        // if there is a hero selected
        if(heroSelected){
            if(heroMoveCommitted){
                scrHeroUndoMove();
                scrRedrawAllRanges(noone);
            }
            else{
                selected[heroIndex][0].selected = false;
                selected[heroIndex][1] = noone;
                heroSelected = false;
                selectedHero = noone;
                heroIndex = pointer_null;
                scrRedrawAllRanges(noone);
            }
        }
        //else if no one is selected do nothing
        selectorPaused = true;
        alarm[0] = alarmPause; 
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
        //selectorPaused = true;
        //alarm[0] = alarmPause; 
    }
    
    //Handles hovering
    
    // If there is directional input
    if (inputX!=0||inputY!=0){
        gridX = clamp(gridX + inputX, 0, oRoomController.columns - 1);
        gridY = clamp(gridY + inputY, 0, oRoomController.rows - 1);
    }
    
    x= gridX * GRIDSIZE;
    y= gridY * GRIDSIZE;
    hoverNode = global.nodeMap[gridX,gridY];
    hoverNode.occupant = global.nodeMap[gridX,gridY].occupant;
    
    
    
    // Enemies drawn first, hero (green) drawn on top when selected
    scrRedrawAllRanges(hoverNode);
    
    inputX=0;
    inputY=0;
}

// If the player has manually selected all of the enemies, show range is flipped to true
// this is because it is essentially the same as show range and prevents needing a second button push.


if(selectedEnemies == activeEnemies){ 
    show_range = true;
}
deselectedEnemy = noone;