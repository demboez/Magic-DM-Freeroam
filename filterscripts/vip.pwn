//----------------------------------------------------------------------------//
//V.I.P System by ZigGamerX.
//s_samp - Kalcor
//zcmd - Zeex
//Foreach - Thanks whoever made this.
//Sscanf2 - Thanks whoever made this.
//ZigGamerX Aka me - Script
//Jithu - Helping
//----------------------------------------------------------------------------//

//Includes
#include <a_samp>
#include <zcmd>
#include <foreach>
#include <sscanf2>

native IsValidVehicle(vehicleid);

//Defines
#define FILTERSCRIPT
#if defined FILTERSCRIPT

//Colors
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x33AA33AA
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLUE 0x0000BBAA

///Dialog
#define DIALOG_VIPS 0

//Add this to into your Gamemode/FS enums.
enum PInfo
{
   pVIP,
   pGOD
}
new PlayerInfo[MAX_PLAYERS][PInfo];

//Variables
new dVehicle[MAX_PLAYERS];

public OnFilterScriptInit()
{
    print(" V.I.P system Loaded");

    print("\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=");
	print("        Deathmatch System by ZigGamerX        ");
	print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-\n");
	return 1;
}

public OnFilterScriptExit()
{
    print(" V.I.P system Unloaded");
	return 1;
}

public OnPlayerConnect(playerid)
{
	//Evading Bugs for car
	dVehicle[playerid] = 0;

	if(PlayerInfo[playerid][pVIP] >= 1)
	{
	   SendClientMessage(playerid, -1, "[VIP]: Welcome Back.");
    }
    return 1;
}

public OnPlayerText(playerid, text[])
{
     if(text[0] == '#' && PlayerInfo[playerid][pVIP] >= 1)
     {
         new msg[128], message[128];
         format(msg, sizeof(msg), "VIP CHAT: %s(%i): %s",  GetName(playerid), playerid, message);
         for(new i = 0; i <MAX_PLAYERS; i++)
         {
             if(PlayerInfo[i][pVIP] >= 1)
             {
                 SendClientMessage(i, -1, message);
             }
         }
     }
     return 1;
}


//Normal Command
CMD:vips(playerid, params[])
{
        new vips[3000],count=0;
        if(IsPlayerConnected(playerid))
        {
            for (new i = 0; i < MAX_PLAYERS; i++)
            {
                if(IsPlayerConnected(i))
                {
                    if(PlayerInfo[i][pVIP] > 0)
                    {
                        format(vips, sizeof(vips),"{ffffff}%s%s (ID:%d)\n", vips, GetName(i), playerid);
                        count++;
                    }
                }
            }
            ShowPlayerDialog(playerid,DIALOG_VIPS,DIALOG_STYLE_MSGBOX,"{B266FF}Online VIPs:",vips,"Close","");
          }
        if(count == 0) return SendClientMessage(playerid,-1, "There are no VIP's online.");
        return 1;
}

CMD:getvip(playerid)
{
   PlayerInfo[playerid][pVIP]  = 2;
   SendClientMessage(playerid, COLOR_YELLOW, "You're now V.I.P");
   return 1;
}

//VIP COMMANDS LEVEL (1)
CMD:vcmds(playerid)
{
  if(PlayerInfo[playerid][pVIP] >= 1) return SendClientMessage(playerid, COLOR_RED, "You don't have V.I.P Access to you're account.");
  {
	SendClientMessage(playerid, COLOR_YELLOW, "__________V.I.P Commands Level (1)__________");
	SendClientMessage(playerid, COLOR_RED, "/nos || /vheal || /vgod || /vcar || /vsay || /vcc || # for vip chat.");
  }
  if(PlayerInfo[playerid][pVIP] >= 2)
  {
    SendClientMessage(playerid, COLOR_YELLOW, "__________V.I.P Commands Level (2)__________");
    SendClientMessage(playerid, COLOR_RED, "/varmour || /vbike || /vheli || /vweaps");
  }
  return 1;
}

//VIP COMMANDS LEVEL (1)
CMD:vgod(playerid)
{
   if(PlayerInfo[playerid][pVIP] < 1) return SendClientMessage(playerid, COLOR_RED, "You don't have V.I.P Access to you're account.");
   {
     if(PlayerInfo[playerid][pGOD] == 0)
     {
        SetPlayerHealth(playerid, 999999999);
        SendClientMessage(playerid, COLOR_GREEN, "You have enabled God Mode.");
        PlayerInfo[playerid][pGOD] = 1;
     }
     else if(PlayerInfo[playerid][pGOD] == 1)
     {
        SetPlayerHealth(playerid, 100);
        SendClientMessage(playerid, COLOR_GREEN, "You have disabled God Mode.");
        PlayerInfo[playerid][pGOD] = 0;
     }
    }
   return 1;
}

CMD:nos(playerid, params[])
{
    if(PlayerInfo[playerid][pVIP] < 1) return SendClientMessage(playerid, COLOR_RED, "You don't have V.I.P Access to you're account.");
    if(GetPlayerState(playerid)==PLAYER_STATE_DRIVER)
    {
        switch(GetVehicleModel(GetPlayerVehicleID(playerid)))
        {
            case 448,461,462,463,468,471,509,510,521,522,523,581,586,449: return SendClientMessage(playerid,-1,"ERROR: You can not add nos in this vehicle!");
        }
        AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
        PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
    }
    else return SendClientMessage(playerid,-1,"ERROR: You must be in a vehicle.");
    return 1;
}

