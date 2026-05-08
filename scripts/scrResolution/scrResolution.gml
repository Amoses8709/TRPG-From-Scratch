global.res = {
    width:480,
    height: 270,
    scale: 2
    
}

var _width = global.res.width * global.res.scale;
var _height = global.res.height * global.res.scale;

// Set resolution
surface_resize(application_surface,_width, _height);

// Window
window_set_size(_width, _height);

// GUI
display_set_gui_size(_width, _height);

// Center window
var _displayWidth = display_get_width();
var _displayHeight = display_get_height();

window_set_position(
    _displayWidth/2 - _width/2,
    _displayHeight/2 - _height/2
);
