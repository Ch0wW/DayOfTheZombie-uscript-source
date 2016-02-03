// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 *
 * @author  Jesse LaChapelle (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    July 2004
 */
class DOTZCreditsMenu extends DOTZSinglePlayerBase
config(Credits);




//Controls
var Automated GUIButton   BackButton;
var array<GUIListBox> CreditBoxes;
var Automated GUILabel    Title;

//internal
//var int escHack;
var config array<string> Credit;
var sound clickSound;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner){
    Super.InitComponent(MyController, MyOwner);
    SetCredits();
}


/*****************************************************************
 * ListOnClick
 * Overridden so you can't click it
 *****************************************************************
 */
function bool ListOnClick(GUIComponent Sender) {
    local int i;
    for ( i = 0; i < creditBoxes.length; ++i ) {
        CreditBoxes[i].List.bHasFocus = false;
        CreditBoxes[i].List.SetIndex(-1);
    }
    return false;
}


/*****************************************************************
 * ListOnMousePressed
 * Overridden so you can't mouse press on it
 *****************************************************************
 */
function ListOnMousePressed(GuiComponent Sender, bool bRepeat) {
    local int i;
    for ( i = 0; i < creditBoxes.length; ++i ) {
        CreditBoxes[i].List.bHasFocus = false;
        CreditBoxes[i].List.SetIndex(-1);
    }
}


/*****************************************************************
 * HandleParameters
 * When open menu get's called, the parameter values are supplied
 * here.
 *
 * Param1 - the menu to load
 * Param2 - the name of the sub menu to load on top of the first menu
 *****************************************************************
 */
event HandleParameters( String ChapterNum, String PageNum ) {}



/*****************************************************************
 * SetImageAndText
 *****************************************************************
 */
function SetCredits(){
    local int i;
    local GuiListBox currentList;

    CreditBoxes[0] = GUIListBox(Controls[0]);
    CreditBoxes[1] = GUIListBox(Controls[3]);
    CreditBoxes[2] = GUIListBox(Controls[4]);

    if ( Credit.length > 28 ) {
        Controls[0].bVisible = false;
        // do a two column layout
        currentList = GUIListBox(Controls[3]);
        initCreditBox( currentList );
        for (i=0; i < Credit.Length/2; i++) {
            currentList.List.Add(Credit[i]);   //13 CR, 10 LF
        }
        currentList = GUIListBox(Controls[4]);
        initCreditBox( currentList );
        for ( i = i; i < Credit.Length; i++) {
            currentList.List.Add(Credit[i]);   //13 CR, 10 LF
        }
    }
    else {
        // one column will do the job
        Controls[3].bVisible = false;
        Controls[4].bVisible = false;
        currentList = GUIListBox(Controls[0]);
        initCreditBox( currentList );
        for (i=0; i<Credit.Length; i++) {
            currentList.List.Add(Credit[i]);   //13 CR, 10 LF
        }
    }

}

/**
 */
function InitCreditBox( GuiListBox CreditBox ) {
    local int i;

    CreditBox.List.OnClick = ListOnClick;
    CreditBox.List.OnMousePressed = ListOnMousePressed;
    CreditBox.MyScrollBar.FocusInstead = none;
    for (i=0;i<CreditBox.MyScrollBar.Controls.Length;i++) {
        CreditBox.MyScrollBar.Controls[i].FocusInstead = None;
    }
    CreditBox.Style        = Controller.GetStyle( "BBNoBackground" );
    CreditBox.List.Style   = Controller.GetStyle( "BBNoBackground" );
    CreditBox.MyList.Style = Controller.GetStyle( "BBNoBackground" );
}

/*****************************************************************
 * BackButtonClicked
 * Back button selected do nothing here!
 *****************************************************************
 */
function bool BackButtonClicked( GUIComponent Sender ) {
    PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
    Controller.CloseMenu( true );
    return true;
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
}*/



//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     Controls(0)=BBListBox'DOTZMenu.DOTZCreditsMenu.CreditList'
     Controls(1)=GUIButton'DOTZMenu.DOTZCreditsMenu.MyBackButton'
     Controls(2)=GUILabel'DOTZMenu.DOTZCreditsMenu.The_title'
     Controls(3)=BBListBox'DOTZMenu.DOTZCreditsMenu.CreditListL'
     Controls(4)=BBListBox'DOTZMenu.DOTZCreditsMenu.CreditListR'
     RenderWeight=0.100000
     __OnKeyEvent__Delegate=DOTZCreditsMenu.HandleKeyEvent
}
