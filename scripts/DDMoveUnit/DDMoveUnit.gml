function scr_move_unit()
{
    movementstate = "unit moving";
    selectedactor.x = floor(selectedactor.x / 32) * 32;
    selectedactor.y = floor(selectedactor.y / 32) * 32;
    ds_grid_set(grid_army, map_x, map_y, selectedactor.army);
    ds_grid_set(grid_army, selectedactor.x / 32, selectedactor.y / 32, 0);
    ds_grid_set(grid_occupant, map_x, map_y, selectedactor);
    ds_grid_set(grid_occupant, selectedactor.x / 32, selectedactor.y / 32, 0);
    selectedactor.map_x = map_x;
    selectedactor.map_y = map_y;
    var pathinggrid = obj_movement.grid_moves;
    var xxx = map_x;
    var yyy = map_y;
    var iterate = 0;
    path_clear_points(path_move);
    path_add_point(path_move, map_x * 32, map_y * 32, 40);
    
    do
    {
        if (xxx < 0)
            xxx = 0;
        
        if (yyy < 0)
            yyy = 0;
        
        var xyxydist = max(ds_grid_get(pathinggrid, xxx + 1, yyy), ds_grid_get(pathinggrid, max(xxx - 1, 0), yyy), ds_grid_get(pathinggrid, xxx, yyy + 1), ds_grid_get(pathinggrid, xxx, max(yyy - 1, 0)));
        
        if (ds_grid_get(pathinggrid, xxx + 1, yyy) == xyxydist)
        {
            path_add_point(path_move, (xxx + 1) * 32, yyy * 32, 50);
            xxx = xxx + 1;
        }
        else if (ds_grid_get(pathinggrid, max(xxx - 1, 0), yyy) == xyxydist)
        {
            path_add_point(path_move, max(xxx - 1, 0) * 32, yyy * 32, 50);
            xxx = xxx - 1;
        }
        else if (ds_grid_get(pathinggrid, xxx, yyy + 1) == xyxydist)
        {
            path_add_point(path_move, xxx * 32, (yyy + 1) * 32, 50);
            yyy = yyy + 1;
        }
        else if (ds_grid_get(pathinggrid, xxx, max(yyy - 1, 0)) == xyxydist)
        {
            path_add_point(path_move, xxx * 32, max(yyy - 1, 0) * 32, 50);
            yyy = yyy - 1;
        }
        
        iterate += 1;
    }
    until ((xxx == (selectedactor.x / 32) && yyy == (selectedactor.y / 32)) || iterate > 80);
    
    path_reverse(path_move);
    
    with (selectedactor)
    {
        x_movep = x;
        
        if (Name != "Shamac")
            alarm[0] = 1;
        
        movementhappening = true;
        path_start(other.path_move, other.movementspeed, path_action_stop, true);
        sprite_index = sprite_move;
    }
    
    with (obj_movement)
        instance_destroy();
    
    selectedactor.can_move = false;
    action_menu_select = 0;
    action_menu_open = true;
    scr_action_menu_list();
    audio_play_sound_on(global.SFX_Emitter, snd_inlevel_menuopen, false, 2);
    map_x_menu = map_x;
    map_y_menu = map_y;
}

