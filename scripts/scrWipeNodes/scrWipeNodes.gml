function scrWipeNodes(){
    //reset data of ALL nodes
    with(oNode){
        if(!saveNode){
            moveNode=false;
            attackNode = false;
            edge = false;
            G=0;  
            parent = noone;
            color = c_white;
            sprite_index = sDefaultNode;
        }
    }
}
