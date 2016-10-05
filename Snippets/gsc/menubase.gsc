/*
    -- Credit to: Jeff Skye
    DESC:
        This code allows you to use a prebuild mod menu looking menu for your
        map or testing needs.

    Preview: https://gyazo.com/657b5539e3e758fcf8efb142ac0f2341
*/

#using scripts\shared\util_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\callbacks_shared;

//Calling this init() is all you have to do for this menu to work.
function init()
{
	menu_init();
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned()
{
	self thread OnMenuResponse();
}
function menu_init()
{
	addSubMenu("Player Menu","pmenu");
		addMenuOption("Thirdperson On","pmenu",&thirdpersOn);
		addMenuOption("Thirdperson Off","pmenu",&thirdpersOff);
		addMenuOption("Option","pmenu",&test);
		addMenuOption("Option","pmenu",&test);

	addMenuOption("Option","main", &test );
	addMenuOption("Option","main",&test);

	addSubMenu("SubMenu","sub1");
		addMenuOption("Option","sub1",&test);
		addMenuOption("Option","sub1",&test);

	addSubMenu("Submenu","sub2");
		addMenuOption("Option","sub2",&test);
		addMenuOption("Option","sub2",&test);
}

//Add your menu functions below this line


function thirdpersOn()
{
	self setClientThirdPerson( 1 );
}
function thirdpersOff()
{
	self setClientThirdPerson( 0 );
}

function test()
{
	iPrintLnBold( "testin" );
}



//Add your menu functions above this line

// Don't Edit Anything Below This Line Unless You Know What Your Doing.
function OnMenuResponse()
{
	self endon( "death" );
	self endon( "disconnect" );
	self.injsp_menu = false;
	for(;;)
	{
		if( self FragButtonPressed() && !self.injsp_menu )
		{
			self.injsp_menu = true;
			self thread jspMenu();
			self disableWeapons();
			self freezeControls(true);
			self SetClientUIVisibilityFlag( "hud_visible", 0 );
		}
		wait 0.05;
	}
}

function endMenu()
{
	self notify("close_jsp_menu");
	for(i=0;i<self.jsp_menu.size;i++) self.jsp_menu[i] thread FadeOut(1,true,"right");
	self.jsp_menubg thread FadeOut(1);
	self.injsp_menu = false;
	self enableWeapons();
	self freezeControls(false);
	self SetClientUIVisibilityFlag( "hud_visible", 1 );
}
function addMenuOption(name,menu,script) {
	if(!isdefined(level.menuoption)) level.menuoption["name"] = [];
	if(!isDefined(level.menuoption["name"][menu])) level.menuoption["name"][menu] = [];
	level.menuoption["name"][menu][level.menuoption["name"][menu].size] = name;
	level.menuoption["script"][menu][level.menuoption["name"][menu].size] = script;
}
function addSubMenu(displayname,name) {
	addMenuOption(displayname,"main",name);
}
function GetMenuStuct(menu) {
	itemlist = "";
	for(i=0;i<level.menuoption["name"][menu].size;i++) itemlist = itemlist + level.menuoption["name"][menu][i] + "\n";
	return itemlist;
}
function jspMenu() {
	self endon("close_jsp_menu");
	self endon("disconnect");
	submenu = "main";
	self.jsp_menu[0] = addTextHud( self, -200, 0, .6, "left", "top", "right",0, 101 );
	self.jsp_menu[0] setShader("white", 400, 650);
	self.jsp_menu[0] thread FadeIn(.5,true,"right");
	self.jsp_menu[1] = addTextHud( self, -200, 0, .5, "left", "top", "right", 0, 101 );
	self.jsp_menu[1] setShader("white", 400, 650);
	self.jsp_menu[1] thread FadeIn(.5,true,"right");
	self.jsp_menu[2] = addTextHud( self, -200, 89, .5, "left", "top", "right", 0, 102 );
	self.jsp_menu[2] setShader("white", 600, 22);
	self.jsp_menu[2] thread FadeIn(.5,true,"right");
	self.jsp_menu[3] = addTextHud( self, -190, 98, 1, "left", "top", "right", 0, 104 );
	self.jsp_menu[3] setShader("white", 20, 3);
	self.jsp_menu[3] thread FadeIn(.5,true,"right");
	self.jsp_menu[4] = addTextHud( self, -165, 100, 1, "left", "middle", "right", 1.4, 103 );
	self.jsp_menu[4] settext(GetMenuStuct(submenu));
	self.jsp_menu[4] thread FadeIn(.5,true,"right");
	self.jsp_menu[5] = addTextHud( self, -170, 10, 1, "left", "top", "right" ,1.4, 103 );
	self.jsp_menu[5] settext("^7Select: ^3[Right or Left Mouse]^7\nUse: ^3[[{+activate}]]^7\nLeave: ^3[[{+melee}]]\n^3JSP Menu ^7by JeffSkye");
	self.jsp_menu[5] thread FadeIn(.5,true,"right");
	self.jsp_menubg = addTextHud( self, 0, 0, .5, "left", "top", undefined , 0, 101 );
	self.jsp_menubg.horzAlign = "fullscreen";
	self.jsp_menubg.vertAlign = "fullscreen";
	self.jsp_menubg setShader("black", 640, 480);
	self.jsp_menubg thread FadeIn(.2);
	for(selected=0;!self meleebuttonpressed();wait .05) {
		if(self Attackbuttonpressed()) {
			if(selected == level.menuoption["name"][submenu].size-1) selected = 0;
			else selected++;
		}
		if(self adsbuttonpressed())
		{
			if(selected == 0) selected = level.menuoption["name"][submenu].size-1;
			else selected--;
		}
		if(self adsbuttonpressed() || self Attackbuttonpressed()) {
			if(submenu == "main") {
				self.jsp_menu[2] moveOverTime( .05 );
				self.jsp_menu[2].y = 89 + (16.8 * selected);
				self.jsp_menu[3] moveOverTime( .05 );
				self.jsp_menu[3].y = 98 + (16.8 * selected);
			}
			else {
				self.jsp_menu[7] moveOverTime( .05 );
				self.jsp_menu[7].y = 10 + self.jsp_menu[6].y + (16.8 * selected);

			}
		}
		if((self adsbuttonpressed() || self Attackbuttonpressed()) && !self useButtonPressed()) wait .15;
		if(self useButtonPressed()) {
			if(!isString(level.menuoption["script"][submenu][selected+1])) {
				self thread [[level.menuoption["script"][submenu][selected+1]]]();
				self thread endMenu();
				self notify("close_jsp_menu");
			}
			else {
				abstand = (16.8 * selected);
				submenu = level.menuoption["script"][submenu][selected+1];
				self.jsp_menu[6] = addTextHud( self, -430, abstand + 50, .5, "left", "top", "right", 0, 101 );
				self.jsp_menu[6] setShader("white", 200, 300);
				self.jsp_menu[6] thread FadeIn(.5,true,"left");
				self.jsp_menu[7] = addTextHud( self, -430, abstand + 60, .5, "left", "top", "right", 0, 102 );
				self.jsp_menu[7] setShader("white", 200, 22);
				self.jsp_menu[7] thread FadeIn(.5,true,"left");
				self.jsp_menu[8] = addTextHud( self, -420, abstand + 71, 1, "left", "middle", "right", 1.4, 103 );
				self.jsp_menu[8] settext(GetMenuStuct(submenu));
				self.jsp_menu[8] thread FadeIn(.5,true,"left");
				selected = 0;
				wait .2;
			}
		}
	}
	self thread endMenu();
}
function addTextHud( who, x, y, alpha, alignX, alignY, vert, fontScale, sort ) {
	if( isPlayer( who ) ) hud = newClientHudElem( who );
	else hud = newHudElem();

	hud.x = x;
	hud.y = y;
	hud.alpha = alpha;
	hud.sort = sort;
	hud.alignX = alignX;
	hud.alignY = alignY;
	if(isdefined(vert))
		hud.horzAlign = vert;
	if(fontScale != 0)
		hud.fontScale = fontScale;
	return hud;
}
function FadeOut(time,slide,dir) {
	if(!isDefined(self)) return;
	if(isdefined(slide) && slide) {
		self MoveOverTime(0.2);
		if(isDefined(dir) && dir == "right") self.x+=600;
		else self.x-=600;
	}
	self fadeovertime(time);
	self.alpha = 0;
	wait time;
	if(isDefined(self)) self destroy();
}
function FadeIn(time,slide,dir) {
	if(!isDefined(self)) return;
	if(isdefined(slide) && slide) {
		if(isDefined(dir) && dir == "right") self.x+=600;
		else self.x-=600;
		self moveOverTime( .2 );
		if(isDefined(dir) && dir == "right") self.x-=600;
		else self.x+=600;
	}
	alpha = self.alpha;
	self.alpha = 0;
	self fadeovertime(time);
	self.alpha = alpha;
}
