// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>
#include <foreach>

//togglespeedo
new Speedometer;

//speedo1
new Text:Textdraw0;
new Text:Textdraw1;
new Text:Textdraw2;
new PlayerText:Textdraw3[MAX_PLAYERS];
new Text:Textdraw4;
new Text:Textdraw5;
new PlayerText:Textdraw6[MAX_PLAYERS];
new PlayerText:Textdraw7[MAX_PLAYERS];
new PlayerText:Textdraw8[MAX_PLAYERS];
new PlayerText:Textdraw9[MAX_PLAYERS];
new PlayerText:Textdraw10[MAX_PLAYERS];
new PlayerText:Textdraw11[MAX_PLAYERS];
new PlayerText:Textdraw12[MAX_PLAYERS];

//speedo2

new Text:speedom0;
new Text:speedom1;
new Text:speedom2;
new PlayerText:speedom3[MAX_PLAYERS];
new PlayerText:speedom4[MAX_PLAYERS];
new PlayerText:speedom5[MAX_PLAYERS];
new PlayerText:speedom6[MAX_PLAYERS];
new PlayerText:speedom7[MAX_PLAYERS];
new PlayerText:speedom8[MAX_PLAYERS];
new PlayerText:speedom9[MAX_PLAYERS];
new PlayerText:speedom10[MAX_PLAYERS];
new PlayerText:speedom11[MAX_PLAYERS];
new PlayerText:speedom12[MAX_PLAYERS];
new PlayerText:speedom13[MAX_PLAYERS];
new PlayerText:speedom14[MAX_PLAYERS];
new PlayerText:speedom15[MAX_PLAYERS];
new PlayerText:speedom16[MAX_PLAYERS];
new Text:speedom17;
new Text:speedom18;
new Text:speedom19;
new PlayerText:speedom20[MAX_PLAYERS];
new PlayerText:speedom21[MAX_PLAYERS];
new PlayerText:speedom22[MAX_PLAYERS];
new Text:speedom23;

//speed02
new Text:speedm0;
new Text:speedm1;
new PlayerText:speedm2[MAX_PLAYERS];
new Text:speedm3;
new PlayerText:speedm4[MAX_PLAYERS];
new PlayerText:speedm5[MAX_PLAYERS];
new Text:speedm6;
new PlayerText:speedm7[MAX_PLAYERS];
new PlayerText:speedm8[MAX_PLAYERS];
new PlayerText:speedm9[MAX_PLAYERS];
new PlayerText:speedm10[MAX_PLAYERS];

new VehicleName2[][] =
{
   "Landstalker",
   "Bravura",
   "Buffalo",
   "Linerunner",
   "Pereniel",
   "Sentinel",
   "Dumper",
   "Firetruck",
   "Trashmaster",
   "Stretch",
   "Manana",
   "Infernus",
   "Voodoo",
   "Pony",
   "Mule",
   "Cheetah",
   "Ambulance",
   "Leviathan",
   "Moonbeam",
   "Esperanto",
   "Taxi",
   "Washington",
   "Bobcat",
   "Mr Whoopee",
   "BF Injection",
   "Hunter",
   "Premier",
   "Enforcer",
   "Securicar",
   "Banshee",
   "Predator",
   "Bus",
   "Rhino",
   "Barracks",
   "Hotknife",
   "Trailer",
   "Previon",
   "Coach",
   "Cabbie",
   "Stallion",
   "Rumpo",
   "RC Bandit",
   "Romero",
   "Packer",
   "Monster",
   "Admiral",
   "Squalo",
   "Seasparrow",
   "Pizzaboy",
   "Tram",
   "Trailer",
   "Turismo",
   "Speeder",
   "Reefer",
   "Tropic",
   "Flatbed",
   "Yankee",
   "Caddy",
   "Solair",
   "RC Van",
   "Skimmer",
   "PCJ-600",
   "Faggio",
   "Freeway",
   "RC Baron",
   "RC Raider",
   "Glendale",
   "Oceanic",
   "Sanchez",
   "Sparrow",
   "Patriot",
   "Quad",
   "Coastguard",
   "Dinghy",
   "Hermes",
   "Sabre",
   "Rustler",
   "ZR-350",
   "Walton",
   "Regina",
   "Comet",
   "BMX",
   "Burrito",
   "Camper",
   "Marquis",
   "Baggage",
   "Dozer",
   "Maverick",
   "News Chopper",
   "Rancher",
   "FBI Rancher",
   "Virgo",
   "Greenwood",
   "Jetmax",
   "Hotring",
   "Sandking",
   "Blista Compact",
   "PD Maverick",
   "ProtoType",
   "Benson",
   "Mesa",
   "RC Goblin",
   "Hotring",
   "Hotring",
   "Bloodring",
   "Rancher",
   "Super GT",
   "Elegant",
   "Journey",
   "Bike",
   "Mountain Bike",
   "Beagle",
   "Cropdust",
   "Stunt",
   "Tanker",
   "RoadTrain",
   "Nebula",
   "Majestic",
   "Buccaneer",
   "Shamal",
   "Hydra",
   "FCR-900",
   "NRG-500",
   "HPV1000",
   "Cement",
   "Tow Truck",
   "Fortune",
   "Cadrona",
   "FBI Truck",
   "Willard",
   "Forklift",
   "Tractor",
   "Combine",
   "Feltzer",
   "Remington",
   "Slamvan",
   "Blade",
   "Freight",
   "Streak",
   "Vortex",
   "Vincent",
   "Bullet",
   "Clover",
   "Sadler",
   "Firetruck",
   "Hustler",
   "Intruder",
   "Primo",
   "Cargobob",
   "Tampa",
   "Sunrise",
   "Merit",
   "Utility",
   "Nevada",
   "Yosemite",
   "Windsor",
   "Monster",
   "Monster",
   "Uranus",
   "Jester",
   "Sultan",
   "Stratum",
   "Elegy",
   "Raindance",
   "RC Tiger",
   "Flash",
   "Tahoma",
   "Savanna",
   "Bandito",
   "Freight",
   "Trailer",
   "Kart",
   "Mower",
   "Duneride",
   "Sweeper",
   "Broadway",
   "Tornado",
   "AT-400",
   "DFT-30",
   "Huntley",
   "Stafford",
   "BF-400",
   "Newsvan",
   "Tug",
   "Trailer",
   "Emperor",
   "Wayfarer",
   "Euros",
   "Hotdog",
   "Club",
   "Trailer",
   "Trailer",
   "Andromada",
   "Dodo",
   "RC Cam",
   "Launch",
   "Police Car",
   "Police Car",
   "Police Car",
   "Police Ranger",
   "Picador",
   "S.W.A.T",
   "Alpha",
   "Phoenix",
   "Glendale",
   "Sadler",
   "Luggage Trailer",
   "Luggage Trailer",
   "Stair Trailer",
   "Boxville",
   "Farm Plow",
   "Utility Trailer"
};

