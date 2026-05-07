function collision(tileX,tileY){
    //Tile
    var _tilemap =oRoomController.tile_id;
    
    if (tilemap_get(_tilemap,tileX,tileY)) return true;
        
    //Objects
    var _roomX = to_room(tileX+0.5);
    var _roomY = to_room(tileY+0.5);
    
    if (position_meeting(_roomX, _roomY, oCollision)) return true;
        
    if (position_meeting(_roomX, _roomY, oActor)) return true;
        
    return false;

}