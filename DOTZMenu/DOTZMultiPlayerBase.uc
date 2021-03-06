// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class DOTZMultiPlayerBase extends DOTZPage;

//configurable stuff
var localized string MinuteText;
var localized string MinutesText;

var localized string KillText;
var localized string KillsText;

var localized string PtText;
var localized string PtsText;

var localized string PlayerText;
var localized string PlayersText;

var localized string SlotText;
var localized string SlotsText;

var localized string UnlimitedText;

// A few localizable strings
var localized string gametype_deathmatch;
var localized string gametype_teamdeathmatch;
var localized string gametype_capturetheflag;
var localized string gametype_invasion;

var localized string yesno_no;
var localized string yesno_yes;

var localized string AnyText;
var localized string NoneText;

// Map names
var localized string BothText;

var localized string DeathmatchMap1;
var localized string DeathmatchMap2;
var localized string DeathmatchMap3;
var localized string DeathmatchMap4;

var localized string CaptureTheFlagMap1;
var localized string CaptureTheFlagMap2;
var localized string CaptureTheFlagMap3;

var localized string InvasionMap1;
var localized string InvasionMap2;
var localized string InvasionMap3;
var localized string InvasionMap4;
var localized string InvasionMap5;
var localized string InvasionMap6;

var localized string EnemyPatheticTxt;
var localized string EnemyNormalTxt;
var localized string EnemyImpossibleTxt;

var bool bIsTeamMatch;

/*****************************************************************
 * Game type strings
 *****************************************************************
 */
function string IntToGameType (int gt)
{
    local string game_type_string;

    switch (gt) {
        case 0:    game_type_string = gametype_deathmatch;      break;
        case 1:    game_type_string = gametype_teamdeathmatch;  break;
        case 2:    game_type_string = gametype_capturetheflag;  break;
        case 3:    game_type_string = gametype_invasion;        break;
    };

    return game_type_string;
}

function FillInGameTypes (BBComboBox box)
{
    box.List.Add(IntToGameType(0));
    box.List.Add(IntToGameType(1));
    box.List.Add(IntToGameType(2));
    box.List.Add(IntToGameType(3));
}

function FillInGameTypesAny (BBComboBox box)
{
    FillInGameTypes(box);
    Box.List.Add(AnyText);
//    box.List.AddItem(AnyText);
}

function bool IsGameTypeIndexWildcard(int pi)
{
    if (pi >= 4 || pi < 0)
       return true;
    else
       return false;
}

/*****************************************************************
 * Yes and No
 *****************************************************************
 */

function string IntToYesNo (int gt)
{
    local string yesno_string;

    switch (gt) {
        case 0:    yesno_string = yesno_no;   break;
        default:   yesno_string = yesno_yes;  break;
    };

    return yesno_string;
}

/*****************************************************************
 * Used to fill in time limit lists
 *****************************************************************
 */

function FillInTimeLimits (BBComboBox box)
{
//   box.AddItem(UnlimitedText);    //remember to update timelimitindextominutes
//   box.AddItem("1 " $ MinuteText,,"1");
//   box.AddItem("2 " $ MinutesText,,"2");
//   box.AddItem("3 " $ MinutesText,,"3");
//   box.AddItem("4 " $ MinutesText,,"4");
   box.AddItem("5 " $ MinutesText,,"5");
   box.AddItem("6 " $ MinutesText,,"6");
   box.AddItem("7 " $ MinutesText,,"7");
   box.AddItem("8 " $ MinutesText,,"8");
   box.AddItem("9 " $ MinutesText,,"9");
   box.AddItem("10 " $ MinutesText,,"10");
   box.AddItem("15 " $ MinutesText,,"15");
   box.AddItem("20 " $ MinutesText,,"20");
   box.AddItem("25 " $ MinutesText,,"25");
   box.AddItem("30 " $ MinutesText,,"30");
   box.AddItem("35 " $ MinutesText,,"35");
   box.AddItem("40 " $ MinutesText,,"40");
   box.AddItem("60 " $ MinutesText,,"60");
}

