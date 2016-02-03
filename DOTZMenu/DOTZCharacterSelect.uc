// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * XDOTZMainMenu - the main menu for Xbox DOTZ, based on the Warfare
 *              "GUI" package.
 *
 * @author  Tod Baudais (tod.baudais@digitalextremes.com)
 * @version $Revision: #11 $
 * @date    January 19, 2005
 */

class DOTZCharacterSelect extends DOTZMultiPlayerBase;




var localized string PageCaption;
var sound ClickSound;

var Automated GUILabel   CharacterTypeLabel;
var Automated GUILabel   HeadTypeLabel;
var Automated GUILabel   BodyTypeLabel;

var Automated BBComboBox   CharacterTypeValue;
var Automated BBComboBox   HeadTypeValue;
var Automated BBComboBox   BodyTypeValue;

var Automated BBEditBox     PasswordBox;

//var Automated GUIButton    StartButton;

// Used for character (not just weapons!)
var SpinnyWeap          SpinnyDude; // MUST be set to null when you leave the window
var vector              SpinnyDudeOffset;

var string URL;
var bool bPasswordRequired;

var string TeenageMaleMesh;
var array<Material> TeenageMaleHeadTextures;
var array<Material> TeenageMaleBodyTextures;

var string MiddleAgedMaleMesh;
var array<Material> MiddleAgedMaleHeadTextures;
var array<Material> MiddleAgedMaleBodyTextures;

var string MilitaryMaleMesh;
var array<Material> MilitaryMaleHeadTextures;
var array<Material> MilitaryMaleBodyTextures;

var localized string Variant1Head;
var localized string Variant2Head;
var localized string OriginalHead;

var localized string Variant1Body;
var localized string Variant2Body;
var localized string OriginalBody;

var localized string TeenageMaleName;
var localized string MiddleAgedMaleName;
var localized string MilitaryMaleName;

/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent( GUIController MyController, GUIComponent MyOwner )
{
   local Mesh PlayerMesh;
   local int HeadPref, BodyPref, MeshPref;

   Super.Initcomponent(MyController, MyOwner);
   AdvancedPlayerController(PlayerOwner()).bCameraLock = true;
   // init my components...
   SetPageCaption (PageCaption);

    PlayerMesh = Mesh(DynamicLoadObject(TeenageMaleMesh, class'Mesh'));
   CharacterTypeValue.AddItem(TeenageMaleName,PlayerMesh,"XDOTZCharacters.TeenagerHuman");

    PlayerMesh = Mesh(DynamicLoadObject(MiddleAgedMaleMesh, class'Mesh'));
   CharacterTypeValue.AddItem(MiddleAgedMaleName,PlayerMesh,"XDOTZCharacters.MiddleAgedHuman");

     PlayerMesh = Mesh(DynamicLoadObject(MilitaryMaleMesh, class'Mesh'));
   CharacterTypeValue.AddItem(MilitaryMaleName,PlayerMesh,"XDOTZCharacters.MilitaryHuman");

   HeadTypeValue.AddItem(OriginalHead,,"0");
   HeadTypeValue.AddItem(Variant1Head,,"1");
   HeadTypeValue.AddItem(Variant2Head,,"2");

   BodyTypeValue.AddItem(OriginalBody,,"0");
   BodyTypeValue.AddItem(Variant1Body,,"1");
   BodyTypeValue.AddItem(Variant2Body,,"2");


   HeadPref = int(class'Profiler'.static.GetValue("HeadPref"));
   BodyPref = int(class'Profiler'.static.GetValue("BodyPref"));
   MeshPref = int(class'Profiler'.static.GetValue("MeshPref"));

   HeadTypeValue.SetIndex(HeadPref);
   BodyTypeValue.SetIndex(BodyPref);
   CharacterTypeValue.SetIndex(MeshPref);


   SetPageCaption(PageCaption);
   AddBackButton ();
   AddNextButton ();

   //Spawn spinning character actor
    SpinnyDude = PlayerOwner().spawn(class'GUI.SpinnyWeap');
    SpinnyDude.SetRotation(PlayerOwner().Rotation);
    SpinnyDude.SetDrawType(DT_Mesh);
    SpinnyDude.SetDrawScale(0.7);
    SpinnyDude.SpinRate = 5000;
    SpinnyDude.bPlayRandomAnims = false;
    SpinnyDude.bRotate = true;
   UpdateSpinnyDude();

}

