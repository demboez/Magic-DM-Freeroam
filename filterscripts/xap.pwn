/********************************************
 *	XAP	v1.2		Created by SharkyKH		*
 *	Based on Xtreme's Admin Script v2.2#1	*
 ********************************************/
// Main
#include <a_samp2>
#pragma dynamic 20000
// Main defines
#define		APS			0 // APS: Admin Protection System.
#define		AL			1 // AL: Auto Login | Automatically log in the admin to his admin account using Last-known-IP check.
#define		RL			0 // RL: Register/Login ajustments.
#define		AM			1 // AM: Auto Mute.

// Warning if APS & AL are both set to ON.
#if APS && AL
	#error You can not use both APS and Auto-Login at the same time!
#endif

// Colors
#define		blue		0x005EECAA
#define		cblue		0x6495EDAA
#define		red			0xFF0000AA
#define		orange		0xFF9900AA
#define		lblue		0x00C8C8AA
#define		yellow		0xFFFF00AA
#define		green		0x16EB43FF
#define		green2		0x008D00AA
#define		green3		0x006400AA
#define		lgreen		0x2CCC99FF
#define		darkred		0x800000FF
#define		white		0xFFFFFFAA
#define		purple		0x8B00A0FF
#define		grey		0xC0C0C0AA
#define		ppmsc		0xA448FFFF
#define		invisible	0xFFFFFF00

#define COMMANDS_COUNT 115
#define COMMANDS_PER_LEVEL_COUNT 40
enum CL_DATA { CL_CMD[16], CL_LVL };
new CommandsList[COMMANDS_COUNT][CL_DATA] =
{
	// Time
	{"morning",3},{"noon",3},{"evening",3},{"midnight",3},{"settime",2},{"satime",3},
	// Kick/Ban/Unban
	{"kick",2},{"kickall",9},
	{"ban",2},{"tempban",2},
	{"unban",3},{"unbanip",3},{"banned",2},{"bannedip",2},{"untb",3},{"untbip",3},
	// Goto/Get
	{"goto",2},{"get",2},{"ptp",4},
	// Mute/Jail/Freeze/Explode/Slap/Kill
	{"mute",2},{"unmute",2},{"muted",2},
	{"jail",2},{"unjail",2},{"jailed",2},
	{"freeze",3},{"unfreeze",3},{"fall",6},{"unfall",6},
	{"slap",2},{"akill",4},{"explode",4},
	// HealthArmor/Vehicle
    {"full",4},{"sethp",4},{"setar",4},{"healall",8},{"armorall",8},{"god",5},
	{"flip",1},{"carhealth",2},{"vr",2},{"vrall",7},{"carcolor",1},{"eject",4},{"ejectall",7},{"givecar",7},
	{"gn",5},{"xlock",4},{"xunlock",4},{"xunlockall",5},
	// Money
	{"setmoney",7},{"givemoney",4},{"remmoney",7},{"resetmoney",7},{"samoney",9},{"gamoney",9},{"remamoney",9},{"ramoney",9},
	// Weapon/Ammo
	{"giveweapon",4},{"gaweapon",8},{"raweapons",9},{"disarm",4},{"getslot",2},{"setammo",4},
	// Skin
	{"setskin",4},{"skinall",9},
	// Name/Account/PlayerInfo/Server
	{"setname",10},{"saccname",10},{"xchangepass",2},
	{"ip",3},{"ping",3},
	{"uconfig",10},{"setsm",10},{"gmx",10},{"sgravity",10},{"setping",10},{"cfgvar",10},{"xvar",10},
	// World/Scores/Wanted
	{"setworld",7},{"saworld",10},{"outsideall",8},
	{"setscore",8},{"rscores",8},
/*	{"setwanted",5},*/{"sawanted",7},{"xcmds",5},
	// Announcements/ChatControl
	{"ann",2},{"say",2},{"saa",4},{"snatime",10},{"snatext",8},{"sna",5},
	{"c",2},{"ca",8},{"chat",6},{"ac",8},{"lpt",6},
	// Commands/PMs
	{"pcmds",2},{"acmds",8},{"ppms",2},
	// Admin/CD/Spec/AdminVehicle/Other
	{"setxlevel",10},{"tmplevel",10},{"rc",10},{"aafk",1},{"inv",2},
	{"cd",2},{"kcd",4},
	{"xspec",1},
	{"spawnc",7},{"spawnd",7},{"spawncall",7},
	{"plusz",1},{"force",5},
	// Teleport
	{"ct",6},{"ctd",6},{"ctl",3}
};

// Main includes
#include "xap\Core\XtremeAdmin.inc"
#include "xap\Core\XAP.inc"

forward OnPlayerPrivmsg(playerid, receiverid, text[]);
forward PingKick();
forward ServerNewsAnnouncement();
forward CountDown(Count, Freeze);
forward OpenChats();
forward AutoOpenChat(chat, bool:reload);
forward AdminVehicleAction(playerid,vehicleid,actionid);
forward ResetReportedID(playerid);

enum JailPositionsData { Float:j_x, Float:j_y, Float:j_z, j_int };
new Float:JailPositions[6][JailPositionsData] = {
	{197.3192,175.1013,1003.0234,3}, // LV 1
	{193.0444,174.7908,1003.0234,3}, // LV 2
	{198.6733,162.1703,1003.0300,3}, // LV 3
	{264.3686,78.6028,1001.0391,6}, // SF 1
	{264.3686,77.6028,1001.0391,6}, // SF 2
	{264.3686,76.6028,1001.0391,6}  // SF 3
};