CMD:vh(playerid) return cmd_vheal(playerid);
CMD:vheal(playerid)
{
    if(PlayerInfo[playerid][pVIP] < 1) return SendClientMessage(playerid, COLOR_RED, "You don't have V.I.P Access to you're account.");
    {
	   SetPlayerHealth(playerid, 100.0);
	   SendClientMessage(playerid, COLOR_YELLOW, "Health Restored!");
    }
    return 1;
}

CMD:vcc(playerid, params[])
{
    if(PlayerInfo[playerid][pVIP] < 1) return SendClientMessage(playerid, COLOR_RED, "You don't have V.I.P Access to you're account.");
    if(GetPlayerState(playerid) != 2) return SendClientMessage(playerid, 0xFF0000FF, "You are not driving a vehicle.");
    new color[2];
    if(sscanf(params, "iI(-1)", color[0], color[1]))
    {
        return SendClientMessage(playerid, 0xFF0000FF, "USAGE: /dcc [color1] <color2>");
    }
    if(color[1] == -1) color[1] = color[0];
    new szSuccess[44];
    format(szSuccess, sizeof(szSuccess), "Vehicle colors changed to: {FFFFFF}%i and %i.", color[0], color[1]);
    SendClientMessage(playerid, 0x00FF00FF, szSuccess);
    ChangeVehicleColor(GetPlayerVehicleID(playerid), color[0], color[1]);
    return 1;
}

CMD:vsay(playerid)
{
   if(PlayerInfo[playerid][pVIP] < 1) return SendClientMessage(playerid, COLOR_RED, "You don't have V.I.P Access to you're account.");
   {
	  new string[100], vmsg[100];
      format(string, sizeof string, "[VIP]: %s", vmsg);
      SendClientMessageToAll(-1, string);
   }
   return 1;
}

CMD:vcar(playerid)
{
    if(PlayerInfo[playerid][pVIP] < 1) return SendClientMessage(playerid, COLOR_RED, "You don't have V.I.P Access to you're account.");
    {
       new Float:X, Float:Y, Float:Z;
       if(IsValidVehicle(dVehicle[playerid]))
       {
         DestroyVehicle(dVehicle[playerid]);
       }
       GetPlayerPos(playerid, X, Y, Z);
       CreateVehicle(415, X, Y, Z, 0, 0, 0, 0, 0);
       SendClientMessage(playerid, COLOR_RED, "Car Spawned.");
    }
    return 1;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------//

//VIP COMMANDS LEVEL (2)
CMD:va(playerid) return cmd_varmour(playerid);
CMD:varmour(playerid)
{
   if(PlayerInfo[playerid][pVIP] < 2) return SendClientMessage(playerid, COLOR_RED, "You don't have V.I.P Access to you're account.");
   {
	  SetPlayerArmour(playerid, 100.0);
	  SendClientMessage(playerid, COLOR_YELLOW, "Armour Restored!");
   }
   return 1;
}

CMD:vbike(playerid)
{
    if(PlayerInfo[playerid][pVIP] < 2) return SendClientMessage(playerid, COLOR_RED, "You don't have V.I.P Access to you're account.");
    {
       new Float:X, Float:Y, Float:Z;
       if(IsValidVehicle(dVehicle[playerid]))
       {
         DestroyVehicle(dVehicle[playerid]);
       }
       GetPlayerPos(playerid, X, Y, Z);
       CreateVehicle(522, X, Y, Z, 0, 0, 0, 0, 0);
       SendClientMessage(playerid, COLOR_RED, "Bike Spawned.");
    }
    return 1;
}

CMD:vheli(playerid)
{
    if(PlayerInfo[playerid][pVIP] < 2) return SendClientMessage(playerid, COLOR_RED, "You don't have V.I.P Access to you're account.");
    {
       new Float:X, Float:Y, Float:Z;
       if(IsValidVehicle(dVehicle[playerid]))
       {
         DestroyVehicle(dVehicle[playerid]);
       }
       GetPlayerPos(playerid, X, Y, Z);
       CreateVehicle(488, X, Y, Z, 0, 0, 0, 0, 0);
       SendClientMessage(playerid, COLOR_RED, "Helicopter Spawned.");
    }
    return 1;
}

CMD:vweaps(playerid)
{
   if(PlayerInfo[playerid][pVIP] < 2) return SendClientMessage(playerid, COLOR_RED, "You don't have V.I.P Access to you're account.");
   {
	  GiveWeapons(playerid);
	  SendClientMessage(playerid, COLOR_YELLOW, "V.I.P Weapons spawned.");
   }
   return 1;
}
//--------------------------------------------------------------------------------------------------------------------------------------------------------------------//

//Stocks
stock GiveWeapons(playerid)
{
   GivePlayerWeapon(playerid, 9, 1);
   GivePlayerWeapon(playerid, 24, 999999);
   GivePlayerWeapon(playerid, 26, 999999);
   GivePlayerWeapon(playerid, 28, 999999);
   GivePlayerWeapon(playerid, 31, 999999);
   GivePlayerWeapon(playerid, 34, 999999);
   GivePlayerWeapon(playerid, 35, 100);
   GivePlayerWeapon(playerid, 16, 100);
   return 1;
}

stock GetName(playerid)
{
    new pName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, pName, sizeof(pName));
    return pName;
}

#endif
