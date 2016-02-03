// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class ChangeLevelTrigger extends ScriptedTrigger
hidecategories(AIScript);

var() name    LevelEndEvent;
var() localized string  LoadingMenuText;
var() string  NextLevel;
var() texture LoadingImage;
var() bool bEndOfGame;
var() bool bFadeView;
var() string MenuName;


/*****************************************************************
 * PostBeginPlay
 *****************************************************************
 */
//function PostBeginPlay(){
//function SpawnController

function PreBeginPlay(){
    super.PreBeginPlay();

    //wait for event
    Actions[0] = new(Level) Class'ACTION_WaitForEvent';
    ACTION_WaitForEvent(Actions[0]).ExternalEvent = LevelEndEvent;

    //fade the view
    Actions[1] = new(Level) Class'ACTION_AdvancedFadeView';

    //wait for timer
    Actions[2] = new(Level) Class'ACTION_WaitForTimerTwo';
    ACTION_WaitForTimerTwo(Actions[2]).PauseTime = 3;

    //open the menu
    Actions[3] = new(Level) Class'ACTION_OpenMenu';
    ACTION_OpenMenu(Actions[3]).Menu = MenuName;
    ACTION_OpenMenu(Actions[3]).MenuParam1 = LoadingMenutext;
    ACTION_OpenMenu(Actions[3]).MenuParam2 = string(LoadingImage);

    //wit a sec
    Actions[4] = new(Level) Class'ACTION_WaitForTimerTwo';
    ACTION_WaitForTimerTwo(Actions[4]).PauseTime = 2;

    //change the level
    Actions[5] = new(Level) Class'ACTION_ChangeLevelEx';
    ACTION_ChangeLevelEx(Actions[5]).URL = NextLevel;

    if(bFadeView == false){
      Actions.Remove(1,2);
    }

    if (bEndOfGame){
      class'UtilsXbox'.static.Set_Reboot_Type(6);   // IS_RETURN_FROM_SINGLE_PLAYER
    }

}

defaultproperties
{
     LevelEndEvent="LevelEnd"
     LoadingMenuText="Loading..."
     bFadeView=True
     MenuName="DOTZMenu.XDOTZLoadingMenu"
}
