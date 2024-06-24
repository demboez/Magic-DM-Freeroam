/*SCRIPT [S]peed_. (speedpro)*/
/*Includes*/
#include <a_samp>
#include <zcmd>
#include <streamer>
#include <xFireworks>
#include <ProgressBars>
/*Defines*/
#define gamesxd  930
#define LaifJuegos 60
#define ZombiesDialog 112
#define ListaMapasCS 332
#define MapaCSeleccionado 400
#define timefor 1300
#pragma unused CreateFirework
#define CALLBACK:%0(%1) forward%0(%1);public%0(%1)
#define PRESSED(%0) \
(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
/*News*/
new FireShotON[MAX_PLAYERS];
new FireShot[MAX_PLAYERS];
new	gRocketObj[MAX_PLAYERS];
new VarSaltos[MAX_PLAYERS];
new EsZombie[MAX_PLAYERS];
new EsHumano[MAX_PLAYERS];
new MediKits[MAX_PLAYERS];
new Carnes[MAX_PLAYERS];
new Text:ZombiesTD0[MAX_PLAYERS];
new Text:ZombiesTD1[MAX_PLAYERS];
new PlayerBar:LaifZombies;
new TelesJuegosMenu[] = "ZonaWW {58FCB7}| {FFFFFF}Users: {58FCB7}%d\n\
					ZonaRW {58FCB7}| {FFFFFF}Users: {58FCB7}%d\n\
					RocketDM {58FCB7}| {FFFFFF}Users: {58FCB7}%d\n\
					Minigun {58FCB7}| {FFFFFF}Users: {58FCB7}%d\n\
					Zombie Attack {58FCB7}| {FFFFFF}Users: {58FCB7}%d\n\
					Minigun2 {58FCB7}| {FFFFFF}Users: {58FCB7}%d\n\
					Counter Strike {58FCB7}| {FFFFFF}Users: {58FCB7}%d\n\
					RocketDM2 {58FCB7}| {FFFFFF}Users: {58FCB7}%d\n\
					Monster War {58FCB7}| {FFFFFF}Users: {58FCB7}%d";
new Float:Rocketlaa[5][5] = {
   {-1060.9521,1025.0426,1346.4713},
   {-1131.9752,1095.4905,1345.7924},
   {-1132.1311,1029.0294,1345.7332},
   {-1026.4314,1077.6188,1346.8560},
   {-974.8481,1060.8491,1345.6719}
};
new Float:Minigun1[6][6] =
{
   {934.2223,2176.5996,1011.0234},
   {933.4439,2149.3118,1011.0234},
   {933.5018,2144.3103,1011.0234},
   {950.4492,2144.4521,1011.0195},
   {942.3889,2127.0247,1012.2277},
   {955.9052,2144.3752,1011.0271}
};
new Float:Minigun2[7][7] =
{
   {2235.9456,1679.1506,1008.3594},
   {2251.6807,1631.3894,1008.3594},
   {2276.7754,1585.7549,1006.1780},
   {2245.8799,1591.7612,1006.1844},
   {2211.9063,1603.1843,1006.1641},
   {2146.2209,1619.5223,1008.3594},
   {2143.6838,1585.5140,1006.1801}
};
new Float:Rocket2[11][11] = {
   {-2068.8599,228.6366,39.0518},
   {-2095.7881,260.7444,38.6118},
   {-2131.7517,276.8345,37.6241},
   {-2056.2661,241.0510,35.2058},
   {-2088.7976,171.0626,38.0798},
   {-2130.3792,167.9699,42.2500},
   {-2125.4731,239.3777,37.2813},
   {-2082.9563,293.7145,35.7458},
   {-2069.3984,303.4023,41.9922},
   {-2083.9365,254.3925,39.3953},
   {-2062.3359,203.8662,35.4786}
};
new Float:MDM[4][4] =
{
	{448.4664,-1853.8698,3.5349},
	{577.2783,-1852.2715,5.0090},
	{635.6251,-1808.0022,8.5370},
	{692.7674,-1894.4720,3.5303}
};

new Float:SpawnZombies[3][3] =
{
	{124.6185,1890.3892,18.3369},
	{146.1253,1860.5768,17.6489},
	{191.5023,1861.5026,20.3978}
};

new Float:SpawnMilitares[3][3] =
{
	{232.9877,1919.4017,17.6481},
	{267.5323,1865.8577,17.6406},
	{235.0362,1933.1027,33.8984}
};
new vmensajes[150];
new mensajeColors[12] =
{
	0xFF0000FF,0xFF9500FF,
	0xFF95BBFF,0xFFFFBBFF,
	0x07FFBBFF,0xFA5882FF,
	0xD0FA58FF,0xFF00BBFF,
	0xAC58FAFF,0x819FF7FF,
	0x5858FAFF,0x58FA58FF
};
enum JuegosLista
{
	ZonaWW,
	ZonaRW,
	RocketDM,
	RocketDM2,
	MinigunDM,
	Minigun2DM,
	MonsterDM,
	Counter,
	Zhomviez,
	CSMap1,
	CSMap2,
	CSMap3,
	CSMap4,
	CSMap5,
	CSMap6,
	CSMap7,
	CSMap8,
	CSMap9,
	CSMap10,
	CSMap11
};

new Game[MAX_PLAYERS][JuegosLista];

CMD:games(playerid, params[])
{
	new sdtrx[800];
	format(sdtrx, sizeof(sdtrx), TelesJuegosMenu,UsersZonaWW(),UsersZonaRW(),UsersRocket(),UsersMinigun(),UsersZombieAttack(),UsersMinigun2(),UsersCS(),UsersRocket2(),UsersMDM());
	ShowPlayerDialog(playerid,gamesxd,DIALOG_STYLE_LIST, "Games",sdtrx,"Select","Cancel");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
	return 1;
}
CMD:exit(playerid, params[])
{
	SpawnPlayer(playerid);
	ActualizarJuegos();
	EsHumano[playerid] = 0;
	EsZombie[playerid] = 0;
	Carnes[playerid] = 0;
	MediKits[playerid] = 0;
	Game[playerid][Zhomviez] = 0;
	Game[playerid][CSMap1] = 0;
	Game[playerid][CSMap2] = 0;
	Game[playerid][CSMap3] = 0;
	Game[playerid][CSMap4] = 0;
	Game[playerid][CSMap5] = 0;
	Game[playerid][CSMap6] = 0;
	Game[playerid][CSMap7] = 0;
	Game[playerid][CSMap8] = 0;
	Game[playerid][CSMap9] = 0;
	Game[playerid][CSMap10] = 0;
	Game[playerid][CSMap11] = 0;
	Game[playerid][MinigunDM] = 0;
	Game[playerid][Minigun2DM] = 0;
	Game[playerid][RocketDM] = 0;
	Game[playerid][RocketDM2] = 0;
	Game[playerid][ZonaWW] = 0;
	Game[playerid][ZonaRW] = 0;
	Game[playerid][Counter] = 0;
	return 1;
}
CALLBACK: OnPlayerSpawn(playerid)
{
    TextDrawHideForPlayer(playerid, ZombiesTD0[playerid]);
	TextDrawHideForPlayer(playerid, ZombiesTD1[playerid]);
	return 1;
}
CALLBACK: OnFilterScriptInit()
{
    CargarObjetos();
    for(new playerid; playerid < MAX_PLAYERS; playerid++)
    {
    ZombiesTD0[playerid] = TextDrawCreate(10.000000, 152.133331, "_");
    TextDrawLetterSize(ZombiesTD0[playerid], 0.283998, 1.039999);
    TextDrawAlignment(ZombiesTD0[playerid], 1);
    TextDrawColor(ZombiesTD0[playerid], -16776961);
    TextDrawSetShadow(ZombiesTD0[playerid], 0);
    TextDrawSetOutline(ZombiesTD0[playerid], 1);
    TextDrawBackgroundColor(ZombiesTD0[playerid], 255);
    TextDrawFont(ZombiesTD0[playerid], 1);
    TextDrawSetProportional(ZombiesTD0[playerid], 1);

    ZombiesTD1[playerid] = TextDrawCreate(25.000000, 168.000015, "_");
    TextDrawLetterSize(ZombiesTD1[playerid], 0.313998, 1.142665);
    TextDrawAlignment(ZombiesTD1[playerid], 1);
    TextDrawColor(ZombiesTD1[playerid], -1);
    TextDrawSetShadow(ZombiesTD1[playerid], 0);
    TextDrawSetOutline(ZombiesTD1[playerid], 1);
    TextDrawBackgroundColor(ZombiesTD1[playerid], 255);
    TextDrawFont(ZombiesTD1[playerid], 1);
    TextDrawSetProportional(ZombiesTD1[playerid], 1);
    }
	return 1;
}
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == ListaMapasCS)
    {
    if(response)
    {
    if(listitem == 0)
	{
	new StrBox1[500];
	strcat(StrBox1, "{FFFFFF}Choose the character you want to be\n");
	strcat(StrBox1, "{FF0000}Terrorist: {91EB00}Weapons: 9mm, Shotgun, Uzi, AK47, Rifle\n");
	strcat(StrBox1, "{FF0000}Swats: {91EB00}Weapons: DesertEagle, Combat Shotgun, Mp5, M4 ,Sniper\n");
	ShowPlayerDialog(playerid, MapaCSeleccionado, DIALOG_STYLE_MSGBOX, "Counter Strike: AimHeadshot", StrBox1, "Terrorist", "Swats");
	    }
    if(listitem == 1)
	{
	new StrBox1[500];
	strcat(StrBox1, "{FFFFFF}Choose the character you want to be\n");
	strcat(StrBox1, "{FF0000}Terrorist: {91EB00}Weapons: 9mm, Escopeta, Uzi, AK47, Rifle\n");
	strcat(StrBox1, "{FF0000}Swats: {91EB00}Weapons: DesertEagle, Combat Shotgun, Mp5, M4 ,Sniper\n");
	ShowPlayerDialog(playerid, MapaCSeleccionado+1, DIALOG_STYLE_MSGBOX, "Counter Strike: CS_Bank", StrBox1, "Terrorist", "Swats");
    }
    if(listitem == 2)
	{
	new StrBox1[500];
	strcat(StrBox1, "{FFFFFF}Choose the character you want to be\n");
	strcat(StrBox1, "{FF0000}Terrorist: {91EB00}Weapons: 9mm, Escopeta, Uzi, AK47, Rifle\n");
	strcat(StrBox1, "{FF0000}Swats: {91EB00}Weapons: DesertEagle, Combat Shotgun, Mp5, M4 ,Sniper\n");
	ShowPlayerDialog(playerid, MapaCSeleccionado+2, DIALOG_STYLE_MSGBOX, "Counter Strike: CS_Barron", StrBox1, "Terrorist", "Swats");
    }
    if(listitem == 3)
	{
	new StrBox1[500];
	strcat(StrBox1, "{FFFFFF}Choose the character you want to be\n");
	strcat(StrBox1, "{FF0000}Terrorist: {91EB00}Weapons: 9mm, Escopeta, Uzi, AK47, Rifle\n");
	strcat(StrBox1, "{FF0000}Swats: {91EB00}Weapons: DesertEagle, Combat Shotgun, Mp5, M4 ,Sniper\n");
	ShowPlayerDialog(playerid, MapaCSeleccionado+3, DIALOG_STYLE_MSGBOX, "Counter Strike: CS_Compound", StrBox1, "Terrorist", "Swats");
    }
    if(listitem == 4)
	{
	new StrBox1[500];
	strcat(StrBox1, "{FFFFFF}Choose the character you want to be\n");
	strcat(StrBox1, "{FF0000}Terrorist: {91EB00}Weapons: 9mm, Escopeta, Uzi, AK47, Rifle\n");
	strcat(StrBox1, "{FF0000}Swats: {91EB00}Weapons: DesertEagle, Combat Shotgun, Mp5, M4 ,Sniper\n");
	ShowPlayerDialog(playerid, MapaCSeleccionado+4, DIALOG_STYLE_MSGBOX, "Counter Strike: CS_Hospital", StrBox1, "Terrorist", "Swats");
    }
    if(listitem == 5)
	{
	new StrBox1[500];
	strcat(StrBox1, "{FFFFFF}Choose the character you want to be\n");
	strcat(StrBox1, "{FF0000}Terrorist: {91EB00}Weapons: 9mm, Escopeta, Uzi, AK47, Rifle\n");
	strcat(StrBox1, "{FF0000}Swats: {91EB00}Weapons: DesertEagle, Combat Shotgun, Mp5, M4 ,Sniper\n");
	ShowPlayerDialog(playerid, MapaCSeleccionado+5, DIALOG_STYLE_MSGBOX, "Counter Strike: CS_House", StrBox1, "Terrorist", "Swats");
    }
    if(listitem == 6)
	{
	new StrBox1[500];
	strcat(StrBox1, "{FFFFFF}Choose the character you want to be\n");
	strcat(StrBox1, "{FF0000}Terrorist: {91EB00}Weapons: 9mm, Escopeta, Uzi, AK47, Rifle\n");
	strcat(StrBox1, "{FF0000}Swats: {91EB00}Weapons: DesertEagle, Combat Shotgun, Mp5, M4 ,Sniper\n");
	ShowPlayerDialog(playerid, MapaCSeleccionado+6, DIALOG_STYLE_MSGBOX, "Counter Strike: CS_PD", StrBox1, "Terrorist", "Swats");
	    }
    if(listitem == 7)
	{
	new StrBox1[500];
	strcat(StrBox1, "{FFFFFF}Choose the character you want to be\n");
	strcat(StrBox1, "{FF0000}Terrorist: {91EB00}Weapons: 9mm, Escopeta, Uzi, AK47, Rifle\n");
	strcat(StrBox1, "{FF0000}Swats: {91EB00}Weapons: DesertEagle, Combat Shotgun, Mp5, M4 ,Sniper\n");
	ShowPlayerDialog(playerid, MapaCSeleccionado+7, DIALOG_STYLE_MSGBOX, "Counter Strike: CS_Ship", StrBox1, "Terrorist", "Swats");
    }
	if(listitem == 8)
	{
	new StrBox1[500];
	strcat(StrBox1, "{FFFFFF}Choose the character you want to be\n");
	strcat(StrBox1, "{FF0000}Terrorist: {91EB00}Weapons: 9mm, Escopeta, Uzi, AK47, Rifle\n");
	strcat(StrBox1, "{FF0000}Swats: {91EB00}Weapons: DesertEagle, Combat Shotgun, Mp5, M4 ,Sniper\n");
	ShowPlayerDialog(playerid, MapaCSeleccionado+9, DIALOG_STYLE_MSGBOX, "Counter Strike: CS_Vill", StrBox1, "Terrorist", "Swats");
    }
    if(listitem == 9)
	{
	new StrBox1[500];
	strcat(StrBox1, "{FFFFFF}Choose the character you want to be\n");
	strcat(StrBox1, "{FF0000}Terrorist: {91EB00}Weapons: 9mm, Escopeta, Uzi, AK47, Rifle\n");
	strcat(StrBox1, "{FF0000}Swats: {91EB00}Weapons: DesertEagle, Combat Shotgun, Mp5, M4 ,Sniper\n");
	ShowPlayerDialog(playerid, MapaCSeleccionado+10, DIALOG_STYLE_MSGBOX, "Counter Strike: DE_Dust3", StrBox1, "Terrorist", "Swats");
    }
    if(listitem == 10)
	{
	new StrBox1[500];
	strcat(StrBox1, "{FFFFFF}Choose the character you want to be\n");
	strcat(StrBox1, "{FF0000}Terrorist: {91EB00}Weapons: 9mm, Escopeta, Uzi, AK47, Rifle\n");
	strcat(StrBox1, "{FF0000}Swats: {91EB00}Weapons: DesertEagle, Combat Shotgun, Mp5, M4 ,Sniper\n");
	ShowPlayerDialog(playerid, MapaCSeleccionado+8, DIALOG_STYLE_MSGBOX, "Counter Strike: CS_TnT", StrBox1, "Terrorist", "Swats");
    }
    }
    return 1;
    }
    if(dialogid == ZombiesDialog)
    {
    if(response == 1)
	{
	new xdax[400];
	format(xdax, sizeof(xdax), "~g~(!) ~w~Do you have ~g~%d ~w~Rotten Meat, Press ~g~'Y' ~w~to use/s",Carnes[playerid]);
	TextDrawSetString(ZombiesTD0[playerid], xdax);
	TextDrawShowForPlayer(playerid, ZombiesTD0[playerid]);
	TextDrawSetString(ZombiesTD1[playerid], "~w~every ~g~humans ~w~what does matt add to you ~g~1 Rotten meat");
	TextDrawShowForPlayer(playerid, ZombiesTD1[playerid]);
	EsZombie[playerid] = 1;
	LaifZombies = CreatePlayerProgressBar(playerid,545.00, 67.00, 84.50, 7.19, 16739327, 100.0);
	SetPlayerProgressBarMaxValue(playerid, LaifZombies, 200);
	SetPlayerSkin(playerid, 162);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 9, 1);
	new rand = random(sizeof(SpawnZombies));
	SetPlayerPos(playerid,SpawnZombies[rand][0], SpawnZombies[rand][1], SpawnZombies[rand][2]);
	SetPlayerVirtualWorld(playerid, 5);
	SetPlayerHealth(playerid, 200);
	VarSaltos[playerid] = 1;
	Game[playerid][Zhomviez] = 1;
	Tele(playerid,"Zombies"); CargandoJuego(playerid);
	return 1;
	}
	if(response == 0)
    {
	new xdax[400];
	format(xdax, sizeof(xdax), "~r~(!) ~w~Do you have ~r~%d ~w~MediKits, Press ~r~'Y' ~w~to use it/s",MediKits[playerid]);
	TextDrawSetString(ZombiesTD0[playerid], xdax);
	TextDrawShowForPlayer(playerid, ZombiesTD0[playerid]);
	TextDrawSetString(ZombiesTD1[playerid], "~w~Each ~r~zombie ~w~what does matt add to you ~r~1 MediKit");
	TextDrawShowForPlayer(playerid, ZombiesTD1[playerid]);
	EsHumano[playerid] = 1;
	SetPlayerSkin(playerid, 284);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 25, 500);
	GivePlayerWeapon(playerid, 30, 500);
	GivePlayerWeapon(playerid, 33, 500);
	SetPlayerHealth(playerid, 100);
	SetPlayerArmour(playerid, 20);
	Game[playerid][Zhomviez] = 1;
	new rand = random(sizeof(SpawnMilitares));
	SetPlayerPos(playerid,SpawnMilitares[rand][0], SpawnMilitares[rand][1], SpawnMilitares[rand][2]);
	SetPlayerVirtualWorld(playerid, 5);
	Tele(playerid, "Zombies"); CargandoJuego(playerid);
    return 1;
    }
    }
	if(dialogid == gamesxd)
    {
    if(response)
    {
    if(listitem == 0)
    {
	new Float:VerificarVida;
	GetPlayerHealth(playerid, VerificarVida);
	if(VerificarVida >= LaifJuegos)
	{
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 500);
	GivePlayerWeapon(playerid, 25, 500);
	GivePlayerWeapon(playerid, 34, 500);
	SetPlayerPos(playerid,1412.639892,-1.787510,1000.924377);
	SetPlayerVirtualWorld(playerid, 3);
	SetPlayerInterior(playerid, 1);
	Game[playerid][ZonaWW] = 1;
	Tele(playerid, "ZonaWW");
	} else { SendClientMessage(playerid, -1, "* You do not have enough life to enter the game"); }
    }
    if(listitem == 1)
    {
	new Float:VerificarVida;
	GetPlayerHealth(playerid, VerificarVida);
	if(VerificarVida >= LaifJuegos)
	{
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 26, 500);
	GivePlayerWeapon(playerid, 28, 500);
	GivePlayerWeapon(playerid, 22, 500);
	SetPlayerPos(playerid,1412.639892,-1.787510,1000.924377);
	SetPlayerVirtualWorld(playerid, 4);
	SetPlayerInterior(playerid, 1);
	Game[playerid][ZonaRW] = 1;
	Tele(playerid, "ZonaRW");
	} else { SendClientMessage(playerid, -1, "* You do not have enough life to enter the game"); }
 	}
    if(listitem == 2)
    {
	new Float:VerificarVida;
	GetPlayerHealth(playerid, VerificarVida);
	if(VerificarVida >= LaifJuegos)
	{
	new rand = random(sizeof(Rocketlaa));
	SetPlayerPos(playerid,Rocketlaa[rand][0], Rocketlaa[rand][1], Rocketlaa[rand][2]);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 35, 9999);
	SetPlayerVirtualWorld(playerid,3);
	SetPlayerInterior(playerid, 10);
	Game[playerid][RocketDM] = 1;
	Tele(playerid, "Rocket"); CargandoJuego(playerid);
	} else { SendClientMessage(playerid, -1, "* You do not have enough life to enter the game"); }
    }
    if(listitem == 3)
    {
	new Float:VerificarVida;
	GetPlayerHealth(playerid, VerificarVida);
	if(VerificarVida >= LaifJuegos) {
	new rand = random(sizeof(Minigun1));
	SetPlayerPos(playerid,Minigun1[rand][0], Minigun1[rand][1], Minigun1[rand][2]);
	ResetPlayerWeapons(playerid);
	SetPlayerInterior(playerid, 1);
	GivePlayerWeapon(playerid, 38, 10000);
	SetPlayerVirtualWorld(playerid,5);
	Game[playerid][MinigunDM] = 1;
	Tele(playerid, "Minigun");
	} else { SendClientMessage(playerid, -1, "* You do not have enough life to enter the game"); }
    }
    if(listitem == 4)
    {
	new Float:VerificarVida;
	GetPlayerHealth(playerid, VerificarVida);
	if(VerificarVida >= LaifJuegos)
	{
	new StrBox1[500];
	strcat(StrBox1, "{FFCC66}Choose the character you want to be:\n");
	strcat(StrBox1, "{FFFFFF}Zombies: {91EB00}200 of health - Weapons: Motosierra\n");
	strcat(StrBox1, "{FFFFFF}Humans: {91EB00}100 of want y 20 of armour - Weapons: DesertEagle,Escopeta,Ak47,Rifle\n");
	ShowPlayerDialog(playerid, ZombiesDialog, DIALOG_STYLE_MSGBOX, "Zombie Attack", StrBox1, "Zombies", "Humans");
	} else { SendClientMessage(playerid, -1, "* You do not have enough life to enter the game"); }
	}
	if(listitem == 5)
	{
	new Float:VerificarVida;
	GetPlayerHealth(playerid, VerificarVida);
	if(VerificarVida >= LaifJuegos)
	{
	new rand = random(sizeof(Minigun2));
	SetPlayerPos(playerid,Minigun2[rand][0], Minigun2[rand][1], Minigun2[rand][2]);
	ResetPlayerWeapons(playerid);
	SetPlayerInterior(playerid, 1);
	GivePlayerWeapon(playerid, 38, 10000);
	SetPlayerVirtualWorld(playerid,4);
	Game[playerid][Minigun2DM] = 1;
	Tele(playerid, "Minigun2");
	} else { SendClientMessage(playerid, -1, "* You do not have enough life to enter the game"); }
    }
    if(listitem == 6)
    {
	new xdxax[700];
	format(xdxax, sizeof(xdxax), "� {FF0000}AimHeadshot | Users: %d\n� {FF0000}CS_Bank | Users: %d\n� {FF0000}CS_Barron | Users: %d\n� {FF0000}CS_Compound | Users: %d\n� {FF0000}CS_Hospital | Users: %d\n� {FF0000}CS_House | Users: %d\n� {FF0000}CS_PD | Users: %d\n� {FF0000}CS_Ship | Users: %d\n� {FF0000}CS_Vill | Users: %d\n� {FF0000}De_Dust5 | Users: %d\n� {FF0000}CS_TnT | Users: %d"
	,UsersCS1(),UsersCS2(),UsersCS3(),UsersCS4(),UsersCS5(),UsersCS6(),UsersCS7(),UsersCS8(),UsersCS9(),UsersCS10(),UsersCS11());
	ShowPlayerDialog(playerid,ListaMapasCS,DIALOG_STYLE_LIST, "Counter Strike",xdxax,"Select","Exit");
	PlayerPlaySound(playerid,1139,0.0,0.0,0.0);
    }
    if(listitem == 7)
    {
	new Float:VerificarVida;
	GetPlayerHealth(playerid, VerificarVida);
	if(VerificarVida >= LaifJuegos)
	{
	new rand = random(sizeof(Rocket2));
	SetPlayerPos(playerid,Rocket2[rand][0], Rocket2[rand][1], Rocket2[rand][2]);
	ResetPlayerWeapons(playerid);
	SetPlayerInterior(playerid, 1);
	GivePlayerWeapon(playerid, 35, 9999);
	SetPlayerVirtualWorld(playerid,3);
	Game[playerid][RocketDM2] = 1;
	Tele(playerid, "Rocket2"); CargandoJuego(playerid);
	} else { SendClientMessage(playerid, -1, "* You do not have enough life to enter the game"); }
    }
	if(listitem == 8)
    {
	if(!IsPlayerInAnyVehicle(playerid))
    return SendClientMessage(playerid,-1,"{FF0000}** To enter this minigame spawn a monster with / v monster");
    if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 463)
    return SendClientMessage(playerid,-1,"{FF0000}** To enter this minigame spawn a monster with / v monster");
    FireShotON[playerid] = 1;
    Tele(playerid,"monsterdm");
    Game[playerid][MonsterDM] = 1;
    new vehicleid = GetPlayerVehicleID(playerid),State = GetPlayerState(playerid),rand = random(sizeof(MDM));
	if(IsPlayerInAnyVehicle(playerid) && State == PLAYER_STATE_DRIVER)
    return SetVehiclePos(vehicleid,MDM[rand][0], MDM[rand][1], MDM[rand][2]);

    SetPlayerPos(playerid, MDM[rand][0], MDM[rand][1], MDM[rand][2]);

	}
	}
	return 1;
	}
	if(dialogid == MapaCSeleccionado)
	{
	if(response == 1)
	{
	SetPlayerSkin(playerid, 73);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 22, 9999);
	GivePlayerWeapon(playerid, 25, 9999);
	GivePlayerWeapon(playerid, 28, 9999);
	GivePlayerWeapon(playerid, 30, 9999);
	GivePlayerWeapon(playerid, 33, 9999);
	SetPlayerPos(playerid ,3099.4692, -2064.5356, 29.9883);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap1] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "AimHeadShot"); CargandoJuego(playerid);
	return 1;
	}
	if(response == 0)
	{
	SetPlayerSkin(playerid, 285);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 9999);
	GivePlayerWeapon(playerid, 27, 9999);
	GivePlayerWeapon(playerid, 29, 9999);
	GivePlayerWeapon(playerid, 31, 9999);
	GivePlayerWeapon(playerid, 34, 9999);
	SetPlayerPos(playerid , 3127.8765, -1953.4105, 29.7298);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap1] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "AimHeadShot"); CargandoJuego(playerid);
	return 1;
	}
	}
	if(dialogid == MapaCSeleccionado+1)
	{
	if(response == 1)
	{
	SetPlayerSkin(playerid, 73);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 22, 9999);
	GivePlayerWeapon(playerid, 25, 9999);
	GivePlayerWeapon(playerid, 28, 9999);
	GivePlayerWeapon(playerid, 30, 9999);
	GivePlayerWeapon(playerid, 33, 9999);
	SetPlayerPos(playerid,1543.0106,-1649.9576,-25.5641);
	SetPlayerFacingAngle(playerid,88.8991);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap2] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Bank"); CargandoJuego(playerid);
	return 1;
	}
	if(response == 0)
	{
	SetPlayerSkin(playerid, 285);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 9999);
	GivePlayerWeapon(playerid, 27, 9999);
	GivePlayerWeapon(playerid, 29, 9999);
	GivePlayerWeapon(playerid, 31, 9999);
	GivePlayerWeapon(playerid, 34, 9999);
	SetPlayerPos(playerid,1522.8954,-1586.9799,-28.2123);
	SetPlayerFacingAngle(playerid,174.9541);
	Game[playerid][CSMap2] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Bank"); CargandoJuego(playerid);
	return 1;
	}
	}
	if(dialogid == MapaCSeleccionado+2)
	{
	if(response == 1)
	{
	SetPlayerSkin(playerid, 73);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 22, 9999);
	GivePlayerWeapon(playerid, 25, 9999);
	GivePlayerWeapon(playerid, 28, 9999);
	GivePlayerWeapon(playerid, 30, 9999);
	GivePlayerWeapon(playerid, 33, 9999);
	SetPlayerPos(playerid,-173.7432,-22.4266,3.1172);
	SetPlayerFacingAngle(playerid,70.0427);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap3] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Barron"); CargandoJuego(playerid);
	return 1;
	}
	if(response == 0)
	{
	SetPlayerSkin(playerid, 285);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 9999);
	GivePlayerWeapon(playerid, 27, 9999);
	GivePlayerWeapon(playerid, 29, 9999);
	GivePlayerWeapon(playerid, 31, 9999);
	GivePlayerWeapon(playerid, 34, 9999);
	SetPlayerPos(playerid,-247.7691,-20.1400,3.1172);
	SetPlayerFacingAngle(playerid,258.8486);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap3] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Barron"); CargandoJuego(playerid);
	return 1;
	}
	}
	if(dialogid == MapaCSeleccionado+3)
	{
	if(response == 1)
	{
	SetPlayerSkin(playerid, 73);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 22, 9999);
	GivePlayerWeapon(playerid, 25, 9999);
	GivePlayerWeapon(playerid, 28, 9999);
	GivePlayerWeapon(playerid, 30, 9999);
	GivePlayerWeapon(playerid, 33, 9999);
	SetPlayerPos(playerid , 1980.1952, 252.4269, 249.4551);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap4] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Compound"); CargandoJuego(playerid);
	return 1;
	}
	if(response == 0)
	{
	SetPlayerSkin(playerid, 285);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 9999);
	GivePlayerWeapon(playerid, 27, 9999);
	GivePlayerWeapon(playerid, 29, 9999);
	GivePlayerWeapon(playerid, 31, 9999);
	GivePlayerWeapon(playerid, 34, 9999);
	SetPlayerPos(playerid , 1877.3414, 336.6315, 248.8726);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap4] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Compound"); CargandoJuego(playerid);
	return 1;
	}
	}
	if(dialogid == MapaCSeleccionado+4)
	{
	if(response == 1)
	{
	SetPlayerSkin(playerid, 73);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 22, 9999);
	GivePlayerWeapon(playerid, 25, 9999);
	GivePlayerWeapon(playerid, 28, 9999);
	GivePlayerWeapon(playerid, 30, 9999);
	GivePlayerWeapon(playerid, 33, 9999);
	SetPlayerPos(playerid,1897.8322,85.5282,960.3094);
	SetPlayerFacingAngle(playerid,315.1511);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap5] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Hospital"); CargandoJuego(playerid);
	return 1;
	}
	if(response == 0)
	{
	SetPlayerSkin(playerid, 285);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 9999);
	GivePlayerWeapon(playerid, 27, 9999);
	GivePlayerWeapon(playerid, 29, 9999);
	GivePlayerWeapon(playerid, 31, 9999);
	GivePlayerWeapon(playerid, 34, 9999);
	SetPlayerPos(playerid,1941.1548,92.5686,960.3094);
	SetPlayerFacingAngle(playerid,93.8795);
	Game[playerid][CSMap5] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Hospital"); CargandoJuego(playerid);
	return 1;
	}
	}
	if(dialogid == MapaCSeleccionado+5)
	{
	if(response == 1)
	{
	SetPlayerSkin(playerid, 73);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 22, 9999);
	GivePlayerWeapon(playerid, 25, 9999);
	GivePlayerWeapon(playerid, 28, 9999);
	GivePlayerWeapon(playerid, 30, 9999);
	GivePlayerWeapon(playerid, 33, 9999);
	SetPlayerPos(playerid,-1427.6024,562.0229,1032.2534);
	SetPlayerFacingAngle(playerid,164.9947);
	Game[playerid][CSMap6] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_House"); CargandoJuego(playerid);
	return 1;
	}
	if(response == 0)
	{
	SetPlayerSkin(playerid, 285);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 9999);
	GivePlayerWeapon(playerid, 27, 9999);
	GivePlayerWeapon(playerid, 29, 9999);
	GivePlayerWeapon(playerid, 31, 9999);
	GivePlayerWeapon(playerid, 34, 9999);
	SetPlayerPos(playerid,-1405.0837,545.9390,1035.9259);
	SetPlayerFacingAngle(playerid,59.9146);
	Game[playerid][CSMap6] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_House"); CargandoJuego(playerid);
	return 1;
	}
	}
	if(dialogid == MapaCSeleccionado+6)
	{
	if(response == 1)
	{
	SetPlayerSkin(playerid, 73);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 22, 9999);
	GivePlayerWeapon(playerid, 25, 9999);
	GivePlayerWeapon(playerid, 28, 9999);
	GivePlayerWeapon(playerid, 30, 9999);
	GivePlayerWeapon(playerid, 33, 9999);
	SetPlayerPos(playerid,1476.7532,-1791.2219,3288.7859);
	SetPlayerFacingAngle(playerid,348.5796);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap7] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_PD"); CargandoJuego(playerid);
	return 1;
	}
	if(response == 0)
	{
	SetPlayerSkin(playerid, 285);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 9999);
	GivePlayerWeapon(playerid, 27, 9999);
	GivePlayerWeapon(playerid, 29, 9999);
	GivePlayerWeapon(playerid, 31, 9999);
	GivePlayerWeapon(playerid, 34, 9999);
	SetPlayerPos(playerid,1475.5542,-1751.7849,3285.2859);
	SetPlayerFacingAngle(playerid,173.4948);
	Game[playerid][CSMap7] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_PD"); CargandoJuego(playerid);
	return 1;
	}
	}
	if(dialogid == MapaCSeleccionado+7)
	{
	if(response == 1)
	{
	SetPlayerSkin(playerid, 73);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 22, 9999);
	GivePlayerWeapon(playerid, 25, 9999);
	GivePlayerWeapon(playerid, 28, 9999);
	GivePlayerWeapon(playerid, 30, 9999);
	GivePlayerWeapon(playerid, 33, 9999);
	SetPlayerPos(playerid,473.4067,-2294.1711,16.0266);
	SetPlayerFacingAngle(playerid,84.6665);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap8] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Ship"); CargandoJuego(playerid);
	return 1;
	}
	if(response == 0)
	{
	SetPlayerSkin(playerid, 285);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 9999);
	GivePlayerWeapon(playerid, 27, 9999);
	GivePlayerWeapon(playerid, 29, 9999);
	GivePlayerWeapon(playerid, 31, 9999);
	GivePlayerWeapon(playerid, 34, 9999);
	SetPlayerPos(playerid,325.7214,-2309.9575,14.5813);
	SetPlayerFacingAngle(playerid,309.3520);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap8] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Ship"); CargandoJuego(playerid);
	return 1;
	}
	}
	if(dialogid == MapaCSeleccionado+8)
	{
	if(response == 1)
	{
	SetPlayerSkin(playerid, 73);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 22, 9999);
	GivePlayerWeapon(playerid, 25, 9999);
	GivePlayerWeapon(playerid, 28, 9999);
	GivePlayerWeapon(playerid, 30, 9999);
	GivePlayerWeapon(playerid, 33, 9999);
	SetPlayerPos(playerid,752.0549,-3310.9387,25.6988);
	SetPlayerFacingAngle(playerid,110.4959);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap9] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Tnt"); CargandoJuego(playerid);
	return 1;
	}
	if(response == 0)
	{
	SetPlayerSkin(playerid, 285);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 9999);
	GivePlayerWeapon(playerid, 27, 9999);
	GivePlayerWeapon(playerid, 29, 9999);
	GivePlayerWeapon(playerid, 31, 9999);
	GivePlayerWeapon(playerid, 34, 9999);
	SetPlayerPos(playerid,599.7078,-3304.0002,19.9305);
	SetPlayerFacingAngle(playerid,270.0491);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap9] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Tnt"); CargandoJuego(playerid);
	return 1;
	}
	}
	if(dialogid == MapaCSeleccionado+9)
	{
	if(response == 1)
	{
	SetPlayerSkin(playerid, 73);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 22, 9999);
	GivePlayerWeapon(playerid, 25, 9999);
	GivePlayerWeapon(playerid, 28, 9999);
	GivePlayerWeapon(playerid, 30, 9999);
	GivePlayerWeapon(playerid, 33, 9999);
	SetPlayerPos(playerid,-1666.5732,-416.8023,265.9619);
	SetPlayerFacingAngle(playerid,324.8113);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap10] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Vill"); CargandoJuego(playerid);
	return 1;
	}
	if(response == 0)
	{
	SetPlayerSkin(playerid, 285);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 9999);
	GivePlayerWeapon(playerid, 27, 9999);
	GivePlayerWeapon(playerid, 29, 9999);
	GivePlayerWeapon(playerid, 31, 9999);
	GivePlayerWeapon(playerid, 34, 9999);
	SetPlayerPos(playerid,-1482.0507,-309.9048,265.9619);
	SetPlayerFacingAngle(playerid,146.3022);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap10] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "CS_Vill"); CargandoJuego(playerid);
	return 1;
	}
	}
	if(dialogid == MapaCSeleccionado+10)
	{
	if(response == 1)
	{
	SetPlayerSkin(playerid, 73);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 22, 9999);
	GivePlayerWeapon(playerid, 25, 9999);
	GivePlayerWeapon(playerid, 28, 9999);
	GivePlayerWeapon(playerid, 30, 9999);
	GivePlayerWeapon(playerid, 33, 9999);
	SetPlayerPos(playerid,543.9832,-2481.4565,12.3350);
	SetPlayerFacingAngle(playerid,97.4008);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap11] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "De_Dust3"); CargandoJuego(playerid);
	return 1;
	}
	if(response == 0)
	{
	SetPlayerSkin(playerid, 285);
	ResetPlayerWeapons(playerid);
	GivePlayerWeapon(playerid, 24, 9999);
	GivePlayerWeapon(playerid, 27, 9999);
	GivePlayerWeapon(playerid, 29, 9999);
	GivePlayerWeapon(playerid, 31, 9999);
	GivePlayerWeapon(playerid, 34, 9999);
	SetPlayerPos(playerid,445.0026,-2504.4465,12.3350);
	SetPlayerFacingAngle(playerid,58.2572);
	SetPlayerInterior(playerid , 0);
	Game[playerid][CSMap11] = 1; Game[playerid][Counter] = 1;
	EnviarTeleCS(playerid, "De_Dust3"); CargandoJuego(playerid);
	return 1;
	}
	}
	return 1;
}
/*Stocks*/
stock UsersZombieAttack()
{
	new ZombiesCount;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][Zhomviez] == 1) {
	ZombiesCount++;
	}
	return ZombiesCount;
}

stock UsersZonaWW()
{
	new Gaim1;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][ZonaWW] == 1) {
	Gaim1++;
	}
	return Gaim1;
}

stock UsersZonaRW()
{
	new Gaim2;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][ZonaRW] == 1) {
	Gaim2++;
	}
	return Gaim2;
}

stock UsersRocket()
{
	new Gaim3;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][RocketDM] == 1) {
	Gaim3++;
	}
	return Gaim3;
}

stock UsersRocket2()
{
	new Gaim4;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][RocketDM2] == 1) {
	Gaim4++;
	}
	return Gaim4;
}

stock UsersMinigun()
{
	new Gaim14;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][MinigunDM] == 1) {
	Gaim14++;
	}
	return Gaim14;
}

stock UsersMinigun2()
	{
	new Gaim5;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][Minigun2DM] == 1) {
	Gaim5++;
	}
	return Gaim5;
}

stock UsersMDM()
{
	new Gaim6;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][MonsterDM] == 1) {
	Gaim6++;
	}
	return Gaim6;
}

stock UsersCS1()
{
	new Gaim7;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][CSMap1] == 1) {
	Gaim7++;
	}
	return Gaim7;
}

stock UsersCS2()
{
	new Gaim8;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][CSMap2] == 1) {
	Gaim8++;
	}
	return Gaim8;
}

stock UsersCS3()
{
	new Gaim9;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][CSMap3] == 1) {
	Gaim9++;
	}
	return Gaim9;
}

stock UsersCS4()
{
	new Gaim10;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][CSMap4] == 1) {
	Gaim10++;
	}
	return Gaim10;
}

stock UsersCS5()
{
	new Gaim11;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][CSMap5] == 1) {
	Gaim11++;
	}
	return Gaim11;
}

stock UsersCS6()
{
	new Gaim12;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][CSMap6] == 1) {
	Gaim12++;
	}
	return Gaim12;
}

stock UsersCS7()
{
	new Gaim13;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][CSMap7] == 1) {
	Gaim13++;
	}
	return Gaim13;
}

stock UsersCS8()
{
	new Gaim15;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][CSMap8] == 1) {
	Gaim15++;
	}
	return Gaim15;
}

stock UsersCS9()
{
	new Gaim16;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][CSMap9] == 1) {
	Gaim16++;
	}
	return Gaim16;
}

stock UsersCS10()
{
	new Gaim17;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][CSMap10] == 1) {
	Gaim17++;
	}
	return Gaim17;
}

stock UsersCS11()
{
	new Gaim18;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][CSMap11] == 1) {
	Gaim18++;
	}
	return Gaim18;
}

stock UsersCS()
{
	new Gaim20;
	for(new i, g = GetMaxPlayers(); i < g; i++)
	if(IsPlayerConnected(i))
	if(Game[i][Counter] == 1) {
	Gaim20++;
	}
	return Gaim20;
}
stock CargarObjetos()
{
	/*CREDITS FOR MAPS FORUM-SAMP*/
	//AimHeadShot
	CreateDynamicObject(5172, 3098.69995, -2002.69995, 26.20000,   0.00000, 351.50000, 0.00000);
	CreateDynamicObject(5172, 3100.10010, -1989.59998, 5.00000,   0.00000, 72.49646, 0.00000);
	CreateDynamicObject(5172, 3120.23193, -1954.77771, 5.00000,   0.00000, 72.49329, 269.75000);
	CreateDynamicObject(5172, 3130.92944, -2024.61023, 5.00000,   0.00000, 72.49330, 180.00000);
	CreateDynamicObject(5172, 3117.10010, -1921.69995, 32.70000,   0.00000, 352.73779, 269.74731);
	CreateDynamicObject(5172, 3117.71729, -2066.51050, 4.71534,   0.00000, 85.73785, 90.64733);
	CreateDynamicObject(18360, 3117.30005, -1962.80005, 40.30000,   279.03162, 175.21533, 1.77505);
	CreateDynamicObject(18360, 3106.80005, -2051.80005, 39.20000,   296.58826, 174.96533, 180.75085);
	CreateDynamicObject(5172, 3130.80005, -2095.89990, 35.80000,   0.00000, 341.48254, 270.24182);
	CreateDynamicObject(18257, 3099.69995, -2038.00000, 22.90000,   0.00000, 0.00000, 182.00000);
	CreateDynamicObject(18257, 3130.50000, -1981.50000, 22.90000,   0.00000, 0.00000, 355.99951);
	CreateDynamicObject(2991, 3111.10010, -1976.59998, 23.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2991, 3111.10010, -1976.59998, 24.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2991, 3115.19995, -2038.00000, 23.60000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2991, 3115.19995, -2038.09998, 24.90000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2973, 3122.19995, -2038.80005, 23.00000,   0.00000, 0.00000, 340.00000);
	CreateDynamicObject(2973, 3125.50000, -2039.19995, 23.00000,   0.00000, 0.00000, 5.99939);
	CreateDynamicObject(2973, 3102.69995, -1976.69995, 22.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2973, 3099.60010, -1977.30005, 22.70000,   0.00000, 0.00000, 22.00000);
	CreateDynamicObject(18257, 3116.80005, -1965.50000, 22.70000,   0.00000, 0.00000, 351.99548);
	CreateDynamicObject(2912, 3125.10010, -1980.80005, 26.90000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2912, 3110.00000, -1976.69995, 25.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1271, 3131.30005, -1978.90002, 25.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1271, 3110.10010, -1964.30005, 27.10000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(18257, 3115.80005, -2053.39990, 22.90000,   0.00000, 0.00000, 171.99951);
	CreateDynamicObject(1271, 3125.60010, -2038.80005, 25.80000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1271, 3114.69995, -2038.09998, 25.90000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1271, 3120.80005, -2054.00000, 27.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(1431, 3124.19995, -2037.19995, 23.60000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2038, 3125.60010, -2039.00000, 26.20000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(3798, 3133.80005, -2040.19995, 23.10000,   0.00000, 0.00000, 346.00000);
	CreateDynamicObject(3798, 3131.19995, -2039.59998, 23.10000,   0.00000, 0.00000, 25.99792);
	CreateDynamicObject(10244, 3096.60010, -2055.10010, 25.40000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(10244, 3136.19995, -2054.69995, 24.30000,   0.00000, 0.00000, 270.00000);
	CreateDynamicObject(10244, 3133.39990, -1962.59998, 25.20000,   0.00000, 0.00000, 90.00000);
	CreateDynamicObject(10244, 3095.89990, -1963.19995, 24.80000,   0.00000, 0.00000, 92.00000);
	CreateDynamicObject(8651, 3113.10010, -1960.19995, 28.70000,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(8651, 3116.60010, -1960.09998, 28.70000,   0.00000, 0.00000, 91.00000);
	CreateDynamicObject(2991, 3100.19995, -1958.69995, 29.40000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2991, 3100.30005, -1958.69995, 30.70000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2991, 3123.80005, -1958.40002, 29.30000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2991, 3123.69995, -1958.40002, 30.60000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2973, 3115.80005, -1957.69995, 28.70000,   0.00000, 0.00000, 21.99463);
	CreateDynamicObject(8651, 3119.19995, -2057.80005, 29.00000,   0.00000, 0.00000, 90.75000);
	CreateDynamicObject(8651, 3113.80005, -2057.80005, 29.00000,   0.00000, 0.00000, 90.74707);
	CreateDynamicObject(3798, 3121.10010, -2059.89990, 28.90000,   0.00000, 0.00000, 345.99792);
	CreateDynamicObject(3798, 3120.80005, -2060.00000, 30.90000,   0.00000, 0.00000, 345.99792);
	CreateDynamicObject(3798, 3106.80005, -2060.00000, 28.90000,   0.00000, 0.00000, 43.99792);
	CreateDynamicObject(2991, 3113.19995, -2059.69995, 29.50000,   0.00000, 0.00000, 0.00000);
	CreateDynamicObject(2991, 3113.19995, -2059.80005, 30.80000,   0.00000, 0.00000, 0.00000);
//CS_Bank
	CreateDynamicObject(19458, 1519.46, -1649.37, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1515.98, -1649.36, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1519.42, -1640.01, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1516.00, -1639.99, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1522.93, -1587.99, -29.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1549.81, -1615.77, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1553.30, -1615.79, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1556.78, -1615.76, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1560.24, -1615.77, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1563.74, -1615.75, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1567.17, -1615.75, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1570.65, -1615.77, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1574.11, -1615.82, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1577.58, -1615.86, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1574.15, -1625.24, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1577.65, -1625.23, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1570.66, -1625.22, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1567.21, -1625.21, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1563.71, -1625.25, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1560.25, -1625.24, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1556.76, -1625.24, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1553.29, -1625.25, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19458, 1549.85, -1625.25, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(14877, 1522.78, -1589.92, -28.69,   0.00, 0.00, 270.00);
	CreateDynamicObject(19461, 1504.91, -1622.45, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1504.88, -1609.75, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1504.90, -1632.08, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1500.23, -1631.32, -24.89,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19461, 1500.11, -1612.27, -24.89,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19458, 1521.15, -1588.84, -28.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(19458, 1524.40, -1588.47, -28.30,   0.00, 0.00, 0.00);
	CreateDynamicObject(19458, 1522.90, -1583.96, -27.96,   -90.00, 90.00, 0.00);
	CreateDynamicObject(19461, 1548.17, -1610.55, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1548.11, -1623.27, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1548.09, -1632.85, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1552.85, -1629.86, -24.89,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19461, 1562.28, -1629.85, -24.89,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19461, 1571.87, -1629.84, -24.89,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19461, 1581.29, -1629.85, -24.89,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19461, 1552.98, -1611.09, -24.89,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19461, 1562.53, -1611.06, -24.89,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19461, 1572.06, -1611.06, -24.89,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19461, 1581.37, -1611.07, -24.89,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19461, 1579.22, -1625.61, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1579.25, -1615.98, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19415, 1500.18, -1619.33, -24.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(19415, 1500.21, -1622.45, -24.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(19415, 1500.21, -1625.65, -24.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(19415, 1500.23, -1628.80, -24.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(19442, 1501.05, -1620.94, -24.94,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19442, 1500.99, -1623.96, -24.94,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19442, 1501.11, -1627.28, -24.94,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19442, 1501.11, -1630.32, -24.94,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19442, 1500.99, -1617.82, -24.94,   -180.00, 0.00, 90.00);
	CreateDynamicObject(19447, 1490.65, -1631.32, -24.88,   0.00, 0.00, 90.00);
	CreateDynamicObject(19447, 1481.15, -1631.32, -24.88,   0.00, 0.00, 90.00);
	CreateDynamicObject(19447, 1472.55, -1631.33, -24.88,   0.00, 0.00, 90.00);
	CreateDynamicObject(19447, 1490.68, -1612.26, -24.88,   0.00, 0.00, 90.00);
	CreateDynamicObject(19447, 1481.22, -1612.27, -24.88,   0.00, 0.00, 90.00);
	CreateDynamicObject(19447, 1471.75, -1612.25, -24.88,   0.00, 0.00, 90.00);
	CreateDynamicObject(19447, 1473.59, -1616.97, -24.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(19447, 1473.62, -1626.50, -24.88,   0.00, 0.00, 0.00);
	CreateDynamicObject(2049, 1487.51, -1621.00, -26.16,   0.00, 0.00, 90.00);
	CreateDynamicObject(19442, 1487.39, -1620.90, -26.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(19442, 1476.35, -1626.75, -26.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(19442, 1481.71, -1623.26, -26.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(19442, 1479.30, -1614.85, -26.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(19442, 1479.96, -1619.84, -26.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(19442, 1485.23, -1616.80, -26.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(2049, 1485.37, -1616.80, -25.64,   0.00, 0.00, 90.00);
	CreateDynamicObject(2049, 1480.13, -1619.83, -25.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(2049, 1481.89, -1623.28, -26.16,   0.00, 0.00, 90.00);
	CreateDynamicObject(2049, 1479.44, -1614.83, -25.12,   0.00, 0.00, 90.00);
	CreateDynamicObject(2049, 1476.53, -1626.90, -25.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, 1504.90, -1616.03, -24.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19397, 1548.12, -1616.85, -24.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1521.25, -1649.22, -27.09,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1521.26, -1639.66, -27.09,   0.00, 0.00, 0.00);
	CreateDynamicObject(3850, 1529.04, -1654.06, -24.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(3850, 1525.57, -1654.05, -24.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(3850, 1522.18, -1654.06, -24.73,   0.00, 0.00, 90.00);
	CreateDynamicObject(1536, 1545.25, -1651.25, -26.55,   0.00, 0.00, 90.00);
	CreateDynamicObject(1536, 1545.22, -1648.29, -26.55,   0.00, 0.00, 270.00);
	CreateDynamicObject(3051, 1528.28, -1584.34, -25.23,   0.00, 0.00, -45.00);
	CreateDynamicObject(3051, 1527.10, -1584.31, -25.23,   0.00, 0.00, 134.00);
	CreateDynamicObject(1491, 1515.31, -1635.25, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(1491, 1514.46, -1647.11, -26.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(1491, 1514.43, -1616.83, -26.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(1491, 1504.98, -1616.77, -26.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(1491, 1538.51, -1617.65, -26.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(1491, 1548.08, -1617.62, -26.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(1491, 1536.08, -1609.96, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(1491, 1521.96, -1609.82, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(1491, 1515.34, -1609.74, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1544.95, -1651.60, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1544.94, -1648.05, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1531.23, -1653.96, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1537.93, -1654.16, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1521.69, -1663.17, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1521.76, -1635.74, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1534.54, -1635.83, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1537.91, -1635.59, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1537.87, -1634.31, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1534.63, -1628.37, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1518.45, -1628.30, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1514.96, -1615.03, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1514.99, -1610.07, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1521.83, -1610.06, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1535.60, -1610.35, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1538.29, -1615.70, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1525.07, -1602.63, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1530.96, -1602.58, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1524.42, -1594.13, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1529.22, -1585.05, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1526.19, -1584.90, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1517.36, -1586.62, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1515.93, -1584.84, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1497.60, -1584.56, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1497.70, -1602.60, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1513.80, -1602.69, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1543.64, -1605.30, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1538.93, -1605.22, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(19397, 1553.07, -1618.49, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, 1556.27, -1618.47, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, 1559.49, -1618.46, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, 1562.55, -1618.47, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, 1565.40, -1618.45, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, 1568.58, -1618.43, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, 1571.77, -1618.44, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, 1574.96, -1618.44, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, 1578.05, -1618.44, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, 1576.01, -1623.38, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1573.13, -1623.27, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1570.23, -1623.24, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1563.96, -1623.29, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1560.92, -1623.37, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1557.71, -1623.36, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1554.51, -1623.36, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19461, 1551.41, -1623.22, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19415, 1552.95, -1628.00, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19415, 1556.09, -1628.03, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19415, 1559.17, -1628.03, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19415, 1562.46, -1628.01, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19415, 1565.60, -1628.02, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, 1567.04, -1623.33, -24.89,   -180.00, 0.00, 0.00);
	CreateDynamicObject(19415, 1568.69, -1627.96, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19415, 1571.61, -1627.96, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19415, 1574.51, -1627.94, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(19415, 1577.63, -1627.94, -24.98,   0.00, 0.00, 90.00);
	CreateDynamicObject(2949, 1553.79, -1618.44, -26.61,   0.00, 0.00, 270.00);
	CreateDynamicObject(2949, 1556.97, -1618.40, -26.61,   0.00, 0.00, 270.00);
	CreateDynamicObject(2949, 1560.21, -1618.40, -26.61,   0.00, 0.00, 270.00);
	CreateDynamicObject(2949, 1563.28, -1618.41, -26.61,   0.00, 0.00, 270.00);
	CreateDynamicObject(2949, 1566.11, -1618.35, -26.61,   0.00, 0.00, 270.00);
	CreateDynamicObject(2949, 1569.31, -1618.37, -26.61,   0.00, 0.00, 270.00);
	CreateDynamicObject(2949, 1572.49, -1618.35, -26.61,   0.00, 0.00, 270.00);
	CreateDynamicObject(2949, 1575.67, -1618.36, -26.61,   0.00, 0.00, 270.00);
	CreateDynamicObject(2949, 1578.71, -1618.37, -26.61,   0.00, 0.00, 270.00);
	CreateDynamicObject(2010, 1548.61, -1629.15, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1578.70, -1611.61, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1548.67, -1611.71, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(1801, 1559.17, -1622.94, -26.64,   0.00, 0.00, -180.00);
	CreateDynamicObject(1801, 1562.47, -1622.78, -26.64,   0.00, 0.00, -180.00);
	CreateDynamicObject(1801, 1565.49, -1622.92, -26.64,   0.00, 0.00, -180.00);
	CreateDynamicObject(1801, 1568.59, -1622.92, -26.64,   0.00, 0.00, -180.00);
	CreateDynamicObject(1801, 1571.73, -1623.04, -26.64,   0.00, 0.00, -180.00);
	CreateDynamicObject(1801, 1574.69, -1623.05, -26.64,   0.00, 0.00, -180.00);
	CreateDynamicObject(1801, 1577.61, -1623.10, -26.64,   0.00, 0.00, -180.00);
	CreateDynamicObject(1801, 1555.99, -1622.94, -26.64,   0.00, 0.00, -180.00);
	CreateDynamicObject(1801, 1552.91, -1622.90, -26.64,   0.00, 0.00, -180.00);
	CreateDynamicObject(2198, 1527.50, -1613.09, -26.59,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1530.74, -1613.21, -26.59,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1533.53, -1613.62, -26.59,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1525.72, -1617.46, -26.53,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1529.18, -1617.94, -26.59,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1532.68, -1618.60, -26.53,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1524.54, -1621.21, -26.59,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1528.39, -1622.07, -26.59,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1531.85, -1622.75, -26.59,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1531.22, -1626.54, -26.59,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1527.16, -1625.87, -26.59,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1523.04, -1625.63, -26.53,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1519.07, -1613.90, -26.59,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1518.70, -1618.54, -26.53,   0.00, 0.00, 46.00);
	CreateDynamicObject(2198, 1518.40, -1622.95, -26.53,   0.00, 0.00, 46.00);
	CreateDynamicObject(1806, 1526.90, -1617.87, -26.58,   0.00, 0.00, 47.00);
	CreateDynamicObject(1806, 1525.73, -1621.59, -26.58,   0.00, 0.00, 44.00);
	CreateDynamicObject(1806, 1530.06, -1618.41, -26.58,   0.00, 0.00, 40.00);
	CreateDynamicObject(1806, 1529.18, -1622.50, -26.58,   0.00, 0.00, 47.00);
	CreateDynamicObject(1806, 1527.91, -1626.14, -26.58,   0.00, 0.00, 40.00);
	CreateDynamicObject(1806, 1523.73, -1626.07, -26.58,   0.00, 0.00, 47.00);
	CreateDynamicObject(1806, 1519.27, -1623.04, -26.58,   0.00, 0.00, 47.00);
	CreateDynamicObject(1806, 1531.93, -1626.91, -26.58,   0.00, 0.00, 33.00);
	CreateDynamicObject(1806, 1532.74, -1623.03, -26.58,   0.00, 0.00, 47.00);
	CreateDynamicObject(1806, 1533.51, -1618.78, -26.58,   0.00, 0.00, 40.00);
	CreateDynamicObject(1806, 1534.44, -1613.93, -26.58,   0.00, 0.00, 42.00);
	CreateDynamicObject(1806, 1531.70, -1613.48, -26.58,   0.00, 0.00, 55.00);
	CreateDynamicObject(1806, 1528.49, -1613.16, -26.58,   0.00, 0.00, 47.00);
	CreateDynamicObject(1806, 1519.56, -1618.48, -26.58,   0.00, 0.00, 47.00);
	CreateDynamicObject(1806, 1519.89, -1613.94, -26.58,   0.00, 0.00, 47.00);
	CreateDynamicObject(2164, 1533.90, -1609.98, -26.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(2164, 1532.14, -1609.99, -26.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(2164, 1530.42, -1609.98, -26.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(2164, 1528.64, -1609.99, -26.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(2164, 1526.87, -1609.98, -26.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(2164, 1525.14, -1609.99, -26.61,   0.00, 0.00, 0.00);
	CreateDynamicObject(2612, 1514.53, -1620.90, -25.12,   0.00, 0.00, 90.00);
	CreateDynamicObject(2611, 1514.53, -1622.48, -25.11,   0.00, 0.00, 90.00);
	CreateDynamicObject(2611, 1514.54, -1624.06, -25.11,   0.00, 0.00, 90.00);
	CreateDynamicObject(2611, 1514.55, -1625.62, -25.11,   0.00, 0.00, 90.00);
	CreateDynamicObject(2611, 1514.55, -1612.15, -25.11,   0.00, 0.00, 90.00);
	CreateDynamicObject(2606, 1528.08, -1628.57, -24.71,   0.00, 0.00, 180.00);
	CreateDynamicObject(2606, 1530.06, -1628.56, -24.71,   0.00, 0.00, 180.00);
	CreateDynamicObject(2616, 1525.45, -1628.74, -24.70,   0.00, 0.00, 180.00);
	CreateDynamicObject(2310, 1521.71, -1639.02, -26.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(2310, 1521.56, -1642.76, -26.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(2310, 1521.64, -1647.76, -26.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(2604, 1518.98, -1637.29, -26.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(2604, 1518.95, -1642.70, -26.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(2604, 1519.00, -1648.15, -26.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(2310, 1520.12, -1648.01, -26.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(2310, 1520.25, -1642.86, -26.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(2310, 1520.37, -1638.71, -26.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(2310, 1511.23, -1587.03, -26.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(2310, 1510.40, -1586.97, -26.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(2310, 1509.38, -1586.94, -26.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(2310, 1508.38, -1586.90, -26.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(2310, 1507.27, -1586.84, -26.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(2208, 1508.56, -1588.14, -26.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(2208, 1505.70, -1588.13, -26.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1506.26, -1586.89, -26.18,   0.00, 0.00, 90.00);
	CreateDynamicObject(2310, 1506.26, -1589.12, -26.18,   0.00, 0.00, -90.00);
	CreateDynamicObject(2310, 1507.32, -1589.13, -26.18,   0.00, 0.00, -90.00);
	CreateDynamicObject(2310, 1508.31, -1589.15, -26.18,   0.00, 0.00, -90.00);
	CreateDynamicObject(2310, 1509.32, -1589.06, -26.18,   0.00, 0.00, -90.00);
	CreateDynamicObject(2310, 1510.34, -1589.02, -26.18,   0.00, 0.00, -90.00);
	CreateDynamicObject(2310, 1511.20, -1588.99, -26.18,   0.00, 0.00, -90.00);
	CreateDynamicObject(2310, 1504.68, -1588.07, -26.18,   0.00, 0.00, 900.00);
	CreateDynamicObject(1491, 1515.37, -1590.90, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2611, 1508.49, -1590.89, -25.16,   0.00, 0.00, 180.00);
	CreateDynamicObject(2611, 1509.97, -1590.89, -25.16,   0.00, 0.00, 180.00);
	CreateDynamicObject(2611, 1506.98, -1590.88, -25.16,   0.00, 0.00, 180.00);
	CreateDynamicObject(3077, 1501.85, -1587.84, -26.47,   0.00, 0.00, -90.00);
	CreateDynamicObject(2630, 1510.18, -1592.21, -26.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2628, 1510.39, -1600.82, -26.53,   0.00, 0.00, 135.00);
	CreateDynamicObject(2627, 1507.20, -1599.99, -26.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(2628, 1502.50, -1593.40, -26.53,   0.00, 0.00, 47.00);
	CreateDynamicObject(2628, 1504.27, -1593.23, -26.53,   0.00, 0.00, 47.00);
	CreateDynamicObject(2628, 1506.79, -1592.86, -26.53,   0.00, 0.00, 47.00);
	CreateDynamicObject(2627, 1504.54, -1599.79, -26.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(2627, 1502.23, -1599.70, -26.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(1491, 1514.42, -1594.57, -26.58,   0.00, 0.00, 90.00);
	CreateDynamicObject(2631, 1499.18, -1594.92, -26.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2631, 1499.16, -1597.47, -26.57,   0.00, 0.00, 0.00);
	CreateDynamicObject(2390, 1508.02, -1591.30, -25.42,   0.00, 0.00, 0.00);
	CreateDynamicObject(2390, 1508.71, -1591.33, -25.42,   0.00, 0.00, 0.00);
	CreateDynamicObject(2371, 1543.59, -1598.90, -26.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(2371, 1543.50, -1603.15, -26.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(2371, 1543.53, -1601.03, -26.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(2390, 1543.66, -1598.10, -25.87,   -22.58, 0.00, -0.06);
	CreateDynamicObject(2394, 1543.59, -1600.44, -25.74,   0.00, 0.00, 91.00);
	CreateDynamicObject(2394, 1543.55, -1602.66, -25.74,   0.00, 0.00, 91.00);
	CreateDynamicObject(1703, 1526.00, -1654.85, -26.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(1703, 1523.50, -1654.83, -26.62,   0.00, 0.00, 0.00);
	CreateDynamicObject(1703, 1521.91, -1658.66, -26.62,   0.00, 0.00, 90.00);
	CreateDynamicObject(1703, 1527.93, -1602.41, -26.62,   0.00, 0.00, 180.00);
	CreateDynamicObject(1703, 1530.41, -1602.40, -26.62,   0.00, 0.00, 180.00);
	CreateDynamicObject(3077, 1486.54, -1646.86, -26.47,   0.00, 0.00, -90.00);
	CreateDynamicObject(2208, 1488.59, -1648.04, -26.62,   0.00, 0.00, 90.00);
	CreateDynamicObject(2310, 1500.88, -1644.80, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1500.79, -1645.90, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1500.73, -1648.14, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1500.72, -1649.22, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1498.54, -1648.22, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1498.54, -1649.14, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1496.63, -1649.15, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1496.66, -1648.07, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1498.80, -1645.61, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1498.92, -1644.58, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1496.75, -1645.61, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1496.77, -1644.56, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1494.33, -1644.60, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1494.29, -1645.78, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1494.38, -1648.04, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1494.31, -1649.08, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1492.03, -1649.07, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1492.05, -1648.07, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1492.17, -1644.57, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(2310, 1492.15, -1645.73, -26.18,   0.00, 0.00, 0.00);
	CreateDynamicObject(3850, 1490.87, -1644.27, -26.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(3850, 1490.69, -1649.51, -26.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(3850, 1501.45, -1644.42, -26.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(3850, 1501.40, -1649.25, -26.22,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1502.12, -1645.90, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1501.91, -1647.90, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1490.48, -1645.60, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1490.29, -1648.00, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(1703, 1528.43, -1662.72, -26.62,   0.00, 0.00, 2700.00);
	CreateDynamicObject(1703, 1530.92, -1662.72, -26.62,   0.00, 0.00, 2700.00);
	CreateDynamicObject(1703, 1533.40, -1662.75, -26.62,   0.00, 0.00, 2700.00);
	CreateDynamicObject(1703, 1535.88, -1662.76, -26.62,   0.00, 0.00, 2700.00);
	CreateDynamicObject(2163, 1539.13, -1596.46, -26.59,   0.00, 0.00, 9000.00);
	CreateDynamicObject(1359, 1543.35, -1604.21, -25.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(1359, 1533.65, -1628.30, -25.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(1359, 1522.24, -1655.55, -25.82,   0.00, 0.00, 0.00);
	CreateDynamicObject(2690, 1522.05, -1654.24, -26.02,   0.00, 0.00, 0.00);
	CreateDynamicObject(2690, 1519.98, -1635.52, -24.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(1808, 1528.89, -1654.49, -26.56,   0.00, 0.00, 0.00);
	CreateDynamicObject(2610, 1536.46, -1596.64, -25.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(2610, 1537.40, -1596.65, -25.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1535.66, -1597.21, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2610, 1537.88, -1596.64, -25.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(2610, 1536.93, -1596.65, -25.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(2610, 1538.38, -1596.64, -25.74,   0.00, 0.00, 0.00);
	CreateDynamicObject(2614, 1521.39, -1645.22, -26.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(2614, 1521.39, -1640.84, -26.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(2614, 1521.39, -1640.84, -26.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(2614, 1521.40, -1650.16, -26.21,   0.00, 0.00, 90.00);
	CreateDynamicObject(1557, 1522.03, -1584.04, -29.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(2690, 1539.78, -1605.68, -25.37,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1522.70, -1628.91, -24.95,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1530.12, -1628.91, -24.95,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1529.28, -1609.89, -24.95,   0.00, 0.00, -90.00);
	CreateDynamicObject(19431, 1534.41, -1609.88, -24.96,   0.00, 0.00, 90.00);
	CreateDynamicObject(19431, 1520.21, -1609.78, -24.96,   0.00, 0.00, 90.00);
	CreateDynamicObject(19431, 1518.64, -1609.78, -24.96,   0.00, 0.00, 90.00);
	CreateDynamicObject(19450, 1521.10, -1605.05, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1521.09, -1595.52, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1521.09, -1586.09, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1524.41, -1588.86, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1531.38, -1588.92, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1531.38, -1598.45, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1524.38, -1605.17, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1535.21, -1605.18, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1535.22, -1595.70, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1544.25, -1600.81, -25.12,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1538.55, -1610.49, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1538.41, -1623.27, -25.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1538.42, -1632.80, -25.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1538.42, -1639.78, -25.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1545.33, -1649.19, -25.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1538.46, -1658.74, -25.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1521.17, -1658.87, -25.03,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1514.42, -1652.80, -25.11,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1514.41, -1639.95, -24.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1514.40, -1630.55, -24.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1514.40, -1622.53, -24.98,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1514.39, -1609.67, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1514.39, -1600.17, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19431, 1514.38, -1591.56, -24.96,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1517.76, -1605.07, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1517.76, -1595.53, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1517.77, -1586.15, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1486.02, -1646.86, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1504.92, -1652.88, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1504.78, -1639.80, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1535.01, -1630.58, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1517.80, -1630.56, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1522.67, -1635.29, -24.95,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1530.17, -1635.31, -24.95,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1543.18, -1653.99, -25.03,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1543.28, -1644.49, -25.03,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1516.46, -1654.12, -25.12,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1525.98, -1663.64, -25.03,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1534.88, -1663.64, -25.03,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1509.65, -1648.11, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1509.52, -1644.62, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1500.41, -1651.57, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1490.82, -1651.57, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1500.11, -1642.46, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1490.56, -1642.45, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1543.35, -1618.50, -25.12,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1543.39, -1615.24, -25.12,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1539.83, -1596.14, -25.12,   0.00, 0.00, -90.00);
	CreateDynamicObject(2163, 1541.15, -1596.50, -26.59,   0.00, 0.00, 9000.00);
	CreateDynamicObject(2163, 1541.13, -1596.49, -25.70,   0.00, 0.00, 9000.00);
	CreateDynamicObject(2163, 1539.11, -1596.45, -25.67,   0.00, 0.00, 9000.00);
	CreateDynamicObject(2390, 1543.66, -1598.63, -25.87,   -22.58, 0.00, -0.06);
	CreateDynamicObject(2390, 1543.67, -1599.14, -25.87,   -22.58, 0.00, -0.06);
	CreateDynamicObject(19450, 1543.29, -1605.76, -25.12,   0.00, 0.00, -90.00);
	CreateDynamicObject(2390, 1543.66, -1597.58, -25.87,   -22.58, 0.00, -0.06);
	CreateDynamicObject(19450, 1529.32, -1603.25, -24.95,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1526.73, -1584.16, -24.95,   0.00, 0.00, -90.00);
	CreateDynamicObject(19431, 1521.18, -1584.15, -24.96,   0.00, 0.00, 90.00);
	CreateDynamicObject(19450, 1525.99, -1654.10, -26.82,   0.00, 0.00, -90.00);
	CreateDynamicObject(3850, 1521.21, -1652.33, -23.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(3850, 1521.23, -1648.91, -23.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(3850, 1521.23, -1645.48, -23.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(3850, 1521.23, -1642.05, -23.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(3850, 1521.24, -1638.60, -23.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(3850, 1521.26, -1635.18, -23.97,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1509.66, -1617.87, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1509.66, -1614.47, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1497.01, -1598.38, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19450, 1497.02, -1588.86, -24.95,   0.00, 0.00, 0.00);
	CreateDynamicObject(19431, 1517.34, -1586.00, -24.96,   0.00, 0.00, 222.00);
	CreateDynamicObject(19431, 1516.28, -1584.83, -24.96,   0.00, 0.00, 222.00);
	CreateDynamicObject(19450, 1509.60, -1603.17, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1501.00, -1603.17, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1501.68, -1584.23, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1511.22, -1584.22, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1509.72, -1590.83, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19450, 1500.29, -1590.85, -24.98,   0.00, 0.00, -90.00);
	CreateDynamicObject(19384, 1514.39, -1616.09, -24.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(19384, 1538.55, -1616.90, -24.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(19384, 1514.40, -1646.37, -24.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(19384, 1514.35, -1593.86, -24.99,   0.00, 0.00, 0.00);
	CreateDynamicObject(19384, 1516.14, -1590.82, -24.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(19384, 1516.11, -1609.67, -24.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(19384, 1522.75, -1609.76, -24.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(19384, 1536.87, -1609.92, -24.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(19384, 1536.69, -1634.85, -24.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(19384, 1516.10, -1635.17, -24.99,   0.00, 0.00, 90.00);
	CreateDynamicObject(19462, 1540.17, -1649.14, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1543.65, -1649.16, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1536.74, -1649.49, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1533.24, -1649.50, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1529.78, -1649.49, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1526.30, -1649.47, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1536.68, -1639.88, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1533.23, -1640.04, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1529.73, -1640.04, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1526.26, -1639.88, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1522.79, -1639.82, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1522.80, -1649.44, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1536.79, -1620.95, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1536.79, -1611.32, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1533.34, -1624.18, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1533.31, -1614.56, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1529.82, -1614.54, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1529.87, -1624.17, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1526.40, -1615.17, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1526.39, -1624.81, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1522.99, -1624.02, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1522.92, -1614.42, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1519.44, -1614.46, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1519.49, -1624.08, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1516.00, -1620.98, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1516.00, -1611.35, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1515.91, -1601.79, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1515.99, -1592.24, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1516.03, -1582.70, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1512.55, -1589.11, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1509.09, -1589.11, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1505.66, -1589.11, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1502.20, -1589.06, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1498.74, -1589.07, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1512.56, -1598.73, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1509.15, -1598.74, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1505.72, -1598.75, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1502.20, -1598.60, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1498.75, -1598.67, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1522.93, -1604.89, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1522.88, -1595.68, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1526.32, -1598.53, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1529.73, -1598.49, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1526.07, -1588.99, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1529.56, -1588.87, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1536.72, -1630.52, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1516.15, -1630.63, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1509.59, -1646.42, -26.65,   0.00, 90.00, 90.00);
	CreateDynamicObject(19462, 1503.05, -1646.73, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1499.58, -1646.70, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1496.09, -1646.82, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1492.60, -1646.78, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1489.15, -1646.64, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1485.70, -1646.43, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1536.65, -1659.11, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1533.16, -1659.13, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1529.66, -1659.11, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1526.21, -1659.09, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1522.77, -1659.02, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1503.13, -1626.45, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1499.67, -1626.42, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1503.12, -1616.86, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1499.64, -1616.80, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1537.00, -1601.72, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1540.47, -1600.92, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1543.92, -1600.87, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1536.98, -1592.05, -26.65,   0.00, 90.00, 0.00);
	CreateDynamicObject(19462, 1509.69, -1616.12, -26.65,   0.00, 90.00, 90.00);
	CreateDynamicObject(19462, 1543.36, -1616.82, -26.65,   0.00, 90.00, 90.00);
	CreateDynamicObject(2010, 1535.54, -1634.21, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2010, 1535.14, -1625.42, -26.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(19449, 1496.19, -1617.10, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1496.18, -1626.74, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1492.74, -1617.05, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1492.72, -1626.68, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1489.27, -1617.15, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1489.22, -1626.79, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1485.77, -1626.53, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1485.77, -1616.89, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1482.27, -1616.96, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1482.26, -1626.55, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1478.77, -1616.96, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1478.77, -1626.58, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1475.26, -1617.14, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19449, 1475.26, -1626.77, -26.57,   0.00, 90.00, 0.00);
	CreateDynamicObject(19442, 1486.65, -1630.08, -26.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(19442, 1493.42, -1625.83, -26.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(19442, 1492.75, -1613.97, -26.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(2049, 1486.76, -1630.09, -25.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(2049, 1493.54, -1625.90, -25.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(2049, 1492.87, -1614.02, -25.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(19454, 1516.08, -1614.53, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1519.58, -1614.49, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1523.06, -1614.50, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1526.55, -1614.49, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1529.94, -1614.48, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1533.41, -1614.46, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1536.86, -1614.49, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1536.56, -1623.99, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1533.05, -1624.10, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1529.52, -1624.08, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1526.02, -1624.13, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1522.52, -1624.02, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1519.01, -1624.06, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1515.50, -1624.10, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1516.16, -1604.82, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1516.07, -1595.21, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1512.67, -1598.47, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1509.22, -1598.47, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1505.72, -1598.48, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1502.28, -1598.50, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1498.80, -1598.49, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1498.89, -1588.93, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1502.38, -1588.93, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1505.89, -1588.94, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1509.38, -1588.92, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1512.78, -1588.90, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1516.19, -1585.65, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1522.77, -1604.94, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1522.76, -1595.35, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1522.69, -1585.73, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1526.25, -1589.05, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1529.74, -1589.04, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1529.59, -1598.45, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1526.07, -1598.48, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1503.18, -1616.83, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1499.69, -1616.81, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1499.72, -1626.41, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1503.15, -1626.50, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1496.22, -1626.41, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1496.16, -1616.79, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1492.72, -1616.86, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1489.23, -1616.88, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1485.71, -1616.77, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1482.23, -1616.87, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1478.77, -1616.85, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1475.26, -1616.78, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1478.83, -1626.46, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1475.36, -1626.32, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1482.32, -1626.49, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1485.83, -1626.45, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1489.36, -1626.47, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1492.76, -1626.48, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1536.91, -1604.89, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1536.92, -1595.32, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1540.38, -1600.85, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1543.87, -1600.86, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1503.12, -1647.07, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1499.63, -1647.08, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1496.16, -1647.07, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1492.69, -1647.04, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1489.21, -1647.07, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1485.77, -1647.03, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1515.99, -1633.74, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1516.03, -1643.32, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1516.03, -1652.92, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1519.52, -1652.91, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1519.51, -1643.32, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1519.50, -1633.88, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1536.57, -1633.56, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1536.59, -1643.17, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1536.57, -1652.77, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1540.02, -1649.22, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1543.49, -1649.17, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1536.61, -1662.27, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1533.16, -1662.22, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1529.66, -1662.20, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1526.33, -1662.09, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1522.82, -1662.07, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1533.07, -1652.60, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1533.14, -1643.06, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1533.16, -1633.56, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1529.60, -1652.55, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1526.09, -1652.52, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1522.77, -1652.49, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1522.70, -1642.91, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1522.69, -1633.31, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1526.21, -1642.94, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1529.62, -1642.98, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1526.16, -1633.35, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1529.69, -1633.58, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1549.97, -1624.94, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1553.43, -1624.97, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1556.86, -1624.95, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1560.35, -1624.95, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1563.85, -1624.95, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1567.35, -1624.96, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1570.82, -1624.96, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1574.27, -1624.95, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1577.77, -1624.91, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1577.70, -1615.29, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1574.20, -1615.29, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1570.73, -1615.32, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1567.25, -1615.32, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1563.82, -1615.33, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1560.33, -1615.34, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1556.82, -1615.31, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1553.39, -1615.38, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1549.90, -1615.43, -23.40,   0.00, 90.00, 0.00);
	CreateDynamicObject(19454, 1543.30, -1616.65, -23.40,   0.00, 90.00, 90.00);
	CreateDynamicObject(19454, 1509.67, -1616.28, -23.40,   0.00, 90.00, 90.00);
	CreateDynamicObject(19454, 1509.52, -1646.25, -23.40,   0.00, 90.00, 90.00);
	CreateDynamicObject(1893, 1528.68, -1614.61, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1525.76, -1614.61, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1522.48, -1614.63, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1528.56, -1615.98, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1528.49, -1617.36, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1525.80, -1617.38, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1525.78, -1616.02, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1522.38, -1615.96, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1522.35, -1617.32, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1522.20, -1622.97, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1522.21, -1623.95, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1522.12, -1625.13, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1525.56, -1622.98, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1525.55, -1624.00, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1525.55, -1625.16, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1528.31, -1622.97, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1528.44, -1623.98, -22.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(1893, 1528.31, -1625.20, -22.92,   0.00, 0.00, 0.00);
	//CS_Barron
	CreateDynamicObject(8662, -212.46876525879, -24.288707733154, 2.975040435791, 0.000000, 0.000000, 250.33032226563); //
	CreateDynamicObject(8662, -212.46875, -24.2880859375, 4.5250463485718, 0.000000, 0.000000, 250.32897949219); //
	CreateDynamicObject(8662, -212.46875, -24.2880859375, 6.1750526428223, 0.000000, 0.000000, 250.32897949219); //
	CreateDynamicObject(986, -235.96162414551, 15.34818649292, 2.9921908378601, 0.000000, 0.000000, 340.06005859375); //
	CreateDynamicObject(986, -228.5302734375, 12.651516914368, 2.9921908378601, 0.000000, 0.000000, 340.05981445313); //
	CreateDynamicObject(986, -213.60552978516, 7.2394957542419, 3.042191028595, 0.000000, 0.000000, 340.05981445313); //
	CreateDynamicObject(986, -206.07551574707, 4.5005059242249, 3.0671911239624, 0.000000, 0.000000, 340.05981445313); //
	CreateDynamicObject(986, -198.55236816406, 1.8162176609039, 3.0921912193298, 0.000000, 0.000000, 340.05981445313); //
	CreateDynamicObject(986, -191.14495849609, -0.92075884342194, 3.1171913146973, 0.000000, 0.000000, 340.05981445313); //
	CreateDynamicObject(986, -183.75317382813, -3.5880470275879, 3.1421914100647, 0.000000, 0.000000, 340.05981445313); //
	CreateDynamicObject(986, -176.21896362305, -6.3988618850708, 3.1671915054321, 0.000000, 0.000000, 340.05981445313); //
	CreateDynamicObject(986, -168.712890625, -9.0693359375, 3.1671915054321, 0.000000, 0.000000, 340.05981445313); //
	CreateDynamicObject(980, -221.25607299805, 10.004496574402, 4.8905787467957, 0.000000, 0.000000, 340.65319824219); //
	CreateDynamicObject(2934, -205.53852844238, 1.7517160177231, 3.5142693519592, 0.000000, 0.000000, 51.15576171875); //
	CreateDynamicObject(2934, -207.55137634277, -2.3084032535553, 3.5142693519592, 0.000000, 0.000000, 75.062713623047); //
	CreateDynamicObject(2934, -223.2278137207, -49.198299407959, 3.5142693519592, 0.000000, 0.000000, 89.932739257813); //
	CreateDynamicObject(2934, -222.25831604004, -45.166229248047, 3.5142693519592, 0.000000, 0.000000, 70.819274902344); //
	CreateDynamicObject(2932, -203.6142578125, -18.3623046875, 3.5691070556641, 0.000000, 0.000000, 252.29553222656); //
	CreateDynamicObject(2932, -217.875, -13.3994140625, 3.5691070556641, 0.000000, 0.000000, 251.65283203125); //
	CreateDynamicObject(2932, -223.69140625, -30.8095703125, 3.5691070556641, 0.000000, 0.000000, 250.54870605469); //
	CreateDynamicObject(2932, -209.478515625, -35.255859375, 3.5691070556641, 0.000000, 0.000000, 250.44982910156); //
	CreateDynamicObject(3043, -218.81967163086, -16.392498016357, 3.5691068172455, 0.000000, 0.000000, 252.38342285156); //
	CreateDynamicObject(3043, -222.54292297363, -27.849060058594, 3.5691068172455, 0.000000, 0.000000, 70.157318115234); //
	CreateDynamicObject(3043, -208.3193359375, -32.3251953125, 3.5691068172455, 0.000000, 0.000000, 70.235595703125); //
	CreateDynamicObject(3043, -204.58932495117, -21.369289398193, 3.5691068172455, 0.000000, 0.000000, 252.09228515625); //
	CreateDynamicObject(3043, -176.83584594727, -35.591728210449, 3.8185563087463, 0.000000, 0.000000, 160.78332519531); //
	CreateDynamicObject(3043, -179.833984375, -34.681640625, 3.7935562133789, 0.000000, 0.000000, 341.3232421875); //
	CreateDynamicObject(2973, -188.1879119873, -7.2431516647339, 2.109395980835, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2973, -175.77676391602, -12.288446426392, 2.109395980835, 0.000000, 0.000000, 287.96710205078); //
	CreateDynamicObject(2973, -175.12757873535, -14.5346326828, 2.109395980835, 0.000000, 0.000000, 287.96264648438); //
	CreateDynamicObject(2973, -185.83467102051, -7.254002571106, 2.109395980835, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2973, -233.85977172852, 4.9349994659424, 2.109395980835, 0.000000, 0.000000, 24.480194091797); //
	CreateDynamicObject(2973, -231.74678039551, 5.8939471244812, 2.109395980835, 0.000000, 0.000000, 24.4775390625); //
	CreateDynamicObject(2932, -217.875, -13.3994140625, 6.4465546607971, 0.000000, 0.000000, 251.65283203125); //
	CreateDynamicObject(2932, -218.86372375488, -16.322736740112, 6.4465546607971, 0.000000, 0.000000, 251.70129394531); //
	CreateDynamicObject(2932, -209.478515625, -35.255859375, 6.3691177368164, 0.000000, 0.000000, 250.45532226563); //
	CreateDynamicObject(2932, -208.44024658203, -32.323310852051, 6.3691177368164, 0.000000, 0.000000, 250.45532226563); //
	CreateDynamicObject(1225, -230.61386108398, 7.7840690612793, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -229.97698974609, 8.3376703262329, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -229.9765625, 8.3369140625, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -235.70500183105, -0.61730891466141, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -235.11485290527, -0.099033206701279, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -236.06091308594, 0.20932152867317, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -221.3588104248, -10.761023521423, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -221.76815795898, -10.073406219482, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -228.04707336426, -30.827402114868, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -228.71585083008, -30.351627349854, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -186.13813781738, -47.133007049561, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -186.96270751953, -47.17501449585, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -187.84587097168, -47.304904937744, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -188.78784179688, -47.401176452637, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3594, -191.93244934082, -54.18968963623, 2.7483642101288, 0.000000, 0.000000, 104.83343505859); //
	CreateDynamicObject(3594, -247.21374511719, -27.642646789551, 2.7483642101288, 0.000000, 0.000000, 47.216735839844); //
	CreateDynamicObject(1225, -231.53384399414, -42.823146820068, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -232.08798217773, -42.093276977539, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -232.30793762207, -42.890621185303, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3043, -244.8935546875, -11.466796875, 3.7685561180115, 0.000000, 0.000000, 341.3232421875); //
	CreateDynamicObject(3043, -247.79475402832, -10.442965507507, 3.7935562133789, 0.000000, 0.000000, 160.55419921875); //
	CreateDynamicObject(1217, -244.9930267334, -14.596480369568, 2.7340819835663, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -244.68086242676, -13.785695075989, 2.7340819835663, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -206.16973876953, -38.028419494629, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -205.56109619141, -38.551780700684, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -199.36694335938, -18.25373840332, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, -198.68673706055, -18.601680755615, 2.5229425430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -199.26815795898, -54.326526641846, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -200.01667785645, -54.499137878418, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -200.00540161133, -55.307231903076, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -199.22137451172, -55.168212890625, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -176.83111572266, -19.646520614624, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -176.89633178711, -20.434648513794, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -176.05291748047, -20.680583953857, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -175.92599487305, -19.889638900757, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -175.16131591797, -20.320835113525, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1456, -253.07928466797, -21.422479629517, 2.916086435318, 345.48980712891, 0.000000, 76.238983154297); //
	CreateDynamicObject(1456, -245.00685119629, 1.44466984272, 2.916086435318, 345.48706054688, 0.000000, 76.234130859375); //
	CreateDynamicObject(1456, -170.05595397949, -22.746810913086, 2.916086435318, 345.48706054688, 0.000000, 246.80438232422); //
	CreateDynamicObject(1456, -182.4571685791, -57.247367858887, 2.916086435318, 345.48156738281, 0.000000, 246.80236816406); //
	CreateDynamicObject(1456, -189.93565368652, -63.453189849854, 2.916086435318, 345.48156738281, 0.000000, 166.78692626953); //
	CreateDynamicObject(1456, -234.92720031738, -47.404083251953, 2.916086435318, 345.48156738281, 0.000000, 166.78344726563); //
	CreateDynamicObject(761, -181.58280944824, -50.892585754395, 2.1171865463257, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -190.62002563477, -45.162815093994, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -192.90559387207, -24.290649414063, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -207.31939697266, -46.9137840271, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -188.31565856934, -57.574192047119, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -182.18911743164, -43.221420288086, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -176.44598388672, -25.503410339355, 2.1171875, 0.000000, 0.000000, 358.38775634766); //
	CreateDynamicObject(866, -189.52308654785, -17.661376953125, 2.1171875, 0.000000, 0.000000, 342.26257324219); //
	CreateDynamicObject(866, -183.7177734375, -16.024215698242, 2.1171875, 0.000000, 0.000000, 342.26257324219); //
	CreateDynamicObject(866, -179.78167724609, -8.6356229782104, 2.1171875, 0.000000, 0.000000, 342.26257324219); //
	CreateDynamicObject(866, -170.80252075195, -10.076661109924, 2.1171875, 0.000000, 0.000000, 342.26257324219); //
	CreateDynamicObject(866, -204.61766052246, -7.39280128479, 2.1171875, 0.000000, 0.000000, 342.26257324219); //
	CreateDynamicObject(866, -204.740234375, -26.843242645264, 2.1171875, 0.000000, 0.000000, 340.65032958984); //
	CreateDynamicObject(866, -213.32795715332, -26.422317504883, 2.1171875, 0.000000, 0.000000, 340.64758300781); //
	CreateDynamicObject(866, -212.14532470703, -17.178291320801, 2.1171875, 0.000000, 0.000000, 340.64758300781); //
	CreateDynamicObject(866, -220.67547607422, -22.883644104004, 2.1171875, 0.000000, 0.000000, 343.8720703125); //
	CreateDynamicObject(866, -232.03196716309, -43.015777587891, 2.1171875, 0.000000, 0.000000, 343.86657714844); //
	CreateDynamicObject(866, -241.69229125977, -38.440731048584, 2.1171875, 0.000000, 0.000000, 340.64208984375); //
	CreateDynamicObject(866, -250.16737365723, -35.425922393799, 2.1171875, 0.000000, 0.000000, 340.64208984375); //
	CreateDynamicObject(866, -233.6854095459, -29.420265197754, 2.1171875, 0.000000, 0.000000, 332.58087158203); //
	CreateDynamicObject(866, -236.78175354004, -16.078701019287, 2.1171875, 0.000000, 9.6734619140625, 334.19036865234); //
	CreateDynamicObject(866, -232.15315246582, -0.2201182693243, 2.1171875, 0.000000, 9.66796875, 332.57537841797); //
	CreateDynamicObject(866, -223.40173339844, -4.2641396522522, 2.1171875, 0.000000, 9.6624755859375, 334.18487548828); //
	CreateDynamicObject(866, -230.20951843262, 11.742373466492, 2.1171875, 0.000000, 9.6624755859375, 334.18212890625); //
	CreateDynamicObject(1217, -179.71713256836, -37.650566101074, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -179.5041809082, -36.861221313477, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -177.16529846191, -33.276229858398, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -177.49012756348, -34.171123504639, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -206.82350158691, -19.515508651733, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -206.08135986328, -19.788105010986, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -206.57954406738, -34.086811065674, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -207.25569152832, -33.825412750244, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -221.18180847168, -14.547941207886, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -220.42134094238, -14.749977111816, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -220.55302429199, -29.697078704834, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1217, -221.32318115234, -29.476440429688, 2.5385675430298, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3678, -246.33889770508, -54.860374450684, 9.3098182678223, 0.000000, 0.000000, 250.330078125); //
	CreateDynamicObject(3678, -205.34532165527, -69.443641662598, 9.3098182678223, 0.000000, 0.000000, 250.32897949219); //
	CreateDynamicObject(616, -225.58987426758, -69.167770385742, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(616, -187.45991516113, -78.077308654785, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(616, -262.64562988281, -51.777309417725, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(13367, -214.43023681641, -81.722778320313, 14.111074447632, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -181.44006347656, -28.706588745117, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -181.3869934082, -26.170066833496, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -178.3426361084, -28.910831451416, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -175.81753540039, -29.526100158691, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -174.28805541992, -30.54362487793, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -173.52439880371, -27.739757537842, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -173.47972106934, -25.62593460083, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -173.42994689941, -23.229900360107, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -172.40269470215, -21.277431488037, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -170.94395446777, -18.911350250244, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -169.61711120605, -16.119564056396, 2.1171875, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(866, -168.29870605469, -13.750245094299, 2.1171875, 0.000000, 358.38775634766, 0.000000); //
	CreateDynamicObject(866, -167.53805541992, -11.087681770325, 2.1171875, 0.000000, 358.38500976563, 0.000000); //
	CreateDynamicObject(866, -170.90667724609, -10.453483581543, 2.1171875, 0.000000, 358.38500976563, 0.000000); //
	CreateDynamicObject(866, -170.40391540527, -13.42342376709, 2.1171875, 0.000000, 358.38500976563, 0.000000); //
	CreateDynamicObject(866, -171.16603088379, -16.226058959961, 2.1171875, 0.000000, 358.38500976563, 0.000000); //
	CreateDynamicObject(866, -172.38734436035, -13.945170402527, 2.1171875, 0.000000, 358.38500976563, 0.000000); //
	CreateDynamicObject(866, -172.74816894531, -10.976948738098, 2.1171875, 0.000000, 358.38500976563, 0.000000); //
	CreateDynamicObject(866, -174.54165649414, -9.1071653366089, 2.1171875, 0.000000, 358.38500976563, 0.000000); //
	CreateDynamicObject(866, -177.21199035645, -8.7693519592285, 2.1171875, 0.000000, 358.38500976563, 0.000000); //
	CreateDynamicObject(866, -180.857421875, -7.8475275039673, 2.1171875, 0.000000, 358.38500976563, 0.000000); //
	CreateDynamicObject(866, -182.68891906738, -7.8088355064392, 2.1171875, 0.000000, 358.38500976563, 0.000000); //
	CreateDynamicObject(866, -182.73219299316, -9.9219169616699, 2.1171875, 0.000000, 358.38500976563, 0.000000); //
	CreateDynamicObject(866, -182.76933288574, -11.753421783447, 2.1171875, 0.000000, 1.6094970703125, 0.000000); //
	CreateDynamicObject(866, -182.81518554688, -14.007141113281, 2.1171875, 0.000000, 8.052978515625, 0.000000); //
	CreateDynamicObject(866, -184.66926574707, -15.096091270447, 2.1171875, 0.000000, 29.012176513672, 3.2244873046875); //
	CreateDynamicObject(866, -184.43089294434, -17.214847564697, 2.1171875, 0.000000, 12.886932373047, 350.32104492188); //
	CreateDynamicObject(866, -183.89335632324, -18.494480133057, 2.1171875, 0.000000, 16.10595703125, 347.09106445313); //
	CreateDynamicObject(866, -183.91589355469, -19.621246337891, 2.1171875, 0.000000, 22.554931640625, 347.08557128906); //
	CreateDynamicObject(866, -183.96166992188, -21.875305175781, 2.1171875, 0.000000, 25.77392578125, 347.08557128906); //
	CreateDynamicObject(866, -183.99008178711, -23.283882141113, 2.1171875, 0.000000, 30.610656738281, 347.08557128906); //
	CreateDynamicObject(866, -184.00674438477, -24.128532409668, 2.1171875, 0.000000, 32.220153808594, 347.08557128906); //
	CreateDynamicObject(866, -184.5810546875, -24.679840087891, 2.1171875, 0.000000, 11.258209228516, 6.4324951171875); //
	CreateDynamicObject(866, -184.63642883301, -27.356563568115, 2.1171875, 0.000000, 12.867736816406, 6.4324951171875); //
	CreateDynamicObject(866, -184.66488647461, -28.765327453613, 2.1171875, 0.000000, 6.416015625, 6.4324951171875); //
	CreateDynamicObject(866, -184.00044250488, -30.751636505127, 2.1171875, 0.000000, 6.4105224609375, 6.4324951171875); //
	CreateDynamicObject(866, -184.60725402832, -32.852657318115, 2.1171875, 0.000000, 12.859497070313, 6.4324951171875); //
	CreateDynamicObject(866, -184.65599060059, -35.247638702393, 2.1171875, 0.000000, 4.7982788085938, 6.4324951171875); //
	CreateDynamicObject(866, -184.70190429688, -37.501281738281, 2.1171875, 0.000000, 6.4077758789063, 6.4324951171875); //
	CreateDynamicObject(866, -187.68305969238, -38.566959381104, 2.1171875, 0.000000, 6.405029296875, 6.4324951171875); //
	CreateDynamicObject(866, -189.80754089355, -39.08629989624, 2.1171875, 0.000000, 6.405029296875, 6.4324951171875); //
	CreateDynamicObject(866, -192.92358398438, -39.867233276367, 2.1171875, 0.000000, 353.50708007813, 11.269226074219); //
	CreateDynamicObject(866, -195.62464904785, -42.608543395996, 2.1171875, 0.000000, 353.50158691406, 11.266479492188); //
	CreateDynamicObject(866, -197.6171875, -44.461692810059, 2.1171875, 0.000000, 353.50158691406, 11.266479492188); //
	CreateDynamicObject(866, -199.14028930664, -46.734001159668, 2.1171875, 0.000000, 358.33831787109, 11.266479492188); //
	CreateDynamicObject(866, -200.87265014648, -49.241485595703, 2.1171875, 0.000000, 347.04986572266, 11.260986328125); //
	CreateDynamicObject(866, -202.5746307373, -49.917633056641, 2.1171875, 0.000000, 347.04711914063, 11.260986328125); //
	CreateDynamicObject(866, -202.57421875, -49.9169921875, 2.1171875, 0.000000, 335.76135253906, 11.260986328125); //
	CreateDynamicObject(866, -203.75291442871, -50.385284423828, 2.1171875, 0.000000, 351.88110351563, 11.260986328125); //
	CreateDynamicObject(866, -205.0651550293, -52.422805786133, 2.1171875, 0.000000, 351.87561035156, 11.260986328125); //
	CreateDynamicObject(866, -207.47741699219, -54.745216369629, 2.1171875, 0.000000, 348.65112304688, 6.4242553710938); //
	CreateDynamicObject(866, -211.12768554688, -49.37230682373, 2.1171875, 0.000000, 348.64562988281, 6.4215087890625); //
	CreateDynamicObject(866, -211.85540771484, -47.538650512695, 2.1171875, 0.000000, 348.64562988281, 8.0337524414063); //
	CreateDynamicObject(866, -213.88906860352, -44.707275390625, 2.1171875, 0.000000, 348.64013671875, 8.031005859375); //
	CreateDynamicObject(866, -215.87298583984, -42.766036987305, 2.1171875, 0.000000, 348.64013671875, 8.031005859375); //
	CreateDynamicObject(866, -218.48254394531, -40.011985778809, 2.1171875, 0.000000, 348.64013671875, 8.031005859375); //
	CreateDynamicObject(866, -221.5647277832, -37.59716796875, 2.1171875, 0.000000, 348.64013671875, 8.031005859375); //
	CreateDynamicObject(866, -223.81423950195, -37.277465820313, 2.1171875, 0.000000, 348.64013671875, 14.47998046875); //
	CreateDynamicObject(866, -225.90524291992, -37.16024017334, 2.1171875, 0.000000, 348.63464355469, 14.474487304688); //
	CreateDynamicObject(866, -228.89205932617, -36.935928344727, 2.1171875, 0.000000, 348.63464355469, 14.474487304688); //
	CreateDynamicObject(866, -229.97857666016, -35.830360412598, 2.1171875, 0.000000, 358.30810546875, 14.474487304688); //
	CreateDynamicObject(866, -232.56935119629, -35.808456420898, 2.1171875, 0.000000, 358.30261230469, 14.468994140625); //
	CreateDynamicObject(866, -234.55230712891, -34.595306396484, 2.1171875, 0.000000, 358.30261230469, 14.468994140625); //
	CreateDynamicObject(866, -236.62689208984, -32.484825134277, 2.1171875, 0.000000, 358.30261230469, 14.468994140625); //
	CreateDynamicObject(866, -237.7013092041, -29.984203338623, 2.1171875, 0.000000, 358.30261230469, 14.468994140625); //
	CreateDynamicObject(866, -239.36773681641, -26.68109703064, 2.1171875, 0.000000, 358.30261230469, 14.468994140625); //
	CreateDynamicObject(866, -240.83279418945, -23.180746078491, 2.1171875, 0.000000, 358.30261230469, 14.468994140625); //
	CreateDynamicObject(866, -241.30448913574, -20.087635040283, 2.1171875, 0.000000, 358.30261230469, 14.468994140625); //
	CreateDynamicObject(866, -242.46954345703, -16.489852905273, 2.1171875, 0.000000, 358.30261230469, 14.468994140625); //
	CreateDynamicObject(866, -240.14608764648, -12.821677207947, 2.1171875, 0.000000, 358.30261230469, 14.468994140625); //
	CreateDynamicObject(866, -238.13592529297, -10.845104217529, 2.1171875, 0.000000, 358.30261230469, 14.468994140625); //
	CreateDynamicObject(866, -236.72903442383, -9.4613971710205, 2.1171875, 0.000000, 358.30261230469, 17.693481445313); //
	CreateDynamicObject(866, -235.72372436523, -8.4728450775146, 2.1171875, 0.000000, 358.29711914063, 20.912475585938); //
	CreateDynamicObject(866, -235.12075805664, -7.8798007965088, 2.1171875, 0.000000, 358.29162597656, 28.973693847656); //
	CreateDynamicObject(866, -233.4119720459, -6.1991491317749, 2.1171875, 0.000000, 358.29162597656, 32.195434570313); //
	CreateDynamicObject(866, -232.50682067871, -5.3089590072632, 2.1171875, 0.000000, 358.29162597656, 38.638916015625); //
	CreateDynamicObject(866, -231.40058898926, -4.2216920852661, 2.1171875, 0.000000, 358.29162597656, 40.251159667969); //
	CreateDynamicObject(866, -229.59176635742, -2.4431171417236, 2.1171875, 0.000000, 358.29162597656, 40.248413085938); //
	CreateDynamicObject(866, -228.2845916748, -1.1578657627106, 2.1171875, 0.000000, 358.29162597656, 43.472900390625); //
	CreateDynamicObject(866, -226.9779510498, 0.12729051709175, 2.1171875, 0.000000, 358.29162597656, 45.079650878906); //
	CreateDynamicObject(866, -226.37466430664, 0.71980714797974, 2.1171875, 0.000000, 358.29162597656, 49.913635253906); //
	CreateDynamicObject(866, -224.86683654785, 2.2018616199493, 2.1171875, 0.000000, 358.29162597656, 54.747619628906); //
	CreateDynamicObject(866, -224.06237792969, 2.9916439056396, 2.1171875, 0.000000, 358.29162597656, 61.19384765625); //
	CreateDynamicObject(866, -222.55433654785, 4.4733471870422, 2.1171875, 0.000000, 358.29162597656, 64.418334960938); //
	CreateDynamicObject(866, -221.14700317383, 5.8559856414795, 2.1171875, 0.000000, 358.29162597656, 67.637329101563); //
	CreateDynamicObject(866, -219.8402557373, 7.139988899231, 2.1171875, 0.000000, 358.29162597656, 70.86181640625); //
	CreateDynamicObject(866, -219.2718963623, 3.5475795269012, 2.1171875, 0.000000, 358.29162597656, 70.86181640625); //
	CreateDynamicObject(866, -217.88806152344, 2.140257358551, 2.1171875, 0.000000, 358.29162597656, 70.86181640625); //
	CreateDynamicObject(866, -216.80404663086, 0.63588547706604, 2.1171875, 0.000000, 351.84265136719, 70.86181640625); //
	CreateDynamicObject(866, -216.01318359375, -0.16803953051567, 2.1171875, 0.000000, 340.55694580078, 70.86181640625); //
	CreateDynamicObject(866, -215.12335205078, -1.0722230672836, 2.1171875, 0.000000, 334.10522460938, 70.86181640625); //
	CreateDynamicObject(866, -213.73962402344, -2.477906703949, 2.1171875, 0.000000, 324.42626953125, 64.412841796875); //
	CreateDynamicObject(866, -212.16984558105, -5.4800772666931, 2.1171875, 0.000000, 324.42077636719, 64.407348632813); //
	CreateDynamicObject(866, -210.39025878906, -7.2880048751831, 2.1171875, 0.000000, 316.35955810547, 64.407348632813); //
	CreateDynamicObject(866, -208.90740966797, -8.7941999435425, 2.1171875, 0.000000, 313.13232421875, 64.40185546875); //
	CreateDynamicObject(866, -207.42498779297, -10.301032066345, 2.1171875, 0.000000, 313.13232421875, 64.396362304688); //
	CreateDynamicObject(866, -205.83210754395, -10.513368606567, 2.1171875, 0.000000, 303.45886230469, 64.396362304688); //
	CreateDynamicObject(866, -203.03857421875, -10.1374168396, 2.1171875, 0.000000, 303.45886230469, 66.003112792969); //
	CreateDynamicObject(866, -201.7318572998, -8.852198600769, 2.1171875, 0.000000, 335.70373535156, 67.612609863281); //
	CreateDynamicObject(866, -200.24920654297, -10.358649253845, 2.1171875, 0.000000, 330.86700439453, 67.60986328125); //
	CreateDynamicObject(866, -198.8356628418, -8.177942276001, 2.1171875, 0.000000, 343.76220703125, 67.604370117188); //
	CreateDynamicObject(866, -197.55035400391, -9.4838762283325, 2.1171875, 0.000000, 338.91998291016, 67.598876953125); //
	CreateDynamicObject(866, -191.37664794922, -10.132802963257, 2.1171875, 0.000000, 322.79479980469, 78.879089355469); //
	CreateDynamicObject(866, -189.89706420898, -12.037486076355, 2.1171875, 0.000000, 317.95806884766, 78.876342773438); //
	CreateDynamicObject(866, -197.98608398438, -2.204092502594, 2.1171875, 0.000000, 348.58795166016, 77.258605957031); //
	CreateDynamicObject(866, -198.58157348633, -1.9988522529602, 2.1171875, 0.000000, 351.80969238281, 75.643615722656); //
	CreateDynamicObject(866, -199.77516174316, -1.7887830734253, 2.1171875, 0.000000, 351.80419921875, 75.640869140625); //
	CreateDynamicObject(866, -200.86637878418, -1.2807314395905, 2.1171875, 0.000000, 351.80419921875, 75.640869140625); //
	CreateDynamicObject(866, -201.86767578125, -1.8698000907898, 2.1171875, 0.000000, 351.80419921875, 72.416381835938); //
	CreateDynamicObject(866, -201.67121887207, -2.2693676948547, 2.1171875, 0.000000, 345.35522460938, 65.9619140625); //
	CreateDynamicObject(866, -201.69750976563, -5.4570651054382, 2.1171875, 0.000000, 345.34973144531, 65.9619140625); //
	CreateDynamicObject(866, -197.30612182617, -4.6965036392212, 2.1171875, 0.000000, 329.22729492188, 85.308837890625); //
	CreateDynamicObject(866, -191.92469787598, -4.7412085533142, 2.1171875, 0.000000, 322.7783203125, 88.533325195313); //
	CreateDynamicObject(866, -178.99893188477, -10.552695274353, 2.1171875, 0.000000, 356.6298828125, 85.303344726563); //
	CreateDynamicObject(866, -180.35357666016, -12.856340408325, 2.1171875, 0.000000, 356.62719726563, 86.915588378906); //
	CreateDynamicObject(866, -179.05661010742, -14.342151641846, 2.1171875, 0.000000, 356.62170410156, 90.137329101563); //
	CreateDynamicObject(866, -180.11752319336, -15.268148422241, 2.1171875, 0.000000, 355.00390625, 90.1318359375); //
	CreateDynamicObject(866, -178.91291809082, -16.648069381714, 2.1171875, 0.000000, 355.00122070313, 93.350830078125); //
	CreateDynamicObject(866, -178.95497131348, -18.741910934448, 2.1171875, 0.000000, 355.00122070313, 99.7998046875); //
	CreateDynamicObject(866, -174.94834899902, -17.116735458374, 2.1171875, 0.000000, 355.00122070313, 99.794311523438); //
	CreateDynamicObject(866, -177.9665222168, -23.302391052246, 2.1171875, 0.000000, 353.38897705078, 99.794311523438); //
	CreateDynamicObject(866, -181.88806152344, -22.235305786133, 2.1171875, 0.000000, 353.38623046875, 99.794311523438); //
	CreateDynamicObject(866, -182.80503845215, -32.972492218018, 2.1171875, 0.000000, 353.38623046875, 99.794311523438); //
	CreateDynamicObject(866, -183.79496765137, -36.121448516846, 2.1171875, 0.000000, 353.38623046875, 99.794311523438); //
	CreateDynamicObject(866, -184.60858154297, -38.588775634766, 2.1171875, 0.000000, 354.99847412109, 99.794311523438); //
	CreateDynamicObject(866, -183.91174316406, -40.282218933105, 2.1171875, 0.000000, 356.60797119141, 99.794311523438); //
	CreateDynamicObject(866, -183.21447753906, -41.975578308105, 2.1171875, 0.000000, 359.82971191406, 99.794311523438); //
	CreateDynamicObject(866, -182.78515625, -43.017272949219, 2.1171875, 0.000000, 6.2786865234375, 99.794311523438); //
	CreateDynamicObject(866, -182.46362304688, -43.798599243164, 2.1171875, 0.000000, 12.727661132813, 99.794311523438); //
	CreateDynamicObject(866, -182.08776855469, -44.710182189941, 2.1171875, 0.000000, 15.9521484375, 99.794311523438); //
	CreateDynamicObject(866, -180.52301025391, -44.066940307617, 2.1171875, 0.000000, 14.339904785156, 98.182067871094); //
	CreateDynamicObject(866, -180.19236755371, -43.016483306885, 2.1171875, 0.000000, 12.724914550781, 96.567077636719); //
	CreateDynamicObject(866, -180.43620300293, -42.049709320068, 2.1171875, 0.000000, 9.4976806640625, 96.564331054688); //
	CreateDynamicObject(866, -187.12716674805, -42.819412231445, 1.8353507518768, 1.6122436523438, 343.69625854492, 120.74798583984); //
	CreateDynamicObject(866, -186.59106445313, -44.122665405273, 1.8353507518768, 1.6094970703125, 350.13977050781, 120.74523925781); //
	CreateDynamicObject(866, -185.82472229004, -44.873645782471, 1.8353507518768, 1.60400390625, 351.751953125, 120.74523925781); //
	CreateDynamicObject(866, -182.90473937988, -46.415264129639, 1.8353507518768, 1.5985107421875, 351.74926757813, 120.74523925781); //
	CreateDynamicObject(866, -185.27778625488, -51.159015655518, 1.8353507518768, 1.5985107421875, 351.74926757813, 120.74523925781); //
	CreateDynamicObject(866, -185.59951782227, -53.91881942749, 1.8353507518768, 1.5985107421875, 354.97375488281, 120.74523925781); //
	CreateDynamicObject(866, -186.27726745605, -56.219772338867, 1.8353507518768, 1.593017578125, 358.19274902344, 123.9697265625); //
	CreateDynamicObject(866, -186.56823730469, -58.3508644104, 1.8353507518768, 1.593017578125, 359.79949951172, 125.57647705078); //
	CreateDynamicObject(866, -187.85659790039, -58.919471740723, 1.8353507518768, 1.593017578125, 359.79675292969, 132.02270507813); //
	CreateDynamicObject(866, -189.52870178223, -58.270614624023, 1.8353507518768, 1.593017578125, 356.56677246094, 141.69616699219); //
	CreateDynamicObject(866, -194.13200378418, -51.676464080811, 1.8353507518768, 1.593017578125, 340.43884277344, 156.20635986328); //
	CreateDynamicObject(866, -202.92593383789, -55.135238647461, 1.8353507518768, 1.593017578125, 340.43334960938, 156.20361328125); //
	CreateDynamicObject(866, -200.00564575195, -56.146873474121, 1.8353507518768, 1.593017578125, 333.984375, 149.75463867188); //
	CreateDynamicObject(866, -197.27084350586, -57.087291717529, 1.8353507518768, 1.593017578125, 330.75439453125, 146.53015136719); //
	CreateDynamicObject(866, -195.59564208984, -57.728618621826, 1.8353507518768, 1.593017578125, 327.5244140625, 143.30017089844); //
	CreateDynamicObject(866, -193.91986083984, -58.370220184326, 1.8353507518768, 1.593017578125, 319.46319580078, 135.23895263672); //
	CreateDynamicObject(866, -192.61627197266, -58.869220733643, 1.8353507518768, 1.593017578125, 313.01147460938, 128.78723144531); //
	CreateDynamicObject(866, -191.12744140625, -59.439544677734, 1.8353507518768, 1.593017578125, 308.16925048828, 123.94500732422); //
	CreateDynamicObject(866, -192.42962646484, -58.940349578857, 1.8353507518768, 1.593017578125, 319.45220947266, 135.22796630859); //
	CreateDynamicObject(866, -196.33673095703, -57.442142486572, 1.8353507518768, 1.593017578125, 324.28619384766, 140.06195068359); //
	CreateDynamicObject(866, -208.35903930664, -54.008674621582, 1.8353507518768, 1.593017578125, 327.50793457031, 143.28369140625); //
	CreateDynamicObject(866, -210.40545654297, -53.22350692749, 1.8353507518768, 1.593017578125, 333.95141601563, 149.72717285156); //
	CreateDynamicObject(866, -212.26623535156, -52.509651184082, 1.8353507518768, 1.593017578125, 343.61938476563, 159.39514160156); //
	CreateDynamicObject(866, -213.03964233398, -51.465286254883, 1.8353507518768, 1.593017578125, 343.61938476563, 165.84411621094); //
	CreateDynamicObject(866, -213.67050170898, -50.049140930176, 1.8353507518768, 1.593017578125, 343.61938476563, 172.29309082031); //
	CreateDynamicObject(866, -216.85675048828, -42.212013244629, 1.8353507518768, 1.593017578125, 343.61938476563, 172.28759765625); //
	CreateDynamicObject(866, -219.833984375, -41.071105957031, 1.8353507518768, 1.593017578125, 348.4560546875, 177.12432861328); //
	CreateDynamicObject(866, -221.69494628906, -40.357307434082, 1.8353507518768, 1.593017578125, 359.73907470703, 188.40728759766); //
	CreateDynamicObject(866, -224.07006835938, -39.873039245605, 1.8353507518768, 1.593017578125, 7.7975463867188, 188.40454101563); //
	CreateDynamicObject(866, -228.11434936523, -42.910663604736, 1.8353507518768, 1.593017578125, 14.243774414063, 188.40454101563); //
	CreateDynamicObject(866, -229.16970825195, -45.386856079102, 1.8353507518768, 1.593017578125, 17.46826171875, 188.40454101563); //
	CreateDynamicObject(866, -231.54467773438, -44.903312683105, 1.8353507518768, 1.593017578125, 25.529479980469, 188.40454101563); //
	CreateDynamicObject(866, -234.33538818359, -43.832836151123, 1.8353507518768, 1.593017578125, 28.751220703125, 191.62902832031); //
	CreateDynamicObject(866, -236.19592285156, -43.119026184082, 1.8353507518768, 1.593017578125, 33.582458496094, 196.46026611328); //
	CreateDynamicObject(866, -237.68408203125, -42.547760009766, 1.8353507518768, 1.593017578125, 49.7021484375, 212.57995605469); //
	CreateDynamicObject(866, -238.61407470703, -42.190372467041, 1.8353507518768, 1.593017578125, 56.145629882813, 219.0234375); //
	CreateDynamicObject(866, -240.47424316406, -41.476448059082, 1.8353507518768, 1.593017578125, 69.0380859375, 231.91589355469); //
	CreateDynamicObject(866, -241.40411376953, -41.119083404541, 1.8353507518768, 1.593017578125, 77.093811035156, 239.97161865234); //
	CreateDynamicObject(866, -242.33380126953, -40.761661529541, 1.8353507518768, 1.593017578125, 85.152282714844, 248.03009033203); //
	CreateDynamicObject(866, -243.63568115234, -40.261638641357, 1.8353507518768, 1.593017578125, 93.210754394531, 256.08856201172); //
	CreateDynamicObject(866, -244.93743896484, -39.761638641357, 1.8353507518768, 1.593017578125, 102.88146972656, 265.75927734375); //
	CreateDynamicObject(866, -245.68090820313, -39.475540161133, 1.8353507518768, 1.593017578125, 115.77392578125, 278.6572265625); //
	CreateDynamicObject(866, -246.23895263672, -39.260707855225, 1.8353507518768, 1.593017578125, 122.21740722656, 285.10070800781); //
	CreateDynamicObject(866, -247.91314697266, -38.618061065674, 1.8353507518768, 1.593017578125, 130.27313232422, 293.15643310547); //
	CreateDynamicObject(866, -249.02966308594, -38.189384460449, 1.8353507518768, 1.593017578125, 144.78057861328, 307.66394042969); //
	CreateDynamicObject(866, -249.77368164063, -37.903274536133, 1.8353507518768, 1.593017578125, 154.45129394531, 317.33459472656); //
	CreateDynamicObject(866, -250.70391845703, -37.545841217041, 1.8353507518768, 1.593017578125, 162.51251220703, 325.39038085938); //
	CreateDynamicObject(866, -252.19189453125, -36.974517822266, 1.8353507518768, 1.593017578125, 170.57098388672, 333.44879150391); //
	CreateDynamicObject(866, -253.49407958984, -36.474529266357, 1.8353507518768, 1.593017578125, 180.24169921875, 343.11950683594); //
	CreateDynamicObject(866, -254.42364501953, -36.117130279541, 1.8353507518768, 1.593017578125, 191.52740478516, 354.39978027344); //
	CreateDynamicObject(866, -253.03857421875, -38.957962036133, 1.8353507518768, 1.593017578125, 183.46343994141, 346.33575439453); //
	CreateDynamicObject(866, -244.38584899902, -41.536327362061, 3.1036152839661, 1.593017578125, 183.46069335938, 346.3330078125); //
	CreateDynamicObject(866, -239.83811950684, -42.517711639404, 3.1036152839661, 1.593017578125, 180.23620605469, 346.3330078125); //
	CreateDynamicObject(866, -237.51263427734, -43.093704223633, 3.1036152839661, 1.593017578125, 175.39398193359, 346.32751464844); //
	CreateDynamicObject(866, -235.73358154297, -43.533340454102, 3.1036152839661, 1.593017578125, 170.55450439453, 346.32202148438); //
	CreateDynamicObject(866, -234.50238037109, -43.83821105957, 3.1036152839661, 1.593017578125, 164.10278320313, 346.32202148438); //
	CreateDynamicObject(866, -233.48037719727, -42.058479309082, 3.1036152839661, 1.593017578125, 164.10278320313, 351.15875244141); //
	CreateDynamicObject(866, -233.10670471191, -40.552997589111, 3.1036152839661, 1.593017578125, 164.10278320313, 359.21728515625); //
	CreateDynamicObject(866, -232.86921691895, -39.595249176025, 3.1036152839661, 1.593017578125, 164.10278320313, 5.6634521484375); //
	CreateDynamicObject(866, -236.87330627441, -37.005634307861, 3.1036152839661, 1.593017578125, 168.93951416016, 5.6634521484375); //
	CreateDynamicObject(866, -238.78796386719, -36.530426025391, 3.1036152839661, 1.593017578125, 173.77349853516, 5.6634521484375); //
	CreateDynamicObject(866, -240.56524658203, -36.089706420898, 3.1036152839661, 1.593017578125, 178.60748291016, 5.6634521484375); //
	CreateDynamicObject(866, -242.06903076172, -35.716079711914, 3.1036152839661, 1.593017578125, 185.0537109375, 5.6634521484375); //
	CreateDynamicObject(866, -244.86405944824, -31.791051864624, 3.1036152839661, 1.593017578125, 189.89044189453, 0.82672119140625); //
	CreateDynamicObject(866, -246.71466064453, -31.701982498169, 3.1036152839661, 1.593017578125, 186.66320800781, 357.59948730469); //
	CreateDynamicObject(866, -247.87715148926, -32.471134185791, 3.1036152839661, 1.593017578125, 183.43322753906, 352.75720214844); //
	CreateDynamicObject(866, -248.6212310791, -31.887865066528, 3.1036152839661, 1.593017578125, 188.26446533203, 347.91778564453); //
	CreateDynamicObject(866, -249.28109741211, -30.890594482422, 3.1036152839661, 1.593017578125, 193.09844970703, 343.07836914063); //
	CreateDynamicObject(866, -249.94027709961, -29.892547607422, 3.1036152839661, 1.593017578125, 199.54467773438, 336.62658691406); //
	CreateDynamicObject(866, -250.48945617676, -29.060684204102, 3.1036152839661, 1.593017578125, 202.763671875, 333.40209960938); //
	CreateDynamicObject(866, -251.14926147461, -28.063446044922, 3.1036152839661, 1.593017578125, 210.82489013672, 328.55987548828); //
	CreateDynamicObject(866, -250.81134033203, -26.405418395996, 3.1036152839661, 1.593017578125, 230.16906738281, 328.55712890625); //
	CreateDynamicObject(866, -249.77589416504, -22.733026504517, 3.1036152839661, 1.593017578125, 230.16906738281, 328.55712890625); //
	CreateDynamicObject(866, -249.35401916504, -20.661069869995, 3.1036152839661, 1.593017578125, 235.00579833984, 328.55712890625); //
	CreateDynamicObject(866, -248.26977539063, -18.867361068726, 3.1036152839661, 1.593017578125, 236.61529541016, 330.16937255859); //
	CreateDynamicObject(866, -245.46096801758, -22.027050018311, 3.1036152839661, 1.593017578125, 185.02075195313, 23.370666503906); //
	CreateDynamicObject(866, -244.29765319824, -21.25638961792, 3.1036152839661, 1.593017578125, 188.24523925781, 26.592407226563); //
	CreateDynamicObject(866, -243.13359069824, -20.48588180542, 3.1036152839661, 1.593017578125, 204.36218261719, 42.71484375); //
	CreateDynamicObject(866, -241.27906799316, -19.855840682983, 3.1036152839661, 1.593017578125, 217.25463867188, 65.286254882813); //
	CreateDynamicObject(866, -240.73512268066, -14.357590675354, 3.1036152839661, 1.593017578125, 234.98382568359, 65.28076171875); //
	CreateDynamicObject(866, -240.56582641602, -13.528886795044, 3.1036152839661, 1.593017578125, 246.26678466797, 65.275268554688); //
	CreateDynamicObject(866, -240.45306396484, -12.975963592529, 3.1036152839661, 1.593017578125, 252.71301269531, 65.269775390625); //
	CreateDynamicObject(866, -239.82940673828, -8.5005435943604, 3.1036152839661, 1.593017578125, 265.61096191406, 65.269775390625); //
	CreateDynamicObject(866, -240.09819030762, -6.2881851196289, 3.1036152839661, 1.593017578125, 270.44219970703, 65.269775390625); //
	CreateDynamicObject(866, -240.72720336914, -4.4343500137329, 3.1036152839661, 1.593017578125, 276.88842773438, 60.433044433594); //
	CreateDynamicObject(866, -242.87512207031, -2.2708270549774, 3.1036152839661, 1.593017578125, 276.88293457031, 53.981323242188); //
	CreateDynamicObject(866, -243.54209899902, -3.429030418396, 3.1036152839661, 1.593017578125, 276.88293457031, 53.981323242188); //
	CreateDynamicObject(866, -241.21305847168, -1.1702342033386, 3.1036152839661, 1.593017578125, 286.55639648438, 62.042541503906); //
	CreateDynamicObject(866, -240.65106201172, 1.5918680429459, 3.1036152839661, 1.593017578125, 289.775390625, 62.039794921875); //
	CreateDynamicObject(866, -240.31329345703, 3.2488701343536, 3.1036152839661, 1.593017578125, 296.21887207031, 62.034301757813); //
	CreateDynamicObject(866, -240.11585998535, 4.2146730422974, 3.1036152839661, 1.593017578125, 305.88684082031, 62.02880859375); //
	CreateDynamicObject(866, -238.31057739258, 6.7228116989136, 3.1036152839661, 1.593017578125, 312.33032226563, 62.023315429688); //
	CreateDynamicObject(866, -237.33917236328, 7.9630813598633, 3.1036152839661, 1.593017578125, 320.38604736328, 63.630065917969); //
	CreateDynamicObject(866, -235.40557861328, 7.5695705413818, 3.1036152839661, 1.593017578125, 320.38330078125, 73.30078125); //
	CreateDynamicObject(866, -229.39250183105, 3.9013803005219, 3.1036152839661, 1.593017578125, 320.38330078125, 73.295288085938); //
	CreateDynamicObject(866, -227.9224395752, 5.5284099578857, 3.1036152839661, 1.593017578125, 323.60778808594, 76.519775390625); //
	CreateDynamicObject(866, -226.98695373535, 6.5637111663818, 3.1036152839661, 1.593017578125, 326.82678222656, 79.744262695313); //
	CreateDynamicObject(866, -226.01554870605, 6.8951892852783, 3.1036152839661, 1.593017578125, 326.8212890625, 84.575500488281); //
	CreateDynamicObject(866, -224.56430053711, 6.1218910217285, 3.1036152839661, 1.593017578125, 317.14233398438, 94.246215820313); //
	CreateDynamicObject(866, -224.42274475098, 6.1282711029053, 3.1036152839661, 1.593017578125, 317.13684082031, 103.91967773438); //
	CreateDynamicObject(866, -220.70547485352, 5.1886558532715, 3.1036152839661, 1.593017578125, 315.52459716797, 108.75091552734); //
	CreateDynamicObject(866, -219.01629638672, 5.2746047973633, 3.1036152839661, 1.593017578125, 315.52185058594, 113.58489990234); //
	CreateDynamicObject(866, -215.51614379883, 3.0541667938232, 3.1036152839661, 1.593017578125, 297.78717041016, 128.09234619141); //
	CreateDynamicObject(866, -220.25477600098, -0.85661566257477, 3.1036152839661, 1.593017578125, 296.17218017578, 126.47735595703); //
	CreateDynamicObject(866, -221.23902893066, -0.9066863656044, 3.1036152839661, 1.593017578125, 296.16943359375, 121.63787841797); //
	CreateDynamicObject(866, -221.94194030762, -0.94213646650314, 3.1036152839661, 1.593017578125, 296.16394042969, 115.18615722656); //
	CreateDynamicObject(866, -222.64506530762, -0.97729271650314, 3.1036152839661, 1.593017578125, 296.16394042969, 107.11944580078); //
	CreateDynamicObject(866, -223.34819030762, -1.0124489068985, 3.1036152839661, 1.593017578125, 286.49047851563, 95.830993652344); //
	CreateDynamicObject(866, -218.95628356934, -1.3521665334702, 3.1036152839661, 1.593017578125, 286.49047851563, 99.052734375); //
	CreateDynamicObject(866, -216.53045654297, 0.88866055011749, 3.1036152839661, 1.593017578125, 286.49047851563, 100.66497802734); //
	CreateDynamicObject(866, -213.51753234863, -0.087465539574623, 3.1036152839661, 1.593017578125, 286.49047851563, 103.88671875); //
	CreateDynamicObject(866, -213.11862182617, 3.1787104606628, 3.1036152839661, 1.593017578125, 286.49047851563, 103.88122558594); //
	CreateDynamicObject(866, -213.13250732422, 3.4592051506042, 3.1036152839661, 1.593017578125, 286.49047851563, 103.88122558594); //
	CreateDynamicObject(866, -199.95948791504, -3.0653939247131, 3.1036152839661, 1.593017578125, 286.49047851563, 103.88122558594); //
	CreateDynamicObject(866, -195.82485961914, -6.6633472442627, 3.1036152839661, 1.593017578125, 262.30682373047, 120.00366210938); //
	CreateDynamicObject(866, -194.62934875488, -5.1911334991455, 3.1036152839661, 1.593017578125, 263.91632080078, 119.99816894531); //
	CreateDynamicObject(866, -193.39100646973, -4.5628910064697, 3.1036152839661, 1.593017578125, 263.91357421875, 124.82940673828); //
	CreateDynamicObject(866, -195.11225891113, -7.0456643104553, 3.1036152839661, 4.8175048828125, 7.0916748046875, 140.94909667969); //
	CreateDynamicObject(866, -193.59375, -8.8932027816772, 3.1036152839661, 4.81201171875, 10.316162109375, 144.17358398438); //
	CreateDynamicObject(866, -191.86703491211, -10.053423881531, 3.1036152839661, 4.8065185546875, 13.53515625, 144.16809082031); //
	CreateDynamicObject(866, -190.47509765625, -11.746989250183, 3.1036152839661, 4.801025390625, 18.371887207031, 149.00482177734); //
	CreateDynamicObject(866, -188.93193054199, -11.897680282593, 3.1036152839661, 4.7955322265625, 21.593627929688, 145.77758789063); //
	CreateDynamicObject(866, -187.65812683105, -10.465037345886, 3.1036152839661, 4.7900390625, 21.588134765625, 142.54760742188); //
	CreateDynamicObject(866, -187.4781036377, -8.6416902542114, 3.1036152839661, 4.7845458984375, 21.582641601563, 139.31762695313); //
	CreateDynamicObject(866, -188.22746276855, -4.7447962760925, 3.1036152839661, 4.7845458984375, 18.352661132813, 136.09313964844); //
	CreateDynamicObject(866, -188.60595703125, -4.282069683075, 3.1036152839661, 4.7845458984375, 16.740417480469, 134.47540283203); //
	CreateDynamicObject(866, -188.60595703125, -4.282069683075, 3.1036152839661, 4.7845458984375, 16.740417480469, 134.47540283203); //
//CS_Compound
	CreateDynamicObject(16501, 2026.77, 328.31, 250.01,   0.00, 0.00, 90.00);
    CreateDynamicObject(16501, 2033.68, 328.31, 250.01,   0.00, 0.00, 90.00);
    CreateDynamicObject(16501, 2037.06, 324.90, 250.01,   0.00, 0.00, 0.75);
    CreateDynamicObject(16501, 2037.15, 317.82, 250.01,   0.00, 0.00, 0.75);
    CreateDynamicObject(16501, 2037.24, 310.79, 250.01,   0.00, 0.00, 0.75);
    CreateDynamicObject(16501, 2037.33, 303.72, 250.01,   0.00, 0.00, 0.75);
    CreateDynamicObject(16501, 2037.44, 296.91, 250.01,   0.00, 0.00, 0.75);
    CreateDynamicObject(16501, 2034.12, 293.45, 250.01,   0.00, 0.00, 90.00);
    CreateDynamicObject(16501, 2023.39, 293.41, 250.01,   0.00, 0.00, 90.00);
    CreateDynamicObject(16501, 2023.05, 328.30, 250.01,   0.00, 0.00, 90.00);
    CreateDynamicObject(16501, 2019.62, 324.77, 250.01,   0.00, 0.00, 0.75);
    CreateDynamicObject(16501, 2019.71, 312.19, 250.01,   0.00, 0.00, 0.75);
    CreateDynamicObject(16501, 2019.78, 305.26, 250.01,   0.00, 0.00, 0.75);
    CreateDynamicObject(16501, 2019.85, 296.92, 250.01,   0.00, 0.00, 0.75);
    CreateDynamicObject(16501, 2019.85, 299.69, 250.01,   0.00, 0.00, 0.75);
    CreateDynamicObject(16501, 2021.99, 296.90, 252.19,   0.00, 90.00, 0.75);
    CreateDynamicObject(16501, 2026.34, 296.94, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2030.74, 297.00, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2035.12, 297.12, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2035.00, 304.19, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2030.65, 304.04, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2026.25, 303.99, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2021.89, 303.99, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2021.77, 311.10, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2026.17, 311.09, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2030.52, 311.13, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2034.90, 311.17, 252.19,   0.00, 90.00, 0.75);
    CreateDynamicObject(16501, 2034.76, 318.26, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2030.38, 318.20, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2026.01, 318.13, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2021.63, 318.07, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2021.70, 324.78, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2026.10, 324.91, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2030.47, 325.02, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 2034.70, 325.09, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(3761, 2033.89, 317.26, 249.82,   0.00, 0.00, 270.00);
    CreateDynamicObject(3761, 2033.87, 306.49, 249.81,   0.00, 0.00, 270.00);
    CreateDynamicObject(18451, 2015.83, 313.68, 248.33,   0.00, 0.00, 0.00);
    CreateDynamicObject(18451, 2016.12, 297.77, 248.33,   0.00, 0.00, 180.00);
    CreateDynamicObject(13591, 2006.95, 325.15, 248.03,   0.00, 2.00, 266.00);
    CreateDynamicObject(12814, 2023.41, 324.82, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(12814, 2023.41, 274.82, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(12814, 1993.43, 274.82, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(12814, 1993.42, 324.81, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(12814, 1963.47, 324.77, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(18451, 2001.72, 299.31, 248.33,   0.00, 0.00, 270.00);
    CreateDynamicObject(12814, 1933.78, 324.80, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 1985.75, 340.56, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 1982.59, 340.60, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 1961.13, 352.30, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 1957.76, 352.33, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 1954.33, 352.45, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 1961.13, 352.30, 252.20,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 1957.75, 352.33, 252.10,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 1954.33, 352.45, 252.12,   0.00, 0.00, 0.00);
    CreateDynamicObject(12814, 1903.85, 324.62, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(12814, 1873.87, 324.69, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(7236, 1911.72, 321.94, 272.22,   0.00, 0.00, 0.00);
    CreateDynamicObject(3050, 2006.87, 262.63, 250.06,   0.00, 0.00, 60.00);
    CreateDynamicObject(3050, 2004.59, 268.12, 250.06,   0.00, 0.00, 89.50);
    CreateDynamicObject(2935, 1923.64, 340.65, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(2935, 1920.24, 340.72, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(2935, 1920.24, 340.72, 252.20,   0.00, 0.00, 0.00);
    CreateDynamicObject(2935, 1923.64, 340.65, 252.10,   0.00, 0.00, 0.00);
    CreateDynamicObject(2935, 1890.86, 340.60, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(2935, 1887.36, 340.63, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(2935, 1890.86, 340.60, 252.15,   0.00, 0.00, 0.00);
    CreateDynamicObject(2932, 1901.28, 352.15, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(2932, 1906.60, 352.20, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(2932, 1912.41, 351.97, 249.04,   0.00, 0.00, 0.00);
    CreateDynamicObject(2932, 1895.70, 352.84, 249.19,   0.00, 0.00, 351.95);
    CreateDynamicObject(1345, 1868.61, 338.32, 248.59,   0.00, 0.00, 270.00);
    CreateDynamicObject(1345, 2005.94, 275.71, 248.59,   0.00, 0.00, 270.00);
    CreateDynamicObject(1345, 2006.36, 277.50, 248.59,   0.00, 0.00, 358.00);
    CreateDynamicObject(2934, 1985.75, 340.56, 252.20,   0.00, 0.00, 0.00);
    CreateDynamicObject(12814, 1963.48, 274.80, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(12814, 1903.54, 274.68, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(12814, 1873.60, 274.69, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(16501, 1988.26, 291.07, 250.01,   0.00, 0.00, 90.75);
    CreateDynamicObject(12991, 2000.37, 282.52, 247.82,   0.00, 0.00, 88.00);
    CreateDynamicObject(16501, 1991.72, 294.64, 250.01,   0.00, 0.00, 180.74);
    CreateDynamicObject(16501, 1984.90, 284.01, 250.01,   0.00, 0.00, 0.74);
    CreateDynamicObject(16501, 1981.46, 280.39, 250.01,   0.00, 0.00, 271.74);
    CreateDynamicObject(16501, 1977.95, 283.75, 250.01,   0.00, 0.00, 0.74);
    CreateDynamicObject(16501, 1977.88, 290.73, 250.01,   0.00, 0.00, 0.74);
    CreateDynamicObject(16501, 1991.61, 301.70, 250.01,   0.00, 0.00, 180.74);
    CreateDynamicObject(16501, 1991.53, 308.77, 250.01,   0.00, 0.00, 180.74);
    CreateDynamicObject(16501, 1991.45, 315.65, 250.01,   0.00, 0.00, 180.74);
    CreateDynamicObject(16501, 1987.89, 319.06, 250.01,   0.00, 0.00, 270.74);
    CreateDynamicObject(16501, 1981.10, 318.95, 250.01,   0.00, 0.00, 270.74);
    CreateDynamicObject(16501, 1977.60, 315.40, 250.01,   0.00, 0.00, 0.74);
    CreateDynamicObject(16501, 1977.68, 308.41, 250.01,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1977.77, 301.52, 250.01,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1977.84, 297.33, 250.01,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1982.72, 287.57, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 1980.05, 287.50, 252.19,   0.00, 90.00, 0.74);
    CreateDynamicObject(16501, 1981.47, 282.45, 252.19,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1988.26, 291.07, 254.36,   0.00, 0.00, 90.74);
    CreateDynamicObject(16501, 1991.72, 294.64, 254.41,   0.00, 0.00, 180.74);
    CreateDynamicObject(16501, 1991.61, 301.70, 254.39,   0.00, 0.00, 180.74);
    CreateDynamicObject(16501, 1991.53, 308.77, 254.41,   0.00, 0.00, 180.74);
    CreateDynamicObject(16501, 1991.45, 315.65, 254.39,   0.00, 0.00, 180.74);
    CreateDynamicObject(16501, 1987.89, 319.06, 254.41,   0.00, 0.00, 270.74);
    CreateDynamicObject(16501, 1981.10, 318.95, 254.39,   0.00, 0.00, 270.74);
    CreateDynamicObject(16501, 1977.60, 315.40, 254.39,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1977.77, 301.52, 254.39,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1977.84, 297.33, 254.39,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1977.70, 294.39, 254.41,   0.00, 0.00, 0.74);
    CreateDynamicObject(16501, 1983.23, 291.01, 254.39,   0.00, 0.00, 90.74);
    CreateDynamicObject(16501, 1981.24, 290.97, 254.39,   0.00, 0.00, 90.74);
    CreateDynamicObject(16501, 1988.21, 293.21, 260.94,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1977.77, 301.52, 258.76,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1977.60, 315.40, 258.79,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1974.20, 305.04, 254.34,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1974.23, 305.00, 258.74,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1977.68, 308.39, 252.14,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1967.66, 304.92, 258.74,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1968.50, 304.96, 253.24,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1974.13, 307.15, 254.22,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1965.13, 304.89, 257.59,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1974.26, 305.00, 253.24,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1961.60, 304.89, 253.24,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1967.08, 307.08, 254.22,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1977.62, 313.00, 254.39,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1977.62, 313.00, 258.79,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1977.67, 307.33, 258.79,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1974.23, 309.35, 254.34,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1967.65, 309.27, 254.34,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1960.82, 309.18, 253.24,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1967.65, 309.27, 253.19,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1974.23, 309.35, 253.16,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1955.84, 309.12, 257.59,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1954.05, 309.06, 253.24,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1964.99, 309.24, 257.61,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1960.00, 306.98, 254.22,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1960.82, 309.18, 258.74,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1974.23, 309.35, 258.69,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1967.65, 309.27, 258.69,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1947.12, 308.98, 253.24,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1949.00, 309.02, 257.59,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1940.09, 308.90, 253.24,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1940.09, 308.90, 257.64,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1944.62, 308.97, 258.74,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1955.84, 309.12, 258.76,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1949.00, 309.02, 258.74,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1940.09, 308.90, 258.76,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1974.13, 307.15, 251.02,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1952.94, 306.89, 254.22,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1945.90, 306.80, 254.22,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1938.94, 306.68, 254.22,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1954.71, 304.81, 253.24,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1948.11, 304.72, 253.24,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1941.32, 304.60, 253.24,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1967.08, 307.08, 251.02,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1960.00, 306.98, 250.99,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1952.94, 306.89, 250.99,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1945.90, 306.80, 250.99,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1938.94, 306.68, 250.99,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1958.18, 304.83, 257.56,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1951.19, 304.73, 257.54,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1944.13, 304.63, 257.54,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1941.32, 304.60, 257.54,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1965.13, 304.89, 258.56,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1958.18, 304.83, 258.59,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1951.19, 304.73, 258.59,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1944.13, 304.63, 258.64,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1941.32, 304.60, 258.66,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1974.13, 307.17, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1967.05, 307.08, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1959.99, 306.99, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1952.90, 306.90, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1945.87, 306.81, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1938.94, 306.74, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1977.86, 294.51, 258.76,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1981.24, 290.97, 258.76,   0.00, 0.00, 90.74);
    CreateDynamicObject(16501, 1988.26, 291.07, 258.76,   0.00, 0.00, 90.74);
    CreateDynamicObject(16501, 1991.72, 294.64, 258.71,   0.00, 0.00, 180.74);
    CreateDynamicObject(16501, 1991.61, 301.70, 258.71,   0.00, 0.00, 180.74);
    CreateDynamicObject(16501, 1991.53, 308.77, 258.74,   0.00, 0.00, 180.74);
    CreateDynamicObject(16501, 1991.45, 315.65, 258.71,   0.00, 0.00, 180.74);
    CreateDynamicObject(16501, 1987.89, 319.06, 258.81,   0.00, 0.00, 270.74);
    CreateDynamicObject(16501, 1981.10, 318.95, 258.79,   0.00, 0.00, 270.74);
    CreateDynamicObject(16501, 1988.19, 297.62, 260.94,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1988.12, 302.00, 260.94,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1988.07, 306.39, 260.94,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1988.01, 310.81, 260.94,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1988.01, 315.17, 260.94,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1987.98, 316.92, 260.96,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1981.14, 316.89, 260.94,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1981.19, 312.59, 260.94,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1981.23, 308.28, 260.94,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1981.29, 303.87, 260.94,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1981.36, 299.47, 260.94,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1981.42, 295.06, 260.94,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1981.38, 293.14, 260.91,   0.00, 90.00, 90.74);
    CreateDynamicObject(3761, 1988.22, 312.90, 249.82,   0.00, 0.00, 274.00);
    CreateDynamicObject(3761, 1988.09, 305.01, 249.82,   0.00, 0.00, 270.00);
    CreateDynamicObject(2633, 1978.97, 307.23, 252.70,   0.00, 0.00, 270.00);
    CreateDynamicObject(2633, 1978.99, 314.20, 252.70,   0.00, 0.00, 270.00);
    CreateDynamicObject(2633, 1982.26, 317.55, 252.70,   0.00, 0.00, 180.00);
    CreateDynamicObject(2633, 1986.52, 317.55, 252.70,   0.00, 0.00, 179.99);
    CreateDynamicObject(2633, 1989.81, 314.51, 252.70,   0.00, 0.00, 89.99);
    CreateDynamicObject(2633, 1979.03, 310.06, 252.73,   0.00, 0.00, 270.00);
    CreateDynamicObject(2633, 1989.80, 310.41, 252.70,   0.00, 0.00, 89.99);
    CreateDynamicObject(2633, 1989.79, 307.21, 251.90,   0.00, 332.00, 89.99);
    CreateDynamicObject(2633, 1989.81, 303.51, 249.93,   0.00, 332.00, 89.99);
    CreateDynamicObject(2633, 1989.83, 299.78, 247.93,   0.00, 332.00, 89.99);
    CreateDynamicObject(2633, 1989.85, 296.08, 245.95,   0.00, 332.00, 89.99);
    CreateDynamicObject(3117, 1989.29, 317.70, 254.18,   0.00, 0.00, 0.00);
    CreateDynamicObject(3117, 1979.57, 317.44, 254.18,   0.00, 0.00, 0.00);
    CreateDynamicObject(2633, 1978.09, 306.35, 252.68,   0.00, 0.00, 180.00);
    CreateDynamicObject(16501, 1938.92, 304.58, 253.24,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1938.92, 304.58, 257.64,   0.00, 0.00, 270.73);
    CreateDynamicObject(16501, 1938.92, 304.58, 258.76,   0.00, 0.00, 270.73);
    CreateDynamicObject(16644, 1933.68, 298.91, 254.27,   0.00, 0.00, 90.00);
    CreateDynamicObject(16501, 1935.47, 300.68, 253.24,   0.00, 0.00, 0.73);
    CreateDynamicObject(16501, 1935.55, 294.02, 253.24,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.43, 295.23, 248.99,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.49, 305.31, 248.99,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.64, 287.14, 253.26,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.78, 277.05, 253.39,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.73, 280.60, 253.39,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1932.28, 273.54, 248.99,   0.00, 0.00, 270.72);
    CreateDynamicObject(16501, 1932.30, 273.54, 253.32,   0.00, 0.00, 270.71);
    CreateDynamicObject(16501, 1925.22, 273.44, 249.04,   0.00, 0.00, 270.71);
    CreateDynamicObject(16501, 1925.24, 273.45, 253.32,   0.00, 0.00, 270.71);
    CreateDynamicObject(16501, 1933.06, 308.81, 253.24,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1933.06, 308.81, 257.54,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1933.10, 308.85, 258.76,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1932.03, 308.79, 248.84,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1935.41, 305.34, 252.09,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.72, 284.46, 249.26,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.79, 278.95, 249.26,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.55, 294.02, 258.74,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.64, 287.14, 258.59,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.73, 280.60, 258.71,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.78, 277.05, 258.71,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1932.30, 273.54, 258.68,   0.00, 0.00, 270.71);
    CreateDynamicObject(16501, 1925.24, 273.45, 257.72,   0.00, 0.00, 270.71);
    CreateDynamicObject(16501, 1935.50, 300.70, 258.76,   0.00, 0.00, 0.72);
    CreateDynamicObject(16644, 1933.61, 281.41, 254.27,   0.00, 0.00, 90.00);
    CreateDynamicObject(16501, 1932.29, 280.01, 249.99,   0.00, 0.00, 88.71);
    CreateDynamicObject(16501, 1932.29, 280.01, 251.99,   0.00, 0.00, 88.71);
    CreateDynamicObject(16501, 1925.33, 280.17, 249.99,   0.00, 0.00, 88.71);
    CreateDynamicObject(16501, 1925.33, 280.17, 252.02,   0.00, 0.00, 88.71);
    CreateDynamicObject(16644, 1930.65, 278.26, 248.49,   0.00, 324.00, 179.00);
    CreateDynamicObject(16501, 1919.06, 273.35, 249.04,   0.00, 0.00, 270.71);
    CreateDynamicObject(16501, 1919.06, 273.35, 253.39,   0.00, 0.00, 270.71);
    CreateDynamicObject(16501, 1919.06, 273.35, 258.79,   0.00, 0.00, 270.71);
    CreateDynamicObject(16501, 1915.50, 278.71, 249.04,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.53, 276.79, 253.39,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.53, 276.79, 258.59,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1925.33, 280.17, 256.24,   0.00, 0.00, 88.71);
    CreateDynamicObject(16644, 1925.60, 274.82, 254.27,   0.00, 0.00, 180.75);
    CreateDynamicObject(3117, 1917.29, 277.01, 254.18,   0.00, 0.00, 0.00);
    CreateDynamicObject(3117, 1917.33, 279.05, 254.18,   0.00, 0.00, 0.00);
    CreateDynamicObject(3117, 1920.84, 279.05, 254.18,   0.00, 0.00, 0.00);
    CreateDynamicObject(3117, 1920.81, 277.02, 254.18,   0.00, 0.00, 0.00);
    CreateDynamicObject(16501, 1915.41, 285.71, 249.04,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.41, 285.71, 253.42,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.41, 285.71, 257.79,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.50, 278.71, 253.42,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.50, 278.71, 258.62,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.32, 292.68, 249.04,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.32, 292.68, 253.44,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.32, 292.68, 257.84,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.24, 299.70, 249.04,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.24, 299.70, 253.42,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.18, 305.08, 249.04,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1924.96, 308.69, 248.84,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1918.61, 308.60, 248.84,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1915.18, 305.08, 253.42,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.18, 305.08, 258.64,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1932.03, 308.79, 253.24,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1924.96, 308.68, 253.24,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1918.61, 308.60, 253.24,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1918.61, 308.60, 257.61,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1924.96, 308.68, 257.64,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1932.03, 308.79, 257.64,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1932.03, 308.79, 258.82,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1924.98, 308.73, 258.84,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1918.61, 308.60, 258.86,   0.00, 0.00, 90.73);
    CreateDynamicObject(16501, 1925.35, 280.16, 257.94,   0.00, 0.00, 88.71);
    CreateDynamicObject(16501, 1918.93, 280.31, 259.36,   0.00, 0.00, 88.71);
    CreateDynamicObject(16501, 1929.16, 280.07, 256.34,   0.00, 0.00, 88.71);
    CreateDynamicObject(16501, 1929.16, 280.07, 257.94,   0.00, 0.00, 88.71);
    CreateDynamicObject(12814, 1904.06, 364.59, 247.81,   0.00, 0.00, 269.99);
    CreateDynamicObject(12814, 1954.02, 364.75, 247.81,   0.00, 0.00, 269.99);
    CreateDynamicObject(12814, 2003.95, 364.77, 247.81,   0.00, 0.00, 89.99);
    CreateDynamicObject(7191, 1905.58, 335.57, 249.80,   0.00, 0.00, 270.00);
    CreateDynamicObject(7191, 1850.55, 335.58, 249.80,   0.00, 0.00, 270.00);
    CreateDynamicObject(1345, 1868.30, 340.83, 248.59,   0.00, 0.00, 270.00);
    CreateDynamicObject(7191, 1879.14, 371.29, 253.73,   0.00, 0.00, 179.75);
    CreateDynamicObject(7191, 1856.28, 349.43, 253.51,   0.00, 0.00, 90.36);
    CreateDynamicObject(7191, 1858.87, 327.13, 248.82,   0.00, 0.00, 179.75);
    CreateDynamicObject(7191, 1858.72, 282.19, 248.77,   0.00, 0.00, 179.75);
    CreateDynamicObject(7191, 1858.53, 237.91, 248.75,   0.00, 0.00, 179.75);
    CreateDynamicObject(7191, 1881.08, 249.73, 248.75,   0.00, 0.00, 269.75);
    CreateDynamicObject(7191, 1923.71, 249.81, 248.77,   0.00, 0.00, 269.99);
    CreateDynamicObject(7191, 1968.64, 250.20, 248.62,   0.00, 0.00, 269.99);
    CreateDynamicObject(7191, 1981.55, 250.18, 248.65,   0.00, 0.00, 269.99);
    CreateDynamicObject(2934, 1992.59, 254.92, 249.27,   0.00, 0.00, 80.00);
    CreateDynamicObject(2934, 1972.01, 254.24, 249.27,   0.00, 0.00, 310.00);
    CreateDynamicObject(4100, 1997.79, 258.23, 249.45,   0.00, 0.00, 322.00);
    CreateDynamicObject(4100, 1984.09, 257.78, 249.45,   0.00, 0.00, 322.00);
    CreateDynamicObject(4100, 1967.06, 257.48, 249.45,   0.00, 0.00, 322.00);
    CreateDynamicObject(4100, 1954.77, 253.17, 249.45,   0.00, 0.00, 358.00);
    CreateDynamicObject(3980, 2077.76, 313.45, 257.55,   0.00, 0.00, 270.00);
    CreateDynamicObject(3980, 1976.10, 396.04, 257.55,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 2030.42, 353.36, 249.12,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 2033.46, 353.33, 249.12,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 2036.54, 353.36, 249.12,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 2039.67, 353.34, 249.12,   0.00, 0.00, 0.00);
    CreateDynamicObject(2934, 2032.40, 357.54, 249.12,   0.00, 0.00, 90.00);
    CreateDynamicObject(2934, 2038.65, 357.99, 249.12,   0.00, 0.00, 90.00);
    CreateDynamicObject(3980, 1819.87, 286.10, 253.05,   0.00, 0.00, 89.75);
    CreateDynamicObject(6930, 1896.57, 368.31, 255.00,   0.00, 0.00, 90.00);
    CreateDynamicObject(3980, 1911.84, 210.71, 253.05,   0.00, 0.00, 179.75);
    CreateDynamicObject(3980, 1982.77, 211.21, 253.05,   0.00, 0.00, 179.75);
    CreateDynamicObject(7191, 1856.37, 349.70, 249.80,   0.00, 0.00, 89.75);
    CreateDynamicObject(7191, 1879.10, 371.38, 249.80,   0.00, 0.00, 179.75);
    CreateDynamicObject(18259, 1875.78, 303.72, 248.81,   0.00, 0.00, 177.82);
    CreateDynamicObject(16644, 1916.66, 287.80, 254.27,   0.00, 0.00, 90.00);
    CreateDynamicObject(16644, 1916.66, 298.19, 254.27,   0.00, 0.00, 90.00);
    CreateDynamicObject(16644, 1926.06, 306.92, 254.27,   0.00, 0.00, 180.83);
    CreateDynamicObject(3594, 1932.64, 296.04, 248.34,   0.00, 0.00, 0.00);
    CreateDynamicObject(3594, 1929.37, 296.23, 248.34,   0.00, 0.00, 23.67);
    CreateDynamicObject(12930, 1947.80, 255.10, 248.67,   0.00, 0.00, 88.66);
    CreateDynamicObject(3675, 1929.17, 271.91, 254.15,   0.00, 0.00, 0.00);
    CreateDynamicObject(3675, 1931.21, 272.02, 254.15,   0.00, 0.00, 0.00);
    CreateDynamicObject(761, 1934.56, 272.51, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(761, 1934.59, 271.15, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(761, 1933.39, 271.82, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(3675, 1927.66, 271.82, 254.15,   0.00, 0.00, 0.00);
    CreateDynamicObject(6933, 2035.72, 252.39, 247.80,   0.00, 0.00, 0.00);
    CreateDynamicObject(761, 2006.44, 271.05, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(761, 2005.93, 270.01, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(761, 1986.09, 284.14, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(761, 1986.38, 282.09, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(761, 1986.44, 280.47, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(2935, 1887.36, 340.63, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(2935, 1911.76, 292.56, 249.14,   0.00, 0.00, 0.00);
    CreateDynamicObject(2567, 1979.18, 296.83, 249.72,   0.00, 0.00, 87.62);
    CreateDynamicObject(3594, 1869.30, 260.31, 248.34,   0.00, 0.00, 0.00);
    CreateDynamicObject(3594, 1866.95, 305.73, 248.34,   0.00, 0.00, 0.00);
    CreateDynamicObject(2935, 1880.81, 258.33, 248.87,   0.00, 0.00, 20.76);
    CreateDynamicObject(2935, 1876.39, 269.18, 249.14,   0.00, 0.00, 0.00);
    CreateDynamicObject(3594, 1881.22, 269.97, 248.34,   0.00, 0.00, 0.00);
    CreateDynamicObject(818, 1892.43, 253.34, 246.98,   0.00, 0.00, 0.00);
    CreateDynamicObject(818, 1890.22, 256.69, 245.82,   0.00, 0.00, 59.61);
    CreateDynamicObject(818, 1885.17, 258.10, 245.82,   0.00, 0.00, 59.61);
    CreateDynamicObject(818, 1967.25, 280.40, 245.82,   0.00, 0.00, 59.61);
    CreateDynamicObject(818, 1962.63, 283.60, 245.82,   0.00, 0.00, 59.61);
    CreateDynamicObject(818, 1963.59, 280.31, 245.82,   0.00, 0.00, 59.61);
    CreateDynamicObject(818, 1940.74, 333.95, 245.82,   0.00, 0.00, 59.61);
    CreateDynamicObject(818, 1939.39, 333.77, 245.82,   0.00, 0.00, 59.61);
    CreateDynamicObject(818, 1930.72, 335.15, 245.82,   0.00, 0.00, 59.61);
    CreateDynamicObject(13591, 1983.36, 328.05, 248.03,   0.00, 2.00, 266.00);
    CreateDynamicObject(2934, 1992.36, 329.70, 249.27,   0.00, 0.00, 0.00);
    CreateDynamicObject(818, 2015.89, 325.97, 245.82,   0.00, 0.00, 59.61);
    CreateDynamicObject(818, 2014.75, 323.53, 245.82,   0.00, 0.00, 59.61);
    CreateDynamicObject(818, 2017.58, 320.31, 245.82,   0.00, 0.00, 59.61);
    CreateDynamicObject(761, 2011.85, 296.87, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(1329, 1976.69, 273.48, 248.14,   84.00, 0.00, 259.06);
    CreateDynamicObject(1329, 1976.47, 269.95, 248.14,   84.00, 0.00, 0.00);
    CreateDynamicObject(1329, 1926.26, 291.96, 248.14,   84.00, 0.00, 259.06);
    CreateDynamicObject(1329, 1937.13, 333.59, 248.14,   84.00, 0.00, 259.06);
    CreateDynamicObject(1529, 2004.90, 306.32, 248.96,   0.00, 0.00, 0.00);
    CreateDynamicObject(1530, 2004.88, 311.93, 248.96,   0.00, 0.00, 0.00);
    CreateDynamicObject(1530, 2004.92, 311.40, 248.86,   0.00, 0.00, 0.00);
    CreateDynamicObject(1531, 2004.89, 297.75, 249.17,   0.00, 0.00, 0.00);
    CreateDynamicObject(18662, 2004.86, 272.52, 249.42,   0.00, 0.00, 0.00);
    CreateDynamicObject(12814, 1933.51, 274.83, 247.81,   0.00, 0.00, 0.00);
    CreateDynamicObject(16501, 1931.84, 306.58, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1924.77, 306.50, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1918.32, 306.38, 260.89,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1918.37, 302.15, 260.89,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1918.43, 297.81, 260.89,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1918.50, 293.47, 260.89,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1918.56, 289.09, 260.89,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1918.64, 284.72, 260.89,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1918.71, 280.36, 260.89,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1918.77, 276.02, 260.89,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1918.78, 275.32, 260.91,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1924.84, 302.14, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1924.92, 297.72, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1924.98, 293.26, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1925.03, 288.90, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1925.07, 284.55, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1925.14, 280.28, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1925.18, 275.88, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1925.31, 275.41, 260.89,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1931.88, 302.20, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1931.95, 297.78, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1932.13, 293.37, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1932.18, 289.00, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1932.25, 284.57, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1932.29, 280.15, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1932.34, 275.74, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1932.38, 275.48, 260.87,   0.00, 90.00, 90.74);
    CreateDynamicObject(16501, 1932.30, 273.54, 257.67,   0.00, 0.00, 270.71);
    CreateDynamicObject(16501, 1925.24, 273.45, 258.72,   0.00, 0.00, 270.71);
    CreateDynamicObject(16501, 1919.06, 273.35, 257.77,   0.00, 0.00, 270.71);
    CreateDynamicObject(16501, 1915.53, 276.79, 257.79,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.50, 278.71, 257.81,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.41, 285.71, 258.59,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.32, 292.68, 258.75,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.24, 299.70, 258.75,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.24, 299.70, 257.82,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1915.18, 305.08, 257.81,   0.00, 0.00, 180.71);
    CreateDynamicObject(16501, 1935.47, 300.68, 257.64,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.57, 294.02, 257.61,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.64, 287.12, 257.66,   0.00, 0.00, 0.72);
    CreateDynamicObject(16501, 1935.76, 277.07, 257.79,   0.00, 0.00, 0.72);
    CreateDynamicObject(7191, 2004.79, 313.41, 249.07,   0.00, 0.00, 179.71);
    CreateDynamicObject(7191, 2004.67, 290.29, 249.07,   0.00, 0.00, 179.71);
    CreateDynamicObject(7191, 2004.40, 235.97, 249.07,   0.00, 0.00, 179.71);
    CreateDynamicObject(7191, 1982.87, 336.28, 249.07,   0.00, 0.00, 269.45);
    CreateDynamicObject(3498, 1935.28, 304.55, 256.39,   0.00, 0.00, 0.00);
    //CS_Hospital
    CreateDynamicObject(14847,1910.69995117,89.50000000,962.70001221,0.00000000,0.00000000,0.00000000); //object(mp_sfpd_big) (1)
	CreateDynamicObject(1555,1909.00000000,100.40000153,959.29998779,0.00000000,0.00000000,0.00000000); //object(gen_doorext17) (1)
	CreateDynamicObject(1555,1910.50000000,100.40000153,959.29998779,0.00000000,0.00000000,0.00000000); //object(gen_doorext17) (2)
	CreateDynamicObject(3851,1910.09997559,100.40000153,961.90002441,0.00000000,0.00000000,90.00000000); //object(carshowwin_sfsx) (1)
	CreateDynamicObject(3851,1921.40002441,100.40000153,961.90002441,0.00000000,0.00000000,90.00000000); //object(carshowwin_sfsx) (2)
	CreateDynamicObject(3851,1910.09997559,100.40000153,958.00000000,0.00000000,0.00000000,90.00000000); //object(carshowwin_sfsx) (3)
	CreateDynamicObject(1703,1904.80004883,92.90000153,959.29998779,0.00000000,0.00000000,92.00000000); //object(kb_couch02) (1)
	CreateDynamicObject(2065,1924.19995117,97.80000305,959.29998779,0.00000000,0.00000000,270.00000000); //object(cj_m_fileing1) (1)
	CreateDynamicObject(2065,1924.19995117,97.80000305,960.70001221,0.00000000,0.00000000,269.99450684); //object(cj_m_fileing1) (2)
	CreateDynamicObject(2065,1924.19995117,97.19999695,959.29998779,0.00000000,0.00000000,269.99450684); //object(cj_m_fileing1) (3)
	CreateDynamicObject(2174,1923.09997559,92.00000000,959.29998779,0.00000000,0.00000000,180.00000000); //object(med_office4_desk_2) (1)
	CreateDynamicObject(2185,1917.80004883,93.80000305,959.29998779,0.00000000,0.00000000,0.00000000); //object(med_office6_desk_1) (1)
	CreateDynamicObject(2185,1920.09997559,93.48000336,959.29998779,0.00000000,0.00000000,90.00000000); //object(med_office6_desk_1) (2)
	CreateDynamicObject(1806,1918.19995117,95.00000000,959.29998779,0.00000000,0.00000000,156.00000000); //object(med_office_chair) (1)
	CreateDynamicObject(1806,1919.09997559,94.90000153,959.29998779,0.00000000,0.00000000,257.99487305); //object(med_office_chair) (2)
	CreateDynamicObject(1555,1899.90002441,93.40000153,959.29998779,0.00000000,0.00000000,269.99996948); //object(gen_doorext17) (3)
	CreateDynamicObject(1555,1899.90002441,93.40000153,961.59997559,0.00000000,0.00000000,269.99450684); //object(gen_doorext17) (4)
	CreateDynamicObject(1555,1899.90002441,94.00000000,961.59997559,0.00000000,0.00000000,269.99450684); //object(gen_doorext17) (5)
	CreateDynamicObject(1555,1899.90002441,94.00000000,959.09997559,0.00000000,0.00000000,269.99450684); //object(gen_doorext17) (6)
	CreateDynamicObject(1555,1899.90002441,83.09999847,959.29998779,0.00000000,0.00000000,270.00000000); //object(gen_doorext17) (7)
	CreateDynamicObject(1555,1899.90002441,82.50000000,959.29998779,0.00000000,0.00000000,269.99450684); //object(gen_doorext17) (8)
	CreateDynamicObject(1555,1899.90002441,82.50000000,961.79998779,0.00000000,0.00000000,269.99450684); //object(gen_doorext17) (9)
	CreateDynamicObject(1555,1899.90002441,83.09999847,961.79998779,0.00000000,0.00000000,269.99450684); //object(gen_doorext17) (10)
	CreateDynamicObject(1555,1929.19995117,83.30000305,959.29998779,0.00000000,0.00000000,90.75000000); //object(gen_doorext17) (11)
	CreateDynamicObject(1555,1929.19995117,82.69999695,959.29998779,0.00000000,0.00000000,90.74707031); //object(gen_doorext17) (12)
	CreateDynamicObject(1555,1929.19995117,82.69999695,961.79998779,0.00000000,0.00000000,90.74707031); //object(gen_doorext17) (13)
	CreateDynamicObject(1555,1929.19995117,83.30000305,961.79998779,0.00000000,0.00000000,90.74707031); //object(gen_doorext17) (14)
	CreateDynamicObject(1555,1929.19995117,80.19999695,959.29998779,0.00000000,0.00000000,90.74707031); //object(gen_doorext17) (15)
	CreateDynamicObject(1555,1929.19995117,80.80000305,959.29998779,0.00000000,0.00000000,90.74707031); //object(gen_doorext17) (16)
	CreateDynamicObject(1555,1929.19995117,80.80000305,961.79998779,0.00000000,0.00000000,90.74707031); //object(gen_doorext17) (17)
	CreateDynamicObject(1555,1929.19995117,80.19999695,961.79998779,0.00000000,0.00000000,90.74707031); //object(gen_doorext17) (18)
	CreateDynamicObject(1808,1904.30004883,91.90000153,959.29998779,0.00000000,0.00000000,92.00000000); //object(cj_watercooler2) (1)
	CreateDynamicObject(1977,1916.69995117,98.00000000,959.29998779,0.00000000,0.00000000,270.00000000); //object(vendin3) (1)
	CreateDynamicObject(2190,1914.00000000,88.00000000,960.50000000,0.00000000,0.00000000,0.00000000); //object(pc_1) (1)
	CreateDynamicObject(2190,1909.69995117,88.00000000,960.50000000,0.00000000,0.00000000,0.00000000); //object(pc_1) (2)
	CreateDynamicObject(2190,1905.50000000,88.00000000,960.50000000,0.00000000,0.00000000,0.00000000); //object(pc_1) (3)
	CreateDynamicObject(1781,1907.40002441,87.90000153,960.50000000,0.00000000,0.00000000,336.00000000); //object(med_tv_1) (1)
	CreateDynamicObject(1840,1917.09997559,81.09999847,962.59997559,0.00000000,0.00000000,0.00000000); //object(speaker_2) (1)
	CreateDynamicObject(2007,1913.09997559,80.69999695,959.29998779,0.00000000,0.00000000,182.00000000); //object(filing_cab_nu01) (1)
	CreateDynamicObject(1742,1911.00000000,80.09999847,959.29998779,0.00000000,0.00000000,180.00000000); //object(med_bookshelf) (1)
	CreateDynamicObject(2007,1914.40002441,80.69999695,959.29998779,0.00000000,0.00000000,181.99951172); //object(filing_cab_nu01) (2)
	CreateDynamicObject(2007,1904.40002441,84.90000153,959.29998779,0.00000000,0.00000000,89.99954224); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2161,1906.90002441,80.69999695,959.29998779,0.00000000,0.00000000,0.00000000); //object(med_office_unit_4) (1)
	CreateDynamicObject(2199,1909.09997559,80.30000305,959.29998779,0.00000000,0.00000000,179.99993896); //object(med_office6_mc_1) (1)
	CreateDynamicObject(2255,1916.59997559,85.19999695,961.50000000,0.00000000,0.00000000,268.00000000); //object(frame_clip_2) (1)
	CreateDynamicObject(1840,1910.59997559,88.19999695,963.79998779,0.00000000,322.00000000,272.00000000); //object(speaker_2) (2)
	CreateDynamicObject(1840,1917.69995117,100.09999847,962.29998779,0.00000000,348.00000000,130.99993896); //object(speaker_2) (3)
	CreateDynamicObject(2000,1897.30004883,87.09999847,959.40002441,0.00000000,0.00000000,90.00000000); //object(filing_cab_nu) (1)
	CreateDynamicObject(2000,1897.80004883,90.80000305,959.29998779,0.00000000,0.00000000,0.00000000); //object(filing_cab_nu) (2)
	CreateDynamicObject(1999,1903.09997559,89.30000305,959.29998779,0.00000000,0.00000000,269.99996948); //object(officedesk2) (1)
	CreateDynamicObject(2161,1896.80004883,88.30000305,959.29998779,0.00000000,0.00000000,90.00000000); //object(med_office_unit_4) (2)
	CreateDynamicObject(1840,1896.80004883,84.19999695,962.29998779,0.00000000,340.00000000,227.99996948); //object(speaker_2) (4)
	CreateDynamicObject(2198,1899.50000000,84.69999695,959.20001221,0.00000000,0.00000000,179.99993896); //object(med_office2_desk_3) (1)
	CreateDynamicObject(948,1897.30004883,84.69999695,959.29998779,0.00000000,0.00000000,0.00000000); //object(plant_pot_10) (1)
	CreateDynamicObject(1731,1903.19995117,84.40000153,961.00000000,0.00000000,0.00000000,270.00000000); //object(cj_mlight3) (1)
	CreateDynamicObject(2001,1904.50000000,96.09999847,959.29998779,0.00000000,0.00000000,0.00000000); //object(nu_plant_ofc) (1)
	CreateDynamicObject(14699,1912.30004883,91.19999695,965.79998779,0.00000000,0.00000000,0.00000000); //object(int_tat_lights) (1)
	CreateDynamicObject(14699,1908.00000000,82.59999847,962.70001221,0.00000000,0.00000000,270.00000000); //object(int_tat_lights) (2)
	CreateDynamicObject(948,1918.19995117,99.50000000,959.29998779,0.00000000,0.00000000,0.00000000); //object(plant_pot_10) (2)
	CreateDynamicObject(2196,1919.50000000,94.19999695,960.13000488,0.00000000,0.00000000,114.99993896); //object(work_lamp1) (1)
	CreateDynamicObject(2239,1924.40002441,91.80000305,959.29998779,0.00000000,0.00000000,334.00000000); //object(cj_mlight16) (1)
	CreateDynamicObject(3851,1928.69995117,100.50000000,961.09997559,0.00000000,0.00000000,270.00000000); //object(carshowwin_sfsx) (4)
	CreateDynamicObject(3851,1936.90002441,100.50000000,961.09997559,0.00000000,0.00000000,270.00000000); //object(carshowwin_sfsx) (5)
	CreateDynamicObject(2953,1910.40002441,87.59999847,960.59997559,0.00000000,0.00000000,0.00000000); //object(kmb_paper_code) (1)
	CreateDynamicObject(2132,1926.00000000,99.69999695,959.29998779,0.00000000,0.00000000,0.00000000); //object(cj_kitch2_sink) (1)
	CreateDynamicObject(1997,1932.09997559,97.50000000,959.29998779,0.00000000,0.00000000,0.00000000); //object(hos_trolley) (1)
	CreateDynamicObject(2994,1931.19995117,99.00000000,959.79998779,0.00000000,0.00000000,236.00000000); //object(kmb_trolley) (1)
	CreateDynamicObject(2164,1925.09997559,96.59999847,959.29998779,0.00000000,0.00000000,89.99993896); //object(med_office_unit_5) (1)
	CreateDynamicObject(2163,1925.09997559,94.59999847,959.29998779,0.00000000,0.00000000,89.99993896); //object(med_office_unit_2) (1)
	CreateDynamicObject(2190,1925.09997559,95.00000000,960.23004150,0.00000000,0.00000000,92.00000000); //object(pc_1) (4)
	CreateDynamicObject(1840,1925.19995117,100.19999695,962.29998779,0.00000000,346.00000000,123.99993896); //object(speaker_2) (5)
	CreateDynamicObject(3383,1927.19995117,92.30000305,959.29998779,0.00000000,0.00000000,0.00000000); //object(a51_labtable1_) (1)
	CreateDynamicObject(2700,1932.40002441,91.90000153,962.50000000,0.00000000,22.00000000,119.99993896); //object(cj_sex_tv2) (1)
	CreateDynamicObject(2271,1932.19995117,94.69999695,961.09997559,0.00000000,0.00000000,269.99996948); //object(frame_wood_1) (1)
	CreateDynamicObject(1997,1934.59997559,85.59999847,959.29998779,0.00000000,0.00000000,269.99996948); //object(hos_trolley) (2)
	CreateDynamicObject(1997,1931.59997559,85.59999847,959.29998779,0.00000000,0.00000000,269.99450684); //object(hos_trolley) (3)
	CreateDynamicObject(1997,1925.69995117,85.19999695,959.29998779,0.00000000,0.00000000,179.99450684); //object(hos_trolley) (4)
	CreateDynamicObject(1749,1931.45007324,99.05000305,960.13000488,0.00000000,0.00000000,326.00000000); //object(med_tv_3) (1)
	CreateDynamicObject(1330,1929.80004883,92.00000000,959.79998779,0.00000000,0.00000000,0.00000000); //object(binnt14_la) (1)
	CreateDynamicObject(1330,1916.69995117,96.59999847,959.79998779,0.00000000,0.00000000,0.00000000); //object(binnt14_la) (2)
	CreateDynamicObject(1330,1916.19995117,86.40000153,959.90002441,0.00000000,0.00000000,0.00000000); //object(binnt14_la) (3)
	CreateDynamicObject(1330,1904.80004883,86.59999847,959.79998779,0.00000000,0.00000000,0.00000000); //object(binnt14_la) (4)
	CreateDynamicObject(1330,1900.00000000,90.90000153,959.79998779,0.00000000,0.00000000,0.00000000); //object(binnt14_la) (5)
	CreateDynamicObject(1330,1920.30004883,95.90000153,959.79998779,0.00000000,0.00000000,0.00000000); //object(binnt14_la) (6)
	CreateDynamicObject(1806,1902.40002441,88.80000305,959.29998779,0.00000000,0.00000000,242.00000000); //object(med_office_chair) (3)
	CreateDynamicObject(14699,1924.59997559,87.09999847,961.70001221,0.00000000,0.00000000,359.99450684); //object(int_tat_lights) (3)
	CreateDynamicObject(14699,1932.50000000,87.09999847,961.70001221,0.00000000,0.00000000,359.98901367); //object(int_tat_lights) (4)
	CreateDynamicObject(1771,1941.90002441,97.90000153,959.90002441,0.00000000,0.00000000,269.99996948); //object(cj_bunk_bed1) (2)
	CreateDynamicObject(1771,1941.90002441,94.00000000,959.90002441,0.00000000,0.00000000,269.99450684); //object(cj_bunk_bed1) (3)
	CreateDynamicObject(1771,1934.40002441,98.09999847,959.90002441,0.00000000,0.00000000,269.99450684); //object(cj_bunk_bed1) (4)
	CreateDynamicObject(1997,1934.09997559,94.90000153,959.29998779,0.00000000,0.00000000,92.00000000); //object(hos_trolley) (5)
	CreateDynamicObject(14532,1938.40002441,99.69999695,960.29998779,0.00000000,0.00000000,181.99996948); //object(tv_stand_driv) (1)
	CreateDynamicObject(1840,1933.19995117,100.19999695,962.20001221,0.00000000,338.00000000,126.00000000); //object(speaker_2) (6)
	CreateDynamicObject(2994,1936.09997559,97.19999695,959.79998779,0.00000000,0.00000000,319.99734497); //object(kmb_trolley) (2)
	CreateDynamicObject(2994,1935.50000000,95.00000000,959.79998779,0.00000000,0.00000000,1.99328613); //object(kmb_trolley) (3)
	CreateDynamicObject(2994,1940.00000000,97.80000305,959.79998779,0.00000000,0.00000000,179.98852539); //object(kmb_trolley) (4)
	CreateDynamicObject(2994,1942.19995117,95.19999695,959.79998779,0.00000000,2.00000000,69.98352051); //object(kmb_trolley) (5)
	CreateDynamicObject(1811,1939.90002441,92.90000153,959.90002441,0.00000000,0.00000000,209.99996948); //object(med_din_chair_5) (1)
	CreateDynamicObject(1811,1940.69995117,95.19999695,959.90002441,0.00000000,0.00000000,125.99816895); //object(med_din_chair_5) (2)
	CreateDynamicObject(1811,1942.40002441,96.69999695,959.90002441,0.00000000,0.00000000,339.99667358); //object(med_din_chair_5) (3)
	CreateDynamicObject(1811,1935.00000000,96.90000153,959.90002441,0.00000000,0.00000000,339.99389648); //object(med_din_chair_5) (4)
	CreateDynamicObject(1811,1932.69995117,90.80000305,959.90002441,0.00000000,0.00000000,83.99389648); //object(med_din_chair_5) (5)
	CreateDynamicObject(1811,1929.09997559,90.80000305,959.90002441,0.00000000,0.00000000,89.99047852); //object(med_din_chair_5) (6)
	CreateDynamicObject(1811,1928.09997559,90.80000305,959.90002441,0.00000000,0.00000000,89.98901367); //object(med_din_chair_5) (7)
	CreateDynamicObject(1808,1925.30004883,87.69999695,959.29998779,0.00000000,0.00000000,91.99951172); //object(cj_watercooler2) (2)
	CreateDynamicObject(1330,1927.09997559,90.80000305,959.79998779,0.00000000,0.00000000,0.00000000); //object(binnt14_la) (7)
	CreateDynamicObject(1840,1925.00000000,88.19999695,962.79998779,0.00000000,336.00000000,221.99996948); //object(speaker_2) (7)
	CreateDynamicObject(1330,1937.40002441,92.00000000,959.79998779,0.00000000,0.00000000,0.00000000); //object(binnt14_la) (8)
	CreateDynamicObject(2010,1936.40002441,90.80000305,959.29998779,0.00000000,0.00000000,30.00000000); //object(nu_plant3_ofc) (1)
	CreateDynamicObject(2239,1938.50000000,91.90000153,959.29998779,0.00000000,0.00000000,0.00000000); //object(cj_mlight16) (2)
	CreateDynamicObject(2239,1937.09997559,99.90000153,959.29998779,0.00000000,0.00000000,0.00000000); //object(cj_mlight16) (3)
	CreateDynamicObject(2971,1922.30004883,81.40000153,959.29998779,0.00000000,0.00000000,0.00000000); //object(k_smashboxes) (1)
	CreateDynamicObject(2608,1924.59997559,83.59999847,959.90002441,0.00000000,0.00000000,268.00000000); //object(polce_shelf) (1)
	CreateDynamicObject(2007,1921.90002441,84.40000153,959.29998779,0.00000000,0.00000000,92.00000000); //object(filing_cab_nu01) (4)
	CreateDynamicObject(2007,1921.90002441,85.40000153,959.29998779,0.00000000,0.00000000,89.99951172); //object(filing_cab_nu01) (5)
	CreateDynamicObject(2462,1924.59997559,86.40000153,959.90002441,0.00000000,0.00000000,269.99996948); //object(cj_hobby_shelf) (1)
	CreateDynamicObject(1893,1919.30004883,83.40000153,963.09997559,0.00000000,0.00000000,269.99996948); //object(shoplight1) (1)
	CreateDynamicObject(1997,1920.59997559,81.40000153,959.29998779,0.00000000,0.00000000,0.00000000); //object(hos_trolley) (6)
	CreateDynamicObject(2163,1921.09997559,84.90000153,959.29998779,0.00000000,0.00000000,269.99996948); //object(med_office_unit_2) (2)
	CreateDynamicObject(2163,1917.59997559,84.80000305,959.29998779,0.00000000,0.00000000,91.99450684); //object(med_office_unit_2) (3)
	CreateDynamicObject(2000,1918.09997559,87.40000153,959.29998779,0.00000000,0.00000000,0.00000000); //object(filing_cab_nu) (3)
	CreateDynamicObject(2971,1898.00000000,99.00000000,959.29998779,0.00000000,0.00000000,0.00000000); //object(k_smashboxes) (2)
	CreateDynamicObject(1997,1898.40002441,96.00000000,959.29998779,0.00000000,0.00000000,92.00000000); //object(hos_trolley) (7)
	CreateDynamicObject(2199,1903.40002441,94.00000000,959.29998779,0.00000000,0.00000000,269.99996948); //object(med_office6_mc_1) (2)
	CreateDynamicObject(1893,1900.30004883,97.09999847,963.40002441,0.00000000,0.00000000,0.00000000); //object(shoplight1) (2)
	CreateDynamicObject(1893,1901.30004883,82.80000305,963.00000000,0.00000000,0.00000000,0.00000000); //object(shoplight1) (3)
	CreateDynamicObject(1893,1923.19995117,83.50000000,963.00000000,0.00000000,0.00000000,90.00000000); //object(shoplight1) (4)
	//CS_House
	CreateDynamicObject(19379, -1407.69, 528.32, 1031.17,   0.00, 90.00, 0.00);
	CreateDynamicObject(19379, -1418.19, 537.95, 1031.17,   0.00, 90.00, 0.00);
	CreateDynamicObject(19379, -1407.71, 537.95, 1031.17,   0.00, 90.00, 0.00);
	CreateDynamicObject(19379, -1418.19, 528.32, 1031.17,   0.00, 90.00, 0.00);
	CreateDynamicObject(19446, -1423.44, 528.32, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, -1423.44, 537.95, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19446, -1424.22, 523.48, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19446, -1404.96, 523.48, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19379, -1407.71, 547.58, 1031.17,   0.00, 90.00, 0.00);
	CreateDynamicObject(19379, -1418.19, 547.58, 1031.17,   0.00, 90.00, 0.00);
	CreateDynamicObject(19460, -1406.86, 523.42, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19368, -1412.75, 523.41, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(14874, -1412.03, 532.37, 1033.18,   0.00, 0.00, -90.00);
	CreateDynamicObject(19446, -1411.09, 531.87, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, -1411.09, 531.79, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19378, -1418.19, 537.95, 1034.84,   0.00, 90.00, 0.00);
	CreateDynamicObject(19378, -1418.17, 522.65, 1034.84,   0.00, 90.00, 0.00);
	CreateDynamicObject(19378, -1407.69, 522.65, 1034.83,   0.00, 90.00, 0.00);
	CreateDynamicObject(19378, -1407.69, 541.16, 1034.84,   0.00, 90.00, 0.00);
	CreateDynamicObject(19378, -1405.81, 531.53, 1034.84,   0.00, 90.00, 0.00);
	CreateDynamicObject(19460, -1402.46, 528.32, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, -1402.46, 537.95, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19459, -1423.44, 528.32, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, -1423.44, 537.95, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19439, -1411.26, 535.52, 1034.85,   0.00, 90.00, 0.00);
	CreateDynamicObject(19446, -1402.46, 528.33, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19446, -1423.84, 533.14, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19378, -1421.12, 529.01, 1034.83,   0.00, 90.00, 0.00);
	CreateDynamicObject(19446, -1415.85, 537.87, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19446, -1412.80, 544.50, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19377, -1418.19, 528.32, 1038.33,   0.00, 90.00, 0.00);
	CreateDynamicObject(19377, -1418.19, 537.95, 1038.33,   0.00, 90.00, 0.00);
	CreateDynamicObject(19377, -1407.71, 537.95, 1038.33,   0.00, 90.00, 0.00);
	CreateDynamicObject(19377, -1407.71, 528.32, 1038.33,   0.00, 90.00, 0.00);
	CreateDynamicObject(19369, -1417.46, 533.15, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19369, -1415.94, 531.46, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19369, -1415.95, 528.75, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19369, -1414.43, 527.38, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19369, -1412.61, 527.39, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, -1415.95, 525.56, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19378, -1407.71, 547.58, 1034.84,   0.00, 90.00, 0.00);
	CreateDynamicObject(19378, -1418.19, 547.58, 1034.84,   0.00, 90.00, 0.00);
	CreateDynamicObject(19377, -1418.19, 547.58, 1038.33,   0.00, 90.00, 0.00);
	CreateDynamicObject(19377, -1407.69, 547.58, 1038.33,   0.00, 90.00, 0.00);
	CreateDynamicObject(19397, -1420.67, 533.15, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19367, -1415.95, 522.35, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19354, -1409.54, 533.77, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19354, -1404.14, 533.73, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19369, -1423.88, 533.15, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19384, -1406.86, 533.75, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19459, -1418.86, 523.42, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, -1411.09, 525.56, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19441, -1415.95, 522.35, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19441, -1411.09, 523.17, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19369, -1409.47, 533.17, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, -1406.25, 533.16, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19369, -1403.05, 533.16, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19369, -1411.09, 552.72, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19397, -1411.09, 538.21, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, -1406.34, 542.72, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, -1402.46, 547.63, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19446, -1402.46, 537.96, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, -1406.19, 552.29, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, -1411.08, 543.83, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19397, -1411.07, 549.84, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, -1415.94, 541.91, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19397, -1420.12, 537.18, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19369, -1423.18, 537.17, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19369, -1417.63, 537.21, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19397, -1415.94, 548.34, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, -1420.74, 544.41, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, -1423.44, 547.57, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19369, -1415.94, 551.49, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(19461, -1420.71, 552.28, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, -1413.73, 552.30, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19427, -1411.97, 536.59, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19446, -1415.85, 549.64, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19384, -1415.84, 543.74, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19384, -1417.42, 533.14, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19461, -1423.43, 547.57, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19384, -1412.80, 538.11, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(1736, -1402.85, 528.72, 1034.18,   0.00, 0.00, -90.00);
	CreateDynamicObject(1704, -1404.36, 526.97, 1031.25,   0.00, 0.00, -90.00);
	CreateDynamicObject(1703, -1407.68, 528.61, 1031.24,   0.00, 0.00, 0.00);
	CreateDynamicObject(1704, -1408.81, 526.05, 1031.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(2311, -1407.45, 526.75, 1031.25,   0.00, 0.00, 0.00);
	CreateDynamicObject(2313, -1406.03, 523.96, 1031.25,   0.00, 0.00, 180.00);
	CreateDynamicObject(1792, -1406.57, 523.76, 1031.75,   0.00, 0.00, 180.00);
	CreateDynamicObject(19384, -1412.81, 550.92, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19446, -1402.45, 547.56, 1033.01,   0.00, 0.00, 0.00);
	CreateDynamicObject(19446, -1410.01, 552.47, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(2124, -1418.47, 537.36, 1032.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(2124, -1418.47, 538.36, 1032.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(2124, -1418.47, 539.36, 1032.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(2124, -1418.47, 540.36, 1032.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(2124, -1418.47, 541.36, 1032.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(2124, -1418.47, 542.36, 1032.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(2124, -1418.47, 543.36, 1032.08,   0.00, 0.00, 0.00);
	CreateDynamicObject(2124, -1420.67, 543.39, 1032.08,   0.00, 0.00, 180.00);
	CreateDynamicObject(2124, -1420.67, 542.39, 1032.08,   0.00, 0.00, 180.00);
	CreateDynamicObject(2124, -1420.67, 541.39, 1032.08,   0.00, 0.00, 180.00);
	CreateDynamicObject(2124, -1420.67, 540.39, 1032.08,   0.00, 0.00, 180.00);
	CreateDynamicObject(2124, -1420.67, 539.39, 1032.08,   0.00, 0.00, 180.00);
	CreateDynamicObject(2124, -1420.67, 538.39, 1032.08,   0.00, 0.00, 180.00);
	CreateDynamicObject(2124, -1420.67, 537.39, 1032.08,   0.00, 0.00, 180.00);
	CreateDynamicObject(2124, -1419.60, 536.59, 1032.08,   0.00, 0.00, -90.00);
	CreateDynamicObject(2124, -1419.65, 543.81, 1032.08,   0.00, 0.00, 90.00);
	CreateDynamicObject(19174, -1423.31, 543.14, 1033.66,   0.00, 0.00, 90.00);
	CreateDynamicObject(19173, -1423.34, 537.86, 1033.66,   0.00, 0.00, 90.00);
	CreateDynamicObject(19172, -1423.35, 549.10, 1033.66,   0.00, 0.00, 90.00);
	CreateDynamicObject(19175, -1415.95, 539.01, 1033.35,   0.00, 0.00, -90.00);
	CreateDynamicObject(16780, -1419.60, 540.39, 1034.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(16780, -1406.85, 526.85, 1034.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(1736, -1420.00, 533.55, 1033.61,   0.00, 0.00, 180.00);
	CreateDynamicObject(14866, -1403.82, 530.02, 1035.52,   0.00, 0.00, -90.00);
	CreateDynamicObject(2091, -1410.81, 529.20, 1034.93,   0.00, 0.00, 90.00);
	CreateDynamicObject(2296, -1417.15, 523.75, 1034.92,   0.00, 0.00, 180.00);
	CreateDynamicObject(1491, -1421.46, 533.10, 1034.76,   0.00, 0.00, 0.00);
	CreateDynamicObject(3961, -1428.41, 557.50, 1033.23,   0.00, 0.00, 90.00);
	CreateDynamicObject(19354, -1422.80, 552.46, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19354, -1416.41, 552.46, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(2959, -1426.44, 564.36, 1031.20,   0.00, 0.00, 90.00);
	CreateDynamicObject(1523, -1420.40, 552.40, 1031.23,   0.00, 0.00, 0.00);
	CreateDynamicObject(19384, -1419.61, 552.46, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(1506, -1412.20, 523.56, 1031.25,   0.00, 0.00, 180.00);
	CreateDynamicObject(19446, -1414.59, 523.48, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(19354, -1403.60, 552.45, 1033.01,   0.00, 0.00, 90.00);
	CreateDynamicObject(2833, -1413.45, 523.59, 1031.25,   0.00, 0.00, 0.00);
	CreateDynamicObject(2964, -1410.29, 545.06, 1031.25,   0.00, 0.00, 90.00);
	CreateDynamicObject(19474, -1407.87, 550.58, 1031.79,   0.00, 0.00, 0.00);
	CreateDynamicObject(1824, -1408.76, 540.80, 1031.75,   0.00, 0.00, 0.00);
	CreateDynamicObject(16151, -1403.60, 542.58, 1031.58,   0.00, 0.00, 0.00);
	CreateDynamicObject(2965, -1410.29, 544.95, 1032.15,   0.00, 0.00, 0.00);
	CreateDynamicObject(3004, -1409.95, 544.98, 1032.16,   0.00, 0.00, 12.60);
	CreateDynamicObject(1491, -1411.07, 549.09, 1034.76,   0.00, 0.00, 90.00);
	CreateDynamicObject(1491, -1411.06, 537.46, 1034.76,   0.00, 0.00, 90.00);
	CreateDynamicObject(2526, -1414.17, 526.91, 1034.92,   0.00, 0.00, 180.00);
	CreateDynamicObject(2528, -1412.27, 526.79, 1034.93,   0.00, 0.00, 0.00);
	CreateDynamicObject(14481, -1414.68, 526.60, 1036.93,   0.00, 0.00, 90.00);
	CreateDynamicObject(2136, -1413.51, 523.97, 1034.82,   0.00, 0.00, 180.00);
	CreateDynamicObject(1491, -1411.07, 524.82, 1034.76,   0.00, 0.00, 90.00);
	CreateDynamicObject(1491, -1415.98, 524.81, 1034.76,   0.00, 0.00, 90.00);
	CreateDynamicObject(2558, -1422.96, 527.70, 1036.35,   0.00, 0.00, 90.00);
	CreateDynamicObject(2558, -1422.96, 525.93, 1036.35,   0.00, 0.00, 90.00);
	CreateDynamicObject(3034, -1402.57, 528.72, 1032.75,   0.00, 0.00, -90.00);
	CreateDynamicObject(3034, -1414.21, 552.36, 1034.13,   0.00, 90.00, 0.00);
	CreateDynamicObject(2558, -1414.69, 551.98, 1033.41,   0.00, 0.00, 0.00);
	CreateDynamicObject(2561, -1402.93, 530.72, 1032.24,   0.00, 0.00, -90.00);
	CreateDynamicObject(3034, -1423.33, 527.33, 1036.89,   0.00, 0.00, 90.00);
	CreateDynamicObject(2561, -1403.88, 523.89, 1036.04,   0.00, 0.00, 180.00);
	CreateDynamicObject(3034, -1402.57, 547.55, 1036.26,   0.00, 0.00, -90.00);
	CreateDynamicObject(3034, -1405.87, 523.51, 1036.58,   0.00, 0.00, 180.00);
	CreateDynamicObject(2561, -1402.93, 549.55, 1035.73,   0.00, 0.00, -90.00);
	CreateDynamicObject(2161, -1405.94, 552.20, 1034.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(2161, -1404.75, 542.83, 1034.92,   0.00, 0.00, 180.00);
	CreateDynamicObject(2163, -1404.55, 542.85, 1036.25,   0.00, 0.00, 180.00);
	CreateDynamicObject(2163, -1408.85, 542.77, 1036.81,   0.00, 0.00, 180.00);
	CreateDynamicObject(2200, -1408.79, 542.88, 1034.92,   0.00, 0.00, 180.00);
	CreateDynamicObject(2163, -1407.05, 542.75, 1036.81,   0.00, 0.00, 180.00);
	CreateDynamicObject(2200, -1406.62, 542.91, 1034.92,   0.00, 0.00, 180.00);
	CreateDynamicObject(2207, -1405.64, 548.64, 1034.92,   0.00, 0.00, -90.00);
	CreateDynamicObject(1714, -1404.20, 547.66, 1034.93,   0.00, 0.00, -70.50);
	CreateDynamicObject(2700, -1410.73, 547.30, 1037.35,   0.00, 0.00, 0.00);
	CreateDynamicObject(2700, -1410.74, 546.08, 1037.35,   0.00, 0.00, 0.00);
	CreateDynamicObject(14492, -1420.83, 539.21, 1036.68,   0.00, 0.00, -90.00);
	CreateDynamicObject(19461, -1422.45, 541.68, 1036.51,   0.00, 0.00, 90.00);
	CreateDynamicObject(19369, -1417.79, 540.48, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(1491, -1415.92, 547.60, 1034.76,   0.00, 0.00, 90.00);
	CreateDynamicObject(1799, -1418.53, 529.56, 1034.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(19369, -1417.84, 538.76, 1036.51,   0.00, 0.00, 0.00);
	CreateDynamicObject(2021, -1404.03, 531.47, 1034.93,   0.00, 0.00, -90.00);
	CreateDynamicObject(2021, -1416.65, 531.57, 1034.92,   0.00, 0.00, 0.00);
	CreateDynamicObject(2029, -1420.08, 538.36, 1031.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(2029, -1420.08, 539.34, 1031.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(2029, -1420.08, 540.32, 1031.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(2029, -1420.08, 541.29, 1031.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(2029, -1420.08, 542.27, 1031.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(2029, -1420.08, 543.24, 1031.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(2029, -1420.08, 537.39, 1031.26,   0.00, 0.00, 0.00);
	CreateDynamicObject(2258, -1415.96, 548.49, 1033.30,   0.00, 0.00, -90.00);
	CreateDynamicObject(2330, -1409.48, 528.07, 1031.26,   0.00, 0.00, 90.00);
	CreateDynamicObject(19369, -1427.20, 564.40, 1032.84,   0.00, 0.00, 90.00);
	CreateDynamicObject(1985, -1417.78, 545.38, 1038.24,   0.00, 0.00, 214.74);
	CreateDynamicObject(1985, -1418.96, 545.11, 1038.24,   0.00, 0.00, -79.62);
	CreateDynamicObject(2629, -1421.39, 549.67, 1034.93,   0.00, 0.00, 66.42);
	CreateDynamicObject(2630, -1417.72, 550.94, 1034.93,   0.00, 0.00, 90.00);
	CreateDynamicObject(2627, -1421.79, 545.33, 1034.93,   0.00, 0.00, 90.00);
	//CS_PD
	CreateDynamicObject(19379,1469.39941406,-1754.00000000,3284.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (1)
	CreateDynamicObject(19379,1479.00000000,-1754.00000000,3284.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (2)
	CreateDynamicObject(1536,1475.69995117,-1748.86303711,3284.30004883,0.00000000,0.00000000,180.00000000); //object(gen_doorext15) (1)
	CreateDynamicObject(1536,1472.69921875,-1748.89941406,3284.30004883,0.00000000,0.00000000,0.00000000); //object(gen_doorext15) (2)
	CreateDynamicObject(19450,1464.50000000,-1753.59960938,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok10) (3)
	CreateDynamicObject(19450,1483.79980469,-1753.59960938,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok10) (4)
	CreateDynamicObject(18070,1474.19921875,-1755.89941406,3284.80004883,0.00000000,0.00000000,179.99450684); //object(gap_counter) (1)
	CreateDynamicObject(19379,1479.00000000,-1764.50000000,3284.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (3)
	CreateDynamicObject(19379,1469.39941406,-1764.50000000,3284.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (4)
	CreateDynamicObject(18070,1474.19995117,-1755.80004883,3287.10009766,0.00000000,179.99450684,179.99450684); //object(gap_counter) (3)
	CreateDynamicObject(19435,1477.80102539,-1756.59960938,3284.60009766,90.00000000,0.00000000,0.00000000); //object(cs_landbit_58_a) (1)
	CreateDynamicObject(19435,1477.80078125,-1755.09960938,3284.60009766,90.00000000,0.00000000,0.00000000); //object(cs_landbit_58_a) (3)
	CreateDynamicObject(19435,1476.13903809,-1753.40002441,3284.60009766,90.00000000,90.00000000,0.00000000); //object(cs_landbit_58_a) (4)
	CreateDynamicObject(19435,1472.69995117,-1753.40002441,3284.60009766,90.00000000,90.00000000,0.00000000); //object(cs_landbit_58_a) (5)
	CreateDynamicObject(19435,1472.26074219,-1753.40039062,3284.60009766,90.00000000,90.00000000,0.00000000); //object(cs_landbit_58_a) (6)
	CreateDynamicObject(19435,1470.59960938,-1755.09960938,3284.60009766,90.00000000,0.00000000,0.00000000); //object(cs_landbit_58_a) (7)
	CreateDynamicObject(19435,1470.59960938,-1756.59960938,3284.60009766,90.00000000,0.00000000,0.00000000); //object(cs_landbit_58_a) (8)
	CreateDynamicObject(19379,1479.00000000,-1754.00000000,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (5)
	CreateDynamicObject(19379,1469.40002441,-1754.00000000,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (6)
	CreateDynamicObject(19435,1477.80102539,-1756.59960938,3287.30004883,90.00000000,0.00000000,0.00000000); //object(cs_landbit_58_a) (9)
	CreateDynamicObject(19435,1477.79980469,-1755.09960938,3287.30004883,90.00000000,0.00000000,0.00000000); //object(cs_landbit_58_a) (10)
	CreateDynamicObject(19435,1476.09960938,-1753.39941406,3287.30004883,90.00000000,90.00000000,0.00000000); //object(cs_landbit_58_a) (11)
	CreateDynamicObject(19435,1472.69921875,-1753.39941406,3287.30004883,90.00000000,90.00000000,0.00000000); //object(cs_landbit_58_a) (12)
	CreateDynamicObject(19435,1472.30004883,-1753.40100098,3287.30004883,90.00000000,90.00000000,0.00000000); //object(cs_landbit_58_a) (13)
	CreateDynamicObject(19435,1470.59960938,-1755.09960938,3287.30004883,90.00000000,0.00000000,0.00000000); //object(cs_landbit_58_a) (14)
	CreateDynamicObject(19435,1470.60095215,-1756.59960938,3287.30004883,90.00000000,0.00000000,0.00000000); //object(cs_landbit_58_a) (15)
	CreateDynamicObject(19379,1459.79980469,-1764.50000000,3284.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (7)
	CreateDynamicObject(19379,1488.59960938,-1764.50000000,3284.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (8)
	CreateDynamicObject(19388,1483.79980469,-1763.19921875,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw15) (1)
	CreateDynamicObject(19358,1464.50000000,-1760.00000000,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (1)
	CreateDynamicObject(19431,1465.39941406,-1758.29980469,3286.00000000,0.00000000,0.00000000,270.00000000); //object(cs_landbit_48_a) (3)
	CreateDynamicObject(19388,1467.80004883,-1758.30004883,3286.00000000,0.00000000,0.00000000,270.00000000); //object(road_sfw15) (2)
	CreateDynamicObject(19358,1471.00000000,-1758.30004883,3286.00000000,0.00000000,0.00000000,90.00000000); //object(road_sfw12) (2)
	CreateDynamicObject(19358,1477.39941406,-1758.29980469,3286.00000000,0.00000000,0.00000000,90.00000000); //object(road_sfw12) (3)
	CreateDynamicObject(19388,1480.59960938,-1758.29980469,3286.00000000,0.00000000,0.00000000,270.00000000); //object(road_sfw15) (3)
	CreateDynamicObject(19358,1483.79980469,-1766.39941406,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (4)
	CreateDynamicObject(19358,1483.79980469,-1760.00000000,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (5)
	CreateDynamicObject(19388,1464.50000000,-1763.19921875,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw15) (4)
	CreateDynamicObject(19358,1464.50000000,-1766.39941406,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (6)
	CreateDynamicObject(19431,1483.00000000,-1768.00000000,3286.00000000,0.00000000,0.00000000,270.00000000); //object(cs_landbit_48_a) (4)
	CreateDynamicObject(19358,1479.00000000,-1769.51562500,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1477.39941406,-1768.00000000,3286.00000000,0.00000000,0.00000000,90.00000000); //object(road_sfw12) (8)
	CreateDynamicObject(14416,1474.09960938,-1771.00000000,3284.50000000,0.00000000,0.00000000,179.99450684); //object(carter-stairs07) (1)
	CreateDynamicObject(19450,1475.79980469,-1772.72900391,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok10) (3)
	CreateDynamicObject(19450,1472.50000000,-1772.72851562,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok10) (3)
	CreateDynamicObject(19379,1479.00000000,-1762.79980469,3287.70092773,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (5)
	CreateDynamicObject(19379,1469.39941406,-1762.79980469,3287.70092773,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (5)
	CreateDynamicObject(19379,1477.29980469,-1778.29980469,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (5)
	CreateDynamicObject(19450,1467.77197266,-1773.00000000,3289.50000000,0.00000000,0.00000000,270.00000000); //object(cs_detrok10) (1)
	CreateDynamicObject(19450,1477.30004883,-1768.00000000,3289.50000000,0.00000000,0.00000000,270.00000000); //object(cs_detrok10) (1)
	CreateDynamicObject(19450,1480.52697754,-1773.00000000,3289.50000000,0.00000000,0.00000000,270.00000000); //object(cs_detrok10) (1)
	CreateDynamicObject(19450,1485.30004883,-1777.90002441,3289.50000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok10) (4)
	CreateDynamicObject(19450,1463.00000000,-1777.90002441,3289.50000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok10) (4)
	CreateDynamicObject(19379,1480.50000000,-1777.89941406,3291.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (5)
	CreateDynamicObject(19379,1470.90002441,-1777.90002441,3291.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (5)
	CreateDynamicObject(19379,1461.29980469,-1777.89941406,3291.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (5)
	CreateDynamicObject(19379,1470.90002441,-1767.40002441,3291.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (5)
	CreateDynamicObject(19450,1472.50000000,-1768.09960938,3289.50000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok10) (4)
	CreateDynamicObject(19450,1475.80004883,-1768.09997559,3289.50000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok10) (4)
	CreateDynamicObject(19379,1467.69921875,-1778.29980469,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (5)
	CreateDynamicObject(19379,1486.90002441,-1778.30004883,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (5)
	CreateDynamicObject(19450,1467.80004883,-1782.69995117,3289.50000000,0.00000000,0.00000000,270.00000000); //object(cs_detrok10) (1)
	CreateDynamicObject(19450,1480.50000000,-1782.69995117,3289.50000000,0.00000000,0.00000000,270.00000000); //object(cs_detrok10) (1)
	CreateDynamicObject(19388,1474.09997559,-1782.69995117,3289.50000000,0.00000000,0.00000000,270.00000000); //object(road_sfw15) (5)
	CreateDynamicObject(19379,1474.09960938,-1788.79980469,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (5)
	CreateDynamicObject(19450,1478.79980469,-1787.59960938,3289.50000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok10) (4)
	CreateDynamicObject(19450,1469.39941406,-1787.59960938,3289.50000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok10) (4)
	CreateDynamicObject(19379,1474.09960938,-1788.39941406,3291.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (5)
	CreateDynamicObject(19431,1483.00000000,-1758.29980469,3286.00000000,0.00000000,0.00000000,270.00000000); //object(cs_landbit_48_a) (6)
	CreateDynamicObject(19431,1474.09997559,-1786.40002441,3289.50000000,0.00000000,0.00000000,180.00000000); //object(cs_landbit_48_a) (7)
	CreateDynamicObject(19431,1474.81298828,-1785.59997559,3289.50000000,0.00000000,0.00000000,90.00000000); //object(cs_landbit_48_a) (8)
	CreateDynamicObject(19388,1477.19995117,-1785.59997559,3289.50000000,0.00000000,0.00000000,270.00000000); //object(road_sfw15) (6)
	CreateDynamicObject(19431,1474.09960938,-1791.19921875,3289.50000000,0.00000000,0.00000000,179.99450684); //object(cs_landbit_48_a) (9)
	CreateDynamicObject(19358,1474.09960938,-1788.79980469,3289.50000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (19)
	CreateDynamicObject(19431,1478.80004883,-1793.19995117,3289.50000000,0.00000000,0.00000000,179.99450684); //object(cs_landbit_48_a) (11)
	CreateDynamicObject(19388,1474.19921875,-1758.29980469,3286.00000000,0.00000000,0.00000000,270.00000000); //object(road_sfw15) (3)
	CreateDynamicObject(19358,1485.40002441,-1768.00000000,3286.00000000,0.00000000,0.00000000,90.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1485.40002441,-1759.30004883,3286.00000000,0.00000000,0.00000000,90.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1487.00000000,-1766.40002441,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (4)
	CreateDynamicObject(19388,1487.00000000,-1763.19995117,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw15) (1)
	CreateDynamicObject(19358,1487.00000000,-1760.00000000,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (5)
	CreateDynamicObject(19379,1498.19995117,-1764.50000000,3284.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (8)
	CreateDynamicObject(19379,1507.80004883,-1764.50000000,3284.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (8)
	CreateDynamicObject(19379,1488.59997559,-1754.00000000,3284.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (8)
	CreateDynamicObject(19379,1498.19995117,-1754.00000000,3284.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (8)
	CreateDynamicObject(19379,1507.80004883,-1754.00000000,3284.19995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (8)
	CreateDynamicObject(19447,1487.09997559,-1756.80004883,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok13) (1)
	CreateDynamicObject(19385,1487.09997559,-1763.19995117,3286.00000000,0.00000000,0.00000000,0.00000000); //object(sfw_boxwest02) (1)
	CreateDynamicObject(19447,1492.00000000,-1769.69921875,3286.00000000,0.00000000,0.00000000,270.00000000); //object(cs_detrok13) (2)
	CreateDynamicObject(19355,1488.79980469,-1761.50000000,3286.00000000,0.00000000,0.00000000,90.00000000); //object(cs_landbit_12) (1)
	CreateDynamicObject(19355,1488.80004883,-1764.90002441,3286.00000000,0.00000000,0.00000000,90.00000000); //object(cs_landbit_12) (2)
	CreateDynamicObject(19385,1492.00000000,-1761.50000000,3286.00000000,0.00000000,0.00000000,90.00000000); //object(sfw_boxwest02) (2)
	CreateDynamicObject(19447,1490.39941406,-1756.59960938,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok13) (3)
	CreateDynamicObject(19385,1495.19921875,-1761.50000000,3286.00000000,0.00000000,0.00000000,90.00000000); //object(sfw_boxwest02) (6)
	CreateDynamicObject(19385,1498.39941406,-1761.50000000,3286.00000000,0.00000000,0.00000000,90.00000000); //object(sfw_boxwest02) (7)
	CreateDynamicObject(19385,1501.59997559,-1761.50000000,3286.00000000,0.00000000,0.00000000,90.00000000); //object(sfw_boxwest02) (8)
	CreateDynamicObject(19447,1493.59997559,-1756.69995117,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok13) (4)
	CreateDynamicObject(19447,1496.80004883,-1756.59997559,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok13) (5)
	CreateDynamicObject(19447,1500.09997559,-1756.59997559,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok13) (6)
	CreateDynamicObject(19447,1503.30004883,-1756.69995117,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok13) (7)
	CreateDynamicObject(19447,1503.29980469,-1766.29980469,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok13) (8)
	CreateDynamicObject(19385,1492.00000000,-1764.90002441,3286.00000000,0.00000000,0.00000000,90.00000000); //object(sfw_boxwest02) (9)
	CreateDynamicObject(19385,1495.19921875,-1764.89941406,3286.00000000,0.00000000,0.00000000,90.00000000); //object(sfw_boxwest02) (10)
	CreateDynamicObject(19385,1498.40002441,-1764.90002441,3286.00000000,0.00000000,0.00000000,90.00000000); //object(sfw_boxwest02) (11)
	CreateDynamicObject(19385,1501.59997559,-1764.90002441,3286.00000000,0.00000000,0.00000000,90.00000000); //object(sfw_boxwest02) (12)
	CreateDynamicObject(19447,1487.09960938,-1769.59960938,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok13) (9)
	CreateDynamicObject(19447,1501.59997559,-1769.69995117,3286.00000000,0.00000000,0.00000000,270.00000000); //object(cs_detrok13) (10)
	CreateDynamicObject(19447,1490.40002441,-1769.80004883,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok13) (11)
	CreateDynamicObject(19447,1493.59997559,-1769.80004883,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok13) (12)
	CreateDynamicObject(19447,1496.79980469,-1769.79980469,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok13) (13)
	CreateDynamicObject(19447,1500.00000000,-1769.80004883,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok13) (14)
	CreateDynamicObject(19447,1492.00000000,-1757.09997559,3286.00000000,0.00000000,0.00000000,270.00000000); //object(cs_detrok13) (15)
	CreateDynamicObject(19447,1501.59960938,-1757.09960938,3286.00000000,0.00000000,0.00000000,270.00000000); //object(cs_detrok13) (16)
	CreateDynamicObject(19379,1488.59960938,-1764.50000000,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (8)
	CreateDynamicObject(19379,1498.19995117,-1764.50000000,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (8)
	CreateDynamicObject(19379,1507.79980469,-1764.50000000,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (8)
	CreateDynamicObject(19379,1507.80004883,-1754.00000000,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (8)
	CreateDynamicObject(19379,1498.19995117,-1754.00000000,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (8)
	CreateDynamicObject(19379,1488.59997559,-1754.00000000,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (8)
	CreateDynamicObject(19450,1459.59997559,-1759.19995117,3286.00000000,0.00000000,0.00000000,270.00000000); //object(cs_detrok10) (1)
	CreateDynamicObject(19450,1459.69921875,-1768.00000000,3286.00000000,0.00000000,0.00000000,270.00000000); //object(cs_detrok10) (1)
	CreateDynamicObject(19450,1454.90002441,-1763.19995117,3286.00000000,0.00000000,0.00000000,0.00000000); //object(cs_detrok10) (3)
	CreateDynamicObject(19379,1459.80004883,-1764.50000000,3287.69995117,0.00000000,90.00000000,90.00000000); //object(sfw_boxwest12) (7)
	CreateDynamicObject(2008,1474.69995117,-1754.30004883,3284.48999023,0.00000000,0.00000000,0.00000000); //object(officedesk1) (1)
	CreateDynamicObject(2008,1472.59997559,-1754.30004883,3284.48999023,0.00000000,0.00000000,0.00000000); //object(officedesk1) (2)
	CreateDynamicObject(2607,1471.40002441,-1755.90002441,3284.89990234,0.00000000,0.00000000,270.00000000); //object(polce_desk2) (1)
	CreateDynamicObject(2007,1486.40002441,-1759.90002441,3284.30004883,0.00000000,0.00000000,0.00000000); //object(filing_cab_nu01) (1)
	CreateDynamicObject(2007,1485.40002441,-1759.90002441,3284.30004883,0.00000000,0.00000000,0.00000000); //object(filing_cab_nu01) (2)
	CreateDynamicObject(2007,1484.39941406,-1759.89941406,3284.30004883,0.00000000,0.00000000,0.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2162,1471.81005859,-1758.09997559,3284.38500977,0.00000000,0.00000000,180.00000000); //object(med_office_unit_1) (1)
	CreateDynamicObject(2606,1473.19995117,-1754.40002441,3287.00000000,6.50000000,0.00000000,0.00000000); //object(cj_police_counter2) (1)
	CreateDynamicObject(2606,1475.19995117,-1754.40002441,3287.00000000,6.49841309,0.00000000,0.00000000); //object(cj_police_counter2) (3)
	CreateDynamicObject(2162,1476.69995117,-1754.19995117,3284.38500977,0.00000000,0.00000000,312.74450684); //object(med_office_unit_1) (2)
	CreateDynamicObject(1811,1483.19995117,-1752.40002441,3284.89990234,0.00000000,0.00000000,0.00000000); //object(med_din_chair_5) (1)
	CreateDynamicObject(1811,1483.19921875,-1753.19921875,3284.89990234,0.00000000,0.00000000,0.00000000); //object(med_din_chair_5) (2)
	CreateDynamicObject(1811,1483.19995117,-1754.00000000,3284.89990234,0.00000000,0.00000000,0.00000000); //object(med_din_chair_5) (3)
	CreateDynamicObject(1811,1483.19995117,-1754.80004883,3284.89990234,0.00000000,0.00000000,0.00000000); //object(med_din_chair_5) (4)
	CreateDynamicObject(1892,1472.90002441,-1749.50000000,3284.30004883,0.00000000,0.00000000,0.00000000); //object(security_gatsh) (1)
	CreateDynamicObject(1892,1474.50000000,-1749.50000000,3284.30004883,0.00000000,0.00000000,0.00000000); //object(security_gatsh) (2)
	CreateDynamicObject(2111,1482.69995117,-1750.90002441,3284.69995117,0.00000000,0.00000000,0.00000000); //object(low_dinning_5) (1)
	CreateDynamicObject(2816,1482.59997559,-1751.19995117,3285.11010742,0.00000000,0.00000000,0.00000000); //object(gb_bedmags01) (1)
	CreateDynamicObject(14401,1453.30004883,-1747.40002441,3284.60009766,0.00000000,0.00000000,180.00000000); //object(bench1) (1)
	CreateDynamicObject(14401,1443.09960938,-1773.59960938,3284.60009766,0.00000000,0.00000000,269.99450684); //object(bench1) (2)
	CreateDynamicObject(1502,1464.43945312,-1762.41503906,3284.23999023,0.00000000,0.00000000,270.00000000); //object(gen_doorint04) (1)
	CreateDynamicObject(14782,1461.30004883,-1759.69995117,3285.30004883,0.00000000,0.00000000,0.00000000); //object(int3int_boxing30) (1)
	CreateDynamicObject(14782,1455.69995117,-1760.00000000,3285.30004883,0.00000000,0.00000000,90.00000000); //object(int3int_boxing30) (4)
	CreateDynamicObject(2846,1456.09997559,-1760.59997559,3284.30004883,0.00000000,0.00000000,0.00000000); //object(gb_bedclothes05) (1)
	CreateDynamicObject(2614,1474.15002441,-1768.12500000,3289.50000000,0.00000000,0.00000000,0.00000000); //object(cj_us_flag) (1)
	CreateDynamicObject(2007,1463.00000000,-1767.40002441,3284.30004883,0.00000000,0.00000000,180.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2007,1462.00000000,-1767.40002441,3284.30004883,0.00000000,0.00000000,179.99450684); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2007,1461.00000000,-1767.40002441,3284.30004883,0.00000000,0.00000000,179.99450684); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2400,1464.40002441,-1764.59997559,3284.39990234,0.00000000,0.00000000,270.00000000); //object(cj_sports_wall01) (1)
	CreateDynamicObject(2689,1464.00000000,-1765.09997559,3285.69995117,0.00000000,0.00000000,270.00000000); //object(cj_hoodie_2) (1)
	CreateDynamicObject(2704,1464.09997559,-1765.69995117,3285.69995117,0.00000000,0.00000000,270.00000000); //object(cj_hoodie_3) (1)
	CreateDynamicObject(19358,1482.19995117,-1769.51599121,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(14416,1480.59997559,-1772.80004883,3281.10009766,0.00000000,0.00000000,359.99450684); //object(carter-stairs07) (1)
	CreateDynamicObject(19358,1482.19995117,-1769.59997559,3282.50000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1482.19995117,-1772.80004883,3282.50000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1482.19995117,-1772.69995117,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1479.00000000,-1769.59997559,3282.50000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1479.00000000,-1772.80004883,3282.50000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1479.00000000,-1772.69995117,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(14416,1480.50000000,-1779.09997559,3277.60009766,0.00000000,0.00000000,359.98901367); //object(carter-stairs07) (1)
	CreateDynamicObject(19358,1482.19995117,-1776.00000000,3282.50000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1479.00000000,-1776.00000000,3282.50000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1482.19995117,-1775.90002441,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1479.00000000,-1775.90002441,3286.00000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1480.59960938,-1777.50000000,3282.50000000,0.00000000,0.00000000,90.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19358,1480.59997559,-1777.50000000,3286.00000000,0.00000000,0.00000000,90.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19370,1480.50000000,-1769.59960938,3287.69995117,0.00000000,90.00000000,0.00000000); //object(freight_sfw15) (1)
	CreateDynamicObject(19370,1480.50000000,-1772.79980469,3287.69799805,0.00000000,90.00000000,0.00000000); //object(freight_sfw15) (2)
	CreateDynamicObject(19370,1480.59960938,-1776.00000000,3287.69799805,0.00000000,90.00000000,0.00000000); //object(freight_sfw15) (3)
	CreateDynamicObject(14416,1480.50000000,-1780.30004883,3277.60009766,0.00000000,0.00000000,359.98901367); //object(carter-stairs07) (1)
	CreateDynamicObject(1536,1479.09997559,-1777.43701172,3280.80004883,0.00000000,0.00000000,0.00000000); //object(gen_doorext15) (2)
	CreateDynamicObject(1536,1482.09997559,-1777.40002441,3280.80004883,0.00000000,0.00000000,180.00000000); //object(gen_doorext15) (2)
	CreateDynamicObject(1811,1464.00000000,-1777.80004883,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (5)
	CreateDynamicObject(1811,1464.90002441,-1777.80004883,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (6)
	CreateDynamicObject(1811,1465.80004883,-1777.80004883,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (7)
	CreateDynamicObject(1811,1466.69995117,-1777.80004883,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (9)
	CreateDynamicObject(1811,1467.59997559,-1777.80004883,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (10)
	CreateDynamicObject(1811,1467.59997559,-1776.09997559,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (11)
	CreateDynamicObject(1811,1466.69995117,-1776.09997559,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (12)
	CreateDynamicObject(1811,1465.80004883,-1776.09997559,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (13)
	CreateDynamicObject(1811,1464.90002441,-1776.09997559,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (14)
	CreateDynamicObject(1811,1464.00000000,-1776.09997559,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (15)
	CreateDynamicObject(1811,1467.59997559,-1774.59997559,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (16)
	CreateDynamicObject(1811,1466.69995117,-1774.59997559,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (17)
	CreateDynamicObject(1811,1465.90002441,-1774.59997559,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (18)
	CreateDynamicObject(1811,1465.00000000,-1774.59997559,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (19)
	CreateDynamicObject(1811,1464.09997559,-1774.59997559,3288.39990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (20)
	CreateDynamicObject(3077,1466.80004883,-1781.80004883,3287.80004883,0.00000000,0.00000000,0.00000000); //object(nf_blackboard) (1)
	CreateDynamicObject(14532,1464.09960938,-1781.19921875,3288.80004883,0.00000000,0.00000000,349.99694824); //object(tv_stand_driv) (1)
	CreateDynamicObject(19358,1470.50000000,-1774.69995117,3289.50000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(19388,1470.50000000,-1777.90002441,3289.50000000,0.00000000,0.00000000,0.00000000); //object(road_sfw15) (1)
	CreateDynamicObject(19358,1470.50000000,-1781.09997559,3289.50000000,0.00000000,0.00000000,0.00000000); //object(road_sfw12) (7)
	CreateDynamicObject(2357,1471.59960938,-1787.69921875,3288.19995117,0.00000000,0.00000000,270.00000000); //object(dunc_dinning) (1)
	CreateDynamicObject(1714,1513.09997559,-1837.50000000,3216.69995117,0.00000000,0.00000000,0.00000000); //object(kb_swivelchair1) (1)
	CreateDynamicObject(1714,1471.59997559,-1790.69995117,3287.80004883,0.00000000,0.00000000,180.00000000); //object(kb_swivelchair1) (2)
	CreateDynamicObject(1671,1470.40002441,-1788.90002441,3288.19995117,0.00000000,0.00000000,90.00000000); //object(swivelchair_a) (1)
	CreateDynamicObject(1671,1470.40002441,-1787.69995117,3288.19995117,0.00000000,0.00000000,90.00000000); //object(swivelchair_a) (2)
	CreateDynamicObject(1671,1470.40002441,-1786.50000000,3288.19995117,0.00000000,0.00000000,90.00000000); //object(swivelchair_a) (4)
	CreateDynamicObject(1671,1472.90002441,-1788.90002441,3288.19995117,0.00000000,0.00000000,270.00000000); //object(swivelchair_a) (5)
	CreateDynamicObject(1671,1472.90002441,-1787.69995117,3288.19995117,0.00000000,0.00000000,270.00000000); //object(swivelchair_a) (7)
	CreateDynamicObject(1671,1472.90002441,-1786.50000000,3288.19995117,0.00000000,0.00000000,270.00000000); //object(swivelchair_a) (9)
	CreateDynamicObject(14532,1470.09960938,-1791.59960938,3288.80004883,0.00000000,0.00000000,337.99438477); //object(tv_stand_driv) (1)
	CreateDynamicObject(1671,1475.19995117,-1790.40002441,3288.19995117,0.00000000,0.00000000,180.00000000); //object(swivelchair_a) (10)
	CreateDynamicObject(2165,1478.19995117,-1790.09997559,3287.80004883,0.00000000,0.00000000,270.00000000); //object(med_office_desk_1) (1)
	CreateDynamicObject(2166,1477.19995117,-1788.09997559,3287.80004883,0.00000000,0.00000000,270.00000000); //object(med_office_desk_2) (1)
	CreateDynamicObject(2173,1474.69995117,-1789.50000000,3287.80004883,0.00000000,0.00000000,0.00000000); //object(med_office_desk_3) (1)
	CreateDynamicObject(1671,1477.29980469,-1790.69921875,3288.19995117,0.00000000,0.00000000,90.00000000); //object(swivelchair_a) (11)
	CreateDynamicObject(1671,1475.09997559,-1788.50000000,3288.19995117,0.00000000,0.00000000,358.24450684); //object(swivelchair_a) (12)
	CreateDynamicObject(2186,1476.59997559,-1773.59997559,3287.80004883,0.00000000,0.00000000,0.00000000); //object(photocopier_1) (1)
	CreateDynamicObject(2612,1474.22302246,-1790.40002441,3289.60009766,0.00000000,0.00000000,90.00000000); //object(police_nb2) (1)
	CreateDynamicObject(2611,1474.22399902,-1787.80004883,3289.62011719,0.00000000,0.00000000,90.00000000); //object(police_nb1) (1)
	CreateDynamicObject(1502,1476.45996094,-1785.61999512,3287.73510742,0.00000000,0.00000000,0.00000000); //object(gen_doorint04) (1)
	CreateDynamicObject(2165,1479.19995117,-1775.59997559,3287.80004883,0.00000000,0.00000000,90.00000000); //object(med_office_desk_1) (2)
	CreateDynamicObject(2165,1479.30004883,-1778.50000000,3287.80004883,0.00000000,0.00000000,90.00000000); //object(med_office_desk_1) (3)
	CreateDynamicObject(2165,1479.40002441,-1781.50000000,3287.80004883,0.00000000,0.00000000,90.00000000); //object(med_office_desk_1) (4)
	CreateDynamicObject(2165,1482.30004883,-1775.59997559,3287.80004883,0.00000000,0.00000000,90.00000000); //object(med_office_desk_1) (5)
	CreateDynamicObject(2165,1482.40002441,-1778.50000000,3287.80004883,0.00000000,0.00000000,90.00000000); //object(med_office_desk_1) (6)
	CreateDynamicObject(2165,1482.50000000,-1781.50000000,3287.80004883,0.00000000,0.00000000,90.00000000); //object(med_office_desk_1) (7)
	CreateDynamicObject(1671,1483.19995117,-1775.00000000,3288.19995117,0.00000000,0.00000000,270.00000000); //object(swivelchair_a) (13)
	CreateDynamicObject(1671,1480.19995117,-1775.00000000,3288.19995117,0.00000000,0.00000000,270.00000000); //object(swivelchair_a) (14)
	CreateDynamicObject(1671,1483.30004883,-1778.00000000,3288.19995117,0.00000000,0.00000000,270.00000000); //object(swivelchair_a) (15)
	CreateDynamicObject(1671,1483.50000000,-1781.00000000,3288.19995117,0.00000000,0.00000000,270.00000000); //object(swivelchair_a) (16)
	CreateDynamicObject(1671,1480.40002441,-1781.09997559,3288.19995117,0.00000000,0.00000000,270.00000000); //object(swivelchair_a) (17)
	CreateDynamicObject(1671,1480.19995117,-1778.00000000,3288.19995117,0.00000000,0.00000000,270.00000000); //object(swivelchair_a) (18)
	CreateDynamicObject(2186,1474.79980469,-1786.19921875,3287.80004883,0.00000000,0.00000000,0.00000000); //object(photocopier_1) (2)
	CreateDynamicObject(2007,1471.19995117,-1773.69995117,3287.80004883,0.00000000,0.00000000,90.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2007,1471.19995117,-1774.69995117,3287.80004883,0.00000000,0.00000000,90.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2007,1471.19995117,-1775.69995117,3287.80004883,0.00000000,0.00000000,90.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2166,1471.90002441,-1779.09997559,3287.80004883,0.00000000,0.00000000,270.00000000); //object(med_office_desk_2) (2)
	CreateDynamicObject(2165,1472.90002441,-1781.09997559,3287.80004883,0.00000000,0.00000000,270.00000000); //object(med_office_desk_1) (8)
	CreateDynamicObject(1714,1471.69995117,-1781.69995117,3287.80004883,0.00000000,0.00000000,89.99450684); //object(kb_swivelchair1) (3)
	CreateDynamicObject(1800,1492.69995117,-1760.80004883,3284.30004883,0.00000000,0.00000000,0.00000000); //object(low_bed_1) (1)
	CreateDynamicObject(1800,1495.90002441,-1760.80004883,3284.30004883,0.00000000,0.00000000,0.00000000); //object(low_bed_1) (2)
	CreateDynamicObject(1800,1499.19995117,-1760.80004883,3284.30004883,0.00000000,0.00000000,0.00000000); //object(low_bed_1) (3)
	CreateDynamicObject(1800,1502.40002441,-1760.80004883,3284.30004883,0.00000000,0.00000000,0.00000000); //object(low_bed_1) (4)
	CreateDynamicObject(1800,1491.00000000,-1770.59997559,3284.30004883,0.00000000,0.00000000,0.00000000); //object(low_bed_1) (5)
	CreateDynamicObject(1800,1494.19995117,-1770.50000000,3284.30004883,0.00000000,0.00000000,0.00000000); //object(low_bed_1) (6)
	CreateDynamicObject(1800,1497.40002441,-1770.50000000,3284.30004883,0.00000000,0.00000000,0.00000000); //object(low_bed_1) (7)
	CreateDynamicObject(1800,1500.59997559,-1770.59997559,3284.30004883,0.00000000,0.00000000,0.00000000); //object(low_bed_1) (8)
	CreateDynamicObject(2738,1500.59997559,-1766.09997559,3284.89990234,0.00000000,0.00000000,90.00000000); //object(cj_toilet_bs) (1)
	CreateDynamicObject(2738,1497.30004883,-1766.09997559,3284.89990234,0.00000000,0.00000000,90.00000000); //object(cj_toilet_bs) (2)
	CreateDynamicObject(2738,1494.09997559,-1766.09997559,3284.89990234,0.00000000,0.00000000,90.00000000); //object(cj_toilet_bs) (3)
	CreateDynamicObject(2738,1490.90002441,-1766.09997559,3284.89990234,0.00000000,0.00000000,90.00000000); //object(cj_toilet_bs) (4)
	CreateDynamicObject(2738,1491.00000000,-1759.90002441,3284.89990234,0.00000000,0.00000000,90.00000000); //object(cj_toilet_bs) (5)
	CreateDynamicObject(2738,1494.09997559,-1760.00000000,3284.89990234,0.00000000,0.00000000,90.00000000); //object(cj_toilet_bs) (6)
	CreateDynamicObject(2738,1497.30004883,-1760.00000000,3284.89990234,0.00000000,0.00000000,90.00000000); //object(cj_toilet_bs) (7)
	CreateDynamicObject(2738,1500.59997559,-1759.90002441,3284.89990234,0.00000000,0.00000000,90.00000000); //object(cj_toilet_bs) (8)
	CreateDynamicObject(2524,1500.69995117,-1758.59997559,3284.30004883,0.00000000,0.00000000,90.00000000); //object(cj_b_sink4) (1)
	CreateDynamicObject(2524,1497.40002441,-1758.69995117,3284.30004883,0.00000000,0.00000000,90.00000000); //object(cj_b_sink4) (2)
	CreateDynamicObject(2524,1494.19995117,-1758.80004883,3284.30004883,0.00000000,0.00000000,90.00000000); //object(cj_b_sink4) (3)
	CreateDynamicObject(2524,1491.00000000,-1758.90002441,3284.30004883,0.00000000,0.00000000,90.00000000); //object(cj_b_sink4) (4)
	CreateDynamicObject(2524,1493.00000000,-1767.59997559,3284.30004883,0.00000000,0.00000000,270.00000000); //object(cj_b_sink4) (5)
	CreateDynamicObject(2524,1496.19995117,-1767.59997559,3284.30004883,0.00000000,0.00000000,270.00000000); //object(cj_b_sink4) (6)
	CreateDynamicObject(2524,1499.40002441,-1767.59997559,3284.30004883,0.00000000,0.00000000,270.00000000); //object(cj_b_sink4) (7)
	CreateDynamicObject(2524,1502.69995117,-1767.59997559,3284.30004883,0.00000000,0.00000000,270.00000000); //object(cj_b_sink4) (8)
	CreateDynamicObject(2007,1493.00000000,-1760.59997559,3284.30004883,0.00000000,0.00000000,270.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2007,1496.19995117,-1760.50000000,3284.30004883,0.00000000,0.00000000,270.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2007,1499.50000000,-1760.40002441,3284.30004883,0.00000000,0.00000000,270.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2007,1502.69995117,-1760.30004883,3284.30004883,0.00000000,0.00000000,270.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2007,1502.69995117,-1766.30004883,3284.30004883,0.00000000,0.00000000,270.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2007,1499.40002441,-1766.30004883,3284.30004883,0.00000000,0.00000000,270.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2007,1496.19995117,-1766.30004883,3284.30004883,0.00000000,0.00000000,270.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(2007,1493.00000000,-1766.30004883,3284.30004883,0.00000000,0.00000000,270.00000000); //object(filing_cab_nu01) (3)
	CreateDynamicObject(19450,1467.59997559,-1768.00097656,3286.00000000,0.00000000,0.00000000,270.00000000); //object(cs_detrok10) (1)
	CreateDynamicObject(1811,1472.30004883,-1758.90002441,3284.89990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (2)
	CreateDynamicObject(1811,1471.50000000,-1758.90002441,3284.89990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (2)
	CreateDynamicObject(1811,1470.69995117,-1758.90002441,3284.89990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (2)
	CreateDynamicObject(1811,1469.90002441,-1758.90002441,3284.89990234,0.00000000,0.00000000,90.00000000); //object(med_din_chair_5) (2)
	CreateDynamicObject(18608,1473.50000000,-1763.19995117,3288.50000000,0.00000000,0.00000000,270.00000000); //object(counts_lights01) (1)
	CreateDynamicObject(18608,1452.09997559,-1763.80004883,3288.50000000,0.00000000,0.00000000,270.00000000); //object(counts_lights01) (2)
	CreateDynamicObject(18608,1474.80004883,-1756.40002441,3288.50000000,0.00000000,0.00000000,270.00000000); //object(counts_lights01) (3)
	CreateDynamicObject(18608,1470.90002441,-1750.90002441,3288.50000000,0.00000000,0.00000000,270.00000000); //object(counts_lights01) (4)
	CreateDynamicObject(18608,1474.69995117,-1777.80004883,3292.19995117,0.00000000,0.00000000,270.00000000); //object(counts_lights01) (5)
	CreateDynamicObject(18608,1464.09997559,-1786.69995117,3292.19995117,0.00000000,0.00000000,270.00000000); //object(counts_lights01) (6)
	CreateDynamicObject(18608,1483.89941406,-1788.89941406,3292.19995117,0.00000000,0.00000000,270.00000000); //object(counts_lights01) (7)
	CreateDynamicObject(18608,1492.80004883,-1763.19995117,3288.50000000,0.00000000,0.00000000,270.00000000); //object(counts_lights01) (8)
	CreateDynamicObject(1886,1465.09997559,-1757.59997559,3287.69995117,8.49990845,0.25277710,139.71264648); //object(shop_sec_cam) (1)
	CreateDynamicObject(1886,1483.40002441,-1757.80004883,3287.50000000,8.49792480,0.25268555,219.70764160); //object(shop_sec_cam) (2)
	CreateDynamicObject(1886,1502.69995117,-1764.40002441,3287.80004883,12.49789429,0.25598145,243.68652344); //object(shop_sec_cam) (3)
	CreateDynamicObject(1886,1465.19921875,-1767.50000000,3287.80004883,8.49792480,0.25268555,123.70056152); //object(shop_sec_cam) (4)
	CreateDynamicObject(19431,1469.40002441,-1793.19995117,3289.50000000,0.00000000,0.00000000,179.99450684); //object(cs_landbit_48_a) (11)
	CreateDynamicObject(19431,1474.09960938,-1792.79980469,3289.50000000,0.00000000,0.00000000,179.99450684); //object(cs_landbit_48_a) (11)
	CreateDynamicObject(19404,1471.69995117,-1793.50000000,3289.50000000,0.00000000,0.00000000,270.00000000); //object(boigagr_sfw) (1)
	CreateDynamicObject(19431,1474.09997559,-1793.50000000,3289.50000000,0.00000000,0.00000000,90.00000000); //object(cs_landbit_48_a) (11)
	CreateDynamicObject(19431,1469.30004883,-1793.50000000,3289.50000000,0.00000000,0.00000000,90.00000000); //object(cs_landbit_48_a) (11)
	CreateDynamicObject(19404,1476.50000000,-1793.50000000,3289.50000000,0.00000000,0.00000000,270.00000000); //object(boigagr_sfw) (2)
	CreateDynamicObject(19431,1478.90002441,-1793.50000000,3289.50000000,0.00000000,0.00000000,90.00000000); //object(cs_landbit_48_a) (11)
	CreateDynamicObject(4108,1480.50000000,-1805.90002441,3287.89990234,0.00000000,0.00000000,270.00000000); //object(roads01b_lan) (1)
	CreateDynamicObject(717,1477.09997559,-1805.90002441,3284.10009766,0.00000000,0.00000000,92.00000000); //object(sm_bevhiltreepv) (1)
	CreateDynamicObject(717,1486.59997559,-1805.80004883,3284.10009766,0.00000000,0.00000000,91.99951172); //object(sm_bevhiltreepv) (2)
	CreateDynamicObject(717,1496.59997559,-1805.69995117,3284.10009766,0.00000000,0.00000000,91.99951172); //object(sm_bevhiltreepv) (3)
	CreateDynamicObject(717,1508.80004883,-1805.59997559,3284.10009766,0.00000000,0.00000000,91.99951172); //object(sm_bevhiltreepv) (4)
	CreateDynamicObject(717,1520.59997559,-1805.50000000,3284.10009766,0.00000000,0.00000000,91.99951172); //object(sm_bevhiltreepv) (5)
	CreateDynamicObject(717,1467.80004883,-1805.90002441,3284.10009766,0.00000000,0.00000000,91.99951172); //object(sm_bevhiltreepv) (6)
	CreateDynamicObject(717,1457.09997559,-1805.59997559,3284.10009766,0.00000000,0.00000000,91.99951172); //object(sm_bevhiltreepv) (7)
	CreateDynamicObject(717,1445.30004883,-1805.19995117,3284.10009766,0.00000000,0.00000000,91.99951172); //object(sm_bevhiltreepv) (8)
	CreateDynamicObject(717,1434.90002441,-1805.30004883,3284.10009766,0.00000000,0.00000000,91.99951172); //object(sm_bevhiltreepv) (9)
	CreateDynamicObject(717,1421.90002441,-1805.69995117,3284.10009766,0.00000000,0.00000000,92.00000000); //object(sm_bevhiltreepv) (10)
	CreateDynamicObject(6199,1450.69995117,-1831.09997559,3295.89990234,0.00000000,0.00000000,4.75000000); //object(gaz27_law) (1)
	CreateDynamicObject(6199,1500.59997559,-1831.30004883,3295.89990234,0.00000000,0.00000000,4.74609375); //object(gaz27_law) (2)
	CreateDynamicObject(6364,1551.59997559,-1819.50000000,3308.19995117,0.00000000,0.00000000,68.00000000); //object(sunset07_law2) (1)
	CreateDynamicObject(6364,1568.69995117,-1845.80004883,3308.19995117,0.00000000,0.00000000,82.99987793); //object(sunset07_law2) (2)
	CreateDynamicObject(6391,1403.59997559,-1822.80004883,3327.60009766,0.00000000,0.00000000,97.00000000); //object(sanclifft05_law2) (1)
	CreateDynamicObject(3858,1474.50000000,-1793.50000000,3290.69995117,0.00000000,0.00000000,225.00000000); //object(ottosmash1) (1)
	CreateDynamicObject(3858,1474.50000000,-1793.50000000,3290.69995117,0.00000000,0.00000000,44.50000000); //object(ottosmash1) (2)
	CreateDynamicObject(2559,1468.90002441,-1749.30004883,3285.50000000,0.00000000,0.00000000,0.00000000); //object(curtain_1_open) (1)
	CreateDynamicObject(2559,1477.00000000,-1793.00000000,3289.00000000,0.00000000,0.00000000,179.99450684); //object(curtain_1_open) (2)
	CreateDynamicObject(4150,1484.90002441,-1741.19995117,3284.19995117,0.00000000,0.00000000,270.00000000); //object(roads14_lan) (1)
	CreateDynamicObject(19358,1482.19995117,-1748.80004883,3286.00000000,0.00000000,0.00000000,90.00000000); //object(road_sfw12) (3)
	CreateDynamicObject(19404,1479.00000000,-1748.80004883,3286.00000000,0.00000000,0.00000000,270.00000000); //object(boigagr_sfw) (3)
	CreateDynamicObject(19358,1475.80004883,-1748.80004883,3286.00000000,0.00000000,0.00000000,90.00000000); //object(road_sfw12) (3)
	CreateDynamicObject(19358,1472.59997559,-1748.80004883,3286.00000000,0.00000000,0.00000000,90.00000000); //object(road_sfw12) (3)
	CreateDynamicObject(19404,1469.40002441,-1748.80004883,3286.00000000,0.00000000,0.00000000,270.00000000); //object(boigagr_sfw) (4)
	CreateDynamicObject(19358,1466.19995117,-1748.80004883,3286.00000000,0.00000000,0.00000000,90.00000000); //object(road_sfw12) (3)
	CreateDynamicObject(3858,1474.19995117,-1748.80004883,3285.30004883,0.00000000,0.00000000,44.99462891); //object(ottosmash1) (3)
	CreateDynamicObject(3858,1474.19995117,-1748.80004883,3285.30004883,0.00000000,0.00000000,224.99450684); //object(ottosmash1) (4)
	CreateDynamicObject(2559,1472.19921875,-1793.00000000,3289.00000000,0.00000000,0.00000000,179.99450684); //object(curtain_1_open) (3)
	CreateDynamicObject(2559,1478.50000000,-1749.30004883,3285.50000000,0.00000000,0.00000000,0.00000000); //object(curtain_1_open) (4)
	CreateDynamicObject(4186,1454.90002441,-1689.09997559,3291.30004883,0.00000000,0.00000000,270.00000000); //object(pershingsq2_lan) (1)
	CreateDynamicObject(3985,1516.50000000,-1689.09997559,3283.80004883,0.00000000,0.00000000,270.00000000); //object(pershingsq1_lan) (1)
	CreateDynamicObject(713,1441.19995117,-1707.30004883,3281.10009766,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (1)
	CreateDynamicObject(713,1527.69995117,-1710.80004883,3281.80004883,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (2)
	CreateDynamicObject(713,1482.80004883,-1693.69995117,3285.30004883,0.00000000,0.00000000,0.00000000); //object(veg_bevtree1) (3)
	CreateDynamicObject(4016,1585.30004883,-1717.90002441,3292.10009766,0.00000000,0.00000000,270.00000000); //object(fighotbase_lan) (1)
	CreateDynamicObject(4006,1490.50000000,-1642.59997559,3304.50000000,0.00000000,0.00000000,270.00000000); //object(eastcolumb1_lan) (1)
	CreateDynamicObject(4008,1558.19995117,-1651.80004883,3292.00000000,0.00000000,0.00000000,272.00000000); //object(decoblok1_lan) (1)
	CreateDynamicObject(4005,1433.40002441,-1656.80004883,3297.80004883,0.00000000,0.00000000,270.00000000); //object(decoblok2_lan) (1)
	CreateDynamicObject(3980,1370.80004883,-1719.80004883,3294.00000000,0.00000000,0.00000000,270.00000000); //object(lacityhall1_lan) (1)
	CreateDynamicObject(4163,1415.80004883,-1678.50000000,3284.30004883,0.00000000,0.00000000,270.00000000); //object(roads24_lan) (1)
	CreateDynamicObject(4002,1360.50000000,-1717.69995117,3326.60009766,0.00000000,0.00000000,270.00000000); //object(lacityhall2_lan) (1)
	CreateDynamicObject(713,1422.19995117,-1669.09997559,3255.60009766,28.00000000,0.00000000,114.00000000); //object(veg_bevtree1) (4)
	//CS_Ship
	CreateDynamicObject(10794,379.70001221,-2296.19995117,3.90000010,0.00000000,0.00000000,0.00000000); //object(car_ship_04_sfse) (1)
	CreateDynamicObject(10795,377.00000000,-2296.19995117,14.30000019,0.00000000,0.00000000,0.00000000); //object(car_ship_05_sfse) (1)
	CreateDynamicObject(10793,304.10000610,-2296.10009766,32.50000000,0.00000000,0.00000000,0.00000000); //object(car_ship_03_sfse) (1)
	CreateDynamicObject(3406,369.39999390,-2277.50000000,-2.00000000,0.00000000,0.00000000,0.00000000); //object(cxref_woodjetty) (1)
	CreateDynamicObject(3406,369.39999390,-2276.50000000,-2.00000000,0.00000000,0.00000000,0.00000000); //object(cxref_woodjetty) (2)
	CreateDynamicObject(942,362.79998779,-2288.19995117,16.00000000,0.00000000,0.00000000,318.00000000); //object(cj_df_unit_2) (1)
	CreateDynamicObject(939,335.79998779,-2290.19995117,16.00000000,0.00000000,0.00000000,0.00000000); //object(cj_df_unit) (1)
	CreateDynamicObject(935,348.00000000,-2296.10009766,14.10000038,0.00000000,0.00000000,0.00000000); //object(cj_drum) (1)
	CreateDynamicObject(922,328.39999390,-2310.00000000,14.50000000,0.00000000,0.00000000,320.00000000); //object(packing_carates1) (1)
	CreateDynamicObject(3134,366.70001221,-2301.30004883,14.10000038,0.00000000,0.00000000,0.00000000); //object(quarry_barrel) (1)
	CreateDynamicObject(3066,359.89999390,-2307.10009766,14.60000038,0.00000000,0.00000000,316.00000000); //object(ammotrn_obj) (1)
	CreateDynamicObject(3015,324.20001221,-2297.50000000,13.60000038,0.00000000,0.00000000,0.00000000); //object(cr_cratestack) (1)
	CreateDynamicObject(2991,337.29998779,-2303.30004883,14.19999981,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (1)
	CreateDynamicObject(2991,341.29998779,-2303.30004883,14.19999981,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (2)
	CreateDynamicObject(2991,345.29998779,-2303.30004883,14.19999981,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (3)
	CreateDynamicObject(2991,339.50000000,-2303.30004883,15.50000000,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (4)
	CreateDynamicObject(2991,343.50000000,-2303.30004883,15.50000000,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (5)
	CreateDynamicObject(2991,341.60000610,-2303.30004883,16.79999924,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (6)
	CreateDynamicObject(2973,353.00000000,-2292.60009766,13.60000038,0.00000000,0.00000000,0.00000000); //object(k_cargo2) (1)
	CreateDynamicObject(2935,350.60000610,-2308.19995117,15.00000000,0.00000000,0.00000000,334.00000000); //object(kmb_container_yel) (2)
	CreateDynamicObject(2935,348.20001221,-2284.60009766,15.00000000,0.00000000,0.00000000,0.00000000); //object(kmb_container_yel) (3)
	CreateDynamicObject(2934,369.60000610,-2295.00000000,15.00000000,0.00000000,0.00000000,328.00000000); //object(kmb_container_red) (1)
	CreateDynamicObject(2932,397.70001221,-2283.39990234,15.00000000,0.00000000,0.00000000,0.00000000); //object(kmb_container_blue) (1)
	CreateDynamicObject(2932,397.60000610,-2309.10009766,15.00000000,0.00000000,0.00000000,0.00000000); //object(kmb_container_blue) (2)
	CreateDynamicObject(2932,425.60000610,-2309.50000000,15.00000000,0.00000000,0.00000000,0.00000000); //object(kmb_container_blue) (3)
	CreateDynamicObject(2932,424.79998779,-2284.10009766,15.00000000,0.00000000,0.00000000,0.00000000); //object(kmb_container_blue) (4)
	CreateDynamicObject(2912,384.70001221,-2311.19995117,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (1)
	CreateDynamicObject(2912,376.00000000,-2309.60009766,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (2)
	CreateDynamicObject(2912,398.39999390,-2293.69995117,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (3)
	CreateDynamicObject(2912,400.00000000,-2298.50000000,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (4)
	CreateDynamicObject(2912,405.29998779,-2309.69995117,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (5)
	CreateDynamicObject(2912,425.89999390,-2299.50000000,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (6)
	CreateDynamicObject(2912,426.50000000,-2295.10009766,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (7)
	CreateDynamicObject(2912,415.60000610,-2310.60009766,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (8)
	CreateDynamicObject(2912,417.89999390,-2280.89990234,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (9)
	CreateDynamicObject(2912,409.50000000,-2282.00000000,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (10)
	CreateDynamicObject(2912,402.60000610,-2281.39990234,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (11)
	CreateDynamicObject(2912,438.89999390,-2281.19995117,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (12)
	CreateDynamicObject(2912,439.79998779,-2311.80004883,13.60000038,0.00000000,0.00000000,0.00000000); //object(temp_crate1) (14)
	CreateDynamicObject(18260,459.00000000,-2305.10009766,15.19999981,0.00000000,0.00000000,42.00000000); //object(crates01) (1)
	CreateDynamicObject(18257,459.79998779,-2289.89990234,13.60000038,0.00000000,0.00000000,312.00000000); //object(crates) (1)
	CreateDynamicObject(925,463.89999390,-2295.00000000,14.60000038,0.00000000,0.00000000,0.00000000); //object(rack2) (1)
	CreateDynamicObject(930,469.00000000,-2293.80004883,15.50000000,0.00000000,0.00000000,0.00000000); //object(o2_bottles) (1)
	CreateDynamicObject(1431,470.00000000,-2289.19995117,15.60000038,0.00000000,0.00000000,0.00000000); //object(dyn_box_pile) (1)
	CreateDynamicObject(2041,464.79998779,-2285.89990234,13.80000019,0.00000000,0.00000000,0.00000000); //object(ammo_box_m2) (1)
	CreateDynamicObject(2042,475.29998779,-2298.69995117,15.10000038,0.00000000,0.00000000,0.00000000); //object(ammo_box_m3) (1)
	CreateDynamicObject(2358,474.00000000,-2292.89990234,15.10000038,0.00000000,0.00000000,0.00000000); //object(ammo_box_c2) (1)
	CreateDynamicObject(2358,458.00000000,-2284.10009766,15.69999981,0.00000000,0.00000000,0.00000000); //object(ammo_box_c2) (2)
	CreateDynamicObject(2567,476.10000610,-2289.39990234,17.00000000,0.00000000,0.00000000,342.00000000); //object(ab_warehouseshelf) (1)
	CreateDynamicObject(2669,481.89999390,-2297.19995117,16.39999962,0.00000000,0.00000000,328.00000000); //object(cj_chris_crate) (1)
	CreateDynamicObject(2678,481.20001221,-2299.89990234,16.29999924,0.00000000,0.00000000,0.00000000); //object(cj_chris_crate_ld) (1)
	CreateDynamicObject(3565,474.60000610,-2302.39990234,16.39999962,0.00000000,0.00000000,326.00000000); //object(lasdkrt1_la01) (1)
	CreateDynamicObject(3577,480.79998779,-2291.89990234,15.80000019,0.00000000,0.00000000,0.00000000); //object(dockcrates1_la) (1)
	CreateDynamicObject(3577,367.39999390,-2284.30004883,14.39999962,0.00000000,0.00000000,0.00000000); //object(dockcrates1_la) (2)
	CreateDynamicObject(3577,358.29998779,-2294.80004883,14.39999962,0.00000000,0.00000000,0.00000000); //object(dockcrates1_la) (3)
	CreateDynamicObject(3577,384.79998779,-2281.80004883,14.39999962,0.00000000,0.00000000,0.00000000); //object(dockcrates1_la) (4)
	CreateDynamicObject(3577,336.39999390,-2283.39990234,14.39999962,0.00000000,0.00000000,0.00000000); //object(dockcrates1_la) (5)
	CreateDynamicObject(3577,330.20001221,-2301.10009766,14.39999962,0.00000000,0.00000000,0.00000000); //object(dockcrates1_la) (6)
	CreateDynamicObject(3577,327.00000000,-2289.80004883,14.39999962,0.00000000,0.00000000,0.00000000); //object(dockcrates1_la) (7)
	CreateDynamicObject(3577,355.89999390,-2282.89990234,14.39999962,0.00000000,0.00000000,0.00000000); //object(dockcrates1_la) (8)
	CreateDynamicObject(3577,371.00000000,-2309.89990234,14.39999962,0.00000000,0.00000000,0.00000000); //object(dockcrates1_la) (9)
	CreateDynamicObject(3577,388.39999390,-2310.50000000,14.39999962,0.00000000,0.00000000,0.00000000); //object(dockcrates1_la) (10)
	CreateDynamicObject(3633,381.00000000,-2310.80004883,14.10000038,0.00000000,0.00000000,0.00000000); //object(imoildrum4_las) (1)
	CreateDynamicObject(3633,395.89999390,-2300.30004883,14.10000038,0.00000000,0.00000000,0.00000000); //object(imoildrum4_las) (2)
	CreateDynamicObject(3633,399.89999390,-2291.10009766,14.10000038,0.00000000,0.00000000,0.00000000); //object(imoildrum4_las) (3)
	CreateDynamicObject(3633,413.10000610,-2310.19995117,14.10000038,0.00000000,0.00000000,0.00000000); //object(imoildrum4_las) (4)
	CreateDynamicObject(3633,420.89999390,-2280.39990234,14.10000038,0.00000000,0.00000000,0.00000000); //object(imoildrum4_las) (5)
	CreateDynamicObject(3796,446.70001221,-2281.69995117,13.60000038,0.00000000,0.00000000,0.00000000); //object(acbox1_sfs) (1)
	CreateDynamicObject(5259,454.70001221,-2295.89990234,14.00000000,0.00000000,0.00000000,0.00000000); //object(las2dkwar01) (1)
	CreateDynamicObject(13025,305.00000000,-2306.80004883,27.00000000,0.00000000,0.00000000,0.00000000); //object(sw_fueldrum01) (1)
	CreateDynamicObject(944,330.50000000,-2307.50000000,14.50000000,0.00000000,0.00000000,0.00000000); //object(packing_carates04) (1)
	CreateDynamicObject(939,451.29998779,-2310.10009766,16.00000000,0.00000000,0.00000000,40.00000000); //object(cj_df_unit) (2)
	CreateDynamicObject(3134,435.20001221,-2281.50000000,14.10000038,0.00000000,0.00000000,0.00000000); //object(quarry_barrel) (2)
	CreateDynamicObject(3015,437.39999390,-2281.50000000,13.60000038,0.00000000,0.00000000,0.00000000); //object(cr_cratestack) (2)
	CreateDynamicObject(2991,431.20001221,-2281.50000000,14.19999981,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (7)
	CreateDynamicObject(2991,408.70001221,-2310.80004883,14.19999981,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (8)
	CreateDynamicObject(2991,406.10000610,-2281.50000000,14.19999981,0.00000000,0.00000000,30.00000000); //object(imy_bbox) (9)
	CreateDynamicObject(2991,413.79998779,-2282.30004883,14.19999981,0.00000000,0.00000000,302.00000000); //object(imy_bbox) (10)
	CreateDynamicObject(2991,375.60000610,-2282.00000000,14.19999981,0.00000000,0.00000000,34.00000000); //object(imy_bbox) (11)
	CreateDynamicObject(2991,397.50000000,-2296.10009766,14.19999981,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (12)
	CreateDynamicObject(2991,425.50000000,-2296.89990234,14.19999981,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (13)
	//CS_TnT
	CreateDynamicObject(5166, 703.54602050781, -3315.6921386719, 13.108501434326, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(5160, 703.5654296875, -3315.712890625, 13.117170333862, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(5167, 596.11968994141, -3307.693359375, 15.193155288696, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(5156, 647.8857421875, -3307.623046875, 18.817274093628, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(5157, 756.70196533203, -3307.5939941406, 24.847515106201, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(5155, 579.50299072266, -3307.4985351563, 29.148788452148, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(5158, 555.44445800781, -3307.7600097656, 19.819080352783, 0.000000, 0.000000, 89.961547851563); //
	CreateDynamicObject(5154, 692.736328125, -3308.1171875, 23.534814834595, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(5154, 639.62890625, -3307.2509765625, 23.423425674438, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2934, 732.169921875, -3307.390625, 20.340620040894, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2934, 734.13323974609, -3297.3212890625, 20.340620040894, 0.000000, 0.000000, 89.730041503906); //
	CreateDynamicObject(2934, 734.14764404297, -3318.0300292969, 20.340620040894, 0.000000, 0.000000, 89.730041503906); //
	CreateDynamicObject(2934, 715.11096191406, -3315.8032226563, 20.340620040894, 0.000000, 0.000000, 359.99536132813); //
	CreateDynamicObject(2934, 715.10540771484, -3298.5192871094, 20.340620040894, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 705.98425292969, -3295.6796875, 20.340620040894, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 705.46484375, -3318.4921875, 20.340620040894, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 680.59338378906, -3296.380859375, 20.340620040894, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 683.73309326172, -3296.4855957031, 20.340620040894, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 665.60113525391, -3317.5520019531, 20.274700164795, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 662.47473144531, -3317.6496582031, 20.340620040894, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 683.41973876953, -3319.3427734375, 20.340620040894, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 680.16290283203, -3319.4147949219, 20.340620040894, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 662.69366455078, -3300.7124023438, 20.340620040894, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 665.70294189453, -3300.5629882813, 20.324699401855, 0.000000, 0.000000, 1.6067504882813); //
	CreateDynamicObject(2934, 648.73712158203, -3319.2580566406, 20.340620040894, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 651.94287109375, -3319.1936035156, 20.340620040894, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 652.3876953125, -3296.7346191406, 20.340620040894, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(2934, 649.2080078125, -3296.638671875, 20.340620040894, 0.000000, 0.000000, 359.98901367188); //
	CreateDynamicObject(2934, 727.138671875, -3297.2104492188, 20.340620040894, 0.000000, 0.000000, 89.725341796875); //
	CreateDynamicObject(2934, 727.18701171875, -3317.9702148438, 20.340620040894, 0.000000, 0.000000, 89.725341796875); //
	CreateDynamicObject(2934, 729.27947998047, -3307.3193359375, 20.340620040894, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2934, 605.17700195313, -3295.03515625, 20.340620040894, 0.000000, 0.000000, 89.724487304688); //
	CreateDynamicObject(2934, 612.36102294922, -3295.0224609375, 20.340620040894, 0.000000, 0.000000, 89.719848632813); //
	CreateDynamicObject(2934, 612.42498779297, -3318.7062988281, 20.340620040894, 0.000000, 0.000000, 89.719848632813); //
	CreateDynamicObject(2934, 605.30389404297, -3318.6496582031, 20.340620040894, 0.000000, 0.000000, 89.167816162109); //
	CreateDynamicObject(2934, 612.28729248047, -3307.3483886719, 20.340620040894, 0.000000, 0.000000, 180.50720214844); //
	CreateDynamicObject(2934, 615.24658203125, -3307.2575683594, 20.340620040894, 0.000000, 0.000000, 180.50537109375); //
	CreateDynamicObject(2934, 618.28704833984, -3307.1826171875, 20.340620040894, 0.000000, 0.000000, 180.50537109375); //
	CreateDynamicObject(2934, 616.625, -3307.345703125, 23.14281463623, 0.000000, 0.000000, 180.49987792969); //
	CreateDynamicObject(2934, 628.58251953125, -3297.5588378906, 20.340620040894, 0.000000, 0.000000, 180.50537109375); //
	CreateDynamicObject(2934, 628.8603515625, -3316.9995117188, 20.340620040894, 0.000000, 0.000000, 180.50537109375); //
	CreateDynamicObject(2934, 698.18981933594, -3294.1389160156, 20.340620040894, 0.000000, 0.000000, 89.724487304688); //
	CreateDynamicObject(2934, 690.98364257813, -3294.0776367188, 20.340620040894, 0.000000, 0.000000, 89.719848632813); //
	CreateDynamicObject(2934, 690.24938964844, -3320.943359375, 20.340620040894, 0.000000, 0.000000, 89.719848632813); //
	CreateDynamicObject(2934, 697.50036621094, -3320.9680175781, 20.340620040894, 0.000000, 0.000000, 89.719848632813); //
	CreateDynamicObject(2934, 635.12384033203, -3321.0024414063, 20.340620040894, 0.000000, 0.000000, 270.2353515625); //
	CreateDynamicObject(2934, 642.31665039063, -3320.9616699219, 20.340620040894, 0.000000, 0.000000, 270.23071289063); //
	CreateDynamicObject(2934, 635.73791503906, -3294.2199707031, 20.340620040894, 0.000000, 0.000000, 270.23071289063); //
	CreateDynamicObject(2934, 642.83813476563, -3294.150390625, 20.340620040894, 0.000000, 0.000000, 270.23071289063); //
	CreateDynamicObject(1393, 666.75823974609, -3299.8117675781, 26.111312866211, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1393, 667.17346191406, -3315.5490722656, 26.2522315979, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1393, 676.39379882813, -3315.4455566406, 26.111312866211, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1393, 675.67901611328, -3299.6948242188, 26.111312866211, 0.000000, 0.000000, 1.6122436523438); //
	CreateDynamicObject(3474, 672.23663330078, -3307.4401855469, 25.733551025391, 0.000000, 0.000000, 181.07116699219); //
	CreateDynamicObject(3633, 601.72027587891, -3312.9255371094, 19.405883789063, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3633, 618.62689208984, -3299.0893554688, 19.405883789063, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3633, 622.13226318359, -3321.3999023438, 19.405883789063, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3633, 647.51837158203, -3302.267578125, 19.405883789063, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3633, 656.19940185547, -3320.4873046875, 19.405883789063, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3633, 673.39495849609, -3316.9619140625, 19.405883789063, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3633, 685.17218017578, -3303.8610839844, 19.405883789063, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3633, 702.57940673828, -3300.1164550781, 19.405883789063, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3633, 709.43566894531, -3311.5375976563, 19.405883789063, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3633, 722.76092529297, -3303.5373535156, 19.405883789063, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3633, 739.19488525391, -3312.4958496094, 19.405883789063, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3633, 601.35046386719, -3300.7275390625, 19.405883789063, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3884, 756.58941650391, -3300.9143066406, 24.850399017334, 0.000000, 0.000000, 300.18017578125); //
	CreateDynamicObject(3884, 756.83422851563, -3305.3937988281, 24.850399017334, 0.000000, 0.000000, 270.26953125); //
	CreateDynamicObject(3884, 756.87847900391, -3310.4545898438, 24.850399017334, 0.000000, 0.000000, 270.26916503906); //
	CreateDynamicObject(3884, 756.62817382813, -3314.3522949219, 24.850399017334, 0.000000, 0.000000, 240.35925292969); //
	CreateDynamicObject(3864, 635.16796875, -3315.1870117188, 32.793231964111, 0.000000, 0.000000, 359.99450683594); //
	CreateDynamicObject(3864, 598.51513671875, -3311.6865234375, 32.793231964111, 0.000000, 0.000000, 179.45465087891); //
	CreateDynamicObject(3864, 598.5576171875, -3304.2294921875, 32.793231964111, 0.000000, 0.000000, 179.45068359375); //
	CreateDynamicObject(1431, 722.83618164063, -3311.2805175781, 19.430490493774, 0.000000, 0.000000, 61.432250976563); //
	CreateDynamicObject(1431, 736.0869140625, -3302.119140625, 19.430490493774, 0.000000, 0.000000, 111.27502441406); //
	CreateDynamicObject(1431, 684.27789306641, -3312.0517578125, 19.430490493774, 0.000000, 0.000000, 271.87524414063); //
	CreateDynamicObject(1431, 656.55651855469, -3302.4697265625, 19.430490493774, 0.000000, 0.000000, 231.99328613281); //
	CreateDynamicObject(1431, 624.88854980469, -3317.001953125, 19.430490493774, 0.000000, 0.000000, 132.29278564453); //
	CreateDynamicObject(1431, 606.75891113281, -3310.4611816406, 19.430490493774, 0.000000, 0.000000, 241.96166992188); //
	CreateDynamicObject(1431, 621.90472412109, -3298.6950683594, 19.430490493774, 0.000000, 0.000000, 331.68713378906); //
	CreateDynamicObject(3864, 644.17901611328, -3299.6623535156, 32.793231964111, 0.000000, 0.000000, 179.45446777344); //
	CreateDynamicObject(3864, 696.90191650391, -3300.2797851563, 32.793231964111, 0.000000, 0.000000, 179.45068359375); //
	CreateDynamicObject(3864, 688.19757080078, -3316.5239257813, 32.793231964111, 0.000000, 0.000000, 358.91012573242); //
	CreateDynamicObject(3864, 744.42333984375, -3310.0554199219, 33.920581817627, 0.000000, 0.000000, 358.91015625); //
	CreateDynamicObject(3864, 744.65374755859, -3304.9291992188, 33.920581817627, 0.000000, 0.000000, 358.90686035156); //
	CreateDynamicObject(3872, 736.44158935547, -3304.5454101563, 38.396354675293, 6.448974609375, 29.020416259766, 0.000000); //
	CreateDynamicObject(3872, 736.47637939453, -3304.1237792969, 38.396354675293, 6.448974609375, 29.020385742188, 0.000000); //
	CreateDynamicObject(3872, 735.99761962891, -3309.8786621094, 38.396354675293, 6.448974609375, 29.020385742188, 0.000000); //
	CreateDynamicObject(3872, 703.58618164063, -3300.673828125, 33.88695526123, 1.6122436523438, 3.2244567871094, 179.4599609375); //
	CreateDynamicObject(3872, 702.947265625, -3299.9775390625, 34.168792724609, 358.38775634766, 3.218994140625, 179.45617675781); //
	CreateDynamicObject(3872, 681.00903320313, -3316.0949707031, 34.02787399292, 4.8367309570313, 3.218994140625, 358.61944580078); //
	CreateDynamicObject(3872, 681.0087890625, -3316.0947265625, 34.02787399292, 4.833984375, 3.2135009765625, 358.61572265625); //
	CreateDynamicObject(3872, 650.63354492188, -3300.1862792969, 33.804164886475, 0.000000, 0.000000, 179.4599609375); //
	CreateDynamicObject(3872, 650.55102539063, -3299.8811035156, 33.804164886475, 0.000000, 0.000000, 179.45617675781); //
	CreateDynamicObject(3872, 630.19976806641, -3315.2233886719, 33.804164886475, 0.000000, 0.000000, 8.88623046875); //
	CreateDynamicObject(3872, 629.70251464844, -3316.0869140625, 33.804164886475, 0.000000, 0.000000, 8.8824768066406); //
	CreateDynamicObject(3872, 604.76934814453, -3310.9907226563, 33.804164886475, 0.000000, 0.000000, 186.13714599609); //
	CreateDynamicObject(3872, 604.5615234375, -3303.46875, 33.804164886475, 0.000000, 0.000000, 186.13586425781); //
	CreateDynamicObject(3872, 604.5615234375, -3303.46875, 33.804164886475, 0.000000, 0.000000, 186.13586425781); //
	CreateDynamicObject(1473, 734.93853759766, -3315.3381347656, 19.353628158569, 0.000000, 0.000000, 272.17889404297); //
	CreateDynamicObject(1473, 736.63427734375, -3315.3374023438, 20.140062332153, 0.000000, 0.000000, 272.17529296875); //
	CreateDynamicObject(1473, 738.36383056641, -3315.2231445313, 20.965049743652, 0.000000, 0.000000, 272.17529296875); //
	CreateDynamicObject(1473, 740.08044433594, -3315.18359375, 21.790037155151, 0.000000, 0.000000, 272.17529296875); //
	CreateDynamicObject(1473, 741.76782226563, -3315.1337890625, 22.56502532959, 0.000000, 0.000000, 272.17529296875); //
	CreateDynamicObject(1473, 743.45532226563, -3314.9606933594, 23.435537338257, 0.000000, 0.000000, 272.17529296875); //
	CreateDynamicObject(1431, 743.09606933594, -3315.3564453125, 19.430490493774, 0.000000, 0.000000, 93.540344238281); //
	CreateDynamicObject(1431, 743.095703125, -3315.3564453125, 20.555473327637, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 743.095703125, -3315.3564453125, 21.580457687378, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 743.095703125, -3315.3564453125, 22.380445480347, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 742.02600097656, -3315.0981445313, 19.780485153198, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 742.025390625, -3315.09765625, 20.85546875, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 742.025390625, -3315.09765625, 22.005451202393, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 741.28057861328, -3315.0598144531, 19.93048286438, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 741.2802734375, -3315.0595703125, 21.055465698242, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 741.2802734375, -3315.0595703125, 21.78045463562, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 740.5361328125, -3314.8969726563, 20.230478286743, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 740.5361328125, -3314.896484375, 21.305461883545, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 739.86126708984, -3314.8688964844, 20.255477905273, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 739.8603515625, -3314.8681640625, 21.055465698242, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 739.25311279297, -3314.9772949219, 20.230478286743, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 739.2529296875, -3314.9765625, 20.230478286743, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 739.2529296875, -3314.9765625, 20.705471038818, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 738.59112548828, -3315.1569824219, 20.080480575562, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 738.5908203125, -3315.15625, 20.480474472046, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 737.90368652344, -3314.9030761719, 20.17140007019, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 737.27587890625, -3315.0153808594, 19.721406936646, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 736.75970458984, -3315.1420898438, 19.371412277222, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 736.03747558594, -3315.4262695313, 18.896419525146, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 734.82885742188, -3315.5307617188, 18.696422576904, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 735.34979248047, -3315.41015625, 18.614582061768, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 740.68591308594, -3314.90234375, 19.105495452881, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 739.98657226563, -3314.875, 19.105495452881, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 739.30450439453, -3315.0478515625, 19.105495452881, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 738.67181396484, -3315.22265625, 19.105495452881, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 738.03649902344, -3315.2243652344, 19.105495452881, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 737.42681884766, -3315.3642578125, 19.105495452881, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 741.29376220703, -3314.8684082031, 19.105495452881, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(1431, 741.92657470703, -3315.0065917969, 19.105495452881, 0.000000, 0.000000, 93.53759765625); //
	CreateDynamicObject(3361, 701.89868164063, -3304.3022460938, 24.621355056763, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3361, 707.20318603516, -3304.2570800781, 21.116544723511, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3361, 649.09002685547, -3305.9184570313, 24.496356964111, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(3361, 654.1328125, -3305.9663085938, 21.032466888428, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 717.35900878906, -3303.4675292969, 19.319786071777, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 701.68426513672, -3311.2531738281, 19.319786071777, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 737.92846679688, -3307.2141113281, 19.319786071777, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 751.85797119141, -3301.5178222656, 25.379291534424, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 765.51556396484, -3306.3649902344, 25.379291534424, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 743.00103759766, -3307.4819335938, 28.479503631592, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 695.23370361328, -3314.3820800781, 27.070316314697, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 689.05267333984, -3308.6123046875, 27.070316314697, 1.6122436523438, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 692.982421875, -3302.8410644531, 27.070316314697, 358.38775634766, 359.99725341797, 90.285675048828); //
	CreateDynamicObject(1225, 687.33624267578, -3299.8715820313, 27.070316314697, 358.38500976563, 359.99450683594, 90.28564453125); //
	CreateDynamicObject(1225, 643.90588378906, -3312.5192871094, 27.070316314697, 1.6094970703125, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 635.86193847656, -3299.4091796875, 27.070316314697, 1.6094970703125, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 644.6923828125, -3302.4423828125, 27.070316314697, 1.6094970703125, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 638.45593261719, -3309.2680664063, 27.070316314697, 1.6094970703125, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 659.76947021484, -3302.9807128906, 19.210708618164, 1.6094970703125, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 677.11834716797, -3309.9462890625, 19.210708618164, 1.6094970703125, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 677.1181640625, -3309.9462890625, 19.210708618164, 1.6094970703125, 0.000000, 0.000000); //
	CreateDynamicObject(1225, 673.68725585938, -3296.5834960938, 19.210708618164, 1.6094970703125, 358.38775634766, 0.000000); //
	CreateDynamicObject(1225, 673.6865234375, -3296.5830078125, 19.210708618164, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 657.37170410156, -3295.4584960938, 19.210708618164, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 654.95379638672, -3315.1794433594, 19.210708618164, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 621.59368896484, -3318.38671875, 19.210708618164, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 606.07446289063, -3298.9313964844, 19.210708618164, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 624.14489746094, -3294.6484375, 19.210708618164, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 600.8330078125, -3292.15625, 19.210708618164, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 625.68011474609, -3308.7355957031, 19.210708618164, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 608.22454833984, -3313.5290527344, 19.210708618164, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 592.47100830078, -3308.0827636719, 38.171730041504, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 585.91857910156, -3307.6098632813, 38.171730041504, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 592.96844482422, -3302.7492675781, 38.171730041504, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 587.98022460938, -3303.83203125, 38.171730041504, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 579.41577148438, -3301.3603515625, 34.226005554199, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 581.43255615234, -3295.7839355469, 30.280281066895, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 589.92065429688, -3295.13671875, 36.339786529541, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 564.84020996094, -3302.9157714844, 26.518058776855, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 567.00952148438, -3317.3679199219, 26.518058776855, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 577.63055419922, -3316.4094238281, 30.041027069092, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 577.17315673828, -3311.1726074219, 34.127670288086, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 589.97705078125, -3320.3154296875, 35.959613800049, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 555.97607421875, -3320.0571289063, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 555.98260498047, -3319.3522949219, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 555.98944091797, -3318.6472167969, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 556.56170654297, -3320.1467285156, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 556.52966308594, -3319.4409179688, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 556.78570556641, -3318.7392578125, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 556.5849609375, -3318.5966796875, 20.31763458252, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 556.412109375, -3319.4243164063, 20.31763458252, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 556.40600585938, -3320.1423339844, 20.31763458252, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 555.59777832031, -3320.1169433594, 20.31763458252, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 555.62640380859, -3319.3679199219, 20.31763458252, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 555.80029296875, -3318.537109375, 20.31763458252, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 555.71435546875, -3315.0241699219, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 554.43603515625, -3310.5454101563, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 557.03857421875, -3307.9807128906, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 554.68408203125, -3304.2626953125, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 557.15252685547, -3301.6552734375, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 553.34112548828, -3299.2434082031, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 553.52270507813, -3295.3974609375, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 553.46014404297, -3296.2736816406, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 553.40557861328, -3297.1787109375, 19.331203460693, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 553.4052734375, -3297.1787109375, 20.181190490723, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 553.35668945313, -3296.2824707031, 20.181190490723, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 553.34375, -3295.4797363281, 20.181190490723, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 554.07733154297, -3295.4375, 20.181190490723, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 554.15441894531, -3296.2687988281, 20.181190490723, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 554.14367675781, -3297.080078125, 20.181190490723, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 554.1435546875, -3297.080078125, 19.206205368042, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 554.20788574219, -3296.1750488281, 19.206205368042, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(1225, 554.26904296875, -3295.2346191406, 19.206205368042, 1.60400390625, 358.38500976563, 0.000000); //
	CreateDynamicObject(2900, 686.87707519531, -3303.9592285156, 26.706844329834, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 687.40032958984, -3308.8637695313, 26.706844329834, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 687.14733886719, -3313.1418457031, 26.706844329834, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 698.31109619141, -3315.3820800781, 26.706844329834, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 694.29486083984, -3299.2346191406, 26.706844329834, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 641.87933349609, -3298.5268554688, 26.706844329834, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 634.03991699219, -3302.7209472656, 26.706844329834, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 642.51324462891, -3314.8610839844, 26.706844329834, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 634.77056884766, -3312.5124511719, 26.706844329834, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 594.23950195313, -3305.8840332031, 37.877548217773, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 594.29583740234, -3301.130859375, 37.877548217773, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 594.50164794922, -3311.1420898438, 37.877548217773, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 594.03411865234, -3321.5786132813, 35.481929779053, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 593.91876220703, -3293.5961914063, 35.481929779053, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 744.84973144531, -3296.2456054688, 24.349349975586, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 745.06335449219, -3298.2521972656, 24.349349975586, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 741.82263183594, -3305.1923828125, 27.872318267822, 0.000000, 0.000000, 0.000000); //
	CreateDynamicObject(2900, 741.69537353516, -3310.1354980469, 27.872318267822, 0.000000, 0.000000, 0.000000); //
	//CS_Vill
	CreateDynamicObject(12814,-1490.62988281,-324.32421875,264.95413208,0.00000000,0.00000000,0.00000000); //object(cuntyeland04) (1)
	CreateDynamicObject(16121,-1522.54931641,-296.46817017,263.88720703,0.00000000,0.00000000,65.99694824); //object(des_rockgp2_09) (1)
	CreateDynamicObject(16121,-1482.40234375,-282.37014771,263.88720703,0.00000000,0.00000000,159.99694824); //object(des_rockgp2_09) (2)
	CreateDynamicObject(3594,-1475.95361328,-306.79360962,265.59310913,0.00000000,0.00000000,0.00000000); //object(la_fuckcar1) (1)
	CreateDynamicObject(12814,-1460.72363281,-286.78710938,264.95413208,0.00000000,0.00000000,0.00000000); //object(cuntyeland04) (2)
	CreateDynamicObject(3594,-1475.88562012,-306.92178345,266.25546265,0.00000000,0.00000000,0.00000000); //object(la_fuckcar1) (2)
	CreateDynamicObject(16121,-1470.04785156,-327.37500000,263.88720703,0.00000000,0.00000000,335.99487305); //object(des_rockgp2_09) (3)
	CreateDynamicObject(12814,-1490.61914062,-374.31054688,264.95413208,0.00000000,0.00000000,0.00000000); //object(cuntyeland04) (3)
	CreateDynamicObject(16121,-1471.07299805,-379.01266479,263.88720703,0.00000000,0.00000000,335.99487305); //object(des_rockgp2_09) (4)
	CreateDynamicObject(16121,-1518.87329102,-368.09274292,263.88720703,0.00000000,0.00000000,335.99487305); //object(des_rockgp2_09) (5)
	CreateDynamicObject(16121,-1510.93750000,-415.60937500,263.88720703,0.00000000,0.00000000,157.99438477); //object(des_rockgp2_09) (6)
	CreateDynamicObject(12814,-1489.81665039,-424.08666992,264.95413208,0.00000000,0.00000000,180.00000000); //object(cuntyeland04) (4)
	CreateDynamicObject(16121,-1510.87963867,-432.66284180,263.88720703,0.00000000,0.00000000,157.99438477); //object(des_rockgp2_09) (7)
	CreateDynamicObject(16121,-1472.75097656,-430.00585938,263.88720703,0.00000000,0.00000000,335.99487305); //object(des_rockgp2_09) (8)
	CreateDynamicObject(16121,-1486.31420898,-458.72549438,263.88720703,0.00000000,0.00000000,281.99487305); //object(des_rockgp2_09) (9)
	CreateDynamicObject(12814,-1497.81774902,-473.90045166,264.95413208,0.00000000,0.00000000,359.99450684); //object(cuntyeland04) (5)
	CreateDynamicObject(12814,-1527.81835938,-478.17578125,264.95413208,0.00000000,0.00000000,359.98352051); //object(cuntyeland04) (6)
	CreateDynamicObject(12814,-1527.80859375,-428.21109009,264.95413208,0.00000000,0.00000000,179.98901367); //object(cuntyeland04) (7)
	CreateDynamicObject(16121,-1486.31347656,-458.72460938,263.88720703,0.00000000,0.00000000,281.99157715); //object(des_rockgp2_09) (10)
	CreateDynamicObject(16121,-1514.28112793,-491.53433228,263.88720703,0.00000000,0.00000000,321.99157715); //object(des_rockgp2_09) (10)
	CreateDynamicObject(16121,-1542.61718750,-523.31170654,263.88720703,0.00000000,0.00000000,247.98730469); //object(des_rockgp2_09) (10)
	CreateDynamicObject(12814,-1527.79040527,-528.07849121,264.95413208,0.00000000,0.00000000,179.98352051); //object(cuntyeland04) (6)
	CreateDynamicObject(12814,-1557.77416992,-486.06860352,264.95413208,0.00000000,0.00000000,359.97802734); //object(cuntyeland04) (6)
	CreateDynamicObject(12814,-1557.31372070,-535.50421143,264.95413208,0.00000000,0.00000000,179.97802734); //object(cuntyeland04) (6)
	CreateDynamicObject(12814,-1526.38000488,-311.55804443,267.15408325,354.00000000,0.00000000,270.00000000); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1576.13708496,-311.58364868,269.77413940,0.00000000,0.00000000,90.00000000); //object(cuntyeland04) (1)
	CreateDynamicObject(16667,-1548.66284180,-325.28222656,265.15173340,0.00000000,0.00000000,20.00000000); //object(des_rockgp2_14) (1)
	CreateDynamicObject(11011,-1572.69128418,-305.66302490,273.16561890,0.00000000,0.00000000,90.00000000); //object(crackfactjump_sfs) (1)
	CreateDynamicObject(3095,-1555.70617676,-299.39559937,271.08706665,90.00000000,179.95605469,270.04394531); //object(a51_jetdoor) (1)
	CreateDynamicObject(3095,-1555.67126465,-310.09753418,271.08706665,90.00000000,179.95056152,270.04394531); //object(a51_jetdoor) (2)
	CreateDynamicObject(16121,-1572.68432617,-290.17770386,263.88720703,0.00000000,0.00000000,65.99487305); //object(des_rockgp2_09) (1)
	CreateDynamicObject(16121,-1565.02270508,-281.11746216,263.88720703,0.00000000,0.00000000,191.99487305); //object(des_rockgp2_09) (1)
	CreateDynamicObject(3095,-1581.26708984,-301.20593262,273.80416870,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (3)
	CreateDynamicObject(3095,-1559.89807129,-306.15948486,271.08706665,90.00000000,179.95056152,0.04394531); //object(a51_jetdoor) (4)
	CreateDynamicObject(3095,-1572.00402832,-305.96548462,271.08706665,90.00000000,179.94506836,0.03845215); //object(a51_jetdoor) (5)
	CreateDynamicObject(3095,-1571.95434570,-302.48306274,271.08706665,90.00000000,179.94506836,180.03845215); //object(a51_jetdoor) (6)
	CreateDynamicObject(3095,-1576.45629883,-298.39346313,271.08706665,90.00000000,179.94506836,270.03295898); //object(a51_jetdoor) (7)
	CreateDynamicObject(3095,-1577.00756836,-310.02377319,271.08706665,90.00000000,179.94506836,270.03845215); //object(a51_jetdoor) (8)
	CreateDynamicObject(14877,-1575.81176758,-304.16940308,272.26412964,0.00000000,0.00000000,180.00000000); //object(michelle-stairs) (1)
	CreateDynamicObject(3095,-1581.36560059,-310.12332153,273.80416870,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (9)
	CreateDynamicObject(3095,-1590.30798340,-309.33605957,273.80416870,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (10)
	CreateDynamicObject(3095,-1590.04296875,-300.59747314,273.80416870,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (11)
	CreateDynamicObject(3095,-1572.44934082,-309.99746704,275.05416870,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (12)
	CreateDynamicObject(3095,-1559.50537109,-310.14947510,275.05416870,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (13)
	CreateDynamicObject(3095,-1564.77758789,-310.13952637,275.05416870,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (14)
	CreateDynamicObject(3095,-1559.61791992,-301.99243164,275.05416870,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (15)
	CreateDynamicObject(3095,-1567.61523438,-301.01498413,275.05416870,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (16)
	CreateDynamicObject(3095,-1571.69238281,-298.51055908,275.05416870,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (17)
	CreateDynamicObject(16667,-1536.43652344,-328.14746094,265.15173340,0.00000000,0.00000000,189.99206543); //object(des_rockgp2_14) (2)
	CreateDynamicObject(12814,-1576.13708496,-327.05697632,254.81909180,0.00000000,271.99993896,89.99993896); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1530.31640625,-335.34542847,264.95413208,0.00000000,0.00000000,92.00000000); //object(cuntyeland04) (1)
	CreateDynamicObject(16667,-1521.15893555,-327.00402832,265.15173340,0.00000000,0.00000000,189.99206543); //object(des_rockgp2_14) (3)
	CreateDynamicObject(17557,-1544.03918457,-376.29461670,267.36245728,0.00000000,0.00000000,180.00000000); //object(mstorcp2_lae2) (1)
	CreateDynamicObject(12814,-1529.24133301,-365.33251953,264.95413208,0.00000000,0.00000000,91.99951172); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1528.21057129,-395.31799316,264.95413208,0.00000000,0.00000000,91.99951172); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1557.71850586,-436.06881714,264.95413208,0.00000000,0.00000000,179.99450684); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1567.64355469,-385.59082031,264.95413208,0.00000000,0.00000000,179.99450684); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1569.68896484,-335.75848389,264.95413208,0.00000000,0.00000000,180.49450684); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1599.64599609,-335.41253662,264.95413208,0.00000000,0.00000000,180.48889160); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1597.59826660,-385.38363647,264.95413208,0.00000000,0.00000000,180.49438477); //object(cuntyeland04) (1)
	CreateDynamicObject(16121,-1588.60351562,-514.52783203,263.88720703,0.00000000,0.00000000,217.98339844); //object(des_rockgp2_09) (10)
	CreateDynamicObject(16121,-1627.08947754,-489.03350830,263.88720703,0.00000000,0.00000000,207.97973633); //object(des_rockgp2_09) (10)
	CreateDynamicObject(16121,-1660.80102539,-456.59197998,263.88720703,0.00000000,0.00000000,191.97668457); //object(des_rockgp2_09) (10)
	CreateDynamicObject(16121,-1677.95837402,-411.94573975,263.88720703,0.00000000,0.00000000,159.97509766); //object(des_rockgp2_09) (10)
	CreateDynamicObject(16121,-1678.35400391,-365.20770264,263.88720703,0.00000000,0.00000000,159.97192383); //object(des_rockgp2_09) (10)
	CreateDynamicObject(16121,-1678.28491211,-322.16314697,263.88720703,0.00000000,0.00000000,159.97192383); //object(des_rockgp2_09) (10)
	CreateDynamicObject(16121,-1677.05310059,-276.02746582,263.88720703,0.00000000,0.00000000,159.97192383); //object(des_rockgp2_09) (10)
	CreateDynamicObject(16121,-1603.63854980,-256.61346436,263.88720703,0.00000000,0.00000000,1.97192383); //object(des_rockgp2_09) (10)
	CreateDynamicObject(16121,-1614.70690918,-221.29391479,263.88720703,0.00000000,0.00000000,1.96655273); //object(des_rockgp2_09) (10)
	CreateDynamicObject(16121,-1648.82019043,-214.59585571,263.88720703,0.00000000,0.00000000,73.96655273); //object(des_rockgp2_09) (10)
	CreateDynamicObject(16121,-1672.61389160,-239.95454407,263.88720703,0.00000000,0.00000000,127.96545410); //object(des_rockgp2_09) (10)
	CreateDynamicObject(12814,-1587.54113770,-435.57662964,264.95413208,0.00000000,0.00000000,179.99450684); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1587.50769043,-485.26937866,264.95413208,0.00000000,0.00000000,359.99450684); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1586.79211426,-535.26843262,264.95413208,0.00000000,0.00000000,179.98901367); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1617.41394043,-485.26647949,264.95413208,0.00000000,0.00000000,359.98901367); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1617.47583008,-435.25454712,264.95413208,0.00000000,0.00000000,179.99450684); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1647.27539062,-485.23529053,264.95413208,0.00000000,0.00000000,359.98901367); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1647.45776367,-435.40896606,264.95413208,0.00000000,0.00000000,179.99450684); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1677.44653320,-435.40679932,264.95413208,0.00000000,0.00000000,179.99450684); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1627.56274414,-386.19534302,264.95413208,0.00000000,0.00000000,180.49438477); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1657.48303223,-385.63522339,264.95413208,0.00000000,0.00000000,180.49438477); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1629.63684082,-336.23202515,264.95413208,0.00000000,0.00000000,180.49438477); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1659.58972168,-335.71823120,264.95413208,0.00000000,0.00000000,180.49438477); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1600.22521973,-286.20214844,264.95413208,0.00000000,0.00000000,0.49438477); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1630.16918945,-286.33612061,264.95413208,0.00000000,0.00000000,0.49438477); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1660.16613770,-285.80059814,264.95413208,0.00000000,0.00000000,0.49438477); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1660.59631348,-235.88627625,264.95413208,0.00000000,0.00000000,180.49438477); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1630.60510254,-236.35745239,264.95413208,0.00000000,0.00000000,180.48889160); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1600.66149902,-236.25875854,264.95413208,0.00000000,0.00000000,180.48889160); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1601.54760742,-301.60562134,254.81909180,0.00000000,271.99951172,359.99450684); //object(cuntyeland04) (1)
	CreateDynamicObject(12814,-1576.00061035,-296.11502075,254.81909180,0.00000000,271.99951172,269.98901367); //object(cuntyeland04) (1)
	CreateDynamicObject(3095,-1594.03942871,-300.61111450,269.87908936,271.99993896,180.00000000,268.00000000); //object(a51_jetdoor) (18)
	CreateDynamicObject(3095,-1589.78784180,-296.63476562,269.87908936,271.99951172,179.99450684,181.99499512); //object(a51_jetdoor) (19)
	CreateDynamicObject(3095,-1596.54748535,-292.65777588,269.20407104,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (20)
	CreateDynamicObject(3095,-1596.50634766,-283.69143677,269.20407104,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (21)
	CreateDynamicObject(3095,-1587.58605957,-291.99606323,269.20407104,0.00000000,0.00000000,0.00000000); //object(a51_jetdoor) (22)
	CreateDynamicObject(3576,-1583.40881348,-361.66244507,266.45462036,0.00000000,0.00000000,0.00000000); //object(dockcrates2_la) (1)
	CreateDynamicObject(3576,-1583.45507812,-363.56250000,266.45462036,0.00000000,0.00000000,0.00000000); //object(dockcrates2_la) (2)
	CreateDynamicObject(8077,-1581.34655762,-375.08679199,263.66033936,0.00000000,0.00000000,0.00000000); //object(vgsfrates06) (2)
	CreateDynamicObject(8355,-1532.08813477,-298.89501953,274.95828247,0.00000000,90.00000000,90.00000000); //object(vgssairportland18) (2)
	CreateDynamicObject(8355,-1474.73242188,-362.96679688,274.95828247,0.00000000,90.00000000,3.99902344); //object(vgssairportland18) (3)
	CreateDynamicObject(8355,-1510.30554199,-482.35842896,274.95828247,0.00000000,90.00000000,323.99902344); //object(vgssairportland18) (4)
	CreateDynamicObject(8355,-1590.12756348,-512.51879883,274.95828247,0.00000000,90.00000000,251.99780273); //object(vgssairportland18) (5)
	CreateDynamicObject(8355,-1640.20812988,-472.55096436,274.95828247,0.00000000,90.00000000,233.99743652); //object(vgssairportland18) (6)
	CreateDynamicObject(8355,-1678.84411621,-403.64981079,274.95828247,0.00000000,90.00000000,193.99475098); //object(vgssairportland18) (7)
	CreateDynamicObject(8355,-1682.78442383,-339.05349731,274.95828247,0.00000000,90.00000000,183.99108887); //object(vgssairportland18) (8)
	CreateDynamicObject(8355,-1680.46704102,-207.77810669,273.45828247,0.00000000,90.00000000,173.98803711); //object(vgssairportland18) (9)
	CreateDynamicObject(8355,-1649.74450684,-203.55859375,273.45828247,0.00000000,90.00000000,147.98498535); //object(vgssairportland18) (10)
	CreateDynamicObject(8355,-1597.61120605,-204.40565491,273.45828247,0.00000000,90.00000000,105.98034668); //object(vgssairportland18) (11)
	CreateDynamicObject(8355,-1608.26831055,-230.03602600,273.45828247,0.00000000,90.00000000,5.97961426); //object(vgssairportland18) (12)
	CreateDynamicObject(8615,-1602.08752441,-308.04702759,267.58584595,0.00000000,0.00000000,270.00000000); //object(vgssstairs04_lvs) (1)
	CreateDynamicObject(8615,-1581.11828613,-327.67950439,267.58584595,0.00000000,0.00000000,0.00000000); //object(vgssstairs04_lvs) (2)
	CreateDynamicObject(4585,-1582.75109863,-277.40960693,194.25704956,0.00000000,0.00000000,0.00000000); //object(towerlan2) (1)
	CreateDynamicObject(4585,-1582.75109863,-277.40960693,194.25704956,0.00000000,0.00000000,0.00000000); //object(towerlan2) (2)
	CreateDynamicObject(11088,-1631.65136719,-383.99121094,271.51007080,0.00000000,0.00000000,0.00000000); //object(crackfact_sfs) (1)
	CreateDynamicObject(8613,-1647.81250000,-382.59375000,269.06137085,0.00000000,0.00000000,87.99499512); //object(vgssstairs03_lvs) (1)
	CreateDynamicObject(3095,-1650.59704590,-376.39102173,271.84884644,0.00000000,0.00000000,358.00000000); //object(a51_jetdoor) (25)
	CreateDynamicObject(3095,-1645.98339844,-385.53570557,271.84884644,0.00000000,0.00000000,357.99499512); //object(a51_jetdoor) (26)
	CreateDynamicObject(3095,-1641.83471680,-377.50445557,271.84884644,0.00000000,0.00000000,359.99499512); //object(a51_jetdoor) (28)
	CreateDynamicObject(3095,-1637.11657715,-386.47216797,271.84884644,0.00000000,0.00000000,359.99499512); //object(a51_jetdoor) (30)
	CreateDynamicObject(3095,-1632.85253906,-377.69470215,271.84884644,0.00000000,0.00000000,359.99450684); //object(a51_jetdoor) (31)
	CreateDynamicObject(3095,-1624.28527832,-377.72409058,271.84884644,0.00000000,0.00000000,359.99450684); //object(a51_jetdoor) (32)
	CreateDynamicObject(3095,-1615.35595703,-377.72183228,271.84884644,0.00000000,0.00000000,359.99450684); //object(a51_jetdoor) (33)
	CreateDynamicObject(3095,-1607.57897949,-377.70550537,271.84884644,0.00000000,0.00000000,359.99450684); //object(a51_jetdoor) (34)
	CreateDynamicObject(3095,-1607.94726562,-386.69738770,271.84884644,0.00000000,0.00000000,359.99450684); //object(a51_jetdoor) (35)
	CreateDynamicObject(3095,-1616.93237305,-386.70425415,271.84884644,0.00000000,0.00000000,359.99450684); //object(a51_jetdoor) (36)
	CreateDynamicObject(3095,-1625.90307617,-386.67700195,271.84884644,0.00000000,0.00000000,359.99450684); //object(a51_jetdoor) (37)
	CreateDynamicObject(3095,-1631.77404785,-386.27261353,271.87384033,0.00000000,0.00000000,359.99450684); //object(a51_jetdoor) (38)
	CreateDynamicObject(17068,-1634.20800781,-372.08673096,272.63812256,0.00000000,0.00000000,89.99450684); //object(xjetty01) (1)
	CreateDynamicObject(17068,-1602.19299316,-383.93951416,272.63812256,0.00000000,0.00000000,359.99450684); //object(xjetty01) (2)
	CreateDynamicObject(17068,-1644.51367188,-418.72851562,272.63812256,0.00000000,0.00000000,269.98901367); //object(xjetty01) (3)
	CreateDynamicObject(17068,-1622.51953125,-418.73828125,272.63812256,0.00000000,0.00000000,269.98901367); //object(xjetty01) (4)
	CreateDynamicObject(8613,-1627.95715332,-397.33401489,269.06137085,0.00000000,0.00000000,87.99499512); //object(vgssstairs03_lvs) (2)
	CreateDynamicObject(3095,-1650.34594727,-392.69213867,271.84884644,0.00000000,0.00000000,359.99499512); //object(a51_jetdoor) (39)
	CreateDynamicObject(3095,-1650.35693359,-401.67840576,271.84884644,0.00000000,0.00000000,359.99450684); //object(a51_jetdoor) (40)
	CreateDynamicObject(3095,-1641.44677734,-392.74029541,271.84884644,0.00000000,0.00000000,359.99450684); //object(a51_jetdoor) (41)
	CreateDynamicObject(3095,-1636.45983887,-394.28530884,271.87384033,0.00000000,0.00000000,357.99450684); //object(a51_jetdoor) (42)
	CreateDynamicObject(3095,-1636.56738281,-403.20605469,271.84884644,0.00000000,0.00000000,359.98901367); //object(a51_jetdoor) (43)
	CreateDynamicObject(3095,-1643.27246094,-401.67968750,271.87384033,0.00000000,0.00000000,359.98901367); //object(a51_jetdoor) (44)
	CreateDynamicObject(3095,-1625.76721191,-394.48867798,271.84884644,0.00000000,0.00000000,359.99450684); //object(a51_jetdoor) (45)
	CreateDynamicObject(3095,-1625.77343750,-403.43066406,271.84884644,0.00000000,0.00000000,359.98901367); //object(a51_jetdoor) (46)
	CreateDynamicObject(3095,-1630.49377441,-403.63372803,271.87384033,0.00000000,0.00000000,359.99450684); //object(a51_jetdoor) (47)
	CreateDynamicObject(11428,-1597.88220215,-437.55236816,268.28009033,0.00000000,0.00000000,190.00000000); //object(des_indruin02) (1)
	CreateDynamicObject(11440,-1583.53515625,-464.12500000,264.18713379,0.00000000,0.00000000,0.00000000); //object(des_pueblo1) (1)
	CreateDynamicObject(11442,-1580.08496094,-477.28906250,264.96194458,0.00000000,0.00000000,90.00000000); //object(des_pueblo3) (1)
	CreateDynamicObject(11443,-1581.21582031,-492.71679688,264.96194458,0.00000000,0.00000000,90.00000000); //object(des_pueblo4) (1)
	CreateDynamicObject(11457,-1613.57812500,-450.34472656,263.71194458,0.00000000,0.00000000,0.00000000); //object(des_pueblo09) (1)
	CreateDynamicObject(11458,-1542.24560547,-449.22891235,264.46194458,0.00000000,0.00000000,260.00000000); //object(des_pueblo10) (1)
	CreateDynamicObject(11492,-1536.53613281,-480.28027344,264.96194458,0.00000000,0.00000000,90.00000000); //object(des_rshed1_) (1)
	CreateDynamicObject(11440,-1614.82360840,-345.10073853,264.18713379,0.00000000,0.00000000,0.00000000); //object(des_pueblo1) (2)
	CreateDynamicObject(8337,-1627.94433594,-345.10839844,264.91009521,0.00000000,0.00000000,0.00000000); //object(vgsfrates10) (1)
	CreateDynamicObject(17068,-1612.29199219,-372.05371094,272.63812256,0.00000000,0.00000000,89.99450684); //object(xjetty01) (1)
	CreateDynamicObject(17068,-1602.11621094,-405.92187500,272.63812256,0.00000000,0.00000000,359.98352051); //object(xjetty01) (2)
	CreateDynamicObject(3095,-1650.62597656,-410.66406250,271.87384033,0.00000000,0.00000000,359.98352051); //object(a51_jetdoor) (44)
	CreateDynamicObject(3095,-1636.59558105,-412.17651367,271.87384033,0.00000000,0.00000000,359.98901367); //object(a51_jetdoor) (44)
	CreateDynamicObject(3095,-1627.65478516,-412.47454834,271.87384033,0.00000000,0.00000000,359.98901367); //object(a51_jetdoor) (44)
	CreateDynamicObject(3095,-1618.70227051,-412.39694214,271.87384033,0.00000000,0.00000000,359.98901367); //object(a51_jetdoor) (44)
	CreateDynamicObject(3095,-1609.74560547,-412.39465332,271.87384033,0.00000000,0.00000000,359.98901367); //object(a51_jetdoor) (44)
	CreateDynamicObject(3095,-1616.83374023,-403.39898682,271.87384033,0.00000000,0.00000000,359.98901367); //object(a51_jetdoor) (44)
	CreateDynamicObject(3095,-1607.85095215,-403.37814331,271.87384033,0.00000000,0.00000000,359.98901367); //object(a51_jetdoor) (44)
	CreateDynamicObject(3095,-1607.55578613,-394.63327026,271.87384033,0.00000000,0.00000000,359.98901367); //object(a51_jetdoor) (44)
	CreateDynamicObject(3095,-1616.70349121,-394.37219238,271.87384033,0.00000000,0.00000000,359.98901367); //object(a51_jetdoor) (44)
	CreateDynamicObject(17068,-1643.52124023,-416.38558960,268.48834229,20.00000000,0.00000000,359.98901367); //object(xjetty01) (3)
	CreateDynamicObject(3798,-1603.65649414,-380.54379272,272.35302734,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (1)
	CreateDynamicObject(3798,-1603.66992188,-380.71679688,273.57772827,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,-1603.98669434,-395.53680420,272.80291748,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (3)
	CreateDynamicObject(5269,-1618.55371094,-381.61035156,272.91326904,0.00000000,90.00000000,0.00000000); //object(las2dkwar05) (2)
	CreateDynamicObject(5269,-1618.55371094,-381.61035156,272.91326904,0.00000000,90.00000000,0.00000000); //object(las2dkwar05) (3)
	CreateDynamicObject(3798,-1610.96228027,-381.30664062,272.37765503,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,-1610.94458008,-379.45568848,272.37765503,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,-1610.94531250,-377.49966431,272.37765503,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,-1613.66711426,-361.33273315,263.52792358,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(11440,-1595.80590820,-415.86111450,264.18713379,0.00000000,0.00000000,0.00000000); //object(des_pueblo1) (1)
	CreateDynamicObject(11457,-1568.09570312,-411.02929688,263.71194458,0.00000000,0.00000000,90.00000000); //object(des_pueblo09) (1)
	CreateDynamicObject(8337,-1544.72265625,-420.27929688,262.06060791,0.00000000,0.00000000,179.99450684); //object(vgsfrates10) (1)
	CreateDynamicObject(11457,-1527.67639160,-406.13223267,263.71194458,0.00000000,0.00000000,90.00000000); //object(des_pueblo09) (1)
	CreateDynamicObject(3798,-1587.78588867,-409.86489868,264.74771118,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,-1585.75207520,-409.86547852,264.74771118,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,-1583.66369629,-409.87420654,264.74771118,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,-1589.74853516,-409.85308838,264.74771118,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,-1591.76806641,-409.85339355,264.74771118,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,-1593.81225586,-409.85665894,264.74771118,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(6959,-1539.68737793,-379.60266113,272.78085327,0.00000000,0.00000000,0.00000000); //object(vegasnbball1) (1)
	CreateDynamicObject(6959,-1539.90405273,-382.99447632,272.75585938,0.00000000,0.00000000,0.00000000); //object(vegasnbball1) (2)
	CreateDynamicObject(3798,-1604.05432129,-411.42990112,272.30303955,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,-1604.04626465,-409.58398438,272.30303955,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,-1604.07055664,-409.58016968,274.27755737,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(3798,-1604.07482910,-411.57821655,274.27755737,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(17068,-1612.16162109,-418.77493286,272.66311646,0.00000000,0.00000000,269.98901367); //object(xjetty01) (4)
	CreateDynamicObject(3798,-1602.13818359,-417.33410645,270.90338135,0.00000000,0.00000000,0.00000000); //object(acbox3_sfs) (2)
	CreateDynamicObject(5269,-1600.01367188,-394.32324219,263.16387939,12.14538574,0.00000000,90.14282227); //object(las2dkwar05) (2)
	CreateDynamicObject(5269,-1600.00866699,-396.30844116,263.16387939,12.14538574,0.00000000,90.14282227); //object(las2dkwar05) (2)
	CreateDynamicObject(17068,-1542.98339844,-413.19421387,270.61343384,10.00000000,0.00000000,357.98901367); //object(xjetty01) (4)
	CreateDynamicObject(17068,-1543.73046875,-434.52737427,265.68927002,15.99755859,0.00000000,357.98400879); //object(xjetty01) (4)
	CreateDynamicObject(16667,-1534.00366211,-328.72332764,265.15173340,0.00000000,0.00000000,189.99206543); //object(des_rockgp2_14) (2)
	CreateDynamicObject(11442,-1623.29541016,-289.02154541,264.96194458,0.00000000,0.00000000,90.00000000); //object(des_pueblo3) (1)
	CreateDynamicObject(11442,-1631.54821777,-310.54254150,264.96194458,0.00000000,0.00000000,0.00000000); //object(des_pueblo3) (1)
	CreateDynamicObject(11457,-1621.10009766,-305.71276855,263.71194458,0.00000000,0.00000000,90.00000000); //object(des_pueblo09) (1)
	CreateDynamicObject(11457,-1657.25244141,-280.68731689,263.71194458,0.00000000,0.00000000,90.00000000); //object(des_pueblo09) (1)
	CreateDynamicObject(11492,-1633.22155762,-268.25570679,264.96194458,0.00000000,0.00000000,90.00000000); //object(des_rshed1_) (1)
	CreateDynamicObject(3576,-1585.51721191,-340.27236938,266.45462036,0.00000000,0.00000000,0.00000000); //object(dockcrates2_la) (2)
	CreateDynamicObject(3576,-1585.53503418,-343.28012085,266.45462036,0.00000000,0.00000000,0.00000000); //object(dockcrates2_la) (2)
	CreateDynamicObject(7191,-1552.52746582,-381.41448975,263.98648071,0.00000000,0.00000000,180.00000000); //object(vegasnnewfence2b) (1)
	CreateDynamicObject(7191,-1554.42822266,-381.40234375,265.86145020,0.00000000,270.00000000,0.00000000); //object(vegasnnewfence2b) (3)
	CreateDynamicObject(7191,-1556.42187500,-381.19628906,263.98648071,0.00000000,0.00000000,0.00000000); //object(vegasnnewfence2b) (4)
	CreateDynamicObject(3576,-1556.45959473,-340.34442139,266.45462036,0.00000000,0.00000000,0.00000000); //object(dockcrates2_la) (2)
	CreateDynamicObject(11443,-1551.58703613,-347.24621582,264.96194458,0.00000000,0.00000000,270.00000000); //object(des_pueblo4) (1)
	CreateDynamicObject(5269,-1618.55371094,-381.61035156,272.88827515,0.00000000,90.00000000,180.00000000); //object(las2dkwar05) (3)
	CreateDynamicObject(4239,-1472.56481934,-298.65011597,268.83251953,0.00000000,0.00000000,214.00000000); //object(billbrdlan_11) (1)
	CreateDynamicObject(16121,-1470.44384766,-286.03268433,263.88720703,0.00000000,0.00000000,25.99487305); //object(des_rockgp2_09) (3)
	CreateDynamicObject(5269,-1557.99328613,-377.34957886,269.08392334,0.00000000,270.00000000,180.28823853); //object(las2dkwar05) (2)
	CreateDynamicObject(5269,-1558.04394531,-369.20263672,269.08392334,0.00000000,270.00000000,180.28564453); //object(las2dkwar05) (2)
	CreateDynamicObject(5269,-1557.99169922,-387.67016602,269.08392334,0.00000000,270.00000000,180.28564453); //object(las2dkwar05) (2)
	CreateDynamicObject(5269,-1551.97070312,-382.62396240,269.08392334,0.00000000,270.00000000,272.28564453); //object(las2dkwar05) (2)
	CreateDynamicObject(5269,-1551.97070312,-382.62304688,269.05892944,0.00000000,270.00000000,92.28515625); //object(las2dkwar05) (2)
	CreateDynamicObject(3576,-1504.63452148,-347.76464844,266.45462036,0.00000000,0.00000000,90.00000000); //object(dockcrates2_la) (2)
	CreateDynamicObject(3576,-1504.99755859,-342.77807617,266.45462036,0.00000000,0.00000000,90.00000000); //object(dockcrates2_la) (2)
	CreateDynamicObject(2991,-1482.64843750,-383.95562744,265.58969116,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (1)
	CreateDynamicObject(2991,-1487.83020020,-391.57388306,265.58969116,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (2)
	CreateDynamicObject(2991,-1484.18286133,-407.78448486,265.58969116,0.00000000,0.00000000,0.00000000); //object(imy_bbox) (3)
	CreateDynamicObject(2973,-1492.85058594,-386.68637085,264.96194458,0.00000000,0.00000000,0.00000000); //object(k_cargo2) (1)
	CreateDynamicObject(2973,-1496.47448730,-422.63748169,264.96194458,0.00000000,0.00000000,0.00000000); //object(k_cargo2) (2)
	CreateDynamicObject(2934,-1495.74633789,-376.09777832,266.41387939,0.00000000,0.00000000,60.00000000); //object(kmb_container_red) (1)
	CreateDynamicObject(2934,-1487.88610840,-417.66510010,266.41387939,0.00000000,0.00000000,59.99633789); //object(kmb_container_red) (2)
	CreateDynamicObject(2062,-1478.84375000,-373.75567627,265.53057861,0.00000000,0.00000000,0.00000000); //object(cj_oildrum2) (1)
	CreateDynamicObject(2062,-1478.24194336,-372.93060303,265.53057861,0.00000000,0.00000000,0.00000000); //object(cj_oildrum2) (2)
	CreateDynamicObject(2062,-1479.49035645,-372.66891479,265.53057861,0.00000000,0.00000000,0.00000000); //object(cj_oildrum2) (3)
	CreateDynamicObject(2062,-1496.48498535,-369.39212036,265.53057861,0.00000000,0.00000000,0.00000000); //object(cj_oildrum2) (4)
	CreateDynamicObject(2062,-1489.05932617,-383.93539429,265.53057861,0.00000000,0.00000000,0.00000000); //object(cj_oildrum2) (5)
	CreateDynamicObject(2062,-1495.83239746,-367.41232300,265.53057861,0.00000000,0.00000000,0.00000000); //object(cj_oildrum2) (6)
	CreateDynamicObject(2062,-1497.27233887,-368.54391479,265.53057861,0.00000000,0.00000000,0.00000000); //object(cj_oildrum2) (7)
	CreateDynamicObject(2062,-1488.05969238,-383.95883179,265.53057861,0.00000000,0.00000000,0.00000000); //object(cj_oildrum2) (8)
	CreateDynamicObject(2062,-1494.94384766,-407.58682251,265.53057861,0.00000000,0.00000000,0.00000000); //object(cj_oildrum2) (9)
	CreateDynamicObject(18260,-1491.46557617,-399.36468506,266.53512573,0.00000000,0.00000000,0.00000000); //object(crates01) (1)
	CreateDynamicObject(930,-1503.33789062,-344.84899902,265.43780518,0.00000000,0.00000000,90.00000000); //object(o2_bottles) (1)
	CreateDynamicObject(931,-1563.96777344,-301.48022461,271.40722656,0.00000000,0.00000000,90.00000000); //object(rack3) (1)
	CreateDynamicObject(1362,-1502.28393555,-326.30606079,265.56042480,0.00000000,0.00000000,0.00000000); //object(cj_firebin) (1)
	CreateDynamicObject(1362,-1552.50732422,-308.07293701,270.26043701,0.00000000,0.00000000,0.00000000); //object(cj_firebin) (2)
	CreateDynamicObject(3461,-1502.21093750,-326.33139038,264.46206665,0.00000000,0.00000000,0.00000000); //object(tikitorch01_lvs) (1)
	CreateDynamicObject(3461,-1552.57958984,-307.93368530,268.98229980,0.00000000,0.00000000,0.00000000); //object(tikitorch01_lvs) (2)
	CreateDynamicObject(1362,-1552.71972656,-302.77835083,270.38043213,0.00000000,0.00000000,0.00000000); //object(cj_firebin) (3)
	CreateDynamicObject(3461,-1552.62304688,-302.79608154,269.40701294,0.00000000,0.00000000,0.00000000); //object(tikitorch01_lvs) (3)
	CreateDynamicObject(1362,-1484.23132324,-375.08752441,265.56042480,0.00000000,0.00000000,0.00000000); //object(cj_firebin) (4)
	CreateDynamicObject(3576,-1579.45617676,-320.25961304,270.90487671,0.00000000,0.00000000,90.00000000); //object(dockcrates2_la) (2)
	CreateDynamicObject(1362,-1483.20593262,-398.55627441,265.56042480,0.00000000,0.00000000,0.00000000); //object(cj_firebin) (5)
	CreateDynamicObject(1362,-1490.43017578,-409.90872192,265.56042480,0.00000000,0.00000000,0.00000000); //object(cj_firebin) (6)
	CreateDynamicObject(1362,-1490.53283691,-433.60067749,265.56042480,0.00000000,0.00000000,0.00000000); //object(cj_firebin) (7)
	CreateDynamicObject(1362,-1499.12658691,-436.52734375,265.56042480,0.00000000,0.00000000,0.00000000); //object(cj_firebin) (8)
	CreateDynamicObject(1362,-1494.79455566,-392.87545776,265.56042480,0.00000000,0.00000000,0.00000000); //object(cj_firebin) (9)
	CreateDynamicObject(3461,-1484.17529297,-374.88543701,264.43679810,0.00000000,0.00000000,0.00000000); //object(tikitorch01_lvs) (4)
	CreateDynamicObject(3461,-1494.65136719,-392.89398193,264.43679810,0.00000000,0.00000000,0.00000000); //object(tikitorch01_lvs) (5)
	CreateDynamicObject(3461,-1483.17016602,-398.57669067,264.43679810,0.00000000,0.00000000,0.00000000); //object(tikitorch01_lvs) (6)
	CreateDynamicObject(3461,-1490.39465332,-409.87438965,264.43679810,0.00000000,0.00000000,0.00000000); //object(tikitorch01_lvs) (7)
	CreateDynamicObject(3461,-1490.48510742,-433.55554199,264.43679810,0.00000000,0.00000000,0.00000000); //object(tikitorch01_lvs) (8)
	CreateDynamicObject(3461,-1499.20764160,-436.60064697,264.43679810,0.00000000,0.00000000,0.00000000); //object(tikitorch01_lvs) (9)
	CreateDynamicObject(851,-1494.66455078,-433.30075073,264.96194458,0.00000000,0.00000000,0.00000000); //object(cj_urb_rub_2) (1)
	CreateDynamicObject(849,-1487.73864746,-430.98074341,265.26168823,0.00000000,0.00000000,0.00000000); //object(cj_urb_rub_3) (1)
	CreateDynamicObject(3119,-1493.30798340,-429.95007324,265.26187134,0.00000000,0.00000000,0.00000000); //object(cs_ry_props) (1)
	CreateDynamicObject(3005,-1492.88476562,-438.77450562,264.96194458,0.00000000,0.00000000,0.00000000); //object(smash_box_stay) (1)
	CreateDynamicObject(2890,-1596.57653809,-319.13812256,269.78195190,0.00000000,0.00000000,90.00000000); //object(kmb_skip) (1)
	//CS_Dust5
	CreateDynamicObject(4867,468.22900390625,-2434.4509277344,11.335000038147,0,0,0); // object (lasrnway3_LAS) (1)
    CreateDynamicObject(4199,558.40399169922,-2436.5649414063,13.409999847412,0,0,90); // object (garages1_LAn) (1)
    CreateDynamicObject(4199,568.32598876953,-2457.4409179688,13.409999847412,0,0,0); // object (garages1_LAn) (2)
    CreateDynamicObject(4199,568.33001708984,-2488.9729003906,13.409999847412,0,0,0); // object (garages1_LAn) (3)
    CreateDynamicObject(4199,541.91198730469,-2437.0590820313,13.409999847412,0,0,140); // object (garages1_LAn) (4)
    CreateDynamicObject(4199,531.11901855469,-2459.1340332031,13.409999847412,0,0,180); // object (garages1_LAn) (5)
    CreateDynamicObject(4199,539.45501708984,-2480.6870117188,8.1499996185303,340,0,270); // object (garages1_LAn) (6)
    CreateDynamicObject(4199,531.11798095703,-2459.1340332031,17.604000091553,0,0,179.99450683594); // object (garages1_LAn) (7)
    CreateDynamicObject(4199,541.91101074219,-2437.0590820313,17.600999832153,0,0,139.99877929688); // object (garages1_LAn) (8)
    CreateDynamicObject(4199,558.40301513672,-2436.5649414063,17.570999145508,0,0,90); // object (garages1_LAn) (9)
    CreateDynamicObject(4199,568.32501220703,-2457.4409179688,17.566999435425,0,0,0); // object (garages1_LAn) (10)
    CreateDynamicObject(4199,568.32897949219,-2488.9729003906,17.548000335693,0,0,0); // object (garages1_LAn) (11)
    CreateDynamicObject(4199,519.53302001953,-2470.6799316406,13.435000419617,0,0,179.99450683594); // object (garages1_LAn) (12)
    CreateDynamicObject(4199,531.08001708984,-2459.1359863281,17.604000091553,0,0,0); // object (garages1_LAn) (13)
    CreateDynamicObject(4199,520.36901855469,-2449.1840820313,17.604000091553,0,0,90); // object (garages1_LAn) (14)
    CreateDynamicObject(4199,508.36898803711,-2479.3449707031,17.604000091553,0,0,180); // object (garages1_LAn) (15)
    CreateDynamicObject(4199,521.07501220703,-2492.2360839844,13.409999847412,0,0,270); // object (garages1_LAn) (16)
    CreateDynamicObject(4199,541.02301025391,-2492.2670898438,17.586999893188,0,0,269.99450683594); // object (garages1_LAn) (17)
    CreateDynamicObject(4199,552.4990234375,-2492.2409667969,13.409999847412,0,0,269.99450683594); // object (garages1_LAn) (19)
    CreateDynamicObject(4199,552.4990234375,-2492.2399902344,17.591999053955,0,0,269.99450683594); // object (garages1_LAn) (18)
    CreateDynamicObject(4199,497.95599365234,-2459.2958984375,13.435000419617,0,0,90); // object (garages1_LAn) (20)
    CreateDynamicObject(4199,492.44198608398,-2449.1630859375,17.604000091553,0,0,90); // object (garages1_LAn) (21)
    CreateDynamicObject(8650,497.42999267578,-2464.6640625,15.300000190735,0,0,90); // object (shbbyhswall06_lvs) (1)
    CreateDynamicObject(4199,492.44100952148,-2449.1630859375,13.446999549866,0,0,90); // object (garages1_LAn) (22)
    CreateDynamicObject(4199,471.48300170898,-2459.162109375,17.604000091553,0,0,180); // object (garages1_LAn) (23)
    CreateDynamicObject(4199,471.48199462891,-2459.162109375,13.449000358582,0,0,179.99450683594); // object (garages1_LAn) (24)
    CreateDynamicObject(4199,467.3630065918,-2453.1110839844,13.435000419617,0,0,90); // object (garages1_LAn) (25)
    CreateDynamicObject(14416,480.21701049805,-2461.1860351563,12.25800037384,0,0,0); // object (carter-stairs07) (1)
    CreateDynamicObject(14416,478.76901245117,-2461.1831054688,12.256999969482,0,0,0); // object (carter-stairs07) (2)
    CreateDynamicObject(4199,508.33099365234,-2479.3449707031,17.604000091553,0,0,0); // object (garages1_LAn) (26)
    CreateDynamicObject(4199,508.32998657227,-2479.3449707031,13.434000015259,0,0,0); // object (garages1_LAn) (27)
    CreateDynamicObject(4199,471.43701171875,-2490.1120605469,13.449000358582,0,0,179.99450683594); // object (garages1_LAn) (28)
    CreateDynamicObject(4199,509.58200073242,-2500.3181152344,13.408999443054,0,0,269.99450683594); // object (garages1_LAn) (29)
    CreateDynamicObject(4199,487.34298706055,-2500.1110839844,13.409999847412,0,0,269.99450683594); // object (garages1_LAn) (30)
    CreateDynamicObject(4199,541.03497314453,-2501.7290039063,17.586999893188,0,0,269.99450683594); // object (garages1_LAn) (31)
    CreateDynamicObject(4199,509.49398803711,-2511.2189941406,17.604000091553,0,0,270); // object (garages1_LAn) (32)
    CreateDynamicObject(8650,492.44198608398,-2494.7429199219,15.345999717712,0,0,90); // object (shbbyhswall06_lvs) (2)
    CreateDynamicObject(8650,476.81500244141,-2479.0920410156,15.345999717712,0,0,0); // object (shbbyhswall06_lvs) (3)
    CreateDynamicObject(3499,476.9469909668,-2494.5891113281,16.70299911499,0,0,0); // object (wdpillar02_lvs) (1)
    CreateDynamicObject(4199,471.45599365234,-2490.3969726563,21.718999862671,0,179.99450683594,0); // object (garages1_LAn) (34)
    CreateDynamicObject(4199,471.48199462891,-2459.162109375,21.746999740601,0,0,179.99450683594); // object (garages1_LAn) (35)
    CreateDynamicObject(4199,492.64898681641,-2499.8010253906,21.718999862671,0,179.99450683594,90); // object (garages1_LAn) (36)
    CreateDynamicObject(4199,508.36801147461,-2479.3449707031,21.785999298096,0,0,179.99450683594); // object (garages1_LAn) (37)
    CreateDynamicObject(4199,509.49301147461,-2511.2189941406,21.745000839233,0,0,269.99450683594); // object (garages1_LAn) (38)
    CreateDynamicObject(4199,508.32998657227,-2479.3459472656,21.785999298096,0,0,0); // object (garages1_LAn) (39)
    CreateDynamicObject(3862,498.625,-2468.2019042969,12.506999969482,0,0,306); // object (marketstall02_SFXRF) (
    CreateDynamicObject(3862,499.63800048828,-2474.4379882813,12.506999969482,0,0,268.74670410156); // object (marketstall02_SFXRF) (
    CreateDynamicObject(3863,499.89898681641,-2484.1088867188,12.506999969482,0,0,268); // object (marketstall03_SFXRF) (
    CreateDynamicObject(3861,488.11401367188,-2467.4040527344,12.506999969482,0,0,0); // object (marketstall01_SFXRF) (
    CreateDynamicObject(3799,478.92498779297,-2492.751953125,11.211000442505,0,0,0); // object (acbox2_SFS) (1)
    CreateDynamicObject(4199,464.30099487305,-2511.3830566406,17.604000091553,0,0,269.99450683594); // object (garages1_LAn) (40)
    CreateDynamicObject(4199,461.03298950195,-2497.6640625,17.604000091553,0,0,179.99450683594); // object (garages1_LAn) (41)
    CreateDynamicObject(4199,451.05999755859,-2479.2150878906,9.16100025177,344,0,90); // object (garages1_LAn) (42)
    CreateDynamicObject(4199,461.03201293945,-2497.6640625,13.456000328064,0,0,179.99450683594); // object (garages1_LAn) (43)
    CreateDynamicObject(4199,461.03298950195,-2459.1560058594,17.604000091553,0,0,179.99450683594); // object (garages1_LAn) (44)
    CreateDynamicObject(4199,461.03298950195,-2459.1560058594,13.434000015259,0,0,179.99450683594); // object (garages1_LAn) (45)
    CreateDynamicObject(4199,452.00299072266,-2469.1831054688,13.435000419617,0,0,90); // object (garages1_LAn) (46)
    CreateDynamicObject(4199,452.00299072266,-2469.1831054688,17.584999084473,0,0,90); // object (garages1_LAn) (47)
    CreateDynamicObject(4199,451.3219909668,-2487.6530761719,17.559999465942,0,0,270); // object (garages1_LAn) (48)
    CreateDynamicObject(4199,455.2619934082,-2487.7648925781,13.395999908447,0,0,90); // object (garages1_LAn) (49)
    CreateDynamicObject(4199,487.13400268555,-2511.6560058594,13.421999931335,0,0,269.99450683594); // object (garages1_LAn) (50)
    CreateDynamicObject(4199,477.93899536133,-2521.8840332031,13.421999931335,0,0,269.99450683594); // object (garages1_LAn) (51)
    CreateDynamicObject(4199,509.50698852539,-2519.0380859375,17.604000091553,0,0,269.99450683594); // object (garages1_LAn) (52)
    CreateDynamicObject(4199,478.54098510742,-2527.9050292969,17.604000091553,0,0,270); // object (garages1_LAn) (53)
    CreateDynamicObject(4199,492.61499023438,-2499.8640136719,21.718999862671,0,0,90); // object (garages1_LAn) (54)
    CreateDynamicObject(4199,464.30099487305,-2511.3830566406,21.812999725342,0,0,269.99450683594); // object (garages1_LAn) (55)
    CreateDynamicObject(4199,509.50698852539,-2519.0380859375,21.757999420166,0,0,269.99450683594); // object (garages1_LAn) (56)
    CreateDynamicObject(4199,478.54000854492,-2527.9040527344,21.739999771118,0,0,269.99450683594); // object (garages1_LAn) (57)
    CreateDynamicObject(4199,464.29501342773,-2511.419921875,17.604000091553,0,0,90); // object (garages1_LAn) (58)
    CreateDynamicObject(4199,464.29501342773,-2511.419921875,21.746999740601,0,0,90); // object (garages1_LAn) (59)
    CreateDynamicObject(4199,447.79901123047,-2521.4289550781,13.421999931335,0,0,269.99450683594); // object (garages1_LAn) (60)
    CreateDynamicObject(4199,447.03500366211,-2527.9089355469,17.604000091553,0,0,269.99450683594); // object (garages1_LAn) (63)
    CreateDynamicObject(4199,447.03399658203,-2527.9079589844,21.732999801636,0,0,269.99450683594); // object (garages1_LAn) (64)
    CreateDynamicObject(4199,464.29501342773,-2511.419921875,13.444999694824,0,0,90); // object (garages1_LAn) (65)
    CreateDynamicObject(4199,464.29699707031,-2511.3830566406,13.444999694824,0,0,270); // object (garages1_LAn) (66)
    CreateDynamicObject(4199,460.99398803711,-2497.662109375,13.456000328064,0,0,0); // object (garages1_LAn) (67)
    CreateDynamicObject(4199,460.99301147461,-2497.662109375,17.649000167847,0,0,0); // object (garages1_LAn) (68)
    CreateDynamicObject(4199,460.99200439453,-2497.662109375,21.801000595093,0,0,0); // object (garages1_LAn) (69)
    CreateDynamicObject(4199,451.29098510742,-2487.6740722656,17.559999465942,0,0,90); // object (garages1_LAn) (70)
    CreateDynamicObject(4199,455.23599243164,-2487.7490234375,13.395999908447,0,0,269.99450683594); // object (garages1_LAn) (71)
    CreateDynamicObject(4199,447.77801513672,-2520.7189941406,13.062999725342,0,0,270); // object (garages1_LAn) (72)
    CreateDynamicObject(4199,447.7568359375,-2520.0087890625,12.703999519348,0,0,90); // object (garages1_LAn) (74)
    CreateDynamicObject(4199,447.7353515625,-2519.298828125,12.344999313354,0,0,270.01098632813); // object (garages1_LAn) (75)
    CreateDynamicObject(4199,447.71484375,-2518.5888671875,11.985999107361,0,0,90); // object (garages1_LAn) (76)
    CreateDynamicObject(4199,447.69403076172,-2517.8791503906,11.626998901367,0,0,270.02197265625); // object (garages1_LAn) (77)
    CreateDynamicObject(4199,447.67303466797,-2517.1691894531,11.267998695374,0,0,270.02746582031); // object (garages1_LAn) (78)
    CreateDynamicObject(4199,447.65203857422,-2516.4592285156,10.90899848938,0,0,270.03295898438); // object (garages1_LAn) (79)
    CreateDynamicObject(4199,447.630859375,-2515.7490234375,10.549998283386,0,0,90); // object (garages1_LAn) (80)
    CreateDynamicObject(4199,447.609375,-2515.0390625,10.190998077393,0,0,270.0439453125); // object (garages1_LAn) (81)
    CreateDynamicObject(4199,447.5888671875,-2514.3291015625,9.8319978713989,0,0,270.0439453125); // object (garages1_LAn) (82)
    CreateDynamicObject(4199,447.568359375,-2513.619140625,9.4729976654053,0,0,90); // object (garages1_LAn) (88)
    CreateDynamicObject(4199,426.10198974609,-2512.4699707031,13.456000328064,0,0,180); // object (garages1_LAn) (83)
    CreateDynamicObject(4199,426.10198974609,-2512.4699707031,17.611000061035,0,0,179.99450683594); // object (garages1_LAn) (84)
    CreateDynamicObject(4199,426.10198974609,-2512.4699707031,21.718999862671,0,0,179.99450683594); // object (garages1_LAn) (85)
    CreateDynamicObject(4199,451.31600952148,-2487.6489257813,17.534999847412,0,180,90); // object (garages1_LAn) (86)
    CreateDynamicObject(3498,435.85699462891,-2482.2141113281,14.520000457764,0,0,0); // object (wdpillar01_lvs) (1)
    CreateDynamicObject(3498,435.8450012207,-2493.0778808594,14.520000457764,0,0,0); // object (wdpillar01_lvs) (2)
    CreateDynamicObject(4199,425.31399536133,-2475.0759277344,13.397999763489,0,0,118.99993896484); // object (garages1_LAn) (87)
    CreateDynamicObject(4199,409.03298950195,-2495.7600097656,13.397999763489,0,0,180); // object (garages1_LAn) (89)
    CreateDynamicObject(4199,471.40600585938,-2490.3969726563,21.718999862671,0,179.99450683594,180); // object (garages1_LAn) (90)
    CreateDynamicObject(4199,471.43200683594,-2459.162109375,21.746999740601,0,180,180); // object (garages1_LAn) (91)
    CreateDynamicObject(4199,425.31298828125,-2475.0749511719,17.568000793457,0,0,118.99841308594); // object (garages1_LAn) (92)
    CreateDynamicObject(4199,409.03201293945,-2495.7600097656,17.555000305176,0,0,179.99450683594); // object (garages1_LAn) (93)
    CreateDynamicObject(4199,426.05200195313,-2512.4709472656,13.456000328064,0,0,0); // object (garages1_LAn) (94)
    CreateDynamicObject(4199,426.05200195313,-2512.4709472656,17.613000869751,0,0,0); // object (garages1_LAn) (95)
    CreateDynamicObject(4199,426.05200195313,-2512.4709472656,21.79700088501,0,0,0); // object (garages1_LAn) (96)
    CreateDynamicObject(4199,405.73901367188,-2531.3181152344,13.435000419617,0,0,270); // object (garages1_LAn) (97)
    CreateDynamicObject(4199,405.7380065918,-2531.3181152344,17.632999420166,0,0,269.99450683594); // object (garages1_LAn) (98)
    CreateDynamicObject(4199,405.73699951172,-2531.3181152344,21.790000915527,0,0,269.99450683594); // object (garages1_LAn) (99)
    CreateDynamicObject(4199,384.58200073242,-2510.5939941406,13.435000419617,0,0,180); // object (garages1_LAn) (100)
    CreateDynamicObject(4199,384.58099365234,-2510.5939941406,17.591999053955,0,0,179.99450683594); // object (garages1_LAn) (101)
    CreateDynamicObject(4199,384.57998657227,-2510.5939941406,21.774000167847,0,0,179.99450683594); // object (garages1_LAn) (102)
    CreateDynamicObject(4199,409.00698852539,-2495.7490234375,13.397999763489,0,0,0); // object (garages1_LAn) (103)
    CreateDynamicObject(4199,409.00698852539,-2495.7490234375,17.542999267578,0,0,0); // object (garages1_LAn) (104)
    CreateDynamicObject(4199,384.57800292969,-2479.0009765625,13.435000419617,0,0,179.99450683594); // object (garages1_LAn) (105)
    CreateDynamicObject(4199,384.57699584961,-2479.0009765625,17.600999832153,0,0,179.99450683594); // object (garages1_LAn) (106)
    CreateDynamicObject(4199,393.92498779297,-2474.2619628906,13.435000419617,0,0,90); // object (garages1_LAn) (107)
    CreateDynamicObject(4199,393.92498779297,-2474.2619628906,17.565999984741,0,0,90); // object (garages1_LAn) (108)
    CreateDynamicObject(3863,437.49099731445,-2484.5559082031,12.470000267029,359.75,0.25,270.49609375); // object (marketstall03_SFXRF) (
    CreateDynamicObject(1570,489.87200927734,-2492.0100097656,12.666000366211,0,0,0); // object (CJ_NOODLE_3) (1)
    CreateDynamicObject(3799,468.37200927734,-2503.7580566406,15.428999900818,0,0,0); // object (acbox2_SFS) (2)
    CreateDynamicObject(18257,524.50897216797,-2490.9020996094,15.522999763489,0,0,88.5); // object (crates) (1)
    CreateDynamicObject(2973,524.03399658203,-2456.5979003906,15.498000144958,0,0,0); // object (k_cargo2) (1)
    CreateDynamicObject(2973,521.22100830078,-2460.4780273438,15.510999679565,0,0,346); // object (k_cargo2) (2)
    CreateDynamicObject(3799,495.07400512695,-2462.3400878906,15.548000335693,0,0,0); // object (acbox2_SFS) (3)
    CreateDynamicObject(3799,503.91500854492,-2461.83203125,14.371999740601,0,0,0); // object (acbox2_SFS) (4)
    CreateDynamicObject(4199,557.19897460938,-2471.7971191406,13.409999847412,0,0,0); // object (garages1_LAn) (109)
    CreateDynamicObject(4199,557.19799804688,-2471.7971191406,17.538999557495,0,0,0); // object (garages1_LAn) (110)
    CreateDynamicObject(3799,492.05700683594,-2506.4951171875,15.373999595642,0,0,0); // object (acbox2_SFS) (5)
    CreateDynamicObject(3799,481.68399047852,-2514.4938964844,15.385999679565,0,0,0); // object (acbox2_SFS) (6)
    CreateDynamicObject(3799,474.55999755859,-2520.6789550781,14.284000396729,0,0,0); // object (acbox2_SFS) (7)
    CreateDynamicObject(3799,449.8039855957,-2518.6818847656,14.597999572754,0,0,0); // object (acbox2_SFS) (8)
    CreateDynamicObject(3800,468.51599121094,-2501.5048828125,15.562000274658,0,0,0); // object (acbox4_SFS) (1)
    CreateDynamicObject(3800,492.58599853516,-2506.6340332031,17.724000930786,0,0,0); // object (acbox4_SFS) (2)
    CreateDynamicObject(3800,465.36401367188,-2521.5100097656,15.534999847412,0,0,0); // object (acbox4_SFS) (3)
    CreateDynamicObject(3800,465.37399291992,-2520.3391113281,15.534999847412,0,0,0); // object (acbox4_SFS) (4)
    CreateDynamicObject(3800,465.71600341797,-2519.0380859375,15.498000144958,0,0,328); // object (acbox4_SFS) (5)
    CreateDynamicObject(3800,465.35699462891,-2520.6970214844,16.593999862671,0,0,0); // object (acbox4_SFS) (6)
    CreateDynamicObject(3796,452.89199829102,-2495.8090820313,11.310000419617,0,0,0); // object (acbox1_SFS) (1)
    CreateDynamicObject(3633,454.20300292969,-2504.9250488281,11.810000419617,0,0,0); // object (imoildrum4_LAS) (1)
    CreateDynamicObject(3633,454.18099975586,-2503.5380859375,11.810000419617,0,0,0); // object (imoildrum4_LAS) (2)
    CreateDynamicObject(3633,452.58898925781,-2504.9069824219,11.810000419617,0,0,0); // object (imoildrum4_LAS) (3)
    CreateDynamicObject(3633,454.22500610352,-2504.9450683594,12.75800037384,0,0,0); // object (imoildrum4_LAS) (4)
    CreateDynamicObject(1225,454.00100708008,-2495.99609375,11.817000389099,0,0,0); // object (barrel4) (2)
    CreateDynamicObject(1225,452.85699462891,-2494.7780761719,11.817000389099,0,0,0); // object (barrel4) (3)
    CreateDynamicObject(1225,451.84600830078,-2494.6730957031,11.817000389099,0,0,0); // object (barrel4) (4)
    CreateDynamicObject(1225,452.61199951172,-2496.5959472656,11.817000389099,0,0,0); // object (barrel4) (6)
    CreateDynamicObject(1225,501.79901123047,-2493.5791015625,11.741000175476,0,0,0); // object (barrel4) (7)
    CreateDynamicObject(1225,524.43103027344,-2504.6140136719,15.928000450134,0,0,0); // object (barrel4) (8)
    CreateDynamicObject(18260,425.13900756836,-2494.7819824219,12.907999992371,0,0,0); // object (crates01) (1)
    CreateDynamicObject(2991,432.94500732422,-2503.8059082031,11.925999641418,0,0,90); // object (imy_bbox) (1)
    CreateDynamicObject(2991,432.94400024414,-2503.8059082031,13.137999534607,0,0,90); // object (imy_bbox) (2)
    CreateDynamicObject(2974,439.74899291992,-2494.8759765625,11.322999954224,0,0,0); // object (k_cargo1) (1)
    CreateDynamicObject(3798,422.26998901367,-2484.6040039063,11.298000335693,0,0,30); // object (acbox3_SFS) (1)
    CreateDynamicObject(3798,424.0710144043,-2483.5759277344,11.298000335693,0,0,29.998168945313); // object (acbox3_SFS) (2)
    CreateDynamicObject(3798,425.85800170898,-2482.5471191406,11.298000335693,0,0,29.998168945313); // object (acbox3_SFS) (3)
    CreateDynamicObject(3798,427.66000366211,-2481.4750976563,11.298000335693,0,0,29.998168945313); // object (acbox3_SFS) (4)
    CreateDynamicObject(3798,426.91598510742,-2484.375,11.298000335693,0,0,29.998168945313); // object (acbox3_SFS) (5)
    CreateDynamicObject(3798,424.01800537109,-2483.5520019531,13.256999969482,0,0,29.998168945313); // object (acbox3_SFS) (6)
    CreateDynamicObject(3798,422.23199462891,-2484.5629882813,13.256999969482,0,0,29.998168945313); // object (acbox3_SFS) (7)
    CreateDynamicObject(3798,422.23098754883,-2484.5629882813,15.251000404358,0,0,29.998168945313); // object (acbox3_SFS) (8)
    CreateDynamicObject(3798,422.20199584961,-2487.7939453125,11.324000358582,0,0,46.998199462891); // object (acbox3_SFS) (9)
    CreateDynamicObject(3798,415.85501098633,-2501.8359375,10.475999832153,0,0,356.99401855469); // object (acbox3_SFS) (10)
    CreateDynamicObject(3798,417.85501098633,-2501.9399414063,11.300000190735,0,0,356.98974609375); // object (acbox3_SFS) (11)
    CreateDynamicObject(3799,505.32901000977,-2496.6240234375,15.373999595642,0,0,0); // object (acbox2_SFS) (9)
    CreateDynamicObject(874,549.84399414063,-2480.7189941406,11.916999816895,0,0,308); // object (veg_procgrasspatch) (1
    CreateDynamicObject(874,541.35198974609,-2449.7758789063,11.916999816895,0,0,307.99621582031); // object (veg_procgrasspatch) (2
    CreateDynamicObject(874,480.95599365234,-2478.5749511719,10.414999961853,0,0,319.99621582031); // object (veg_procgrasspatch) (3
    CreateDynamicObject(874,500.23498535156,-2489.6320800781,10.791000366211,0,0,279.99331665039); // object (veg_procgrasspatch) (4
    CreateDynamicObject(874,495.66400146484,-2466.9809570313,10.791000366211,0,0,279.99206542969); // object (veg_procgrasspatch) (5
    CreateDynamicObject(874,434.44500732422,-2476.9370117188,10.791000366211,0,0,279.99206542969); // object (veg_procgrasspatch) (6
    CreateDynamicObject(874,455.49200439453,-2499.087890625,12.729000091553,0,0,279.99206542969); // object (veg_procgrasspatch) (7
    CreateDynamicObject(874,419.01800537109,-2522.4619140625,11.789999961853,0,0,303.99206542969); // object (veg_procgrasspatch) (8
    CreateDynamicObject(874,394.49398803711,-2525.712890625,11.789999961853,0,0,239.99169921875); // object (veg_procgrasspatch) (9
    CreateDynamicObject(874,404.57800292969,-2494.3601074219,11.789999961853,0,0,165.99084472656); // object (veg_procgrasspatch) (1
    CreateDynamicObject(4199,492.44100952148,-2449.1630859375,21.746999740601,0,0,90); // object (garages1_LAn) (111)
    CreateDynamicObject(4199,520.36798095703,-2449.1840820313,21.785999298096,0,0,90); // object (garages1_LAn) (112)
    CreateDynamicObject(4199,531.07897949219,-2459.1359863281,21.811000823975,0,0,0); // object (garages1_LAn) (113)
    CreateDynamicObject(4199,531.11499023438,-2459.1330566406,21.811000823975,0,0,180); // object (garages1_LAn) (114)
    CreateDynamicObject(4199,541.90997314453,-2437.0590820313,21.735000610352,0,0,139.99877929688); // object (garages1_LAn) (115)
    CreateDynamicObject(4199,558.40197753906,-2436.5649414063,21.767000198364,0,0,90); // object (garages1_LAn) (116)
    CreateDynamicObject(4199,541.02197265625,-2492.2670898438,21.739000320435,0,0,269.99450683594); // object (garages1_LAn) (117)
    CreateDynamicObject(4199,541.03399658203,-2501.7290039063,21.763999938965,0,0,269.99450683594); // object (garages1_LAn) (118)
    CreateDynamicObject(3799,474.91198730469,-2476.3811035156,15.428999900818,0,0,0); // object (acbox2_SFS) (12)
    CreateDynamicObject(3798,449.69900512695,-2480.9331054688,11.310000419617,0,0,0); // object (acbox3_SFS) (12)
    CreateDynamicObject(3798,447.61999511719,-2479.1708984375,11.298000335693,0,0,38); // object (acbox3_SFS) (13)
    CreateDynamicObject(3798,448.50900268555,-2480.0249023438,13.265999794006,0,0,37.996215820313); // object (acbox3_SFS) (14)
    CreateDynamicObject(3799,492.15600585938,-2520.1530761719,15.385999679565,0,0,0); // object (acbox2_SFS) (13)
    CreateDynamicObject(2670,457.58898925781,-2520.1950683594,15.626999855042,0,0,0); // object (PROC_RUBBISH_1) (1)
    CreateDynamicObject(2670,478.1669921875,-2520.8068847656,15.626999855042,0,0,0); // object (PROC_RUBBISH_1) (2)
    CreateDynamicObject(2670,483.99600219727,-2510.4499511719,15.626999855042,0,0,0); // object (PROC_RUBBISH_1) (3)
    CreateDynamicObject(2670,489.66799926758,-2500.9760742188,15.614999771118,0,0,0); // object (PROC_RUBBISH_1) (4)
    CreateDynamicObject(2670,488.92700195313,-2486.0590820313,11.427000045776,0,0,0); // object (PROC_RUBBISH_1) (5)
    CreateDynamicObject(2670,494.41101074219,-2476.8000488281,11.427000045776,0,0,0); // object (PROC_RUBBISH_1) (6)
    CreateDynamicObject(2670,482.84399414063,-2471.9289550781,11.427000045776,0,0,0); // object (PROC_RUBBISH_1) (7)
    CreateDynamicObject(2674,480.18899536133,-2500.5200195313,15.545000076294,0,0,0); // object (PROC_RUBBISH_2) (1)
    CreateDynamicObject(2674,471.13800048828,-2493.1040039063,15.583999633789,0,0,0); // object (PROC_RUBBISH_2) (2)
    CreateDynamicObject(2674,472.25601196289,-2483.4399414063,15.583999633789,0,0,0); // object (PROC_RUBBISH_2) (3)
    CreateDynamicObject(2674,442.82699584961,-2478.0080566406,11.357000350952,0,0,0); // object (PROC_RUBBISH_2) (4)
    CreateDynamicObject(2674,427.88198852539,-2488.7600097656,11.357000350952,0,0,0); // object (PROC_RUBBISH_2) (5)
    CreateDynamicObject(2674,436.77801513672,-2497.8520507813,11.357000350952,0,0,0); // object (PROC_RUBBISH_2) (6)
    CreateDynamicObject(2674,442.68399047852,-2517.3000488281,15.557000160217,0,0,0); // object (PROC_RUBBISH_2) (7)
    CreateDynamicObject(2674,484.79299926758,-2518.2260742188,15.557000160217,0,0,0); // object (PROC_RUBBISH_2) (8)
    CreateDynamicObject(2676,440.38900756836,-2506.41796875,11.437999725342,0,0,0); // object (PROC_RUBBISH_8) (1)
    CreateDynamicObject(2676,470.34399414063,-2518.8530273438,15.638999938965,0,0,0); // object (PROC_RUBBISH_8) (2)
    CreateDynamicObject(2676,474.0530090332,-2502.5600585938,15.666000366211,0,0,0); // object (PROC_RUBBISH_8) (3)
    CreateDynamicObject(2676,488.99099731445,-2479.7619628906,11.437999725342,0,0,0); // object (PROC_RUBBISH_8) (4)
    CreateDynamicObject(2676,485.85000610352,-2459.8940429688,15.652000427246,0,0,0); // object (PROC_RUBBISH_8) (5)
    CreateDynamicObject(2676,521.5009765625,-2465.8068847656,15.652000427246,0,0,0); // object (PROC_RUBBISH_8) (6)
    CreateDynamicObject(2676,516.45397949219,-2482.294921875,15.652000427246,0,0,0); // object (PROC_RUBBISH_8) (7)
    CreateDynamicObject(2676,545.80102539063,-2481.4489746094,11.437999725342,0,0,0); // object (PROC_RUBBISH_8) (8)
    CreateDynamicObject(2676,540.28997802734,-2471.9450683594,11.437999725342,0,0,0); // object (PROC_RUBBISH_8) (9)
    CreateDynamicObject(2676,558.20599365234,-2446.5869140625,11.437999725342,0,0,0); // object (PROC_RUBBISH_8) (10)
    CreateDynamicObject(18260,401.30999755859,-2495.1879882813,12.907999992371,0,0,90.75); // object (crates01) (2)
    CreateDynamicObject(2912,400.14300537109,-2496.62109375,13.335000038147,0,0,0); // object (temp_crate1) (1)
    CreateDynamicObject(2912,402.17599487305,-2498.6049804688,15.335000038147,0,0,0); // object (temp_crate1) (2)
    CreateDynamicObject(2912,402.3330078125,-2496.5869140625,15.335000038147,0,0,0); // object (temp_crate1) (3)
    CreateDynamicObject(3799,391.98098754883,-2500.0148925781,11.173999786377,0,0,0); // object (acbox2_SFS) (14)
    CreateDynamicObject(3799,394.95999145508,-2500.0180664063,11.173999786377,0,0,0); // object (acbox2_SFS) (15)
    CreateDynamicObject(3799,393.40701293945,-2500.0200195313,13.338000297546,0,0,0); // object (acbox2_SFS) (16)
    CreateDynamicObject(4199,409.04400634766,-2501.4409179688,11.699000358582,0,0,179.99450683594); // object (garages1_LAn) (119)
    CreateDynamicObject(4199,409.03201293945,-2501.4938964844,11.647999763489,0,0,0); // object (garages1_LAn) (120)
    CreateDynamicObject(3799,408.16198730469,-2513.3610839844,13.637999534607,0,0,0); // object (acbox2_SFS) (17)
    CreateDynamicObject(3800,550.80297851563,-2465.0668945313,11.335000038147,0,0,0); // object (acbox4_SFS) (7)
    CreateDynamicObject(3800,550.7919921875,-2463.3911132813,11.335000038147,0,0,0); // object (acbox4_SFS) (8)
    CreateDynamicObject(3800,474.71398925781,-2475.8430175781,17.778999328613,0,0,0); // object (acbox4_SFS) (9)
    CreateDynamicObject(3800,500.12200927734,-2463.3579101563,15.548000335693,0,0,0); // object (acbox4_SFS) (10)
    CreateDynamicObject(3800,501.42300415039,-2479.0319824219,11.335000038147,0,0,0); // object (acbox4_SFS) (11)
    CreateDynamicObject(3800,450.69500732422,-2520.9299316406,15.534999847412,0,0,0); // object (acbox4_SFS) (12)
    CreateDynamicObject(3800,438.73901367188,-2490.0930175781,11.335000038147,0,0,0); // object (acbox4_SFS) (13)
    CreateDynamicObject(3800,438.78601074219,-2491.8181152344,11.335000038147,0,0,0); // object (acbox4_SFS) (14)
    CreateDynamicObject(3800,430.06500244141,-2494.0180664063,13.329999923706,0,0,0); // object (acbox4_SFS) (15)
    CreateDynamicObject(3800,415.39801025391,-2515.6020507813,11.335000038147,0,0,0); // object (acbox4_SFS) (16)
    CreateDynamicObject(3798,550.36602783203,-2459.8059082031,11.335000038147,0,0,0); // object (acbox3_SFS) (15)
    CreateDynamicObject(3798,548.32897949219,-2459.8139648438,11.335000038147,0,0,0); // object (acbox3_SFS) (16)
    CreateDynamicObject(3798,546.32397460938,-2459.8220214844,11.335000038147,0,0,0); // object (acbox3_SFS) (17)
    CreateDynamicObject(3798,548.30102539063,-2459.8720703125,13.338000297546,0,0,0); // object (acbox3_SFS) (18)
    CreateDynamicObject(3798,515.17999267578,-2467.6088867188,15.548000335693,0,0,0); // object (acbox3_SFS) (19)
    CreateDynamicObject(3798,511.44400024414,-2504.4099121094,15.522000312805,0,0,0); // object (acbox3_SFS) (20)
    CreateDynamicObject(3798,511.45001220703,-2502.3559570313,15.522000312805,0,0,0); // object (acbox3_SFS) (21)
    CreateDynamicObject(3798,501.00201416016,-2504.3349609375,15.522999763489,0,0,0); // object (acbox3_SFS) (22)
    CreateDynamicObject(3798,468.25100708008,-2491.5720214844,15.562000274658,0,0,0); // object (acbox3_SFS) (23)
    CreateDynamicObject(3798,478.36199951172,-2473.9909667969,11.335000038147,0,0,0); // object (acbox3_SFS) (24)
    CreateDynamicObject(3798,392.10501098633,-2502.9819335938,11.335000038147,0,0,0); // object (acbox3_SFS) (25)
    CreateDynamicObject(3798,394.69198608398,-2504.3278808594,11.335000038147,0,0,0); // object (acbox3_SFS) (26)
    CreateDynamicObject(3798,407.02301025391,-2518.416015625,11.335000038147,0,0,0); // object (acbox3_SFS) (27)
    CreateDynamicObject(3798,445.53399658203,-2494.6940917969,11.335000038147,0,0,0); // object (acbox3_SFS) (28)
    CreateDynamicObject(3799,538.39398193359,-2468.3688964844,11.199000358582,0,0,0); // object (acbox2_SFS) (18)
    CreateDynamicObject(3799,541.38098144531,-2468.37890625,10.423999786377,0,0,0); // object (acbox2_SFS) (19)
    CreateDynamicObject(3799,544.38098144531,-2468.3911132813,11.1859998703,0,0,0); // object (acbox2_SFS) (20)
    CreateDynamicObject(3799,552.92797851563,-2454.4389648438,11.16100025177,0,0,0); // object (acbox2_SFS) (21)
    CreateDynamicObject(3799,552.93402099609,-2451.3449707031,11.173999786377,0,0,0); // object (acbox2_SFS) (22)
    CreateDynamicObject(3799,552.9169921875,-2453.0739746094,13.338000297546,0,0,0); // object (acbox2_SFS) (23)
    CreateDynamicObject(8661,517.51202392578,-2506.5791015625,23.836999893188,0,0,89.75); // object (gnhtelgrnd_lvs) (1)
    CreateDynamicObject(4199,452.00299072266,-2469.1831054688,21.743999481201,0,0,90); // object (garages1_LAn) (121)
    CreateDynamicObject(4199,425.31298828125,-2475.0739746094,21.686000823975,0,0,118.99841308594); // object (garages1_LAn) (122)
    CreateDynamicObject(4199,409.03100585938,-2495.7600097656,21.736999511719,0,0,179.99450683594); // object (garages1_LAn) (123)
    CreateDynamicObject(4199,409.00698852539,-2495.7490234375,21.719999313354,0,0,0); // object (garages1_LAn) (124)
    CreateDynamicObject(4199,460.99099731445,-2497.662109375,25.979000091553,0,0,0); // object (garages1_LAn) (125)
    CreateDynamicObject(4199,461.02700805664,-2497.6560058594,25.979000091553,0,0,180); // object (garages1_LAn) (126)
}
/*Callbacks*/
CALLBACK: OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(VarSaltos[playerid] == 1)
    {
        if(newkeys & KEY_JUMP)
        {
            new Float:SJ[3];
            GetPlayerVelocity(playerid, SJ[0], SJ[1], SJ[2]);
            SetPlayerVelocity(playerid, SJ[0], SJ[1], SJ[2] + 1);
            VarSaltos[playerid] = 0;
            SetTimer("SuperSaltos", 2000, false);
        }    }
	if(IsPlayerInAnyVehicle(playerid) && FireShotON[playerid] == 1 && FireShot[playerid] == 0 && newkeys & 4 && !IsValidObject(gRocketObj[playerid]))   // Only run the code if the object doesn't already exist, otherwise more objects will take up gRocketObj and the previous ones won't be deleted
	{
 		SetPlayerTime(playerid,0,0);
  		new
	        vehicleid = GetPlayerVehicleID(playerid),
			Float:x,
			Float:y,
			Float:z,
			Float:r,
			Float:dist = 50.0,
			Float:tmpang,
			Float:tmpx,
			Float:tmpy,
			Float:tmpz;

		FireShot[playerid] = 1;
        SetTimerEx("ShotFire", 1000, 0, "i", playerid);
		GetVehiclePos(vehicleid, x, y, z);
	    GetVehicleZAngle(vehicleid, r);
		new rand = random(11);
  		switch(rand)
  		{
			case 0: gRocketObj[playerid] = CreateObject(18647, x, y, z, 0, 0, r);
			case 1: gRocketObj[playerid] = CreateObject(18648, x, y, z, 0, 0, r);
			case 2: gRocketObj[playerid] = CreateObject(18649, x, y, z, 0, 0, r);
 		case 3: gRocketObj[playerid] = CreateObject(18650, x, y, z, 0, 0, r);
			case 4: gRocketObj[playerid] = CreateObject(18651, x, y, z, 0, 0, r);
			case 5: gRocketObj[playerid] = CreateObject(18652, x, y, z, 0, 0, r);
            case 6: gRocketObj[playerid] = CreateObject(18647, x, y, z, 0, 0, r+90);
			case 7: gRocketObj[playerid] = CreateObject(18648, x, y, z, 0, 0, r+90);
			case 8: gRocketObj[playerid] = CreateObject(18649, x, y, z, 0, 0, r+90);
			case 9: gRocketObj[playerid] = CreateObject(18650, x, y, z, 0, 0, r+90);
			case 10: gRocketObj[playerid] = CreateObject(18651, x, y, z, 0, 0, r+90);
			case 11: gRocketObj[playerid] = CreateObject(18652, x, y, z, 0, 0, r+90);
		}
		//Thanks to Southclaw helped me alot
		for(new i;i<MAX_PLAYERS;i++)
		{
		    if(i == playerid)continue;
		    if(IsPlayerInRangeOfPoint(i, 50.0, x, y, z))
		    {
		        GetPlayerPos(i, tmpx, tmpy, tmpz);

		        tmpang = (90-atan2(tmpy-y, tmpx-x));
		        if(tmpang < 0)tmpang = 360.0+tmpang;
		        tmpang = 360.0 - tmpang;

				if( floatabs(tmpang-r) < 5.0)
				{
				    dist = GetPlayerDistanceFromPoint(i, x, y, z);
				}
		    }
		}

  	    MoveObject(gRocketObj[playerid],x + (dist * floatsin(-r, degrees)),y + (dist * floatcos(-r, degrees)),z,100.0);// Nice and fast!
	}
	if(PRESSED(KEY_YES))
	{
	if(EsHumano[playerid] == 1)
	{
	if(MediKits[playerid] == 0) return SendClientMessage(playerid, -1, "{FF0000}* You do not have meats available!");
	MediKits[playerid]--;
    new Float:laifxdxdxd, Float:jarmorxdxdxd;
    GetPlayerHealth(playerid, laifxdxdxd);
    GetPlayerArmour(playerid, jarmorxdxdxd);
	SetPlayerHealth(playerid, laifxdxdxd+50);
	SetPlayerArmour(playerid, jarmorxdxdxd+20);
	SendClientMessage(playerid, -1, "{77FF00}*Medikit used! +50 life and +20 armor");
	}
	if(EsZombie[playerid] == 1)
	{
	if(Carnes[playerid] == 0) return SendClientMessage(playerid, -1, "{FF0000}* You do not have meats available!");
	Carnes[playerid]--;
    new Float:laifxdxdxd, Float:jarmorxdxdxd;
    GetPlayerHealth(playerid, laifxdxdxd);
    GetPlayerArmour(playerid, jarmorxdxdxd);
	SetPlayerHealth(playerid, laifxdxdxd+50);
	SetPlayerArmour(playerid, jarmorxdxdxd+20);
	SendClientMessage(playerid, -1, "{77FF00}* Meat eaten! +50 Life and +20 Armor");
	}
	}
	return 1;
}
CALLBACK: ShotFire(playerid)
{
	FireShot[playerid] = 0;
	return 1;
}
CALLBACK: JuegoCargado(playerid)
{
	TogglePlayerControllable(playerid,1);
	GameTextForPlayer(playerid, "_~n~_~n~_~n~_~n~_~g~~h~Game Charged!",2000,6);
	return 1;
}

CALLBACK: CargandoJuego(playerid)
{
	SetTimerEx("JuegoCargado", 2000, false, "i", playerid);
	TogglePlayerControllable(playerid,0);
	GameTextForPlayer(playerid, "_~n~_~n~_~n~_~n~_~r~~h~Loading Game...",2000,6);
	return 1;
}
CALLBACK: Tele(playerid,command[])
{
    new dragName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, dragName, sizeof(dragName));
   	new colores = random(sizeof(mensajeColors));
    new vastring[256];
	format(vastring, sizeof(vastring), "* %s i teleport to (/%s)!", dragName,command);
    MandarMensajeTele(1,mensajeColors[colores], vastring);
   	return 1;
}
MandarMensajeTele(ID, color, const message[]) {
    if(GetTickCount() > vmensajes[ID-1]) {
        SendClientMessageToAll(color,message);
        vmensajes[ID-1] = GetTickCount()+timefor;
    }
}
CALLBACK: EnviarTeleCS(playerid, command[])
{
	new uNick[MAX_PLAYER_NAME], StrTele[500];
	new colores = random(sizeof(mensajeColors));
	GetPlayerName(playerid, uNick, sizeof(uNick));
	format(StrTele, sizeof(StrTele), "* %s i teleport to (/CS)! Mapa: %s",uNick,command);
	MandarMensajeTele(1,mensajeColors[colores], StrTele);
	return 1;
}
CALLBACK: OnObjectMoved(objectid)
{
	xFireworks_OnObjectMoved(objectid);
	for(new i;i<MAX_PLAYERS;i++)
	{
		if(objectid == gRocketObj[i])
		{
		    new
				Float:x,
				Float:y,
				Float:z;

		    GetObjectPos(gRocketObj[i], x, y, z);
		    CreateExplosion(x, y, z, 11, 3.0);
		    DestroyObject(gRocketObj[i]);
		}
	}
	return 1;
}
CALLBACK: ActualizarJuegos()
{
	SetTimer("UsersCS", 1000, true);
	SetTimer("UsersCS11", 1000, true);
	SetTimer("UsersCS10", 1000, true);
	SetTimer("UsersCS9", 1000, true);
	SetTimer("UsersCS8", 1000, true);
	SetTimer("UsersCS7", 1000, true);
	SetTimer("UsersCS6", 1000, true);
	SetTimer("UsersCS5", 1000, true);
	SetTimer("UsersCS4", 1000, true);
	SetTimer("UsersCS3", 1000, true);
	SetTimer("UsersCS2", 1000, true);
	SetTimer("UsersCS1", 1000, true);
	SetTimer("UsersMinigun", 1000, true);
	SetTimer("UsersMinigun2", 1000, true);
	SetTimer("UsersRocket", 1000, true);
	SetTimer("UsersRocket2", 1000, true);
	SetTimer("UsersMDM", 1000, true);
	SetTimer("UsersZonaWW", 1000, true);
	SetTimer("UsersZonaRW", 1000, true);
	SetTimer("UsersZombieAttack", 1000, true);
	return 1;
}
