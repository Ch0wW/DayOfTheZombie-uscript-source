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

class DOTZSaveMenu extends DOTZInGamePage;



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
    Super.InitComponent(MyController, MyOwner);
    SetPageCaption (PageCaption);

    Refresh();
}

/**
 * Happens every time the menu is opened, not just the first.
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);
    Refresh();
}
/*****************************************************************
 * Add a new slot?
 *****************************************************************
 */

function Refresh () {
    local int i;
    local int ireal;
    local int num;

    class'UtilsXbox'.static.Filter_Containers("OWNER", DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName());

    GamesList.List.Clear();

    num = class'UtilsXbox'.static.Get_Num_Filtered_Containers();

    if (AddNewSlot ()) {
        GamesList.List.Add(NewSlot);
    }

    for (i = 0; i < num; ++i) {
        ireal = class'UtilsXbox'.static.Filtered_To_Real_Index(i);
        if (class'UtilsXbox'.static.Get_Container_Meta(ireal, "AUTOSAVE") != "true" &&
            class'UtilsXbox'.static.Get_Container_Meta(ireal, "QUICKSAVE") != "true") {
            GamesList.List.Add(class'UtilsXbox'.static.Get_Container_Meta(ireal, "TITLE"));
        }
    }

    // Magical sorting
    Sort_Games(GamesList);
}

/*****************************************************************
 * Add a new slot?
 *****************************************************************
 */

function bool AddNewSlot (){
   return (class'UtilsXbox'.static.Get_Num_Filtered_Containers() < 10);
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
                return true;

             if (list_index == 0) {
                Controller.OpenMenu(ConfirmMenu, "", DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName());
             } else {
                Controller.OpenMenu(ConfirmMenu, GamesList.List.GetItemAtIndex(list_index), DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName());
             }

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
         Caption="Save"
         StyleName="BBRoundButton"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.800000
         WinLeft=0.600000
         WinWidth=0.250000
         WinHeight=0.050000
         __OnClick__Delegate=DOTZSaveMenu.ButtonClicked
         Name="cYesButton"
     End Object
     YesButton=GUIButton'DOTZMenu.DOTZSaveMenu.cYesButton'
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
         __OnClick__Delegate=DOTZSaveMenu.ButtonClicked
         Name="cNoButton"
     End Object
     NoButton=GUIButton'DOTZMenu.DOTZSaveMenu.cNoButton'
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
         __OnClick__Delegate=DOTZSaveMenu.ButtonClicked
         Name="GamesList_btn"
     End Object
     GamesList=BBListBox'DOTZMenu.DOTZSaveMenu.GamesList_btn'
     __OnKeyEvent__Delegate=DOTZSaveMenu.HandleKeyEvent
}
