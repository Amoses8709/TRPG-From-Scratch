neighbors = ds_list_create();

color = c_white;

occupant = noone;
passable = true;
gridX = 0;
gridY = 0;

//path finding variables ==========================================================
parent = noone;
G = 0;
moveNode = false;
attackNode = false;
cost = 1;
sprite = sDefaultNode;