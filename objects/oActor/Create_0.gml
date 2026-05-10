army = BLUEARMY;
name = "John Doe";

gridX = 0;
gridY = 0;

//move and action variables
move =4; 
actions =1;
canAct = false;
attackRange = 3;

//variables related to pathing -------------------------------------------------------------
movePath = path_add();
path_set_kind(movePath,2); // 2 is straight lines and hits all points, 1 is wavy and doesn't full hit all points
path_set_closed(movePath, false); // If true would return to start point, potentially good for patrols

attackTarget = noone;

// Variables related to fx-------------------------------------
shake = 0;
shakeMag = 0;

//Actor states
states = {
    idle: {
        right:sMainCharIdle
    },
    walk: {
        right:sMainCharWalkRight
    }
}

state = states.idle;