//==============================================================================
public OnFilterScriptInit()
{
	printf("\t[XAP] XAP v1.2 - by SharkyKH");
	printf("\t[XAP] Based on Xtreme's Admin Script v2.2r1");
	// Loading starts...
	xResetServerVars();
	xResetPlayersData();
	
	new Result = CheckFolderConfiguration();
	if (Result)
	{
		xVars[LoadFailed] = true;
		printf("\t[XAP] The system can't load, review the errors above.");
		printf("\t[XAP] Unsuccessful load.\n");
		return 0;
	}
	
	CreateFileConfiguration();
	
	new File[64];
	// Check if all configuration files are present.
	File = "/xap/Configuration/Announcements.ini";
	if(!dini_Exists(File))
	{
		dini_Create(File);
		dini_BoolSet(File,"System",true);
		dini_IntSet(File,"Time",15);
		dini_IntSet(File,"MaxTexts",5);
		for (new i=1; i<=dini_Int(File, "MaxTexts"); ++i)
		{
			new fstr[24]; format(fstr,24,"Text%d",i); dini_Set(File,fstr,"None");
		}
	}
	if(dini_Int(File, "MaxTexts") > 8) dini_IntSet(File,"MaxTexts",8);
	
	File = "/xap/Configuration/Configuration.ini";
	if(!dini_Exists(File))
	{
		dini_Create(File);
		dini_Set(File,"ServerMessage","None");
	}
	// Create the variables to be stored in each user's file.
	CreateLevelConfig(
		"IP","Registered","Level","Password","Commands","ACommands","PPMS"
	);
	// Create Level Config:
	/*File = "/xap/Configuration/Commands.ini";
	if (!dini_Exists(File)) dini_Create(File);
	for (new c = 0; c < COMMANDS_COUNT; ++c) AddCommandToCommandConfig(CommandsList[c][CL_CMD], CommandsList[c][CL_LVL]);*/
	// Create forbidden words list:
	#if AM
	//CreateForbiddenWords();
	#endif
	UpdateConfigurationVariables();
	SetTimer("PingKick",Config[PingSecondUpdate]*1000,true);
	SetTimer("Jail_Time_Ticker", 1000, true);
	SetTimer("Mute_Time_Ticker", 1000, true);
	CheckTempBans();
	SetTimer("CheckTempBans", 600000, true);
	File = "/xap/Configuration/Announcements.ini";
	if (dini_Int(File,"Time")) xVars[TimerNews] = SetTimer("ServerNewsAnnouncement",(dini_Int(File,"Time")*60000),1);
	// GiveCar Menu
	xVars[GiveCar] = CreateMenu("~b~Givecar ~w~Administration", 1, 125, 150, 300);
	if (IsValidMenu(xVars[GiveCar]))
	{
		SetMenuColumnHeader(xVars[GiveCar], 0, "Select a car component to add:");
		AddMenuItem(xVars[GiveCar], 0, "Nitrous x10");
		AddMenuItem(xVars[GiveCar], 0, "Hydraulics");
		AddMenuItem(xVars[GiveCar], 0, "Offroad Wheel");
		AddMenuItem(xVars[GiveCar], 0, "Wire Wheels");
	}
	xVars[Reload] = true;
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i))
		{
			OnPlayerConnect(i);
			if (Variables[i][Level])
			{
				if (!Variables[i][LoggedIn])
					SendClientMessage(i, orange, "The administration filterscript has been restarted, please re-login.");
			}
		}
	}
	xVars[Reload] = false;
	
	CreateForbiddenWords("הומו","קוקסינל","בן זונה","ה1מ1","הומ1","ה1מו","ק1קסינל","מוצצת","מזדינת","מזדיינת","מזדיין","מזדין");
	printf("\t[XAP] Loaded successfully.\n");
	return 1;
}
//==============================================================================
public OnFilterScriptExit()
{
	if (!xVars[LoadFailed])
	{
		if (IsValidMenu(xVars[GiveCar])) DestroyMenu(xVars[GiveCar]);
		if (xVars[TimerChat] != -1) AutoOpenChat(0, true);
		if (xVars[TimerAChat] != -1) AutoOpenChat(1, true);
		if (xVars[TimerNews] != -1) KillTimer(xVars[TimerNews]);
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				#if APS
				if (APS_Timer[i] != -1) { KillTimer(APS_Timer[i]); APS_Timer[i] = -1; }
				#endif
				#if AM
				xPlayer[i][ChatWarnings] = 0;
				#endif
				if (Variables[i][Jailed]) JailUnload(i);
				if (Variables[i][Muted]) MuteUnload(i);
				if (xPlayer[i][TimerReport] != -1) { KillTimer(xPlayer[i][TimerReport]); xPlayer[i][TimerReport] = -1; }
				if (Spec[i][Spectating])
				{
					TogglePlayerSpectating(i,false);
					Spec[i][Spectating] = false;
					Spec[i][SpectateID] = INVALID_PLAYER_ID;
					GameTextForPlayer(i,"~y~~h~~h~~h~Spectator Mode: ~r~OFF~n~~b~xAp ~g~has been unloaded",5000,4);
					SetTimerEx("RestorePlayerPosition",250,0,"i",i);
				}
				new name[24]; GetPlayerName(i,name,24);
				if (!xVars[Reload]) if (xPlayer[i][AdminVehicle]) dini_IntSet("/xap/DataSave/AVehicle.ini",name,xPlayer[i][AdminVehicle]);
				if (xPlayer[i][TMPLevel]) dini_IntSet("/xap/DataSave/TMPLevel.ini",name,Variables[i][Level]);
				if (IsPlayerXAdmin(i))
				{
					new fileline[128];
					format(fileline, 128, "%s [%s - %s] (XAP reloaded)\r\n", name, xPlayer[i][LoginTime], TND("logins"));
					WriteToLog("logins", fileline);
				}
			}
		}
		if(dini_Exists("/xap/CT.ini")) dini_Remove("/xap/CT.ini"); dini_Create("/xap/CT.ini");
		OpenChats();
		printf("\t[XAP] Unloaded successfully.\n");
	}
	else printf("\t[XAP] Unloaded unsuccessfully.\n");
	return 1;
}
//==============================================================================
public OnGameModeInit()
{
	if(xVars[Reload])
	{
		printf("\t[XAP] Recreating menus...");
		xVars[GiveCar] = CreateMenu("~b~Givecar ~w~Administration", 1, 125, 150, 300);
		if (IsValidMenu(xVars[GiveCar]))
		{
			SetMenuColumnHeader(xVars[GiveCar], 0, "Select a car component to add:");
			AddMenuItem(xVars[GiveCar], 0, "Nitrous x10");
			AddMenuItem(xVars[GiveCar], 0, "Hydraulics");
			AddMenuItem(xVars[GiveCar], 0, "Offroad Wheel");
			AddMenuItem(xVars[GiveCar], 0, "Wire Wheels");
			printf("\t[XAP] >> GiveCar");
		}
		printf("\t[XAP] Done.");
	}
	xVars[Reload] = false;
	return 1;
}
public OnGameModeExit()
{
	xVars[Reload] = true;
	DestroyMenu(xVars[GiveCar]);
	return 1;
}
//==============================================================================
public OnPlayerConnect(playerid)
{
	new string[128],PlayerName[24],file[64],UserIP[30]; file = GetPlayerFile(playerid);
	GetPlayerName(playerid,PlayerName,24); GetPlayerIp(playerid, UserIP, 30);
	new bool:IsBanned = (BanCheck(PlayerName,1)||BanCheck(UserIP,2)||TempBanCheck(PlayerName,1)||TempBanCheck(UserIP,2))?true:false;
 	for (new i = 0; i < 100; ++i)
	{
		if (strfind(PlayerName,ForbidNames[i],true)!=-1 && Config[ForbidData])
		{
			switch (Config[ForbidData]) { case 1: KickPlayer(playerid, -1, "Forbidden Name"); case 2: BanPlayer(playerid, -1, "Forbidden Name"); }
			return 1;
		}
	}
	if (Config[DisplayServerMessage] && !xVars[Reload] && !IsBanned)
	{
		if (strcmp(dini_Get("/xap/Configuration/Configuration.ini","ServerMessage"),"None",true))
		{
			format(string,128,"Server Message: %s",dini_Get("/xap/Configuration/Configuration.ini","ServerMessage"));
			SendClientMessage(playerid,green,string);
		}
	}
	if (!IsBanned)
	{
		if (Variables[playerid][Level] && !dini_Exists(file)) CreateUserConfigFile(playerid);
		if (dini_Isset(file,"Registered")) Variables[playerid][Registered] = GetPlayerFileVar(playerid,"Registered"); else Variables[playerid][Registered] = false;
		if (dini_Isset(file,"Level")) Variables[playerid][Level] = GetPlayerFileVar(playerid,"Level"); else Variables[playerid][Level] = 0;
		if (dini_Isset(file,"Commands")) Variables[playerid][Commands] = GetPlayerFileVar(playerid,"Commands"); else Variables[playerid][Commands] = false;
		if (dini_Isset(file,"ACommands")) Variables[playerid][ACommands] = GetPlayerFileVar(playerid,"ACommands"); else Variables[playerid][ACommands] = false;
		if (dini_Isset(file,"PPMS")) Variables[playerid][PPMS] = GetPlayerFileVar(playerid,"PPMS"); else Variables[playerid][PPMS] = false;
		
		Variables[playerid][Jailed] = false;
		Variables[playerid][Muted] = false;
		Variables[playerid][MutedWarnings] = Config[MutedWarnings];
		ClearString(32, xPlayer[playerid][JailInfo][jReason]);
		xPlayer[playerid][JailInfo][jTime] = 0;
		xPlayer[playerid][JailInfo][jTimeLeft] = 0;
		ClearString(32, xPlayer[playerid][MuteInfo][mReason]);
		xPlayer[playerid][MuteInfo][mTime] = 0;
		xPlayer[playerid][MuteInfo][mTimeLeft] = 0;

		if (Variables[playerid][Level] > Config[MaxLevel])
		{
			Variables[playerid][Level] = Config[MaxLevel];
			SetUserInt(playerid,"Level",Config[MaxLevel]);
		}
	
		new DSFile[64];
		DSFile = "/xap/DataSave/AVehicle.ini";
		if (dini_Isset(DSFile,PlayerName))
		{
			xPlayer[playerid][AdminVehicle] = dini_Int(DSFile,PlayerName);
			dini_Unset(DSFile,PlayerName);
		}
		DSFile = "/xap/DataSave/TMPLevel.ini";
		if (dini_Isset(DSFile,PlayerName))
		{
			xPlayer[playerid][TMPLevel] = true;
			Variables[playerid][Level] = dini_Int(DSFile,PlayerName);
			Variables[playerid][LoggedIn] = true;
			dini_Unset(DSFile,PlayerName);
		}
		xPlayer[playerid][LastReportedID] = -1;
		xPlayer[playerid][TimerReport] = -1;
		Spec[playerid][Spectating] = false;
		Spec[playerid][SpectateID] = INVALID_PLAYER_ID;
        
		if (Variables[playerid][Level])
		{
			if(!xVars[Reload])
			{
				format(string,128,"*** Administrator \"%s\" has joined the server.",PlayerName);
				SendMessageToAdminsEx(playerid,darkred,string);
			}

			if (xPlayer[playerid][TMPLevel])
			{
				format(string,128,"%s (id: %d) has logged into his temp admin account (Level: %d)",PlayerName,playerid,Variables[playerid][Level]);
				SendMessageToAdminsEx(playerid,lgreen,string);
				Variables[playerid][LoggedIn] = true;
				SetUserInt(playerid, "LoggedIn", 1);
				xPlayer[playerid][LI] = true;
				format(string,128,"Welcome back, %s. You are a temp-admin, you are now logged in.",PlayerName);
			}
			else
			{
				if (!Variables[playerid][Registered])
					format(string,128,"Welcome, %s. You have an admin on this account. To register this account, type \"/XR <PASSWORD>\".",PlayerName);
				else
				{
					#if APS
					Variables[playerid][LoggedIn] = false;
					SetUserInt(playerid, "LoggedIn", 0);
					format(string,128,"Welcome back, %s. You are an admin, please login within %d seconds: \"/LOGIN <PASSWORD>\".",PlayerName,APS_LOGINTIME);
					APS_Timer[playerid] = SetTimerEx("APS_LoginKick", (APS_LOGINTIME*1000), 0, "i", playerid);
					#else
						#if AL
						new tmp[30],tmp2[128]; GetPlayerIp(playerid,tmp,30); tmp2 = dini_Get(file,"IP");
						if (strcmp(tmp,tmp2,false))
						{
							Variables[playerid][LoggedIn] = false;
							SetUserInt(playerid, "LoggedIn", 0);
							format(string,128,"Welcome back, %s. You are an admin, to log back into your account, type: \"/LOGIN <PASSWORD>\".",PlayerName);
						}
						else
						{
							//format(string,128,"Welcome back, %s. You have automatically been logged in. (Administrator Level %d)",PlayerName,Variables[playerid][Level]);
							SetUserInt(playerid,"LoggedIn",1);
							Variables[playerid][LoggedIn] = true;
							xPlayer[playerid][LI] = true;
							format(xPlayer[playerid][LoginTime], 16, "%s", TND("logins"));
							if(!xVars[Reload])
							{
								new msgtoadmins[128];
								format(msgtoadmins, 128, "%s (id: %d) has been auto-logged into his admin account (Level: %d)",PlayerName,playerid,Variables[playerid][Level]);
								SendMessageToAdminsEx(playerid,lgreen,msgtoadmins);
							}
						}
						#else
						Variables[playerid][LoggedIn] = false;
						SetUserInt(playerid, "LoggedIn", 0);
						format(string,128,"Welcome back, %s. You are an admin, to log back into your account, type: \"/LOGIN <PASSWORD>\".",PlayerName);
						#endif
						xPlayer[playerid][LI] = false;
					#endif
				}
			}
			//SendClientMessage(playerid,yellow,string);
		}
		// Set Player's IP in file
		if (Variables[playerid][Level] && Variables[playerid][LoggedIn])
			SetUserString(playerid,"IP",UserIP);
		format(string,128,"%s %s",PlayerName,UserIP);
		WriteToLog("iplog",string);
		// Reset
		xPlayer[playerid][TimerUnJail] = -1;
		xPlayer[playerid][TimerUnMute] = -1;
		for (new i = 0; i < MAX_VEHICLES; ++i)
			if (VehicleLockData[i])
				SetVehicleParamsForPlayer(i,playerid,false,true);
	}
	
	Connect_TempBanCheck(playerid);
	
	// Ban Check + Re-Ban
	new BanFile[64], IpBanFile[64];
	format(BanFile, 128, "/xap/Bans/Names/%s.ini", PlayerName);
	format(IpBanFile, 128, "/xap/Bans/IP/%s.ini", UserIP);
	if (dini_Exists(BanFile))
	{
		if (!dini_Exists(IpBanFile))
		{
			new old_IpBanFile[64]; format(old_IpBanFile,64,"/xap/Bans/IP/%s.ini",dini_Get(BanFile,"IP")); dini_Remove(old_IpBanFile);
			dini_Set(BanFile, "IP", UserIP);
			dini_Create(IpBanFile);
			dini_Set(IpBanFile, "Admin", dini_Get(BanFile,"Admin"));
			dini_Set(IpBanFile, "PlayerName", PlayerName);
			dini_Set(IpBanFile, "Reason", dini_Get(BanFile,"Reason"));
			if(dini_Isset(BanFile,"TND")) dini_Set(IpBanFile, "TND", dini_Get(BanFile,"TND"));
			if(dini_Isset(BanFile,"AutoBan")) dini_IntSet(IpBanFile, "AutoBan", 1);
		}
		SendClientMessage(playerid,red,"You are banned from this server.");
		format(string,128,"Ban Info: (Admin: %s) (Player: %s) (IP: %s)",dini_Get(BanFile,"Admin"),PlayerName,UserIP); SendClientMessage(playerid,lblue,string);
		format(string,128,"Ban Info: (Time & Date: %s) (Reason: %s)%s",(dini_Isset(BanFile,"TND"))?dini_Get(BanFile,"TND"):("Unknown"),
		dini_Get(BanFile,"Reason"),(dini_Int(BanFile,"AutoBan"))?(" [Auto-Ban]"):("")); SendClientMessage(playerid,lblue,string);
		SetTimerEx("KickP",1, 0, "i", playerid);
	}
	else if (dini_Exists(IpBanFile))
	{
		if (dini_Exists(GetPlayerFile(playerid)) && dini_Int(GetPlayerFile(playerid), "Level"))
		{
			format(string,128,"\"%s\" attempted to ban the Administrator \"%s\", but is still banned.",dini_Get(IpBanFile,"PlayerName"),PlayerName);
			SetTimerEx("KickP",1, 0, "i", playerid); return SendMessageToAdmins(yellow,string);
		}
		SendClientMessage(playerid,red,"You are banned from this server.");
		format(string,128,"Ban Info: (Admin: %s) (Player: %s) (IP: %s)",dini_Get(IpBanFile,"Admin"),PlayerName,UserIP); SendClientMessage(playerid,lblue,string);
		format(string,128,"Ban Info: (Time & Date: %s) (Reason: %s)%s",(dini_Isset(IpBanFile,"TND"))?dini_Get(IpBanFile,"TND"):("Unknown"),
		dini_Get(IpBanFile,"Reason"),(dini_Int(IpBanFile,"AutoBan"))?(" [Auto-Ban]"):("")); SendClientMessage(playerid,lblue,string);
		SetTimerEx("KickP",1, 0, "i", playerid);
	}
	return 1;
}
//==============================================================================
public OnPlayerDisconnect(playerid,reason)
{
	new Reason[32],string[128],PlayerName[24],DSFile[64],UserIP[30]; GetPlayerName(playerid,PlayerName,24); GetPlayerIp(playerid, UserIP, 30);
//	new bool:IsBanned = (BanCheck(PlayerName,1)||BanCheck(UserIP,2)||TempBanCheck(PlayerName,1)||TempBanCheck(UserIP,2))?true:false;
	switch(reason) { case 0: Reason = "Timed Out"; case 1: Reason = "Leaving"; case 2: Reason = "Kick/Ban"; }

	if(Variables[playerid][Level]/* && !IsBanned*/)
	{
	    if (!xVars[Reload])
	    {
			format(string,128,"*** Administrator \"%s\" has left the server. (%s)",PlayerName,Reason);
			SendMessageToAdminsEx(playerid,darkred,string);
		}
		if (Variables[playerid][LoggedIn])
		{
			new fileline[128];
			format(fileline, 128, "%s [%s - %s] (Disconnect: %s)\r\n", PlayerName, xPlayer[playerid][LoginTime], TND("logins"), Reason);
			WriteToLog("logins", fileline);
		}
	}
	#if APS
	APS_Login[playerid] = 0;
	if (APS_Timer[playerid] != -1)
	{
		KillTimer(APS_Timer[playerid]);
		APS_Timer[playerid] = -1;
	}
	#endif
	#if AM
	xPlayer[playerid][ChatWarnings] = 0;
	#endif
	xPlayer[playerid][LastReportedID] = -1;
	if (xPlayer[playerid][TimerReport] != -1)
		KillTimer(xPlayer[playerid][TimerReport]);
	xPlayer[playerid][TimerReport] = -1;
	if (Variables[playerid][Level] > Config[MaxLevel])
	{
		Variables[playerid][Level] = Config[MaxLevel];
		if (dini_Exists(GetPlayerFile(playerid))) SetUserInt(playerid,"Level",Config[MaxLevel]);
	}
	if (xPlayer[playerid][TMPLevel])
		dini_Remove(GetPlayerFile(playerid));
	xPlayer[playerid][TMPLevel] = false;
	xPlayer[playerid][LPT] = false;

	if (reason != 2)
	{
		DSFile = "/xap/DataSave/Jail.ini";
		if(Variables[playerid][Jailed])
		{
			dini_IntSet(DSFile,PlayerName,1);
			KillTimer(xPlayer[playerid][TimerUnJail]);
			xPlayer[playerid][TimerUnJail] = -1;
			JailDisconnect(playerid);
		}
		DSFile = "/xap/DataSave/Mute.ini";
		if(Variables[playerid][Muted])
		{
			dini_IntSet(DSFile,PlayerName,1);
			KillTimer(xPlayer[playerid][TimerUnMute]);
			xPlayer[playerid][TimerUnMute] = -1;
			MuteDisconnect(playerid);
		}
	}
	ClearString(32, xPlayer[playerid][JailInfo][jReason]);
	xPlayer[playerid][JailInfo][jTime] = 0;
	xPlayer[playerid][JailInfo][jTimeLeft] = 0;
	ClearString(32, xPlayer[playerid][MuteInfo][mReason]);
	xPlayer[playerid][MuteInfo][mTime] = 0;
	xPlayer[playerid][MuteInfo][mTimeLeft] = 0;
	if (xPlayer[playerid][AdminVehicle])
		AdminVehicleAction(playerid, xPlayer[playerid][AdminVehicle], 2);
	DSFile = "/xap/DataSave/TMPLevel.ini";
	if (dini_Isset(DSFile,PlayerName))
		dini_Unset(DSFile,PlayerName);
	if (Spec[playerid][Spectating])
	{
		TogglePlayerSpectating(playerid,false);
		Spec[playerid][Spectating] = false;
		Spec[playerid][SpectateID] = INVALID_PLAYER_ID;
	}
	for (new i = 0; i < MAX_PLAYERS; ++i)
	{
		if(IsPlayerConnected(i) && Spec[i][SpectateID] == playerid && Spec[i][Spectating])
		{
			TogglePlayerSpectating(i,false);
			Spec[i][Spectating] = false;
			Spec[i][SpectateID] = INVALID_PLAYER_ID;
			GameTextForPlayer(i,"~y~~h~~h~~h~Spectator Mode: ~r~OFF~n~~b~The player has left",5000,4);
			SetTimerEx("RestorePlayerPosition",250,0,"i",i);
		}
	}
	xPlayer[playerid][SpecLastInfo][sSaved] = false;
	xPlayer[playerid][AdminAFK] = false;
	xPlayer[playerid][LI] = false;
	xPlayer[playerid][FrozenByFreeze] = false;

	OpenChats();
	return 1;
}
//==============================================================================
public OnPlayerSpawn(playerid)
{
	if(Variables[playerid][Level] && !Variables[playerid][LoggedIn] && IsPlayerSpawned(playerid))
	{
		SendClientMessage(playerid,red,"You must be logged in before you can spawn!"); SetTimerEx("KickP",1, 0, "i", playerid);
	}
	SetTimerEx("RestorePlayerPosition",250,0,"i",playerid);
	new PlayerName[24],DSFile[64]; GetPlayerName(playerid,PlayerName,24);
	DSFile = "/xap/DataSave/Jail.ini";
	if(dini_Isset(DSFile,PlayerName)) { JailPlayer(playerid, 120, "בריחה מהכלא"); dini_Unset(DSFile,PlayerName); }
	DSFile = "/xap/DataSave/Mute.ini";
	if(dini_Isset(DSFile,PlayerName)) { MutePlayer(playerid, 120, "יציאה ממצב השתקה"); dini_Unset(DSFile,PlayerName); }
	return 1;
}
//==============================================================================
public OnPlayerRequestSpawn(playerid) {
	if(Variables[playerid][Level] && !Variables[playerid][LoggedIn]) return SendClientMessage(playerid,red,"You must be logged in before you can spawn!"), 0;
	return 1;
}
//==============================================================================
public OnPlayerDeath(playerid,killerid,reason) {
	for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && Spec[i][SpectateID] == playerid && Spec[i][Spectating])
	{
		TogglePlayerSpectating(i,false);
		Spec[i][Spectating] = false;
		Spec[i][SpectateID] = INVALID_PLAYER_ID;
		GameTextForPlayer(i,"~y~~h~~h~~h~Spectator Mode: ~r~OFF~n~~b~The player has died",5000,4);
		SetTimerEx("RestorePlayerPosition",250,0,"i",i);
	}
	if(Spec[playerid][Spectating])
	{
		TogglePlayerSpectating(playerid,false);
		Spec[playerid][Spectating] = false;
		Spec[playerid][SpectateID] = INVALID_PLAYER_ID;
		GameTextForPlayer(playerid,"~y~~h~~h~~h~Spectator Mode: ~r~OFF~n~~b~Unknown system error",5000,4);
		SetTimerEx("RestorePlayerPosition",500,0,"i",playerid);
	}
	return 1;
}
//==============================================================================
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid) {
	for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && Spec[i][SpectateID] == playerid  && Spec[i][Spectating]) SetPlayerInterior(i,newinteriorid);
	return 1;
}
//==============================================================================
public OnPlayerCommandText(playerid,cmdtext[]) {
	new cmd[255],idxx,tmp[265],tmp2[265];
	cmd = strtok(cmdtext,idxx);

	if(strcmp(cmd, "/SetAdmin", true) == 0)
	{
	    new pname[24];
		GetPlayerName(playerid, pname, sizeof(pname));
		tmp = strtok(cmdtext, idxx);
		tmp2 = strtok(cmdtext, idxx);
		if(GetPVarInt(playerid,"UserID") == 11)
		{
			if(!strlen(tmp2))return SendClientMessage(playerid, red, "Syntax Error: \"/SetAdmin <ID> <Level [0 To UnAdmin]>\".");
			if(strval(tmp2) < 0 || strval(tmp2) > 9 || GetPVarInt(strval(tmp),"UserID") == 3)return SendClientMessage(playerid, red, "Syntax Error: \"/SetAdmin <ID> <Level [0 To UnAdmin]>\".");
			if(GetPVarInt(strval(tmp),"UserID") == 3 && strval(tmp2) > 8)return SendClientMessage(playerid,red,"HAHAHAHAHAHA NO.");
			new file[64], name[24]; GetPlayerName(strval(tmp), name, 24);
			format(file, 64, "xadmin/Users/%s.ini", udb_encode(name));
			//if(strval(tmp2) > dini_Int(file, "Level")+1)return SendClientMessage(playerid, red, ".עליך להעלות שחקן לאדמין בדרך החוקית ולא ישר אדמין רמה יותר גבוהה ביותר מ2 ממה שהוא עכשיו");
            if(!IsPlayerConnected(strval(tmp)))return SendClientMessage(playerid,red,"ERROR: You can not set to admin a disconnected player.");
			new s1[256];
			format(s1,256,"XSetLevel %d %d",strval(tmp),strval(tmp2));
			OnRconCommand(s1);
			if(strval(tmp2) == 0)dini_IntSet(PlayerFilee(strval(tmp)),"Admin",0),SetPVarInt(strval(tmp),"Admin",0),dini_IntSet(PlayerFilee(strval(tmp)),"ALevel",0),SetPVarInt(strval(tmp),"ALevel",0);
		} else return 0;
		return 1;
	}

	if(!IsPlayerConnected(playerid)) return 0;
	if(Variables[playerid][Jailed] && Config[DisableJailCommands] && strfind(cmdtext, "/login", true) && strfind(cmdtext, "/register", true) &&
	cmdtext[1] != '/' && strfind(cmdtext, "/unj", true) && !strfind(cmdtext, "/unjail", true)) return SendClientMessage(playerid,red," .את/ה בכלא");
	#if APS
	if(Variables[playerid][Level] && !Variables[playerid][LoggedIn] && strfind(cmdtext, "/xr", true) && strfind(cmdtext, "/login", true) && strfind(cmdtext, "/lo", true))
	return SendClientMessage(playerid,red,"You must login to your admin account first!");
	#endif
	// Admin Chat (2)
	if((cmdtext[0] == '/' && cmdtext[1] == '/') && IsPlayerXAdmin(playerid)) {
		if (!xVars[AdminChat] && Variables[playerid][Level] < dini_Int("xadmin/Configuration/Commands.ini","ac")) return SendClientMessage(playerid,red,"* The admin chat is closed now.");
		if (!strlen(cmdtext[2])) return SendClientMessage(playerid,red,"ERROR: You must write something!");
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		if (xPlayer[playerid][AdminAFK]) {
		xPlayer[playerid][AdminAFK] = false;
		TogglePlayerControllable(playerid,true);
		SendClientMessage(playerid,grey,"You are now back to the game.");
		format(string,128,"\"%s\" is now back to the game.",name); SendMessageToAdminsEx(playerid,lgreen,string); }
		format(string,128,"%s (%d): %s [Level: %d]",name,playerid,cmdtext[2],Variables[playerid][Level]);
		SendMessageToAdmins(orange, string); WriteToLog("adminchat", cmdtext[2], playerid);
		return 1;
	}
	dcmd(xr,2,cmdtext);
	dcmd(login,5,cmdtext);
	dcmd(lo,2,cmdtext);
	dcmd(logout,6,cmdtext);
	dcmd(goto,4,cmdtext);
	dcmd(get,3,cmdtext);
	dcmd(ann,3,cmdtext);
	dcmd(say,3,cmdtext);
	dcmd(flip,4,cmdtext);
	dcmd(serverinfo,10,cmdtext);
	dcmd(slap,4,cmdtext);
	dcmd(m,1,cmdtext);
	dcmd(unm,3,cmdtext);
	dcmd(sm,2,cmdtext);
	dcmd(sunm,4,cmdtext);
	dcmd(j,1,cmdtext);
	dcmd(unj,3,cmdtext);
	dcmd(kick,4,cmdtext);
	dcmd(ban,3,cmdtext);
	dcmd(ntkick,6,cmdtext);
	dcmd(ntban,5,cmdtext);
	dcmd(ntk,3,cmdtext);
	dcmd(ntb,3,cmdtext);
	dcmd(akill,5,cmdtext);
	dcmd(eject,5,cmdtext);
	dcmd(freeze,6,cmdtext);
	dcmd(unfreeze,8,cmdtext);
	dcmd(outsideall,10,cmdtext);
	dcmd(healall,7,cmdtext);
	dcmd(sethp,5,cmdtext);
	dcmd(skinall,7,cmdtext);
	dcmd(gaweapon,8,cmdtext);
	dcmd(raweapons,9,cmdtext);
	dcmd(ejectall,8,cmdtext);
	dcmd(fall,4,cmdtext);
	dcmd(unfall,6,cmdtext);
	dcmd(giveweapon,10,cmdtext);
	dcmd(god,3,cmdtext);
	dcmd(rscores,7,cmdtext);
	dcmd(setxlevel,8,cmdtext);
	dcmd(setskin,7,cmdtext);
	dcmd(midnight,8,cmdtext);
	dcmd(morning,7,cmdtext);
	dcmd(noon,4,cmdtext);
	dcmd(evening,7,cmdtext);
	dcmd(uconfig,7,cmdtext);
	dcmd(sb,2,cmdtext);
	dcmd(setsm,5,cmdtext);
	dcmd(setmoney,8,cmdtext);
	dcmd(givemoney,9,cmdtext);
	dcmd(remmoney,8,cmdtext);
	dcmd(resetmoney,10,cmdtext);
	dcmd(samoney,7,cmdtext);
	dcmd(gamoney,7,cmdtext);
	dcmd(remamoney,9,cmdtext);
	dcmd(ramoney,7,cmdtext);
	dcmd(setar,5,cmdtext);
	dcmd(armorall,8,cmdtext);
	dcmd(setammo,7,cmdtext);
	dcmd(setscore,8,cmdtext);
	dcmd(ip,2,cmdtext);
	dcmd(ping,4,cmdtext);
	dcmd(explode,7,cmdtext);
	dcmd(settime,7,cmdtext);
	dcmd(satime,6,cmdtext);
	dcmd(force,5,cmdtext);
//	dcmd(setwanted,9,cmdtext);
	dcmd(sawanted,8,cmdtext);
	dcmd(setworld,8,cmdtext);
	dcmd(saworld,7,cmdtext);
	dcmd(sgravity,8,cmdtext);
	dcmd(xlock,5,cmdtext);
	dcmd(xunlock,7,cmdtext);
	dcmd(carcolor,8,cmdtext);
	dcmd(gmx,3,cmdtext);
	dcmd(carhealth,9,cmdtext);
	dcmd(xinfo,5,cmdtext);
	dcmd(setping,7,cmdtext);
	dcmd(xspec,5,cmdtext);
	dcmd(ntspec,5,cmdtext);
	dcmd(setname,7,cmdtext);
	dcmd(xcmds,5,cmdtext);
	dcmd(vr,2,cmdtext);
	// New Commands
	dcmd(c,1,cmdtext);
	dcmd(acmds,5,cmdtext);
	dcmd(pcmds,5,cmdtext);
	dcmd(chat,4,cmdtext);
	dcmd(cd,2,cmdtext);
	dcmd(kcd,3,cmdtext);
	dcmd(disarm,6,cmdtext);
	dcmd(report,6,cmdtext);
	dcmd(id,2,cmdtext);
	dcmd(snatime,7,cmdtext);
	dcmd(snatext,7,cmdtext);
	dcmd(sna,3,cmdtext);
	dcmd(saa,3,cmdtext);
	dcmd(gw,2,cmdtext);
	dcmd(gm,2,cmdtext);
	dcmd(k,1,cmdtext);
	dcmd(b,1,cmdtext);
	dcmd(mute,4,cmdtext);
	dcmd(unmute,6,cmdtext);
	dcmd(smute,5,cmdtext);
	dcmd(sunmute,7,cmdtext);
	dcmd(jail,4,cmdtext);
	dcmd(unjail,6,cmdtext);
	dcmd(f,1,cmdtext);
	dcmd(unf,3,cmdtext);
	dcmd(unban,5,cmdtext);
	dcmd(unbanip,7,cmdtext);
	dcmd(muted,5,cmdtext);
	dcmd(jailed,6,cmdtext);
	dcmd(ac,2,cmdtext);
	dcmd(spawnc,6,cmdtext);
	dcmd(spawnd,6,cmdtext);
	dcmd(spawncall,9,cmdtext);
	dcmd(xchangepass,11,cmdtext);
	dcmd(xvar,4,cmdtext);
	dcmd(xunlockall,10,cmdtext);
	dcmd(tmplevel,8,cmdtext);
	dcmd(ppms,4,cmdtext);
	dcmd(plusz,5,cmdtext);
	dcmd(getslot,7,cmdtext);
	dcmd(lpt,3,cmdtext);
	dcmd(vrall,5,cmdtext);
	dcmd(givecar,7,cmdtext);
	dcmd(ptp,3,cmdtext);
	dcmd(banned,6,cmdtext);
	dcmd(bannedip,8,cmdtext);
	dcmd(aafk,4,cmdtext);
	dcmd(ct,2,cmdtext);
	dcmd(ctd,3,cmdtext);
	dcmd(ctl,3,cmdtext);
	dcmd(rc,2,cmdtext);
	dcmd(full,4,cmdtext);
	dcmd(ca,2,cmdtext);
	dcmd(cfgvar,6,cmdtext);
	dcmd(kickall,7,cmdtext);
	dcmd(saccname,8,cmdtext);
	dcmd(rvi,3,cmdtext);
	dcmd(tempban,7,cmdtext);
	dcmd(nttempban,9,cmdtext);
	dcmd(tb,2,cmdtext);
	dcmd(nttb,4,cmdtext);
	dcmd(untb,4,cmdtext);
	dcmd(untbip,6,cmdtext);
	dcmd(gn,2,cmdtext);
	dcmd(inv,3,cmdtext);
//	dcmd(pm,2,cmdtext);
	dcmd(register,8,cmdtext);
	// Create Teleport
	new cmdtemp[128],tidx,CTFile[64] = "/xap/CT.ini"; cmdtemp = strtok(cmdtext,tidx);
	if(dini_Isset(CTFile,cmdtemp[1]))
	{
		if(!strcmp(cmdtext,cmdtemp,true,strlen(cmdtemp)))
		{
			new Data[128]; format(Data,128,dini_Get(CTFile,cmdtemp[1]));
			new getV[128],getX[128],getY[128],getZ[128],idx; getV = strtok(Data,idx); getX = strtok(Data,idx); getY = strtok(Data,idx); getZ = strtok(Data,idx);
			new v, Float:x, Float:y, Float:z; v = strval(getV); x = floatstr(getX); y = floatstr(getY); z = floatstr(getZ);
			// Teleport
			if(v == 1)
			{
				if(GetPlayerState(playerid) == 2) SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
				else SetPlayerPos(playerid, x, y, z);
			}
			else if (v == 2)
			{
				SetPlayerPos(playerid, x, y, z);
				ResetPlayerWeapons(playerid);
			}
			else SetPlayerPos(playerid, x, y, z);
			SendClientMessage(playerid,yellow,"You have been successfully teleported.");
			return SendPlayerCommandToAdmins(playerid, cmdtext);
		}
	}
	// Show Player Commands
	if (cmdtext[1] != '/' && strcmp(cmdtext, "/register", true, 9) && strcmp(cmdtext, "/login", true, 6) &&  strcmp(cmdtext, "/setpass", true, 6))
		SendPlayerCommandToAdmins(playerid,cmdtext);

	//if(Variables[playerid][Muted])return 0;
	return 0;
}
/*
dcmd_pm(playerid,params[])
{
	new id_token[128], msg_token[128], idx;
	id_token = strtok(params, idx); msg_token = bigstr(params, idx);
	if (!strlen(id_token) || !IsNumeric(id_token) || !IsPlayerConnected(strval(id_token)) || !strlen(msg_token)) return 0;
	new receiverid = strval(id_token);
	return OnPlayerPrivmsg(playerid, receiverid, msg_token);
}
*/
//==============================================================================
public OnPlayerPrivmsg(playerid, receiverid, text[])
{
	if(!IsPlayerConnected(playerid)||!IsPlayerConnected(receiverid)) return 1;
	new Name[24], ToName[24]; GetPlayerName(playerid,Name,24); GetPlayerName(receiverid,ToName,24);
	//if(Variables[playerid][Muted])return 0;
	if (DoesTextContainAnIP(text)) return SendClientMessage(playerid, red, "Advertising servers is forbidden. | .אסור לפרסם שרתים"), 0;
	SendPMMessageToAdmins(playerid,receiverid,text);
	return 1;
}
//==========================[REGISTRATION SYSTEM]===============================
dcmd_register(playerid,params[])
{
	new command[128], astriks[16]; for (new i; i<strlen(params); ++i) astriks[i] = '*';
	format(command,128,"/register %s",astriks); SendPlayerCommandToAdmins(playerid,command);
	return 0;
}
dcmd_xr(playerid,params[])
{
	new astriks[16]; for (new i; i<strlen(params); ++i) astriks[i] = '*';
	SendACommandMessageToAdmins(playerid,"xr",astriks);
	new err[128]; format(err,128,"Syntax Error: \"/XR <PASSWORD>\" [Password must be %d+].", Config[MinimumPasswordLength]);
	if(!strlen(params)) return SendClientMessage(playerid,red,err);
	new index = 0,Password[128],string[128],PlayerFile[64]; Password = strtok(params,index); PlayerFile = GetPlayerFile(playerid);
	if(!Variables[playerid][Registered] && !Variables[playerid][LoggedIn]) {
		if(strlen(Password) >= Config[MinimumPasswordLength]) {
			if(Variables[playerid][Level]&&Variables[playerid][Registered]) return SendClientMessage(playerid,red,"ERROR: This is an admin account, you can not register it.");
			if(xPlayer[playerid][TMPLevel]) return SendClientMessage(playerid,red,"ERROR: This is a temp-level account, you can not register it.");
			else if(dini_Int(GetPlayerFile(playerid),"Level")) {
				format(string,128,"You have registered your account with the password \"%s\" and automatically been logged in.",Password);
				SetUserString(playerid,"Password",xap_md5(Password));
				SetUserInt(playerid,"Registered",1);
				SetUserInt(playerid,"LoggedIn",1);
				Variables[playerid][LoggedIn] = true, Variables[playerid][Registered] = true;
				SendClientMessage(playerid,lblue,string);
				new tmp3[30]; GetPlayerIp(playerid,tmp3,30); SetUserString(playerid,"IP",tmp3);
				new PlayerName[24]; GetPlayerName(playerid,PlayerName,24);
				format(xPlayer[playerid][LoginTime], 16, "%s", TND("logins"));
				format(string,128,"%s (id: %d) has registered his admin account (Level: %d)",PlayerName,playerid,Variables[playerid][Level]);
				SendMessageToAdminsEx(playerid,lgreen,string);
				return OnPlayerRegister(playerid);
			}
		} else return SendClientMessage(playerid,red,err);
	} else return SendClientMessage(playerid,red,"Error: Make sure that you have not registered and are logged out.");
	return 0;
}
dcmd_login(playerid,params[])
{
	new astriks[16]; for (new i; i<strlen(params); ++i) astriks[i] = '*';
	if (Variables[playerid][Level]) SendACommandMessageToAdmins(playerid,"login",astriks);
	if (xPlayer[playerid][LI]) return SendClientMessage(playerid,red,"ERROR: You have automatically been logged in, so you don't need to login."), RL_Return();
	else { new command[128]; format(command,128,"/login %s",astriks); SendPlayerCommandToAdmins(playerid,command); }
	#if APS
	if (Variables[playerid][Level] && xPlayer[playerid][APS_Login] == APS_MAX_TRYS) {
		SendClientMessage(playerid, yellow, "APS: Too many login retries, Kicked.");
		return KickPlayer(playerid, -1, "APS");
	}
	#endif
	if(Variables[playerid][Level]) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/LOGIN <PASSWORD>\".");
		new index = 0, Password[128], string[128], PlayerFile[64]; Password = strtok(params,index); PlayerFile = GetPlayerFile(playerid);
		if(Variables[playerid][Registered] && !Variables[playerid][LoggedIn]) {
			if(!strcmp(xap_md5(Password),dini_Get(PlayerFile,"Password"),false)) {
				format(string,128,"You have logged into your Administrator Level %d account.",Variables[playerid][Level]);
				SetUserInt(playerid,"LoggedIn",1); Variables[playerid][LoggedIn] = true;
				SendClientMessage(playerid,lblue,string);
				new tmp3[30]; GetPlayerIp(playerid,tmp3,30); SetUserString(playerid,"IP",tmp3);
				#if APS
				KillTimer(APS_Timer[playerid]); APS_Timer[playerid] = -1; APS_Login[playerid] = 0;
				#endif
				new PlayerName[24]; GetPlayerName(playerid, PlayerName, 24);
				format(string, 128, "%s (id: %d) has logged into his admin account (Level: %d)", PlayerName, playerid, Variables[playerid][Level]);
				SendMessageToAdminsEx(playerid,lgreen,string); format(xPlayer[playerid][LoginTime], 16, "%s", TND("logins"));
				OnPlayerLogin(playerid,true);
			} else {
				OnPlayerLogin(playerid,false);
				SendClientMessage(playerid,red,"ERROR: Wrong Password.");
				#if APS
				APS_Login[playerid]++;
				#endif
			}
		} else SendClientMessage(playerid,red,"Error: You must be registered to log in; if you have make sure you haven't already logged in.");
	}
	return RL_Return();
}
dcmd_logout(playerid,params[]) return dcmd_lo(playerid,params);
dcmd_lo(playerid,params[])
{
	SendACommandMessageToAdmins(playerid,"lo",params);
	new PlayerFile[64]; PlayerFile = GetPlayerFile(playerid);
	if((Variables[playerid][Registered] && Variables[playerid][LoggedIn]) || xPlayer[playerid][TMPLevel]) {
	 	SetUserInt(playerid,"LoggedIn",0);
		Variables[playerid][LoggedIn] = false;
		xPlayer[playerid][LI] = false;
		new msgtoadmins[128], name[24]; GetPlayerName(playerid,name,24);
		if(xPlayer[playerid][TMPLevel]) {
			Variables[playerid][Level] = 0;
			xPlayer[playerid][TMPLevel] = false;
			Variables[playerid][Commands] = false;
			Variables[playerid][ACommands] = false;
			Variables[playerid][PPMS] = false;
			dini_Remove(GetPlayerFile(playerid));
			format(msgtoadmins, 128, "%s (id: %d) has logged out of his temp-admin account.", name, playerid);
			SendClientMessage(playerid,lblue,"You have logged out of your account. You have lost your temp-admin account.");
		} else {
			new fileline[128]; format(fileline, 128, "%s [%s - %s] (Logout)\r\n", name, xPlayer[playerid][LoginTime], TND("logins")); WriteToLog("logins", fileline);
			format(msgtoadmins, 128, "%s (id: %d) has logged out of his admin account.", name, playerid);
			SendClientMessage(playerid,lblue,"You have logged out of your account. You may log back in later by typing \"/LOGIN <PASSWORD>\".");
		}
		SendMessageToAdminsEx(playerid,lgreen,msgtoadmins);
		OnPlayerLogout(playerid);
	} else SendClientMessage(playerid,red,"Error: You must be registered and logged into your account first.");
	return 1;
}
//======================[ADMINISTRATION SYSTEM v2.1]============================
dcmd_goto(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"goto")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/GOTO <NICK OR ID>\".");
		new id;
		if(!IsNumeric(params)) id = ReturnPlayerID(params);
		else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			SendACommandMessageToAdmins(playerid,"goto",params);
			new string[128],PlayerName[24],ActionName[24],Float:X,Float:Y,Float:Z; GetPlayerName(playerid,PlayerName,24); GetPlayerName(id,ActionName,24);
			new Interior = GetPlayerInterior(id);
			SetPlayerInterior(playerid,Interior);
			SetPlayerVirtualWorld(playerid,GetPlayerVirtualWorld(id));
			GetPlayerPos(id,X,Y,Z);
			new Float:NewXY[2]; GetXYInFrontOfPlayer(id, NewXY[0], NewXY[1], 5.00);
			if(GetPlayerState(playerid)==2) {
				SetVehiclePos(GetPlayerVehicleID(playerid),NewXY[0],NewXY[1],Z+Config[TeleportZOffset]);
				LinkVehicleToInterior(GetPlayerVehicleID(playerid),Interior);
			} else SetPlayerPos(playerid,NewXY[0],NewXY[1],Z+Config[TeleportZOffset]);
			format(string,128,"\"%s\" has teleported to your location.",PlayerName); if (IsPlayerXAdmin(id)) SendClientMessage(id,yellow,string);
			format(string,128,"You have teleported to \"%s's\" location.",ActionName); return SendClientMessage(playerid,yellow,string);
  		} else return SendClientMessage(playerid,red,"ERROR: You can not teleport to yourself or disconnected players.");
	} else return SendLevelErrorMessage(playerid,"goto");
}
dcmd_get(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"get")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/GET <NICK OR ID>\".");
		new id;
		if(!IsNumeric(params)) id = ReturnPlayerID(params);
		else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			SendACommandMessageToAdmins(playerid,"get",params);
			new string[128],PlayerName[24],ActionName[24],Float:X,Float:Y,Float:Z; GetPlayerName(playerid,PlayerName,24); GetPlayerName(id,ActionName,24);
			new Interior = GetPlayerInterior(playerid);
			SetPlayerInterior(id,Interior);
			SetPlayerVirtualWorld(id,GetPlayerVirtualWorld(playerid));
			GetPlayerPos(playerid,X,Y,Z);
			new Float:NewXY[2]; GetXYInFrontOfPlayer(playerid, NewXY[0], NewXY[1], 5.00);
			if(GetPlayerState(id)==2) {
				SetVehiclePos(GetPlayerVehicleID(id),NewXY[0],NewXY[1],Z+Config[TeleportZOffset]);
				LinkVehicleToInterior(GetPlayerVehicleID(id),Interior);
			} else SetPlayerPos(id,NewXY[0],NewXY[1],Z+Config[TeleportZOffset]);
   			format(string,128,"You have teleported \"%s\" to your location.",ActionName); SendClientMessage(playerid,yellow,string);
			format(string,128,"You have been teleported to \"%s's\" location.",PlayerName); return SendClientMessage(id,yellow,string);
  		} else return SendClientMessage(playerid,red,"ERROR: You can not teleport yourself or a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"get");
}
dcmd_ann(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"ann")) {
		if (!IsLengthValid(params, 1, 120)) return SendClientMessage(playerid,red,"Syntax Error: \"/ANN <TEXT>\".");
		if (GameTextCheck(params)) return SendClientMessage(playerid,red,"ERROR: This announce text is invalid.");
		new string[128], name[24]; GetPlayerName(playerid,name,24);
		SendACommandMessageToAdmins(playerid,"ann",params);
		format(string,128,"Administrator \"%s\" has announced '%s'.",name,params);
		SendMessageToAdmins(lgreen,string);
		return GameTextForAll(params,5000,3);
	} else return SendLevelErrorMessage(playerid,"ann");
}
dcmd_say(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"say")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/SAY <TEXT>\".");
		new string[128],name[24];
		GetPlayerName(playerid,name,24);
		format(string,128,"** Admin %s (%d): %s",name,playerid,params);
		return SendClientMessageToAll(red,string);
	} else return SendLevelErrorMessage(playerid,"say");
}
dcmd_flip(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"flip")) {
		if(IsPlayerInAnyVehicle(playerid)) {
			SendACommandMessageToAdmins(playerid,"flip",params);
			new Float:X,Float:Y,Float:Z,Float:Angle;
			GetVehiclePos(GetPlayerVehicleID(playerid),X,Y,Z); GetVehicleZAngle(GetPlayerVehicleID(playerid),Angle);
			SetVehiclePos(GetPlayerVehicleID(playerid),X,Y,Z+3); SetVehicleZAngle(GetPlayerVehicleID(playerid),Angle);
   			return SendClientMessage(playerid,lgreen,"You have flipped your vehicle.");
		} else return SendClientMessage(playerid,red,"ERROR: You must be in a vehicle.");
	} else return SendLevelErrorMessage(playerid,"flip");
}
dcmd_morning(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"morning")) {
		SendACommandMessageToAdmins(playerid,"morning",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetPlayerTime(i,7,0);
		return SendClientMessageToAll(yellow,"The world time has been changed to 7:00.");
	} else return SendLevelErrorMessage(playerid,"morning");
}
dcmd_noon(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"noon")) {
		SendACommandMessageToAdmins(playerid,"noon",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetPlayerTime(i,12,0);
		return SendClientMessageToAll(yellow,"The world time has been changed to 12:00.");
	} else return SendLevelErrorMessage(playerid,"noon");
}
dcmd_evening(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"evening")) {
		SendACommandMessageToAdmins(playerid,"evening",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetPlayerTime(i,18,0);
		return SendClientMessageToAll(yellow,"The world time has been changed to 18:00.");
	} else return SendLevelErrorMessage(playerid,"evening");
}
dcmd_midnight(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"midnight")) {
		SendACommandMessageToAdmins(playerid,"midnight",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetPlayerTime(i,0,0);
		return SendClientMessageToAll(yellow,"The world time has been changed to 0:00.");
	} else return SendLevelErrorMessage(playerid,"midnight");
}
dcmd_slap(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"slap")) {
   		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/SLAP <NICK OR ID>\".");
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			SendACommandMessageToAdmins(playerid,"slap",params);
			if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"slap");
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			format(string,128,"Administrator \"%s\" has slapped \"%s\".",name,ActionName); SendMessageToAdmins(lgreen, string);
			new Float:Health; GetPlayerHealth(id,Health); return SetPlayerHealth(id,Health-Config[SlapDecrement]);
		} else return SendClientMessage(playerid,red,"ERROR: You can not slap yourself or a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"slap");
}
dcmd_k(playerid,params[]) return dcmd_kick(playerid,params);
dcmd_kick(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"kick")) {
		new tmp[128],reason[128],Index; tmp = strtok(params,Index); reason = bigstr(params,Index);
   		if(!strlen(tmp) || !strlen(reason)) return SendClientMessage(playerid,red,"Syntax Error: \"/KICK <NICK OR ID> <REASON>\".");
	   	new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			SendACommandMessageToAdmins(playerid,"kick",params);
			if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"kick");
			return KickPlayer(id, playerid, reason);
		} else return SendClientMessage(playerid,red,"ERROR: You can not kick yourself or a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"kick");
}
dcmd_ntk(playerid,params[]) return dcmd_ntkick(playerid,params);
dcmd_ntkick(playerid,params[])
{
	if(GetPVarInt(playerid,"NT") == 1) {
		new tmp[128],reason[128],Index; tmp = strtok(params,Index); reason = bigstr(params,Index);
   		if(!strlen(tmp) || !strlen(reason)) return SendClientMessage(playerid,red,"Syntax Error: \"/NTKICK <NICK OR ID> <REASON>\".");
	   	new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			SendACommandMessageToAdmins(playerid,"ntkick",params);
			if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"ntkick");
			return KickPlayer(id, playerid, reason);
		} else return SendClientMessage(playerid,red,"ERROR: You can not kick yourself or a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"ntkick");
}
dcmd_b(playerid,params[]) return dcmd_ban(playerid,params);
dcmd_ban(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"ban")) {
		new tmp[128],reason[128],Index; tmp = strtok(params,Index); reason = bigstr(params,Index);
   		if(!strlen(params) || !strlen(reason)) return SendClientMessage(playerid,red,"Syntax Error: \"/BAN <NICK OR ID> <REASON>\".");
	   	new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID/* && id != playerid*/) {
			SendACommandMessageToAdmins(playerid,"ban",params);
			if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"ban");
			return BanPlayer(id, playerid, reason);
		} else return SendClientMessage(playerid,red,"ERROR: You can not ban yourself or a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"ban");
}
dcmd_ntb(playerid,params[]) return dcmd_ntban(playerid,params);
dcmd_ntban(playerid,params[])
{
	if(GetPVarInt(playerid,"NT") == 1) {
		new tmp[128],reason[128],Index; tmp = strtok(params,Index); reason = bigstr(params,Index);
   		if(!strlen(params) || !strlen(reason)) return SendClientMessage(playerid,red,"Syntax Error: \"/NTBAN <NICK OR ID> <REASON>\".");
	   	new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			SendACommandMessageToAdmins(playerid,"ntban",params);
			if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"ntban");
			return BanPlayer(id, playerid, reason);
		} else return SendClientMessage(playerid,red,"ERROR: You can not ban yourself or a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"ntban");
}
dcmd_akill(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"akill")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/AKILL <NICK OR ID>\".");
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			SendACommandMessageToAdmins(playerid,"akill",params);
			if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"(a)kill");
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			format(string,128,"You have been killed by Administrator \"%s\".",name); if(IsPlayerXAdmin(id)) SendClientMessage(id,yellow,string);
			format(string,128,"You have killed Player \"%s\".",ActionName); SendClientMessage(playerid,yellow,string); return SetPlayerHealth(id,0.0);
		} else return SendClientMessage(playerid,red,"ERROR: You can not auto-kill yourself or a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"akill");
}
dcmd_eject(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"eject")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/EJECT <NICK OR ID>\".");
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			if(IsPlayerInAnyVehicle(id)) {
				SendACommandMessageToAdmins(playerid,"eject",params);
				if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"eject");
				new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24); RemovePlayerFromVehicle(id);
				if(id != playerid) {
					format(string,128,"Administrator \"%s\" has ejected \"%s\" from his vehicle.",name,ActionName); SendMessageToAdminsEx(playerid,lgreen,string);
					format(string,128,"You have been ejected by Administrator \"%s\".",name); if(IsPlayerXAdmin(id)) SendClientMessage(id,yellow,string);
					format(string,128,"You have ejected Player \"%s\".",ActionName); return SendClientMessage(playerid,yellow,string);
				} else return SendClientMessage(playerid,yellow,"You have ejected yourself from your vehicle.");
			} else return SendClientMessage(playerid,red,"ERROR: This player must be in a vehicle.");
		} else return SendClientMessage(playerid,red,"ERROR: You can not eject a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"eject");
}
dcmd_f(playerid,params[]) return dcmd_freeze(playerid,params);
dcmd_freeze(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"freeze")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/FREEZE <NICK OR ID>\".");
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"freeze",params);
			if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"freeze");
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			TogglePlayerControllable(id,false); xPlayer[id][FrozenByFreeze] = true;
			if (id != playerid) { format(string,128,"Administrator \"%s\" has frozen \"%s\".",name,ActionName); return SendClientMessageToAll(yellow,string); }
			else { format(string,128,"Administrator \"%s\" has frozen himself.",name); return SendClientMessageToAll(yellow,string); }
		} else return SendClientMessage(playerid,red,"ERROR: You can not freeze a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"freeze");
}
dcmd_unf(playerid,params[]) return dcmd_unfreeze(playerid,params);
dcmd_unfreeze(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"unfreeze")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/UNF <NICK OR ID>\".");
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			if(xPlayer[id][AdminAFK])
				if (id != playerid) return SendClientMessage(playerid,red,"ERROR: This player is AFK.");
				else return SendClientMessage(playerid,red,"ERROR: You are AFK, please use /aafk to un-freeze yourself.");
			SendACommandMessageToAdmins(playerid,"unfreeze",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			TogglePlayerControllable(id,true); xPlayer[id][FrozenByFreeze] = false;
			if(id != playerid) { format(string,128,"Administrator \"%s\" has unfrozen \"%s\".",name,ActionName); return SendClientMessageToAll(yellow,string); }
			else return SendClientMessage(playerid,yellow,"You have unfrozen yourself.");
		} else return SendClientMessage(playerid,red,"ERROR: You can not unfreeze a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"unfreeze");
}
dcmd_outsideall(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"outsideall")) {
		SendACommandMessageToAdmins(playerid,"outsideall",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetPlayerInterior(i,0);
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Administrator \"%s\" has transfered everyone outside.",name); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"outsideall");
}
dcmd_healall(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"healall")) {
		SendACommandMessageToAdmins(playerid,"healall",params);
 		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetPlayerHealth(i,100.0);
 		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Everyone has been healed by Administrator \"%s\".",name); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"healall");
}
dcmd_sb(playerid,params[])
{
	#pragma unused params
	if(Config[DisplayServerMessage]) {
		new string[128], File[64] = "/xap/Configuration/Configuration.ini";
		if(dini_Int(File,"DisplayServerMessage")) { format(string,128,"Server Message: %s",dini_Get(File,"ServerMessage")); return SendClientMessage(playerid,green,string); }
		return SendClientMessage(playerid,red,"Server Message is OFF.");
	} else return SendClientMessage(playerid,red,"ERROR: The server message has been disabled.");
}
dcmd_setsm(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"setsm")) {
		SendACommandMessageToAdmins(playerid,"setsm",params);
		new File[64] = "/xap/Configuration/Configuration.ini";
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/SETSM <TEXT | OFF>\".");
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		if(!strcmp(params,"off",true))
		{
			dini_IntSet(File,"DisplayServerMessage",0); Config[DisplayServerMessage] = false;
			format(string,128,"Administartor \"%s\" has disabled the server message.",name);
			return SendMessageToAdmins(lgreen, string);
		}
		dini_IntSet(File,"DisplayServerMessage",1); Config[DisplayServerMessage] = true;
		dini_Set(File,"ServerMessage",params);
		format(string,128,"New Server Message by Administartor \"%s\": %s",name,params);
		return SendMessageToAdmins(lgreen, string);
	} else return SendLevelErrorMessage(playerid,"setsm");
}
dcmd_uconfig(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"uconfig")) {
		SendACommandMessageToAdmins(playerid,"unconfig",params);
		UpdateConfigurationVariables();
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Administrator \"%s\" has updated the configuration variables.",name);
		SendMessageToAdmins(lgreen, string);
		return 1;
	} else return SendLevelErrorMessage(playerid,"uconfig");
}
dcmd_sethp(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"sethp")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||
		!(strval(tmp2) >= 0 && strval(tmp2) <= 100)) return SendClientMessage(playerid,red,"Syntax Error: \"/SETHP <NICK OR ID> <0-100>\".");
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"sethp",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has set your health to %d percent.",name,strval(tmp2)); SendClientMessage(id,yellow,string);
				format(string,128,"Administrator \"%s\" has set \"%s's\" health to %d percent.",name,ActionName,strval(tmp2)); SendMessageToAdminsEx2(playerid,id,lgreen,string);
				format(string,128,"You have set \"%s's\" health to %d percent.",ActionName,strval(tmp2)); SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You've set your health to %d percent.",strval(tmp2)); SendClientMessage(playerid,yellow,string); }
			return SetPlayerHealth(id,strval(tmp2));
		} return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's health.");
	} else return SendLevelErrorMessage(playerid,"sethp");
}
dcmd_skinall(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"skinall")) {
		if(!strlen(params)||!IsNumeric(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/SKINALL <SKINID>\".");
		if(IsSkinValid(strval(params))) {
			SendACommandMessageToAdmins(playerid,"skinall",params);
			new string[128],name[24]; GetPlayerName(playerid,name,24);
			for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetPlayerSkin(i,strval(params));
			format(string,128,"Everyone's skin has been changed to ID %d.",strval(params)); return SendClientMessageToAll(yellow,string);
		} else return SendClientMessage(playerid,red,"ERROR: Invalid skin ID.");
	} else return SendLevelErrorMessage(playerid,"skinall");
}
dcmd_gaweapon(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"gaweapon")) {
		new tmp[128], tmp2[128], Index; tmp = strtok(params,Index); tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||
		!(strval(tmp2) <= 0 || strval(tmp2) <= 10000)) return SendClientMessage(playerid,red,"Syntax Error: \"/GAWEAPON <WEAPON NAME | ID> <1-10,000>\".");
		new id; if(!IsNumeric(tmp)) id = ReturnWeaponID(tmp); else id = strval(tmp);
		if(id == -1||id==19||id==20||id==21||id==0||id==44||id==45) return SendClientMessage(playerid,red,"ERROR: You have selected an invalid weapon ID.");
		SendACommandMessageToAdmins(playerid,"gaweapon",params);
		new string[128],name[24],WeaponName[24]; GetWeaponName(id,WeaponName,24); if(id == 18) WeaponName = "Molotov";
		GetPlayerName(playerid,name,24); for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) GivePlayerWeapon(i,id,strval(tmp2));
		format(string,128,"Everyone has been given %d \'%s\' by Administrator \"%s\".",strval(tmp2),WeaponName,name);
		return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"gaweapon");
}
dcmd_raweapons(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"raweapons")) {
		SendACommandMessageToAdmins(playerid,"raweapons",params);
		new string[128],name[24]; GetPlayerName(playerid,name,24); for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) ResetPlayerWeapons(i);
		format(string,128,"Administrator \"%s\" has reseted everyone's weapons.",name); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"raweapons");
}
dcmd_setmoney(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"setmoney")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||
		!(strval(tmp2) >= 1 && strval(tmp2) <= 1000000)) return SendClientMessage(playerid,red,"Syntax Error: \"/SETMONEY <NICK OR ID> <1 - 1,000,000>\".");
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"setmoney",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
			format(string,128,"Administrator \"%s\" has set your money to $%d.",name,strval(tmp2)); SendClientMessage(id,yellow,string);
			format(string,128,"Administrator \"%s\" has set \"%s's\" money to $%d.",name,ActionName,strval(tmp2)); SendMessageToAdminsEx2(playerid,id,lgreen,string);
			format(string,128,"You have set \"%s's\" money to $%d.",ActionName,strval(tmp2)); SendClientMessage(playerid,yellow,string); }
			else { format(string,128,"You have set your money to $%d.",strval(tmp2)); SendClientMessage(playerid,yellow,string); }
			ResetPlayerMoney(id);
			GivePlayerMoney(id,strval(tmp2));
			return 1;
		} return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's money.");
	} else return SendLevelErrorMessage(playerid,"setmoney");
}