/*****************************************************************
 * HandleParameters
 * Collect the URL from the calling page
 *****************************************************************
 */
event HandleParameters( String param1, String param2 ) {
   URL = Param1;
   bPasswordRequired = bool(param2);
}

/*****************************************************************
 * Happens every time the menu is opened, not just the first.
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
    super.Opened(Sender);
}

/*****************************************************************
 * Closed
 *****************************************************************
 */
event Closed(GUIComponent Sender, bool bCancelled) {
   Super.Closed(Sender,bCancelled);
   AdvancedPlayerController(PlayerOwner()).bCameraLock = false;
   OnDraw=None;
   SpinnyDude.destroy();
   SpinnyDude=None;
   Controller.MouseEmulation(false);
}

/*****************************************************************
 *
 *****************************************************************
 */
function HandleCharacterSelection(GUIComponent Sender){
   UpdateSpinnyDude();
}


/*****************************************************************
 * Next Button
 *****************************************************************
 */

function Click_Next ()
{

   local string CustomURL;
   CustomURL = URL $ "?Character=" $ CharacterTypeValue.GetExtra()
                   $ "?Head=" $ HeadTypeValue.GetExtra()
                   $ "?Body=" $ BodyTypeValue.GetExtra()
                   $ "?XGAMERTAG=" $ EncodeStringURL(DOTZPlayerControllerBase(PlayerOwner()).GetCurrentProfileName());

    Log ("URL: " $ CustomURL);

    class'DOTZMPFailed'.default.LastURL = CustomURL;

   //if (bPasswordRequired == true){
   //   Controller.OpenMenu("DOTZMenu.DOTZGetPassword", CustomURL);
   //} else {
      // Display loading screen

    class'Profiler'.static.SetValue("HeadPref", string(HeadTypeValue.GetIndex()));
    class'Profiler'.static.SetValue("BodyPref", string(BodyTypeValue.GetIndex()));
    class'Profiler'.static.SetValue("MeshPref", string(CharacterTypeValue.GetIndex()));


      PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
      PlayerOwner().ClientTravel( CustomURL ,TRAVEL_Absolute, false);
      BBGUIController(Controller).SwitchMenu("DOTZMenu.DOTZLoadingMenu");
   //}
}

/*****************************************************************
 * A Button pressed
 *
 *****************************************************************
 */

/*function DoButtonA ()
{
    local string CustomURL;
   CustomURL = URL $ "?Character=" $ CharacterTypeValue.GetExtra()
                   $ "?Head=" $ HeadTypeValue.GetExtra()
                   $ "?Body=" $ BodyTypeValue.GetExtra();

   // Display loading screen
   Controller.OpenMenu("DOTZMenu.XDOTZLoadingMenu");
   PlayerOwner().Pawn.PlayOwnedSound(ClickSound,SLOT_Interface,1.0);
   PlayerOwner().ClientTravel( CustomURL ,TRAVEL_Absolute, false);
}*/

/*****************************************************************
 * InternalDraw
 *****************************************************************
 */
function bool InternalDraw(Canvas canvas)
{
    local vector CamPos, X, Y, Z;
    local rotator CamRot;

   if (SpinnyDude != none){
      canvas.GetCameraLocation(CamPos, CamRot);
    GetAxes(CamRot, X, Y, Z);
    SpinnyDude.SetLocation(CamPos + (SpinnyDudeOffset.X * X) + (SpinnyDudeOffset.Y * Y) + (SpinnyDudeOffset.Z * Z));
    canvas.DrawActor(SpinnyDude, false, true, 90.0);
   }
    return false;
}

