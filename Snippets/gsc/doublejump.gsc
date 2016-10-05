/*

    -- Credit to Echo000
    DESC:
        This code enabled will enabled double jump in zombies :) 

*/

function main()
{
    // Not part of this snippet.
    zm_usermap::main();

    level._zombie_custom_add_weapons =&custom_add_weapons;

    //Setup the levels Zombie Zone Volumes
    level.zones = [];
    level.zone_manager_init_func =&usermap_test_zone_init;
    init_zones[0] = "start_zone";
    level thread zm_zonemgr::manage_zones( init_zones );

    level.pathdist_type = PATHDIST_ORIGINAL;
    level.perk_purchase_limit = 12;

    level flag::wait_till( "initial_blackscreen_passed" );
    // END

    // The snippet is showing this code off.
    SetDvar( "doublejump_enabled", 1 );
    SetDvar( "juke_enabled", 1 );
    SetDvar( "playerEnergy_enabled", 1 );
    SetDvar( "wallrun_enabled", 1 );
    SetDvar( "sprintLeap_enabled", 1 );
    SetDvar( "traverse_mode", 1 );
    SetDvar( "weaponrest_enabled", 1 );

}