//depricated
/*
function int TimeLimitIndexToMinutes (int i)
{
    switch (i) {
        //0 - unlimited removed!
        case 0:     return 1;
        case 1:     return 2;
        case 2:     return 3;
        case 3:     return 4;
        case 4:     return 5;
        case 5:     return 6;
        case 6:     return 7;
        case 7:     return 8;
        case 8:     return 9;
        case 9:     return 10;
        case 10:    return 15;
        case 11:    return 20;
        case 12:    return 25;
        case 13:    return 30;
        case 14:    return 35;
        case 15:    return 40;
        case 16:    return 60;
//        case 17:    return 60;
    };
}
*/
/*****************************************************************
 * Used to fill in score lists
 *****************************************************************
 */

function FillInScoreLimits (BBComboBox box, int gt)
{

    if (gt == 0) {       // Deathmatch
      //box.AddItem(UnlimitedText);
      box.AddItem("1 " $ KillText,,"1");
      box.AddItem("2 " $ KillsText,,"2");
      box.AddItem("5 " $ KillsText,,"5");
      box.AddItem("10 " $ KillsText,,"10");
      box.AddItem("15 " $ KillsText,,"15");
      box.AddItem("20 " $ KillsText,,"20");
      box.AddItem("30 " $ KillsText,,"30");
      box.AddItem("40 " $ KillsText,,"40");
      box.AddItem("50 " $ KillsText,,"50");
      box.AddItem("60 " $ KillsText,,"60");
      box.AddItem("70 " $ KillsText,,"70");
      box.AddItem("80 " $ KillsText,,"80");
      box.AddItem("90 " $ KillsText,,"90");
      box.AddItem("100 " $ KillsText,,"100");
      box.AddItem("125 " $ KillsText,,"125");
      box.AddItem("150 " $ KillsText,,"150");
      box.AddItem("175 " $ KillsText,,"175");
      box.AddItem("200 " $ KillsText,,"200");
      box.SetIndex(4);
    } else if (gt == 1) {       // Team Deathmatch
      //box.AddItem(UnlimitedText);
      box.AddItem("1 " $ KillText,,"1");
      box.AddItem("2 " $ KillsText,,"2");
      box.AddItem("5 " $ KillsText,,"5");
      box.AddItem("10 " $ KillsText,,"10");
      box.AddItem("15 " $ KillsText,,"15");
      box.AddItem("20 " $ KillsText,,"20");
      box.AddItem("30 " $ KillsText,,"30");
      box.AddItem("40 " $ KillsText,,"40");
      box.AddItem("50 " $ KillsText,,"50");
      box.AddItem("60 " $ KillsText,,"60");
      box.AddItem("70 " $ KillsText,,"70");
      box.AddItem("80 " $ KillsText,,"80");
      box.AddItem("90 " $ KillsText,,"90");
      box.AddItem("100 " $ KillsText,,"100");
      box.AddItem("125 " $ KillsText,,"125");
      box.AddItem("150 " $ KillsText,,"150");
      box.AddItem("175 " $ KillsText,,"175");
      box.AddItem("200 " $ KillsText,,"200");
      box.SetIndex(6);
    } else if (gt == 2) {       // CTF
      //box.AddItem(UnlimitedText);
      box.AddItem("1 " $ PtText,,"1");
      box.AddItem("2 " $ PtsText,,"2");
      box.AddItem("5 " $ PtsText,,"5");
      box.AddItem("10 " $ PtsText,,"10");
      box.AddItem("15 " $ PtsText,,"15");
      box.AddItem("20 " $ PtsText,,"20");
      box.AddItem("30 " $ PtsText,,"30");
      box.AddItem("40 " $ PtsText,,"40");
      box.SetIndex(2);
    } else if (gt == 3) {       // Invasion
      box.AddItem(UnlimitedText,,"0");
    }
}