/*****************************************************************
 *
 *****************************************************************
*/
function UpdateSpinnyDude()
{
   local Mesh PlayerMesh;
   local int HeadIndex, BodyIndex;
   //PlayerMesh = Mesh(DynamicLoadObject(string(CharacterTypeValue.GetObject()), class'Mesh'));
   PlayerMesh = mesh(CharacterTypeValue.GetObject());
   if(PlayerMesh == none || SpinnyDude == None){ return; }
   SpinnyDude.LinkMesh(PlayerMesh);

   HeadIndex = int(HeadTypeValue.GetExtra());
   BodyIndex = int(BodyTypeValue.GetExtra());

   if (CharacterTypeValue == none) return;

   if(CharacterTypeValue.GetIndex() == 0){ //Teenager
       SpinnyDude.Skins[0] = TeenageMaleBodyTextures[BodyIndex];
       SpinnyDude.Skins[1] = TeenageMaleHeadTextures[HeadIndex];
   } else if(CharacterTypeValue.GetIndex() == 1){ //MiddleAged
       SpinnyDude.Skins[0] = MiddleAgedMaleBodyTextures[BodyIndex];
       SpinnyDude.Skins[1] = MiddleAgedMaleHeadTextures[HeadIndex];
   } else if(CharacterTypeValue.GetIndex() == 2){ //MiddleAged
       SpinnyDude.Skins[0] = MilitaryMaleBodyTextures[BodyIndex];
       SpinnyDude.Skins[1] = MilitaryMaleHeadTextures[HeadIndex];
   }


    SpinnyDude.LoopAnim( 'Bored', 1);
}


/*****************************************************************
 * NotifyLevelChange
 *
 *****************************************************************
 */
event NotifyLevelChange() {
    Controller.CloseMenu(true);
}

//===========================================================================
// defaultproperties
//===========================================================================

