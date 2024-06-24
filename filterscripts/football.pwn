/*
		~ CREDITS ~

	Created by: Farkias
	Edited: Micko
	Bug fix: Micko
	Translate: Micko (not the best translate but.. xD )

	This FS is very nice and i hope it will make your game better :)
	I hope that you won't remove this text.
	To make this FS playable just put it in filterscripts folder and in server.cfg
	in the "filterscripts" line write football.

	If you want to put this FS directly in your GM also be nice and leave the credits

	Now go and score some goals :)

	PS: If you find any bug just PM me on http://forum.sa-mp.com/
	My Account: http://forum.sa-mp.com/member.php?u=275247
*/

#include <a_samp>
#include <streamer>
#include <sscanf2>
#include <foreach>
#include <zcmd>

// -- Football --
new ball;
new goals1;
new goals2;
new gol;
new shooter;
new gameTimer;
new footballTeam[MAX_PLAYERS];
new bool:footbalOn;

new	animation[200];

new isAnimating[MAX_PLAYERS];
new	gPlayerUsingLoopingAnim[MAX_PLAYERS];

#define LIGHT_BLUE    	"{00A2D7}"
#define COLOR_YELLOW    0xDABB3EAA


#define ERROR(%0,%1) \
 SendClientMessage(%0, 0xF81414FF, "{F81414}(ERROR) | {FFFFFF} "%1)
#define USAGE(%0,%1) \
 SendClientMessage(%0, 0xC0C0C0FF, "{C0C0C0}(USAGE) | {FFFFFF} "%1)