dcmd_gm(playerid,params[]) return dcmd_givemoney(playerid,params);
dcmd_givemoney(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"givemoney")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||
		!(strval(tmp2) >= 1 && strval(tmp2) <= 1000000)) return SendClientMessage(playerid,red,"Syntax Error: \"/GIVEMONEY <NICK OR ID> <1 - 1,000,000>\".");
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"givemoney",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has given you $%d.",name,strval(tmp2)); SendClientMessage(id,yellow,string);
				format(string,128,"Administrator \"%s\" has given \"%s\" $%d.",name,ActionName,strval(tmp2)); SendMessageToAdminsEx2(playerid,id,lgreen,string);
				format(string,128,"You have given \"%s\" $%d.",ActionName,strval(tmp2)); SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You have given yourself $%d.",strval(tmp2)); SendClientMessage(playerid,yellow,string); }
			GivePlayerMoney(id,strval(tmp2));
			return 1;
		} return SendClientMessage(playerid,red,"ERROR: You can not give a disconnected player money.");
	} else return SendLevelErrorMessage(playerid,"givemoney");
}

dcmd_remmoney(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"remmoney")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||
		!(strval(tmp2) >= 1 && strval(tmp2) <= 1000000)) return SendClientMessage(playerid,red,"Syntax Error: \"/REMMONEY <NICK OR ID> <1 - 1,000,000>\".");
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"remmoney",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has removed $%d from your money.",name,strval(tmp2)); SendClientMessage(id,yellow,string);
				format(string,128,"You have removed $%d from \"%s's\" money.",strval(tmp2),ActionName); SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You have removed $%d from your money.",strval(tmp2)); SendClientMessage(playerid,yellow,string); }
			GivePlayerMoney(id,-strval(tmp2));
			return 1;
		} return SendClientMessage(playerid,red,"ERROR: You can not remove a disconnected player's money.");
	} else return SendLevelErrorMessage(playerid,"remmoney");
}
dcmd_resetmoney(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"resetmoney")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/RESETMONEY <NICK OR ID>\".");
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"resetmoney",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has reseted your money.",name); SendClientMessage(id,yellow,string);
				format(string,128,"You have reseted \"%s's\" money.",ActionName); SendClientMessage(playerid,yellow,string);
			} else SendClientMessage(playerid,yellow,"You have reseted your money.");
			return ResetPlayerMoney(id);
		} else return SendClientMessage(playerid,red,"ERROR: You can not reset a disconnected player's money.");
	} else return SendLevelErrorMessage(playerid,"resetmoney");
}
dcmd_samoney(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"samoney")) {
		if(!strlen(params)||!IsNumeric(params)||
		!(strval(params)>=0&&strval(params)<=1000000)) return SendClientMessage(playerid,red,"Syntax Error: \"/SAMONEY <1 - 1,000,000>\".");
		SendACommandMessageToAdmins(playerid,"samoney",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) {
			ResetPlayerMoney(i);
			GivePlayerMoney(i,strval(params));
		}
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Administrator \"%s\" has set every player's money to $%d.",name,strval(params)); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"samoney");
}
dcmd_gamoney(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"gamoney")) {
		if(!strlen(params)||!IsNumeric(params)||
		!(strval(params)>=0&&strval(params)<=1000000)) return SendClientMessage(playerid,red,"Syntax Error: \"/GAMONEY <1 - 1,000,000>\".");
		SendACommandMessageToAdmins(playerid,"gamoney",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) {
			GivePlayerMoney(i,strval(params));
		}
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Administrator \"%s\" has given every player $%d.",name,strval(params)); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"gamoney");
}
dcmd_remamoney(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"remamoney")) {
		if(!strlen(params)||!(strval(params)>=0&&
		strval(params)<=1000000)) return SendClientMessage(playerid,red,"Syntax Error: \"/REMAMONEY <1 - 1,000,000>\".");
		SendACommandMessageToAdmins(playerid,"remamoney",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) {
			GivePlayerMoney(i,-strval(params));
		}
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Administrator \"%s\" has removed $%d from everyone's money.",name,strval(params)); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"remamoney");
}
dcmd_ramoney(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"ramoney")) {
		SendACommandMessageToAdmins(playerid,"ramoney",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) ResetPlayerMoney(i);
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Administrator \"%s\" resetted everyone's money.",name); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"ramoney");
}
dcmd_ejectall(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"ejectall")) {
		SendACommandMessageToAdmins(playerid,"ejectall",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && IsPlayerInAnyVehicle(i)) RemovePlayerFromVehicle(i);
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Administrator \"%s\" has ejected everyone from their vehicle.",name); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"ejectall");
}
dcmd_fall(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"fall")) {
		SendACommandMessageToAdmins(playerid,"fall",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && IsPlayerSpawned(i)) {
			TogglePlayerControllable(i,false); xPlayer[i][FrozenByFreeze] = true;
		}
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Administrator \"%s\" has frozen everyone.",name); SendMessageToAdminsEx(playerid,lgreen,string);
		return SendClientMessage(playerid,yellow,"You have frozen everyone.");
	} else return SendLevelErrorMessage(playerid,"fall");
}
dcmd_unfall(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"unfall")) {
		SendACommandMessageToAdmins(playerid,"unfall",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)&&IsPlayerSpawned(i)) {
			TogglePlayerControllable(i,true); xPlayer[i][FrozenByFreeze] = false;
		}
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Administrator \"%s\" has unfrozen everyone.",name); SendMessageToAdminsEx(playerid,lgreen,string);
		return SendClientMessage(playerid,yellow,"You have unfrozen everyone.");
	} else return SendLevelErrorMessage(playerid,"unfall");
}
dcmd_gw(playerid,params[]) return dcmd_giveweapon(playerid,params);
dcmd_giveweapon(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"giveweapon")) {
		new tmp[128], tmp2[128], tmp3[128], Index; tmp = strtok(params,Index),tmp2 = strtok(params,Index),tmp3 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!strlen(tmp3)||!IsNumeric(tmp3)||!(strval(tmp3) <= 0 ||
		strval(tmp3) <= 10000)) return SendClientMessage(playerid,red,"Syntax Error: \"/GIVEWEPAON <NICK OR ID> <WEAPON NAME | ID> <1-10,000>\".");
		new id,id2; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp); if(!IsNumeric(tmp2)) id2 = ReturnWeaponID(tmp2); else id2 = strval(tmp2);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			if(id2==-1||id2==19||id2==20||id2==21||id2==0||id2==44||id2==45) return SendClientMessage(playerid,red,"ERROR: You have selected an invalid weapon ID.");
			SendACommandMessageToAdmins(playerid,"giveweapon",params);
			new string[128],name[24],ActionName[24],WeaponName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			GetWeaponName(id2,WeaponName,24); if(id2 == 18) WeaponName = "Molotov";
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has given you %d %s.",name,strval(tmp3),WeaponName); SendClientMessage(id,yellow,string);
				format(string,128,"Administrator \"%s\" has given \"%s\" %d %s.",name,ActionName,strval(tmp3),WeaponName); SendMessageToAdminsEx2(playerid,id,lgreen,string);
				format(string,128,"You have given \"%s\" %d %s.",ActionName,strval(tmp3),WeaponName); SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You have given yourself %d %s.",strval(tmp3),WeaponName); SendClientMessage(playerid,yellow,string); }
			return GivePlayerWeapon(id,id2,strval(tmp3));
		} else return SendClientMessage(playerid,red,"ERROR: You can not give a disconnected player a weapon.");
	} else return SendLevelErrorMessage(playerid,"giveweapon");
}
dcmd_god(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"god")) {
		SendACommandMessageToAdmins(playerid,"god",params);
		if(strlen(params))
		{
			if(IsNumeric(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/GOD (<OFF>)\".");
			if(!strcmp(params,"off",true))
			{
				if(Config[GodWeapons]) ResetPlayerWeapons(playerid);
				SetPlayerHealth(playerid,100);
				SetPVarInt(playerid,"God",0);
				return SendClientMessage(playerid,yellow,"You have given yourself normal health.");
			}
		}
		else
		{
			if(!Config[GodWeapons])
			{
				SetPlayerHealth(playerid,1000000);
				SetPVarInt(playerid,"God",1);
				return SendClientMessage(playerid,yellow,"You have given yourself infinite health.");
			}
			else
			{
				SetPlayerHealth(playerid,1000000);
				GivePlayerWeapon(playerid,38,50000);
				GivePlayerWeapon(playerid,WEAPON_GRENADE,50000);
				return SendClientMessage(playerid,yellow,"You have given yourself infinite health, minigun & grenades.");
			}
		}
	} else return SendLevelErrorMessage(playerid,"god");
	return 1;
}
dcmd_rscores(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"rscores")) {
		SendACommandMessageToAdmins(playerid,"rscores",params);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetPlayerScore(i,0);
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Administrator \"%s\" resetted everyone's score.",name);
		return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"rscores");
}
dcmd_setxlevel(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"setxlevel")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||!(strval(tmp2) >= 0 && strval(tmp2) <= Config[MaxLevel])) {
			new string[128];
			format(string,128,"Syntax Error: \"/SETXLEVEL <NICK OR ID> <0 - %d>\".",Config[MaxLevel]);
			return SendClientMessage(playerid,red,string);
		}
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			if(xPlayer[id][TMPLevel]) return SendClientMessage(playerid,red,"ERROR: That player has a temp-level.");
  			if(Variables[id][Level] == strval(tmp2)) return SendClientMessage(playerid,red,"ERROR: That player is already that level.");
  			if(!dini_Exists(GetPlayerFile(id))) CreateUserConfigFile(id);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			SendACommandMessageToAdmins(playerid,"setxlevel",params);
			format(string,128,"Administrator \"%s\" has %s you to %s [%d].",name, ((strval(tmp2) >= Variables[id][Level])?("promoted"):("demoted")),
			((strval(tmp2))?("Administrator"):("Member Status")),strval(tmp2));
			SendClientMessage(id,yellow,string);
			format(string,128,"You have %s \"%s\" to %s [%d].",((strval(tmp2) >= Variables[id][Level])?("promoted"):("demoted")),ActionName,
			((strval(tmp2))?("Administrator"):("Member Status")),strval(tmp2)); SendClientMessage(playerid,yellow,string);
			Variables[id][Level] = strval(tmp2); SetUserInt(id,"Level",strval(tmp2));
			Variables[id][LoggedIn] = false; SetUserInt(id,"LoggedIn",0);
			if(!strval(tmp2)) dini_Remove(GetPlayerFile(id));
			OnPlayerConnect(id);
		} else return SendClientMessage(playerid,red,"ERROR: You can not set your or a disconnected player's level.");
	} else return SendLevelErrorMessage(playerid,"setxlevel");
	return 1;
}
dcmd_setskin(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"setskin")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)) return SendClientMessage(playerid,red,"Syntax Error: \"/SETSKIN <NICK OR ID> <SKINID>\".");
		if(!IsSkinValid(strval(tmp2))) return SendClientMessage(playerid,red,"ERROR: Invalid skin ID.");
  		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			SendACommandMessageToAdmins(playerid,"setskin",params);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has set your skin to ID %d.",name,strval(tmp2)); SendClientMessage(id,yellow,string);
				format(string,128,"You have set \"%s's\" skin ID to %d.",ActionName,strval(tmp2)); SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You have set your skin ID to %d.",strval(tmp2)); SendClientMessage(playerid,yellow,string); }
			return SetPlayerSkin(id,strval(tmp2));
		} return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's skin.");
	} else return SendLevelErrorMessage(playerid,"setskin");
}
dcmd_setar(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"setar")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||
		!(strval(tmp2) >= 1 && strval(tmp2) <= 100)) return SendClientMessage(playerid,red,"Syntax Error: \"/SETAR <NICK OR ID> <1-100>\".");
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"setar",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has set your armor to %d.",name,strval(tmp2)); SendClientMessage(id,yellow,string);
				format(string,128,"Administrator \"%s\" has set \"%s's\" armor to %d percent.",name,ActionName,strval(tmp2)); SendMessageToAdminsEx2(playerid,id,lgreen,string);
				format(string,128,"You set \"%s\'s\" armor to %d.",ActionName,strval(tmp2)); SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You have set your armor to %d.",strval(tmp2)); SendClientMessage(playerid,yellow,string); }
			return SetPlayerArmour(id,strval(tmp2));
		} return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's armor.");
	} else return SendLevelErrorMessage(playerid,"setar");
}
dcmd_armorall(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"armorall")) {
		SendACommandMessageToAdmins(playerid,"armorall",params);
 		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetPlayerArmour(i,100.0);
 		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Everyone's armor has been restored by Administrator \"%s\".",name); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"armorall");
}
dcmd_setammo(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"setammo")) {
		new tmp[128], tmp2[128], tmp3[128], Index; tmp = strtok(params,Index),tmp2 = strtok(params,Index),tmp3 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!strlen(tmp3)||!IsNumeric(tmp3)||!IsNumeric(tmp2)||
		!(strval(tmp3) <= 0 || strval(tmp3) <= 10000)) return SendClientMessage(playerid,red,"Syntax Error: \"/SETAMMO <NICK OR ID> <WEAPON SLOT> <1-10,000>\".");
		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			if(!(strval(tmp2) >= 0 && strval(tmp2) <= 12)) return SendClientMessage(playerid,red,"ERROR: Invalid weapon slot! Range: 0 - 12");
			SendACommandMessageToAdmins(playerid,"setammo",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has set your ammunition in slot \'%d\' to %d.",name,strval(tmp2),strval(tmp3));
				SendClientMessage(id,yellow,string);
				format(string,128,"You have set \"%s\'s\" ammunition in slot %d to %d.",ActionName,strval(tmp2),strval(tmp3));
				SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You have set your ammunition in slot \'%d\' to %d.",strval(tmp2),strval(tmp3)); SendClientMessage(playerid,yellow,string); }
			return SetPlayerAmmo(id,strval(tmp2),strval(tmp3));
		} else return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's ammunition.");
	} else return SendLevelErrorMessage(playerid,"setammo");
}
dcmd_setscore(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"setscore")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||
		!(strval(tmp2) >= 1 && strval(tmp2) <= 100000)) return SendClientMessage(playerid,red,"Syntax Error: \"/SETSCORE <NICK OR ID> <1-100,000>\".");
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"setscore",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has set your score to %d.",name,strval(tmp2)); SendClientMessage(id,yellow,string);
				format(string,128,"You set \"%s\'s\" score to %d.",ActionName,strval(tmp2)); SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You have set your score to %d.",strval(tmp2)); SendClientMessage(playerid,yellow,string); }
			return SetPlayerScore(id,strval(tmp2));
		} return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's score.");
	} else return SendLevelErrorMessage(playerid,"setscore");
}
dcmd_ip(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"ip")) {
		SendACommandMessageToAdmins(playerid,"ip",params);
		if(!strlen(params)) {
			new IP[128],string[128];
			GetPlayerIp(playerid,IP,128);
			format(string,128,"Your IP: \'%s\'",IP);
			return SendClientMessage(playerid,yellow,string);
		}
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			new string[128],ActionName[24],IP[128]; GetPlayerName(id,ActionName,24); GetPlayerIp(id,IP,128);
			format(string,128,"\"%s\'s\" IP: \'%s\'",ActionName,IP); return SendClientMessage(playerid,yellow,string);
		} else return SendClientMessage(playerid,red,"ERROR: You can not get the IP of a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"ip");
}
dcmd_ping(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"ping")) {
		SendACommandMessageToAdmins(playerid,"ping",params);
		if(!strlen(params)) {
			new string[128];
			format(string,128,"Your Ping: \'%d\'",GetPlayerPing(playerid));
			return SendClientMessage(playerid,yellow,string);
		}
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			new string[128],ActionName[24],IP[128]; GetPlayerName(id,ActionName,24); GetPlayerIp(id,IP,128);
			format(string,128,"\"%s\'s\" Ping: \'%d\'",ActionName,GetPlayerPing(id)); return SendClientMessage(playerid,yellow,string);
		} else return SendClientMessage(playerid,red,"ERROR: You can not get the ping of a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"ping");
}
dcmd_explode(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"explode")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/EXPLODE <NICK OR ID>\".");
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"explode",params);
			if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"explode");
  			new string[128],name[24],ActionName[24],Float:X,Float:Y,Float:Z; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(!IsPlayerInAnyVehicle(id)) GetPlayerPos(id,X,Y,Z);
			else GetVehiclePos(GetPlayerVehicleID(id),X,Y,Z); for(new i = 1; i <= 5; ++i) CreateExplosion(X,Y,Z,10,0);
			if(id != playerid) {
				//format(string,128,"Administrator \"%s\" has exploded \"%s\".",name,ActionName); SendMessageToAdminsEx(playerid, lgreen, string);
				format(string,128,"You have exploded Player \"%s\".",ActionName); return SendClientMessage(playerid,yellow,string);
			} else {
				if(Spec[playerid][Spectating] && Variables[Spec[playerid][SpectateID]][Level] > Variables[playerid][Level] && Variables[id][LoggedIn]) {
					new trystr[128],tryname[24]; GetPlayerName(playerid, tryname, 24);
					format(trystr,128,"[NOTE] \"%s\" has tried to %s you, but failed.",tryname,("explode")); SendClientMessage(id,red,tryname);
					format(trystr,128,"ERROR: You can not use this on player which is higher level then you.");
					return SendClientMessage(playerid,red,tryname);
				}
				format(string,128,"Administrator \"%s\" has exploded himself.",name); SendMessageToAdminsEx(playerid,lgreen,string);
				return SendClientMessage(playerid,yellow,"You have exploded yourself.");
			}
		} else return SendClientMessage(playerid,red,"ERROR: You can not explode a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"explode");
}
dcmd_settime(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"settime")) {
		new tmp[128], tmp2[128], tmp3[128], Index; tmp = strtok(params,Index),tmp2 = strtok(params,Index),tmp3 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!strlen(tmp3)||
		!IsNumeric(tmp2)||!IsNumeric(tmp3)) return SendClientMessage(playerid,red,"Syntax Error: \"/SETTIME <NICK OR ID> <HOUR> <MINUTE>\".");
		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"settime",params);
			new name[24],string[128],Hour[5],Minute[5],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			format(Hour,5,"%s%d",((strval(tmp2)<10)?("0"):("")),strval(tmp2)); format(Minute,5,"%s%d",((strval(tmp3)<10)?("0"):("")),strval(tmp3));
			if(id != playerid) {
			format(string,128,"Administrator \"%s\" has set your time to \'%s:%s\'.",name,Hour,Minute); SendClientMessage(id,yellow,string);
			format(string,128,"You have set \"%s's\" time to \'%s:%s\'.",ActionName,Hour,Minute); SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You have set your time to \'%s:%s\'.",Hour,Minute); SendClientMessage(playerid,yellow,string); }
			return SetPlayerTime(id,strval(tmp2),strval(tmp3));
		} else return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's time.");
	} else return SendLevelErrorMessage(playerid,"settime");
}
dcmd_satime(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"satime")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||
		!IsNumeric(tmp)||!IsNumeric(tmp2)) return SendClientMessage(playerid,red,"Syntax Error: \"/SATIME <HOUR> <MINUTE>\".");
		SendACommandMessageToAdmins(playerid,"satime",params);
		new name[24],string[128],Hour[5],Minute[5]; GetPlayerName(playerid,name,24);
		format(Hour,5,"%s%d",((strval(tmp)<10)?("0"):("")),strval(tmp)); format(Minute,5,"%s%d",((strval(tmp2)<10)?("0"):("")),strval(tmp2));
		format(string,128,"Administrator \"%s\" has set everyone's time to \'%s:%s\'.",name,Hour,Minute);
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetPlayerTime(i,strval(tmp),strval(tmp2)); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"satime");
}
dcmd_force(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"force")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/FORCE <NICK OR ID>\".");
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			SendACommandMessageToAdmins(playerid,"force",params);
			if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"force");
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			ForceClassSelection(id); SetPlayerHealth(id,0);
			format(string,128,"Administrator \"%s\" has forced you to the spawn selection screen.",name); SendClientMessage(id,yellow,string);
			format(string,128,"You have forced Player \"%s\" to the spawn selection screen.",ActionName); return SendClientMessage(playerid,yellow,string);
		} else return SendClientMessage(playerid,red,"ERROR: You can not force yourself or a disconnected player to the spawn selection screen.");
	} else return SendLevelErrorMessage(playerid,"force");
}
/*
dcmd_setwanted(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"setwanted")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||
		!(strval(tmp2) >= 0 && strval(tmp2) <= 6)) return SendClientMessage(playerid,red,"Syntax Error: \"/SETWANTED <NICK OR ID> <0-6>\".");
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"setwanted",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has set your wanted level to %d.",name,strval(tmp2)); SendClientMessage(id,yellow,string);
				format(string,128,"You set \"%s\'s\" wanted level to %d.",ActionName,strval(tmp2)); SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You have set your wanted level to %d.",strval(tmp2)); SendClientMessage(playerid,yellow,string); }
			return SetPlayerWantedLevel(id,strval(tmp2));
		} return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's wanted level.");
	} else return SendLevelErrorMessage(playerid,"setwanted");
}
*/
dcmd_sawanted(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"sawanted")) {
		if(!strlen(params)||!IsNumeric(params)||
		!(strval(params) >= 0 && strval(params) <= 6)) return SendClientMessage(playerid,red,"Syntax Error: \"/SAWANTED <0-6>\".");
		new name[24],string[128]; GetPlayerName(playerid,name,24);
		SendACommandMessageToAdmins(playerid,"sawanted",params);
		format(string,128,"Administrator \"%s\" has set everyone's wanted level to %d.",name,strval(params));
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetPlayerWantedLevel(i,strval(params)); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"sawanted");
}
dcmd_setworld(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"setworld")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||
		!(strval(tmp2) >= 0 && strval(tmp2) <= 255)) return SendClientMessage(playerid,red,"Syntax Error: \"/SETWORLD <NICK OR ID> <VIRT. WORLD ID>\".");
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"setworld",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has set your virtual world to %d.",name,strval(tmp2)); SendClientMessage(id,yellow,string);
				format(string,128,"You set \"%s\'s\" virtual world to %d.",ActionName,strval(tmp2)); SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You have set your virtual world to %d.",strval(tmp2)); SendClientMessage(playerid,yellow,string); }
			if (GetPlayerState(id) == 2) SetVehicleVirtualWorld(GetPlayerVehicleID(id), strval(tmp2));
			return SetPlayerVirtualWorld(id, strval(tmp2));
		} return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's virtual world.");
	} else return SendLevelErrorMessage(playerid,"setworld");
}
dcmd_saworld(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"saworld")) {
		if(!strlen(params)||!IsNumeric(params)||
		!(strval(params) >= 0 && strval(params) <= 255)) return SendClientMessage(playerid,red,"Syntax Error: \"/SAWORLD <VIRT. WORLD ID>\".");
		new name[24],string[128]; GetPlayerName(playerid,name,24);
		SendACommandMessageToAdmins(playerid,"saworld",params);
		format(string,128,"Administrator \"%s\" has set everyone's virtual world to %d.",name,strval(params));
		for(new i = 0; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i))
			{
				if (GetPlayerState(i) == 2) SetVehicleVirtualWorld(GetPlayerVehicleID(i), strval(params));
				SetPlayerVirtualWorld(i, strval(params));
			}
		}
		return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"saworld");
}
dcmd_sgravity(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"sgravity")) {
		if(!strlen(params)||!(strval(params)<=50&&strval(params)>=-50)) return SendClientMessage(playerid,red,"Syntax Error: \"/SGRAVITY <-50.0 - 50.0>\".");
		SendACommandMessageToAdmins(playerid,"sgravity",params);
		new string[128],name[24]; GetPlayerName(playerid,name,24); new Float:Gravity = floatstr(params);
		format(string,128,"Administrator \"%s\" has set the gravity to: \'%f\'.",name,Gravity);
		SetGravity(Gravity); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"sgravity");
}
dcmd_xlock(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"xlock")) {
		if(IsPlayerInAnyVehicle(playerid)) {
			SendACommandMessageToAdmins(playerid,"xlock",params);
			for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i,false,true);
			new string[128],name[24]; VehicleLockData[GetPlayerVehicleID(playerid)] = true; GetPlayerName(playerid,name,24);
			format(string,128,"Administrator \"%s\" has locked his vehicle.",name); return SendMessageToAdmins(lgreen,string);
		} else return SendClientMessage(playerid,red,"ERROR: You must be in a vehicle to lock.");
	} else return SendLevelErrorMessage(playerid,"xlock");
}
dcmd_xunlock(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"xunlock")) {
		if(IsPlayerInAnyVehicle(playerid)) {
			SendACommandMessageToAdmins(playerid,"xunlock",params);
			for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) SetVehicleParamsForPlayer(GetPlayerVehicleID(playerid),i,false,false);
			new string[128],name[24]; VehicleLockData[GetPlayerVehicleID(playerid)] = false; GetPlayerName(playerid,name,24);
			format(string,128,"Administrator \"%s\" has unlocked his vehicle.",name); return SendMessageToAdmins(lgreen,string);
		} else return SendClientMessage(playerid,red,"ERROR: You must be in a vehicle to unlock.");
	} else return SendLevelErrorMessage(playerid,"xunlock");
}
dcmd_carcolor(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"carcolor")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!(strval(tmp) >= 0 && strval(tmp) <= 255)||
		!IsNumeric(tmp)||!IsNumeric(tmp2)) return SendClientMessage(playerid,red,"Syntax Error: \"/CARCOLOR <COLOR 1> (<COLOR 2>)\".");
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"ERROR: You must be in a vehicle.");
		SendACommandMessageToAdmins(playerid,"carcolor",params);
		if(!strlen(tmp2)) tmp2 = tmp;
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"You have set your vehicle's color data to: [%d %d]",strval(tmp),strval(tmp2));
		return ChangeVehicleColor(GetPlayerVehicleID(playerid),strval(tmp),strval(tmp2));
	} else return SendLevelErrorMessage(playerid,"carcolor");
}
dcmd_gmx(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"gmx")) {
		SendACommandMessageToAdmins(playerid,"gmx",params);
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		format(string,128,"Administrator \"%s\" has restarted the game mode.",name); SendClientMessageToAll(yellow,string); return GameModeExit(), 1;
	} else return SendLevelErrorMessage(playerid,"gmx");
}
dcmd_carhealth(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"carhealth")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||
		!(strval(tmp2) >= 0 && strval(tmp2) <= 1000)) return SendClientMessage(playerid,red,"Syntax Error: \"/CARHEALTH <NICK OR ID> <0-1000>\".");
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			if(!IsPlayerInAnyVehicle(id)) return SendClientMessage(playerid,red,"ERROR: This player must be in a vehicle.");
			SendACommandMessageToAdmins(playerid,"carhealth",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has set your car's health to %.f percent.",name,floatdiv(strval(tmp2),10));
				if(IsPlayerXAdmin(id)) SendClientMessage(id,yellow,string);
				format(string,128,"You have set \"%s's\" car's health to %.f percent.",ActionName,floatdiv(strval(tmp2),10)); SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You've set your car's health to %.f percent.",floatdiv(strval(tmp2),10)); SendClientMessage(playerid,yellow,string); }
			RepairVehicle(GetPlayerVehicleID(id));
			return SetVehicleHealth(GetPlayerVehicleID(id),strval(tmp2));
		} return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's car health.");
	} else return SendLevelErrorMessage(playerid,"carhealth");
}
dcmd_xinfo(playerid,params[])
{
	#pragma unused params
	SendPlayerCommandToAdmins(playerid, "/xinfo");
	new string[128];
	if (IsPlayerXAdmin(playerid))
		format(string, 128, "[XAP v1.2");
	else
		format(string, 128, "[XAP");
	format(string, 128, "%s] Created by SharkyKH, based on Xtreme's Admin Script v2.2r1.", string);
	return SendClientMessage(playerid, green, string);
}
dcmd_serverinfo(playerid,params[])
{
	#pragma unused params
	new string[128]; format(string,128,"Server Information: [Players Connected: %d/%d || Ratio: %.2f]",
	GetConnectedPlayers(),MAX_PLAYERS,floatdiv(GetConnectedPlayers(),MAX_PLAYERS));
	SendPlayerCommandToAdmins(playerid,"/serverinfo");
	SendClientMessage(playerid,green,string);
	return SendClientMessage(playerid,green,"This server is using SharkyKH's xAp script, use /xinfo for more information.");
}
dcmd_setping(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"setping")) {
		if(!strlen(params)||!(strval(params) >= 0 &&
		strval(params) <= 10000)) return SendClientMessage(playerid,red,"Syntax Error: \"/SETPING <[0 / OFF] - 10,000>\".");
   		if(!IsNumeric(params)) {
   			if(!strcmp(params,"off",true)) { Config[MaxPing] = 0; SetConfigInt("MaxPing",0); }
   			else return SendClientMessage(playerid,red,"Syntax Error: \"/SETPING <[0 / OFF] - 10,000>\".");
   		}
		Config[MaxPing] = strval(params); SetConfigInt("MaxPing",strval(params));
		SendACommandMessageToAdmins(playerid,"setping",params);
		new string[128],name[24],Fo[30]; GetPlayerName(playerid,name,24); format(Fo,30,"to %d",Config[MaxPing]); if(!Config[MaxPing]) Fo = "off";
		format(string,128,"Administrator \"%s\" has set the Maximum Ping %s.",name,Fo); return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"setping");
}
dcmd_xspec(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"xspec")) {
		if (!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/XSPEC <NICK OR ID | OFF>\".");
		if (!strcmp(params, "off", true))
		{
			if (!Spec[playerid][Spectating]) return SendClientMessage(playerid,red,"ERROR: You must be spectating.");
			SendACommandMessageToAdmins(playerid, "xspec", params);
			return Spectate(playerid, -1, false);
		}
		new id; if (!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			if (Spec[id][Spectating]) return SendClientMessage(playerid,red,"Error: You can not spectate a player that is already spectating.");
			if (Spec[playerid][Spectating] && Spec[playerid][SpectateID] == id) return SendClientMessage(playerid,red,"ERROR: You are already spectating this player.");
			for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && Spec[i][Spectating] && Spec[i][SpectateID] == playerid)
			{
				TogglePlayerSpectating(i,false);
				Spec[i][Spectating] = false;
				Spec[i][SpectateID] = INVALID_PLAYER_ID;
				GameTextForPlayer(i,"~y~~h~~h~~h~Spectator Mode: ~r~OFF~n~~b~The admin is now spectating",5000,4);
			}
			SendACommandMessageToAdmins(playerid,"xspec",params);
			return Spectate(playerid, id, true);
		} else return SendClientMessage(playerid,red,"ERROR: You can not spectate yourself or a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"xspec");
}
dcmd_ntspec(playerid,params[])
{
	if(GetPVarInt(playerid,"NT") == 1) {
		if (!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/NTSPEC <NICK OR ID | OFF>\".");
		if (!strcmp(params, "off", true))
		{
			if (!Spec[playerid][Spectating]) return SendClientMessage(playerid,red,"ERROR: You must be spectating.");
			SendACommandMessageToAdmins(playerid, "ntspec", params);
			return Spectate(playerid, -1, false);
		}
		new id; if (!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			if (Spec[id][Spectating]) return SendClientMessage(playerid,red,"Error: You can not spectate a player that is already spectating.");
			if (Spec[playerid][Spectating] && Spec[playerid][SpectateID] == id) return SendClientMessage(playerid,red,"ERROR: You are already spectating this player.");
			for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && Spec[i][Spectating] && Spec[i][SpectateID] == playerid)
			{
				TogglePlayerSpectating(i,false);
				Spec[i][Spectating] = false;
				Spec[i][SpectateID] = INVALID_PLAYER_ID;
				GameTextForPlayer(i,"~y~~h~~h~~h~Spectator Mode: ~r~OFF~n~~b~The NightTeam is now spectating",5000,4);
			}
			SendACommandMessageToAdmins(playerid,"ntspec",params);
			return Spectate(playerid, id, true);
		} else return SendClientMessage(playerid,red,"ERROR: You can not spectate yourself or a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"ntspec");
}
dcmd_m(playerid,params[]) return dcmd_mute(playerid,params);
dcmd_mute(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"mute")) {
		new tmp[128],tmp2[128],reason[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index); reason = bigstr(params,Index);
   		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid,red,"Syntax Error: \"/MUTE <NICK OR ID> <0 | UNMUTE TIME> (<REASON>)\".");
	   	new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			if(!Variables[id][Muted]) {
				SendACommandMessageToAdmins(playerid,"mute",params);
				if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"mute");
				new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
				Variables[id][Muted] = true, Variables[id][MutedWarnings] = Config[MutedWarnings];
				if(strval(tmp2) > 0) {
					new nTime[16];
					FormatTime(strval(tmp2), nTime);
					xPlayer[id][TimerUnMute] = SetTimerEx("UnMutePlayer", (strval(tmp2)*1000), 0, "d", id);
					//SetPVarInt(id,"InMute",1);
					if (!strlen(reason)) format(string,128,"\"%s\" has been muted by Administrator {FF0000}\"%s\"{FFFF00} for %s.",ActionName,name,nTime);
					else
					{
						format(string,128,"\"%s\" has been muted by Administrator {FF0000}\"%s\"{FFFF00} for %s. (Reason: %s)",ActionName,name,nTime,reason);
						format(xPlayer[id][MuteInfo][mReason], 32, reason);
					}
				} else {
					if (!strlen(reason)) format(string,128,"\"%s\" has been muted by Administrator {FF0000}\"%s\"{FFFF00}.",ActionName,name);
					else
					{
						format(string,128,"\"%s\" has been muted by Administrator {FF0000}\"%s\"{FFFF00}. (Reason: %s)",ActionName,name,reason);
						format(xPlayer[id][MuteInfo][mReason], 32, reason);
					}
				}
				xPlayer[id][MuteInfo][mTime] = strval(tmp2);
				xPlayer[id][MuteInfo][mTimeLeft] = strval(tmp2);
				return SendClientMessageToAll(yellow,string);
			} else return SendClientMessage(playerid,red,"ERROR: This player has already been muted.");
		} else return SendClientMessage(playerid,red,"ERROR: You can not mute yourself or a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"mute");
}

