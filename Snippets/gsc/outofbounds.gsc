/*
    -- Credit to: MiKeY (aokmikey@gmail.com)
    DESC:
        Stops watching players for out of bounds or to many weapons in zombies

    INSTRUCTIONS:
        use this with a callback::on_player_spawned
*/
function onPlayerSpawn() {
    wait 5;
    self IPrintLn("Watchers Disabled");
    self notify( "stop_player_too_many_weapons_monitor" );
    self notify( "stop_player_out_of_playable_area_monitor" );
}

/*
    Alternative
    -- Credit: Maciej Ray Marcin
    INSTRUCTIONS:
        follow the above
*/

level.player_too_many_weapons_monitor_func = &nothing;
level.player_out_of_playable_area_monitor = false;

function nothing() {}