public OnFilterScriptInit()
{
    //========================= [football stadium] =============================
	new white[48], grass[10], pillar[8];
	white[0] = CreateDynamicObject(9339, 1384.6, 2125.3, 9.33, 0, 0, 0);
	white[1] = CreateDynamicObject(9339, 1384.6, 2151.3999, 9.33, 0, 0, 0);
	white[2] = CreateDynamicObject(9339, 1384.6, 2174.3999, 9.33, 0, 0, 0);
	white[3] = CreateDynamicObject(9339, 1311.4, 2125.3, 9.33, 0, 0, 0);
	white[4] = CreateDynamicObject(9339, 1311.4, 2148.3999, 9.33, 0, 0, 0);
	white[5] = CreateDynamicObject(9339, 1311.4, 2174.3999, 9.33, 0, 0, 0);
	white[6] = CreateDynamicObject(9339, 1371.7002, 2187.2998, 9.3299999, 0, 0, 90);
	white[7] = CreateDynamicObject(9339, 1350.4, 2187.3, 9.33, 0, 0, 90);
	white[8] = CreateDynamicObject(9339, 1324.3, 2187.3, 9.33, 0, 0, 90);
	white[9] = CreateDynamicObject(9339, 1371.7, 2112.3, 9.33, 0, 0, 90);
	white[10] = CreateDynamicObject(9339, 1345.7, 2112.3, 9.33, 0, 0, 90);
	white[11] = CreateDynamicObject(9339, 1324.4, 2112.3, 9.33, 0, 0, 90);
	white[12] = CreateDynamicObject(9339, 1324.5, 2149.6001, 9.33, 0, 0, 90);
	white[13] = CreateDynamicObject(9339, 1350.6, 2149.6001, 9.33, 0, 0, 90);
	white[14] = CreateDynamicObject(9339, 1371.6, 2149.6001, 9.33, 0, 0, 90);
	white[15] = CreateDynamicObject(16501, 1338.2998, 2115.7998, 7.8260002, 0, 0, 0);
	white[16] = CreateDynamicObject(16501, 1358, 2115.7998, 7.8249998, 0, 0, 0);
	white[17] = CreateDynamicObject(16501, 1341.7998, 2119.25, 7.8260002, 0, 0, 90);
	white[18] = CreateDynamicObject(16501, 1348.9004, 2119.25, 7.8260002, 0, 0, 90);
	white[19] = CreateDynamicObject(16501, 1354.5, 2119.25, 7.8260002, 0, 0, 90);
	white[20] = CreateDynamicObject(16501, 1369.2998, 2115.7998, 7.8249998, 0, 0, 0);
	white[21] = CreateDynamicObject(16501, 1369.2998, 2122.75, 7.8249998, 0, 0, 0);
	white[22] = CreateDynamicObject(16501, 1365.7002, 2126.2002, 7.8249998, 0, 0, 90);
	white[23] = CreateDynamicObject(16501, 1358.5996, 2126.2002, 7.8249998, 0, 0, 90);
	white[24] = CreateDynamicObject(16501, 1351.5, 2126.2002, 7.8249998, 0, 0, 90);
	white[25] = CreateDynamicObject(16501, 1344.5, 2126.2002, 7.8260002, 0, 0, 90);
	white[26] = CreateDynamicObject(16501, 1337.4004, 2126.2002, 7.8260002, 0, 0, 90);
	white[27] = CreateDynamicObject(16501, 1330.4004, 2126.2002, 7.8260002, 0, 0, 90);
	white[28] = CreateDynamicObject(16501, 1326.9404, 2122.7002, 7.8260002, 0, 0, 0);
	white[29] = CreateDynamicObject(16501, 1326.9404, 2115.7998, 7.8260002, 0, 0, 0);
	white[30] = CreateDynamicObject(16501, 1338.3, 2183.8, 7.8260002, 0, 0, 0);
	white[31] = CreateDynamicObject(16501, 1358, 2183.8, 7.8260002, 0, 0, 0);
	white[32] = CreateDynamicObject(16501, 1354.5, 2180.3501, 7.8260002, 0, 0, 90);
	white[33] = CreateDynamicObject(16501, 1347.4, 2180.3501, 7.8260002, 0, 0, 90);
	white[34] = CreateDynamicObject(16501, 1341.8, 2180.3501, 7.8260002, 0, 0, 90);
	white[35] = CreateDynamicObject(16501, 1326.9399, 2183.8999, 7.8260002, 0, 0, 0);
	white[36] = CreateDynamicObject(16501, 1326.9399, 2176.8999, 7.8260002, 0, 0, 0);
	white[37] = CreateDynamicObject(16501, 1330.4, 2173.3999, 7.8260002, 0, 0, 90);
	white[38] = CreateDynamicObject(16501, 1337.5, 2173.3999, 7.8260002, 0, 0, 90);
	white[39] = CreateDynamicObject(16501, 1344.6, 2173.3999, 7.8260002, 0, 0, 90);
	white[40] = CreateDynamicObject(16501, 1351.7, 2173.3999, 7.8260002, 0, 0, 90);
	white[41] = CreateDynamicObject(16501, 1358.8, 2173.3999, 7.8260002, 0, 0, 90);
	white[42] = CreateDynamicObject(16501, 1369.3, 2183.8, 7.8260002, 0, 0, 0);
	white[43] = CreateDynamicObject(16501, 1369.3, 2176.8701, 7.8260002, 0, 0, 0);
	white[44] = CreateDynamicObject(16501, 1365.8, 2173.3999, 7.8260002, 0, 0, 90);
	white[45] = CreateDynamicObject(18808, 1348.5, 2149.7, -14.96, 0, 0, 0);
	white[46] = CreateDynamicObject(18808, 1348.1, 2124.6001, -15, 1, 0, 0);
	white[47] = CreateDynamicObject(18808, 1349.1, 2175, -15, 359, 0, 0);
	for(new i = 0; i < sizeof(white); i++) { SetDynamicObjectMaterial(white[i], 0, 3924, "rc_warhoose", "white", 0xFFFFFFFF); }
	SetDynamicObjectMaterial(white[46], 1, 3924, "rc_warhoose", "white", 0xFFFFFFFF);
	SetDynamicObjectMaterial(white[47], 1, 3924, "rc_warhoose", "white", 0xFFFFFFFF);
	grass[0] = CreateDynamicObject(4708, 1373.4, 2120.8999, -7.8629999, 0, 0, 0);
	grass[1] = CreateDynamicObject(4708, 1322.3, 2126.2998, -7.8639998, 0, 0, 0);
	grass[2] = CreateDynamicObject(4708, 1322.3, 2120.8999, -7.8610001, 0, 0, 0);
	grass[3] = CreateDynamicObject(4708, 1373.4, 2149.7, -7.8629999, 0, 0, 0);
	grass[4] = CreateDynamicObject(4708, 1339, 2148.3999, -7.8639998, 0, 0, 0);
	grass[5] = CreateDynamicObject(4708, 1322.3, 2149.7, -7.8610001, 0, 0, 0);
	grass[6] = CreateDynamicObject(4708, 1339, 2177.2, -7.8639998, 0, 0, 0);
	grass[7] = CreateDynamicObject(4708, 1373.4, 2177.2, -7.8610001, 0, 0, 0);
	grass[8] = CreateDynamicObject(4708, 1339, 2120.8999, -7.862, 0, 0, 0);
	grass[9] = CreateDynamicObject(4708, 1322.3, 2177.2, -7.862, 0, 0, 0);
	for(new i = 0; i < sizeof(grass); i++)
	{
		SetDynamicObjectMaterial(grass[i], 5, 10931, "traingen_sfse", "desgreengrass", 0xFFFFFFFF);
		SetDynamicObjectMaterial(grass[i], 9, 10931, "traingen_sfse", "desgreengrass", 0xFFFFFFFF);
	}
	pillar[0] = CreateDynamicObject(1251, 1350.1, 2187.3999, 13.302, 0, 0, 90);
	pillar[1] = CreateDynamicObject(1251, 1347.4, 2187.3999, 13.3, 0, 0, 90);
	pillar[2] = CreateDynamicObject(1251, 1344, 2187.3999, 9.8999996, 90, 0, 0);
	pillar[3] = CreateDynamicObject(1251, 1353.5, 2187.3, 9.8999996, 90, 0, 0);
	pillar[4] = CreateDynamicObject(1251, 1344, 2112.3, 9.8999996, 90, 0, 0);
	pillar[5] = CreateDynamicObject(1251, 1353.7, 2112.3999, 9.8999996, 90, 0, 0);
	pillar[6] = CreateDynamicObject(1251, 1347.4, 2112.3, 13.302, 0, 0, 90);
	pillar[7] = CreateDynamicObject(1251, 1350.3, 2112.3101, 13.302, 0, 0, 90);
 	for(new i = 0; i < sizeof(pillar); i++) { SetDynamicObjectMaterial(pillar[i], 0, 3924, "rc_warhoose", "white", 0xFFFFFFFF); }
	CreateDynamicObject(2945, 1344, 2189.5, 11.4, 0, 0, 90);
	CreateDynamicObject(2945, 1353.5, 2189.5, 11.4, 0, 0, 90);
	CreateDynamicObject(2945, 1351.8, 2191.1001, 11.4, 0, 0, 0);
	CreateDynamicObject(2945, 1349.6, 2191.1001, 11.4, 0, 0, 0);
	CreateDynamicObject(2945, 1346.0996, 2191.1006, 11.4, 0, 0, 0);
	CreateDynamicObject(2945, 1345.3, 2189.5, 13.3, 90, 0, 90);
	CreateDynamicObject(2945, 1348.6, 2189.5, 13.3, 90, 0, 90);
	CreateDynamicObject(2945, 1351.5996, 2189.5, 13.3, 90, 0, 90);
	CreateDynamicObject(2945, 1353.7, 2110.7, 11.4, 0, 0, 90);
	CreateDynamicObject(2945, 1344, 2110.7, 11.4, 0, 0, 90);
	CreateDynamicObject(2945, 1352, 2108.6001, 11.4, 0, 0, 0);
	CreateDynamicObject(2945, 1349.8, 2108.6001, 11.4, 0, 0, 0);
	CreateDynamicObject(2945, 1346.1, 2108.6001, 11.4, 0, 0, 0);
	CreateDynamicObject(2945, 1351.8, 2110.7, 13.3, 90, 0, 90);
	CreateDynamicObject(2945, 1345.3, 2110.7, 13.3, 90, 0, 90);
	CreateDynamicObject(2945, 1348.54, 2110.7, 13.3, 90, 0, 90);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
    footballTeam[playerid] = 0;
    isAnimating[playerid] = 0;
    gPlayerUsingLoopingAnim[playerid] = 0;
    return 1;
}

