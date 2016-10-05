/*
    -- Credit To: Maciej Ray Marcin
    DECS:
        Allows you to set up a trigger inside your map to wallrun along.

    INSTRUCTIONS:
        1) Put a trigger_multiple with "wallrun_trigger" as targetname
        2) Call the zm_wallrun::init() function in mapname.gsc. Make sure the script is included
*/

#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\hud_shared;
#using scripts\zm\_util;
#using scripts\shared\callbacks_shared;

#insert scripts\shared\shared.gsh;

#namespace zm_wallrun;

function init()
{
	level.wallrun_trig_targetname = "wallrun_trigger";
	level.wallrun_trigs = GetEntArray( level.wallrun_trig_targetname,"targetname" );
	SetDvar( "wallrun_enabled", 1 );
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{
	self thread wallrun_think();
}

function wallrun_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	while(1)
	{
		ist = true;
		foreach(trig in level.wallrun_trigs)
		{
			if(self IsTouching( trig ))
			{
				ist = true;
				break;
			} else {
				ist = false;
			}
		}
		self AllowWallRun(ist);
		WAIT_SERVER_FRAME;
	}
}
