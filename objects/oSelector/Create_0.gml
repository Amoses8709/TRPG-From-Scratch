depth =-100;
gridX = 0;
gridY = 0;

sWidth = 2;
sHeight = oRoomController.maxEnemies+oRoomController.maxHeroes;

selected [sHeight-1][0] = noone;
selected [sHeight-1][1] = noone;
var jj = 0;
with(oEnemyChar){
    oSelector.selected[jj][0] = id;
    oSelector.selected[jj][1] = noone; //global.nodeMap[selected[jj][0].gridX,selected[jj][0].gridY];
    jj+=1;
}
with(oHeroChar){
    oSelector.selected[jj][0] = id;
    oSelector.selected[jj][1] = noone; //global.nodeMap[selected[jj][0].gridX,selected[jj][0].gridY];
    jj+=1;
}

//for( jj = 0; jj < oRoomController.maxEnemies; jj++){
    //selected[jj][0] = instance_find(oEnemyChar,jj);
    //selected[jj][1] = global.nodeMap[selected[jj][0].gridX,selected[jj][0].gridY];
//}
//for ( jj= oRoomController.maxEnemies; jj < sHeight-1; jj++){
    //selected[jj][0] = instance_find(oHeroChar,jj);
    //selected[jj][1] = global.nodeMap[selected[jj][0].gridX,selected[jj][0].gridY];
//}


selectorPaused = false;
hoverNode = noone;
noOneSelected = true;
show_range = false;

selectedEnemies = 0;
selectedHero = false;
activeEnemies = 0;

//moving = false;
alarmPause = 10