public OnPlayerSpawn(playerid)
{
    isAnimating[playerid] = 0;
    if(gPlayerUsingLoopingAnim[playerid])
	{
		gPlayerUsingLoopingAnim[playerid] = 0;
	}
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    isAnimating[playerid] = 0;
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(footballTeam[playerid] == 2 || footballTeam[playerid] == 1)
	{
		new Float:x, Float:y, Float:z;
		GetDynamicObjectPos(ball, x, y, z);
	 	if(newkeys & KEY_FIRE)
	 	{
	 		if(IsPlayerInRangeOfPoint(playerid, 2.5, x, y, z))
			{
			 	GetPlayerPos(playerid, x, y, z);
			 	GetXYInFrontOfPlayer(playerid, x, y, 8.0);
			 	MoveDynamicObject(ball,x,y,10.2,8.0,0,0,0);
				shooter = playerid;
			 	LoopingAnim(playerid,"FIGHT_D","FightD_1",4.1,0,1,1,0,0);
			 	SetTimerEx("FootballAnimation", 1000, false, "d", playerid);
			}
		}
	}
	return 1;
}

forward FootballAnimation(playerid);
public FootballAnimation(playerid)
{
    if(isAnimating[playerid] == 1) return ERROR(playerid, "You can't stop animation!");
	StopLoopingAnim(playerid);
	return 1;
}

