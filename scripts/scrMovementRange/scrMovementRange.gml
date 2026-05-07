// Origin node- the node to pathfind from, units movement range, units remaining actions
function scrMovementRange(_start, _move, _actions){

    // Reset all node data
    scrWipeNodes();
    var _open, _closed;
    var _current, _neighbor;
    var _tempG, _range, _costMod;
    
    _range = _move * _actions;
    
    // Create data structures
    _open = ds_priority_create();
    _closed = ds_list_create();
    
    // Add starting node to open list
    ds_priority_add(_open, _start, _start.G);
    
    // While open queue is NOT empty repeate until ALL nodes have been looked at
    while (ds_priority_size(_open) > 0) {
        // remove node with the lowest G score from open
        _current = ds_priority_delete_min(_open);
        
        // Add that node to the closed list
        ds_list_add(_closed,_current);
        
        // step through all of current's neighbors
        for (ii = 0; ii < ds_list_size(_current.neighbors); ii++){
            // store current neighbor in neighbor variable
            _neighbor = ds_list_find_value(_current.neighbors, ii);
            
            // add neighbor to open list if it qualifies
            // neighbor is passable, neighbor has no occupant
            // neighbor projected G score is less than movement range
            // neighbor isn't ALREADY on the closed list
            
            //ds_list_find_index(closed, neighbor) returns 1 if neighbor /in list or -1 if not in list
            if(ds_list_find_index(_closed, _neighbor) < 0 && _neighbor.passable &&
                _neighbor.occupant == noone && _neighbor.cost +_current.G <= _range){
                
                // only calculate a new G score for neighbor if is hasn't been calculated
                if (ds_priority_find_priority(_open, _neighbor) == 0 || 
                    ds_priority_find_priority(_open, _neighbor)== undefined) {
                    _costMod = 1;
                    
                    // give neighbore the appropiate parent
                    _neighbor.parent = _current;
                    
                    // if node is diagonal, create appropriate costMod Probably delete-------------------
                    if (_neighbor.gridX != _current.gridX && _neighbor.gridY != _current.gridY){ 
                        _costMod = 1.5;
                    }
                    
                    // calculate G score of neighbor with costMod in place
                    _neighbor.G = _current.G + (_neighbor.cost * _costMod);
                    
                    // add neighbor to the open list so it can be checked out too
                    ds_priority_add(_open, _neighbor, _neighbor.G);
                    }
                
                // else if neighbor's score has already been calculated for the open list
                else {
                    // figure out if the neighbor's score would be LOWER if found from the current node
                    _costMod = 1;
                    
                    _tempG = _current.G + (_neighbor.cost * _costMod);
                    
                    // check if G score would be lower 
                    if (_tempG < _neighbor.G) {
                        _neighbor.parent = _current;
                        _neighbor.G = _tempG;
                        ds_priority_change_priority(_open, _neighbor, _neighbor.G);
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    //round down all G scores for movement calculations
    with (oNode) {G = floor(G);}
    
    //destroy open! SUPER IMPORTANT! NO LEAKS!!!
    ds_priority_destroy(_open);
    
    // color all the move nodes then destroy the closed list as well
    
    for (ii = 0; ii < ds_list_size(_closed); ii++) {
        _current = ds_list_find_value(_closed, ii);
        _current.moveNode = true;
        
        scrColorMoveNode(_current, _move, _actions);
    }
        
    _start.moveNode = false;
    
    //DESTROY CLOSED list
    ds_list_destroy(_closed);
    
    
    
    scrCreateButtons(_start.occupant);
    
    
    
    
    
    
    
}