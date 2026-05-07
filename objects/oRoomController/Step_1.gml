//This means its the beginning of the hero turn
if(activeArmy==BLUEARMY && maxHeroes == array_length(heroChars)){
    roundCounter++;
    turnStart = true;
    
    with(oHeroChar){
       if(army == other.activeArmy){
           //Apply any conditions effects
       } 
    }
}
//This means its the beginning of the enemy turn
else if(activeArmy==REDARMY && maxEnemies == array_length(enemyChars)){
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
    if (instance_position(x + CENTER, y + CENTER, oActor)){
        //if there is an oActor at this node, it sets the node's occupant = the actor's id
        occupant= instance_position(x + CENTER, y + CENTER, oActor);
        occupant.gridX = gridX;
        occupant.gridY = gridY;
        if(occupant == oMainChar && other.turnStart && other.activeArmy==BLUEARMY){
            oSelector.selectedActor = self.occupant;
            oSelector.selectedNode = global.nodeMap[gridX,gridY];
        }
    }
    
}



