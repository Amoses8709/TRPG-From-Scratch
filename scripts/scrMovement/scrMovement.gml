// _start- the node to pathfind from,_selected - true if node is selected/false if just hovering 
// _move- the unit on the node's movement range, units remaining actions
// _cancel - is this call for the cancel button?
function scrMovementRange(_start, _selected, _move,_atkRange,_cancel){
     // Reset node data; full clear only when cancelling (layered draws use scrRedrawAllRanges)
    var _army = _start.occupant.army;
    scrWipeNodes(_cancel);
    var _open, _closed; 
    var _current, _neighbor; 
    var _tempG, _wall, _walkable;

    // Create data structures
    _open = ds_priority_create();   // _open - to be checked nodes in range
    _closed = [];                   // _closed already checked nodes
    
    // Starting node must be G=0 (stale G on saveNode tiles broke range after layered draws)
    _start.G = 0;
    _start.parent = noone;
    ds_priority_add(_open, _start, 0);
    
    // While open queue is NOT empty repeat until ALL nodes have been looked at
    while (ds_priority_size(_open) > 0) {
        
        // remove node with the lowest G score from open
        _current = ds_priority_delete_min(_open);
        
        // Valid destinations: empty tiles and the unit's start tile (allies are pass-through only)
        _current.moveNode = (_current == _start || _current.occupant == noone);
        if(_current.G == _move){
            _current.edge = true;
        }
        // Add that node to the closed list
        array_push(_closed,_current);
        
        // step through all of current's neighbors
        for (ii = 0; ii < array_length(_current.neighbors); ii++){
            // store current neighbor in neighbor variable
            _neighbor = array_get(_current.neighbors, ii);

            // add neighbor to open list if it qualifies\
            // neighbor isn't ALREADY on the closed list
            // neighbor projected G score is less than movement range
            // Walkable: open terrain, empty tile, or same-army ally (pass through; cannot stop on ally)
            // Array contains returns 1 if neighbor is in array or 0 if not in list
            _walkable = _neighbor.noObject && (
                _neighbor.occupant == noone
                || _neighbor.occupant.army == _army
            );
            if(!array_contains(_closed, _neighbor) && _neighbor.cost + _current.G <= _move && _walkable){
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
             
            if(!_neighbor.noObject && _neighbor != _start && _current.G <= _move ){
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
        //if the current node is an edge node
        if(_current.edge){
            //check all possible ranges within the attack range
            for(jj = -_atkRange; jj<= _atkRange; jj++){
                for(kk = -_atkRange; kk <= _atkRange; kk++){
                    
                    _edgeNeighborX = clamp(_current.gridX+jj,0,oRoomController.columns-1);
                    _edgeNeighborY = clamp(_current.gridY+kk,0,oRoomController.rows-1);
                    _edgeNeighbor = global.nodeMap[_edgeNeighborX,_edgeNeighborY];
                    //if(_edgeNeighbor == global.nodeMap[3,6]){
                        //var _thing =1;
                    //}
                    //we make it an attack node 
                    //if the abs value of offset > than attack range 
                    if(abs(jj)+abs(kk) <= _atkRange){
                        //Excluding nodes that are move nodes
                        if(!array_contains(_closed, _edgeNeighbor)){
                            //if(_edgeNeighbor == global.nodeMap[3,6]){
                                //var _thing =1;
                            //}
                            //if clearing for the cancel
                            if(_cancel){
                               _edgeNeighbor.saveNode = false;
                               _edgeNeighbor.sprite_index = sDefaultNode;
                            }
                            else{
                                //only color if the neighbor is noObject
                                if(_edgeNeighbor.noObject || _edgeNeighbor.occupant != noone){
                                    // If the node isn't selected then don't save
                                    if(!_selected){
                                        _edgeNeighbor.saveNode = false;
                                        _edgeNeighbor.sprite_index = sAttackNode;
                                    }
                                    // else the node is selected then we save it
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
    }    

    // color all the move nodes (skip ally pass-through tiles)
    for (ii = 0; ii < array_length(_closed); ii++) {
        
        _current = array_get(_closed, ii);
        if (_current.moveNode) {
            scrColorMoveNode(_current, _army, _selected, _move,_current.G,_cancel);
        }
    }
    
    //scrCreateButtons(_start.occupant);

}

/// Redraws movement/attack overlays: selected enemies first, hero on top when active.
/// @param {Struct} _hoverNode  Node under cursor (noone to skip hover layer)
function scrRedrawAllRanges(_hoverNode) {
    scrWipeNodes(true);
    
    // Only selected enemies (not every enemy on the field)
    for (var aa = 0; aa < oSelector.sHeight; aa++) {
        if (oSelector.selected[aa][1] != noone && oSelector.selected[aa][0].army == REDARMY) {
            scrMovementRange(
                oSelector.selected[aa][1],
                oSelector.selected[aa][0].selected,
                oSelector.selected[aa][0].move,
                oSelector.selected[aa][0].attackRange,
                false
            );
        }
    }
    
    // Hero move + attack range drawn last so it wins on overlapping tiles
    if (oSelector.heroSelected && oSelector.selected[oSelector.heroIndex][1] != noone) {
        scrMovementRange(
            oSelector.selected[oSelector.heroIndex][1],
            false,
            oSelector.selectedHero.move,
            oSelector.selectedHero.attackRange,
            false
        );
    }
    else {
        for (var bb = 0; bb < oSelector.sHeight; bb++) {
            if (oSelector.selected[bb][1] != noone && oSelector.selected[bb][0].army == BLUEARMY) {
                scrMovementRange(
                    oSelector.selected[bb][1],
                    false,
                    oSelector.selected[bb][0].move,
                    oSelector.selected[bb][0].attackRange,
                    false
                );
            }
        }
        if (_hoverNode != noone && _hoverNode.occupant != noone) {
            scrMovementRange(
                _hoverNode,
                false,
                _hoverNode.occupant.move,
                _hoverNode.occupant.attackRange,
                false
            );
        }
    }
}

//node ID to color, Actor's army, is Actor selected, Actor's move, Node's G score. 
// If G score is greater than move, but still in the array that means its in the attack range
function scrColorMoveNode(_node, _army,_selected, _move, _cost,_cancel){
    if(_node == global.nodeMap[3,6]){
                        var _thing =1;
                    }
    // if cancelling clear stuff
    if(_cancel){
        _node.saveNode = false;
        _node.sprite_index = sDefaultNode;
    }
    else{
        //Blue army never saves attack nodes
        if(_army = BLUEARMY){ 
          if(_node.moveNode){
              _node.sprite_index = sMoveNode;
          }
          else if(_node.passable){
              _node.sprite_index = sAttackNode;
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
                if(_cost > _move && _node.noObject){
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