dcmd_sm(playerid,params[]) return dcmd_smute(playerid,params);
dcmd_smute(playerid,params[])
{
	if(GetPVarInt(playerid,"Supporter") == 1) {
		new tmp[128],tmp2[128],reason[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index); reason = bigstr(params,Index);
   		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid,red,"Syntax Error: \"/SMUTE <NICK OR ID> <0 | UNMUTE TIME> (<REASON>)\".");
	   	new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			if(!Variables[id][Muted]) {
				SendACommandMessageToAdmins(playerid,"mute",params);
				if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"mute");
				new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
				Variables[id][Muted] = true, Variables[id][MutedWarnings] = Config[MutedWarnings];
				if(strval(tmp2) > 0) {
					new nTime[16];
					FormatTime(strval(tmp2), nTime);
					xPlayer[id][TimerUnMute] = SetTimerEx("UnMutePlayer", (strval(tmp2)*1000), 0, "d", id);
					if (!strlen(reason)) format(string,128,"\"%s\" has been muted by Supporter {0099FF}\"%s\"{FFFF00} for %s.",ActionName,name,nTime);
					else
					{
						format(string,128,"\"%s\" has been muted by Supporter {0099FF}\"%s\"{FFFF00} for %s. (Reason: %s)",ActionName,name,nTime,reason);
						format(xPlayer[id][MuteInfo][mReason], 32, reason);
					}
				} else {
					if (!strlen(reason)) format(string,128,"\"%s\" has been muted by Supporter {0099FF}\"%s\"{FFFF00}.",ActionName,name);
					else
					{
						format(string,128,"\"%s\" has been muted by Supporter {0099FF}\"%s\"{FFFF00}. (Reason: %s)",ActionName,name,reason);
						format(xPlayer[id][MuteInfo][mReason], 32, reason);
					}
				}
				xPlayer[id][MuteInfo][mTime] = strval(tmp2);
				xPlayer[id][MuteInfo][mTimeLeft] = strval(tmp2);
				return SendClientMessageToAll(yellow,string);
			} else return SendClientMessage(playerid,red,"ERROR: This player has already been muted.");
		} else return SendClientMessage(playerid,red,"ERROR: You can not mute yourself or a disconnected player.");
	} else return 0;
}
dcmd_sunm(playerid,params[]) return dcmd_sunmute(playerid,params);
dcmd_sunmute(playerid,params[])
{
	if(GetPVarInt(playerid,"Supporter") == 1) {
   		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/SUNMUTE <NICK OR ID>\".");
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			if(Variables[id][Muted]) {
				SendACommandMessageToAdmins(playerid,"unmute",params);
				new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
				KillTimer(xPlayer[id][TimerUnMute]); xPlayer[id][TimerUnMute] = -1;
				Variables[id][Muted] = false, Variables[id][MutedWarnings] = Config[MutedWarnings];
				ClearString(32, xPlayer[id][MuteInfo][mReason]);
				xPlayer[id][MuteInfo][mTime] = 0;
				xPlayer[id][MuteInfo][mTimeLeft] = 0;
				#if AM
				xPlayer[id][ChatWarnings] = 0;
				#endif
				if(id != playerid) {
					format(string,128,"\"%s\" has been unmuted by Supporter {6495ED}\"%s\"{FFFF00}.",ActionName,name); return SendClientMessageToAll(yellow,string);
				} else return SendClientMessage(playerid,yellow,"You have successfully unmuted yourself.");
			} else return SendClientMessage(playerid,red,"ERROR: This player is not muted.");
		} else return SendClientMessage(playerid,red,"ERROR: You can not unmute a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"unmute");
}
dcmd_unm(playerid,params[]) return dcmd_unmute(playerid,params);
dcmd_unmute(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"unmute")) {
   		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/UNMUTE <NICK OR ID>\".");
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			if(Variables[id][Muted]) {
			    //SetPVarInt(id,"InMute",0);
				SendACommandMessageToAdmins(playerid,"unmute",params);
				new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
				KillTimer(xPlayer[id][TimerUnMute]); xPlayer[id][TimerUnMute] = -1;
				Variables[id][Muted] = false, Variables[id][MutedWarnings] = Config[MutedWarnings];
				ClearString(32, xPlayer[id][MuteInfo][mReason]);
				xPlayer[id][MuteInfo][mTime] = 0;
				xPlayer[id][MuteInfo][mTimeLeft] = 0;
				#if AM
				xPlayer[id][ChatWarnings] = 0;
				#endif
				if(id != playerid) {
					format(string,128,"\"%s\" has been unmuted by Administrator {FF0000}\"%s\"{FFFF00}.",ActionName,name); return SendClientMessageToAll(yellow,string);
				} else return SendClientMessage(playerid,yellow,"You have successfully unmuted yourself.");
			} else return SendClientMessage(playerid,red,"ERROR: This player is not muted.");
		} else return SendClientMessage(playerid,red,"ERROR: You can not unmute a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"unmute");
}
dcmd_j(playerid,params[]) return dcmd_jail(playerid,params);
dcmd_jail(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"jail")) {
		new tmp[128],tmp2[128],reason[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index); reason = bigstr(params,Index);
		if(!strlen(tmp) || !strlen(tmp2) || !IsNumeric(tmp2)) return SendClientMessage(playerid,red,"Syntax Error: \"/JAIL <NICK OR ID> <0 | UNJAIL TIME> (<REASON>)\".");
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			if(Variables[id][Jailed]) return SendClientMessage(playerid,red,"ERROR: This player has already been jailed.");
			SendACommandMessageToAdmins(playerid,"jail",params);
			if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"jail");
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(strval(tmp2) > 0) {
				new nTime[16];
				FormatTime(strval(tmp2), nTime);
				xPlayer[id][TimerUnJail] = SetTimerEx("UnJailPlayer", (strval(tmp2)*1000), 0, "d", id);
				if (!strlen(reason)) format(string,128,"Administrator \"%s\" has jailed \"%s\" for %s.",name,ActionName,nTime);
				else
				{
					format(string,128,"Administrator \"%s\" has jailed \"%s\" for %s. (Reason: %s)",name,ActionName,nTime,reason);
					format(xPlayer[id][JailInfo][jReason], 32, reason);
				}
			} else {
				if (!strlen(reason)) format(string,128,"Administrator \"%s\" has jailed \"%s\".",name,ActionName);
				else
				{
					format(string,128,"Administrator \"%s\" has jailed \"%s\". (Reason: %s)",name,ActionName,reason);
					format(xPlayer[id][JailInfo][jReason], 32, reason);
				}
			}
			xPlayer[id][JailInfo][jTime] = strval(tmp2);
			xPlayer[id][JailInfo][jTimeLeft] = strval(tmp2);
			Variables[id][Jailed] = true;
			SetCameraBehindPlayer(id);
			TogglePlayerControllable(id,false);
			SetVehicleToRespawn(GetPlayerVehicleID(id));
			SetPlayerVirtualWorld(id, id+1);
			new Float:X, Float:Y, Float:Z; GetPlayerPos(id, X, Y, Z); SetPlayerPos(id, X+5, Y+5, Z+5);
			SetPlayerHealth(id,100000);
			ResetPlayerWeapons(id);
			new cell = random(sizeof(JailPositions));
			SetPlayerPos(id,JailPositions[cell][j_x],JailPositions[cell][j_y],JailPositions[cell][j_z]);
			SetPlayerInterior(id,JailPositions[cell][j_int]);
			SetPlayerFacingAngle(id,0);
			if(Spec[playerid][Spectating] && Spec[playerid][SpectateID] == id) {
			TogglePlayerSpectating(playerid,false);
			Spec[playerid][Spectating] = false;
			Spec[playerid][SpectateID] = INVALID_PLAYER_ID;
			GameTextForPlayer(playerid,"~y~~h~~h~~h~Spectator Mode: ~r~OFF~n~~b~The player has been ~r~jailed",200,4);
			SetTimerEx("RestorePlayerPosition",500,0,"i",playerid); }
			return SendClientMessageToAll(yellow,string);
		} else return SendClientMessage(playerid,red,"ERROR: You can not jail yourself or a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"jail");
}
dcmd_unj(playerid,params[]) return dcmd_unjail(playerid,params);
dcmd_unjail(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"unjail")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/UNJAIL <NICK OR ID>\".");
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			if(!Variables[id][Jailed]) return SendClientMessage(playerid,red,"ERROR: This player has already been unjailed.");
			SendACommandMessageToAdmins(playerid,"unjail",params);
			KillTimer(xPlayer[id][TimerUnJail]); xPlayer[id][TimerUnJail] = -1;
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has unjailed you.",name); SendClientMessage(id,yellow,string);
				format(string,128,"You have unjailed \"%s\".",ActionName); SendClientMessage(playerid,yellow,string);
				for (new i = 0; i < MAX_PLAYERS; ++i) {
					if (i != id && i != playerid) {
						format(string,128,"Administrator \"%s\" has unjailed \"%s\".",name,ActionName);
						SendClientMessage(i, yellow,string);
					}
				}
			} else SendClientMessage(playerid,yellow,"You have unjailed yourself.");
			ClearString(32, xPlayer[id][JailInfo][jReason]);
			xPlayer[id][JailInfo][jTime] = 0;
			xPlayer[id][JailInfo][jTimeLeft] = 0;
			Variables[id][Jailed] = false; SetPlayerInterior(id, 0);
			TogglePlayerControllable(id,true);
			SetPlayerVirtualWorld(id, 0);
			SetPlayerHealth(id,100.0);
			if(Spec[playerid][Spectating] && Spec[playerid][SpectateID] == id) {
			TogglePlayerSpectating(playerid,false);
			Spec[playerid][Spectating] = false;
			Spec[playerid][SpectateID] = INVALID_PLAYER_ID;
			GameTextForPlayer(playerid,"~y~~h~~h~~h~Spectator Mode: ~r~OFF~n~~b~The player has been ~r~unjailed",200,4);
			SetTimerEx("RestorePlayerPosition",500,0,"i",playerid); }
			return SpawnPlayer(id);
		} return SendClientMessage(playerid,red,"ERROR: You can not unjail a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"unjail");
}
dcmd_setname(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"setname")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
   	 	if(!strlen(tmp)||!strlen(tmp2)) return SendClientMessage(playerid,red,"Syntax Error: \"/SETNAME <NICK OR ID> <NEW NAME>\".");
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"setname",params);
			if(!IsNickValid(tmp2)) return SendClientMessage(playerid,red,"ERROR: The name you have entered is invalid.");
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has set your name to %s.",name,tmp2); SendClientMessage(id,yellow,string);
				format(string,128,"You have set \"%s's\" name to %s.",ActionName,tmp2); SendClientMessage(playerid,yellow,string);
			} else { format(string,128,"You've set your name to %s.",tmp2); SendClientMessage(playerid,yellow,string); }
			SetPlayerName(id,tmp2); OnPlayerConnect(id); return 1;
		} return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's name.");
	} else return SendLevelErrorMessage(playerid,"setname");
}
/*
dcmd_ad(playerid,params[]) return dcmd_admins(playerid,params);
dcmd_admins(playerid,params[])
{
	if (!IsPlayerXAdmin(playerid)) return SendClientMessage(playerid,red,"Only admins can see the online admins list.");
	new Count,i,name[24],string[128];
	for(i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && Variables[i][Level] && Variables[i][LoggedIn]) Count++;
	if(!Count) { return SendClientMessage(playerid,red,"Admins Online:"), SendClientMessage(playerid,green,"None."); }
	if(Count >= 1) {
		new aCount;
		format(string,128,"Admins Online (%d):",Count);
		SendClientMessage(playerid,red,string);
		for(i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) {
			if(Variables[i][Level]) {
				new type; GetPlayerName(i,name,24);
				if (xPlayer[i][TMPLevel] && Variables[i][LoggedIn]) {
					if (!xPlayer[i][AdminAFK]) { aCount++; type = 2; format(string,128,"%d. %s [id: %d | level: %d] -- Temp Admin",aCount,name,i,Variables[i][Level]); }
					else { aCount++; type = 4; format(string,128,"%d. %s [id: %d | level: %d] -- Temp Admin | AFK",aCount,name,i,Variables[i][Level]); }
				} else if (!Variables[i][Registered]) {
					aCount++; type = 3; format(string,128,"%d. %s [id: %d | level: %d] -- Not Registered",aCount,name,i,Variables[i][Level]);
				} else if (!Variables[i][LoggedIn]) {
					aCount++; type = 3; format(string,128,"%d. %s [id: %d | level: %d] -- Not Logged In",aCount,name,i,Variables[i][Level]);
				} else if (Variables[i][LoggedIn]) {
					if (!xPlayer[i][AdminAFK]) { aCount++; type = 1; format(string,128,"%d. %s [id: %d | level: %d]",aCount,name,i,Variables[i][Level]); }
					else { aCount++; type = 4; format(string,128,"%d. %s [id: %d | level: %d] -- AFK",aCount,name,i,Variables[i][Level]); }
				}
				switch (type) {
				case 1: SendClientMessage(playerid,green,string); // Default
				case 2: SendClientMessage(playerid,green2,string); // Temp Admin
				case 3: SendClientMessage(playerid,green3,string); // Not Logged In
				case 4: SendClientMessage(playerid,purple,string); } // AFK
			}
		}
	}
	SendACommandMessageToAdmins(playerid,"admins",params);
	return 1;
}
*/
dcmd_vr(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"vr")) {
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"ERROR: You must be in a vehicle to repair.");
		RepairVehicle(GetPlayerVehicleID(playerid));
		SendACommandMessageToAdmins(playerid,"vr",params);
		return SendClientMessage(playerid,yellow,"You have successfully repaired your vehicle!");
	} else return SendLevelErrorMessage(playerid,"vr");
}
dcmd_xcmds(playerid,params[])
{
	if(!IsPlayerXAdmin(playerid)) return SendClientMessage(playerid,red,"ERROR: You must be an administrator to view these commands.");
	SendACommandMessageToAdmins(playerid,"xcmds",params);
	return ShowCommandsForAdmin(playerid);
}
//============================= [ New Commands ]==============================//
dcmd_c(playerid, params[])
{
	if(IsPlayerCommandLevel(playerid,"c")) {
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		for (new i = 0; i < MAX_PLAYERS; ++i) if (IsPlayerConnected(i) && !IsPlayerXAdmin(i)) for (new j=0; j<50; ++j) SendClientMessage(i,white," ");
		format(string, 128, "Administrator \"%s\" has cleaned the players chat.", name); SendMessageToAdmins(red, string);
		SendMessageToPlayers(red, "An administrator has cleaned the chat.");
		SendACommandMessageToAdmins(playerid,"c",params);
		return 1;
	} else return SendLevelErrorMessage(playerid,"c");
}
dcmd_pcmds(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"pcmds")) {
		if(!Variables[playerid][Commands]) {
			if (!xPlayer[playerid][TMPLevel]) SetUserInt(playerid,"Commands",1);
			Variables[playerid][Commands] = true;
			SendClientMessage(playerid,yellow,"Player commands monitoring is now enabled.");
		} else {
			if (!xPlayer[playerid][TMPLevel]) SetUserInt(playerid,"Commands",0);
			Variables[playerid][Commands] = false;
			SendClientMessage(playerid,yellow,"Player commands monitoring is now disabled.");
		}
		SendACommandMessageToAdmins(playerid,"pcmds",params);
		return 1;
	} else return SendLevelErrorMessage(playerid,"pcmds");
}
dcmd_acmds(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"acmds")) {
		if(!Variables[playerid][ACommands]) {
			if (!xPlayer[playerid][TMPLevel]) SetUserInt(playerid,"ACommands",1);
			Variables[playerid][ACommands] = true;
			SendClientMessage(playerid,yellow,"Admin commands monitoring is now enabled.");
		} else {
			if (!xPlayer[playerid][TMPLevel]) SetUserInt(playerid,"ACommands",0);
			Variables[playerid][ACommands] = false;
			SendClientMessage(playerid,yellow,"Admin commands monitoring is now disabled.");
		}
		SendACommandMessageToAdmins(playerid,"acmds",params);
		return 1;
	} else return SendLevelErrorMessage(playerid,"acmds");
}
dcmd_id(playerid,params[])
{
	if (!strlen(params)) { new m[128]; format(m,128,"Your ID: %d.",playerid); return SendClientMessage(playerid,green,m); }
	if (IsNumeric(params)) return SendClientMessage(playerid, red, "Syntax Error: \"/ID (<PART OF NAME>)\".");
	new bool:Found;
	for(new i = 0; i < MAX_PLAYERS; ++i) {
		if(IsPlayerConnected(i)) {
			new string[128], name[24];
			GetPlayerName(i,name,24);
			if(!IsNumeric(params) && strfind(name,params,true)!=-1) {
				format(string,128,"\"%s\" is ID %d", name, i);
				SendClientMessage(playerid,green,string);
				Found = true;
			}
		}
	}
	SendACommandMessageToAdmins(playerid,"id",params);
	if (!Found) SendClientMessage(playerid,red,"Player not found.");
	return 1;
}
dcmd_chat(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"chat")) {
		new aName[24], string[128]; GetPlayerName(playerid, aName, 24);
		if (!xVars[ChatSystem])
		{
			if (xVars[TimerChat] != -1) KillTimer(xVars[TimerChat]); xVars[TimerChat] = -1;
			xVars[ChatSystem] = true; for(new i=0;i<MAX_PLAYERS;++i) if(IsPlayerConnected(i)) xPlayer[i][LPT] = false;
			format(string, 128, "Administrator \"%s\" has enabled the public chat.", aName);
		} else {
			if (!IsNumeric(params)) return SendClientMessage(playerid, red, "Syntax Error: \"/CHAT (<TIME>)\".");
			if (strlen(params) || strval(params) > 0) {
				new nTime[16];
				FormatTime(strval(params), nTime);
				format(string, 128, "Administrator \"%s\" has disabled the public chat for %s.", aName, nTime);
				xVars[TimerChat] = SetTimerEx("AutoOpenChat", (strval(params)*1000), 0, "ib", 0, false);
			} else {
				format(string, 128, "Administrator \"%s\" has disabled the public chat.", aName);
			}
			xVars[ChatSystem] = false;
		}
		SendClientMessageToAll(red,string);
		SendACommandMessageToAdmins(playerid,"chat",params);
		return 1;
	} else return SendLevelErrorMessage(playerid,"chat");
}
dcmd_cd(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"cd")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if (xVars[TimerCountDown] != -1) return SendClientMessage(playerid, red, "ERROR: There is already a countdown running. [Use /kcd to kill it]");
		if (!IsLengthValid(tmp, 1, 5)||!IsNumeric(tmp)) return SendClientMessage(playerid, red, "Syntax Error: \"/CD <NUMBER> (0-2)\" | 0 - None, 1 - Freeze & Unfreeze All, 2 - Unfreeze All.");
		if (strlen(tmp2)&&!IsNumeric(tmp2)||strval(tmp2)>2||strval(tmp2)<0) return SendClientMessage(playerid, red, "Syntax Error: \"/CD <NUMBER> (<FREEZE>)\".");
		new string[128], aName[24]; GetPlayerName(playerid, aName, 24);
		CountDown(strval(tmp), strval(tmp2));
		if (strval(tmp2) == 1) xVars[CountDownFreeze] = true;
		new fs[128];
		if (!strlen(tmp2) || strval(tmp2) == 0) format(fs,128,"None");
		else if (strval(tmp2) == 1) format(fs,128,"Freeze & Unfreeze All");
		else if (strval(tmp2) == 2) format(fs,128,"Unfreeze All");
		new nTime[16];
		FormatTime(strval(tmp), nTime);
		format(string, 128, "Countdown started; Administrator: \"%s\", Time: %s, Freeze Status: %s.", aName, nTime, fs);
		SendMessageToAdmins(red, string);
		format(string, 128, "Administrator \"%s\" has started a countdown of %s.", aName, nTime);
		SendMessageToPlayers(yellow, string);
		SendACommandMessageToAdmins(playerid,"cd",params);
		return 1;
	} else return SendLevelErrorMessage(playerid,"cd");
}
dcmd_kcd(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"kcd")) {
		if (xVars[TimerCountDown] == -1) return SendClientMessage(playerid, red, "ERROR: There is no countdown running.");
		KillTimer(xVars[TimerCountDown]);
		xVars[TimerCountDown] = -1;
		if (xVars[CountDownFreeze])
		{
			for(new i = 0; i < MAX_PLAYERS; ++i) if (IsPlayerConnected(i) && IsPlayerSpawned(i) && !Variables[i][Jailed]
			&& !Variables[i][Frozen] && !xPlayer[i][AdminAFK] && xPlayer[i][FrozenByFreeze])
			{
				TogglePlayerControllable(i,true);
				xPlayer[i][FrozenByFreeze] = false;
			}
		}
		xVars[CountDownFreeze] = false;
		new string[128], aName[24]; GetPlayerName(playerid, aName, 24);
		format(string, 128, "Countdown stopped; Administrator: \"%s\".", aName); SendMessageToAdmins(red,string);
		format(string, 128, "Administrator \"%s\" has stopped the countdown.", aName); SendMessageToPlayers(yellow,string);
		SendACommandMessageToAdmins(playerid,"kcd",params);
	} else return SendLevelErrorMessage(playerid,"kcd");
	return 1;
}
dcmd_disarm(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"disarm")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/DISARM <NICK OR ID>\".");
   		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"disarm",params);
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24); ResetPlayerWeapons(id);
			if(id != playerid) {
				format(string,128,"You have been disarmed from your weapons by Administrator \"%s\".",name); SendClientMessage(id,yellow,string);
			   	format(string,128,"You have disarmed Player \"%s\".",ActionName); return SendClientMessage(playerid,yellow,string);
			} else return SendClientMessage(playerid,yellow,"You have disarmed yourself from your weapons.");
		} else return SendClientMessage(playerid,red,"ERROR: You can not disarm a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"disarm");
}
dcmd_report(playerid,params[])
{
	if (IsPlayerXAdmin(playerid)) return SendClientMessage(playerid,red,"ERROR: You are an admin, you can not use the report command.");
	new tmp[128],reason[128],Index; tmp = strtok(params,Index); reason = bigstr(params,Index);
	if (!strlen(tmp)||!strlen(reason)) return SendClientMessage(playerid,red,"Syntax Error: \"/REPORT <NICK OR ID> <REASON>\".");
	new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
	if (!IsPlayerConnected(id) || id == INVALID_PLAYER_ID) return SendClientMessage(playerid,red,"ERROR: You can not report a disconnected player.");
	if (id == playerid) return SendClientMessage(playerid,red,"ERROR: You can not report yourself.");
	if (IsPlayerXAdmin(id)) return SendClientMessage(playerid,red,"ERROR: You can not report an admin.");
	if (xPlayer[playerid][LastReportedID] == id) return SendClientMessage(playerid,red,"ERROR: You can report the same id only once in 60 seconds.");
	new string[128],Reporter[24],Reported[24];
	GetPlayerName(playerid,Reporter,24);
	GetPlayerName(id,Reported,24);
	format(string,128,"Report on \"%s\" (%d) from \"%s\" (%d): %s",Reported,id,Reporter,playerid,reason);
	SendMessageToAdmins(red,string);
	format(string,128,"You have reported \"%s\" (id: %d) for \"%s\". Thank you!",Reported,id,reason);
	SendClientMessage(playerid,green,string);
	new fileline[128]; format(fileline,128,"%s (%d) reported on %s (%d) [Reason: %s]\r\n",Reporter,playerid,Reported,id,reason);
	WriteToLog("reports",fileline);
	xPlayer[playerid][LastReportedID] = id;
	xPlayer[playerid][TimerReport] = SetTimerEx("ResetReportedID", 60000, 0, "i", playerid);
	return 1;
}
dcmd_snatime(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"snatime")) {
		if(!strlen(params)||!IsNumeric(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/SNATIME <0 | MINUTES>\".");
		if (strval(params) == 0) {
			if(!dini_Bool("/xap/Configuration/Announcements.ini","System")) return SendClientMessage(playerid,red,"ERROR: The system is already off.");
			KillTimer(xVars[TimerNews]); xVars[TimerNews] = -1;
			dini_BoolSet("/xap/Configuration/Announcements.ini","System",false);
			SendClientMessage(playerid,yellow,"You have set the \"Server News Announcement\" timer OFF.");
		} else {
			KillTimer(xVars[TimerNews]); xVars[TimerNews] = -1; xVars[TimerNews] = SetTimer("ServerNewsAnnouncement",(strval(params)*60*1000),1);
			new text[128]; format(text,128,"You have set the \"Server News Announcement\" timer to %d minutes.",strval(params));
			dini_BoolSet("/xap/Configuration/Announcements.ini","System",true);
			dini_IntSet("/xap/Configuration/Announcements.ini","Time",strval(params));
			SendClientMessage(playerid,yellow,text);
		}
		SendACommandMessageToAdmins(playerid,"snatime",params);
	} else return SendLevelErrorMessage(playerid,"snatime");
	return 1;
}
dcmd_snatext(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"snatext")) {
		new File[64]; File = "/xap/Configuration/Announcements.ini";
		if (!dini_Bool(File,"System")) return SendClientMessage(playerid,red,"ERROR: The news system is off.");
		SendACommandMessageToAdmins(playerid,"snatext",params);
		new tmp[128],reason[128],idx; tmp = strtok(params,idx); reason = bigstr(params,idx);
		new string[128],text[128];
		if (strlen(tmp)&&IsNumeric(tmp)&&strval(tmp)>0&&strval(tmp)<dini_Int(File, "MaxTexts")+1) {
			new fstr[24]; format(fstr,24,"Text%d",strval(tmp));
			if (strlen(reason)) {
				format(text,128,reason);
				if(strcmp(text, "off", true) == 0) {
					format(string,128,"You have set the \"Server News Announcement\" text (%d) off.",strval(tmp)); SendClientMessage(playerid,green,string);
					dini_Set(File,fstr,"None");
					return 1;
				}
				new NewsText[128],name[24]; GetPlayerName(playerid,name,24);
				format(string,128,"You have set the \"Server News Announcement\" text (%d) to:",strval(tmp)); SendClientMessage(playerid,red,string);
				format(NewsText,128,"(%s) %s",name,text); SendClientMessage(playerid,green,NewsText);
				dini_Set(File,fstr,NewsText);
				return 1;
			} else {
				new get[128]; get = dini_Get(File,fstr);
				if (strcmp(get, "None", true) == 0) {
					format(string,128,"Current \"Server News Announcement\" text (%d) is off",strval(tmp));
					SendClientMessage(playerid,green,string);
				} else {
					format(string,128,"Current \"Server News Announcement\" text (%d) is:",strval(tmp)); SendClientMessage(playerid,red,string);
					format(string,128,"%s",get); SendClientMessage(playerid,green,string);
				}
				return 1;
			}
		} else { format(string,128,"Syntax Error: \"/SNATEXT <1-%d> (<TEXT>)\".",dini_Int(File, "MaxTexts")); SendClientMessage(playerid,red,string); }
	} else return SendLevelErrorMessage(playerid,"snatext");
	return 1;
}
dcmd_sna(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"sna")) {
		new File[64]; format(File,64,"/xap/Configuration/Announcements.ini");
		if(!dini_Bool(File,"System")) return SendClientMessage(playerid,red,"ERROR: The news system is off.");
		new fstr[24],count,Texts[8][128];
		for(new i=1;i<=8;++i) { format(fstr,24,"Text%d",i); format(Texts[i-1],128,dini_Get(File,fstr)); if(strcmp(Texts[i-1],"None",true)) count++; }
		if(!count) return SendClientMessage(playerid,red,"ERROR: There are no text lines in the system.");
		ServerNewsAnnouncement();
		SendACommandMessageToAdmins(playerid,"sna",params);
	} else return SendLevelErrorMessage(playerid,"sna");
	return 1;
}
dcmd_saa(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"saa")) {
		if (!strlen(params)) return SendClientMessage(playerid, red, "Syntax Error: \"/SAA <TEXT>\".");
		ServerAdminsAnnouncement(playerid, params);
		SendACommandMessageToAdmins(playerid,"saa",params);
	} else return SendLevelErrorMessage(playerid,"saa");
	return 1;
}
dcmd_unban(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"unban")) {
		if (!strlen(params)) return SendClientMessage(playerid, red, "Syntax Error: \"/UNBAN <NAME>\".");
		if (TempBanCheck(params, 1)) return SendClientMessage(playerid, red, "This player is temp banned, please use \"/UNTB <NAME>\".");
		if (!BanCheck(params, 1)) return SendClientMessage(playerid, red, "This player is not banned.");
		new BanFile[64], IpBanFile[64]; format(BanFile, 64, "/xap/Bans/Names/%s.ini", params);
		new breason[128]; format(breason,128,dini_Get(BanFile, "Reason"));
		new string[128], File[64]; format(string, 128, "You have unbanned \"%s\".", params); format(File, 64, "/xap/Bans/Names/%s.ini", params);
		new fileline[128],name[24]; GetPlayerName(playerid,name,24);
		format(fileline,128,"%s (%d) unbanned %s [Reason: %s]\r\n",name,playerid,params,dini_Get(BanFile,"Reason"));
		WriteToLog("unbans",fileline);
		SendClientMessage(playerid,yellow,string);
		new mode_file[64]; format(mode_file,sizeof(mode_file), "FXP/%s.ini",params); dini_IntSet(mode_file,"IsBanned",0);
		if (dini_Exists(BanFile)) { format(IpBanFile, 64, "/xap/Bans/IP/%s.ini", dini_Get(BanFile, "IP")); if (dini_Exists(IpBanFile)) {
		dini_Remove(BanFile); dini_Remove(IpBanFile); } }
		SendACommandMessageToAdmins(playerid,"unban",params);
	} else return SendLevelErrorMessage(playerid,"unban");
	return 1;
}
dcmd_unbanip(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"unbanip")) {
		if (!strlen(params)) return SendClientMessage(playerid, red, "Syntax Error: \"/UNBANIP <IP>\".");
		if (TempBanCheck(params, 2)) return SendClientMessage(playerid, red, "This IP is temp banned, please use \"/UNTBIP <NAME>\".");
		if (!BanCheck(params, 2)) return SendClientMessage(playerid, red, "This IP is not banned.");
		new IpBanFile[64], BanFile[64]; format(IpBanFile, 64, "/xap/Bans/IP/%s.ini", params);
		new string[128], File[128];
		format(string, 128, "You have unbanned %s (\"%s\").", dini_Get(IpBanFile, "PlayerName"), params); format(File,64,"/xap/Bans/IP/%s.ini",params);
		new fileline[128],name[24]; GetPlayerName(playerid,name,24);
		format(fileline,128,"%s (%d) unbanned %s (%s) [Reason: %s]\r\n",name,playerid,params,dini_Get(File,"PlayerName"),dini_Get(File,"Reason"));
		WriteToLog("unbans",fileline);
		SendClientMessage(playerid,yellow,string);
		new mode_file[128]; format(mode_file,sizeof(mode_file), "FXP/%s.ini",dini_Get(IpBanFile, "PlayerName")); dini_IntSet(mode_file,"IsBanned",0);
		if (dini_Exists(IpBanFile)) { format(BanFile, 64, "/xap/Bans/Names/%s.ini", dini_Get(IpBanFile, "PlayerName")); if (dini_Exists(BanFile)) {
		dini_Remove(IpBanFile); dini_Remove(BanFile); } }
		SendACommandMessageToAdmins(playerid,"unbanip",params);
	} else return SendLevelErrorMessage(playerid,"unbanip");
	return 1;
}
dcmd_muted(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"muted"))
	{
		SendClientMessage(playerid,yellow,"Muted List:");
		new string[128], name[24], Count;
		for (new i = 0; i < MAX_PLAYERS; ++i)
		{
			if (Variables[i][Muted])
			{
				GetPlayerName(i, name, 24);
				new m_Reason[64]; if (strlen(xPlayer[i][MuteInfo][mReason])) format(m_Reason, 64, " [Reason: %s]", xPlayer[i][MuteInfo][mReason]);
				if (xPlayer[i][MuteInfo][mTime] > 0)
				{
					new m_Time[16], m_TimeLeft[16];
					FormatTime(xPlayer[i][MuteInfo][mTime], m_Time); FormatTime(xPlayer[i][MuteInfo][mTimeLeft], m_TimeLeft);
					format(string, 128, "%s (id: %d) [Time: %s] [Time Left: %s]%s", name, i, m_Time, m_TimeLeft, m_Reason);
				}
				else format(string, 128, "%s (id: %d) [Time: Unlimited]%s", name, i, m_Reason);
				SendClientMessage(playerid,green,string);
				Count++;
			}
		}
		if (!Count) SendClientMessage(playerid,green,"No one is muted.");
		SendACommandMessageToAdmins(playerid,"muted",params);
	} else return SendLevelErrorMessage(playerid,"muted");
	return 1;
}
dcmd_jailed(playerid, params[])
{
	if(IsPlayerCommandLevel(playerid,"jailed"))
	{
		SendClientMessage(playerid,yellow,"Jailed List:");
		new string[128], name[24], Count;
		for (new i = 0; i < MAX_PLAYERS; ++i)
		{
			if (Variables[i][Jailed])
			{
				new j_Reason[64]; if (strlen(xPlayer[i][JailInfo][jReason])) format(j_Reason, 64, " [Reason: %s]", xPlayer[i][JailInfo][jReason]);
				GetPlayerName(i, name, 24);
				if (xPlayer[i][JailInfo][jTime] > 0)
				{
					new j_Time[16], j_TimeLeft[16];
					FormatTime(xPlayer[i][JailInfo][jTime], j_Time); FormatTime(xPlayer[i][JailInfo][jTimeLeft], j_TimeLeft);
					format(string, 128, "%s (id: %d) [Time: %s] [Time Left: %s]%s", name, i, j_Time, j_TimeLeft, j_Reason);
				}
				else format(string, 128, "%s (id: %d) [Time: Unlimited]%s", name, i, j_Reason);
				SendClientMessage(playerid,green,string);
				Count++;
			}
		}
		if (!Count) SendClientMessage(playerid,green,"No one is jailed.");
		SendACommandMessageToAdmins(playerid,"jailed",params);
	} else return SendLevelErrorMessage(playerid,"jailed");
	return 1;
}
dcmd_ac(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"ac")) {
		new name[24], string[128]; GetPlayerName(playerid, name, 24);
		if (!xVars[AdminChat]) {
			if (xVars[TimerAChat] != -1) KillTimer(xVars[TimerAChat]); xVars[TimerAChat] = -1;
			xVars[AdminChat] = true;
			format(string, 128, "Administrator \"%s\" has enabled the admin chat.", name);
		} else {
			if (strlen(params)) {
				if (!IsNumeric(params)) return SendClientMessage(playerid, red, "Syntax Error: \"/AC (<TIME>)\".");
				new nTime[16]; FormatTime(strval(params), nTime);
				format(string, 128, "Administrator \"%s\" has disabled the admin chat for %s seconds.", name, nTime);
				xVars[TimerAChat] = SetTimerEx("AutoOpenChat", (strval(params)*1000), 0, "ib", 1, false);
			} else format(string, 128, "Administrator \"%s\" has disabled the admin chat.", name);
			xVars[AdminChat] = false;
		}
		SendMessageToAdmins(red, string);
		SendACommandMessageToAdmins(playerid,"ac",params);
	} else return SendLevelErrorMessage(playerid,"ac");
	return 1;
}
dcmd_spawnc(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"spawnc")) {
		if (!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/SPAWNC <MODEL NAME OR ID>\".");
		if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"ERROR: You must be out of a vehicle.");
		new id; if(!IsNumeric(params)) id = ReturnVehicleModel(params); else id = strval(params);
		if (id < 400 || id > 611) return SendClientMessage(playerid,red,"ERROR: Wrong model name \\ id (400-611).");
		SendACommandMessageToAdmins(playerid,"spawnc",params);
		new name[24],Float:X,Float:Y,Float:Z,Float:A; GetPlayerName(playerid,name,24); GetPlayerPos(playerid,X,Y,Z); GetPlayerFacingAngle(playerid,A);
		GetXYInFrontOfPlayer(playerid,X,Y,3.00);
		if (xPlayer[playerid][AdminVehicle] != 0)
		{
			AdminVehicleAction(playerid, xPlayer[playerid][AdminVehicle], 2);
			xPlayer[playerid][AdminVehicle] = CreateVehicle(id, X, Y, Z+1, A, -1, -1, -1);
			PutPlayerInVehicle(playerid, xPlayer[playerid][AdminVehicle], 0);
			return SendClientMessage(playerid, yellow, "You have changed your vehicle.");
		}
		xPlayer[playerid][AdminVehicle] = CreateVehicle(id, X, Y, Z+1, A, -1, -1, -1);
		PutPlayerInVehicle(playerid, xPlayer[playerid][AdminVehicle], 0);
		return SendClientMessage(playerid, yellow, "You have created your vehicle.");
	} else return SendLevelErrorMessage(playerid,"spawnc");
}
dcmd_spawnd(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"spawnd")) {
		new tmp[128], idx; tmp = strtok(params, idx);
		if (!xPlayer[playerid][AdminVehicle]) return SendClientMessage(playerid,red,"ERROR: You don't have a vehicle.");
		if (IsPlayerInVehicle(playerid, xPlayer[playerid][AdminVehicle])) return SendClientMessage(playerid,red,"ERROR: You must be out of the vehicle!");
		SendACommandMessageToAdmins(playerid,"spawnd",params);
		return AdminVehicleAction(playerid, xPlayer[playerid][AdminVehicle], 0);
	} else return SendLevelErrorMessage(playerid,"spawnd");
}
dcmd_spawncall(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"spawncall")) {
		if (!xPlayer[playerid][AdminVehicle]) return SendClientMessage(playerid,red,"ERROR: You don't have a vehicle.");
		if (IsPlayerInVehicle(playerid, xPlayer[playerid][AdminVehicle])) return SendClientMessage(playerid,red,"ERROR: You are already inside your vehicle!");
		if (IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,red,"ERROR: You must be out of a vehicle.");
		SendACommandMessageToAdmins(playerid,"spawncall",params);
		return AdminVehicleAction(playerid, xPlayer[playerid][AdminVehicle], 1);
	} else return SendLevelErrorMessage(playerid,"spawncall");
}
dcmd_xchangepass(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"xchangepass")) {
		if (Variables[playerid][LoggedIn] && Variables[playerid][Level]) {
			new astriks[16]; for (new i; i<strlen(params); ++i) astriks[i] = '*';
			SendACommandMessageToAdmins(playerid,"xchangepass",astriks);
			new string[128];
			if (!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/xchangepass <NEW PASSWORD>\".");
			dini_Set(GetPlayerFile(playerid), "Password", xap_md5(params));
			format(string,128,"SUCCESS: You have set your password to %s", params);
			SendClientMessage(playerid,green,string);
			OnPlayerConnect(playerid);
		} else return SendClientMessage(playerid,red,"ERROR: You must be logged in and an admin to use this command.");
	} else return SendLevelErrorMessage(playerid,"xchangepass");
	return 1;
}
dcmd_xvar(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"setvar")) {
		new string[128],name[24],tmp[128],tmp2[128],tmp3[128],idx; tmp = strtok(params, idx); tmp2 = strtok(params, idx); tmp3 = strtok(params, idx);
		if (!strlen(tmp)||!strlen(tmp2)) return SendClientMessage(playerid,red,"Syntax Error: \"/XVAR <NICK OR ID> <VAR NAME> (<VALUE>)\".");
		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"xvar",params);
			GetPlayerName(id, name, 24);
			if (dini_Isset(GetPlayerFile(id), tmp2) && strcmp(tmp2,"Password",true) && strcmp(tmp2,"IP",true) && strcmp(tmp2,"Level",true))
			{
				if (strlen(tmp3))
				{
					if (!IsNumeric(tmp3)) return SendClientMessage(playerid,red,"Syntax Error: \"/XVAR <NICK OR ID> <VAR NAME> (<VALUE>)\".");
					dini_IntSet(GetPlayerFile(id), tmp2, strval(tmp3));
					format(string,128,"You have set \"%s's\" '%s' to %d (%s)", name, tmp2, strval(tmp3), (strval(tmp3)==1)?("Yes"):("No"));
					SendClientMessage(playerid,yellow,string);
					return OnPlayerConnect(id);
				}
				else
				{
					format(string,128,"\"%s's\" '%s' is %d", name, tmp2, dini_Int(GetPlayerFile(id), tmp2));
					return SendClientMessage(playerid,yellow,string);
				}
			} else return SendClientMessage(playerid,red,"ERROR: This is not a valid variable name.");
		} else return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's variable.");
	} else return SendLevelErrorMessage(playerid,"setvar");
}
dcmd_xunlockall(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"xunlockall")) {
		new string[128],name[24]; GetPlayerName(playerid, name, 24);
		for (new i = 0; i < 700; ++i)
		{
			if (DoesVehicleExists(i))
			{
				for (new j = 0; j < MAX_PLAYERS; ++j)
				{
					if (IsPlayerConnected(j))
					{
						SetVehicleParamsForPlayer(i, j, 0, 0);
						VehicleLockData[i] = true;
					}
				}
			}
		}
		SendACommandMessageToAdmins(playerid,"xunlockall",params);
		format(string,128,"Administrator \"%s\" has unlocked all vehicles.",name);
		return SendClientMessageToAll(yellow,string);
	} else return SendLevelErrorMessage(playerid,"xunlockall");
}
dcmd_tmplevel(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"tmplevel")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||!(strval(tmp2) >= 0 && strval(tmp2) <= Config[MaxLevel])) {
			new string[128];
			format(string,128,"Syntax Error: \"/TMPLEVEL <NICK OR ID> <0 - %d>\".",Config[MaxLevel]);
			return SendClientMessage(playerid,red,string);
		}
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			if(Variables[id][Level] > Variables[playerid][Level]) return HigherLevelWarning(playerid,id,"tmp-level");
  			if(Variables[id][Level] == strval(tmp2)) return SendClientMessage(playerid,red,"ERROR: That player is already that level.");
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			SendACommandMessageToAdmins(playerid,"tmplevel",params);
			format(string,128,"Administrator \"%s\" has %s you to %s [%d] for the rest of the game, you are now logged in.",name,
			((strval(tmp2) >= Variables[id][Level])?("promoted"):("demoted")),((strval(tmp2))?("Administrator"):("Member Status")),strval(tmp2));
			SendClientMessage(id,yellow,string);
			format(string,128,"You have %s \"%s\" to %s [%d] for the rest of the game.",((strval(tmp2) >= Variables[id][Level])?("promoted"):("demoted")),
			ActionName,((strval(tmp2))?("Administrator"):("Member Status")),strval(tmp2));
			if (strval(tmp2) == 0)
			{
				format(string,128,"You have demoted \"%s\" to Member Status [%d] from the temp level.",ActionName,strval(tmp2));
				Variables[id][Level] = strval(tmp2);
				Variables[id][LoggedIn] = false;
				xPlayer[id][TMPLevel] = false;
				Variables[id][Commands] = false;
				Variables[id][ACommands] = false;
				Variables[id][PPMS] = false;
				dini_Remove(GetPlayerFile(id));
				OnPlayerConnect(id);
			} else {
				Variables[id][Level] = strval(tmp2);
				Variables[id][LoggedIn] = true;
				if (!xPlayer[id][TMPLevel]) {
				new msg[128]; format(msg, 128, "%s (id: %d) has logged into his temp admin account (Level: %d)", ActionName, id, Variables[id][Level]);
				SendMessageToAdminsEx(id,lgreen,msg); }
				xPlayer[id][TMPLevel] = true;
			}
			return SendClientMessage(playerid,yellow,string);
		} else return SendClientMessage(playerid,red,"ERROR: You can not set your or a disconnected player's level.");
	} else return SendLevelErrorMessage(playerid,"tmplevel");
}
dcmd_ppms(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"ppms")) {
		if(!Variables[playerid][PPMS]) {
			if (!xPlayer[playerid][TMPLevel]) SetUserInt(playerid,"PPMS",1);
			Variables[playerid][PPMS] = true;
			SendClientMessage(playerid,yellow,"Player private messages monitoring is now enabled.");
		} else {
			if (!xPlayer[playerid][TMPLevel]) SetUserInt(playerid,"PPMS",0);
			Variables[playerid][PPMS] = false;
			SendClientMessage(playerid,yellow,"Player private messages monitoring is now disabled.");
		}
		SendACommandMessageToAdmins(playerid,"ppms",params);
		return 1;
	} else return SendLevelErrorMessage(playerid,"ppms");
}
dcmd_plusz(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"plusz")) {
		if (!strlen(params)||strval(params)>10000||strval(params)<-10000||strval(params)==0) return SendClientMessage(playerid,red,"Syntax Error: \"/PLUSZ < (-10000) - (10000) >\".");
		SendACommandMessageToAdmins(playerid,"plusz",params);
		new string[128], Float:NewZ, Float:pos[3];
		NewZ = floatstr(params);
		if (!IsPlayerInAnyVehicle(playerid)) { GetPlayerPos(playerid, pos[0], pos[1], pos[2]); SetPlayerPos(playerid, pos[0], pos[1], pos[2]+NewZ); }
		else { GetVehiclePos(GetPlayerVehicleID(playerid), pos[0], pos[1], pos[2]); SetVehiclePos(GetPlayerVehicleID(playerid), pos[0], pos[1], pos[2]+NewZ); }
		format(string,128,"You have added %.f to your height (Z).",NewZ);
		return SendClientMessage(playerid,yellow,string);
	} else return SendLevelErrorMessage(playerid,"plusz");
}
dcmd_getslot(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"getslot")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
		if (!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||strval(tmp2)<0||strval(tmp2)>12) return SendClientMessage(playerid,red,"Syntax Error: \"/GETSLOT <NICK OR ID> <0 - 12>\".");
		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if (IsPlayerConnected(id) && id != playerid) {
			new string[128], name[24], wName[64], weapon, ammo;
			GetPlayerName(id, name, 24);
			GetPlayerWeaponData(id, strval(tmp2), weapon, ammo);
			GetWeaponName(weapon, wName, 64);
			if (weapon != 0) {
				format(string,128,"\"%s\" weapon in slot number %d is: %s (weaponid: %d) with %d ammo.",name,strval(tmp2),wName,weapon,ammo);
				SendClientMessage(playerid,yellow,string);
			} else {
				format(string,128,"\"%s\" weapon slot number %d is empty.",name,strval(tmp2),wName,weapon);
				SendClientMessage(playerid,red,string);
			}
			SendACommandMessageToAdmins(playerid,"getslot",params);
		} else return SendClientMessage(playerid,red,"ERROR: You can not get a disconnected player's weapon slot.");
	} else return SendLevelErrorMessage(playerid,"getslot");
	return 1;
}
dcmd_lpt(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"lpt")) {
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/LPT <NICK OR ID>\".");
		if(xVars[ChatSystem]) return SendClientMessage(playerid,red,"ERROR: There is no use, the chat is active.");
		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		if(IsPlayerXAdmin(id)) return SendClientMessage(playerid,red,"ERROR: This player is already an admin.");
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid) {
			new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			if(!xPlayer[id][LPT]) {
				format(string,128,"Administrator \"%s\" has let you talk in the closed chat.",name); SendClientMessage(id,yellow,string);
				format(string,128,"You have let \"%s\" talk in the closed chat.",ActionName); SendClientMessage(playerid,yellow,string);
				format(string,128,"Administrator \"%s\" has let \"%s\" talk in the closed chat.",name,ActionName); SendMessageToAdminsEx(playerid, lgreen, string);
				xPlayer[id][LPT] = true;
			} else {
				format(string,128,"Administrator \"%s\" has took your permission to talk in the closed chat.",name); SendClientMessage(id,yellow,string);
				format(string,128,"You have took \"%s's\" permission to talk in the closed chat.",ActionName); SendClientMessage(playerid,yellow,string);
				format(string,128,"Administrator \"%s\" has took \"%s's\" permission to talk in the closed chat.",name,ActionName); SendMessageToAdminsEx(playerid, lgreen, string);
				xPlayer[id][LPT] = false;
			}
			SendACommandMessageToAdmins(playerid,"lpt",params);
		} else return SendClientMessage(playerid,red,"ERROR: You can not set this option to yourself or disconnected players.");
	} else return SendLevelErrorMessage(playerid,"lpt");
	return 1;
}
dcmd_vrall(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"vrall")) {
		for (new i=0; i<MAX_VEHICLES; ++i) RepairVehicle(i);
		SendACommandMessageToAdmins(playerid,"vrall",params);
		return SendClientMessage(playerid,yellow,"You have successfully repaired all the vehicles!");
	} else return SendLevelErrorMessage(playerid,"vrall");
}
dcmd_givecar(playerid,params[])
{
	#pragma unused params
	if(IsPlayerCommandLevel(playerid,"givecar"))
	{
		if(Spec[playerid][Spectating]) return SendClientMessage(playerid,red,"ERROR: You must not be spectating.");
		if(IsPlayerInAnyVehicle(playerid))
		{
			new Car = GetPlayerVehicleID(playerid), Model = GetVehicleModel(Car);
			switch (Model)
			{
				case 581,509,481,462,521,463,510,522,461,448,471,468,586,523: return SendClientMessage(playerid,red,"ERROR: You can not add components to bikes!");
				case 548,425,417,487,488,497,563,447,469: return SendClientMessage(playerid,red,"ERROR: You can not add components to helicopters!");
				case 592,577,511,512,593,520,553,476,519,460,513: return SendClientMessage(playerid,red,"ERROR: You can not add components to airplanes!");
				case 472,473,493,595,484,430,453,452,446,454: return SendClientMessage(playerid,red,"ERROR: You can not add components to boats!");
			}
			if(IsValidMenu(xVars[GiveCar]))
			{
				TogglePlayerControllableEx(playerid,false);
				SetCameraBehindPlayer(playerid);
				return ShowMenuForPlayer(xVars[GiveCar],playerid);
			} else return SendClientMessage(playerid,red,"ERROR: The menu is invalid and can not be displayed!");
		} else return SendClientMessage(playerid,red,"ERROR: You must be in a vehicle.");
	} else return SendLevelErrorMessage(playerid,"givecar");
}
dcmd_ptp(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"ptp")) {
		new tmp1[128],tmp2[128],idx; tmp1 = strtok(params, idx); tmp2 = strtok(params, idx);
		if(!strlen(tmp1) || !strlen(tmp2)) return SendClientMessage(playerid,red,"Syntax Error: \"/PTP <1: NICK OR ID> <2: NICK OR ID>\".");
		new id1,id2;
		if(!IsNumeric(tmp1)) id1 = ReturnPlayerID(tmp1); else id1 = strval(tmp1);
		if(!IsNumeric(tmp2)) id2 = ReturnPlayerID(tmp2); else id2 = strval(tmp2);
		if(IsPlayerConnected(id1) && id1 != INVALID_PLAYER_ID && id1 != playerid && IsPlayerConnected(id2) && id2 != INVALID_PLAYER_ID && id2 != playerid) {
			SendACommandMessageToAdmins(playerid,"ptp",params);
			new string[128],ActionName1[24],ActionName2[24],AdminName[24],Float:X,Float:Y,Float:Z;
			GetPlayerName(id2,ActionName2,24); GetPlayerName(id1,ActionName1,24); GetPlayerName(playerid,AdminName,24);
			new Interior = GetPlayerInterior(id2);
			SetPlayerInterior(id1,Interior);
			SetPlayerVirtualWorld(id1,GetPlayerVirtualWorld(id2));
			GetPlayerPos(id2,X,Y,Z);
			new Float:NewXY[2]; GetXYInFrontOfPlayer(id2, NewXY[0], NewXY[1], 5.00);
			if(IsPlayerInAnyVehicle(id1)) {
				SetVehiclePos(GetPlayerVehicleID(id1),NewXY[0],NewXY[1],Z+Config[TeleportZOffset]);
				LinkVehicleToInterior(GetPlayerVehicleID(id1),Interior);
			} else SetPlayerPos(id1,NewXY[0],NewXY[1],Z+Config[TeleportZOffset]);
   			format(string,128,"You have teleported \"%s\" to \"%s's\" location.",ActionName1,ActionName2); SendClientMessage(playerid,yellow,string);
			format(string,128,"You have been teleported to \"%s's\" location by Administrator \"%s\".",ActionName2,AdminName); SendClientMessage(id1,yellow,string);
			format(string,128,"Administrator \"%s\" has teleported \"%s's\" to \"%s's\" location.",AdminName,ActionName1,ActionName2);
			for(new i=0;i<MAX_PLAYERS;++i) if(IsPlayerConnected(i)&&IsPlayerXAdmin(i)&&i!=playerid&&i!=id1&&i!=id2) SendClientMessage(i,lgreen,string);
			format(string,128,"\"%s\" has been teleported to your location by Administrator \"%s\".",ActionName1,AdminName); return SendClientMessage(id2,yellow,string);
  		} else return SendClientMessage(playerid,red,"ERROR: You can not teleport yourself or a disconnected player.");
	} else return SendLevelErrorMessage(playerid,"ptp");
}
dcmd_banned(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"banned")) {
		if (!strlen(params)) return SendClientMessage(playerid, red, "Syntax Error: \"/BANNED <NAME>\".");
		if (TempBanCheck(params, 1)) return TempBanInfo(playerid, params, 1);
		if (!BanCheck(params, 1)) return SendClientMessage(playerid, red, "This player is not banned.");
		new string[128], File[64]; format(File, 128, "/xap/Bans/Names/%s.ini", params);
		format(string, 128, "Ban Info: (Player: %s) (Admin: %s) (Reason: %s) (IP: %s)", params, dini_Get(File, "Admin"), dini_Get(File, "Reason"), dini_Get(File, "IP"));
		SendClientMessage(playerid,lblue,string);
		SendACommandMessageToAdmins(playerid,"banned",params);
		return 1;
	} else return SendLevelErrorMessage(playerid,"banned");
}
dcmd_bannedip(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"bannedip")) {
		if (!strlen(params)) return SendClientMessage(playerid, red, "Syntax Error: \"/BANNEDIP <IP>\".");
		if (TempBanCheck(params, 2)) return TempBanInfo(playerid, params, 2);
		if (!BanCheck(params, 2)) return SendClientMessage(playerid, red, "This IP is not banned.");
		new string[128], File[128]; format(File, 128, "/xap/Bans/IP/%s.ini", params);
		format(string, 128, "Ban Info: (Player: %s) (Admin: %s) (Reason: %s) (IP: %s)", dini_Get(File, "PlayerName"), dini_Get(File, "Admin"), dini_Get(File, "Reason"), params);
		SendClientMessage(playerid,lblue,string);
		SendACommandMessageToAdmins(playerid,"bannedip",params);
		return 1;
	} else return SendLevelErrorMessage(playerid,"bannedip");
}
dcmd_aafk(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"aafk")) {
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		if(!xPlayer[playerid][AdminAFK])
		{
			xPlayer[playerid][AdminAFK] = true;
			TogglePlayerControllable(playerid,false);
			format(string,128,"You are now AFK.%s",(!strlen(params))?(" (Reason: %s)",params):(""));
			SendClientMessage(playerid,grey,string);
			format(string,128,"\"%s\" is now AFK.%s",name,(!strlen(params))?(" (Reason: %s)",params):(""));
			SendMessageToAdminsEx(playerid,lgreen,string);
		}
		else
		{
			xPlayer[playerid][AdminAFK] = false;
			TogglePlayerControllable(playerid,true);
			SendClientMessage(playerid,grey,"You are now back to the game.");
			format(string,128,"\"%s\" is now back to the game.",name); SendMessageToAdminsEx(playerid,lgreen,string);
		}
		return 1;
	} else return SendLevelErrorMessage(playerid,"aafk");
}
dcmd_ct(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"ct")) {
		new tmp[128],tmp2[128],cmd[32],idx; tmp = strtok(params,idx); tmp2 = strtok(params,idx);
		if (!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||strval(tmp2)>2) {
		return SendClientMessage(playerid,red,"Syntax Error: \"/CT <TELEPORT COMMAND> <0-2>\". | <0/1/2 - Without/With Vehicle/Without Vehicle & Weapons>"); }
		if (tmp[0] == '/') format(cmd,32,tmp[1]);
		else format(cmd,32,tmp);
		new CTFile[64] = "/xap/CT.ini";
		if (dini_Isset(CTFile,cmd)) return SendClientMessage(playerid,red,"ERROR: There is already a temp-teleport under this command.");
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		new Float:x, Float:y, Float:z; GetPlayerPos(playerid, x, y, z);
		new file[128]; format(file,128,"%d %.4f %.4f %.4f", strval(tmp2), x, y, z);
		dini_Set(CTFile,cmd,file);
		format(string,128,"You have set a temp-teleport under the command \"/%s\", %s vehicle%s.",
		cmd,(strval(tmp2)==1)?("With"):("Without"),(strval(tmp2)==2)?(" and weapons"):("")); SendClientMessage(playerid,yellow,string);
		format(string,128,"Administrator \"%s\" has set a temp-teleport under the command \"/%s\", %s vehicle teleportation%s.",
		name,cmd,(strval(tmp2)==1)?("With"):("Without"),(strval(tmp2)==2)?(" and weapons"):("")); SendMessageToAdminsEx(playerid,lgreen,string);
		SendACommandMessageToAdmins(playerid,"ct",params);
		return 1;
	} else return SendLevelErrorMessage(playerid,"ct");
}
dcmd_ctd(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"ctd")) {
		if (!strlen(params)) return SendClientMessage(playerid, red, "Syntax Error: \"/CTD <TELEPORT COMMAND | ALL>\".");
		new string[128],cmd[32],name[24]; GetPlayerName(playerid,name,24);
		new CTFile[64] = "/xap/CT.ini";
		if (!strcmp(params, "all", true))
		{
			if (!dini_Exists(CTFile)) dini_Create(CTFile);
			else { dini_Remove(CTFile); dini_Create(CTFile); }
			SendACommandMessageToAdmins(playerid,"ctd",params);
			SendClientMessage(playerid,yellow,"You have unset all of the temp-teleport commands.");
			format(string,128,"Administrator \"%s\" has unset all of the temp-teleport commands \"/%s\".",name,params);
			return SendMessageToAdminsEx(playerid,lgreen,string);
		}
		if (params[0] == '/') format(cmd,32,params[1]);
		else format(cmd,32,params);
		if (!dini_Isset(CTFile,cmd)) return SendClientMessage(playerid, red, "ERROR: There is no temp-teleport under this command.");
		dini_Unset(CTFile,cmd);
		format(string,128,"You have unset the temp-teleport under the command \"/%s\".",cmd); SendClientMessage(playerid,yellow,string);
		format(string,128,"Administrator \"%s\" has unset the temp-teleport under the command \"/%s\".",name,cmd); SendMessageToAdminsEx(playerid,lgreen,string);
		SendACommandMessageToAdmins(playerid,"ctd",params);
		return 1;
	} else return SendLevelErrorMessage(playerid,"ctd");
}
dcmd_ctl(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"ctl")) {
		SendACommandMessageToAdmins(playerid,"ctl",params);
		new CTFile[64] = "/xap/CT.ini";
		new File:fileh = fopen(CTFile, io_read);
		new data[2048],string[128],name[24],number = 1; GetPlayerName(playerid,name,24);
		SendClientMessage(playerid,yellow,"Temp-Teleports List:");
		while (fread(fileh, data)) {
			StripNewLine(data);
			if (strlen(data)) {
				new cmd[128],seperator = strfind(data, "=");
				strmid(cmd,data,0,seperator,128);
				new getV[128],getX[128],getY[128],getZ[128],idx; getV = strtok(data,idx); getX = strtok(data,idx); getY = strtok(data,idx); getZ = strtok(data,idx);
				new v, Float:x, Float:y, Float:z; v = strval(getV[strlen(getV)-1]); x = floatstr(getX); y = floatstr(getY); z = floatstr(getZ);
				format(string,128,"%d. /%s - %s vehicle%s, Pos: (%.2f, %.2f, %.2f)",number,cmd,(v==1)?("With"):("Without"),(v==2)?(" and weapons"):(""),x,y,z);
				SendClientMessage(playerid,green,string);
				number++;
			}
		}
		if(number==1) SendClientMessage(playerid,green,"None.");
		return 1;
	} else return SendLevelErrorMessage(playerid,"ctl");
}
dcmd_rc(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"rc")) {
		SendACommandMessageToAdmins(playerid,"rc",params);
		new string[128],count;
		for(new i=0; i<MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && IsPlayerAdmin(i)) count++;
		if(!count) return SendClientMessage(playerid,red,"Admins connected to RCON:"), SendClientMessage(playerid,green,"None.");
		format(string,128,"Admins connected to RCON: (%d)",count); SendClientMessage(playerid,red,string);
		new bool:First = false;
		for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && IsPlayerAdmin(i)) {
			new name[24]; GetPlayerName(i,name,24);
			if(!First) { format(string,128,"%s (%d)",name,i); First = true; }
			else format(string,128,"%s, %s (%d)",string,name,i);
		}
		SendClientMessage(playerid,green,string);
		return 1;
	} else return SendLevelErrorMessage(playerid,"rc");
}
dcmd_full(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"full")) {
		SendACommandMessageToAdmins(playerid,"full",params);
		if(!strlen(params)) {
			SetPlayerHealth(playerid,100); SetPlayerArmour(playerid,100);
			return SendClientMessage(playerid,yellow,"You've set your health and armor to 100 percent.");
		} else {
			new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
			if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
				new string[128],name[24],ActionName[24]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
				SetPlayerHealth(id,100); SetPlayerArmour(id,100);
				if(id != playerid) {
					format(string,128,"Administrator \"%s\" has set your health and armor to 100 percent.",name); SendClientMessage(id,yellow,string);
					format(string,128,"Administrator \"%s\" has set \"%s's\" health and armor to 100 percent.",name,ActionName); SendMessageToAdminsEx2(playerid,id,lgreen,string);
					format(string,128,"You have set \"%s's\" health and armor to 100 percent.",ActionName); SendClientMessage(playerid,yellow,string);
				} else SendClientMessage(playerid,yellow,"You've set your health and armor to 100 percent.");
				return 1;
			} return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's health and armor.");
		}
	} else return SendLevelErrorMessage(playerid,"full");
}
dcmd_ca(playerid, params[])
{
	if(IsPlayerCommandLevel(playerid,"ca")) {
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		for (new i=0; i<MAX_PLAYERS; ++i) if (IsPlayerConnected(i)) for (new j=0; j<50; ++j) SendClientMessage(i,white," ");
		format(string, 128, "Administrator \"%s\" has cleaned the public chat.", name); SendMessageToAdmins(red, string);
		SendMessageToPlayers(red, "An administrator has cleaned the chat.");
		SendACommandMessageToAdmins(playerid,"ca",params);
		return 1;
	} else return SendLevelErrorMessage(playerid,"ca");
}
dcmd_cfgvar(playerid, params[])
{
	if(IsPlayerCommandLevel(playerid,"cfgvar")) {
		new string[128],tmp[128],tmp2[128],idx; tmp = strtok(params, idx); tmp2 = strtok(params, idx);
		new File[128] = "xadmin/Configuration/Configuration.ini";
		if (!strlen(tmp)||IsNumeric(tmp)||(strlen(tmp2)&&!IsNumeric(tmp2))) return SendClientMessage(playerid,red,"Syntax Error: \"/CFGVAR <VAR NAME> (<VALUE>)\".");
		SendACommandMessageToAdmins(playerid,"cfgvar",params);
		if (dini_Isset(File, tmp)) {
			if (strlen(tmp2)) {
				dini_IntSet(File, tmp, strval(tmp2));
				format(string,128,"You have set '%s' to %d in the configuration file.", tmp, strval(tmp2));
				return SendClientMessage(playerid,yellow,string);
			} else {
				format(string,128,"'%s' is set to %d in the configuration file.", tmp, dini_Int(File, tmp));
				return SendClientMessage(playerid,yellow,string);
			}
		} else return SendClientMessage(playerid,red,"ERROR: This is not a valid variable name.");
	} else return SendLevelErrorMessage(playerid,"cfgvar");
}
dcmd_kickall(playerid, params[])
{
	if(IsPlayerCommandLevel(playerid,"kickall"))
	{
		new string[128], name[24]; GetPlayerName(playerid, name, 24);
		if (!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/KICKALL <REASON>\".");
		SendACommandMessageToAdmins(playerid,"kickall",params);
		format(string, 128, "Everyone has been Kicked from the server. (Reason: %s)", params);
		for (new i = 0; i < MAX_PLAYERS; ++i)
		{
			if (IsPlayerConnected(i) && !(IsPlayerXAdmin(i) || IsPlayerAdmin(i)))
			{
				SendClientMessage(i,yellow,string);
                SetTimerEx("KickP",1, 0, "i", i);
			}
		}
		format(string,128,"Administartor \"%s\" has Kicked everyone from the server. (Reason: %s)", name, params);
		SendMessageToAdminsEx(playerid, lgreen, string);
		return SendClientMessage(playerid,yellow,"You have kicked everyone from the server.");
	} else return SendLevelErrorMessage(playerid,"kickall");
}
dcmd_tb(playerid, params[]) return dcmd_tempban(playerid, params);
dcmd_tempban(playerid, params[])
{
	if(IsPlayerCommandLevel(playerid,"tempban"))
	{
		new tmp[128], idx;
		tmp = strtok(params, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid, red, "Syntax Error: \"/TEMPBAN <NICK OR ID> <DAYS> <REASON>\".");
		new id; if (!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid)
		{
			tmp = strtok(params, idx);
			if (!strlen(tmp)) return SendClientMessage(playerid, red, "Syntax Error: \"/TEMPBAN <NICK OR ID> <DAYS> <REASON>\".");
			new reason[128]; reason = bigstr(params, idx);
			if (!strlen(reason)) return SendClientMessage(playerid, red, "Syntax Error: \"/TEMPBAN <NICK OR ID> <DAYS> <REASON>\".");
			return BanPlayer(id, playerid, reason, strval(tmp));
		} else return SendClientMessage(playerid,red,"ERROR: You can not temp-ban yourself or disconnected player.");
	} else return SendLevelErrorMessage(playerid,"tempban");
}
dcmd_nttb(playerid, params[]) return dcmd_nttempban(playerid, params);
dcmd_nttempban(playerid, params[])
{
	if(IsPlayerCommandLevel(playerid,"nttempban"))
	{
		new tmp[128], idx;
		tmp = strtok(params, idx);
		if(!strlen(tmp)) return SendClientMessage(playerid, red, "Syntax Error: \"/NTTEMPBAN <NICK OR ID> <DAYS> <REASON>\".");
		new id; if (!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID && id != playerid)
		{
			tmp = strtok(params, idx);
			if (!strlen(tmp)) return SendClientMessage(playerid, red, "Syntax Error: \"/NTTEMPBAN <NICK OR ID> <DAYS> <REASON>\".");
			new reason[128]; reason = bigstr(params, idx);
			if (!strlen(reason)) return SendClientMessage(playerid, red, "Syntax Error: \"/NTTEMPBAN <NICK OR ID> <DAYS> <REASON>\".");
			return BanPlayer(id, playerid, reason, strval(tmp));
		} else return SendClientMessage(playerid,red,"ERROR: You can not temp-ban yourself or disconnected player.");
	} else return SendLevelErrorMessage(playerid,"nttempban");
}
dcmd_untb(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"untb"))
	{
		if (!strlen(params)) return SendClientMessage(playerid, red, "Syntax Error: \"/UNTB <NAME>\".");
		if (!TempBanCheck(params, 1)) return SendClientMessage(playerid, red, "This player is not banned.");
		SendACommandMessageToAdmins(playerid,"untb",params);
		new string[128], name[24]; GetPlayerName(playerid,name,24);
		format(string, 128, "You have unbanned \"%s\" (%s).", params, TempBanGet(params, 1, "ip")); SendClientMessage(playerid,yellow,string);
		format(string, 128, "%s (%d) un-temp-banned %s [Reason: %s] {IP: %s}\r\n", name, playerid, params, TempBanGet(params, 1, "reason"), TempBanGet(params, 1, "ip"));
		UnTempBan(params, 1);
		WriteToLog("unbans",string);
	} else return SendLevelErrorMessage(playerid,"untb");
	return 1;
}