//depricated
/*
function int ScoreLimitIndexToScore (int i)
{
    switch (i) {
        case 0:     return 0;
        case 1:     return 1;
        case 2:     return 2;
        case 3:     return 5;
        case 4:     return 10;
        case 5:     return 15;
        case 6:     return 20;
        case 7:     return 30;
        case 8:     return 40;
    };
}

*/
/*****************************************************************
 * Used to fill in player lists
 *****************************************************************
 */

function FillInPlayerLimits (BBComboBox box, int gt)
{
    box.List.Clear();
    if (gt == 0) {       // Deathmatch
      box.AddItem("1 " $ PlayerText);
      box.AddItem("2 " $ PlayersText);
      box.AddItem("3 " $ PlayersText);
      box.AddItem("4 " $ PlayersText);
      box.AddItem("5 " $ PlayersText);
      box.AddItem("6 " $ PlayersText);
      box.AddItem("7 " $ PlayersText);
      box.AddItem("8 " $ PlayersText);
      box.SetIndex(7);
    } else if (gt == 1) {       // Team Deathmatch
      box.AddItem("1 " $ PlayerText);
      box.AddItem("2 " $ PlayersText);
      box.AddItem("3 " $ PlayersText);
      box.AddItem("4 " $ PlayersText);
      box.AddItem("5 " $ PlayersText);
      box.AddItem("6 " $ PlayersText);
      box.AddItem("7 " $ PlayersText);
      box.AddItem("8 " $ PlayersText);
      box.SetIndex(7);
    } else if (gt == 2) {       // CTF
      box.AddItem("1 " $ PlayerText);
      box.AddItem("2 " $ PlayersText);
      box.AddItem("3 " $ PlayersText);
      box.AddItem("4 " $ PlayersText);
      box.AddItem("5 " $ PlayersText);
      box.AddItem("6 " $ PlayersText);
      box.AddItem("7 " $ PlayersText);
      box.AddItem("8 " $ PlayersText);
      box.SetIndex(7);
    } else if (gt == 3) {       // Invasion
      box.AddItem("1 " $ PlayerText);
      box.AddItem("2 " $ PlayersText);
      box.AddItem("3 " $ PlayersText);
      box.AddItem("4 " $ PlayersText);
      box.SetIndex(3);
    } else {
      box.AddItem("1 " $ PlayerText);
      box.AddItem("2 " $ PlayersText);
      box.AddItem("3 " $ PlayersText);
      box.AddItem("4 " $ PlayersText);
      box.AddItem("5 " $ PlayersText);
      box.AddItem("6 " $ PlayersText);
      box.AddItem("7 " $ PlayersText);
      box.AddItem("8 " $ PlayersText);
      box.SetIndex(7);
    }
}

function FillInPlayerLimitsAny (BBComboBox box,int gt)
{
   FillInPlayerLimits(box,gt);
   box.AddItem(AnyText);
   box.SetIndex(box.List.ItemCount-1);
}

function bool IsPlayerIndexWildcard(int gt, int pi)
{
    if (gt == 0) {       // Deathmatch
        if (pi >= 8 || pi < 0)  return true;
        else                    return false;
    } else if (gt == 1) {       // Team Deathmatch
        if (pi >= 8 || pi < 0)  return true;
        else                    return false;
    } else if (gt == 2) {       // CTF
        if (pi >= 8 || pi < 0)  return true;
        else                    return false;
    } else if (gt == 3) {       // Invasion
        if (pi >= 6 || pi < 0)  return true;
        else                    return false;
    }

    return true;

}

/*****************************************************************
 * Used to fill in private slots
 *****************************************************************
 */

function FillInPrivateSlots (BBComboBox box)
{
   box.AddItem(yesno_no);
   box.AddItem(yesno_yes);
}

/*****************************************************************
 * Used to fill in private slot lists
 *****************************************************************
 */

