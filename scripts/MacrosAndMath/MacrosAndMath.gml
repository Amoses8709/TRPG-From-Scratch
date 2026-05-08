#macro GRIDSIZE 32
#macro REDARMY 10
#macro BLUEARMY 20
#macro GHALF GRIDSIZE/2

global.endText = "The Heroes have fallen...";

function to_tile(val){
    return (val div GRIDSIZE);
}

function to_room(val){
    return (val * GRIDSIZE);
}