defaultproperties
{
     PageCaption="Customize Character"
     ClickSound=Sound'DOTZXInterface.Select'
     Begin Object Class=GUILabel Name=CharacterTypeLabel_lbl
         Caption="Character:"
         TextFont="PlainGuiFont"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.250000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="CharacterTypeLabel_lbl"
     End Object
     CharacterTypeLabel=GUILabel'DOTZMenu.DOTZCharacterSelect.CharacterTypeLabel_lbl'
     Begin Object Class=GUILabel Name=HeadTypeLabel_lbl
         Caption="Skin: "
         TextFont="PlainGuiFont"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.320000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="HeadTypeLabel_lbl"
     End Object
     HeadTypeLabel=GUILabel'DOTZMenu.DOTZCharacterSelect.HeadTypeLabel_lbl'
     Begin Object Class=GUILabel Name=BodyTypeLabel_lbl
         Caption="Clothing: "
         TextFont="PlainGuiFont"
         bBoundToParent=True
         bScaleToParent=True
         WinTop=0.390000
         WinLeft=0.150000
         WinWidth=0.400000
         WinHeight=0.100000
         Name="BodyTypeLabel_lbl"
     End Object
     BodyTypeLabel=GUILabel'DOTZMenu.DOTZCharacterSelect.BodyTypeLabel_lbl'
     Begin Object Class=BBComboBox Name=CharacterTypeValue_lbl
         StyleName="BBRoundButton"
         bAcceptsInput=True
         WinTop=0.270000
         WinLeft=0.450000
         WinWidth=0.400000
         __OnChange__Delegate=DOTZCharacterSelect.HandleCharacterSelection
         Name="CharacterTypeValue_lbl"
     End Object
     CharacterTypeValue=BBComboBox'DOTZMenu.DOTZCharacterSelect.CharacterTypeValue_lbl'
     Begin Object Class=BBComboBox Name=HeadTypeValue_lbl
         StyleName="BBRoundButton"
         bAcceptsInput=True
         WinTop=0.340000
         WinLeft=0.450000
         WinWidth=0.400000
         __OnChange__Delegate=DOTZCharacterSelect.HandleCharacterSelection
         Name="HeadTypeValue_lbl"
     End Object
     HeadTypeValue=BBComboBox'DOTZMenu.DOTZCharacterSelect.HeadTypeValue_lbl'
     Begin Object Class=BBComboBox Name=BodyTypeValue_lbl
         StyleName="BBRoundButton"
         bAcceptsInput=True
         WinTop=0.410000
         WinLeft=0.450000
         WinWidth=0.400000
         __OnChange__Delegate=DOTZCharacterSelect.HandleCharacterSelection
         Name="BodyTypeValue_lbl"
     End Object
     BodyTypeValue=BBComboBox'DOTZMenu.DOTZCharacterSelect.BodyTypeValue_lbl'
     SpinnyDudeOffset=(X=170.000000,Y=-50.000000,Z=-30.000000)
     TeenageMaleMesh="DOTZAHumans.JohnAnderson"
     TeenageMaleHeadTextures(0)=Texture'DOTZTHumans.JohnAnderson.JohnnyAndersonHeadA'
     TeenageMaleHeadTextures(1)=Texture'DOTZTHumans.JohnAnderson.JohnnyAndersonHeadC'
     TeenageMaleHeadTextures(2)=Texture'DOTZTHumans.JohnAnderson.JohnnyAndersonHeadB'
     TeenageMaleBodyTextures(0)=Texture'DOTZTHumans.JohnAnderson.JohnnyAndersonBodyA'
     TeenageMaleBodyTextures(1)=Texture'DOTZTHumans.JohnAnderson.JohnnyAndersonBodyB'
     TeenageMaleBodyTextures(2)=Texture'DOTZTHumans.JohnAnderson.JohnnyAndersonBodyC'
     MiddleAgedMaleMesh="DOTZAHumans.HogarthMorten"
     MiddleAgedMaleHeadTextures(0)=Texture'DOTZTHumans.Hogarth.HogarthMortenHade01'
     MiddleAgedMaleHeadTextures(1)=Texture'DOTZTHumans.Hogarth.HogarthMortenHade02'
     MiddleAgedMaleHeadTextures(2)=Texture'DOTZTHumans.Hogarth.HogarthMortenHade03'
     MiddleAgedMaleBodyTextures(0)=Texture'DOTZTHumans.Hogarth.HogarthMortenBody01'
     MiddleAgedMaleBodyTextures(1)=Texture'DOTZTHumans.Hogarth.HogarthMortenBody02'
     MiddleAgedMaleBodyTextures(2)=Texture'DOTZTHumans.Hogarth.HogarthMortenBody03'
     MilitaryMaleMesh="DOTZAHumans.SgtDanielTravis"
     MilitaryMaleHeadTextures(0)=Texture'DOTZTHumans.SgtDanielTravis.SgtTravisHade01'
     MilitaryMaleHeadTextures(1)=Texture'DOTZTHumans.SgtDanielTravis.SgtTravisHade02'
     MilitaryMaleHeadTextures(2)=Texture'DOTZTHumans.SgtDanielTravis.SgtTravisHade03'
     MilitaryMaleBodyTextures(0)=Texture'DOTZTHumans.SgtDanielTravis.SgtTravisCamoBrn'
     MilitaryMaleBodyTextures(1)=Texture'DOTZTHumans.SgtDanielTravis.SgtTravisCamoGrn'
     MilitaryMaleBodyTextures(2)=Texture'DOTZTHumans.SgtDanielTravis.SgtTravisCamoGry'
     Variant1Head="Darker"
     Variant2Head="Beard"
     OriginalHead="Lighter"
     Variant1Body="Variation 1"
     Variant2Body="Variation 2"
     OriginalBody="Normal"
     TeenageMaleName="Student"
     MiddleAgedMaleName="Janitor"
     MilitaryMaleName="Military"
     Background=Texture'DOTZTInterface.Menu.SettingsBackground'
     __OnDraw__Delegate=DOTZCharacterSelect.InternalDraw
     __OnKeyEvent__Delegate=DOTZCharacterSelect.HandleKeyEvent
}
