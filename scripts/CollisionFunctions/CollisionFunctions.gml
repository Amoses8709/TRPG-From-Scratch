//tileX- gridX, tileY- gridY, type- type of collision its checking for Env, Actor, All
function collision(tileX,tileY,type){
    //Tile
    var _tilemap =oRoomController.tile_id;
    
    if (tilemap_get(_tilemap,tileX,tileY)) return true;
        
    //Objects
    var _roomX = to_room(tileX+0.5);
    var _roomY = to_room(tileY+0.5);
    
    if(type="Env" || type == "All"){
        if (position_meeting(_roomX, _roomY, oCollision)) return true;
    }
    if(type="Actor" || type == "All"){    
        if (position_meeting(_roomX, _roomY, oActor)) return true;
    }    
    return false;

}