dcmd_untbip(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"untbip"))
	{
		if (!strlen(params)) return SendClientMessage(playerid, red, "Syntax Error: \"/UNTBIP <IP>\".");
		if (!TempBanCheck(params, 2)) return SendClientMessage(playerid, red, "This IP is not banned.");
		SendACommandMessageToAdmins(playerid,"untbip",params);
		new string[128], name[24]; GetPlayerName(playerid,name,24);
		format(string, 128, "You have unbanned %s (\"%s\").", params, TempBanGet(params, 2, "name")); SendClientMessage(playerid,yellow,string);
		format(string, 128, "%s (%d) un-temp-banned %s [Reason: %s] {IP: %s}\r\n", name, playerid, TempBanGet(params, 2, "name"), TempBanGet(params, 2, "reason"), params);
		UnTempBan(params, 2);
		WriteToLog("unbans",string);
	} else return SendLevelErrorMessage(playerid,"untbip");
	return 1;
}
dcmd_saccname(playerid,params[])
{
	if(IsPlayerCommandLevel(playerid,"saccname")) {
		new tmp[128],tmp2[128],Index; tmp = strtok(params,Index), tmp2 = strtok(params,Index);
   	 	if(!strlen(tmp)||!strlen(tmp2)) return SendClientMessage(playerid,red,"Syntax Error: \"/SACCNAME <NICK OR ID> <NEW NAME>\".");
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			SendACommandMessageToAdmins(playerid,"saccname",params);
			if(!IsNickValid(tmp2)) return SendClientMessage(playerid,red,"ERROR: The name you have entered is invalid.");
			new string[128],name[24],ActionName[24],newxfile[64]; GetPlayerName(playerid,name,24); GetPlayerName(id,ActionName,24);
			format(newxfile, 64, "xadmin/Users/%s.ini", udb_encode(tmp2));
			if(dini_Exists(newxfile)) { format(string,128,"ERROR: The account \"%s\" already exists.",ActionName); return SendClientMessage(playerid,red,string); }
			if(id != playerid) {
				format(string,128,"Administrator \"%s\" has set your account name to \"%s\".",name,tmp2); SendClientMessage(id,yellow,string);
				format(string,128,"You have set \"%s's\" account name to \"%s\".",ActionName,tmp2); SendClientMessage(playerid,yellow,string);
				TransferAccountData(ActionName, tmp2);
			} else {
				format(string,128,"You've set your account name to \"%s\".",tmp2); SendClientMessage(playerid,yellow,string);
				TransferAccountData(name, tmp2);
			}
			SetPlayerName(id,tmp2); return OnPlayerConnect(id);
		} return SendClientMessage(playerid,red,"ERROR: You can not set a disconnected player's account name.");
	} else return SendLevelErrorMessage(playerid,"saccname");
}

