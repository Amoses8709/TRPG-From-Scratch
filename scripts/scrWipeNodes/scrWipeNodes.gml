function scrWipeNodes(){
    //reset data of ALL nodes
    with(oNode){
        moveNode=false;
        attackNode = false;
        G=0;
        parent = noone;
        color = c_white;
        sprite_index = sDefaultNode;
    }

}