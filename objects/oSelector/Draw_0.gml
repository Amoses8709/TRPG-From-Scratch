//var _tempTitle = "oSelector X/Y: " + string(x) + "/" + string(y);
    //
//draw_set_colour(c_black);
//draw_rectangle(x+33, 0, x+33 + string_width(_tempTitle), 20,false);
//draw_set_colour(c_white);
//draw_text(x+33, 0, _tempTitle);
//draw_self();
//scrDebugTextbox(oSelector);
draw_self();

if (heroSelected && selectedHero != noone && !heroMoving) {
    if (gridX != selectedHero.gridX || gridY != selectedHero.gridY) {
        var _startNode = selected[heroIndex][1];
        if (_startNode != noone) {
            var _endNode = global.nodeMap[gridX, gridY];
            var _arrowColour = c_yellow;
            
            if (scrIsValidHeroMoveDest(gridX, gridY, _startNode)){
                gpu_set_depth(0);
                scrDrawHeroMovePreview(_startNode, _endNode, _arrowColour);
            }
            else{
                if (_endNode.occupant != noone) {
                    if (_endNode.occupant.army == BLUEARMY) {
                        gpu_set_depth(0);
                        scrDrawHeroMovePreview(_startNode, _endNode, _arrowColour);
                    }
                }
            }
            
        }
    }
}