dcmd_rvi(playerid, params[])
{
	if (!IsPlayerXAdmin(playerid)) return SendClientMessage(playerid, red, "ERROR: You must be an administrator to use this command.");
	if (!strlen(params))
	{
		if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, red, "ERROR: You must be in a vehicle to use this command.");
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(playerid));
		SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), GetPlayerVirtualWorld(playerid));
		SendClientMessage(playerid, yellow, "Your vehicle has been linked to your interior and your world.");
	}
	else
	{
		if (!IsNumeric(params)) return SendClientMessage(playerid, red, "Syntax Error: \"/RVI (<VEHICLE ID>)\".");
		if (!DoesVehicleExists(strval(params))) return SendClientMessage(playerid, red, "ERROR: This vehicle doesn't exist.");
		LinkVehicleToInterior(strval(params), GetPlayerInterior(playerid));
		SetVehicleVirtualWorld(strval(params), GetPlayerVirtualWorld(playerid));
		SendClientMessage(playerid, yellow, "The vehicle has been linked to your interior and your world.");
	}
	return 1;
}
dcmd_gn(playerid, params[])
{
	if(IsPlayerCommandLevel(playerid,"gn"))
	{
		if(!strlen(params)) return SendClientMessage(playerid,red,"Syntax Error: \"/GN <NICK OR ID>\".");
		new id; if(!IsNumeric(params)) id = ReturnPlayerID(params); else id = strval(params);
		new string[128], name[24], ActionName[24]; GetPlayerName(playerid, name, 24);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID)
		{
			if(Spec[id][Spectating]) return SendClientMessage(playerid,red,"ERROR: The player must not be spectating.");
			SendACommandMessageToAdmins(playerid,"gn",params);
			if(IsPlayerInAnyVehicle(id))
			{
				new Car = GetPlayerVehicleID(id), Model = GetVehicleModel(Car);
				switch (Model)
				{
					case 581,509,481,462,521,463,510,522,461,448,471,468,586,523: return SendClientMessage(playerid,red,"ERROR: You can not add components to bikes!");
					case 548,425,417,487,488,497,563,447,469: return SendClientMessage(playerid,red,"ERROR: You can not add components to helicopters!");
					case 592,577,511,512,593,520,553,476,519,460,513: return SendClientMessage(playerid,red,"ERROR: You can not add components to airplanes!");
					case 472,473,493,595,484,430,453,452,446,454: return SendClientMessage(playerid,red,"ERROR: You can not add components to boats!");
				}
				GetPlayerName(id, ActionName, 24);
				if (id != playerid)
				{
					format(string, 128, "Administrator \"%s\" has added nitrous to your car.", name); SendClientMessage(id, yellow, string);
					format(string, 128, "You have added nitrous to \"%s's\" car.", ActionName); SendClientMessage(playerid, yellow, string);
					format(string, 128, "Administrator \"%s\" has added nitrous to \"%s's\" car.", name, ActionName); SendMessageToAdminsEx2(playerid, id, lblue, string);
				}
				else
				{
					SendClientMessage(playerid, yellow, "You have added nitrous to your car.");
					format(string, 128, "Administrator \"%s\" has added nitrous to his car.", name); SendMessageToAdminsEx(playerid, lblue, string);
				}
				return AddVehicleComponent(Car, 1010);
			} else return SendClientMessage(playerid,red,"ERROR: The player must be in a vehicle.");
		} else return SendClientMessage(playerid,red,"ERROR: You can not add nitrous to a disconnected player's vehicle.");
	} else return SendLevelErrorMessage(playerid,"gn");
}
dcmd_inv(playerid, params[])
{
	if(IsPlayerCommandLevel(playerid,"inv"))
	{
		new string[128], name[24]; GetPlayerName(playerid, name, 24);
		if (!strlen(params))
		{
			if (xPlayer[playerid][Invisible])
			{
				SendClientMessage(playerid, yellow, "[INV] You are now visible on the map.");
				format(string, 128, "[INV] %s is now visible on the map.", name);
				SendMessageToAdminsEx(playerid, lgreen, string);
				SetPlayerColor(playerid, random(0xFFFFFFFF));
				xPlayer[playerid][Invisible] = false;
			}
			else
			{
				SendClientMessage(playerid, yellow, "[INV] You are now hidden from the map.");
				format(string, 128, "[INV] %s is now hidden from the map.", name);
				SendMessageToAdminsEx(playerid, lgreen, string);
				SetPlayerColor(playerid, 0xFFFFFF00);
				xPlayer[playerid][Invisible] = true;
			}
			return 1;
		}

		new selection = strval(params);
		switch (selection)
		{
			case 0:
			{
				SendClientMessage(playerid, yellow, "[INV] You are now visible on the map.");
				format(string, 128, "[INV] %s is now visible on the map.", name);
				SendMessageToAdminsEx(playerid, lgreen, string);
				SetPlayerColor(playerid, random(0xFFFFFFFF));
				xPlayer[playerid][Invisible] = false;
				return 1;
			}
			case 1:
			{
				SendClientMessage(playerid, yellow, "[INV] You are now hidden from the map.");
				format(string, 128, "[INV] %s is now hidden from the map.", name);
				SendMessageToAdminsEx(playerid, lgreen, string);
				SetPlayerColor(playerid, 0xFFFFFF00);
				xPlayer[playerid][Invisible] = true;
				return 1;
			}
			default: return SendClientMessage(playerid, red, "Syntax Error: \"/INV (<0-1>)\".");
		}
	} else return SendLevelErrorMessage(playerid,"inv");
	return 1;
}
//=============================[Text Event]=====================================
public OnPlayerText(playerid, text[])
{
	#if APS
	if(Variables[playerid][Level] && !Variables[playerid][LoggedIn]) return SendClientMessage(playerid,red,"You must be logged in before you can talk!"), 0;
	#endif
 	//if(Variables[playerid][Muted])return 0;
	if(text[0] == '#' && IsPlayerXAdmin(playerid))
	{
		if (!xVars[AdminChat] && Variables[playerid][Level] < dini_Int("xadmin/Configuration/Commands.ini","ac")) return SendClientMessage(playerid,red,"* The admin chat is closed now."), 0;
		if (!strlen(text[1])) return SendClientMessage(playerid,red,"ERROR: You must write something!"), 0;
		new string[128],name[24]; GetPlayerName(playerid,name,24);
		if (xPlayer[playerid][AdminAFK]) {
		xPlayer[playerid][AdminAFK] = false;
		TogglePlayerControllable(playerid,true);
		SendClientMessage(playerid,grey,"You are now back to the game.");
		format(string,128,"\"%s\" is now back to the game.",name); SendMessageToAdminsEx(playerid,lgreen,string); }
		format(string,128,"%s (%d): %s [Level: %d]",name,playerid,text[1],Variables[playerid][Level]);
		SendMessageToAdmins(orange, string); WriteToLog("adminchat", text[1], playerid);
		return 0;
	}
	if(!xVars[ChatSystem] && text[0] != '!' && text[0] != '@' && strcmp(text,"$",false))
	{
		if (IsPlayerXAdmin(playerid) || xPlayer[playerid][LPT]) return 1;
		return SendClientMessage(playerid,red,"* The chat is closed now, you can not send messages."), 0;
	}
	if (DoesTextContainAnIP(text)) return SendClientMessage(playerid, red, "Server advertising is forbidden."), 0;
	//if (DoesTextContainAnIP(text)) return SendClientMessage(playerid, red, ".אסור לפרסם שרתים"), 0;
	#if AM
	if (!IsPlayerXAdmin(playerid) && (strfind(text, "/q", true) != -1 || DoesTextContainForbiddenWords(text)) &&
		strcmp(text,"$",false) && text[0] != '!' && text[0] != '@')
	{
		new string[128], Name[24]; GetPlayerName(playerid, Name, 24);
		format(string, 128, "%s (%d) tried to say: %s", Name, playerid, text);
		SendMessageToAdmins(lgreen, string);
		SendClientMessage(playerid, red, "* /report [לדיווח על צ'יטים / קללות / הצפות: [סיבה] [מספר שחקן");
		switch (xPlayer[playerid][ChatWarnings])
		{
			case 0: { MutePlayer(playerid, 60, "מילה אסורה"); xPlayer[playerid][ChatWarnings]++; }
			case 1: { MutePlayer(playerid, 120, "מילה אסורה"); xPlayer[playerid][ChatWarnings]++; }
			case 2: { MutePlayer(playerid, 300, "מילה אסורה"); xPlayer[playerid][ChatWarnings]++; }
			case 3: { KickPlayer(playerid, -1, "מילה אסורה"); xPlayer[playerid][ChatWarnings] = 0; }
		}
		return 0;
	}
	#endif
	return 1;
}
//==============================================================================
public OnPlayerStateChange(playerid, newstate, oldstate)
{
	for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if (Spec[i][Spectating] && Spec[i][SpectateID] == playerid)
		{
			switch (newstate)
			{
				case 1: PlayerSpectatePlayer(i, playerid);
				case 2, 3: PlayerSpectateVehicle(i, GetPlayerVehicleID(playerid));
			}
		}
	}
	return 1;
}
//==============================================================================
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	new string[128],name[24]; GetPlayerName(playerid,name,24);
	if (vehicleid == xPlayer[playerid][AdminVehicle])
	{
		format(string,128,"Welcome back to your admin vehicle, %s.",name);
		return SendClientMessage(playerid,green,string);
	}
	new id = -1; for(new i = 0; i < MAX_PLAYERS; ++i) if (IsPlayerConnected(i) && vehicleid == xPlayer[i][AdminVehicle]) { id = i; break; }
	if (IsPlayerConnected(id))
	{
		new oname[24];
		GetPlayerName(id,oname,24);
		format(string,128,"Welcome to %s's admin vehicle, %s.",oname,name);
		return SendClientMessage(playerid,green,string);
	}
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(IsPlayerXAdmin(playerid))SetPVarInt(playerid,"Admin",1),SetPVarInt(playerid,"ALevel",Variables[playerid][Level]);
	if(!IsPlayerXAdmin(playerid))SetPVarInt(playerid,"Admin",0),SetPVarInt(playerid,"ALevel",0);

    if(Variables[playerid][Muted] == 1)SetPVarInt(playerid,"InMute",1);
	if(Variables[playerid][Muted] == 0)SetPVarInt(playerid,"InMute",0);
	return 1;
}

