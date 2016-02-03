// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Sept 2003
 */
class XDOTZLoadMenu extends XDOTZSinglePlayerBase;

var localized string PageCaption;
var bool bRequiresConfirmation;

//Page components
var Automated BBXListBox  GamesList;

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
    AddSelectButton();

    class'UtilsXbox'.static.Filter_Containers("OWNER", DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName());

    GamesList.List.Clear();

    num = class'UtilsXbox'.static.Get_Num_Filtered_Containers();

    for (i = 0; i < num; ++i) {
        ireal = class'UtilsXbox'.static.Filtered_To_Real_Index(i);
        GamesList.List.Add(class'UtilsXbox'.static.Get_Container_Meta(ireal, "TITLE"));
    }
}

/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied here.
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {
    bRequiresConfirmation = bool(param1);
}

/*****************************************************************
 * DoButtonB
 *****************************************************************
 */
function DoButtonB(){
   PlayerOwner().PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
   Controller.CloseMenu( true );
}


/*****************************************************************
 * DoButtonA
 *****************************************************************
 */
function DoButtonA(){

}

/*****************************************************************
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */

function bool ButtonClicked(GUIComponent Sender) {
    local BBXListBox Selected;
    local int list_index;

    if (BBXListBox(Sender) != None) Selected = BBXListBox(Sender);
    if (Selected == None) return false;
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case GamesList:
             list_index = GamesList.List.Index;

             if (list_index < 0 || list_index >= GamesList.List.ItemCount)
                return true;

             if (bRequiresConfirmation == true){
               Controller.OpenMenu("DOTZMenu.XDOTZLoadConfirm",GamesList.List.GetItemAtIndex(list_index));
             } else {
                // Display loading screen
                Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");
                // load the game
               class'UtilsXbox'.static.Set_Reboot_Type(5);   // Is single player
               PlayerOwner().ClientTravel( "?loadnamed=" $ EncodeStringURL(GamesList.List.GetItemAtIndex(list_index)),TRAVEL_Absolute, false );
             }


             break;
    };
   return true;
}

//===========================================================================
// defaultproperties
//===========================================================================

defaultproperties
{
     PageCaption="Load Game"
     bRequiresConfirmation=True
     Begin Object Class=BBXListBox Name=GamesList_btn
         bVisibleWhenEmpty=True
         bNeverFocus=True
         WinTop=0.200000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.600000
         __OnClick__Delegate=XDOTZLoadMenu.ButtonClicked
         Name="GamesList_btn"
     End Object
     GamesList=BBXListBox'DOTZMenu.XDOTZLoadMenu.GamesList_btn'
     __OnKeyEvent__Delegate=XDOTZLoadMenu.HandleKeyEvent
}
