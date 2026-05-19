function scrWipeNodes(_forceClear = false){
    // Always reset pathfinding state; only preserve sprites when saveNode is set
    with(oNode){
        moveNode = false;
        attackNode = false;
        edge = false;
        G = 0;
        parent = noone;
        if (_forceClear || !saveNode) {
            saveNode = false;
            color = c_white;
            sprite_index = sDefaultNode;
        }
    }
}
