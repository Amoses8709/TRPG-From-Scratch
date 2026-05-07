#macro GRIDSIZE 16
#macro REDARMY 10
#macro BLUEARMY 20
#macro CENTER GRIDSIZE/2

global.endText = "The Heroes have fallen...";

function to_tile(val){
    return (val div TILESIZE);
}

function to_room(val){
    return (val * TILESIZE);
}