forward GoalCount();
public GoalCount()
{
 	foreach(Player, i)
    {
    	if(footballTeam[i] == 1 || footballTeam[i] == 2)
     	{
      		SetPlayerHealth(i, 99.0);
		}
	}
    if(IsObjectInTheArea(ball,1343.9974,2108.0566,1353.3119,2112.6431))
	{
	    new name[MAX_PLAYER_NAME];
		GetPlayerName(shooter, name, MAX_PLAYER_NAME);
	    new str[128];
	    goals1++;
		if(footballTeam[shooter] == 1)
		{
			format(str, 128, "Football | AUTOGOL! |{FFFFFF} Player %s (team 1) scored an autogoal! |{FF0000} Team 1: %d, Team 2: %d", name, goals2, goals1);
			FootballPoruka(0xF81414FF, str);
		}
		else
		{
			format(str, 128, "Football | GOOOOOL! |{FFFFFF} Player %s (tim 2) scored a goal! |{FFFF00} Team 1: %d, Team 2: %d", name, goals2, goals1);
			FootballPoruka(0xFFFF33FF, str);
		}
  		foreach(Player, i)
	    {
     		if(footballTeam[i] == 1)
			{
				SetPlayerPos(i, 1348.9005,2115.8665,11.0364);
				SetPlayerInterior(i, 0);
			}
     		else if(footballTeam[i] == 2)
			{
				SetPlayerPos(i, 1348.7242,2184.3674,11.0344);
				SetPlayerFacingAngle(i, 180);
				SetPlayerInterior(i, 0);
			}
		}
	    DestroyDynamicObject(ball);
		ball = CreateDynamicObject(2114, 1348.4065,2149.4966,10.2, 0, 0, 0);
		SetDynamicObjectMaterial(ball, 0, 5033, "union_las", "ws_carparkwall2", 0);
	}
	else if(IsObjectInTheArea(ball,1343.9312,2186.9382,1353.5435,2191.6492))
	{
	    new name[MAX_PLAYER_NAME];
		GetPlayerName(shooter, name, MAX_PLAYER_NAME);
	    new str[128];
	    goals2++;
		if(footballTeam[shooter] == 2)
		{
			format(str, 128, "Football | AUTOGOAL! |{FFFFFF} Player %s (tim 2) scored and autogoal! |{FF0000} Team 1: %d, Team 2: %d", name, goals2, goals1);
			FootballPoruka(0xF81414FF, str);
		}
		else
		{
			format(str, 128, "Football | GOOOOAL! |{FFFFFF} Player %s (tim 1) scored a goal! |{FFFF00} Team 1: %d, Team 2: %d", name, goals2, goals1);
			FootballPoruka(0xFFFF33FF, str);
		}
		foreach(Player, i)
	    {
     		if(footballTeam[i] == 1)
			{
				SetPlayerPos(i, 1348.9005,2115.8665,11.0364);
				SetPlayerInterior(i, 0);
			}
     		else if(footballTeam[i] == 2)
			{
				SetPlayerPos(i, 1348.7242,2184.3674,11.0344);
				SetPlayerFacingAngle(i, 180);
				SetPlayerInterior(i, 0);
			}
		}
	    DestroyDynamicObject(ball);
		ball = CreateDynamicObject(2114, 1348.4065,2149.4966,10.2, 0, 0, 0);
		SetDynamicObjectMaterial(ball, 0, 5033, "union_las", "ws_carparkwall2", 0);
	}
	else if(!IsObjectInTheArea(ball,1311.3945,2112.2881,1384.5884,2187.2483))
	{
		DestroyDynamicObject(ball);
		ball = CreateDynamicObject(2114, 1348.4065,2149.4966,10.2, 0, 0, 0);
		SetDynamicObjectMaterial(ball, 0, 5033, "union_las", "ws_carparkwall2", 0);
	}
	return 1;
}