function scr_move_unit_attack()
{
    movementstate = "unit moving";
    selectedactor.x = floor(selectedactor.x / 32) * 32;
    selectedactor.y = floor(selectedactor.y / 32) * 32;
    ds_grid_set(grid_army, map_x, map_y, selectedactor.army);
    ds_grid_set(grid_army, selectedactor.x / 32, selectedactor.y / 32, 0);
    ds_grid_set(grid_occupant, map_x, map_y, selectedactor);
    ds_grid_set(grid_occupant, selectedactor.x / 32, selectedactor.y / 32, 0);
    var pathinggrid = obj_movement.grid_moves;
    var xxx = map_x;
    var yyy = map_y;
    var iterate = 0;
    path_clear_points(path_move);
    path_add_point(path_move, map_x * 32, map_y * 32, 40);
    
    do
    {
        if (xxx < 0)
            xxx = 0;
        
        if (yyy < 0)
            yyy = 0;
        
        var xyxydist = max(ds_grid_get(pathinggrid, xxx + 1, yyy), ds_grid_get(pathinggrid, max(xxx - 1, 0), yyy), ds_grid_get(pathinggrid, xxx, yyy + 1), ds_grid_get(pathinggrid, xxx, max(yyy - 1, 0)));
        
        if (ds_grid_get(pathinggrid, xxx + 1, yyy) == xyxydist)
        {
            path_add_point(path_move, (xxx + 1) * 32, yyy * 32, 50);
            xxx = xxx + 1;
        }
        else if (ds_grid_get(pathinggrid, max(xxx - 1, 0), yyy) == xyxydist)
        {
            path_add_point(path_move, max(xxx - 1, 0) * 32, yyy * 32, 50);
            xxx = xxx - 1;
        }
        else if (ds_grid_get(pathinggrid, xxx, yyy + 1) == xyxydist)
        {
            path_add_point(path_move, xxx * 32, (yyy + 1) * 32, 50);
            yyy = yyy + 1;
        }
        else if (ds_grid_get(pathinggrid, xxx, max(yyy - 1, 0)) == xyxydist)
        {
            path_add_point(path_move, xxx * 32, max(yyy - 1, 0) * 32, 50);
            yyy = yyy - 1;
        }
        
        iterate += 1;
    }
    until ((xxx == (selectedactor.x / 32) && yyy == (selectedactor.y / 32)) || iterate > 80);
    
    path_reverse(path_move);
    
    with (selectedactor)
    {
        x_movep = x;
        
        if (Name != "Shamac")
            alarm[0] = 1;
        
        movementhappening = true;
        path_start(other.path_move, other.movementspeed, path_action_stop, true);
        sprite_index = sprite_move;
    }
    
    with (obj_movement)
        instance_destroy();
    
    scr_targeting_attack();
    selectedactor.can_move = false;
    attack_menu_open = true;
    map_x_menu = map_x;
    map_y_menu = map_y;
}

function scr_move_unit_ai()
{
    if (ds_grid_get(obj_movement_nonplayer.grid_moves, AI_move_x, AI_move_y) >= 0)
    {
        movementstate = "unit moving";
        current_AI.x = floor(current_AI.x / 32) * 32;
        current_AI.y = floor(current_AI.y / 32) * 32;
        ds_grid_set(grid_army, AI_move_x, AI_move_y, current_AI.army);
        ds_grid_set(grid_army, current_AI.x / 32, current_AI.y / 32, 0);
        ds_grid_set(grid_occupant, AI_move_x, AI_move_y, current_AI);
        ds_grid_set(grid_occupant, current_AI.x / 32, current_AI.y / 32, 0);
        current_AI.map_x = AI_move_x;
        current_AI.map_y = AI_move_y;
        var pathinggrid = obj_movement_nonplayer.grid_moves;
        var xxx = AI_move_x;
        var yyy = AI_move_y;
        var iterate = 0;
        path_clear_points(path_move);
        path_add_point(path_move, AI_move_x * 32, AI_move_y * 32, 40);
        
        do
        {
            if (xxx < 0)
                xxx = 0;
            
            if (yyy < 0)
                yyy = 0;
            
            var xyxydist = max(ds_grid_get(pathinggrid, xxx + 1, yyy), ds_grid_get(pathinggrid, max(xxx - 1, 0), yyy), ds_grid_get(pathinggrid, xxx, yyy + 1), ds_grid_get(pathinggrid, xxx, max(yyy - 1, 0)));
            
            if (ds_grid_get(pathinggrid, xxx + 1, yyy) == xyxydist)
            {
                path_add_point(path_move, (xxx + 1) * 32, yyy * 32, 50);
                xxx = xxx + 1;
            }
            else if (ds_grid_get(pathinggrid, max(xxx - 1, 0), yyy) == xyxydist)
            {
                path_add_point(path_move, max(xxx - 1, 0) * 32, yyy * 32, 50);
                xxx = xxx - 1;
            }
            else if (ds_grid_get(pathinggrid, xxx, yyy + 1) == xyxydist)
            {
                path_add_point(path_move, xxx * 32, (yyy + 1) * 32, 50);
                yyy = yyy + 1;
            }
            else if (ds_grid_get(pathinggrid, xxx, max(yyy - 1, 0)) == xyxydist)
            {
                path_add_point(path_move, xxx * 32, max(yyy - 1, 0) * 32, 50);
                yyy = yyy - 1;
            }
            
            iterate += 1;
        }
        until ((xxx == (current_AI.x / 32) && yyy == (current_AI.y / 32)) || iterate > 80);
        
        path_reverse(path_move);
        
        with (current_AI)
        {
            x_movep = x;
            
            if (Name != "Shamac")
                alarm[0] = 1;
            
            movementhappening = true;
            
            if (global.fastforwarding)
                path_start(other.path_move, 99, path_action_stop, true);
            else
                path_start(other.path_move, global.movementspeed, path_action_stop, true);
            
            sprite_index = sprite_move;
        }
        
        current_AI.can_move = false;
    }
    else
    {
        movementstate = "none";
        path_clear_points(path_move);
        AI_state1 = AI_tempstate;
    }
}

