// _start- the node to pathfind from,_selected - true if node is selected/false if just hovering 
// _move- the unit on the node's movement range, units remaining actions
function scrMovementRange(_start, _selected, _move,_atkRange){
     // Reset all node data
    scrWipeNodes();
    var _open, _closed; 
    var _current, _neighbor; 
    var _tempG, _wall;
    
    // Create data structures
    _open = ds_priority_create();   // _open - to be checked nodes in range
    _closed = [];                   // _closed already checked nodes
    
    // Add starting node to open list
    ds_priority_add(_open, _start, _start.G);
    
    // While open queue is NOT empty repeat until ALL nodes have been looked at
    while (ds_priority_size(_open) > 0) {
        
        // remove node with the lowest G score from open
        _current = ds_priority_delete_min(_open);
        
        if(_current.G = _move){
            _current.edge = true;
        }
        // Add that node to the closed list
        array_push(_closed,_current);
        
        // step through all of current's neighbors
        for (ii = 0; ii < array_length(_current.neighbors); ii++){
            // store current neighbor in neighbor variable
            _neighbor = array_get(_current.neighbors, ii);
            
            // add neighbor to open list if it qualifies
            // neighbor is walkable, neighbor has no occupant
            // neighbor projected G score is less than movement range
            // neighbor isn't ALREADY on the closed list
            
            //Array contains returns 1 if neighbor is in array or 0 if not in list
            
            //if(_atkRange =1){
           
            if(array_contains(_closed, _neighbor) = 0 && _neighbor.walkable &&
            _neighbor.occupant == noone && _neighbor.cost +_current.G <= _move + _atkRange){
            
                // only calculate a new G score for neighbor if is hasn't been calculated
                if (ds_priority_find_priority(_open, _neighbor) == 0 || 
                   ds_priority_find_priority(_open, _neighbor)== undefined) {
                   
                   // give neighbor the appropiate parent
                   _neighbor.parent = _current;
                   
                   // calculate G score of neighbor
                   _neighbor.G = _current.G + _neighbor.cost;
                   
                   // add neighbor to the open list so it can be checked out too
                   ds_priority_add(_open, _neighbor, _neighbor.G);
                   }
               
                // else if neighbor's score has already been calculated for the open list
                else {
                   // figure out if the neighbor's score would be LOWER if found from the current node
                   
                   _tempG = _current.G + _neighbor.cost;
                   
                   // check if G score would be lower 
                   if (_tempG < _neighbor.G) {
                       _neighbor.parent = _current;
                       _neighbor.G = _tempG;
                       ds_priority_change_priority(_open, _neighbor, _neighbor.G);
                       
                   }
                   
               }
            }
            
            if(!_neighbor.walkable && _neighbor != _start && _current.G <= _move ){
                _current.edge = true;
            }
        }
        
    }
    
    //destroy open! SUPER IMPORTANT! NO LEAKS!!!
    ds_priority_destroy(_open);
    
    // color all the move nodes
    for (ii = 0; ii < array_length(_closed); ii++) {
        
        _current = array_get(_closed, ii);
        //if(_current.walkable) {
            scrColorMoveNode(_current, _start.occupant.army, _selected, _move,_current.G);
        //}
    }
    // color all the hero attack nodes
    for (ii = 0; ii < array_length(_closed); ii++) {
        var _edgeNeighborX = 0;
        var _edgeNeighborY = 0;
        var _edgeNeighbor = noone;
        _current = array_get(_closed, ii);
        if(_current.edge){
            for(jj = -_atkRange; jj<= _atkRange; jj++){
                for(kk = -_atkRange; kk <= _atkRange; kk++){
                    if(abs(jj)+abs(kk)>_atkRange){
                        continue;
                    }
                    
                    _edgeNeighborX = clamp(_current.gridX+jj,0,oRoomController.columns-1);
                    _edgeNeighborY = clamp(_current.gridY+kk,0,oRoomController.rows-1);
                    _edgeNeighbor = global.nodeMap[_edgeNeighborX,_edgeNeighborY];
                    if(!_selected == true){_edgeNeighbor.saveAttack = false;}
                    if(_edgeNeighbor.sprite_index =sDefaultNode && _edgeNeighbor.walkable){ 
                        _edgeNeighbor.sprite_index = sAttackNode;
                        if(_selected == true){_edgeNeighbor.saveAttack = true;} 
                        else{_edgeNeighbor.saveAttack = false;}
                    }
                       
                }
            
            }
            
        }

    }    

    
    //scrCreateButtons(_start.occupant);

}

//node ID to color, Actor's army, is Actor selected, Actor's move, Node's G score. 
// If G score is greater than move, but still in the array that means its in the attack range
function scrColorMoveNode(_node, _army,_selected, _move, _cost){
    if(_army != REDARMY || (_army = REDARMY && !_selected)){
        if(_cost > _move && _node.walkable){
            _node.sprite_index = sAttackNode;
            _node.saveAttack = false
        }
        else{
            _node.sprite_index = sMoveNode;
            _node.saveAttack = false;
        } 
    } 
    else{
        _node.sprite_index = sAttackNode;
        // Sets the node to not get wiped by wipe nodes
        _node.saveAttack = true;
        _node.debug = true;
    }
}

