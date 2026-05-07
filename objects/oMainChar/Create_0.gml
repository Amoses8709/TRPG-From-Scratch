// Inherit the parent event
event_inherited();

states = {
    idle: {
        right:sMainCharIdle
    },
    walk: {
        right:sMainCharWalkRight
    }
}

state = states.idle;