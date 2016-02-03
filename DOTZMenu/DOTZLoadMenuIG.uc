// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZMainMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    January 19, 2005
 */

class DOTZLoadMenuIG extends DOTZInGamePage;



var localized string PageCaption;
var localized string NewSlot;

var automated GUIButton YesButton;
var automated GUIButton NoButton;

var string ConfirmMenu;

//Page components
var Automated BBListBox  GamesList;

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
 * ButtonClicked
 * Notification that the user clicked a component on the page
 *****************************************************************
 */

function bool ButtonClicked(GUIComponent Sender) {
    local GUIButton Selected;
    local int list_index;

    if (GUIButton(Sender) != None) Selected = GUIButton(Sender);
    if (Selected == None) return false;

    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);

    switch (Selected) {
        case YesButton:

            list_index = GamesList.List.Index;

            if (list_index < 0 || list_index >= GamesList.List.ItemCount)
                return false;

            // load the game
            Controller.OpenMenu("DOTZMenu.DOTZLoadingMenuClientTravel", EncodeStringURL(GamesList.List.GetItemAtIndex(list_index)));
            //PlayerOwner().ClientTravel( "?loadnamed=" $ EncodeStringURL(GamesList.List.GetItemAtIndex(list_index)),TRAVEL_Absolute, false );

            //Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");
            //BBGuiController(Controller).CloseAll(true);

            break;

        case NoButton:
            Controller.CloseMenu( true );
            break;
    };

   return true;
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     PageCaption="Save Game"
     NewSlot="<New Save Game>"
     Begin Object Class=GUIButton Name=cYesButton
         Caption="Load"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.800000
         WinLeft=0.600000
         WinWidth=0.250000
         WinHeight=0.050000
         __OnClick__Delegate=DOTZLoadMenuIG.ButtonClicked
         Name="cYesButton"
     End Object
     YesButton=GUIButton'DOTZMenu.DOTZLoadMenuIG.cYesButton'
     Begin Object Class=GUIButton Name=cNoButton
         Caption="Cancel"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.800000
         WinLeft=0.200000
         WinWidth=0.250000
         WinHeight=0.050000
         TabOrder=1
         __OnClick__Delegate=DOTZLoadMenuIG.ButtonClicked
         Name="cNoButton"
     End Object
     NoButton=GUIButton'DOTZMenu.DOTZLoadMenuIG.cNoButton'
     ConfirmMenu="DOTZMenu.DOTZSaveConfirm"
     Begin Object Class=BBListBox Name=GamesList_btn
         bVisibleWhenEmpty=True
         bBoundToParent=True
         bScaleToParent=True
         bNeverFocus=True
         WinTop=0.100000
         WinLeft=0.100000
         WinWidth=0.800000
         WinHeight=0.600000
         __OnClick__Delegate=DOTZLoadMenuIG.ButtonClicked
         Name="GamesList_btn"
     End Object
     GamesList=BBListBox'DOTZMenu.DOTZLoadMenuIG.GamesList_btn'
     __OnKeyEvent__Delegate=DOTZLoadMenuIG.HandleKeyEvent
}
