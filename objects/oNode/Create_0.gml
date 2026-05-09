neighbors = [];

color = c_white;

occupant = noone;
passable = true;
gridX = 0;
gridY = 0;
selected = false;
debug= false;


//path finding variables ==========================================================
parent = noone;
G = 0;
moveNode = false;
attackNode = false;
saveAttack = false;
cost = 1;
sprite = sDefaultNode;