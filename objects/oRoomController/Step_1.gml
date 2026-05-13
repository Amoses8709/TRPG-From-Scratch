if(roundCounter=0){
    with(oHeroChar){
        array_push(other.heroChars,id);
    }
    with(oEnemyChar){
       array_push(other.enemyChars,id);
       }
}

//This means its the beginning of the hero turn
if(activeArmy = BLUEARMY && maxHeroes == array_length(heroChars)){
    roundCounter++;
    turnStart = true;
    
    with(oHeroChar){
       if(army == other.activeArmy){
           //Apply any conditions effects
       } 
    }
}
//This means its the beginning of the enemy turn
else if(activeArmy=REDARMY && maxEnemies == array_length(enemyChars)){
    turnStart = true;
    with(oEnemyChar){
       if(army == other.activeArmy){
           //Apply any conditions effects
       } 
    }
}
//This is for any other part of hero or enemy turn
else{
    turnStart = false;
}
    
//Sorts out where everyone is
with(oNode){
    if (instance_position(x + GHALF, y + GHALF, oActor)){
        //if there is an oActor at this node, it sets the node's occupant = the actor's id
        
        occupant= instance_position(x + GHALF, y + GHALF, oActor);
        walkable = false
        occupant.gridX = gridX;
        occupant.gridY = gridY;
        //show_message(occupant.id == oMainChar.id);
        if(occupant.id == oMainChar.id && other.turnStart && other.activeArmy==BLUEARMY){
            
            oSelector.x = occupant.gridX * GRIDSIZE;
            oSelector.y = occupant.gridY * GRIDSIZE; 
            oSelector.gridX = occupant.gridX;
            oSelector.gridY = occupant.gridY;
            array_pop(other.heroChars);
        }
    }
    
}





