depth =-100;
gridX = 0;
gridY = 0;

sWidth = 2;
sHeight = oRoomController.maxEnemies+oRoomController.maxHeroes;

selected [sHeight-1][0] = noone; // Selected Actor
selected [sHeight-1][1] = noone; // Selected Node
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

selectorPaused = false;
hoverNode = noone;
show_range = false;
deselectedX = pointer_null;
deselectedY = pointer_null;

selectedEnemies = 0;
heroSelected = false;
selectedHero = noone;
deselectedEnemy = noone;
heroIndex = pointer_null;
activeEnemies = 0;

//moving = false;
alarmPause = 10;
