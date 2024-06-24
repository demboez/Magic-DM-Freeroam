#if defined (c)Copyright_2012
________________________________________________________________________________
********************************************************************************
================================================================================

									aFly (source code)
							     ----------------------
								   			- by Vishnu

________________________________________________________________________________
********************************************************************************
================================================================================

									CONTACT INFO
									------------

email    <::> vishnu4307@gmail.com
facebook <::> facebook.com/vishnu4307
website  <::> www.vggaming.tk

If anyone have any doubts or complaints or suggestion about this gamemode please
feel free to inform me.
I am looking for co developers. If you are willing to help please contact me.
________________________________________________________________________________
********************************************************************************
================================================================================
									    INFO
										----
* ZCMD include from Zeex needed to compile the script.

* Use /fly to switch to aFly mode and /fly again toe deactivate aFly.

		***Say good bye to the bugged s0biet and other hacks!***

________________________________________________________________________________
********************************************************************************
================================================================================
/*
											 /\
                                            //\\
										   // \\
		 					              //   \\
		                                 //     \\
										// RULES \\
                                       //         \\
									   -------------
*/
RULE 1 -
--------
" You may not sell this script under any circumstances.							"

RULE 2 -
--------
" You may edit this script. But don't claim it as yours.						"

________________________________________________________________________________
********************************************************************************
================================================================================
#endif

//==============================================================================
//-------------------------------------------------
// Includes
//-------------------------------------------------
//==============================================================================
#include <a_samp>
#include <zcmd>
//==============================================================================
//-------------------------------------------------
// Variables
//-------------------------------------------------
//==============================================================================
new bool:flying[MAX_PLAYERS];
//==============================================================================
//-------------------------------------------------
// Forwards
//-------------------------------------------------
//==============================================================================
forward AdminFly(playerid);
forward Float:SetPlayerToFacePos(playerid, Float:X, Float:Y);
//==============================================================================
//-------------------------------------------------
// Primary callbacks
//-------------------------------------------------
//==============================================================================
public OnFilterScriptInit()
{
	new year,month,day;
	getdate(year, month, day);
	new hour,minute,second;
	gettime(hour,minute,second);
	
	printf("\n------------------------------------------------");
	printf(" aFly by Vishnu - Replace s0biet, Replace hacks");
	printf("------------------------------------------------\n");

	printf("| LOADED | Date: %d/%d/%d | Time: %d:%d:%d |",day,month,year,hour, minute, second);
	return 1;
}

public OnFilterScriptExit()
{
	new year,month,day;
	getdate(year, month, day);
	new hour,minute,second;
	gettime(hour,minute,second);
	
	printf("\n------------------------------------------------");
	printf(" aFly by Vishnu - Replace s0biet, Replace hacks");
	printf("------------------------------------------------\n");
	
	printf("| UNLOADED | Date: %d/%d/%d | Time: %d:%d:%d |",day,month,year,hour, minute, second);
	return 1;
}

//==============================================================================
//-------------------------------------------------
// Secondary callbacks
//-------------------------------------------------
//==============================================================================
public AdminFly(playerid)
{
	if(!IsPlayerConnected(playerid))
		return flying[playerid] = false;

	if(flying[playerid])
	{
	    if(!IsPlayerInAnyVehicle(playerid))
	    {
			new
			    keys,
				ud,
				lr,
				Float:x[2],
				Float:y[2],
				Float:z;

			GetPlayerKeys(playerid, keys, ud, lr);
			GetPlayerVelocity(playerid, x[0], y[0], z);
			if(ud == KEY_UP)
			{
				GetPlayerCameraPos(playerid, x[0], y[0], z);
				GetPlayerCameraFrontVector(playerid, x[1], y[1], z);
    			ApplyAnimation(playerid, "SWIM", "SWIM_crawl", 4.1, 0, 1, 1, 0, 0);
				SetPlayerToFacePos(playerid, x[0] + x[1], y[0] + y[1]);
				SetPlayerVelocity(playerid, x[1], y[1], z);
			}
			else
			SetPlayerVelocity(playerid, 0.0, 0.0, 0.01);
		}
		SetTimerEx("AdminFly", 100, 0, "d", playerid);
	}
	return 0;
}

public Float:SetPlayerToFacePos(playerid, Float:X, Float:Y)
{
	new
		Float:pX1,
		Float:pY1,
		Float:pZ1,
		Float:ang;

	if(!IsPlayerConnected(playerid)) return 0.0;

	GetPlayerPos(playerid, pX1, pY1, pZ1);

	if( Y > pY1 ) ang = (-acos((X - pX1) / floatsqroot((X - pX1)*(X - pX1) + (Y - pY1)*(Y - pY1))) - 90.0);
	else if( Y < pY1 && X < pX1 ) ang = (acos((X - pX1) / floatsqroot((X - pX1)*(X - pX1) + (Y - pY1)*(Y - pY1))) - 450.0);
	else if( Y < pY1 ) ang = (acos((X - pX1) / floatsqroot((X - pX1)*(X - pX1) + (Y - pY1)*(Y - pY1))) - 90.0);

	if(X > pX1) ang = (floatabs(floatabs(ang) + 180.0));
	else ang = (floatabs(ang) - 180.0);

	ang += 180.0;

	SetPlayerFacingAngle(playerid, ang);

 	return ang;
}
//==============================================================================
//-------------------------------------------------
// ZCMD commands
//-------------------------------------------------
//==============================================================================
CMD:fly(playerid, params[])
{

	{


	    new Float:x, Float:y, Float:z;
		if((flying[playerid] = !flying[playerid]))
		{
		    GetPlayerPos(playerid, x, y, z);
		    SetPlayerPos(playerid, x, y, z+5);
    		SetPlayerArmour(playerid, 1000000000.0);
		    SetPlayerHealth(playerid, 1000000000.0);
		    SetTimerEx("AdminFly", 100, 0, "d", playerid);
		}
		else
		{
		    GetPlayerPos(playerid, x, y, z);
		    SetPlayerPos(playerid, x, y, z+0.5);
		    ClearAnimations(playerid);
		    SetPlayerArmour(playerid, 100.0);
		    SetPlayerHealth(playerid, 100.0);
			return 1;
		}

	}
	return 1;
}
// © VGGaming 2012 - All rights Reserved
