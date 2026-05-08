//Player army always goes first
activeArmy = BLUEARMY;

//Turn and round vars
roundCounter = 0;
turnMax =  0;
turnStart = false;

// Create an array for all enemies and all allies
heroChars = [];
enemyChars =[];

with(oActor){
    if(army==BLUEARMY){
        array_push(other.heroChars,id);
    }
    else{
        array_push(other.enemyChars,id);
    }
}
maxHeroes = array_length(heroChars);
maxEnemies = array_length(enemyChars);

//  Create MP grid the size of the room for pathing
tile_id  = layer_tilemap_get_id(("TilesCollision"));
columns  = tilemap_get_width(tile_id);
rows     = tilemap_get_height(tile_id);
grid_id  = mp_grid_create(0, 0, columns, rows, GRIDSIZE, GRIDSIZE);
move_path  = path_add();
show_range = false;

//  Create map array for tracking occupants, nodes, and neighbors
global.nodeMap = [];

// Populate mp_grid with the collision tilemap
for (var _c = 0; _c < columns; _c++){
	for (var _r = 0; _r < rows; _r++){
            mp_grid_add_cell(grid_id, _c, _r);
            
            global.nodeMap[_c,_r] = instance_create_layer(_c * GRIDSIZE, _r * GRIDSIZE, "Instances", oNode); 
            global.nodeMap[_c,_r].gridX = _c;
            global.nodeMap[_c,_r].gridY = _r;   
        }
}

// Adds collision objects to MP Grid
mp_grid_add_instances(grid_id, oCollision, false);

//Saves the mp grid as a global
global.grid_id = grid_id;


//Creates an instance of the selector
instance_create_layer(0,0,"Instances", oSelector);
