//Magic DeathMatch/Freeroam by Lezduit & Chat-GPT 3.5
//Beta V1.0
//Please DO NOT remove credits!!
//Report bugs to creator: https://discord.gg/SNJkHHhw
//========================<<[include]>>==========================//
#include <a_samp>
#include <dini>
#include <core>
#include <float>
#include <string>
#include <file>
#include <time>
#include <datagram>
#include <a_players>
#include <a_vehicles>
#include <a_objects>
#include <a_sampdb>
#include <DOF2>
#include <streamer>
#include <sscanf2>
#include <dudb>
#include <file>
#pragma dynamic 10000000
#pragma tabsize 0
forward OnVehicleDestroy(vehicleid);
forward RandomMessage();
forward RefillNitro(vehicleid);
//========================<<[NEW]>>==========================//
new req[MAX_PLAYERS];
new Ammo;
new pickuparmor;
new pickuphp;
new pickupbazoka;
new ship;
new Text3D:vehicle3Dtext[MAX_VEHICLES];
new vehicle_id;
new Text:randommsg;
new Float:SafeZoneX = 2001.2804;
new Float:SafeZoneY = 1544.4365;
new Float:SafeZoneZ = 13.5859;
new Float:SafeZoneRadius = 10.0;
new Float:PosX[MAX_PLAYERS];
new Float:PosY[MAX_PLAYERS];
new Float:PosZ[MAX_PLAYERS];
new Float:PosA[MAX_PLAYERS];
new PosI[MAX_PLAYERS];
new Text3D:label[MAX_PLAYERS];
new bool:IsAFK[MAX_PLAYERS];
new LastUpdate[] = "19/06/2024";
new CommandList[] = "/Help - This Help Menu\n/HelpMe - Request help from the admin team\n/Kill - Kill yourself\n/Credits \n/Rules - Server rules\n/AFK - Enter/Exit AFK mode\n/Tele - List of teleports\n/N - Add nitro to your vehicle\n/Fix - Repair your vehicle\n/Fly - Fly in the server\n/DM - List of DM areas\n/Admins - List of online admins";
new RulesList[] = "1. Do not advertise competing communities.\n2. Do not exploit any bugs you find.\n3. Do not perform spawn killing.\n4.  Do not curse at any players / admins on the server.\n5. Do not use cheats / hacks on the server.\n6. Do not report players in the chat.\n7. Do not spam players on the server.\n8. Do not use mods, e.g., parkour mods.\n9. Do not attempt to bypass the system in any way.";
//========================<<[Colors]>>==========================//
#define Red 		0xFF0000AA
#define Yellow		0xFFFF00AA
#define White 		0xFFFFFFAA
#define Blue 		0x33CCFFAA
#define Orange 		0xFF9900AA
#define Green 		0x33AA33AA
#define Grey 		0xAFAFAFAA
#define Black       0x000000AA
#define gmR         0x1589FFAA
#define Pink        0xFF00CCAA
#define Azure 		0x00CCFFAA
#define LightBlue 	0x00FFE5AA
#define Purple      0x5D478BAA
#define LightYellow 0xFFFFE0AA
#define Golden 0xFFD700FF
//========================<<[Dialogs]>>==========================//
#define DIALOG_REG  (001)
#define DIALOG_LOG  (002)
#define DIALOG_INF  (003)
#define DIALOG_HELP 1000
#define DIALOG_TELEPORTS 1001
#define DIALOG_COMMANDS 1002
#define DIALOG_RULES 1003
#define DIALOG_SERVERINFO 1004
#define DIALOG_CREDITS 1005
#define DIALOG_BUY_WEAPONS
#define DIALOG_INFO 1
#define CHECKPOINT_TEST 1
#define AMMO 1
#define ADMIN_RCON_LEVEL 3 
//#define DIALOG_HELP 1 - DONT USE
//========================<<[Others]>>==========================//
#define SAFE_ZONE_X 2001.2804
#define SAFE_ZONE_Y 1544.4365
#define SAFE_ZONE_Z 13.5859
#define SAFE_ZONE_RADIUS 10.0 
//========================<<[Login/Register]>>==========================//
#define PATH "/Users/%s.ini"


new RandomMessages[][] =
{
       "TEST (Change this)",
       "TEST2 (Change this)",
       "TEST3 (Change this)"
};

enum pInfo
{
    pAdmin,
	pVip,
	pCash,
    pScore,
    pKills,
    pDeaths,
}
new PlayerInfo[MAX_PLAYERS][pInfo];
new gPlayerLogged[MAX_PLAYERS];

//========================<<[Teleports Menu + - NEW]>>==========================//
new Float:TeleportLocations[13][3] = {
    {2057.9421,842.8384,6.7031},          // Race
    {1474.7648,-1715.2794,14.0469},      // LS
    {2028.5544, 1340.9491, 10.8203},          // LV
    {-2578.6194, 1100.4614, 55.5781},       // SF
    {1706.5563, 1608.4502, 10.0156},   // AP
    {214.2294, 1908.4487, 17.6406},     // ARMY
    {1544.3032, -1353.2784, 329.4744},     // TOWER
    {-863.7606, -1983.8845, 18.1053},     // SWAMP
    {2330.9800, 1409.1500, 42.8203},     // DRIFT
    {-296.3609, 1772.1890, 42.6875},     // JEEPS
    {-2342.9651, -1599.4357, 483.6536},     // CHILIAD
    {2032.3456, 1007.0475, 10.8203},     // CASINO
    {-2182.5940, 1677.7584, 11.0723}   // CASINO2
};
//========================<<[Teleports - NEW]>>==========================//
enum e_Teleports
{
	TPName[30],
	TeleportName[15],
	Message[120],
	Float:TeleX,
	Float:TeleY,
	Float:TeleZ,
	Float:TeleA,
	Float:TeleVX,
	Float:TeleVY,
	Float:TeleVZ,
	Float:TeleVA,
	AllowVehicle,
	Interior,
	VirtualWorld,
	AllowAFK,
	bool:ObjectLoad,
	bool:InCar,
};
new TeleportNames[][] = {
    "Race",
    "LS",
    "LV",
    "SF",
    "AP",
    "ARMY",
    "TOWER",
    "SWAMP",
    "DRIFT",
    "JEEPS",
    "CHILIAD",
    "CASINO",
    "CASINO2"
};

new Teleport[][e_Teleports]=
{
	{"Race","/Race","!Welcome To Race!",2057.4519,842.9686,6.7922,357.6335,2057.4519,842.9686,6.7922,357.6335,1,0,0,0,true, true},
    //{"LV","/LV","Welcome To Las Venturas!",2086.61,1165.01,10.82,268.1871,2086.61,1165.01,10.82,268.1871,1,0,0,0,false,true},
	{"LS","/LS","Welcome To Los Santos!",1474.5283,-1715.5085,14.0469,359.6599,1474.5283,-1715.5085,14.0469,359.6599,1,0,0,0,false,true},
	{"SF","/SF","Welcome To San Fierro",-1914.2476,883.3618,35.3887,359.6599,-1914.2476,883.3618,35.3887,359.6599,1,0,0,0,false,true},
	//{"Bank","/Bank","!ברוך הבא לבנק",3093.9722,-1808.1891,9.6328,0.6992,3093.9722,-1808.1891,8.1328,0.6992,0,0,1,0,true,false},
	{"Ap","/Ap","Welcome To The Airport!",1707.4934,1607.3639,10.0156,74.7841,1643.4862,1588.0917,10.8203,96.6755,1,0,0,0,false,true},
	{"Army","/Army","!Welcome To The Army Base!",214.2294,1908.4487,17.6406,178.9401,214.2294,1908.4487,17.6406,178.9401,1,0,0,0,false,false},
	{"Ramp","/Ramp","Welcome To The Ramp Area!",1930.3053,-1396.3635,13.5703,181.0620,1930.3053,-1396.3635,13.5703,181.0620,1,0,0,0,false,true},
	{"Jump","/Jump","Welcome To The Jump Area!",-662.0400,2305.9756,136.0404,90.3722,-662.0400,2305.9756,136.0404,90.3722,1,0,0,0,false,true},
	{"Jeeps","/Jeeps","Welcome To The Jeeps Area!",-296.3609,1772.1890,42.6875,180.2061,-307.5496,1767.6116,43.6406,271.6446,1,0,0,0,false,true},
	{"Police","/Police","Welcome To The Police Station!",2238.01,2453.94,10.82,270.5280,2238.01,2453.94,10.82,319.5685,1,0,0,0,false,true},
	{"Drift","/Drift","Welcome To The Drift Area!",2330.98,1409.15,42.82,319.5685,2330.98,1409.15,42.82,319.5685,1,0,0,0,false,true},
	{"Swamp","/Swamp","Welcome To The Swamp!",-863.7606,-1983.8845,18.1053,339.5688,-875.3824,-1967.1909,16.8509,308.1491,1,0,0,0,false,true},
	{"Chiliad","/Chiliad","Welcome To Mount Chiliad!",-2342.9651,-1599.4357,483.6536,231.6886,-2342.9651,-1599.4357,483.6536,231.6886,1,0,0,0,false,true},
	{"Tower","/Tower","Welcome To The Tower!",1544.3032,-1353.2784,329.4744,271.0214, 1541.1882,-1366.7660,329.7969,359.1941,1,0,0,0,false,true},
	{"Trucks","/Trucks","Welcome To The Trucks Area!",-526.6296,2593.3484,53.4141,268.0647,-526.6296,2593.3484,53.4141,268.0647,1,0,0,0,false,true},
	{"Trip","/Trip","Welcome To The Trip Area!",-1331.0828,2655.1931,50.3164,351.7371,-1331.0828,2655.1931,50.3164,351.7371,1,0,0,0,false,true},
	{"Car Shop","/CarShop","Welcome To The Carshop",-1897.4003,253.8361,41.0469,0.0629,-1897.4003,253.8361,41.0469,0.0629,0,0,0,0,false,true},
	{"Bus","/Bus","!Welcome To The Bus Stastion",1000.2962,1758.2288,10.9219,359.1605,1000.2962,1758.2288,10.9219,359.1605,1,0,0,0,false,true},
	{"Stunts 1","/Stunts 1","Welcome To Stunts Area #1! ",-379.9577,-1095.7651,280.4775,180.6241,-379.9577,-1095.7651,280.4775,180.6241,1,0,0,0,true,true},
	{"Stunts 2","/Stunts 2","Welcome To Stunts Area #2",-1350.3236,-233.4533,19.1803,180.6241,-1350.3236,-233.4533,19.1803,180.6241,1,0,0,0,true,true}
};