forward FootbalTime();
public FootbalTime()
{
    new str[128];
    foreach(Player, i)
    {
	    if(footballTeam[i] == 1)
	    {
		    format(str, 128, "| End of the game |{FFFFFF} You: %d | Them: %d", goals2, goals1);
		    SendClientMessage(i, 0x00A2D7FF, str);
		    footballTeam[i] = 0;
		    SpawnPlayer(i);
		}
		else if(footballTeam[i] == 2)
		{
			format(str, 128, "| End of the game |{FFFFFF} You: %d | Them: %d", goals1, goals2);
			SendClientMessage(i, 0x00A2D7FF, str);
			footballTeam[i] = 0;
			SpawnPlayer(i);
		}
	}
	DestroyDynamicObject(ball);
	footbalOn = false;
	goals1 = 0;
	goals2 = 0;
	KillTimer(gol);
	return 1;
}
////////////////////////////////////////////////////////////////////////////
CMD:footballcall(playerid,params[])
{
	if(IsPlayerAdmin(playerid))
	{
		new str[128], id, team;
		if(sscanf(params,"ui", id, team)) return USAGE(playerid, "/footballcall [ ID/name ] [Team 1 - 2, 0 - kick)]");
		if(!IsPlayerConnected(id)) return ERROR(playerid,"That player is offline!");
		if(team > 2 || team < 0) return ERROR(playerid,"Team can only be 1 or 2. 0 - kick from game!");
		new name[MAX_PLAYER_NAME], player[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
		GetPlayerName(id, player, sizeof(player));
		format(str,128,""LIGHT_BLUE"Football | You have been called on game by  {ffffff}%s. | team %d", name, team);
		SendClientMessage(id, -1, str);
		format(str,128,""LIGHT_BLUE"Football | You've called {ffffff}%s"LIGHT_BLUE" on football game. | Team {ffffff}%d", player, team);
		SendClientMessage(playerid, -1, str);
		footballTeam[id] = team;
		ResetPlayerWeapons(id);
		if(footbalOn == true)
		{
		    if(footballTeam[id] == 1)
			{
				SetPlayerPos(id, 1348.9005,2115.8665,11.0364);
				SetPlayerInterior(id, 0);
				SetPlayerSkin(id, 170);
			}
	        else if(footballTeam[id] == 2)
			{
				SetPlayerPos(id, 1348.7242,2184.3674,11.0344);
				SetPlayerFacingAngle(id, 85);
				SetPlayerInterior(id, 0);
				SetPlayerSkin(id, 250);
			}
		}
	}
	else return ERROR(playerid,"You are not authorised to use this command!");
	return 1;
}

CMD:footballstart(playerid,params[])
{
	if(footbalOn == true) return ERROR(playerid,"Football game is not running!");
    if(IsPlayerAdmin(playerid))
    {
		new TimeF;
		if(sscanf(params,"i",TimeF)) return USAGE(playerid, "/footballstart [TIME(minutes)]");
		else if(TimeF < 1 || TimeF > 20) return ERROR(playerid,"Time has to be between 1 and 20!");
		gameTimer = SetTimer("FootbalTime", TimeF*59999, false);
		gol = SetTimer("GoalCount", 499, true);
  		foreach(Player, i)
	    {
     		if(footballTeam[i] == 1)
			{
				SetPlayerPos(i, 1348.9005,2115.8665,11.0364);
				SetPlayerInterior(i, 0);
				SetPlayerSkin(i, 170);
			}
     		else if(footballTeam[i] == 2)
			{
				SetPlayerPos(i, 1348.7242,2184.3674,11.0344);
				SetPlayerFacingAngle(i, 180);
				SetPlayerInterior(i, 0);
				SetPlayerSkin(i, 250);
			}
		}
		new str[128], name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, MAX_PLAYER_NAME);
		new string[90];
		format(string, sizeof(string), "[WARNING]: Admin %s has started football game for %d min", GetName(playerid),TimeF);
		AdminPregled(COLOR_YELLOW, string);
		format(str,128,""LIGHT_BLUE"Football |{ffffff} Football game has started! | "LIGHT_BLUE" Admin: {ffffff}%s"LIGHT_BLUE" | Time: {ffffff}%d min", name, TimeF);
		FootballPoruka(-1, str);
		ball = CreateDynamicObject(2114, 1348.4065,2149.4966,10.2, 0, 0, 0);
		SetDynamicObjectMaterial(ball, 0, 5033, "union_las", "ws_carparkwall2", 0);
		footbalOn = true;
 	}
	else return ERROR(playerid,"You are not authorised to use this command!");
	return 1;
}

