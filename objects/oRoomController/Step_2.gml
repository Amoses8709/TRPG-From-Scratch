
    if(activeArmy = BLUEARMY){
        if(array_length(heroChars)<=0){
        activeArmy = REDARMY;
    }
    else{
        if(array_length(enemyChars)<=0){
            activeArmy = BLUEARMY;
        }
        
    }
}