//==============================================================================
public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(VehicleLockData[vehicleid]) { VehicleLockData[vehicleid] = false; for(new i = 0; i < MAX_PLAYERS; ++i) SetVehicleParamsForPlayer(vehicleid,i,false,false); }
	return 1;
}
//==============================================================================
public OnRconCommand(cmd[])
{
	new cmdtmp[128],idx; cmdtmp = strtok(cmd,idx);
	if(strcmp(cmdtmp, "xinfo", true)==0)
	{
		printf("XAP v1.2 AdminScript Info:");
		print("Created by SharkyKH, based on Xtreme's Admin Script v2.2r1.");
		print("Type \"XHELP\" for RCON commands.");
		return 1;
	}
	if(strcmp(cmdtmp, "xhelp", true)==0)
	{
		print("XAP RCON Commands:");
		print("XADMINS - Shows you the admins list.");
		print("XSAY <NAME> <TEXT> - Send a message to all the admins with your name.");
		print("XSETNAME <NICK OR ID> <NEW NAME> - Set a player's name.");
		printf("XSETLEVEL <NICK OR ID> <0 - %d> - Set a player's level.",Config[MaxLevel]);
		print("XKICK <NICK OR ID> <REASON> - Kick a player from the server.");
		print("XBAN <NICK OR ID> <DAYS> <REASON> - Ban a player from the server.");
		print("XUNBAN <NICK> / XUNBANIP <IP> - Unban a player by name / IP.");
		print("XBANNED <NICK> / XBANNEDIP <IP> - Get ban info by name / IP.");
		print("XKICKALL <REASON> - Kick everyone from the server with a reason.");
		return 1;
	}
	if(strcmp(cmdtmp, "xadmins", true)==0)
	{
		new Count,i,name[24];
		for(i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && Variables[i][Level] && Variables[i][LoggedIn]) Count++;
		if(!Count) { return print("Admins Online: None."), 1; }
		if(Count >= 1) {
			new aCount; printf("Admins Online (%d):",Count);
			for(i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i)) {
				if(Variables[i][Level]) {
					GetPlayerName(i,name,24);
					if (xPlayer[i][TMPLevel] && Variables[i][LoggedIn]) {
						if (!xPlayer[i][AdminAFK]) { aCount++; printf("%d. %s [id: %d | level: %d] -- Temp Admin",aCount,name,i,Variables[i][Level]); }
						else { aCount++; printf("%d. %s [id: %d | level: %d] -- Temp Admin | AFK",aCount,name,i,Variables[i][Level]); }
					} else if (!Variables[i][Registered]) {
						aCount++; printf("%d. %s [id: %d | level: %d] -- Not Registered",aCount,name,i,Variables[i][Level]);
					} else if (!Variables[i][LoggedIn]) {
						aCount++; printf("%d. %s [id: %d | level: %d] -- Not Logged In",aCount,name,i,Variables[i][Level]);
					} else if (Variables[i][LoggedIn]) {
						if (!xPlayer[i][AdminAFK]) { aCount++; printf("%d. %s [id: %d | level: %d]",aCount,name,i,Variables[i][Level]); }
						else { aCount++; printf("%d. %s [id: %d | level: %d] -- AFK",aCount,name,i,Variables[i][Level]); }
					}
				}
			}
		}
		return 1;
	}
	if(strcmp(cmdtmp, "xsay", true)==0)
	{
		new string[128], name[128], text[128]; name = strtok(cmd, idx); text = bigstr(cmd, idx);
   	 	if(!strlen(name) || !strlen(text)) return print("Syntax Error: \"XSAY <NAME> <TEXT>\"."), 1;
		format(string, 128, "** %s (via RCON): %s", name, text);
		SendMessageToAdmins(orange,string);
		printf("Message sent: %s", text);
		return 1;
	}
	if(strcmp(cmdtmp, "xsetname", true)==0)
	{
		new tmp[128],tmp2[128]; tmp = strtok(cmd,idx), tmp2 = strtok(cmd,idx);
   	 	if(!strlen(tmp)||!strlen(tmp2)) return print("Syntax Error: \"XSETNAME <NICK OR ID> <NEW NAME>\"."), 1;
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			if(!IsNickValid(tmp2)) return print("ERROR: The name you have entered is invalid."), 1;
			new string[128],ActionName[24]; GetPlayerName(id,ActionName,24);
			format(string,128,"RCON Admin has set your name to %s.",tmp2);
			SendClientMessage(id,yellow,string);
			printf("You have set \"%s's\" name to %s.",ActionName,tmp2);
			SetPlayerName(id,tmp2);
			OnPlayerConnect(id);
			return 1;
		} return print("ERROR: You can not set a disconnected player's name."), 1;
	}
	if(strcmp(cmdtmp, "xsetlevel", true)==0)
	{
		new tmp[128],tmp2[128]; tmp = strtok(cmd,idx), tmp2 = strtok(cmd,idx);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||!(strval(tmp2) >= 0 && strval(tmp2) <= Config[MaxLevel])) {
		return printf("Syntax Error: \"XSETLEVEL <NICK OR ID> <0 - %d>\".",Config[MaxLevel]), 1; }
   		new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			if(xPlayer[id][TMPLevel]) return print("ERROR: That player has a temp-level."), 1;
  			if(Variables[id][Level] == strval(tmp2)) return print("ERROR: That player is already that level."), 1;
  			if(!dini_Exists(GetPlayerFile(id))) CreateUserConfigFile(id);
			new string[128],ActionName[24]; GetPlayerName(id,ActionName,24);
			format(string,128,"An RCON Administrator has %s you to %s [%d].",((strval(tmp2) >= Variables[id][Level])?("promoted"):("demoted")),
			((strval(tmp2))?("Administrator"):("Member Status")),strval(tmp2));
			SendClientMessage(id,yellow,string);
			printf("You have %s \"%s\" to %s [%d].",((strval(tmp2) >= Variables[id][Level])?("promoted"):("demoted")),ActionName,
			((strval(tmp2))?("Administrator"):("Member Status")),strval(tmp2));
			Variables[id][Level] = strval(tmp2); SetUserInt(id,"Level",strval(tmp2));
			Variables[id][LoggedIn] = false; SetUserInt(id,"LoggedIn",0);
			if(!strval(tmp2)) dini_Remove(GetPlayerFile(id));
			OnPlayerConnect(id);
			if(strval(tmp2) > 0)dini_IntSet(PlayerFilee(id),"Admin",1),SetPVarInt(id,"Admin",1);
			else if(strval(tmp2) == 0)dini_IntSet(PlayerFilee(id),"Admin",0),SetPVarInt(id,"Admin",0);
			SetPVarInt(id,"ALevel",strval(tmp2));
			dini_IntSet(PlayerFilee(id),"ALevel",strval(tmp2));
			if(strval(tmp2) == 0)dini_IntSet(PlayerFilee(id),"Admin",0),SetPVarInt(strval(tmp),"Admin",0),dini_IntSet(PlayerFilee(id),"ALevel",0),SetPVarInt(id,"ALevel",0);
			return 1;
		} else return print("ERROR: You can not set a disconnected player's level."), 1;
	}
	if(strcmp(cmdtmp, "xkick", true)==0)
	{
		new string[128],tmp[128],name[24],reason[128]; tmp = strtok(cmd,idx); reason = bigstr(cmd, idx);
		if(!strlen(tmp)||!strlen(reason)) return print("Syntax Error: \"XKICK <NICK OR ID> <REASON>\"."), 1;
	   	new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			GetPlayerName(id,name,24);
			format(string,128,"\"%s\" has been Kicked from the server by RCON. (Reason: %s)",name,reason); SendMessageToAdminsEx(id,lgreen,string);
			printf("\"%s\" has been Kicked from the server. (Reason: %s)",name,reason);
			KickPlayer(id,-2,reason);
			return 1;
		} else return print("ERROR: You can not kick a disconnected player."), 1;
	}
	if(strcmp(cmdtmp, "xban", true)==0)
	{
		new string[128],tmp[128],tmp2[128],name[24],reason[128]; tmp = strtok(cmd,idx); tmp2 = strtok(cmd,idx); reason = bigstr(cmd, idx);
		if(!strlen(tmp)||!strlen(tmp2)||!IsNumeric(tmp2)||!strlen(reason)) return print("Syntax Error: \"XBAN <NICK OR ID> <DAYS> <REASON>\"."), 1;
	   	new id; if(!IsNumeric(tmp)) id = ReturnPlayerID(tmp); else id = strval(tmp);
		if(IsPlayerConnected(id) && id != INVALID_PLAYER_ID) {
			new ip[20]; GetPlayerName(id,name,24); GetPlayerIp(id,ip,20);
			if(strval(tmp2))
			{
		 		new fdays[16]; FormatDays(strval(tmp2), fdays);
				format(string,128,"\"%s\" has been Temp-Banned from the server by RCON for %s. (Reason: %s)",name,fdays,reason);
				printf("\"%s\" has been Banned from the server for %s. (Reason: %s)",name,fdays,reason);
			}
			else
			{
				format(string,128,"\"%s\" has been Banned from the server by RCON. (Reason: %s)",name,reason);
				printf("\"%s\" has been Banned from the server. (Reason: %s)",name,reason);
			}
			SendMessageToAdminsEx(id,lgreen,string);
			BanPlayer(id,-2,reason,strval(tmp2));
			return 1;
		} else return print("ERROR: You can not ban a disconnected player."), 1;
	}
	if(strcmp(cmdtmp, "xbanned", true)==0)
	{
		new tmp[128]; tmp = strtok(cmd,idx);
		if (!strlen(tmp)) return print("Syntax Error: \"XBANNED <NICK>\"."), 1;
		if (!BanCheck(tmp, 1)) return printf("The player \"%s\" is not banned.",tmp), 1;
		new File[128]; format(File, 128, "/xap/Bans/Names/%s.ini", tmp);
		printf("Ban Info: (Player: %s) (Admin: %s) (Reason: %s) (IP: %s)", tmp, dini_Get(File, "Admin"), dini_Get(File, "Reason"), dini_Get(File, "IP"));
		return 1;
	}
	if(strcmp(cmdtmp, "xbannedip", true)==0)
	{
		new tmp[128]; tmp = strtok(cmd,idx);
		if (!strlen(tmp)) return print("Syntax Error: \"XBANNEDIP <IP>\"."), 1;
		if (!BanCheck(tmp, 2)) return printf("The IP %s is not banned.",tmp), 1;
		new File[128]; format(File, 128, "/xap/Bans/IP/%s.ini", tmp);
		printf("Ban Info: (Player: %s) (Admin: %s) (Reason: %s) (IP: %s)", dini_Get(File, "PlayerName"), dini_Get(File, "Admin"), dini_Get(File, "Reason"), tmp);
		return 1;
	}
	if(strcmp(cmdtmp, "xunban", true)==0)
	{
		new tmp[128]; tmp = strtok(cmd,idx);
		if (!strlen(tmp)) return print("Syntax Error: \"XUNBAN <NAME>\"."), 1;
		if (TempBanCheck(tmp, 1)) return printf("The player \"%s\" is temp banned, please use \"XUNTB <NAME>\".", tmp), 1;
		if (!BanCheck(tmp, 1)) return printf("The player \"%s\" is not banned.",tmp), 1;
		new BanFile[128], IpBanFile[128]; format(BanFile, 128, "/xap/Bans/Names/%s.ini", tmp);
		new fileline[128]; format(fileline,128,"RCON unbanned %s (%s) [Reason: %s]\r\n",tmp,dini_Get(BanFile, "IP"),dini_Get(BanFile, "Reason"));
		WriteToLog("unbans", fileline);
		printf("You have unbanned \"%s\".", tmp);
		if (dini_Exists(BanFile))
		{
			format(IpBanFile, 128, "/xap/Bans/IP/%s.ini", dini_Get(BanFile, "IP"));
			if (dini_Exists(IpBanFile))
			{
				dini_Remove(BanFile);
				dini_Remove(IpBanFile);
			}
		}
		return 1;
	}
	if(strcmp(cmdtmp, "xunbanip", true)==0)
	{
		new tmp[128]; tmp = strtok(cmd,idx);
		if (!strlen(tmp)) return print("Syntax Error: \"/UNBANIP <IP>\"."), 1;
		if (TempBanCheck(tmp, 2)) return printf("The IP \"%s\" is temp banned, please use \"XUNTBIP <IP>\".", tmp), 1;
		if (!BanCheck(tmp, 2)) return printf("The IP \"%s\" is not banned.",tmp), 1;
		new IpBanFile[128], BanFile[128]; format(IpBanFile, 128, "/xap/Bans/IP/%s.ini", tmp);
		new fileline[128]; format(fileline,128,"RCON unbanned %s (%s) [Reason: %s]\r\n",tmp,dini_Get(IpBanFile, "PlayerName"),dini_Get(BanFile, "Reason"));
		WriteToLog("unbans", fileline);
		printf("You have unbanned %s (\"%s\").", dini_Get(IpBanFile, "PlayerName"), tmp);
		if (dini_Exists(IpBanFile))
		{
			format(BanFile, 128, "/xap/Bans/Names/%s.ini", dini_Get(IpBanFile, "PlayerName"));
			if (dini_Exists(BanFile))
			{
				dini_Remove(IpBanFile);
				dini_Remove(BanFile);
			}
		}
		return 1;
	}
	if(strcmp(cmdtmp, "xuntb", true)==0)
	{
		new tmp[128]; tmp = strtok(cmd,idx);
		if (!strlen(tmp)) return print("Syntax Error: \"XUNTB <NAME>\"."), 1;
		if (BanCheck(tmp, 1)) return printf("The player \"%s\" is permanently banned, please use \"XUNBAN <NAME>\".", tmp), 1;
		if (!TempBanCheck(tmp, 1)) return printf("The player \"%s\" is not temp-banned.",tmp), 1;
		new fileline[128]; format(fileline,128,"RCON un-temp-banned %s (%s) [Reason: %s]\r\n",tmp,TempBanGet(tmp,1,"ip"),TempBanGet(tmp,1,"reason"));
		WriteToLog("unbans", fileline);
		printf("You have un-temp-banned \"%s\".", tmp);
		UnTempBan(tmp, 1);
		return 1;
	}
	if(strcmp(cmdtmp, "xuntbip", true)==0)
	{
		new tmp[128]; tmp = strtok(cmd,idx);
		if (!strlen(tmp)) return print("Syntax Error: \"XUNTBIP <IP>\"."), 1;
		if (BanCheck(tmp, 2)) return printf("The IP \"%s\" is permanently banned, please use \"XUNBANIP <NAME>\".", tmp), 1;
		if (!TempBanCheck(tmp, 2)) return printf("The IP \"%s\" is not temp-banned.",tmp), 1;
		new fileline[128]; format(fileline,128,"RCON un-temp-banned %s (%s) [Reason: %s]\r\n",tmp,TempBanGet(tmp,2,"name"),TempBanGet(tmp,2,"reason"));
		WriteToLog("unbans", fileline);
		printf("You have un-temp-banned %s (\"%s\").", TempBanGet(tmp,1,"name"), tmp);
		UnTempBan(tmp, 2);
		return 1;
	}
	if(strcmp(cmdtmp, "xkickall", true)==0)
	{
		new string[128], reason[128]; reason = bigstr(cmd,idx);
		if (!strlen(reason)) return print("Syntax Error: \"XKICKALL <REASON>\"."), 1;
		format(string, 128, "Everyone has been Kicked from the server. (Reason: %s)", reason);
		for (new i = 0; i < MAX_PLAYERS; ++i)
		{
			if (IsPlayerConnected(i) && !(IsPlayerXAdmin(i) || IsPlayerAdmin(i)))
			{
				SendClientMessage(i,yellow,string);
                SetTimerEx("KickP",1, 0, "i", i);
			}
		}
		format(string,128,"Everyone has been Kicked from the server by an RCON Administrator. (Reason: %s)", reason);
		SendMessageToAdmins(lgreen, string);
		printf("Everyone has been Kicked from the server. (Reason: %s)", reason);
		return 1;
	}
	return 0;
}
//==============================================================================
public PingKick()
{
	if (Config[MaxPing])
	{
		for(new i = 0,string[128],name[24]; i < MAX_PLAYERS; ++i)
		{
			if(IsPlayerConnected(i) && (GetPlayerPing(i) > Config[MaxPing]))
			{
				if(!IsPlayerXAdmin(i) || (IsPlayerXAdmin(i) && !Config[AdminImmunity]))
				{
					GetPlayerName(i,name,24);
					format(string,128,"\"%s\" has been Kicked from the server. (Reason: High Ping || Max Allowed: %d)",name,Config[MaxPing]);
					SendClientMessageToAll(yellow,string);
					SetTimerEx("KickP",1, 0, "i", i);
				}
			}
		}
	}
}
//==============================================================================
public CountDown(Count, Freeze)
{
	if (Freeze == 1) for (new i = 0; i < MAX_PLAYERS; ++i) if (IsPlayerConnected(i) && IsPlayerSpawned(i) && !Variables[i][Frozen] && !xPlayer[i][AdminAFK])
	{
		TogglePlayerControllable(i, false);
		xPlayer[i][FrozenByFreeze] = true;
	}
	if (Count)
	{
		new string[128];
		format(string, 128, "~%c~%d", (Count <= 5) ? 'r' : 'b', Count);
		GameTextForAll(string, 1100, 6);
		Count--;
		return xVars[TimerCountDown] = SetTimerEx("CountDown", 1000, 0, "ii", Count, Freeze);
	}
	if (Freeze) for(new i = 0; i < MAX_PLAYERS; ++i)
	{
		if (IsPlayerConnected(i) && IsPlayerSpawned(i) && !Variables[i][Frozen] && !xPlayer[i][AdminAFK] && xPlayer[i][FrozenByFreeze])
		{
			TogglePlayerControllable(i, true);
			xPlayer[i][FrozenByFreeze] = false;
		}
	}
	xVars[TimerCountDown] = -1;
	return GameTextForAll("~g~GO!", 5000, 6);
}
//==============================================================================
public OpenChats()
{
	new CC = 0, ACC = 0;
	for (new i = 0; i < MAX_PLAYERS; ++i)
	{
		if (IsPlayerConnected(i) && Variables[i][LoggedIn])
		{
			if (Variables[i][Level] >= dini_Int("xadmin/Configuration/Commands.ini", "chat"))
				CC++;
			if (Variables[i][Level] >= dini_Int("xadmin/Configuration/Commands.ini", "ac"))
				ACC++;
		}
	}
	if (!xVars[ChatSystem] && !CC) AutoOpenChat(0, false);
	if (!xVars[AdminChat] && !ACC) AutoOpenChat(1, false);
}
//==============================================================================
public AutoOpenChat(chat, bool:reload)
{
	if (!xVars[ChatSystem] && chat == 0)
	{
		xVars[ChatSystem] = true;
		for (new i = 0; i < MAX_PLAYERS; ++i) if (IsPlayerConnected(i)) xPlayer[i][LPT] = false;
		SendClientMessageToAll(red, "The public chat was enabled by the server.");
		if (reload) KillTimer(xVars[TimerChat]);
		xVars[TimerChat] = -1;
	}
	if (!xVars[AdminChat] && chat == 1)
	{
		xVars[AdminChat] = true;
		SendMessageToAdmins(red, "The admin chat was enabled by the server.");
		if (reload) KillTimer(xVars[TimerAChat]);
		xVars[TimerAChat] = -1;
	}
}
//==============================================================================
public ServerNewsAnnouncement()
{
	new File[64] = "/xap/Configuration/Announcements.ini";
	if (dini_Bool(File,"System"))
	{
		new fstr[10],count,Texts[8][128];
		for (new i = 0; i < dini_Int(File, "MaxTexts"); ++i)
		{
			format(fstr,10,"Text%d",i+1); format(Texts[i],128,dini_Get(File,fstr));
			if(strcmp(Texts[i],"None",true)) count++;
		}
		if (!count) return 1;
		SendClientMessageToAll(white,"|___________ Server News Announcement ___________|");
		for (new i = 0; i < dini_Int(File, "MaxTexts"); ++i)
		{
			format(fstr,10,"Text%d",i+1); format(Texts[i],128,dini_Get(File,fstr));
			if (strcmp(Texts[i],"None",true)) SendClientMessageToAll(blue,Texts[i]);
		}
		SendClientMessageToAll(white,"|________________________________________________|");
	}
	return 1;
}
//==============================================================================
stock ServerAdminsAnnouncement(playerid, text[])
{
	new string[128], aName[24]; GetPlayerName(playerid, aName, 24);
	format(string, 128, "%s: %s", aName, text);
	SendClientMessageToAll(white,"|___________ Server Admins Announcement __________|");
	SendClientMessageToAll(green, string);
	SendClientMessageToAll(white,"|_________________________________________________|");
}
//==============================================================================
public OnPlayerSelectedMenuRow(playerid, row)
{
	new Menu:Current = GetPlayerMenu(playerid);
	if(Current == xVars[GiveCar])
	{
		new Component[20],id,carid;
		switch (row)
		{
			case 0: Component = "Nitrous x10", id = 1010;
			case 1: Component = "Hydraulics", id = 1087;
			case 2: Component = "Offroad Wheels", id = 1025;
			case 3: Component = "Wire Wheels", id = 1081;
		}
		new params[30]; format(params, 30, "(%s)", Component);
		SendACommandMessageToAdmins(playerid, "givecar", params);
		new string[128]; format(string, 128,"You have selected \'%s\'.", Component);
		SendClientMessage(playerid, yellow, string);
		TogglePlayerControllable(playerid, true);
		carid = GetPlayerVehicleID(playerid);
		AddVehicleComponent(carid,id);
	}
	return 1;
}
//==============================================================================
public OnPlayerExitedMenu(playerid)
{
	HideMenuForPlayer(GetPlayerMenu(playerid),playerid);
	TogglePlayerControllable(playerid,true);
	return 1;
}
//==============================================================================
public AdminVehicleAction(playerid,vehicleid,actionid)
{
	switch (actionid)
	{
		case 0: // Destroy
		{
			new count = 0;
			for (new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && IsPlayerInVehicle(i, vehicleid)) {
			SendClientMessage(i,red,"You have been ejected because this is an admin vehicle."); RemovePlayerFromVehicle(i); count++; }
			if (count > 0)
			{
				SetTimerEx("AdminVehicleAction",3000,0,"iii",playerid,vehicleid,actionid);
				return SendClientMessage(playerid,yellow,"Your vehicle will be destroyed in 3 seconds.");
			}
			xPlayer[playerid][AdminVehicle] = 0; SendClientMessage(playerid,yellow,"Your vehicle has been destroyed.");
			return DestroyVehicle(vehicleid);
		}
		case 1: // Call
		{
			new count = 0;
			for(new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && IsPlayerInVehicle(i, vehicleid)) {
			SendClientMessage(i,red,"You have been ejected because this is an admin vehicle."); RemovePlayerFromVehicle(i); count++; }
			if (count > 0)
			{
				SetTimerEx("AdminVehicleAction",3000,0,"iii",playerid,vehicleid,actionid);
				return SendClientMessage(playerid,yellow,"Your vehicle will be teleported to your location in 3 seconds.");
			}
			new Float:X, Float:Y, Float:Z, Float:A; GetPlayerPos(playerid, X, Y, Z); GetPlayerFacingAngle(playerid, A);
			SetVehiclePos(xPlayer[playerid][AdminVehicle], X, Y, Z+1); SetVehicleZAngle(xPlayer[playerid][AdminVehicle], A);
			PutPlayerInVehicle(playerid, xPlayer[playerid][AdminVehicle], 0);
			return SendClientMessage(playerid,yellow,"Your vehicle has been teleported to your location.");
		}
		case 2: // Disconnect-Destroy
		{
			new count = 0;
			for (new i = 0; i < MAX_PLAYERS; ++i) if(IsPlayerConnected(i) && IsPlayerInVehicle(i, vehicleid)) {
			SendClientMessage(i,red,"You have been ejected because this is an admin vehicle."); RemovePlayerFromVehicle(i); count++; }
			if (count > 0) return SetTimerEx("AdminVehicleAction",3000,0,"iii",playerid,vehicleid,actionid);
			xPlayer[playerid][AdminVehicle] = 0;
			return DestroyVehicle(vehicleid);
		}
	}
	return false;
}

stock PlayerFilee(playerid)
{
	new namep[25];
	GetPlayerName(playerid,namep,25);
	new file[256];
	format(file,256,"/UsersID/%d.txt",dini_Int(PFile(namep),"UserID"));
	return file;
}

stock PFile(pfname[])
{
	new pfilename[256];
	format(pfilename,256,"/UsersName/%s.txt",pfname);
	return pfilename;
}

forward KickP(playerid);
public KickP(playerid)
{
Kick(playerid);
return 1;
}
//==============================================================================
// => Include XAP Systems:
#if APS
 #include "xap\Systems\AP_System.inc"
#endif
#include "xap\Systems\Kick-Ban_System.inc"
#include "xap\Systems\Mute-Jail_System.inc"
#include "xap\Systems\Log_System.inc"
#include "xap\Systems\Spectate_System.inc"
#include "xap\Systems\Ban_System.inc"
#include "xap\Systems\XCMDS_System.inc"
//================================/=/==E==N==D==/=/=============================