//#if defined FILTERSCRIPT
new speed0[MAX_PLAYERS];

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Advance Speed-O-Meter by MNA - Loaded");
	print("--------------------------------------\n");
	//dont remove credits
	Speedometer = 1;
	
	
	//speedo1
    speedom0 = TextDrawCreate(570.125000, 422.666778, "usebox");
    TextDrawLetterSize(speedom0, 0.000000, 1.562958);
    TextDrawTextSize(speedom0, 124.250000, 0.000000);
    TextDrawAlignment(speedom0, 1);
    TextDrawColor(speedom0, 0);
    TextDrawUseBox(speedom0, true);
    TextDrawBoxColor(speedom0, 68);
    TextDrawSetShadow(speedom0, 0);
    TextDrawSetOutline(speedom0, 0);
    TextDrawFont(speedom0, 0);

    speedom1 = TextDrawCreate(90.000000, 412.999938, "-");
    TextDrawLetterSize(speedom1, 36.082534, 1.133329);
    TextDrawAlignment(speedom1, 1);
    TextDrawColor(speedom1, -2139062017);
    TextDrawSetShadow(speedom1, 0);
    TextDrawSetOutline(speedom1, 1);
    TextDrawBackgroundColor(speedom1, 51);
    TextDrawFont(speedom1, 1);
    TextDrawSetProportional(speedom1, 1);

    speedom2 = TextDrawCreate(88.500000, 431.500213, "-");
    TextDrawLetterSize(speedom2, 36.082534, 1.133329);
    TextDrawAlignment(speedom2, 1);
    TextDrawColor(speedom2, -2139062017);
    TextDrawSetShadow(speedom2, 0);
    TextDrawSetOutline(speedom2, 1);
    TextDrawBackgroundColor(speedom2, 51);
    TextDrawFont(speedom2, 1);
    TextDrawSetProportional(speedom2, 1);

    speedom17 = TextDrawCreate(259.375000, 401.916687, "~>~");
    TextDrawLetterSize(speedom17, 0.449999, 1.600000);
    TextDrawAlignment(speedom17, 1);
    TextDrawColor(speedom17, -1);
    TextDrawSetShadow(speedom17, 0);
    TextDrawSetOutline(speedom17, 1);
    TextDrawBackgroundColor(speedom17, 51);
    TextDrawFont(speedom17, 1);
    TextDrawSetProportional(speedom17, 1);

    speedom18 = TextDrawCreate(383.750000, 403.083526, "~<~");
    TextDrawLetterSize(speedom18, 0.449999, 1.600000);
    TextDrawAlignment(speedom18, 1);
    TextDrawColor(speedom18, -1);
    TextDrawSetShadow(speedom18, 0);
    TextDrawSetOutline(speedom18, 1);
    TextDrawBackgroundColor(speedom18, 51);
    TextDrawFont(speedom18, 1);
    TextDrawSetProportional(speedom18, 1);

    speedom19 = TextDrawCreate(528.125000, 437.500000, "Km/H");
    TextDrawLetterSize(speedom19, 0.342498, 1.144999);
    TextDrawAlignment(speedom19, 1);
    TextDrawColor(speedom19, 16711935);
    TextDrawSetShadow(speedom19, 0);
    TextDrawSetOutline(speedom19, 1);
    TextDrawBackgroundColor(speedom19, 51);
    TextDrawFont(speedom19, 2);
    TextDrawSetProportional(speedom19, 1);
    
    speedom23 = TextDrawCreate(117.500000, 442.750091, "-");
    TextDrawLetterSize(speedom23, 7.244997, 0.567498);
    TextDrawAlignment(speedom23, 1);
    TextDrawColor(speedom23, -2139062017);
    TextDrawSetShadow(speedom23, 0);
    TextDrawSetOutline(speedom23, 1);
    TextDrawBackgroundColor(speedom23, 51);
    TextDrawFont(speedom23, 1);
    TextDrawSetProportional(speedom23, 1);

	//speedomter1
	Textdraw0 = TextDrawCreate(379.500000, 391.166717, "usebox");
	TextDrawLetterSize(Textdraw0, 0.000000, 6.009722);
	TextDrawTextSize(Textdraw0, 259.250000, 0.000000);
	TextDrawAlignment(Textdraw0, 1);
	TextDrawColor(Textdraw0, 0);
	TextDrawUseBox(Textdraw0, true);
	TextDrawBoxColor(Textdraw0, 102);
	TextDrawSetShadow(Textdraw0, 0);
	TextDrawSetOutline(Textdraw0, 0);
	TextDrawFont(Textdraw0, 0);

	Textdraw1 = TextDrawCreate(254.375000, 384.416778, "-");
	TextDrawLetterSize(Textdraw1, 9.266877, 0.952499);
	TextDrawAlignment(Textdraw1, 1);
	TextDrawColor(Textdraw1, -2139062017);
	TextDrawSetShadow(Textdraw1, 0);
	TextDrawSetOutline(Textdraw1, 1);
	TextDrawBackgroundColor(Textdraw1, 51);
	TextDrawFont(Textdraw1, 1);
	TextDrawSetProportional(Textdraw1, 1);

	Textdraw2 = TextDrawCreate(251.625000, 440.250183, "-");
	TextDrawLetterSize(Textdraw2, 9.266877, 0.952499);
	TextDrawAlignment(Textdraw2, 1);
	TextDrawColor(Textdraw2, -2139062017);
	TextDrawSetShadow(Textdraw2, 0);
	TextDrawSetOutline(Textdraw2, 1);
	TextDrawBackgroundColor(Textdraw2, 51);
	TextDrawFont(Textdraw2, 1);
	TextDrawSetProportional(Textdraw2, 1);

	Textdraw4 = TextDrawCreate(375.750000, 410.416687, "usebox");
	TextDrawLetterSize(Textdraw4, 0.000000, 1.949534);
	TextDrawTextSize(Textdraw4, 336.750000, 0.000000);
	TextDrawAlignment(Textdraw4, 1);
	TextDrawColor(Textdraw4, 0);
	TextDrawUseBox(Textdraw4, true);
	TextDrawBoxColor(Textdraw4, 255);
	TextDrawSetShadow(Textdraw4, 0);
	TextDrawSetOutline(Textdraw4, 0);
	TextDrawFont(Textdraw4, 0);

	Textdraw5 = TextDrawCreate(336.250000, 426.416748, "-");
	TextDrawLetterSize(Textdraw5, 2.901256, 0.398333);
	TextDrawAlignment(Textdraw5, 1);
	TextDrawColor(Textdraw5, -2139062017);
	TextDrawSetShadow(Textdraw5, 0);
	TextDrawSetOutline(Textdraw5, 1);
	TextDrawBackgroundColor(Textdraw5, 51);
	TextDrawFont(Textdraw5, 1);
	TextDrawSetProportional(Textdraw5, 1);
	
	//speed0meter3
 	speedm0 = TextDrawCreate(409.500000, 410.999969, "usebox");
	TextDrawLetterSize(speedm0, 0.000000, 3.053708);
	TextDrawTextSize(speedm0, 285.500000, 0.000000);
	TextDrawAlignment(speedm0, 1);
	TextDrawColor(speedm0, 0);
	TextDrawUseBox(speedm0, true);
	TextDrawBoxColor(speedm0, 170);
	TextDrawSetShadow(speedm0, 0);
	TextDrawSetOutline(speedm0, 0);
	TextDrawFont(speedm0, 0);

	speedm1 = TextDrawCreate(229.375000, 389.083496, "LD_BEAT:chit");
	TextDrawLetterSize(speedm1, 0.000000, 0.000000);
	TextDrawTextSize(speedm1, 85.625000, 68.833312);
	TextDrawAlignment(speedm1, 1);
	TextDrawColor(speedm1, 170);
	TextDrawSetShadow(speedm1, 0);
	TextDrawSetOutline(speedm1, 0);
	TextDrawFont(speedm1, 4);

	speedm3 = TextDrawCreate(268.750000, 429.333312, "Km/H");
	TextDrawLetterSize(speedm3, 0.240625, 1.016666);
	TextDrawAlignment(speedm3, 1);
	TextDrawColor(speedm3, 16777215);
	TextDrawSetShadow(speedm3, 0);
	TextDrawSetOutline(speedm3, 1);
	TextDrawBackgroundColor(speedm3, 51);
	TextDrawFont(speedm3, 1);
	TextDrawSetProportional(speedm3, 1);

	speedm6 = TextDrawCreate(286.250000, 429.916656, "-");
	TextDrawLetterSize(speedm6, 6.271872, 0.672499);
	TextDrawAlignment(speedm6, 1);
	TextDrawColor(speedm6, -1);
	TextDrawSetShadow(speedm6, 0);
	TextDrawSetOutline(speedm6, 1);
	TextDrawBackgroundColor(speedm6, 51);
	TextDrawFont(speedm6, 1);
	TextDrawSetProportional(speedm6, 1);
	
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

