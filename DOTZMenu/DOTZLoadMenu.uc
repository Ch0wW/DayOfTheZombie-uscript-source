// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Sept 2003
 */
class DOTZLoadMenu extends DOTZSinglePlayerBase;



//Page components
var Automated BBListBox  GamesList;

var localized string PageCaption;

//internal
//var int escHack;
var sound ClickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */

function InitComponent(GUIController MyController, GUIComponent MyOwner){
    local int i;
    local int ireal;
    local int num;

    Super.InitComponent(MyController, MyOwner);
    SetPageCaption (PageCaption);
    AddBackButton();
    AddNextButton();

    class'UtilsXbox'.static.Filter_Containers("OWNER", DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName());
    //class'UtilsXbox'.static.Filter_Containers("DATATYPE", "SAVE");

    GamesList.List.Clear();

    num = class'UtilsXbox'.static.Get_Num_Filtered_Containers();

    for (i = 0; i < num; ++i) {
        ireal = class'UtilsXbox'.static.Filtered_To_Real_Index(i);
        GamesList.List.Add(class'UtilsXbox'.static.Get_Container_Meta(ireal, "TITLE"));
    }


    // Magical sorting
    Sort_Games(GamesList);
}

/*****************************************************************
 * Next Button
 *****************************************************************
 */

function Click_Next ()
{
    local int list_index;

    list_index = GamesList.List.Index;

    if (list_index < 0 || list_index >= GamesList.List.ItemCount)
        return;

    Controller.OpenMenu("DOTZMenu.DOTZLoadingMenuClientTravel", EncodeStringURL(GamesList.List.GetItemAtIndex(list_index)));
}

/*****************************************************************
 * Closed
 *****************************************************************
 */

event Closed(GUIComponent Sender, bool bCancelled){
}


/*****************************************************************
 * HandleKeyEvent
 *****************************************************************
 */
/*function bool HandleKeyEvent(out byte Key,out byte State,float delta) {

    //ESC IS PRESSED
    if (Key==0x1B) {
       if (escHack == 0){
          escHack = 1;
          return true;
       }
       Controller.CloseMenu(true);
    }
    return true;
} */



//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     Begin Object Class=BBListBox Name=GamesList_btn
         bVisibleWhenEmpty=True
         bNeverFocus=True
         WinTop=0.250000
         WinLeft=0.250000
         WinWidth=0.500000
         WinHeight=0.600000
         Name="GamesList_btn"
     End Object
     GamesList=BBListBox'DOTZMenu.DOTZLoadMenu.GamesList_btn'
     PageCaption="Load Game"
     ClickSound=Sound'DOTZXInterface.Select'
     __OnKeyEvent__Delegate=DOTZLoadMenu.HandleKeyEvent
}