CMD:footballstop(playerid,params[])
{
    if(footbalOn == false) return ERROR(playerid,"Football game is not running!");
    if(IsPlayerAdmin(playerid))
    {
	    new name[MAX_PLAYER_NAME];
		GetPlayerName(playerid, name, sizeof(name));
		new str[80];
		format(str, 80, ""LIGHT_BLUE"Football | Admin {ffffff}%s"LIGHT_BLUE" has stopped the game!", name);
		FootballPoruka(-1, str);
		KillTimer(gameTimer);
		FootbalTime();
	}
	else return ERROR(playerid,"You are not authorised to use this command!");
	return 1;
}
///////////////////////////////////////////////////////////
stock FootballPoruka(boja, string[])
{
 	foreach(Player, i)
	{
	    if(footballTeam[i] == 1 || footballTeam[i] == 2)
	    {
	        SendClientMessage(i, boja, string);
		}
	}
	return 1;
}

stock IsObjectInTheArea(objectid, Float:minx, Float:miny, Float:maxx, Float:maxy)
{
	new Float:x, Float:y, Float:z;
	GetDynamicObjectPos(objectid, x, y, z);
	if(x >= minx && x <= maxx && y >= miny && y <= maxy) return true;
	else return false;
}

stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, a);
	GetPlayerFacingAngle(playerid, a);
	if (GetPlayerVehicleID(playerid))
	{
		GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
	}
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}

stock GetName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}

stock AdminPregled(color, string[])
{
	foreach(Player, i)
	{
		if(IsPlayerAdmin(i))
		{
			SendClientMessage(i, color, string);
		}
	}
	return 1;
}

LoopingAnim(playerid,animlib[],animname[], Float:Speed, looping, lockx, locky, lockz, lp)
{
    gPlayerUsingLoopingAnim[playerid] = 1;
    ApplyAnimation(playerid, animlib, animname, Speed, looping, lockx, locky, lockz, lp);
    animation[playerid]++;
}

StopLoopingAnim(playerid)
{
	gPlayerUsingLoopingAnim[playerid] = 0;
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0);
}
