// Inherit the parent event
event_inherited();

army = BLUEARMY;

gridX = 0;
gridY = 0;

//move and action variables
move =6; 
actions =2;
canAct = false;

//variables related to pathing -------------------------------------------------------------
movePath = path_add();
path_set_kind(movePath,2); // 2 is straight lines and hits all points, 1 is wavy and doesn't full hit all points
path_set_closed(movePath, false); // If true would return to start point, potentially good for patrols

attackTarget = noone;

// Variables related to fx-------------------------------------
shake = 0;
shakeMag = 0;