function scr_move_cutscene(arg0, arg1, arg2)
{
    if (ds_grid_get(obj_movement_nonplayer.grid_moves, arg1, arg2) >= 0)
    {
        ds_grid_set(obj_grid.grid_army, arg1, arg2, arg0.army);
        ds_grid_set(obj_grid.grid_army, arg0.x / 32, arg0.y / 32, 0);
        ds_grid_set(obj_grid.grid_occupant, arg1, arg2, arg0);
        ds_grid_set(obj_grid.grid_occupant, arg0.x / 32, arg0.y / 32, 0);
        arg0.map_x = arg1;
        arg0.map_y = arg2;
        var pathinggrid = obj_movement_nonplayer.grid_moves;
        var xxx = arg1;
        var yyy = arg2;
        var iterate = 0;
        
        with (arg0)
        {
            if (!variable_instance_exists(id, "path_move"))
                path_move = path_add();
        }
        
        path_clear_points(arg0.path_move);
        path_add_point(arg0.path_move, arg1 * 32, arg2 * 32, 40);
        
        do
        {
            if (xxx < 0)
                xxx = 0;
            
            if (yyy < 0)
                yyy = 0;
            
            var xyxydist = max(ds_grid_get(pathinggrid, xxx + 1, yyy), ds_grid_get(pathinggrid, max(xxx - 1, 0), yyy), ds_grid_get(pathinggrid, xxx, yyy + 1), ds_grid_get(pathinggrid, xxx, max(yyy - 1, 0)));
            
            if (ds_grid_get(pathinggrid, xxx + 1, yyy) == xyxydist)
            {
                path_add_point(arg0.path_move, (xxx + 1) * 32, yyy * 32, 50);
                xxx = xxx + 1;
            }
            else if (ds_grid_get(pathinggrid, max(xxx - 1, 0), yyy) == xyxydist)
            {
                path_add_point(arg0.path_move, max(xxx - 1, 0) * 32, yyy * 32, 50);
                xxx = xxx - 1;
            }
            else if (ds_grid_get(pathinggrid, xxx, yyy + 1) == xyxydist)
            {
                path_add_point(arg0.path_move, xxx * 32, (yyy + 1) * 32, 50);
                yyy = yyy + 1;
            }
            else if (ds_grid_get(pathinggrid, xxx, max(yyy - 1, 0)) == xyxydist)
            {
                path_add_point(arg0.path_move, xxx * 32, max(yyy - 1, 0) * 32, 50);
                yyy = yyy - 1;
            }
            
            iterate += 1;
        }
        until ((xxx == (arg0.x / 32) && yyy == (arg0.y / 32)) || iterate > 80);
        
        path_reverse(arg0.path_move);
        path_set_closed(arg0.path_move, false);
        
        with (arg0)
        {
            x_movep = x;
            
            if (Name != "Shamac")
                alarm[0] = 1;
            
            movementhappening = true;
            path_start(path_move, global.movementspeed, path_action_stop, true);
            sprite_index = sprite_move;
        }
    }
}
