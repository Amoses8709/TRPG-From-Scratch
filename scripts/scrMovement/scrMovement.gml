// _start- the node to pathfind from,_selected - true if node is selected/false if just hovering 
// _move- the unit on the node's movement range, units remaining actions
// _cancel - is this call for the cancel button?
function scrMovementRange(_start, _selected, _move,_atkRange,_cancel, _actor = undefined){
     // Reset node data; full clear only when cancelling (layered draws use scrRedrawAllRanges)
    var _unit = _actor;
    if (is_undefined(_unit) || !instance_exists(_unit)) {
        _unit = _start.occupant;
    }
    if (!instance_exists(_unit)) {
        return;
    }
    var _army = _unit.army;
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
        
        // Valid destinations: empty tiles and start tile; allies are pass-through (shown green, not stoppable)
        _current.moveNode = (_current == _start || _current.occupant == noone);
        _current.allyPassNode = (_current.occupant != noone && _current.occupant.army == _army && _current != _start);
        if(_current.G == _move){
            _current.edge = true;
        }
        // Add that node to the closed list
        array_push(_closed,_current);
        
        // step through all of current's neighbors
        for (ii = 0; ii < array_length(_current.neighbors); ii++){
            // store current neighbor in neighbor variable
            _neighbor = array_get(_current.neighbors, ii);

            // Walls block; empty or same-army ally tiles can be entered (allies are pass-through only)
            if (!_neighbor.noObject) {
                if (_neighbor != _start && _current.G <= _move) {
                    _current.edge = true;
                }
                continue;
            }
            if (_neighbor.occupant != noone && _neighbor.occupant.army != _army) {
                continue;
            }

            _tempG = _current.G + _neighbor.cost;

            if (!array_contains(_closed, _neighbor) && _tempG <= _move) {
                var _openPri = ds_priority_find_priority(_open, _neighbor);
                if (_openPri == undefined) {
                    _neighbor.parent = _current;
                    _neighbor.G = _tempG;
                    ds_priority_add(_open, _neighbor, _neighbor.G);
                }
                else if (_tempG < _neighbor.G) {
                    _neighbor.parent = _current;
                    _neighbor.G = _tempG;
                    ds_priority_change_priority(_open, _neighbor, _neighbor.G);
                }
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

    // color move tiles and ally pass-through tiles
    for (ii = 0; ii < array_length(_closed); ii++) {
        
        _current = array_get(_closed, ii);
        if (_current.moveNode || _current.allyPassNode) {
            scrColorMoveNode(_current, _army, _selected, _move,_current.G,_cancel);
        }
    }
    
    //scrCreateButtons(_start.occupant);

}

/// Redraws movement/attack overlays: selected enemies first, hero on top when active.
/// @param {Struct} _hoverNode  Node under cursor (noone to skip hover layer)
function scrRedrawAllRanges(_hoverNode) {
    if (oSelector.heroMoving) {
        return;
    }
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
    if (oSelector.heroSelected && oSelector.selectedHero != noone
        && oSelector.selected[oSelector.heroIndex][1] != noone) {
        scrMovementRange(
            oSelector.selected[oSelector.heroIndex][1],
            false,
            oSelector.selectedHero.move,
            oSelector.selectedHero.attackRange,
            false,
            oSelector.selectedHero
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

/// True if the hero may end their move on this tile (within range, not on an ally).
function scrIsValidHeroMoveDest(_gx, _gy, _startNode) {
    var _node = global.nodeMap[_gx, _gy];
    if (_node == _startNode){
        return true;
    }
 
    return _node.moveNode;
}

function scrSelectorBeginHero(_hero, _index, _node) {
    with (oSelector) {
        selectedHero = _hero;
        heroIndex = _index;
        heroSelected = true;
        _hero.selected = true;
        heroOriginGridX = _hero.gridX;
        heroOriginGridY = _hero.gridY;
        heroMoveCommitted = false;
        if (_node != noone) {
            selected[_index][1] = _node;
        }
    }
}

/// Returns node list from BFS parent links (start -> end), or incomplete list if unreachable.
function scrGetHeroPathNodes(_startNode, _endNode) {
    var _nodes = [];
    var _n = _endNode;
    while (_n != noone) {
        array_insert(_nodes, 0, _n);
        if (_n == _startNode) {
            return _nodes;
        }
        _n = _n.parent;
    }
    return _nodes;
}

/// Builds a path resource from BFS parent links (start -> end).
function scrBuildHeroMovePath(_hero, _startNode, _endNode) {
    var _nodes = scrGetHeroPathNodes(_startNode, _endNode);
    path_clear_points(_hero.movePath);
    if (array_length(_nodes) < 2) {
        path_add_point(_hero.movePath, _startNode.gridX * GRIDSIZE, _startNode.gridY * GRIDSIZE, 100);
        path_add_point(_hero.movePath, _endNode.gridX * GRIDSIZE, _endNode.gridY * GRIDSIZE, 100);
    }
    else {
        for (var ii = 0; ii < array_length(_nodes); ii++) {
            var _node = _nodes[ii];
            path_add_point(_hero.movePath, _node.gridX * GRIDSIZE, _node.gridY * GRIDSIZE, 100);
        }
    }
    return path_get_number(_hero.movePath) > 1;
}

function scrHeroCommitMove(_targetNode) {
    with (oSelector) {
        var _hero = selectedHero;
        var _startNode = selected[heroIndex][1];
        if (_targetNode == _startNode) {
            return;
        }
        if (!scrBuildHeroMovePath(_hero, _startNode, _targetNode)) {
            return;
        }
        heroMoveStartNode = _startNode;
        heroMoveTargetNode = _targetNode;
        heroMoving = true;
        _startNode.occupant = noone;
        with (_hero) {
            isMoving = true;
            sprite_index = states.walk.right;
            path_start(movePath, moveSpeed, path_action_stop, false);
        }
    }
}

function scrHeroMoveFinish(_hero) {
    if (!instance_exists(oSelector) || oSelector.selectedHero != _hero) {
        return;
    }
    with (oSelector) {
        if (!heroMoving || heroMoveTargetNode == noone) {
            return;
        }
        var _target = heroMoveTargetNode;
        _target.occupant = _hero;
        _hero.gridX = _target.gridX;
        _hero.gridY = _target.gridY;
        _hero.x = _target.gridX * GRIDSIZE;
        _hero.y = _target.gridY * GRIDSIZE;
        _hero.sprite_index = _hero.states.idle.right;
        selected[heroIndex][1] = _target;
        heroMoveCommitted = true;
        heroMoving = false;
        heroMoveTargetNode = noone;
        heroMoveStartNode = noone;
        gridX = _target.gridX;
        gridY = _target.gridY;
        x = _hero.x;
        y = _hero.y;
        selectorPaused = false;
        scrRedrawAllRanges(noone);
    }
}

function scrHeroCancelMove() {
    with (oSelector) {
        if (!heroMoving) {
            return;
        }
        var _hero = selectedHero;
        with (_hero) {
            path_end();
            isMoving = false;
            sprite_index = states.idle.right;
        }
        if (heroMoveStartNode != noone) {
            heroMoveStartNode.occupant = _hero;
        }
        if (heroMoveTargetNode != noone && heroMoveTargetNode.occupant == _hero) {
            heroMoveTargetNode.occupant = noone;
        }
        _hero.gridX = heroOriginGridX;
        _hero.gridY = heroOriginGridY;
        _hero.x = heroOriginGridX * GRIDSIZE;
        _hero.y = heroOriginGridY * GRIDSIZE;
        selected[heroIndex][1] = heroMoveStartNode;
        gridX = heroOriginGridX;
        gridY = heroOriginGridY;
        x = _hero.x;
        y = _hero.y;
        heroMoving = false;
        heroMoveTargetNode = noone;
        heroMoveStartNode = noone;
        selectorPaused = false;
    }
}

function scrHeroUndoMove() {
    with (oSelector) {
        if (heroMoving) {
            scrHeroCancelMove();
            return;
        }
        if (!heroMoveCommitted) {
            return;
        }
        var _hero = selectedHero;
        var _currentNode = selected[heroIndex][1];
        var _originNode = global.nodeMap[heroOriginGridX, heroOriginGridY];
        _currentNode.occupant = noone;
        _originNode.occupant = _hero;
        _hero.gridX = heroOriginGridX;
        _hero.gridY = heroOriginGridY;
        _hero.x = heroOriginGridX * GRIDSIZE;
        _hero.y = heroOriginGridY * GRIDSIZE;
        selected[heroIndex][1] = _originNode;
        gridX = heroOriginGridX;
        gridY = heroOriginGridY;
        x = _hero.x;
        y = _hero.y;
        heroMoveCommitted = false;
    }
}

function scrDrawHeroMoveArrowHead(_toX, _toY, _dir, _colour) {
    draw_set_colour(_colour);
    var _headLen = 10;
    var _backX = _toX - lengthdir_x(_headLen, _dir);
    var _backY = _toY - lengthdir_y(_headLen, _dir);
    draw_triangle(
        _toX, _toY,
        _backX + lengthdir_x(6, _dir + 90), _backY + lengthdir_y(6, _dir + 90),
        _backX + lengthdir_x(6, _dir - 90), _backY + lengthdir_y(6, _dir - 90),
        false
    );
}

/// Straight segment fallback (invalid destination).
function scrDrawHeroMoveArrow(_fromX, _fromY, _toX, _toY, _colour = c_yellow) {
    var _dir = point_direction(_fromX, _fromY, _toX, _toY);
    var _dist = point_distance(_fromX, _fromY, _toX, _toY);
    if (_dist < 4) {
        return;
    }
    draw_set_colour(_colour);
    draw_set_alpha(0.95);
    draw_line_width(_fromX, _fromY, _toX, _toY, 3);
    scrDrawHeroMoveArrowHead(_toX, _toY, _dir, _colour);
    draw_set_alpha(1);
}

/// Preview arrow following BFS parent path; straight line if path is missing.
function scrDrawHeroMovePreview(_startNode, _endNode, _colour = c_yellow) {
    var _nodes = scrGetHeroPathNodes(_startNode, _endNode);
    var _count = array_length(_nodes);
    if (_count < 2 || _nodes[0] != _startNode) {
        var _fromX = _startNode.gridX * GRIDSIZE + GHALF;
        var _fromY = _startNode.gridY * GRIDSIZE + GHALF;
        var _toX = _endNode.gridX * GRIDSIZE + GHALF;
        var _toY = _endNode.gridY * GRIDSIZE + GHALF;
        scrDrawHeroMoveArrow(_fromX, _fromY, _toX, _toY, _colour);
        return;
    }
    draw_set_colour(_colour);
    draw_set_alpha(0.95);
    // Match movePath points (grid corners); offset to cell center for visibility
    var _prevX = _nodes[0].gridX * GRIDSIZE + GHALF;
    var _prevY = _nodes[0].gridY * GRIDSIZE + GHALF;
    for (var i = 1; i < _count; i++) {
        var _nextX = _nodes[i].gridX * GRIDSIZE + GHALF;
        var _nextY = _nodes[i].gridY * GRIDSIZE + GHALF;
        draw_line_width(_prevX, _prevY, _nextX, _nextY, 3);
        _prevX = _nextX;
        _prevY = _nextY;
    }
    var _dir = point_direction(
        _nodes[_count - 2].gridX * GRIDSIZE + GHALF,
        _nodes[_count - 2].gridY * GRIDSIZE + GHALF,
        _prevX, _prevY
    );
    scrDrawHeroMoveArrowHead(_prevX, _prevY, _dir, _colour);
    draw_set_alpha(1);
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
        if(_node.allyPassNode){
            _node.sprite_index = sMoveNode;
            _node.saveNode = false;
        }
        else if(_army == BLUEARMY){ 
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