public OnPlayerConnect(playerid)
{
    //speedomter1
    speedom4[playerid] = CreatePlayerTextDraw(playerid, 305.125000, 423.833648, "100");
    PlayerTextDrawLetterSize(playerid, speedom4[playerid], 0.000000, 1.111575);
    PlayerTextDrawTextSize(playerid, speedom4[playerid], 269.875000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom4[playerid], 1);
    PlayerTextDrawColor(playerid, speedom4[playerid], 16777215);
    PlayerTextDrawUseBox(playerid, speedom4[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom4[playerid], 4723199);
    PlayerTextDrawSetShadow(playerid, speedom4[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom4[playerid], 0);
    PlayerTextDrawFont(playerid, speedom4[playerid], 0);

    speedom5[playerid] = CreatePlayerTextDraw(playerid, 341.125000, 423.666931, "120");
    PlayerTextDrawLetterSize(playerid, speedom5[playerid], 0.000000, 1.111575);
    PlayerTextDrawTextSize(playerid, speedom5[playerid], 307.375000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom5[playerid], 1);
    PlayerTextDrawColor(playerid, speedom5[playerid], 16777215);
    PlayerTextDrawUseBox(playerid, speedom5[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom5[playerid], -4128513);
    PlayerTextDrawSetShadow(playerid, speedom5[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom5[playerid], 0);
    PlayerTextDrawFont(playerid, speedom5[playerid], 0);

    speedom6[playerid] = CreatePlayerTextDraw(playerid, 378.375000, 424.083465, "140");
    PlayerTextDrawLetterSize(playerid, speedom6[playerid], 0.000000, 1.111575);
    PlayerTextDrawTextSize(playerid, speedom6[playerid], 343.625000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom6[playerid], 1);
    PlayerTextDrawColor(playerid, speedom6[playerid], 16777215);
    PlayerTextDrawUseBox(playerid, speedom6[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom6[playerid], -6684417);
    PlayerTextDrawSetShadow(playerid, speedom6[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom6[playerid], 0);
    PlayerTextDrawFont(playerid, speedom6[playerid], 0);

    speedom7[playerid] = CreatePlayerTextDraw(playerid, 415.625000, 423.916809, "160");
    PlayerTextDrawLetterSize(playerid, speedom7[playerid], 0.000000, 1.111575);
    PlayerTextDrawTextSize(playerid, speedom7[playerid], 379.875000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom7[playerid], 1);
    PlayerTextDrawColor(playerid, speedom7[playerid], 16777215);
    PlayerTextDrawUseBox(playerid, speedom7[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom7[playerid], -9174785);
    PlayerTextDrawSetShadow(playerid, speedom7[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom7[playerid], 0);
    PlayerTextDrawFont(playerid, speedom7[playerid], 0);

    speedom8[playerid] = CreatePlayerTextDraw(playerid, 451.625000, 423.750061, "180");
    PlayerTextDrawLetterSize(playerid, speedom8[playerid], 0.000000, 1.111575);
    PlayerTextDrawTextSize(playerid, speedom8[playerid], 414.875000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom8[playerid], 1);
    PlayerTextDrawColor(playerid, speedom8[playerid], 16777215);
    PlayerTextDrawUseBox(playerid, speedom8[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom8[playerid], -11730689);
    PlayerTextDrawSetShadow(playerid, speedom8[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom8[playerid], 0);
    PlayerTextDrawFont(playerid, speedom8[playerid], 0);

    speedom9[playerid] = CreatePlayerTextDraw(playerid, 489.500000, 423.583343, "200");
    PlayerTextDrawLetterSize(playerid, speedom9[playerid], 0.000000, 1.111575);
    PlayerTextDrawTextSize(playerid, speedom9[playerid], 451.750000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom9[playerid], 1);
    PlayerTextDrawColor(playerid, speedom9[playerid], 16777215);
    PlayerTextDrawUseBox(playerid, speedom9[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom9[playerid], -16776961);
    PlayerTextDrawSetShadow(playerid, speedom9[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom9[playerid], 0);
    PlayerTextDrawFont(playerid, speedom9[playerid], 0);

    speedom10[playerid] = CreatePlayerTextDraw(playerid, 530.500000, 424.000030, "220");
    PlayerTextDrawLetterSize(playerid, speedom10[playerid], 0.000000, 1.111575);
    PlayerTextDrawTextSize(playerid, speedom10[playerid], 491.750000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom10[playerid], 1);
    PlayerTextDrawColor(playerid, speedom10[playerid], 16777215);
    PlayerTextDrawUseBox(playerid, speedom10[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom10[playerid], -2147483393);
    PlayerTextDrawSetShadow(playerid, speedom10[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom10[playerid], 0);
    PlayerTextDrawFont(playerid, speedom10[playerid], 0);

    speedom11[playerid] = CreatePlayerTextDraw(playerid, 570.250000, 423.833312, "240");
    PlayerTextDrawLetterSize(playerid, speedom11[playerid], 0.000000, 1.111575);
    PlayerTextDrawTextSize(playerid, speedom11[playerid], 532.375000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom11[playerid], 1);
    PlayerTextDrawColor(playerid, speedom11[playerid], 16777215);
    PlayerTextDrawUseBox(playerid, speedom11[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom11[playerid], 1073742079);
    PlayerTextDrawSetShadow(playerid, speedom11[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom11[playerid], 0);
    PlayerTextDrawFont(playerid, speedom11[playerid], 0);

    speedom12[playerid] = CreatePlayerTextDraw(playerid, 144.500000, 424.416748, "0");
    PlayerTextDrawLetterSize(playerid, speedom12[playerid], 0.000000, 1.303701);
    PlayerTextDrawTextSize(playerid, speedom12[playerid], 126.125000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom12[playerid], 1);
    PlayerTextDrawColor(playerid, speedom12[playerid], 0);
    PlayerTextDrawUseBox(playerid, speedom12[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom12[playerid], -1024440833);
    PlayerTextDrawSetShadow(playerid, speedom12[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom12[playerid], 0);
    PlayerTextDrawFont(playerid, speedom12[playerid], 0);

    speedom13[playerid] = CreatePlayerTextDraw(playerid, 178.375000, 424.083251, "20");
    PlayerTextDrawLetterSize(playerid, speedom13[playerid], 0.000000, 1.111575);
    PlayerTextDrawTextSize(playerid, speedom13[playerid], 147.375000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom13[playerid], 1);
    PlayerTextDrawColor(playerid, speedom13[playerid], 0);
    PlayerTextDrawUseBox(playerid, speedom13[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom13[playerid], -1578088961);
    PlayerTextDrawSetShadow(playerid, speedom13[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom13[playerid], 0);
    PlayerTextDrawFont(playerid, speedom13[playerid], 0);

    speedom14[playerid] = CreatePlayerTextDraw(playerid, 209.250000, 424.249969, "40");
    PlayerTextDrawLetterSize(playerid, speedom14[playerid], 0.000000, 1.111575);
    PlayerTextDrawTextSize(playerid, speedom14[playerid], 179.250000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom14[playerid], 1);
    PlayerTextDrawColor(playerid, speedom14[playerid], 0);
    PlayerTextDrawUseBox(playerid, speedom14[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom14[playerid], -1749403905);
    PlayerTextDrawSetShadow(playerid, speedom14[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom14[playerid], 0);
    PlayerTextDrawFont(playerid, speedom14[playerid], 0);

    speedom15[playerid] = CreatePlayerTextDraw(playerid, 240.000000, 423.916564, "60");
    PlayerTextDrawLetterSize(playerid, speedom15[playerid], 0.000000, 1.111575);
    PlayerTextDrawTextSize(playerid, speedom15[playerid], 208.000000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom15[playerid], 1);
    PlayerTextDrawColor(playerid, speedom15[playerid], 0);
    PlayerTextDrawUseBox(playerid, speedom15[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom15[playerid], 1721382399);
    PlayerTextDrawSetShadow(playerid, speedom15[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom15[playerid], 0);
    PlayerTextDrawFont(playerid, speedom15[playerid], 0);

    speedom16[playerid] = CreatePlayerTextDraw(playerid, 271.000000, 423.166595, "80");
    PlayerTextDrawLetterSize(playerid, speedom16[playerid], 0.000000, 1.174075);
    PlayerTextDrawTextSize(playerid, speedom16[playerid], 238.625000, 0.000000);
    PlayerTextDrawAlignment(playerid, speedom16[playerid], 1);
    PlayerTextDrawColor(playerid, speedom16[playerid], 0);
    PlayerTextDrawUseBox(playerid, speedom16[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom16[playerid], 1046225151);
    PlayerTextDrawSetShadow(playerid, speedom16[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom16[playerid], 0);
    PlayerTextDrawFont(playerid, speedom16[playerid], 0);
    
    speedom3[playerid] = CreatePlayerTextDraw(playerid, 131.250000, 421.750091, "0 i 20 i 40 i 60 i 80 i 100 i 120 i 140 i 160 i 180 i 200 i 220 i 240");
    PlayerTextDrawLetterSize(playerid, speedom3[playerid], 0.342500, 1.605834);
    PlayerTextDrawAlignment(playerid, speedom3[playerid], 1);
    PlayerTextDrawColor(playerid, speedom3[playerid], -2139062017);
    PlayerTextDrawSetShadow(playerid, speedom3[playerid], 1);
    PlayerTextDrawSetOutline(playerid, speedom3[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, speedom3[playerid], 255);
    PlayerTextDrawFont(playerid, speedom3[playerid], 2);
    PlayerTextDrawSetProportional(playerid, speedom3[playerid], 1);

	speedom20[playerid] = CreatePlayerTextDraw(playerid, 329.375000, 404.250000, "Land Stalker");
    PlayerTextDrawLetterSize(playerid, speedom20[playerid], 0.327499, 1.290832);
    PlayerTextDrawTextSize(playerid, speedom20[playerid], 26.250000, 131.833328);
    PlayerTextDrawAlignment(playerid, speedom20[playerid], 2);
    PlayerTextDrawColor(playerid, speedom20[playerid], -65281);
    PlayerTextDrawUseBox(playerid, speedom20[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom20[playerid], 119);
    PlayerTextDrawSetShadow(playerid, speedom20[playerid], 1);
    PlayerTextDrawSetOutline(playerid, speedom20[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, speedom20[playerid], -2147483393);
    PlayerTextDrawFont(playerid, speedom20[playerid], 2);
    PlayerTextDrawSetProportional(playerid, speedom20[playerid], 1);

    speedom21[playerid] = CreatePlayerTextDraw(playerid, 367.500000, 373.333435, "LD_SPAC:white");
    PlayerTextDrawLetterSize(playerid, speedom21[playerid], 0.000000, 0.000000);
    PlayerTextDrawTextSize(playerid, speedom21[playerid], 50.625000, 49.583312);
    PlayerTextDrawAlignment(playerid, speedom21[playerid], 1);
    PlayerTextDrawColor(playerid, speedom21[playerid], -1);
    PlayerTextDrawUseBox(playerid, speedom21[playerid], true);
    PlayerTextDrawBoxColor(playerid, speedom21[playerid], 0);
    PlayerTextDrawSetShadow(playerid, speedom21[playerid], 0);
    PlayerTextDrawSetOutline(playerid, speedom21[playerid], 0);
    PlayerTextDrawFont(playerid, speedom21[playerid], 5);
    PlayerTextDrawBackgroundColor(playerid, speedom21[playerid], 0xFFFFFF00);
    PlayerTextDrawSetPreviewModel(playerid, speedom21[playerid], 411);
    PlayerTextDrawSetPreviewRot(playerid, speedom21[playerid], -10.000000, 0.000000, -20.000000, 1.000000);

    speedom22[playerid] = CreatePlayerTextDraw(playerid, 128.125000, 436.916656, "Health: ~b~1200.0");
    PlayerTextDrawLetterSize(playerid, speedom22[playerid], 0.274372, 0.946663);
    PlayerTextDrawAlignment(playerid, speedom22[playerid], 1);
    PlayerTextDrawColor(playerid, speedom22[playerid], -16776961);
    PlayerTextDrawSetShadow(playerid, speedom22[playerid], 1);
    PlayerTextDrawSetOutline(playerid, speedom22[playerid], 0);
    PlayerTextDrawBackgroundColor(playerid, speedom22[playerid], 255);
    PlayerTextDrawFont(playerid, speedom22[playerid], 2);
    PlayerTextDrawSetProportional(playerid, speedom22[playerid], 1);

	//speedomter2
    Textdraw3[playerid] = CreatePlayerTextDraw(playerid, 263.125000, 407.166870, "speed: 120 km/h~n~health: 1000.0~n~model: infernus~g~(411)");
	PlayerTextDrawLetterSize(playerid,Textdraw3[playerid], 0.186249, 1.279166);
	PlayerTextDrawAlignment(playerid,Textdraw3[playerid], 1);
	PlayerTextDrawColor(playerid,Textdraw3[playerid], 16777215);
	PlayerTextDrawSetShadow(playerid,Textdraw3[playerid], 0);
	PlayerTextDrawSetOutline(playerid,Textdraw3[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid,Textdraw3[playerid], 255);
	PlayerTextDrawFont(playerid,Textdraw3[playerid], 2);
	PlayerTextDrawSetProportional(playerid,Textdraw3[playerid], 1);

	Textdraw6[playerid] = CreatePlayerTextDraw(playerid,373.875000, 412.166564, "usebox");
	PlayerTextDrawLetterSize(playerid,Textdraw6[playerid], 0.000000, 1.472680);
	PlayerTextDrawTextSize(playerid,Textdraw6[playerid], 364.875000, 0.000000);
	PlayerTextDrawAlignment(playerid,Textdraw6[playerid], 1);
	PlayerTextDrawColor(playerid,Textdraw6[playerid], 0);
	PlayerTextDrawUseBox(playerid,Textdraw6[playerid], true);
	PlayerTextDrawBoxColor(playerid,Textdraw6[playerid], 1073742079);
	PlayerTextDrawSetShadow(playerid,Textdraw6[playerid], 0);
	PlayerTextDrawSetOutline(playerid,Textdraw6[playerid], 0);
	PlayerTextDrawFont(playerid,Textdraw6[playerid], 0);

	Textdraw7[playerid] = CreatePlayerTextDraw(playerid,368.000000, 416.083343, "usebox");
	PlayerTextDrawLetterSize(playerid,Textdraw7[playerid], 0.000000, 1.035180);
	PlayerTextDrawTextSize(playerid,Textdraw7[playerid], 358.625000, 0.000000);
	PlayerTextDrawAlignment(playerid,Textdraw7[playerid], 1);
	PlayerTextDrawColor(playerid,Textdraw7[playerid], 0);
	PlayerTextDrawUseBox(playerid,Textdraw7[playerid], true);
	PlayerTextDrawBoxColor(playerid,Textdraw7[playerid], -2147483393);
	PlayerTextDrawSetShadow(playerid,Textdraw7[playerid], 0);
	PlayerTextDrawSetOutline(playerid,Textdraw7[playerid], 0);
	PlayerTextDrawFont(playerid,Textdraw7[playerid], 0);

	Textdraw8[playerid] = CreatePlayerTextDraw(playerid,361.500000, 418.833374, "usebox");
	PlayerTextDrawLetterSize(playerid,Textdraw8[playerid], 0.000000, 0.722680);
	PlayerTextDrawTextSize(playerid,Textdraw8[playerid], 352.375000, 0.000000);
	PlayerTextDrawAlignment(playerid,Textdraw8[playerid], 1);
	PlayerTextDrawColor(playerid,Textdraw8[playerid], 0);
	PlayerTextDrawUseBox(playerid,Textdraw8[playerid], true);
	PlayerTextDrawBoxColor(playerid,Textdraw8[playerid], -16776961);
	PlayerTextDrawSetShadow(playerid,Textdraw8[playerid], 0);
	PlayerTextDrawSetOutline(playerid,Textdraw8[playerid], 0);
	PlayerTextDrawFont(playerid,Textdraw8[playerid], 0);

	Textdraw9[playerid] = CreatePlayerTextDraw(playerid,355.625000, 421.583312, "usebox");
	PlayerTextDrawLetterSize(playerid,Textdraw9[playerid], 0.000000, 0.472680);
	PlayerTextDrawTextSize(playerid,Textdraw9[playerid], 346.125000, 0.000000);
	PlayerTextDrawAlignment(playerid,Textdraw9[playerid], 1);
	PlayerTextDrawColor(playerid,Textdraw9[playerid], 0);
	PlayerTextDrawUseBox(playerid,Textdraw9[playerid], true);
	PlayerTextDrawBoxColor(playerid,Textdraw9[playerid], -16776961);
	PlayerTextDrawSetShadow(playerid,Textdraw9[playerid], 0);
	PlayerTextDrawSetOutline(playerid,Textdraw9[playerid], 0);
	PlayerTextDrawFont(playerid,Textdraw9[playerid], 0);

	Textdraw10[playerid] = CreatePlayerTextDraw(playerid,349.750000, 424.333343, "usebox");
	PlayerTextDrawLetterSize(playerid,Textdraw10[playerid], 0.000000, 0.160180);
	PlayerTextDrawTextSize(playerid,Textdraw10[playerid], 340.500000, 0.000000);
	PlayerTextDrawAlignment(playerid,Textdraw10[playerid], 1);
	PlayerTextDrawColor(playerid,Textdraw10[playerid], 0);
	PlayerTextDrawUseBox(playerid,Textdraw10[playerid], true);
	PlayerTextDrawBoxColor(playerid,Textdraw10[playerid], -802083329);
	PlayerTextDrawSetShadow(playerid,Textdraw10[playerid], 0);
	PlayerTextDrawSetOutline(playerid,Textdraw10[playerid], 0);
	PlayerTextDrawFont(playerid,Textdraw10[playerid], 0);

	Textdraw11[playerid] = CreatePlayerTextDraw(playerid,313.750000, 372.166595, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid,Textdraw11[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid,Textdraw11[playerid], 90.000000, 49.583374);
	PlayerTextDrawAlignment(playerid,Textdraw11[playerid], 1);
	PlayerTextDrawColor(playerid,Textdraw11[playerid], -1);
	PlayerTextDrawUseBox(playerid,Textdraw11[playerid], true);
	PlayerTextDrawBoxColor(playerid,Textdraw11[playerid], 0);
	PlayerTextDrawSetShadow(playerid,Textdraw11[playerid], 0);
	PlayerTextDrawSetOutline(playerid,Textdraw11[playerid], 0);
	PlayerTextDrawFont(playerid,Textdraw11[playerid], 5);
	PlayerTextDrawSetPreviewModel(playerid,Textdraw11[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid,Textdraw11[playerid], 0xFFFFFF00);
	PlayerTextDrawSetPreviewRot(playerid,Textdraw11[playerid], -5.000000, 0.000000, -20.000000, 1.000000);

	Textdraw12[playerid] = CreatePlayerTextDraw(playerid,295.625000, 390.833312, "Infernus");
	PlayerTextDrawLetterSize(playerid,Textdraw12[playerid], 0.223124, 1.664167);
	PlayerTextDrawAlignment(playerid,Textdraw12[playerid], 2);
	PlayerTextDrawColor(playerid,Textdraw12[playerid], -5963521);
	PlayerTextDrawUseBox(playerid,Textdraw12[playerid], true);
	PlayerTextDrawBoxColor(playerid,Textdraw12[playerid], 0);
	PlayerTextDrawSetShadow(playerid,Textdraw12[playerid], 1);
	PlayerTextDrawSetOutline(playerid,Textdraw12[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid,Textdraw12[playerid], -16776961);
	PlayerTextDrawFont(playerid,Textdraw12[playerid], 2);
	PlayerTextDrawSetProportional(playerid,Textdraw12[playerid], 1);
	
	//speedomter3
	speedm2[playerid] = CreatePlayerTextDraw(playerid,270.000000, 408.916717, "120");
	PlayerTextDrawLetterSize(playerid, speedm2[playerid], 0.408749, 2.498333);
	PlayerTextDrawAlignment(playerid, speedm2[playerid], 2);
	PlayerTextDrawColor(playerid, speedm2[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, speedm2[playerid], 1);
	PlayerTextDrawSetOutline(playerid, speedm2[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, speedm2[playerid], -16776961);
	PlayerTextDrawFont(playerid, speedm2[playerid], 2);
	PlayerTextDrawSetProportional(playerid, speedm2[playerid], 1);

	speedm4[playerid] = CreatePlayerTextDraw(playerid,353.750000, 380.333343, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, speedm4[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, speedm4[playerid], 87.500000, 45.500000);
	PlayerTextDrawAlignment(playerid, speedm4[playerid], 1);
	PlayerTextDrawColor(playerid, speedm4[playerid], -1);
	PlayerTextDrawUseBox(playerid, speedm4[playerid], true);
	PlayerTextDrawBoxColor(playerid, speedm4[playerid], 0);
	PlayerTextDrawSetShadow(playerid, speedm4[playerid], 0);
	PlayerTextDrawSetOutline(playerid, speedm4[playerid], 0);
	PlayerTextDrawFont(playerid, speedm4[playerid], 5);
	PlayerTextDrawBackgroundColor(playerid, speedm4[playerid], 0xFFFFFF00);
	PlayerTextDrawSetPreviewModel(playerid, speedm4[playerid], 411);
	PlayerTextDrawSetPreviewRot(playerid, speedm4[playerid], -10.000000, 0.000000, -20.000000, 1.000000);

	speedm5[playerid] = CreatePlayerTextDraw(playerid,296.250000, 410.666717, "Vehicle: ~p~Land Stalker~n~~g~Health: ~g~~h~1200.0");
	PlayerTextDrawLetterSize(playerid, speedm5[playerid], 0.246874, 1.150833);
	PlayerTextDrawAlignment(playerid, speedm5[playerid], 1);
	PlayerTextDrawColor(playerid, speedm5[playerid], 16711935);
	PlayerTextDrawSetShadow(playerid, speedm5[playerid], 0);
	PlayerTextDrawSetOutline(playerid, speedm5[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, speedm5[playerid], 51);
	PlayerTextDrawFont(playerid, speedm5[playerid], 1);
	PlayerTextDrawSetProportional(playerid, speedm5[playerid], 1);

	speedm7[playerid] = CreatePlayerTextDraw(playerid,396.250000, 419.416625, "i");
	PlayerTextDrawLetterSize(playerid, speedm7[playerid], 1.004375, 2.521668);
	PlayerTextDrawAlignment(playerid, speedm7[playerid], 1);
	PlayerTextDrawColor(playerid, speedm7[playerid], 1073742079);
	PlayerTextDrawSetShadow(playerid, speedm7[playerid], 0);
	PlayerTextDrawSetOutline(playerid, speedm7[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, speedm7[playerid], 51);
	PlayerTextDrawFont(playerid, speedm7[playerid], 2);
	PlayerTextDrawSetProportional(playerid, speedm7[playerid], 1);

	speedm8[playerid] = CreatePlayerTextDraw(playerid,390.375000, 423.333251, "i");
	PlayerTextDrawLetterSize(playerid, speedm8[playerid], 1.015000, 1.961668);
	PlayerTextDrawAlignment(playerid, speedm8[playerid], 1);
	PlayerTextDrawColor(playerid, speedm8[playerid], -2147483393);
	PlayerTextDrawSetShadow(playerid, speedm8[playerid], 0);
	PlayerTextDrawSetOutline(playerid, speedm8[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, speedm8[playerid], 51);
	PlayerTextDrawFont(playerid, speedm8[playerid], 2);
	PlayerTextDrawSetProportional(playerid, speedm8[playerid], 1);

	speedm9[playerid] = CreatePlayerTextDraw(playerid,384.500000, 428.416656, "i");
	PlayerTextDrawLetterSize(playerid, speedm9[playerid], 1.013125, 1.314168);
	PlayerTextDrawAlignment(playerid, speedm9[playerid], 1);
	PlayerTextDrawColor(playerid, speedm9[playerid], -1090518785);
	PlayerTextDrawSetShadow(playerid, speedm9[playerid], 0);
	PlayerTextDrawSetOutline(playerid, speedm9[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, speedm9[playerid], 51);
	PlayerTextDrawFont(playerid, speedm9[playerid], 2);
	PlayerTextDrawSetProportional(playerid, speedm9[playerid], 1);

	speedm10[playerid] = CreatePlayerTextDraw(playerid,378.625000, 432.333312, "i");
	PlayerTextDrawLetterSize(playerid, speedm10[playerid], 1.012500, 0.806667);
	PlayerTextDrawAlignment(playerid, speedm10[playerid], 1);
	PlayerTextDrawColor(playerid, speedm10[playerid], -16776961);
	PlayerTextDrawSetShadow(playerid, speedm10[playerid], 0);
	PlayerTextDrawSetOutline(playerid, speedm10[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, speedm10[playerid], 51);
	PlayerTextDrawFont(playerid, speedm10[playerid], 2);
	PlayerTextDrawSetProportional(playerid, speedm10[playerid], 1);
	
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
        KillTimer(speed0[killerid]);
	    TextDrawHideForPlayer(killerid, Textdraw0);
	    TextDrawHideForPlayer(killerid, Textdraw1);
	    TextDrawHideForPlayer(killerid, Textdraw2);
	    PlayerTextDrawHide(killerid, Textdraw3[killerid]);
	    TextDrawHideForPlayer(killerid, Textdraw4);
	    TextDrawHideForPlayer(killerid, Textdraw5);
	    PlayerTextDrawHide(killerid, Textdraw6[killerid]);
	    PlayerTextDrawHide(killerid, Textdraw7[killerid]);
	    PlayerTextDrawHide(killerid, Textdraw8[killerid]);
	    PlayerTextDrawHide(killerid, Textdraw9[killerid]);
	    PlayerTextDrawHide(killerid, Textdraw10[killerid]);
	    PlayerTextDrawHide(killerid, Textdraw11[killerid]);
	    PlayerTextDrawHide(killerid, Textdraw12[killerid]);
	    

		TextDrawHideForPlayer(killerid, speedom0);
	    TextDrawHideForPlayer(killerid, speedom1);
	    TextDrawHideForPlayer(killerid, speedom2);
	    PlayerTextDrawHide(killerid, speedom3[killerid]);
	    PlayerTextDrawHide(killerid, speedom4[killerid]);
	    PlayerTextDrawHide(killerid, speedom5[killerid]);
	    PlayerTextDrawHide(killerid, speedom6[killerid]);
	    PlayerTextDrawHide(killerid, speedom7[killerid]);
	    PlayerTextDrawHide(killerid, speedom8[killerid]);
	    PlayerTextDrawHide(killerid, speedom9[killerid]);
	    PlayerTextDrawHide(killerid, speedom10[killerid]);
	    PlayerTextDrawHide(killerid, speedom11[killerid]);
	    PlayerTextDrawHide(killerid, speedom12[killerid]);
	    PlayerTextDrawHide(killerid, speedom13[killerid]);
	    PlayerTextDrawHide(killerid, speedom14[killerid]);
	    PlayerTextDrawHide(killerid, speedom15[killerid]);
	    PlayerTextDrawHide(killerid, speedom16[killerid]);
	    TextDrawHideForPlayer(killerid, speedom17);
	    TextDrawHideForPlayer(killerid, speedom18);
	    TextDrawHideForPlayer(killerid, speedom19);
	    PlayerTextDrawHide(killerid, speedom20[killerid]);
	    PlayerTextDrawHide(killerid, speedom21[killerid]);
	    PlayerTextDrawHide(killerid, speedom22[killerid]);
	    TextDrawHideForPlayer(killerid, speedom23);
	    
	    
	    TextDrawHideForPlayer(killerid, speedm0);
	    TextDrawHideForPlayer(killerid, speedm1);
	    PlayerTextDrawHide(killerid, speedm2[killerid]);
	    TextDrawHideForPlayer(killerid, speedm3);
	    PlayerTextDrawHide(killerid, speedm4[killerid]);
	    PlayerTextDrawHide(killerid, speedm5[killerid]);
	    TextDrawHideForPlayer(killerid, speedm6);
	    PlayerTextDrawHide(killerid, speedm7[killerid]);
	    PlayerTextDrawHide(killerid, speedm8[killerid]);
	    PlayerTextDrawHide(killerid, speedm9[killerid]);
	    PlayerTextDrawHide(killerid, speedm10[killerid]);

        return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
        CarSpawner(playerid,411);
        
		return 1;
}

if (strcmp("/mc", cmdtext, true, 10) == 0)
	{
	if(IsPlayerAdmin(playerid)){
        if(Speedometer == 3){
        SendClientMessage(playerid, 0x33AA33AA, "Speed-O-Meter[1] has been Activated!");
        SetTimer("meter1activate", 500, 0);
        }
        else if(Speedometer == 2){
        SendClientMessage(playerid, 0x33AA33AA, "Speed-O-Meter[3] has been Activated!");
        SetTimer("meter3activate", 500, 0);
        }
        else if(Speedometer == 1){
        SendClientMessage(playerid, 0x33AA33AA, "Speed-O-Meter[2] has been Activated!");
        Speedometer = 2;
        }
	}
		// Do something here
	return 1;
}
return 0;
}

forward meter1activate(playerid);
public meter1activate(playerid)
{
Speedometer = 1;
return 1;
}
forward meter3activate(playerid);
public meter3activate(playerid)
{
Speedometer = 3;
return 1;
}

forward CarSpawner(playerid,model);
public CarSpawner(playerid,model)
{
	if(IsPlayerInAnyVehicle(playerid)) SendClientMessage(playerid, 0x33AA33AA, "You already have a car!");
 	else
	{
    	new Float:x, Float:y, Float:z, Float:angle;
	 	GetPlayerPos(playerid, x, y, z);
	 	GetPlayerFacingAngle(playerid, angle);
		//if(PlayerInfo[playerid][pCar] != -1) CarDeleter(PlayerInfo[playerid][pCar]);
	    new vehicleid=CreateVehicle(model, x, y, z, angle, -1, -1, -1);
		SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
		LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
		PutPlayerInVehicle(playerid, vehicleid, 0);
		ChangeVehicleColor(vehicleid,0,7);
        //PlayerInfo[playerid][pCar] = vehicleid;
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
        KillTimer(speed0[playerid]);
	    TextDrawHideForPlayer(playerid, Textdraw0);
	    TextDrawHideForPlayer(playerid, Textdraw1);
	    TextDrawHideForPlayer(playerid, Textdraw2);
	    PlayerTextDrawHide(playerid, Textdraw3[playerid]);
	    TextDrawHideForPlayer(playerid, Textdraw4);
	    TextDrawHideForPlayer(playerid, Textdraw5);
	    PlayerTextDrawHide(playerid, Textdraw6[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw7[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw8[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw9[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw10[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw11[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw12[playerid]);
	    
	    TextDrawHideForPlayer(playerid, speedom0);
	    TextDrawHideForPlayer(playerid, speedom1);
	    TextDrawHideForPlayer(playerid, speedom2);
	    PlayerTextDrawHide(playerid, speedom3[playerid]);
	    PlayerTextDrawHide(playerid, speedom4[playerid]);
	    PlayerTextDrawHide(playerid, speedom5[playerid]);
	    PlayerTextDrawHide(playerid, speedom6[playerid]);
	    PlayerTextDrawHide(playerid, speedom7[playerid]);
	    PlayerTextDrawHide(playerid, speedom8[playerid]);
	    PlayerTextDrawHide(playerid, speedom9[playerid]);
	    PlayerTextDrawHide(playerid, speedom10[playerid]);
	    PlayerTextDrawHide(playerid, speedom11[playerid]);
	    PlayerTextDrawHide(playerid, speedom12[playerid]);
	    PlayerTextDrawHide(playerid, speedom13[playerid]);
	    PlayerTextDrawHide(playerid, speedom14[playerid]);
	    PlayerTextDrawHide(playerid, speedom15[playerid]);
	    PlayerTextDrawHide(playerid, speedom16[playerid]);
	    TextDrawHideForPlayer(playerid, speedom17);
	    TextDrawHideForPlayer(playerid, speedom18);
	    TextDrawHideForPlayer(playerid, speedom19);
	    PlayerTextDrawHide(playerid, speedom20[playerid]);
	    PlayerTextDrawHide(playerid, speedom21[playerid]);
	    PlayerTextDrawHide(playerid, speedom22[playerid]);
	    TextDrawHideForPlayer(playerid, speedom23);
	    
	    
	    TextDrawHideForPlayer(playerid, speedm0);
	    TextDrawHideForPlayer(playerid, speedm1);
	    PlayerTextDrawHide(playerid, speedm2[playerid]);
	    TextDrawHideForPlayer(playerid, speedm3);
	    PlayerTextDrawHide(playerid, speedm4[playerid]);
	    PlayerTextDrawHide(playerid, speedm5[playerid]);
	    TextDrawHideForPlayer(playerid, speedm6);
	    PlayerTextDrawHide(playerid, speedm7[playerid]);
	    PlayerTextDrawHide(playerid, speedm8[playerid]);
	    PlayerTextDrawHide(playerid, speedm9[playerid]);
	    PlayerTextDrawHide(playerid, speedm10[playerid]);

        return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{

new getstate = GetPlayerState(playerid);
if(getstate == PLAYER_STATE_DRIVER || getstate == PLAYER_STATE_PASSENGER)
{
    new vehicleid;
    vehicleid = GetPlayerVehicleID(playerid);

    if(Speedometer == 1){
    speed0[playerid] = SetTimerEx("speedom", 1000, true, "i", playerid);
    PlayerTextDrawSetPreviewModel(playerid ,Textdraw11[playerid], GetVehicleModel(vehicleid));
    PlayerTextDrawShow(playerid, Textdraw11[playerid]);
    }
    else if(Speedometer == 2){
    speed0[playerid] = SetTimerEx("speedomm", 1000, true, "i", playerid);
    PlayerTextDrawSetPreviewModel(playerid, speedom21[playerid], GetVehicleModel(vehicleid));
    PlayerTextDrawShow(playerid, speedom21[playerid]);
    }
    else if(Speedometer == 3){
    speed0[playerid] = SetTimerEx("speedommm", 1000, true, "i", playerid);
    PlayerTextDrawSetPreviewModel(playerid, speedm4[playerid], GetVehicleModel(vehicleid));
    PlayerTextDrawShow(playerid, speedm4[playerid]);
    }
}
return 1;
}


forward speedom(playerid);
public speedom(playerid)
{
Speedometer1(playerid);
return 1;
}

forward speedomm(playerid);
public speedomm(playerid)
{
Speedometer2(playerid);
return 1;
}

forward speedommm(playerid);
public speedommm(playerid)
{
Speedometer3(playerid);
return 1;
}

forward Speedometer1(playerid);
public Speedometer1(playerid)
{
	new vehicleid;
	vehicleid = GetPlayerVehicleID(playerid);
	new Float:vehicle_health,final_vehicle_health,string[257];
	if(vehicleid != 0)
	{
	    TextDrawShowForPlayer(playerid, Textdraw0);
	    TextDrawShowForPlayer(playerid, Textdraw1);
	    TextDrawShowForPlayer(playerid, Textdraw2);
	    PlayerTextDrawShow(playerid, Textdraw3[playerid]);
	    TextDrawShowForPlayer(playerid, Textdraw4);
	    TextDrawShowForPlayer(playerid, Textdraw5);
	    PlayerTextDrawShow(playerid, Textdraw12[playerid]);

		new Float:VelX, Float:VelY, Float:VelZ;
        GetVehicleVelocity(vehicleid, VelX, VelY, VelZ);
        new Float:Speed;
        Speed = (floatsqroot(((VelX*VelX)+(VelY*VelY))+(VelZ*VelZ))* 181.5);
		GetVehicleHealth(vehicleid,vehicle_health);
		final_vehicle_health = floatround(floatround(vehicle_health)); //This will make the health show at 100 when the vehicle is not damaged and at 0 when it is in fire.
		format(string,257,"~b~SPEED: ~y~%i.0 KM/H~n~~g~HEALTH: ~y~%i.0~n~~p~MODEL: ~y~%s(%d)",floatround(Speed, floatround_floor), final_vehicle_health, VehicleName2[GetVehicleModel(vehicleid)-400],GetVehicleModel(vehicleid));
		PlayerTextDrawSetString(playerid ,Textdraw3[playerid], string);
		format(string,257,"%s",VehicleName2[GetVehicleModel(vehicleid)-400]);
		PlayerTextDrawSetString(playerid, Textdraw12[playerid], string);


		if(floatround(Speed, floatround_floor) < 10){
        PlayerTextDrawHide(playerid, Textdraw6[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw7[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw8[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw9[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw10[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 10 && floatround(Speed, floatround_floor) < 50){
        PlayerTextDrawHide(playerid, Textdraw6[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw7[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw8[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw9[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw10[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 50 && floatround(Speed, floatround_floor) < 100){
	    PlayerTextDrawHide(playerid, Textdraw6[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw7[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw8[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw9[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw10[playerid]);
		}

        else if(floatround(Speed, floatround_floor) > 100 && floatround(Speed, floatround_floor) < 150){
	    PlayerTextDrawHide(playerid, Textdraw6[playerid]);
	    PlayerTextDrawHide(playerid, Textdraw7[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw8[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw9[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw10[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 150 && floatround(Speed, floatround_floor) < 200){
	    PlayerTextDrawHide(playerid, Textdraw6[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw7[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw8[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw9[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw10[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 200){
	    PlayerTextDrawShow(playerid, Textdraw6[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw7[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw8[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw9[playerid]);
	    PlayerTextDrawShow(playerid, Textdraw10[playerid]);
		}

		//TextDrawSetPreviewModel(Textdraw11, "%d",GetVehicleModel(vehicleid));


	}
	else
	{
		PlayerTextDrawSetString(playerid, Textdraw3[playerid], " ");
		PlayerTextDrawSetString(playerid, Textdraw12[playerid], " ");
	}
    return 1;
}


forward Speedometer2(playerid);
public Speedometer2(playerid)
{
	new vehicleid;
	vehicleid = GetPlayerVehicleID(playerid);
	new Float:vehicle_health,final_vehicle_health,string[257];
	if(vehicleid != 0)
	{
	    TextDrawShowForPlayer(playerid, speedom0);
	    TextDrawShowForPlayer(playerid, speedom1);
	    TextDrawShowForPlayer(playerid, speedom2);
	    PlayerTextDrawShow(playerid, speedom3[playerid]);
	    TextDrawShowForPlayer(playerid, speedom17);
	    TextDrawShowForPlayer(playerid, speedom18);
	    TextDrawShowForPlayer(playerid, speedom19);
	    TextDrawShowForPlayer(playerid, speedom23);
	    PlayerTextDrawShow(playerid, speedom20[playerid]);
	    PlayerTextDrawShow(playerid, speedom22[playerid]);

		new Float:VelX, Float:VelY, Float:VelZ;
        GetVehicleVelocity(vehicleid, VelX, VelY, VelZ);
        new Float:Speed;
        Speed = (floatsqroot(((VelX*VelX)+(VelY*VelY))+(VelZ*VelZ))* 181.5);
		GetVehicleHealth(vehicleid,vehicle_health);
		final_vehicle_health = floatround(floatround(vehicle_health)); //This will make the health show at 100 when the vehicle is not damaged and at 0 when it is in fire.
		format(string,257,"HEALTH: ~b~%i.0",final_vehicle_health);
		PlayerTextDrawSetString(playerid, speedom22[playerid], string);
		format(string,257,"%s",VehicleName2[GetVehicleModel(vehicleid)-400]);
		PlayerTextDrawSetString(playerid, speedom20[playerid], string);

		if(floatround(Speed, floatround_floor) < 20){
        PlayerTextDrawHide(playerid, speedom4[playerid]);
        PlayerTextDrawHide(playerid, speedom5[playerid]);
        PlayerTextDrawHide(playerid, speedom6[playerid]);
        PlayerTextDrawHide(playerid, speedom7[playerid]);
        PlayerTextDrawHide(playerid, speedom8[playerid]);
        PlayerTextDrawHide(playerid, speedom9[playerid]);
        PlayerTextDrawHide(playerid, speedom10[playerid]);
        PlayerTextDrawHide(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawHide(playerid, speedom13[playerid]);
        PlayerTextDrawHide(playerid, speedom14[playerid]);
        PlayerTextDrawHide(playerid, speedom15[playerid]);
        PlayerTextDrawHide(playerid, speedom16[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 20 && floatround(Speed, floatround_floor) < 40){
        PlayerTextDrawHide(playerid, speedom4[playerid]);
        PlayerTextDrawHide(playerid, speedom5[playerid]);
        PlayerTextDrawHide(playerid, speedom6[playerid]);
        PlayerTextDrawHide(playerid, speedom7[playerid]);
        PlayerTextDrawHide(playerid, speedom8[playerid]);
        PlayerTextDrawHide(playerid, speedom9[playerid]);
        PlayerTextDrawHide(playerid, speedom10[playerid]);
        PlayerTextDrawHide(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawShow(playerid, speedom13[playerid]);
        PlayerTextDrawHide(playerid, speedom14[playerid]);
        PlayerTextDrawHide(playerid, speedom15[playerid]);
        PlayerTextDrawHide(playerid, speedom16[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 40 && floatround(Speed, floatround_floor) < 60){
        PlayerTextDrawHide(playerid, speedom4[playerid]);
        PlayerTextDrawHide(playerid, speedom5[playerid]);
        PlayerTextDrawHide(playerid, speedom6[playerid]);
        PlayerTextDrawHide(playerid, speedom7[playerid]);
        PlayerTextDrawHide(playerid, speedom8[playerid]);
        PlayerTextDrawHide(playerid, speedom9[playerid]);
        PlayerTextDrawHide(playerid, speedom10[playerid]);
        PlayerTextDrawHide(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawShow(playerid, speedom13[playerid]);
        PlayerTextDrawShow(playerid, speedom14[playerid]);
        PlayerTextDrawHide(playerid, speedom15[playerid]);
        PlayerTextDrawHide(playerid, speedom16[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 60 && floatround(Speed, floatround_floor) < 80){
        PlayerTextDrawHide(playerid, speedom4[playerid]);
        PlayerTextDrawHide(playerid, speedom5[playerid]);
        PlayerTextDrawHide(playerid, speedom6[playerid]);
        PlayerTextDrawHide(playerid, speedom7[playerid]);
        PlayerTextDrawHide(playerid, speedom8[playerid]);
        PlayerTextDrawHide(playerid, speedom9[playerid]);
        PlayerTextDrawHide(playerid, speedom10[playerid]);
        PlayerTextDrawHide(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawShow(playerid, speedom13[playerid]);
        PlayerTextDrawShow(playerid, speedom14[playerid]);
        PlayerTextDrawShow(playerid, speedom15[playerid]);
        PlayerTextDrawHide(playerid, speedom16[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 80 && floatround(Speed, floatround_floor) < 100){
        PlayerTextDrawHide(playerid, speedom4[playerid]);
        PlayerTextDrawHide(playerid, speedom5[playerid]);
        PlayerTextDrawHide(playerid, speedom6[playerid]);
        PlayerTextDrawHide(playerid, speedom7[playerid]);
        PlayerTextDrawHide(playerid, speedom8[playerid]);
        PlayerTextDrawHide(playerid, speedom9[playerid]);
        PlayerTextDrawHide(playerid, speedom10[playerid]);
        PlayerTextDrawHide(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawShow(playerid, speedom13[playerid]);
        PlayerTextDrawShow(playerid, speedom14[playerid]);
        PlayerTextDrawShow(playerid, speedom15[playerid]);
        PlayerTextDrawShow(playerid, speedom16[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 100 && floatround(Speed, floatround_floor) < 120){
        PlayerTextDrawShow(playerid, speedom4[playerid]);
        PlayerTextDrawHide(playerid, speedom5[playerid]);
        PlayerTextDrawHide(playerid, speedom6[playerid]);
        PlayerTextDrawHide(playerid, speedom7[playerid]);
        PlayerTextDrawHide(playerid, speedom8[playerid]);
        PlayerTextDrawHide(playerid, speedom9[playerid]);
        PlayerTextDrawHide(playerid, speedom10[playerid]);
        PlayerTextDrawHide(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawShow(playerid, speedom13[playerid]);
        PlayerTextDrawShow(playerid, speedom14[playerid]);
        PlayerTextDrawShow(playerid, speedom15[playerid]);
        PlayerTextDrawShow(playerid, speedom16[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 120 && floatround(Speed, floatround_floor) < 140){
        PlayerTextDrawShow(playerid, speedom4[playerid]);
        PlayerTextDrawShow(playerid, speedom5[playerid]);
        PlayerTextDrawHide(playerid, speedom6[playerid]);
        PlayerTextDrawHide(playerid, speedom7[playerid]);
        PlayerTextDrawHide(playerid, speedom8[playerid]);
        PlayerTextDrawHide(playerid, speedom9[playerid]);
        PlayerTextDrawHide(playerid, speedom10[playerid]);
        PlayerTextDrawHide(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawShow(playerid, speedom13[playerid]);
        PlayerTextDrawShow(playerid, speedom14[playerid]);
        PlayerTextDrawShow(playerid, speedom15[playerid]);
        PlayerTextDrawShow(playerid, speedom16[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 140 && floatround(Speed, floatround_floor) < 160){
        PlayerTextDrawShow(playerid, speedom4[playerid]);
        PlayerTextDrawShow(playerid, speedom5[playerid]);
        PlayerTextDrawShow(playerid, speedom6[playerid]);
        PlayerTextDrawHide(playerid, speedom7[playerid]);
        PlayerTextDrawHide(playerid, speedom8[playerid]);
        PlayerTextDrawHide(playerid, speedom9[playerid]);
        PlayerTextDrawHide(playerid, speedom10[playerid]);
        PlayerTextDrawHide(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawShow(playerid, speedom13[playerid]);
        PlayerTextDrawShow(playerid, speedom14[playerid]);
        PlayerTextDrawShow(playerid, speedom15[playerid]);
        PlayerTextDrawShow(playerid, speedom16[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 160 && floatround(Speed, floatround_floor) < 180){
        PlayerTextDrawShow(playerid, speedom4[playerid]);
        PlayerTextDrawShow(playerid, speedom5[playerid]);
        PlayerTextDrawShow(playerid, speedom6[playerid]);
        PlayerTextDrawShow(playerid, speedom7[playerid]);
        PlayerTextDrawHide(playerid, speedom8[playerid]);
        PlayerTextDrawHide(playerid, speedom9[playerid]);
        PlayerTextDrawHide(playerid, speedom10[playerid]);
        PlayerTextDrawHide(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawShow(playerid, speedom13[playerid]);
        PlayerTextDrawShow(playerid, speedom14[playerid]);
        PlayerTextDrawShow(playerid, speedom15[playerid]);
        PlayerTextDrawShow(playerid, speedom16[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 180 && floatround(Speed, floatround_floor) < 200){
        PlayerTextDrawShow(playerid, speedom4[playerid]);
        PlayerTextDrawShow(playerid, speedom5[playerid]);
        PlayerTextDrawShow(playerid, speedom6[playerid]);
        PlayerTextDrawShow(playerid, speedom7[playerid]);
        PlayerTextDrawShow(playerid, speedom8[playerid]);
        PlayerTextDrawHide(playerid, speedom9[playerid]);
        PlayerTextDrawHide(playerid, speedom10[playerid]);
        PlayerTextDrawHide(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawShow(playerid, speedom13[playerid]);
        PlayerTextDrawShow(playerid, speedom14[playerid]);
        PlayerTextDrawShow(playerid, speedom15[playerid]);
        PlayerTextDrawShow(playerid, speedom16[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 200 && floatround(Speed, floatround_floor) < 220){
        PlayerTextDrawShow(playerid, speedom4[playerid]);
        PlayerTextDrawShow(playerid, speedom5[playerid]);
        PlayerTextDrawShow(playerid, speedom6[playerid]);
        PlayerTextDrawShow(playerid, speedom7[playerid]);
        PlayerTextDrawShow(playerid, speedom8[playerid]);
        PlayerTextDrawShow(playerid, speedom9[playerid]);
        PlayerTextDrawHide(playerid, speedom10[playerid]);
        PlayerTextDrawHide(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawShow(playerid, speedom13[playerid]);
        PlayerTextDrawShow(playerid, speedom14[playerid]);
        PlayerTextDrawShow(playerid, speedom15[playerid]);
        PlayerTextDrawShow(playerid, speedom16[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 220 && floatround(Speed, floatround_floor) < 240){
        PlayerTextDrawShow(playerid, speedom4[playerid]);
        PlayerTextDrawShow(playerid, speedom5[playerid]);
        PlayerTextDrawShow(playerid, speedom6[playerid]);
        PlayerTextDrawShow(playerid, speedom7[playerid]);
        PlayerTextDrawShow(playerid, speedom8[playerid]);
        PlayerTextDrawShow(playerid, speedom9[playerid]);
        PlayerTextDrawShow(playerid, speedom10[playerid]);
        PlayerTextDrawHide(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawShow(playerid, speedom13[playerid]);
        PlayerTextDrawShow(playerid, speedom14[playerid]);
        PlayerTextDrawShow(playerid, speedom15[playerid]);
        PlayerTextDrawShow(playerid, speedom16[playerid]);
		}

        else if(floatround(Speed, floatround_floor) > 240){
        PlayerTextDrawShow(playerid, speedom4[playerid]);
        PlayerTextDrawShow(playerid, speedom5[playerid]);
        PlayerTextDrawShow(playerid, speedom6[playerid]);
        PlayerTextDrawShow(playerid, speedom7[playerid]);
        PlayerTextDrawShow(playerid, speedom8[playerid]);
        PlayerTextDrawShow(playerid, speedom9[playerid]);
        PlayerTextDrawShow(playerid, speedom10[playerid]);
        PlayerTextDrawShow(playerid, speedom11[playerid]);
        PlayerTextDrawShow(playerid, speedom12[playerid]);
        PlayerTextDrawShow(playerid, speedom13[playerid]);
        PlayerTextDrawShow(playerid, speedom14[playerid]);
        PlayerTextDrawShow(playerid, speedom15[playerid]);
        PlayerTextDrawShow(playerid, speedom16[playerid]);
		}
	//TextDrawSetPreviewModel(Textdraw11, "%d",GetVehicleModel(vehicleid));


	}
	else
	{
		PlayerTextDrawSetString(playerid, speedom20[playerid], " ");
		PlayerTextDrawSetString(playerid, speedom22[playerid], " ");
	}
    return 1;
}

forward Speedometer3(playerid);
public Speedometer3(playerid)
{
	new vehicleid;
	vehicleid = GetPlayerVehicleID(playerid);
	new Float:vehicle_health,final_vehicle_health,string[257];
	if(vehicleid != 0)
	{
	    TextDrawShowForPlayer(playerid, speedm0);
	    TextDrawShowForPlayer(playerid, speedm1);
	    PlayerTextDrawShow(playerid, speedm2[playerid]);
	    TextDrawShowForPlayer(playerid, speedm3);
	    PlayerTextDrawShow(playerid, speedm5[playerid]);
	    TextDrawShowForPlayer(playerid, speedm6);

		new Float:VelX, Float:VelY, Float:VelZ;
        GetVehicleVelocity(vehicleid, VelX, VelY, VelZ);
        new Float:Speed;
        Speed = (floatsqroot(((VelX*VelX)+(VelY*VelY))+(VelZ*VelZ))* 181.5);
		GetVehicleHealth(vehicleid,vehicle_health);
		final_vehicle_health = floatround(floatround(vehicle_health)); //This will make the health show at 100 when the vehicle is not damaged and at 0 when it is in fire.
		format(string,257,"Vehicle: ~p~%s~n~~g~Health: ~g~~h~%i.0", VehicleName2[GetVehicleModel(vehicleid)-400], final_vehicle_health);
		PlayerTextDrawSetString(playerid ,speedm5[playerid], string);
		format(string,257,"%i",floatround(Speed, floatround_floor));
		PlayerTextDrawSetString(playerid, speedm2[playerid], string);


		if(floatround(Speed, floatround_floor) < 20){
	    PlayerTextDrawHide(playerid, speedm7[playerid]);
	    PlayerTextDrawHide(playerid, speedm8[playerid]);
	    PlayerTextDrawHide(playerid, speedm9[playerid]);
	    PlayerTextDrawHide(playerid, speedm10[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 20 && floatround(Speed, floatround_floor) < 80){
	    PlayerTextDrawHide(playerid, speedm7[playerid]);
	    PlayerTextDrawHide(playerid, speedm8[playerid]);
	    PlayerTextDrawHide(playerid, speedm9[playerid]);
	    PlayerTextDrawShow(playerid, speedm10[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 80 && floatround(Speed, floatround_floor) < 140){
	    PlayerTextDrawHide(playerid, speedm7[playerid]);
	    PlayerTextDrawHide(playerid, speedm8[playerid]);
	    PlayerTextDrawShow(playerid, speedm9[playerid]);
	    PlayerTextDrawShow(playerid, speedm10[playerid]);
		}

        else if(floatround(Speed, floatround_floor) > 140 && floatround(Speed, floatround_floor) < 190){
	    PlayerTextDrawHide(playerid, speedm7[playerid]);
	    PlayerTextDrawShow(playerid, speedm8[playerid]);
	    PlayerTextDrawShow(playerid, speedm9[playerid]);
	    PlayerTextDrawShow(playerid, speedm10[playerid]);
		}

		else if(floatround(Speed, floatround_floor) > 190){
	    PlayerTextDrawShow(playerid, speedm7[playerid]);
	    PlayerTextDrawShow(playerid, speedm8[playerid]);
	    PlayerTextDrawShow(playerid, speedm9[playerid]);
	    PlayerTextDrawShow(playerid, speedm10[playerid]);
		}

		//TextDrawSetPreviewModel(Textdraw11, "%d",GetVehicleModel(vehicleid));


	}
	else
	{
		PlayerTextDrawSetString(playerid, speedm5[playerid], " ");
		PlayerTextDrawSetString(playerid, speedm2[playerid], " ");
	}
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
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}
