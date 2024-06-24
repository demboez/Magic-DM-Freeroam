//--------------------------------------------------------------//
// PM system by hobo101 aka MarkNelson V0.1
// If you're using this system as a filterscript or in your game-mode
// Please, don't remove the credits
// If you find any bug, feel free to report it through PM on samp forums
// to MarkNelson, Thank you for understanding.
//-------------------------------------------------------------//

#include <a_samp>
#include <zcmd>
#include <sscanf2>

//Colors + Var + Dialog
#define COLOR_RED 0xAA3333AA
#define COLOR_ORANGE 0xF97804FF
#define COLOR_YELLOW 0xFFFF00AA
#define DIALOG_PM 889
new LastPm[MAX_PLAYERS];
//
#define FILTERSCRIPT
#define SCM(%0,%1,%2) SendClientMessage(%0,%1,%2)

//Stocks
stock GetName(playerid) {
    new pName[26];
    GetPlayerName(playerid, pName, MAX_PLAYER_NAME);
    return pName;
}
//

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" MarkNelson's PM System has been loaded");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	print("\n----------------------------------");
	print(" MarkNelson's PM System has been unloaded");
	print("----------------------------------\n");
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	return 1;
}

public OnPlayerConnect(playerid)
{
	LastPm[playerid] = -1;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	LastPm[playerid] = -1;
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
    {
	  case DIALOG_PM:
      {
	   if(!response) SendClientMessage(playerid, COLOR_RED, "Process Canceled.");
       if(response)
       {
          new str[80];
          new id = GetPVarInt(playerid,"ClickedPlayer");
          format(str, sizeof(str), "%d %s", id, inputtext);
          cmd_pm(playerid, str);
       }
      }
    }
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(clickedplayerid == playerid) return SCM(playerid, COLOR_RED, "You can't send a pm to yourself");
    if(clickedplayerid == INVALID_PLAYER_ID) return SCM(playerid, COLOR_RED, "Invalid player ID");
    if(!IsPlayerConnected(clickedplayerid)) return SCM(playerid, COLOR_RED, "Player is not connected");
    SetPVarInt(playerid,"ClickedPlayer",clickedplayerid);
    ShowPlayerDialog(playerid, DIALOG_PM, DIALOG_STYLE_INPUT, "Private Message", "Enter your message below:", "Send", "Cancel");
	return 1;
}
CMD:pm(playerid, params[])
{
    new str[175], str2[175], id, Name1[MAX_PLAYER_NAME], Name2[MAX_PLAYER_NAME];
    if(sscanf(params, "us", id, str2))
    {
        SendClientMessage(playerid, COLOR_ORANGE, "Usage: /pm <id> <message>");
        return 1;
    }
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid, COLOR_RED, "ERROR: Player not connected");
    if(playerid == id) return SendClientMessage(playerid, COLOR_RED, "ERROR: You cannot pm yourself!");
    {
        GetPlayerName(playerid, Name1, sizeof(Name1));
        GetPlayerName(id, Name2, sizeof(Name2));
        format(str, sizeof(str), "PM To %s(ID %d): %s", Name2, id, str2);
        SendClientMessage(playerid, COLOR_ORANGE, str);
        PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
        format(str, sizeof(str), "PM From %s(ID %d): %s", Name1, playerid, str2);
        SendClientMessage(id, COLOR_YELLOW, str);
        PlayerPlaySound(id, 1057, 0.0, 0.0, 0.0);
        printf(str);
        LastPm[id] = playerid;
    }
    return 1;
}
CMD:re(playerid, params[])
{
    new string[128], message[128];
    if(sscanf(params,"s[128]",message)) return SCM(playerid, COLOR_ORANGE, "Usage: /re <Message>");
    if(LastPm[playerid] == -1) return SCM(playerid, COLOR_RED, "The last player who messaged you last time has left the server");
    format(string, 128, "PM To %s(ID %d): %s", GetName(LastPm[playerid]), LastPm[playerid], message);
    SCM(playerid, COLOR_ORANGE, string);
    PlayerPlaySound(playerid, 1083, 0.0, 0.0, 0.0);
    format(string, 128, "PM From %s(ID %d): %s", GetName(playerid), playerid, message);
    SCM(LastPm[playerid], COLOR_YELLOW, string);
    LastPm[LastPm[playerid]] = playerid;
    PlayerPlaySound(LastPm[playerid], 1057, 0.0, 0.0, 0.0);
    return 1;
}
