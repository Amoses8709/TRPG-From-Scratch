// _start- the node to pathfind from, _selected - true if node is selected/false if just hovering 
// _move- the unit on the node's movement range, units remaining actions
// _allAtk - is this being used to show all active enemy attack ranges
function scrMovementRange(_start, _selected, _move,_atkRange,_allAtk){
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
        
        //if node was added to open, then it is a viable move node
        _current.moveNode = true;
        //if the current cost = move its an edge node
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
           
            if(array_contains(_closed, _neighbor) = 0 && _neighbor.walkable &&
            _neighbor.occupant == noone && _neighbor.cost +_current.G <= _move){// + _atkRange){
            
                // only calculate a new G score for neighbor if is hasn't been calculated
                if (ds_priority_find_priority(_open, _neighbor) == 0 ||  ds_priority_find_priority(_open, _neighbor)== undefined) {
                   
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
            
            // if the neighor isn't walkable, and isn't the start node and the G is less than or equal to move
            // then this is an edge tile for the walkable range
            if(!_neighbor.walkable && _neighbor != _start && _current.G <= _move ){
                _current.edge = true;
            }
        }
        
    }
    
    //destroy open! SUPER IMPORTANT! NO LEAKS!!!
    ds_priority_destroy(_open);
    
    
    // color all the attack nodes
    for (ii = 0; ii < array_length(_closed); ii++) {
        var _edgeNeighborX = 0;
        var _edgeNeighborY = 0;
        var _edgeNeighbor = noone;
        _current = array_get(_closed, ii);
        if(_current.edge){
            for(jj = -_atkRange; jj<= _atkRange; jj++){
                for(kk = -_atkRange; kk <= _atkRange; kk++){
                    
                    _edgeNeighborX = clamp(_current.gridX+jj,0,oRoomController.columns-1);
                    _edgeNeighborY = clamp(_current.gridY+kk,0,oRoomController.rows-1);
                    _edgeNeighbor = global.nodeMap[_edgeNeighborX,_edgeNeighborY];
                    //if the abs value of offset > than attack range or the node is a move node
                    //then we skip making it an attack node 
                    if(!(abs(jj)+abs(kk)>_atkRange || _edgeNeighbor.moveNode)){
                        if(_edgeNeighborX=12 && _edgeNeighborY = 8){
                            var _thing =1;
                        }
                        // If the node isn't selected then don't save
                        if(_edgeNeighbor.walkable){
                            if(!_selected == true){
                                _edgeNeighbor.saveNode = false;
                                if(_allAtk){
                                    global.enemyAllAttack[_edgeNeighbor.gridX,_edgeNeighbor.gridY].sprite_index = sAllEnemyAttackNode;
                                    global.enemyAllAttack[_edgeNeighborX,_edgeNeighborY].saveNode = true;
                                }
                                else{
                                    _edgeNeighbor.sprite_dindex = sAttackNode;
                                    _edgeNeighbor.saveNode = false;
                                }
                            }
                            else{
                                if(_allAtk){
                                    global.enemyAllAttack[_edgeNeighborX,_edgeNeighborY].sprite_index = sAllEnemyAttackNode;
                                    global.enemyAllAttack[_edgeNeighborX,_edgeNeighborY].saveNode = true;
                                }
                                else{ 
                                   _edgeNeighbor.sprite_index = sAttackNode;
                                   _edgeNeighbor.saveNode = true;
                                }
                            } 
                        }
                    }
                }
            }
        }
    }    

    // color all the move nodes
    for (ii = 0; ii < array_length(_closed); ii++) {
        
        _current = array_get(_closed, ii);
        scrColorMoveNode(_current, _start.occupant.army, _selected, _move,_current.G,_allAtk);
    }
    
    //scrCreateButtons(_start.occupant);

}

//node ID to color, Actor's army, is Actor selected, Actor's move, Node's G score. 
// If G score is greater than move, but still in the array that means its in the attack range
function scrColorMoveNode(_node, _army,_selected, _move, _cost,_allAtk){
    //if show range was turned on
    var _tempGridX = _node.gridX;
    var _tempGridY = _node.gridY;
    if(_tempGridX=12 && _tempGridY=8){
        var thing =1;
    }
    if(_allAtk && oSelector.show_range){ 
        global.enemyAllAttack[_tempGridX,_tempGridY].sprite_index = sAllEnemyAttackNode;
        global.enemyAllAttack[_tempGridX,_tempGridY].saveNode = true;
    }
    else if(_allAtk && !oSelector.show_range){
        global.enemyAllAttack[_tempGridX,_tempGridY].sprite_index = sDefaultNode;
        global.enemyAllAttack[_tempGridX,_tempGridY].saveNode = false;
    }
    //Else not invovling show range
    //Blue army never saves attack nodes
    else{
        if(_army = BLUEARMY){ 
            if(_node.moveNode){
                _node.sprite_index = sMoveNode;
                _node.saveNode = false;
            }
            else if(_node.passable){
                _node.sprite_index = sAttackNode;
                _node.saveNode = false;
            }
        } 
            //If red army
        else{
            if(_selected){
                _node.sprite_index = sAttackNode;
                // Sets the node to not get wiped by wipe nodes
                _node.saveNode = true;
               
                  
            } 
            else{
                if(_cost > _move && _node.walkable){
                    _node.sprite_index = sAttackNode;
                    _node.saveNode = false
                }
                else{
                    _node.sprite_index = sMoveNode;
                    _node.saveNode = false;
                } 
            }
        }
    }
}