function FillInMapTitles (GUIList box, int gt)
{

    if (gt == 0) {       // Deathmatch
        box.Add(DeathmatchMap1,,GetActualMapName(gt, 0));
        box.Add(DeathmatchMap2,,GetActualMapName(gt, 1));
        box.Add(DeathmatchMap3,,GetActualMapName(gt, 2));
        box.Add(DeathmatchMap4,,GetActualMapName(gt, 3));
        SetTeamMatchStatus(false);
    } else if (gt == 1) {       // Team Deathmatch
        box.Add(DeathmatchMap1,,GetActualMapName(gt, 0));
        box.Add(DeathmatchMap2,,GetActualMapName(gt, 1));
        box.Add(DeathmatchMap3,,GetActualMapName(gt, 2));
        box.Add(DeathmatchMap4,,GetActualMapName(gt, 3));
        SetTeamMatchStatus(true);
    } else if (gt == 2) {       // CTF
        box.Add(CaptureTheFlagMap1,,GetActualMapName(gt, 0));
        box.Add(CaptureTheFlagMap2,,GetActualMapName(gt, 1));
        box.Add(CaptureTheFlagMap3,,GetActualMapName(gt, 2));
        SetTeamMatchStatus(true);
    } else if (gt == 3) {       // Invasion
        box.Add(InvasionMap1,,GetActualMapName(gt, 0));
        box.Add(InvasionMap2,,GetActualMapName(gt, 1));
        box.Add(InvasionMap3,,GetActualMapName(gt, 2));
        box.Add(InvasionMap4,,GetActualMapName(gt, 3));
        box.Add(InvasionMap5,,GetActualMapName(gt, 4));
        box.Add(InvasionMap6,,GetActualMapName(gt, 5));
        SetTeamMatchStatus(true);
    }
}

/*****************************************************************
 * Used to fill in private slot lists
 *****************************************************************
 */

function string GetActualMapName (int gt, int map)
{
    if (gt == 0) {       // Deathmatch
        switch (map) {
            case 0:   return "DM-Office.day";
            case 1:   return "DM-Hedge.day";
            case 2:   return "DM-Docks.day";
        };
    } else if (gt == 1) {       // Team Deathmatch
        switch (map) {
            case 0:   return "DM-Office.day";
            case 1:   return "DM-Hedge.day";
            case 2:   return "DM-Docks.day";
        };
    } else if (gt == 2) {       // CTF
        switch (map) {
            case 0:   return "CTF-Library.day";
            case 1:   return "CTF-Sewers.day";
        };
    } else if (gt == 3) {       // Invasion
        switch (map) {
            case 0:   return "IN-Streets.day";
            case 1:   return "IN-Hedge.day";
            case 2:   return "IN-Library.day";
            case 3:   return "IN-Office.day";
            case 4:   return "IN-Sewers.day";
            case 5:   return "IN-Garden.day";
        };
    }
}

/*****************************************************************
 *
 *****************************************************************
 */
function SetTeamMatchStatus(bool IsTeamGame){
   //see child implementations
   bIsTeamMatch = IsTeamGame;
}


/*****************************************************************
 * default properties
 *****************************************************************
 */

defaultproperties
{
     MinuteText="minute"
     MinutesText="minutes"
     KillText="kill"
     KillsText="kills"
     PtText="flag capture"
     PtsText="flag captures"
     PlayerText="player"
     PlayersText="players"
     SlotText="slot"
     SlotsText="slots"
     UnlimitedText="Unlimited"
     gametype_deathmatch="Deathmatch"
     gametype_teamdeathmatch="Team Deathmatch"
     gametype_capturetheflag="Capture the Flag"
     gametype_invasion="Invasion"
     yesno_no="No"
     yesno_yes="Yes"
     AnyText="Any"
     NoneText="None"
     BothText="Both"
     DeathmatchMap1="Office"
     DeathmatchMap2="Hedge"
     DeathmatchMap3="Docks"
     CaptureTheFlagMap1="Library"
     CaptureTheFlagMap2="Sewers"
     InvasionMap1="Streets"
     InvasionMap2="Hedge"
     InvasionMap3="Library"
     InvasionMap4="Office"
     InvasionMap5="Sewers"
     InvasionMap6="Garden"
     EnemyPatheticTxt="Pathetic"
     EnemyNormalTxt="Normal"
     EnemyImpossibleTxt="Impossible"
}