Float:GetDistanceBetweenPoints3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return floatsqroot(floatpower(x2 - x1, 2) + floatpower(y2 - y1, 2) + floatpower(z2 - z1, 2));
}
#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Blank Filterscript by your name here");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n----------------------------------");
	print(" SERVER IS ON - Magic BETA v1.0");
	print("----------------------------------\n");
}

#endif

public RandomMessage()
{
        TextDrawSetString(randommsg, RandomMessages[random(sizeof(RandomMessages))]); // We need this to make the timer working
        return 1;
}
public OnGameModeInit()
{
SetGameModeText("MD:v1.0");
UsePlayerPedAnims();
SetTimer("RandomMessages",8000,1);
randommsg = TextDrawCreate(7.000000, 427.000000, "Magic DeathMatch/Freeroam Beta v1.0");
TextDrawBackgroundColor(randommsg, 255);
TextDrawFont(randommsg, 1);
TextDrawLetterSize(randommsg, 0.379999, 1.499999);
TextDrawColor(randommsg, -1);
TextDrawSetOutline(randommsg, 1);
TextDrawSetProportional(randommsg, 1);
//========================<<[Pickups]>>==========================//
pickuparmor = CreatePickup(1242, 2, 2015.9006, 901.4726, 10.8203, -1); // RACE Armor
pickuphp = CreatePickup(1240, 2, 2013.5811, 901.7858, 10.8203, -1); // RACE HP
pickupbazoka = CreatePickup(359, 2, 2010.7385, 901.8138, 10.8203, -1); // RACE BAZOKA
//========================<<[Checkpoints]>>==========================//
ship = CreateDynamicCP(2003.9208, 1543.9696, 13.5908, 3.0); // ship
//========================<<[Skins]>>==========================//
AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(1, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(2, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(3, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(4, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(5, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(6, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(7, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(8, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(9, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(10, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(11, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(12, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(13, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(14, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(15, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(16, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(17, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(18, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(19, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
AddPlayerClass(294, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
//========================<<[Cars]>>==========================//
//========================<<[Race]>>==========================//
vehicle_id = AddStaticVehicle(411,2074.9138,819.2700,7.4123,1.3532,106,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Blue,2074.9138,819.2700,7.4123,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(411,2070.7754,819.6518,7.3374,1.1790,64,1); 
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",White,2070.7754,819.6518,7.3374,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(411,2066.0239,819.6689,7.3340,359.7705,123,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Red,2066.0239,819.6689,7.3340,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(451,2044.5127,820.8805,7.0750,2.5587,125,125); 
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Grey,2044.5127,820.8805,7.0750,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(451,2048.2681,821.1055,7.0252,1.6746,16,16);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Pink,2048.2681,821.1055,7.0252,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(451,2051.8125,821.5493,6.9376,359.1656,36,36); 
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",LightBlue,2051.8125,821.5493,6.9376,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(411,2080.5068,873.1006,6.8323,139.4098,116,1); 
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Azure,2080.5068,873.1006,6.8323,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(506,2033.1686,872.5025,6.7880,253.4503,6,6); 
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",LightYellow,2033.1686,872.5025,6.7880,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(506,2033.8879,877.1148,6.8983,239.4465,52,52); 
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",gmR,2033.8879,877.1148,6.8983,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = CreateVehicle(506,2034.8339,881.5247,7.0035,238.8485,7,7, -1); 
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2034.8339,881.5247,7.0035,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = CreateVehicle(522,2060.7361,801.4044,10.3935,0.2788,6,25, -1); 
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2060.7361,801.4044,10.3935,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(522,2059.4890,801.3139,10.3902,2.3448,8,82);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2059.4890,801.3139,10.3902,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(521,2061.8352,801.4619,10.3929,355.5108,75,13); 
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2061.8352,801.4619,10.3929,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(521,2049.2190,800.9251,10.3897,0.2324,75,13); 
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2049.2190,800.9251,10.3897,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(411,2079.8530,877.8123,6.9426,129.7381,112,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2079.8530,877.8123,6.9426,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(521,2046.6317,800.9094,10.3881,7.0617,87,118);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2046.6317,800.9094,10.3881,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(521,2047.9210,800.9684,10.3952,359.2821,92,3);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2047.9210,800.9684,10.3952,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(541,2084.7490,915.6172,8.4222,42.0460,22,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2084.7490,915.6172,8.4222,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(541,2084.7480,908.9221,8.0587,42.0638,13,8);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2084.7480,908.9221,8.0587,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(541,2084.4014,902.3447,7.7224,41.8188,2,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2084.4014,902.3447,7.7224,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(541,2030.0122,919.2604,8.6206,331.7889,58,8);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2030.0122,919.2604,8.6206,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(541,2030.3364,910.8608,8.1648,331.8938,51,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2030.3364,910.8608,8.1648,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(541,2030.9095,902.9253,7.7424,331.9073,36,8);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2030.9095,902.9253,7.7424,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
//========================<<[Los Santos]>>==========================//
vehicle_id = AddStaticVehicle(412,1454.5262,-1748.1185,13.3827,2.8601,11,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Red,1454.5262,-1748.1185,13.3827,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(463,1486.4633,-1766.1461,18.3345,357.8344,84,84);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Yellow,1486.4633,-1766.1461,18.3345,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(461,1492.4594,-1766.0435,18.3838,358.6927,43,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",White,1492.4594,-1766.0435,18.3838,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(462,1481.1322,-1765.9332,18.3915,358.2266,14,14);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Blue,1481.1322,-1765.9332,18.3915,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(522,1475.5242,-1766.0848,18.3654,0.3027,51,118);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1475.5242,-1766.0848,18.3654,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(521,1470.0457,-1766.0784,18.3420,0.2323,92,3);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Green,1470.0457,-1766.0784,18.3420,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(421,1453.8281,-1736.0211,13.2419,90.6770,36,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",gmR,1453.8281,-1736.0211,13.2419,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(409,1474.4485,-1728.5414,13.1555,270.3886,1,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Pink,1474.4485,-1728.5414,13.1555,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(437,1535.8192,-1672.7310,13.5491,359.9084,87,7);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Azure,1535.8192,-1672.7310,13.5491,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(541,1525.9191,-1655.7261,13.0140,0.0057,51,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",LightBlue,1525.9191,-1655.7261,13.0140,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(541,1533.7781,-1650.2971,13.0592,354.0877,58,8);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Purple,1533.7781,-1650.2971,13.0592,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(560,1458.2484,-1726.9025,13.1663,269.7092,148,9);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",LightYellow,1458.2484,-1726.9025,13.1663,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(560,1512.5106,-1727.6766,13.1666,272.7210,148,9);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Golden,1512.5106,-1727.6766,13.1666,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(560,1481.2582,-1742.4417,13.2139,0.6564,148,9);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",LightYellow,1481.2582,-1742.4417,13.2139,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
//========================<<[Las Venturas]>>==========================//
vehicle_id = AddStaticVehicle(585,2073.5000,1305.7499,10.2540,0.0002,37,37);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Red,2073.5000,1305.7499,10.2540,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(585,2041.6000,1333.8044,10.2854,0.0000,15,15);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,2041.6000,1333.8044,10.2854,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(529,2039.0000,1364.5009,10.3074,0.0000,11,11);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Yellow,2039.0000,1364.5009,10.3074,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(585,2100.0076,1397.4008,10.4294,359.6568,53,53);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Blue,2100.0076,1397.4008,10.4294,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(585,2100.6001,1410.3009,10.4338,359.9999,62,62);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Pink,2100.6001,1410.3009,10.4338,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(529,2122.3000,1410.9020,10.4534,359.9950,37,37);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Purple,2122.3000,1410.9020,10.4534,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(585,2135.8000,1397.0009,10.4338,360.0000,7,7);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",LightBlue,2135.8000,1397.0009,10.4338,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(585,2146.0000,1409.2008,10.4338,0.0000,10,10);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Golden,2146.0000,1409.2008,10.4338,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
//========================<<[Airport]>>==========================//
vehicle_id = AddStaticVehicle(487,1694.8043,1634.2081,10.9703,180.0025,26,57);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1694.8043,1634.2081,10.9703,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(487,1684.8043,1634.2081,10.9703,180.0025,54,29);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1684.8043,1634.2081,10.9703,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(487,1675.1042,1634.2081,10.9703,180.0022,26,3);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1675.1042,1634.2081,10.9703,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(487,1665.8016,1634.3046,10.9617,180.0127,3,29);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1665.8016,1634.3046,10.9617,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(563,1655.4080,1535.2782,11.5320,359.9899,1,6);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1655.4080,1535.2782,11.5320,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(548,1635.2761,1538.4980,12.4306,357.4492,1,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1635.2761,1538.4980,12.4306,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(563,1612.6991,1535.2502,11.5681,359.9429,1,6);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1612.6991,1535.2502,11.5681,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(519,1617.5123,1624.3998,11.6986,87.9948,1,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1617.5123,1624.3998,11.6986,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(519,1576.0052,1644.5999,11.7493,87.9996,1,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1576.0052,1644.5999,11.7493,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(519,1566.3958,1498.8998,11.7620,87.9962,1,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1566.3958,1498.8998,11.7620,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(593,1563.7113,1470.1995,11.2262,90.0571,58,8);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1563.7113,1470.1995,11.2262,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(593,1563.6088,1454.3206,11.2856,90.0740,60,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1563.6088,1454.3206,11.2856,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(593,1562.7983,1439.6627,11.2959,89.6271,68,8);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1562.7983,1439.6627,11.2959,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(513,1562.0663,1427.1857,11.3977,96.6339,21,36);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1562.0663,1427.1857,11.3977,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(513,1563.4606,1417.5172,11.3667,101.3556,21,34);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1563.4606,1417.5172,11.3667,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(513,1564.4087,1407.2084,11.3684,97.6688,30,34);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1564.4087,1407.2084,11.3684,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(469,1702.4033,1571.4479,10.7871,82.0135,1,3);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1702.4033,1571.4479,10.7871,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(563,1655.4014,1535.1406,11.5145,359.9890,1,6);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1655.4014,1535.1406,11.5145,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(563,1612.7019,1535.3307,11.4965,359.9987,1,6);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1612.7019,1535.3307,11.4965,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
vehicle_id = AddStaticVehicle(519,1566.3888,1498.8994,11.7618,87.8684,1,1);
vehicle3Dtext[ vehicle_id ] = Create3DTextLabel( "Public Car",Orange,1566.3888,1498.8994,11.7618,100,0);
Attach3DTextLabelToVehicle( vehicle3Dtext[ vehicle_id ] , vehicle_id, 0,0,0);
//========================<<[Ramp]>>==========================//
AddStaticVehicle(522,1926.7024,-1414.9264,13.1421,7.1817,3,8); //RAMP
AddStaticVehicle(522,1923.9996,-1415.1354,13.1409,2.9485,6,25); //RAMP
AddStaticVehicle(522,1921.0889,-1415.2601,13.1413,7.8489,7,79); //RAMP
AddStaticVehicle(522,1918.8931,-1415.2413,13.1368,359.5339,36,105); //RAMP
AddStaticVehicle(522,1915.8011,-1415.2031,13.1347,359.7603,39,106); //RAMP
AddStaticVehicle(522,1913.1403,-1415.2778,13.1327,359.4138,51,118); //RAMP
AddStaticVehicle(522,1910.0768,-1415.6338,13.1383,0.0000,3,3); //RAMP
AddStaticVehicle(481,1924.8014,-1380.3105,13.0442,61.5818,3,3); //RAMP
AddStaticVehicle(481,1925.4832,-1378.7179,13.0454,60.1256,6,6); //RAMP
AddStaticVehicle(481,1925.2645,-1376.8470,13.0443,62.7404,46,46); //RAMP
AddStaticVehicle(481,1923.8794,-1372.8793,13.0744,78.3066,14,1); //RAMP
AddStaticVehicle(481,1924.6904,-1374.8827,13.0580,74.7704,65,9); //RAMP
AddStaticVehicle(481,1922.3512,-1370.5220,13.1367,81.7490,12,9); //RAMP
AddStaticVehicle(510,1911.3727,-1357.7743,13.1710,179.3875,5,5); //RAMP
AddStaticVehicle(510,1909.1270,-1357.3855,13.1344,183.7094,2,2); //RAMP
AddStaticVehicle(510,1906.8894,-1357.0698,13.1000,160.8104,43,43); //RAMP
AddStaticVehicle(510,1903.8206,-1356.7301,13.0880,172.3132,46,46); //RAMP
AddStaticVehicle(510,1901.0947,-1356.4314,13.1035,180.8716,39,39); //RAMP
AddStaticVehicle(407,1749.0522,-1455.5929,13.6935,268.0598,3,1); //RAMP
AddStaticVehicle(451,1678.8185,-1460.3071,13.2790,269.4637,16,16); //RAMP
//========================<<[LVPD]>>==========================//
AddStaticVehicle(598,2251.7124,2443.3899,10.5704,358.7861,0,1); // LVPD
AddStaticVehicle(598,2256.6418,2442.6252,10.5583,353.2597,0,1); // LVPD
AddStaticVehicle(599,2277.9575,2459.9448,10.9292,180.0182,0,1); // LVPD
AddStaticVehicle(599,2273.4819,2459.8997,10.9427,180.6090,0,1); // LVPDJEEP
AddStaticVehicle(599,2269.0789,2460.0217,10.9384,179.3414,0,1); // LVPDJEEP
AddStaticVehicle(427,2292.3047,2468.6948,10.8842,88.9375,0,1); // LVPDTRUCK
AddStaticVehicle(427,2292.4109,2450.9282,10.9858,88.7975,0,1); // LVPDTRUCK
AddStaticVehicle(598,2260.3472,2459.3672,10.5665,0.5869,0,1); // LVPD
AddStaticVehicle(598,2252.0339,2476.3613,10.5617,358.7506,0,1); // LVPD
AddStaticVehicle(598,2251.6973,2460.9246,10.5657,358.7505,0,1); // LVPD
AddStaticVehicle(598,2255.8994,2459.3481,10.5704,359.5315,0,1); // LVPD
AddStaticVehicle(528,2282.1770,2476.6079,10.8218,179.4698,0,0); // LVPDfb
AddStaticVehicle(528,2277.4094,2478.2256,10.8637,178.6886,0,0); // LVPDfb
AddStaticVehicle(528,2273.4441,2478.1931,10.8625,181.9522,0,0); // LVPDfb
AddStaticVehicle(528,2268.9099,2478.2256,10.8639,179.8236,0,0); // LVPDfb
AddStaticVehicle(598,2255.8240,2476.6003,10.5648,0.2988,0,1); // LVPD
AddStaticVehicle(598,2260.0200,2477.2883,10.5654,357.8940,0,1); // LVPD
//========================<<[Drift]>>==========================//
AddStaticVehicle(451,2301.7083,1412.2758,42.5403,269.3612,36,36); // drift
AddStaticVehicle(451,2301.9519,1419.4673,42.5403,271.3243,125,125); // drift
AddStaticVehicle(451,2301.9832,1426.4575,42.5432,270.7259,123,123); // drift
AddStaticVehicle(451,2302.0911,1433.8387,42.5436,268.9344,75,75); // drift
AddStaticVehicle(451,2302.5591,1441.3536,42.5436,269.9017,61,61); // drift
AddStaticVehicle(415,2302.0205,1448.1265,42.5635,270.2671,40,1); // drift
AddStaticVehicle(415,2301.6563,1455.1858,42.5395,269.5339,36,1); // drift
AddStaticVehicle(415,2301.6353,1462.3690,42.5394,271.1489,25,1); // drift
AddStaticVehicle(415,2301.7307,1469.3290,42.5554,267.2963,20,1); // drift
AddStaticVehicle(415,2301.9971,1476.5007,42.5473,270.7053,0,1); // drift
AddStaticVehicle(541,2353.3320,1476.4684,42.4552,88.0715,22,1); // drift
AddStaticVehicle(541,2353.4939,1469.1699,42.3873,90.7716,36,8); // drift
AddStaticVehicle(541,2353.3169,1461.9657,42.4533,90.4324,51,1); // drift
AddStaticVehicle(541,2353.1245,1455.3739,42.4600,89.1739,58,8); // drift
AddStaticVehicle(541,2352.8591,1447.9274,42.4600,89.1815,60,1); // drift
AddStaticVehicle(560,2353.0544,1433.5642,42.4718,90.1781,0,0); // drift
AddStaticVehicle(560,2352.7231,1426.7151,42.4495,91.0214,9,39); // drift
AddStaticVehicle(560,2352.7258,1419.3674,42.4777,89.8970,1,1); // drift
AddStaticVehicle(560,2352.5974,1412.1356,42.4953,89.5684,180,0); // drift
AddStaticVehicle(562,2312.4678,1387.5327,42.4507,359.7556,1,1); // drift
AddStaticVehicle(562,2305.5356,1387.1851,42.4583,358.8640,0,0); // drift
AddStaticVehicle(562,2298.8962,1387.7080,42.4645,359.5704,77,1); // drift
//========================<<[Jeeps]>>==========================//
AddStaticVehicle(424,-290.6252,1778.0570,42.5310,269.3834,2,2); // jeeps
AddStaticVehicle(424,-290.6437,1774.9647,42.4568,272.7526,3,2); // jeeps
AddStaticVehicle(424,-289.6393,1770.9784,42.5268,265.0420,3,6); // jeeps
AddStaticVehicle(424,-290.6973,1766.4637,42.5143,269.4061,6,16); // jeeps
AddStaticVehicle(424,-290.7490,1761.4904,42.5143,269.4059,15,30); // jeeps
AddStaticVehicle(424,-290.7810,1757.4987,42.5161,269.4059,24,53); // jeeps
AddStaticVehicle(424,-290.8220,1752.8763,42.5177,269.5464,35,61); // jeeps
AddStaticVehicle(495,-300.2352,1750.2061,42.9483,89.6068,114,108); // jeeps
AddStaticVehicle(495,-300.2284,1754.5282,42.9496,89.5457,101,106); // jeeps
AddStaticVehicle(495,-300.1681,1757.9866,42.9509,88.9554,88,99); // jeeps
AddStaticVehicle(495,-300.1555,1762.3795,42.9482,89.6004,5,6); // jeeps
AddStaticVehicle(495,-300.1133,1773.5062,42.9480,89.6059,119,122); // jeeps
AddStaticVehicle(495,-300.0359,1778.6780,42.9519,89.3185,123,124); // jeeps
AddStaticVehicle(495,-312.1633,1755.4734,43.0321,89.7027,118,117); // jeeps
AddStaticVehicle(495,-312.1633,1746.9248,43.0535,89.5622,116,115); // jeeps
//========================<<[Jump]>>==========================//
AddStaticVehicle(568,-662.2858,2302.9353,135.8540,90.2295,17,1); // jump
AddStaticVehicle(568,-662.3492,2299.9407,135.8466,88.0897,21,1); // jump
AddStaticVehicle(463,-660.7300,2330.5500,138.2255,82.6088,19,19); // jump
AddStaticVehicle(463,-661.3524,2328.3733,138.2639,99.9434,7,7); // jump
AddStaticVehicle(468,-661.5083,2327.1765,138.3947,77.5114,3,3); // jump
AddStaticVehicle(463,-660.9154,2329.6104,138.2449,78.8628,11,11); // jump
AddStaticVehicle(468,-661.1529,2326.7646,138.3959,84.2676,46,46); // jump
AddStaticVehicle(471,-662.5342,2321.7214,138.2914,80.1801,120,114); // jump
AddStaticVehicle(471,-662.1940,2319.3022,138.2722,81.2950,103,111); // jump
AddStaticVehicle(495,-688.7888,2360.0525,128.6154,82.4796,123,124); // jump
AddStaticVehicle(495,-688.1920,2365.3159,129.1971,81.1086,119,122); // jump
AddStaticVehicle(495,-687.6857,2370.1072,129.7411,81.0922,118,117); // jump
//========================<<[San Fierro]>>==========================//
AddStaticVehicle(422,-1905.7861,898.7421,35.0161,1.5096,101,25); // sf
AddStaticVehicle(400,-1892.6543,891.6871,35.0775,359.3663,123,1); // sf
AddStaticVehicle(400,-1892.6169,867.3552,35.1172,359.4782,113,1); // sf
AddStaticVehicle(429,-1931.8818,856.7420,38.1854,94.6957,12,12); // sf
AddStaticVehicle(429,-1877.5415,911.5471,34.7513,269.3994,10,10); // sf
AddStaticVehicle(422,-1869.6635,937.8062,34.9358,271.5970,111,31); // sf
AddStaticVehicle(480,-2100.3918,803.6277,69.2743,268.1121,12,12); // sf
AddStaticVehicle(506,-2121.8508,813.2950,69.1457,91.0988,76,76); // sf
AddStaticVehicle(502,-2568.1235,1147.3053,55.6438,160.3603,51,75); // sf
AddStaticVehicle(411,-2561.8237,1113.4612,55.4389,73.2688,1,1); // sf
AddStaticVehicle(411,-2531.0222,1140.0126,55.4536,174.4691,1,1); // sf
AddStaticVehicle(522,-2593.8818,1126.8160,55.2534,59.3604,3,8); // sf
AddStaticVehicle(522,-2596.6167,1128.4622,55.2440,59.7389,3,8); // sf
AddStaticVehicle(522,-2588.7205,1123.7483,55.2634,59.3341,3,8); // sf
AddStaticVehicle(522,-2574.8633,1151.2695,55.2893,334.8275,3,8); // sf
AddStaticVehicle(522,-2571.8547,1148.4688,55.3006,156.4220,3,8); // sf
AddStaticVehicle(522,-2600.2673,1146.6157,55.1513,98.5971,3,8); // sf
AddStaticVehicle(522,-2602.7744,1147.7578,55.1395,99.5727,3,8); // sf
AddStaticVehicle(522,-2608.4678,1151.7958,55.1506,93.6186,3,8); // sf
AddStaticVehicle(522,-2612.4565,1154.4227,55.1518,91.8966,3,8); // sf
AddStaticVehicle(522,-2616.6091,1158.3196,55.1517,89.1657,3,8); // sf
AddStaticVehicle(522,-2619.8174,1161.0280,55.1507,94.5109,3,8); // sf
AddStaticVehicle(522,-2622.4038,1163.5626,55.1516,95.8118,3,8); // sf
AddStaticVehicle(451,-2506.4539,1138.8652,55.4328,180.3441,61,61); // sf
AddStaticVehicle(451,-2499.5469,1138.8480,55.4315,180.5115,61,61); // sf
AddStaticVehicle(451,-2555.7126,1111.0011,55.4794,72.6313,61,61); // sf
AddStaticVehicle(451,-2533.6450,1106.0397,55.4768,86.2104,61,61); // sf
//========================<<[LSPD]>>==========================//
AddStaticVehicle(596,1585.1595,-1671.7202,5.6212,268.7439,0,1); // lspd
AddStaticVehicle(599,1602.0024,-1695.9534,6.1146,90.5001,0,1); // lspdjeep
AddStaticVehicle(427,1595.5186,-1710.4232,6.0504,360.0000,0,1); // lspdtruck
AddStaticVehicle(596,1574.5095,-1710.3556,5.6185,359.4975,0,1); // lspd
AddStaticVehicle(523,1544.9259,-1680.2065,5.4560,90.5001,0,0); // lspdbike
AddStaticVehicle(523,1543.2970,-1675.7181,5.4629,87.2807,0,0); // lspdbike
AddStaticVehicle(523,1543.5671,-1672.4495,5.4631,91.8268,0,0); // lspdbike
AddStaticVehicle(523,1543.3379,-1668.0591,5.4628,88.6294,0,0); // lspdbike
AddStaticVehicle(523,1544.7190,-1663.6610,5.4631,86.9111,0,0); // lspdbike
AddStaticVehicle(523,1545.1344,-1658.9712,5.4560,89.9999,0,0); // lspdbike
AddStaticVehicle(523,1543.8794,-1654.4133,5.4632,94.2905,0,0); // lspdbike
AddStaticVehicle(523,1543.0360,-1650.8834,5.4627,91.7940,0,0); // lspdbike
AddStaticVehicle(596,1530.5208,-1645.3097,5.6185,179.7500,0,1); // lspd
AddStaticVehicle(596,1534.9694,-1645.6895,5.6145,180.5829,0,1); // lspd
AddStaticVehicle(596,1538.6893,-1645.6118,5.6101,181.0443,0,1); // lspd
//

//========================<<[Objects]>>==========================//
CreateObject(6965, 2036, 886.20001, 8.6, 0, 0, 0);
CreateObject(6965, 2079, 886.59998, 8.5, 0, 0, 0);
CreateObject(9833, 2057.3999, 862.20001, 8.9, 0, 0, 0);
CreateObject(3374, 2054.3999, 863.29999, 7.2, 0, 0, 0);
CreateObject(3374, 2061.3999, 862.5, 7.2, 0, 0, 0);
CreateObject(3374, 2061.5, 862.29999, 10.2, 0, 0, 0);
CreateObject(3374, 2061.3999, 862, 13.2, 0, 0, 0);
CreateObject(3374, 2054.3999, 863.09998, 10.2, 0, 0, 0);
CreateObject(3374, 2054.5, 861.70001, 13.2, 0, 0, 0);
CreateObject(3528, 2054.1001, 859.70001, 11.9, 0, 0, -96);
CreateObject(3528, 2061.1001, 860, 11.8, 0, 0, -94);
CreateObject(2780, 2057.8999, 862.09998, 5.9, 0, 0, 0);
CreateObject(3080, 2055.8999, 796.40002, 11.1, 0, 0, 178);
CreateObject(1337, 110.4, 120.9, 481.89999, 0, 0, 0);
CreateObject(1240, 2016.4, 1339.3, 10, 0, 0, 0);
CreateObject(1550, 2021.9, 1331.4, 10.2, 0, 0, 0);
CreateObject(2773, 2018.9, 1341.8, 10.3, 0, 0, 0);
CreateObject(2773, 2018.9, 1344.1, 10.3, 0, 0, 0);
CreateObject(3528, 2023.9, 1356.4, 21.9, 0, 0, 0);
CreateObject(3528, 2023.7998, 1329.0996, 20.9, 0, 0, 0);
CreateObject(8390, 1486.6, 574.5, 29.6, 0, 0, 2);
CreateObject(13594, 2056, 791.20001, 14.3, 0, 0, 0);
CreateObject(14608, 2057.8999, 858.29999, 8, 0, 0, 140);
CreateObject(5999, 1989.1, 533.09998, 36.7, 0, 0, 0);
CreateObject(2780, 1486.9, -1753.1, 14.5, 0, 0, 0);
CreateObject(2780, 1475.4, -1752.6, 14.4, 0, 0, 0);
CreateObject(2780, 1481.0996, -1752.2002, 14.4, 0, 0, 0);
CreateObject(3374, 1481.1, -1751.6, 15.9, 0, 0, 0);
CreateObject(3374, 1486.9004, -1752.7002, 16.1, 0, 0, 0);
CreateObject(3374, 1475.69995, -1752.69995, 15.9, 0, 0, 0);
CreateObject(3515, 1473.2, -1737.2, 14.4, 0, 0, -6);
CreateObject(3515, 1487.09998, -1737.40002, 14.5, 0, 0, 354);
CreateObject(3524, 1468.4, -1719.2, 15.7, 0, 0, 0);
CreateObject(3524, 1485.9, -1719.6, 15.7, 0, 0, 0);
CreateObject(3528, 1484.2, -1750.8, 22.8, 0, 0, 96);
CreateObject(3528, 1478.7, -1750.8, 22.7, 0, 0, 95.999);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}
public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid,2006.5596,1670.3845,13.3197);
	SetPlayerFacingAngle(playerid,289.6543);
	if(req[playerid] == 0)InterpolateCameraPos(playerid, 2025.7397,1643.6031,24.6975,2016.8357,1673.9775,13.2849, 3000,CAMERA_MOVE);
	if(req[playerid] == 0)InterpolateCameraLookAt(playerid, 2006.5596,1670.3845,13.3197,2006.5596,1670.3845,13.3197, 3000,CAMERA_MOVE);
	SetPlayerTime(playerid,0,0);
 	switch(random(3))
{
 case 0: ApplyAnimation(playerid,"DANCING","dnce_M_a",4.0,1,0,0,0,-1);
 case 1: ApplyAnimation(playerid,"DANCING","dnce_M_b",4.1,0,0,0,0,0);
 case 2: ApplyAnimation(playerid,"DANCING","dnce_M_c",4.1,0,0,0,0,0);
}
	req[playerid] = 1;
	return 1;
}

public OnPlayerConnect(playerid)
{
//========================<<[Log system]>>==========================//
    gPlayerLogged[playerid] = 0;
    new name[MAX_PLAYER_NAME], file[256];
    GetPlayerName(playerid, name, sizeof(name)); !
    format(file, sizeof(file), PATH, name); 
    if (!dini_Exists(file))  
    {  
        ShowPlayerDialog(playerid, 44, DIALOG_STYLE_PASSWORD, "-->{FF0000}Magic {0066CC}Account System", "{FF0000}Magic DeathMatch/Freeroam Server!\n{0066CC}Welcome! You are not registered. To register, enter a password :", "Register", "Exit");  // Showin' Register Dialog
    }  
    if(fexist(file))
    {  
        ShowPlayerDialog(playerid, 42, DIALOG_STYLE_INPUT, "-->{FF0000}Magic {0066CC}Account System", "{FF0000}Magic DeathMatch/Freeroam Server\n{0066CC}Welcome Back !\n{FFFF00}Enter your password to log in{FF0000} :", "Login", "Exit"); //  // Showin' Login Dialog !
    }
//========================<<[Log system]>>==========================//

SetPlayerHealth(playerid, 100);
SetPlayerArmour(playerid, 100);
IsAFK[playerid] = false;
TogglePlayerClock(playerid, 1);
    for(new i = 0; i < 7; i++)
    {
        SendClientMessage(playerid, -1, "");
    }
    SetTimerEx("SendWelcomeMessage", 5000, false, "i", playerid);
    SendClientMessage(playerid,Orange,"Welcome to Magic DeathMatch/Freeroam Server! ");
    SendClientMessage(playerid,Orange,"• To receive information about the mod type: /Help");
	SendClientMessage(playerid,Orange,"Visit our website: SA-MP.com");
	SendClientMessage(playerid,Red,"You must read the server rules before starting the game");
	SendClientMessage(playerid,Green,"We hope you will enjoy!");
    new string[64], pName[MAX_PLAYER_NAME];
    GetPlayerName(playerid,pName,MAX_PLAYER_NAME);
    format(string,sizeof string,"Player (%s) has Joined the server !",pName);
    SendClientMessageToAll(Green ,string);
    return 1;


}
public OnPlayerDisconnect(playerid, reason)
{
    new name[MAX_PLAYER_NAME], file[256]; 
    GetPlayerName(playerid, name, sizeof(name)); 
    format(file, sizeof(file), PATH, name); 
    if(gPlayerLogged[playerid] == 1)
    { 
        dini_IntSet(file, "Score", PlayerInfo[playerid][pScore]); 
        dini_IntSet(file, "Money", PlayerInfo[playerid][pCash]); 
        dini_IntSet(file, "Admin",PlayerInfo[playerid][pAdmin]);
        dini_IntSet(file, "pVip",PlayerInfo[playerid][pVip]);
        dini_IntSet(file, "Kills",PlayerInfo[playerid][pKills]); 
        dini_IntSet(file, "Deaths",PlayerInfo[playerid][pDeaths]); 
    } 
    gPlayerLogged[playerid] = 0;
    new string[64], pName[MAX_PLAYER_NAME];
    GetPlayerName(playerid,pName,MAX_PLAYER_NAME);
    format(string,sizeof string,"Player (%s) has left the server!",pName);
    SendClientMessageToAll(Red ,string);
    return 1;
    


}

public OnPlayerSpawn(playerid)
{
    SetPlayerHealth(playerid, 100);
    SetPlayerArmour(playerid, 100);
 GivePlayerMoney(playerid, 10000);
 TextDrawShowForPlayer(playerid, randommsg);
return 1;
}



public OnPlayerDeath(playerid, killerid, reason)
{
GivePlayerMoney(playerid, -1000);
new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    if (GetDistanceBetweenPoints3D(x, y, z, SafeZoneX, SafeZoneY, SafeZoneZ) <= SafeZoneRadius)
    {
        return 0;
    }
    return 1;
}
public OnVehicleSpawn(vehicleid)
{
    return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
    return 1;
}

public OnVehicleDestroy(vehicleid)
{
    return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
//========================<<[Commands]>>==========================//

if (strcmp("/help", cmdtext, true, 5) == 0)
    {
        ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "Help Menu", "1. Teleports\n2. Commands\n3. Rules\n4. Server Info\n5. Credits", "Select", "Cancel");
        return 1;
    }

if(!strcmp(cmdtext,"/DM",true))
	{
	    new szDialog[1000];
		szDialog[0] = '\0';
		strcat(szDialog,"{FFFFFF}1.{FF0000} /ddm - Join deagle deathmatch\n");
		strcat(szDialog,"{FFFFFF}2.{FF0000} /sdm - Join sniper deathmatch (Headshot system included)\n");
		strcat(szDialog,"{FFFFFF}3.{FF0000} /sos - Join sawn-off shotgun\n");
		strcat(szDialog,"{FFFFFF}4.{FF0000} /hitsound - Toggle hitsound on/off\n");
		return ShowPlayerDialog(playerid,DIALOG_INF,DIALOG_STYLE_MSGBOX,"DeathMatch Zones",szDialog,"Close","");
	}

	for(new w,j=sizeof(Teleport); w<j; w++)
	{
	    if(!strcmp(cmdtext,Teleport[w][TeleportName],true))
	    {
	        if(IsPlayerInAnyVehicle(playerid) && !Teleport[w][InCar]) return SendClientMessage(playerid,Red,"You can't teleport to this location while in a vehicle.");
	        if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	        {
	            new Vehicleid = GetPlayerVehicleID(playerid);
	            SetVehiclePos(Vehicleid,Teleport[w][TeleVX],Teleport[w][TeleVY],Teleport[w][TeleVZ]);
	            SetVehicleZAngle(Vehicleid,Teleport[w][TeleVA]);
	            SetPlayerVirtualWorld(playerid, Teleport[w][VirtualWorld]);
	            LinkVehicleToInterior(Vehicleid,Teleport[w][Interior]);
	        } else {
	            SetPlayerPos(playerid,Teleport[w][TeleX],Teleport[w][TeleY],Teleport[w][TeleZ]);
	            SetPlayerFacingAngle(playerid,Teleport[w][TeleA]);
	            SetPlayerInterior(playerid,Teleport[w][Interior]);
	            SetPlayerVirtualWorld(playerid,Teleport[w][VirtualWorld]);
				//SetTimerEx("UnFreezeTeleportedPlayer",2000,0,"i",playerid);
				//TogglePlayerControllable(playerid, 0);
	        }
   			if(Teleport[w][ObjectLoad] == true) Streamer_UpdateEx(playerid,Teleport[w][TeleX],Teleport[w][TeleY],Teleport[w][TeleZ],Teleport[w][VirtualWorld]);
	        SetPlayerInterior(playerid,Teleport[w][Interior]);
	        return SendClientMessage(playerid,Yellow,Teleport[w][Message]);
	    }
	}

    if(!strcmp(cmdtext,"/Tele",true))
	{
		new String[500],pDialog[4096];
		for(new t,j = sizeof(Teleport); t < j; t++)
		{
			format(String,500,"{009DFF}%i. {84FF00}%s{009DFF} - %s \n",t+1,Teleport[t][TeleportName],Teleport[t][Message]);
			strcat(pDialog,String,sizeof(pDialog));
		}
		ShowPlayerDialog(playerid,999,DIALOG_STYLE_MSGBOX,"Teleport List",pDialog,"{3CBD19}Close","");
	    return 1;
    }
    
    if(!strcmp("/HelpMe", cmdtext, true, 7))
    {
        
        if(strlen(cmdtext[8]) > 0)
        {
            
            new message[128];
            strmid(message, cmdtext, 8, sizeof(message), 255);

            
            for(new i = 0; i < MAX_PLAYERS; i++)
            {
                if(IsPlayerConnected(i) && IsPlayerAdmin(i))
                {
                   
                    new playerName[MAX_PLAYER_NAME];
                    GetPlayerName(playerid, playerName, sizeof(playerName));

                    new adminMessage[256];
                    format(adminMessage, sizeof(adminMessage), "[HELP REQUEST] %s: %s", playerName, message);
                    SendClientMessage(i,Yellow, adminMessage);
                }
            }

            
            SendClientMessage(playerid,Green, "One of our admins will be with you shortly to assist. Thank you for your patience.");
        }
        else
        {
            
            SendClientMessage(playerid,Red, "You can't send an empty message..");
        }
        return 1; 
    }
    
      
    if(!strcmp("/Admins", cmdtext, true, 7))
    {
        new adminList[1024];
        new tempStr[128];
        new adminCount = 0;

        
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i) && IsPlayerAdmin(i))
            {
                
                new playerName[MAX_PLAYER_NAME];
                GetPlayerName(i, playerName, sizeof(playerName));

               
                format(tempStr, sizeof(tempStr), "%s\n", playerName);
                strcat(adminList, tempStr);
                adminCount++;
            }
        }

        if(adminCount > 0)
        {
            
            new msg[128];
            format(msg, sizeof(msg), "Online admins (%d):", adminCount);
            SendClientMessage(playerid,Yellow, msg);
            SendClientMessage(playerid,Yellow, adminList);
        }
        else
        {
            
            SendClientMessage(playerid,Red, "No Online admins.");
        }

        return 1;
    }
    
    if(!strcmp("/KILL", cmdtext, true, 5))
    {
        SetPlayerHealth(playerid, 0.0);
        
	return 1;
	
}

if (!strcmp(cmdtext, "/afk", true))
{
    if(IsAFK[playerid] == false)
    {
        new string[128];
        new name[MAX_PLAYER_NAME];
        IsAFK[playerid] = true;
        GetPlayerPos(playerid, PosX[playerid], PosY[playerid], PosZ[playerid]);
        GetPlayerFacingAngle(playerid, PosA[playerid]);
        PosI[playerid] = (GetPlayerInterior(playerid));
        GetPlayerName(playerid, name, sizeof(name));
        GetPlayerWeapon(playerid);
        GivePlayerWeapon(playerid, 0 , 0);
        format(string, sizeof(string), "[AFK] {6f00ff}*%s {FFFFFF}is now AFK {00ff00}{FFFFFF}.",name);
        TogglePlayerControllable(playerid,0);
        label[playerid] = Create3DTextLabel("i'm AFK",Yellow,30.0,40.0,50.0,40.0,0);
        Attach3DTextLabelToPlayer(label[playerid], playerid, 0.0, 0.0, 0.7);
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerInterior(playerid, 3);
        SendClientMessageToAll(0xF8F8F8FFF, string);
    }
    else if(IsAFK[playerid] == true)
    {
        new string[128];
        new name[MAX_PLAYER_NAME];
        IsAFK[playerid] = false;
        SetPlayerPos(playerid, PosX[playerid], PosY[playerid], PosZ[playerid]);
        SetPlayerFacingAngle(playerid, PosA[playerid]);
        SetCameraBehindPlayer(playerid);
        SetPlayerInterior(playerid, PosI[playerid]);
        GetPlayerName(playerid, name, sizeof(name));
        format(string, sizeof(string), "* {6f00ff}%s {FFFFFF}is now Back From AFK {00ff00}{FFFFFF}.",name);
        TogglePlayerControllable(playerid, 1);
        Delete3DTextLabel(Text3D:label[playerid]);
        SendClientMessageToAll(0xF8F8F8FFF, string);
    }
    return 1;
 }

	
 if(!strcmp(cmdtext,"/VHelp",true))
	{
	    new szDialog[1000];
		szDialog[0] = '\0';
		strcat(szDialog,"{FFFFFF}1.{FF0000} /nos - adds nitros to vehicle\n");
		strcat(szDialog,"{FFFFFF}2.{FF0000} /vheal - heals yourslef\n");
		strcat(szDialog,"{FFFFFF}3.{FF0000} /vcar - spawns vip car\n");
		strcat(szDialog,"{FFFFFF}4.{FF0000} /vgod - turns on god mode\n");
		strcat(szDialog,"{FFFFFF}5.{FF0000} /vsay - announcemnets as vip\n");
		strcat(szDialog,"{FFFFFF}6.{FF0000} /vcc - changes car color\n");
		strcat(szDialog,"{FFFFFF}7.{FF0000} # for vip chat\n");
		strcat(szDialog,"{FFFFFF}8.{FF0000} /varmour - restores armour\n");
		strcat(szDialog,"{FFFFFF}9.{FF0000} /vbike - spawns V.I.P bik\n");
		strcat(szDialog,"{FFFFFF}10.{FF0000} /vheli - Spawns V.I.P helicopter\n");
		strcat(szDialog,"{FFFFFF}11.{FF0000} /vweaps- vip special weapons\n");
		strcat(szDialog,"{FFFFFF}11.{FF0000} /getvip - sets yourself as vip\n");
		strcat(szDialog,"{FFFFFF}11.{FF0000} /vips - list of online vips.\n");
		return ShowPlayerDialog(playerid,DIALOG_INF,DIALOG_STYLE_MSGBOX,"V.I.P System",szDialog,"סגירה","");
	}
	
if(!strcmp(cmdtext,"/N",true))
        {
            
            new vehicleid = GetPlayerVehicleID(playerid);

            
            if(vehicleid != INVALID_VEHICLE_ID)
            {
                
                AddVehicleComponent(vehicleid, 1008);
                SendClientMessage(playerid,Green, "Nitro added to your vehicle.");
            }
            else
            {
                SendClientMessage(playerid,Red, "You are not in a vehicle.");
            }
            return 1;
        }
        
        if (strcmp("/fix", cmdtext, true, 4) == 0)
    {
        if (!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,Red, "You are not in a vehicle.");
        {
            
            RepairVehicle(GetPlayerVehicleID(playerid));
            SendClientMessage(playerid, Green, "Your vehicle has been repaired.");

        }
        return 1;
    }

//========================<<[Teleports - OLD]>>==========================//

         if (!strcmp(cmdtext, "/ls", true))
    {
        SetPlayerPos(playerid, 1474.7648,-1715.2794,14.0469);
        SetPlayerFacingAngle(playerid, 187.1461);
        if (IsPlayerInAnyVehicle(playerid))
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehiclePos(vehicleid, 1474.7648,-1715.2794,14.0469);
            PutPlayerInVehicle(playerid, vehicleid, 0);
        }
        SendClientMessage(playerid,LightYellow, "LOS SANTOS--!");
        return 1;
    }
    
if (!strcmp(cmdtext, "/sf", true))
    {
        SetPlayerPos(playerid, -2578.6194, 1100.4614, 55.5781);
        SetPlayerFacingAngle(playerid, 334.1319);
    if (IsPlayerInAnyVehicle(playerid))
        {

            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehiclePos(vehicleid, -2578.6194, 1100.4614, 55.5781);
            PutPlayerInVehicle(playerid, vehicleid, 0);
        }
        SendClientMessage(playerid,Golden, "SF!");
        return 1;
    }
    
    if (!strcmp(cmdtext, "/race", true))
    {

        SetPlayerPos(playerid, 2057.9421,842.8384,6.7031);
        SetPlayerFacingAngle(playerid, 10.0367);
        if (IsPlayerInAnyVehicle(playerid))
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehiclePos(vehicleid, 2057.9421,842.8384,6.7031);
            PutPlayerInVehicle(playerid, vehicleid, 0);
        }
        SendClientMessage(playerid,LightYellow, "RACE!");

        return 1;
    }


    if (!strcmp(cmdtext, "/lv", true))
    {

        SetPlayerPos(playerid, 2028.5544, 1340.9491, 10.8203);
        SetPlayerFacingAngle(playerid, 271.2052);
        if (IsPlayerInAnyVehicle(playerid))
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehiclePos(vehicleid, 2028.5544, 1340.9491, 10.8203);
            PutPlayerInVehicle(playerid, vehicleid, 0);
        }
        SendClientMessage(playerid,LightYellow, "Welcome To Las Venturas!");

        return 1;
    }


    //if (!strcmp(cmdtext, "/ship", true))
   // {
//
      //  SetPlayerPos(playerid, 2027.4493, 1544.0546, 10.8203);
     //   SetPlayerFacingAngle(playerid, 89.7820);
      //  SendClientMessage(playerid,LightYellow, "Welcome to the Ship!");

       // return 1;
   //}
//

    if (!strcmp(cmdtext, "/ap", true))
    {

        SetPlayerPos(playerid, 1706.5563, 1608.4502, 10.0156);
        SetPlayerFacingAngle(playerid, 75.2991);
        if (IsPlayerInAnyVehicle(playerid))
        {
            
            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehiclePos(vehicleid, 1706.5563, 1608.4502, 10.0156);
            PutPlayerInVehicle(playerid, vehicleid, 0);
        }
        SendClientMessage(playerid,LightYellow,"AP!");

        return 1;
    }
    if (!strcmp(cmdtext, "/ramp", true))
    {
        SetPlayerPos(playerid, 1934.4132, -1400.6815, 13.5703);
        SetPlayerFacingAngle(playerid, 112.1857);
            if (IsPlayerInAnyVehicle(playerid))
        {

            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehiclePos(vehicleid, 1934.4132, -1400.6815, 13.5703);
            PutPlayerInVehicle(playerid, vehicleid, 0);
        }
        SendClientMessage(playerid,LightYellow, "ramp!");
        return 1;
    }

    if (!strcmp(cmdtext, "/army", true))
    {
        SetPlayerPos(playerid, 214.2294, 1908.4487, 17.6406);
        SetPlayerFacingAngle(playerid, 178.9401);
        SendClientMessage(playerid,Golden, "armyarmy!");
        return 1;
    }

       // if (!strcmp(cmdtext, "/carshop", true))
  //  {
  //      SetPlayerPos(playerid, -1897.4003, 253.8361, 41.0469);
       // SetPlayerFacingAngle(playerid, 0.0629);
      //  SendClientMessage(playerid,Golden, "carshop!");
      //  return 1;
   // }

    if (!strcmp(cmdtext, "/tower", true))
    {
        SetPlayerPos(playerid, 1544.3032, -1353.2784, 329.4744);
        SetPlayerFacingAngle(playerid, 271.0214);
            if (IsPlayerInAnyVehicle(playerid))
        {

            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehiclePos(vehicleid, 1544.3032, -1353.2784, 329.4744);
            PutPlayerInVehicle(playerid, vehicleid, 0);
        }
        SendClientMessage(playerid,Golden, "tower!");
        return 1;
    }

 if (!strcmp(cmdtext, "/swamp", true))
    {
        SetPlayerPos(playerid, -863.7606, -1983.8845, 18.1053);
        SetPlayerFacingAngle(playerid, 339.5688);
            if (IsPlayerInAnyVehicle(playerid))
        {

            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehiclePos(vehicleid, -863.7606, -1983.8845, 18.1053);
            PutPlayerInVehicle(playerid, vehicleid, 0);
        }
        SendClientMessage(playerid,Golden, "swamp!");
        return 1;
    }


      if (!strcmp(cmdtext, "/drift", true))
    {
        SetPlayerPos(playerid, 2330.9800, 1409.1500, 42.8203);
        SetPlayerFacingAngle(playerid, 319.5685);
            if (IsPlayerInAnyVehicle(playerid))
        {

            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehiclePos(vehicleid, 2330.9800, 1409.1500, 42.8203);
            PutPlayerInVehicle(playerid, vehicleid, 0);
        }
        SendClientMessage(playerid,Red, "drift!");
        return 1;
    }

      if (!strcmp(cmdtext, "/jeeps", true))
    {
        SetPlayerPos(playerid, -296.3609, 1772.1890, 42.6875);
        SetPlayerFacingAngle(playerid, 180.2061);
            if (IsPlayerInAnyVehicle(playerid))
        {

            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehiclePos(vehicleid, -296.3609, 1772.1890, 42.6875);
            PutPlayerInVehicle(playerid, vehicleid, 0);
        }
        SendClientMessage(playerid,Red, "jeeps!");
        return 1;
    }

     if (!strcmp(cmdtext, "/chiliad", true))
    {
        SetPlayerPos(playerid, -2342.9651, -1599.4357, 483.6536);
        SetPlayerFacingAngle(playerid, 231.6886);
            if (IsPlayerInAnyVehicle(playerid))
        {

            new vehicleid = GetPlayerVehicleID(playerid);
            SetVehiclePos(vehicleid, -2342.9651, -1599.4357, 483.6536);
            PutPlayerInVehicle(playerid, vehicleid, 0);
        }
        SendClientMessage(playerid,Red, "chiliad!");
        return 1;
    }
    
     if (!strcmp(cmdtext, "/casino", true))
    {
        SetPlayerPos(playerid, 2032.3456, 1007.0475, 10.8203);
        SetPlayerFacingAngle(playerid, 85.1540);
        SendClientMessage(playerid,Golden, "Welcome To The Casino!");
        return 1;
    }
    
         if (!strcmp(cmdtext, "/casino2", true))
    {
        SetPlayerPos(playerid, 2182.5940, 1677.7584, 11.0723);
        SetPlayerFacingAngle(playerid, 268.0514);
        SendClientMessage(playerid,Golden, "Welcome To The Casino2!");
        return 1;
    }
    

//========================<<[Teleports - OLD]>>==========================//


	return SendClientMessage(playerid,0xff0008AA,"ERROR: {FFFEF0}This command does not exist. For help, type /Help.");
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
  if (dialogid == 44)
    {
        new name[MAX_PLAYER_NAME], file[256], string[128];
        GetPlayerName(playerid, name, sizeof(name));
        format(file, sizeof(file), PATH, name);
        if(!response) Kick(playerid);
        if (!strlen(inputtext)) return
        ShowPlayerDialog(playerid, 1, DIALOG_STYLE_PASSWORD, "-->{FF0000}Registration {0066CC}Magic-System", "{FF0000}Welcome! You are not registered. To register, enter a password:{FFFF00}", "Register", "Exit");
        dini_Create(file);
        dini_IntSet(file, "Password", udb_hash(inputtext));
        dini_IntSet(file, "AdminLevel",PlayerInfo[playerid][pAdmin] = 0);
        dini_IntSet(file, "Money",PlayerInfo[playerid][pCash] = 500);
        dini_IntSet(file, "Score",PlayerInfo[playerid][pScore] = 0);
        dini_IntSet(file, "Kills",PlayerInfo[playerid][pKills] = 0);
        dini_IntSet(file, "Deaths",PlayerInfo[playerid][pDeaths] = 0);
        format(string, 128, "{FFFF00} player %s has registered to the server!!", name, inputtext);
        SendClientMessage(playerid, -1, string);
        ShowPlayerDialog(playerid, 3, DIALOG_STYLE_MSGBOX, "{FF0000}IMPORTANT!","{0066CC}welcome ! :)","Exit", "");
		gPlayerLogged[playerid] = 1;
    }
    if (dialogid == 42)
    {
        new name[MAX_PLAYER_NAME], file[256], string[128];
        GetPlayerName(playerid, name, sizeof(name));
        format(file, sizeof(file), PATH, name);
        if(!response) Kick(playerid);
        new tmp;
        tmp = dini_Int(file, "Password");
        if(udb_hash(inputtext) != tmp) {
            SendClientMessage(playerid, -1, "{FF0000}Wrong Password! {0066CC}Try again !");
            ShowPlayerDialog(playerid, 2, DIALOG_STYLE_INPUT, "-->{FF0000}Login {0066CC}Magic-System", "{FF0000}{0066CC}Welcome !\n{FFFF00}Enter your password to log in :{FF0000}", "התחבר", "ביטול");
        }
        else
        {
            gPlayerLogged[playerid] = 1;
            PlayerInfo[playerid][pAdmin] = dini_Int(file, "AdminLevel");
            SetPlayerScore(playerid, PlayerInfo[playerid][pScore]);
            GivePlayerMoney(playerid, dini_Int(file, "Money")-GetPlayerMoney(playerid));
            SendClientMessage(playerid, -1, "{FF0000}[--> Magic-System <--]: {03AB00}You have successfully logged in.");
        }
        
        return 1;
        }
        
        

if (dialogid == DIALOG_HELP)
    {
        if (response)
        {
            switch (listitem)
            {
                case 0:
                {
                    ShowPlayerDialog(playerid, DIALOG_TELEPORTS, DIALOG_STYLE_LIST, "Teleports", "1. Race\n2. LS\n3. LV\n4. SF\n5. AP\n6. ARMY\n7. TOWER\n8. SWAMP\n9. DRIFT\n10. JEEPS\n11. CHILIAD\n12. CASINO\n13. CASINO2", "Select", "Cancel");
                    return 1;
                }
                case 1:
                {
                    ShowPlayerDialog(playerid, DIALOG_COMMANDS, DIALOG_STYLE_MSGBOX, "Commands", CommandList, "Close", "");
                    return 1;
                }
                case 2:
                {
                    ShowPlayerDialog(playerid, DIALOG_RULES, DIALOG_STYLE_MSGBOX, "Server Rules", RulesList, "Close", "");
                    return 1;
                }
                case 3:
                {
                   
                    new
                        ServerName[64],
                        PlayersOnline[32],
                        ServerPing[32],
                        GamemodeName[64],
                        ServerInfo[256];

                    GetServerVarAsString("hostname", ServerName, sizeof(ServerName));
                    format(PlayersOnline, sizeof(PlayersOnline), "%d / %d", GetPlayerPoolSize(), GetMaxPlayers());
                    format(ServerPing, sizeof(ServerPing), "%d ms", GetPlayerPing(playerid));
                    GetServerVarAsString("gamemodetext", GamemodeName, sizeof(GamemodeName));

                    format(ServerInfo, sizeof(ServerInfo), "Server Name: %s\nPlayers Online: %s\nServer Ping: %s\nGamemode: %s\nLast Update: %s", ServerName, PlayersOnline, ServerPing, GamemodeName, LastUpdate);

                    ShowPlayerDialog(playerid, DIALOG_SERVERINFO, DIALOG_STYLE_MSGBOX, "Server Info", ServerInfo, "Close", "");
                   
                    return 1;
                }
                case 4:
                {
                    ShowPlayerDialog(playerid, DIALOG_CREDITS, DIALOG_STYLE_MSGBOX, "Credits", "Developed by: Lezduit/Demboez\nWith assistance from: ChatGPT", "Close", "");
                    return 1;
                }
            }

            return 1;
        }
    }
    else if (dialogid == DIALOG_TELEPORTS)
    {
        if (response)
        {
            if (listitem >= 0 && listitem < sizeof(TeleportLocations))
            {
                SetPlayerPos(playerid, TeleportLocations[listitem][0], TeleportLocations[listitem][1], TeleportLocations[listitem][2]);
            }
           
        }
        return 1;
    }
    
    return 1;
}
public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if(checkpointid == Ammo)
    {
		new pDialog[4096];
	  	strcat(pDialog,"Shotgun\t{33AA33}$5000\t100\n",sizeof(pDialog));
	  	strcat(pDialog,"Deagle\t{33AA33}$5000\t100\n",sizeof(pDialog));
	  	strcat(pDialog,"M4\t{33AA33}$1000\t50\n",sizeof(pDialog));
	  	strcat(pDialog,"MP5\t{33AA33}$2000\t100\n",sizeof(pDialog));
	  	strcat(pDialog,"UZI\t{33AA33}$2000\t100\n",sizeof(pDialog));
	  	strcat(pDialog,"AK-47\t{33AA33}$2000\t100\n",sizeof(pDialog));
        return ShowPlayerDialog(playerid, 1, DIALOG_STYLE_TABLIST, "Select a Weapon", pDialog,"Buy", "Cancel");
    }

    if (checkpointid == ship)
    {
         GivePlayerMoney(playerid, 75);
    }
    return 1;
}


public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);


    if (GetDistanceBetweenPoints3D(x, y, z, SafeZoneX, SafeZoneY, SafeZoneZ) <= SafeZoneRadius)
    {
        \
        return 0;
    }
    
     if(issuerid != INVALID_PLAYER_ID && weaponid == 34 && bodypart == 9)
    {
        \
        SetPlayerHealth(playerid, 0.0);
    }
    
    return 1;
}


stock CreateVehicleTextLabel(vehicleid, const text[])
{
    \
    new label[128];
    format(label, sizeof(label), "%s %s", text, GetVehicleName(vehicleid));
    new Float:x, Float:y, Float:z;
    GetVehiclePos(vehicleid, x, y, z);
    new Float:rx, Float:ry, Float:rz;
    GetVehicleZAngle(vehicleid, rz);
    return Create3DTextLabel(label, COLOR_WHITE, x, y, z + 3.0, 40.0, 0, rz);
}
