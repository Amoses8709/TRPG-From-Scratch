

// Create Camera
var _w = global.res.width;
var _h = global.res.height;
camera = camera_create_view(0,0,_w,_h,0, oSelector,-1,-1,_w/2,_h/2);

// Enable views and make view 0 visible
view_enabled = true;
view_visible[0] = true;

// Assign camera to view 0
view_set_camera(0, camera);


//Player army always goes first
activeArmy = BLUEARMY;

//Turn and round vars
roundCounter = 0;
turnMax =  0;
turnStart = false;


//  Create MP grid the size of the room for pathing
tile_id  = layer_tilemap_get_id(("TilesCollision"));
columns  = tilemap_get_width(tile_id);
rows     = tilemap_get_height(tile_id);
grid_id  = mp_grid_create(0, 0, columns, rows, GRIDSIZE, GRIDSIZE);
move_path  = path_add();


//  Create map array for tracking occupants, nodes, and neighbors
global.nodeMap = [];

// Populate mp_grid with the collision tilemap
for (var _c = 0; _c < columns; _c++){
	for (var _r = 0; _r < rows; _r++){
        mp_grid_add_cell(grid_id, _c, _r);
        
        global.nodeMap[_c,_r] = instance_create_layer(_c * GRIDSIZE, _r * GRIDSIZE, "Instances", oNode); 
        global.nodeMap[_c,_r].gridX = _c;
        global.nodeMap[_c,_r].gridY = _r;   
        if(collision(_c,_r,"Env")){
             global.nodeMap[_c,_r].noObject = false;
        }
    }
}

// Adds collision objects to MP Grid
mp_grid_add_instances(grid_id, oCollision, false);

//Saves the mp grid as a global
global.grid_id = grid_id;

// Populate neighbors array
for (xx = 0; xx < columns; xx ++){
    for (yy=0;yy<rows;yy++){
        node = global.nodeMap[xx,yy];
        
        // add left neighbor
        if (xx>0){
            array_push(node.neighbors, global.nodeMap[xx-1,yy]);
        }
        
        //add right neighbor
        if (xx<columns-1){
            array_push(node.neighbors, global.nodeMap[xx+1,yy]);
        }
        
        // add top neighbor
        if (yy>0){
            array_push(node.neighbors, global.nodeMap[xx,yy-1]);
        }
        
        // add bottom neighbor
        if (yy<rows-1){
            array_push(node.neighbors, global.nodeMap[xx,yy+1]);
        }
    }
}

// Create an array for all enemies and all allies
heroChars = [];
enemyChars =[];

maxHeroes = instance_number(oHeroChar);
maxEnemies = instance_number(oEnemyChar);

//Creates an instance of the selector
instance_create_layer(0,0,"Instances", oSelector);