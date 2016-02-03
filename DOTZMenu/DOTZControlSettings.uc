// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #4 $
 * @date    Sept 2003
 */
class DOTZControlSettings extends DOTZSettingsPanel;


struct KeyBinding {
   var bool             bIsSectionLabel;
   var localized string KeyLabel;
   var string           Alias;
   var array<int>              Binds;
   var array<string>           BindKeyNames;
   var array<string>    BindLocalizedKeyNames;
};

//controls
var GUIListBox MyListBox;
var Automated  moCheckBox InvertMouseBox;
var sound ClickSound;
var Automated GUIButton ResetButton;

const DefaultBindings=54;            // # of default bindings there are
var array<KeyBinding> Bindings;     // Holds the array of key bindings
var localized string  Labels[54];   // fixed-length array for
                                    // localization.
                                    // accesses clamped to [0,74]

var bool bSetNextKeyPress;
var int  NewIndex, NewSubIndex;
var GUIStyles SelStyle;
var int row, HackIndex;             // Hacky Hacky
var localized string Header,Footer;
var float SectionLabelMargin;
var bool bInvertMouse;
var bool bListInitialised;

var Automated GUILabel    SensLabel;
var Automated GuiSlider   SensSlider;



/*****************************************************************
 * InitComponent
 *****************************************************************
 */
function InitComponent(GUIController MyController, GUIComponent MyOwner){

   Super.Initcomponent(MyController, MyOwner);
   MyListBox = GUIListBox(Controls[0]);
   MyListBox.List.OnDrawItem = DrawBinding;
   MyListBox.List.SelectedImage=None;
   MyListbox.List.OnClick=GetNewKey;
   MyListBox.List.OnChange=ListChange;
   MyListBox.List.OnKeyEvent = ListOnKeyEvent;
   MyListBox.List.bHotTrack=true;
   MyListBox.List.OnClickSound=CS_None;
   MyListBox.List.OnAdjustTop = MyOnAdjustTop;

   Controls[9].OnClick=OnReset;

   SelStyle = Controller.GetStyle("BBTextButton");
   moCheckBox(Controls[5]).Checked(class'PlayerInput'.default.bInvertMouse);

   SensSlider = GuiSlider(Controls[8]);
   SensSlider.SetValue(class'PlayerInput'.default.MouseSensitivity);

   MyListBox.SetVisibility(false);
   InvertMouseBox.SetVisibility(false);
   ResetButton.SetVisibility(false);

}


/*****************************************************************
 * ShowPanel
 *****************************************************************
 */
function ShowPanel(bool bShow){

   Super.ShowPanel(bShow);

   MyListBox.SetVisibility(bShow);
   InvertMouseBox.SetVisibility(bShow);
   ResetButton.SetVisibility(bShow);

   if( bShow ) {
      if(!bListInitialised) {
         InitBindings();
         MyListBox.List.Index=1;
         HackIndex=1;
         bListInitialised = true;
      }
   }

}


/*****************************************************************
 * Weight
 *****************************************************************
 */
function int Weight(int i){

   if ( (i==0x01) || (i==0x02) ){
      return 100;
   }
   if ( (i>=0x30) && (i<=0x5A) ){
      return 50;
   }
   if (i==0x20){
      return 45;
   }
   if (i==0x04){
      return 40;
   }
   if (i==0xEC || i==0xED){
      return 35;
   }
   if (i>=0x21 && i<=0x28){
      return 30;
   }
   if (i>=0x60 && i<=0x6F){
      return 30;
   }

   return 25;
}


/*****************************************************************
 * Swap
 *****************************************************************
 */
function Swap(int index, int a, int b){

   local int TempInt;
   local string TempStrA, TempStrB;

   TempInt  = Bindings[Index].Binds[a];
   TempStrA = Bindings[Index].BindKeyNames[a];
   TempStrB = Bindings[Index].BindLocalizedKeyNames[a];

   Bindings[Index].Binds[a] = Bindings[Index].Binds[B];
   Bindings[Index].BindKeyNames[a] = Bindings[Index].BindKeyNames[b];
   Bindings[Index].BindLocalizedKeyNames[a] = Bindings[Index].BindLocalizedKeyNames[b];
   Bindings[Index].Binds[b] = TempInt;
   Bindings[Index].BindKeyNames[b] = TempStrA;
   Bindings[Index].BindLocalizedKeyNames[b] = TempStrB;

}


/*****************************************************************
 * AddToBindings
 *****************************************************************
 */
function AddToBindings(string Alias, string KeyLabel, bool bSectionLabel){

   local int At;

   At = Bindings.Length;
   Bindings.Length = Bindings.Length + 1;
   Bindings[At].bIsSectionLabel = bSectionLabel;
   Bindings[At].KeyLabel = KeyLabel;
   Bindings[At].Alias = Alias;
   MyListBox.List.Add(Bindings[At].KeyLabel);

}

/*****************************************************************
 * InitBindings
 *****************************************************************
 */
function InitBindings(){

   local int i,j,k,index;
   local string KeyName, Alias, LocalizedKeyName;
   local string UserKeyClass;
   local class<GUIUserKeyBinding> Key;

   local string temp;
   local KeyBinding tempBinding;

   // Clear them all.
   //===========================
   for (i=0;i<Bindings.Length;i++){
         if (Bindings[i].Binds.Length>0)
            Bindings[i].Binds.Remove(0,Bindings[i].Binds.Length);

         if (Bindings[i].BindKeyNames.Length>0)
            Bindings[i].BindKeyNames.Remove(0,Bindings[i].BindKeyNames.Length);

         if (Bindings[i].BindLocalizedKeyNames.Length>0)
            Bindings[i].BindLocalizedKeyNames.
                        Remove(0,Bindings[i].BindLocalizedKeyNames.Length);

         // Set the Localized name
         if (i<DefaultBindings)
            Bindings[i].KeyLabel = Labels[i];

         MyListBox.List.Add(Bindings[i].KeyLabel);
  }

   // Load Bindings from INT
   //===========================
   j = 0;
   while (UserKeyClass!=""){
      Key = class<GUIUserKeyBinding>(DynamicLoadObject(UserKeyClass,class'Class'));
      if (Key!=None){
         for (i=0;i<Key.Default.KeyData.Length;i++)
            AddToBindings(Key.Default.KeyData[i].Alias,
                          Key.Default.KeyData[i].KeyLabel,
                          Key.Default.KeyData[i].bIsSection);
         }
      }


   for (i=0;i<255;i++){
      KeyName = PlayerOwner().ConsoleCommand("KEYNAME"@i);
      LocalizedKeyName = PlayerOwner().ConsoleCommand("LOCALIZEDKEYNAME"@i);
      if (KeyName!=""){
         Alias = PlayerOwner().ConsoleCommand("KEYBINDING"@KeyName);
         if (Alias!=""){
            for (j=0;j<Bindings.Length;j++){

               temp = KeyName;
               temp = Alias;
               tempBinding = Bindings[j];

               if (Bindings[j].Alias ~= Alias){
                  index = Bindings[j].Binds.Length;

                  Bindings[j].Binds[index] = i;
                  Bindings[j].BindKeyNames[Index] = KeyName;
                  Bindings[j].BindLocalizedKeyNames[Index] = LocalizedKeyName;

                  for (k=0;k<index;k++){
                     if ( Weight(Bindings[j].Binds[k]) < Weight(Bindings[j].Binds[Index]) ){
                        //                        Swap(j,k,Index);
                        break;
                     }
                  }
               }
            }
         }
      }
   }

}


/*****************************************************************
 * GetCurrentKeyBind
 *****************************************************************
 */
function string GetCurrentKeyBind(int index, int bind){

   if ( index >= bindings.Length || index < 0)
      return "";

   if (Bindings[Index].bIsSectionLabel)
      return "";

   if (Index==NewIndex && Bind==NewSubIndex)
      return "???";

   if (Bind>=Bindings[Index].Binds.Length)
      return "";

 return Bindings[Index].BindLocalizedKeyNames[Bind];
}


/*****************************************************************
 * DrawBinding
 *****************************************************************
 */
function DrawBinding(Canvas Canvas, int Item, float X, float Y, float W, float H, bool bSelected){

   local int x1,w1;
   local bool InBindArea;

   if (Item>=Bindings.Length || Item<0){  return; }
   if (Controller.MouseX >= controls[2].Bounds[0] ){  InBindArea=true; }

   if ( (Controller.HasMouseMoved()) && (!bSetNextKeyPress) ){
      if (InBindArea) {
         if ( ( Controller.MouseX >= Controls[2].Bounds[0] ) &&
              ( Controller.MouseX <= Controls[2].Bounds[2] ) ){
                  Row = 0;
         }
         InBindArea=true;
      }

      if ( InBindArea && (MyListBox.List.Index != HackIndex) &&
           (MyListBox.List.Index<Bindings.Length) && (MyListBox.List.Index >= 0) &&
           (Bindings[MyListBox.List.Index].bIsSectionLabel) ){
         MyListBox.List.SetIndex(HackIndex);
      }
   }

   if(InBindArea){
      if ( (bSetNextKeyPress) && (MyListBox.List.Index!=HackIndex) ){
         MyListBox.List.SetIndex(HackIndex);
      }
      if ( HackIndex !=MyListBox.List.Index){
            UpdateHint(MyListBox.List.Index);
      }
      HackIndex = MyListBox.List.Index;
   }


   if ( Bindings[Item].bIsSectionLabel ){
         Canvas.CurX = Controls[1].ActualLeft ();
         Canvas.CurY = Y;
         Canvas.SetDrawColor(0,128,0,200);
         Canvas.DrawTile (Controller.DefaultPens[0],
                          Controls[1].ActualWidth () +
                          Controls[2].ActualWidth (),H, 0, 0, 1, 1);

         MyListBox.Style.DrawText(Canvas, MSAT_Pressed,
                   Controls[1].ClientBounds[0]+SectionLabelMargin,
                   Y, Controls[1].ClientBounds[2]-Controls[1].ClientBounds[0] ,
                   H, TXTA_Left, Bindings[Item].KeyLabel);
   } else {
         MyListBox.Style.DrawText(Canvas,MenuState, Controls[1].ActualLeft(),
                             Y,Controls[1].ActualWidth(),
                             H, TXTA_Center, Bindings[Item].KeyLabel);
   }


   MyListBox.Style.DrawText(Canvas,MenuState, Controls[2].ActualLeft(), Y,
                            Controls[2].ActualWidth(), H,
                            TXTA_Center, GetCurrentKeyBind(Item,0));

   if ( (bSelected) && (!Bindings[item].bIsSectionLabel) ){
      if (Row==0){
         x1 = Controls[2].ActualLeft();
         w1 = Controls[2].ActualWidth();
      }

      if (!bSetNextKeyPress){
         SelStyle.Draw(Canvas,MSAT_Watched, x1, y, w1, h );
      } else {
         SelStyle.Draw(Canvas,MSAT_Pressed, x1, y, w1, h );
      }
      UpdateHint(Item);
   }

}



/*****************************************************************
 * ListOnKeyEvent
 *****************************************************************
 */
function bool ListOnKeyEvent(out byte Key, out byte State, float delta){

   local bool result;
   local int oldIndex;

   if (Key==0x0D && State==3) {
         GetNewKey(None);
         return true;
   }

   //backspace
   if ( (Key==0x08) && (State==3) ) {
      // Clear Over
      if ( ( Controller.MouseX >= Controls[2].Bounds[0] ) &&
           ( Controller.MouseX <= Controls[2].Bounds[2] ) ){
         RemoveExistingKey(MyListBox.List.Index,0);
      }
      UpdateHint(MyListBox.List.Index);
      return true;
   }


   // -- WARNING.. really big hack here
   if ( (State==1) && (Key==0x25 || Key==0x64 || Key==0x27 || Key ==0x66) ) {
      if (row==0)
         row = 1;
      else
         row = 0;

      UpdateHint(MyListBox.List.Index);
      return true;
   }

   OldIndex = MyListBox.List.Index;
   result = MyListBox.List.InternalOnKeyEvent(Key,State,delta);
   if (MyListBox.List.Index!=OldIndex){

      if (Bindings[MyListBox.List.Index].bIsSectionLabel){
         if (MyListBox.List.Index<OldIndex)
            SearchUp(OldIndex);
         else
            SearchDown(OldIndex);
      }
   }
   UpdateHint(MyListBox.List.Index);

   return true;
}


/*****************************************************************
 * SearchUp
 *****************************************************************
 */
function SearchUp(int OldIndex){

   local int cindex;

   cindex = MyListBox.List.Index;
   while (cindex>0){
      if (!Bindings[cindex].bIsSectionLabel){
         MyListBox.List.SetIndex(cIndex);
         return;
      }
      cindex--;
   }
   MyListBox.List.SetIndex(OldIndex);


}

/*****************************************************************
 * SearchDown
 *****************************************************************
 */
function SearchDown(int OldIndex){

   local int cindex;

   cindex = MyListBox.List.Index;
   while (cindex<MyListBox.List.ItemCount-1){
      if (!Bindings[cindex].bIsSectionLabel){
         MyListBox.List.SetIndex(cIndex);
         return;
      }
      cindex++;
   }
   MyListBox.List.SetIndex(OldIndex);

}


/*****************************************************************
 * RemoveExistingKey
 *****************************************************************
 */
function RemoveExistingKey(int Index, int SubIndex){

   if ( (Index>=Bindings.Length) || (SubIndex>=Bindings[Index].Binds.Length) ||
        (Bindings[Index].Binds[SubIndex] <0) ){
      return;
   }

   // Clear the bind
   PlayerOwner().
      ConsoleCommand("SET Input"@Bindings[Index].BindKeyNames[SubIndex]);

   // Clear the entry
   Bindings[Index].Binds.Remove(SubIndex,1);
   Bindings[Index].BindKeyNames.Remove(SubIndex,1);
   Bindings[Index].BindLocalizedKeyNames.Remove(SubIndex,1);

}


/*****************************************************************
 * RemoveAllOccurances
 *****************************************************************
 */

function RemoveAllOccurance(byte NewKey){

   local int i,j;

   for (i=0;i<Bindings.Length;i++){
      for (j=Bindings[i].Binds.Length-1;j>=0;j--){
         if (Bindings[i].Binds[j]==NewKey){
            RemoveExistingKey(i,j);
         }
      }
   }
}


/*****************************************************************
 * UpdateHint
 *****************************************************************
 */
function UpdateHint(int index){

   local int i;
   local string t;

   if (Index<0 || Index>=Bindings.Length){
      MyListBox.List.Hint ="";
      Controller.ActivePage.ChangeHint(MyListBox.List.Hint);
      return;
   } else {
      t = "";
      for (i=0;i<Bindings[Index].Binds.Length;i++){
         if (t=="")
            t = ""$GetCurrentKeyBind(Index,i);
      }
   }
   MyListBox.List.Hint =Header$t$Footer;
   Controller.ActivePage.ChangeHint(MyListBox.List.Hint);

}


/*****************************************************************
 * AddNewKey
 *****************************************************************
 */
function AddNewKey(int Index, int SubIndex, byte NewKey){
   local int i;

   //local KeyBinding Where;
   if (Index >= Bindings.Length){
      return;
   }

   if ( (SubIndex<Bindings[Index].Binds.Length) &&
        (Bindings[Index].Binds[SubIndex] == NewKey) ){
      return;
   }

   //remove the existing binding so that the new one shows up
   for (i=0;i < Bindings[Index].Binds.length; i++){
         RemoveAllOccurance(Bindings[Index].Binds[i]);
   }
   RemoveAllOccurance(NewKey);

   if (SubIndex>=Bindings[Index].Binds.Length) {
      Bindings[Index].Binds.Length = Bindings[Index].Binds.Length + 1;
      Bindings[Index].BindKeyNames.Length = Bindings[Index].BindKeyNames.Length + 1;
      Bindings[Index].BindLocalizedKeyNames.Length = Bindings[Index].BindLocalizedKeyNames.Length + 1;
      SubIndex = Bindings[Index].Binds.Length-1;
   }
   Bindings[Index].Binds[SubIndex] = NewKey;
   Bindings[Index].BindKeyNames[SubIndex] = PlayerOwner().ConsoleCommand("KeyName"@NewKey);
   Bindings[Index].BindLocalizedKeyNames[SubIndex] = PlayerOwner().ConsoleCommand("LOCALIZEDKEYNAME"@NewKey);
   PlayerOwner().ConsoleCommand("SET Input"@Bindings[Index].BindKeyNames[SubIndex]@Bindings[Index].Alias);
   UpdateHint(Index);

}

/*****************************************************************
 * GetNewKey
 *****************************************************************
 */
function bool GetNewKey(GUIComponent Sender){

   local int SubIndex;

   if ( ( Controller.MouseX >= Controls[2].Bounds[0] ) && ( Controller.MouseX <= Controls[2].Bounds[2] ) ){
      SubIndex = 0;
   } else {
      return true;
   }

   NewIndex = MyListBox.List.Index;
   NewSubIndex = SubIndex;
   bSetNextKeyPress=true;
   Controller.OnNeedRawKeyPress = RawKey;
   Controller.Master.bRequireRawJoystick=true;

   PlayerOwner().ClientPlaySound(Controller.EditSound);
   PlayerOwner().ConsoleCommand("toggleime 0");

 return true;
}


/*****************************************************************
 * RawKey
 *****************************************************************
 */
function bool RawKey(byte NewKey){

   if (NewKey!=0x1B){
      AddNewKey(NewIndex, NewSubIndex, NewKey);
   }

   NewIndex = -1;
   NewSubIndex = -1;
   bSetNextKeyPress=false;
   Controller.OnNeedRawKeyPress = none;
   Controller.Master.bRequireRawJoystick=false;
   PlayerOwner().ClientPlaySound(Controller.ClickSound);

 return true;
}


/*****************************************************************
 * ListChange
 *****************************************************************
 */
function ListChange(GUIComponent Sender){
   UpdateHint(MyListBox.List.Index);
}


/*****************************************************************
 * MyOnAdjustTop
 *****************************************************************
 */

function MyOnAdjustTop(GUIComponent Sender){

   if( MyListBox.List.Index < MyListBox.List.Top ){
      MyListBox.List.SetIndex( MyListBox.List.Top );
   } else if( MyListBox.List.Index >= MyListBox.List.Top + MyListBox.List.ItemsPerPage ){
      MyListBox.List.SetIndex( MyListBox.List.Top +
                               MyListBox.List.ItemsPerPage );
   }
}

/****************************************************************
 * SliderChange
 ****************************************************************
 */
function SensSliderChange(GUICOmponent Sender){

  Log ("Sens Slider Change:" @ Sender);

  //class'PlayerInput'.default.MouseSensitivity = GuiSlider(Sender).Value;
  //class'PlayerInput'.static.StaticSaveConfig();

  PlayerOwner().
     ConsoleCommand( "SetSensitivity" @ GuiSlider(Sender).Value);

  Class.static.StaticSaveConfig();

}

/*****************************************************************
 * ResetClicked
 *****************************************************************
 */

function bool ResetClicked(GUIComponent Sender)
{
   Controller.ResetKeyboard();
   InitBindings();
   return true;
}


function OnInvertMouse(GUIComponent Sender){
   local bool bIsChecked;

   bIsChecked = moCheckBox(Sender).IsChecked();
   AdvancedPlayerController(PlayerOwner()).InvertLook(bIsChecked);
   //PlayerOwner().
     // ConsoleCommand("set PlayerInput bInvertMouse " $ bIsChecked);
   //class'PlayerInput'.default.bInvertMouse = bIsChecked;
   //class'PlayerInput'.static.StaticSaveConfig();
}

function bool OnReset(GUIComponent Sender)
{
    local int i;

    RemoveAllOccurance(66);   //B
    RemoveAllOccurance(67);   //C
    RemoveAllOccurance(68);   // D
    RemoveAllOccurance(69);   // E
    RemoveAllOccurance(70);   //F
    RemoveAllOccurance(71);   //G
    RemoveAllOccurance(72);   //H
    RemoveAllOccurance(73);   //I
    RemoveAllOccurance(74);   //J
    RemoveAllOccurance(75);   //K
    RemoveAllOccurance(76);   //L
    RemoveAllOccurance(77);   //M
    RemoveAllOccurance(78);   //N
    RemoveAllOccurance(79);   //O
    RemoveAllOccurance(80);   //P
    RemoveAllOccurance(81);   //Q
    RemoveAllOccurance(82);   //R
    RemoveAllOccurance(83);   //S
    RemoveAllOccurance(84);   //T
    RemoveAllOccurance(85);   //U
    RemoveAllOccurance(86);   //V
    RemoveAllOccurance(87);   //W
    RemoveAllOccurance(88);   // X
    RemoveAllOccurance(89);   // Y
    RemoveAllOccurance(90);   // Z

    AddNewKey(0,0,87);   //W
    AddNewKey(1,0,83);   //S
    AddNewKey(2,0,65);   //A
    AddNewKey(3,0,68);   //D
    AddNewKey(4,0,69);   //E
    AddNewKey(5,0,17);   //CTRL
    AddNewKey(6,0,32);   //SPACE
    AddNewKey(7,0,16);   //SHIFT
    AddNewKey(8,0,37);   //LEFT
    AddNewKey(9,0,39);   //RIGHT
    AddNewKey(10,0,33);   //PAGE UP
    AddNewKey(11,0,34);   //PAGE DOWN
    AddNewKey(12,0,1);    //LEFT MOUSE
    AddNewKey(13,0,2);    //RIGHT MOUSE
    AddNewKey(14,0,82);   //R
    AddNewKey(15,0,236);  //MOUSE WHEEL UP
    AddNewKey(16,0,237);  //MOUSE WHEEL DOWN
    AddNewKey(17,0,116);  //F5
    AddNewKey(18,0,117);  //F6
    AddNewKey(19,0,9);    //TAB
    AddNewKey(20,0,84);   //T




    Class.static.StaticSaveConfig();
    return true;

/*
struct KeyBinding {
   var bool             bIsSectionLabel;
   var localized string KeyLabel;
   var string           Alias;
   var array<int>              Binds;
   var array<string>           BindKeyNames;
   var array<string>    BindLocalizedKeyNames;
};

    AddToBinding(default.Binding

    AddToBindings("Key.Default.KeyData[i].Alias,
                  Key.Default.KeyData[i].KeyLabel,
                  Key.Default.KeyData[i].bIsSection);
                  */
}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     ClickSound=Sound'DOTZXInterface.Select'
     Bindings(0)=(KeyLabel="Forward",Alias="MoveForward")
     Bindings(1)=(KeyLabel="Backward",Alias="MoveBackward")
     Bindings(2)=(KeyLabel="Strafe Left",Alias="StrafeLeft")
     Bindings(3)=(KeyLabel="Strafe Right",Alias="StrafeRight")
     Bindings(4)=(KeyLabel="Action",Alias="Action")
     Bindings(5)=(KeyLabel="Crouch",Alias="Duck")
     Bindings(6)=(KeyLabel="Jump",Alias="Jump")
     Bindings(7)=(KeyLabel="Run",Alias="Walking")
     Bindings(8)=(KeyLabel="Turn Left",Alias="TurnLeft")
     Bindings(9)=(KeyLabel="Turn Right",Alias="TurnRight")
     Bindings(10)=(KeyLabel="Look Up",Alias="LookUp")
     Bindings(11)=(KeyLabel="Look Down",Alias="LookDown")
     Bindings(12)=(KeyLabel="Fire",Alias="Fire")
     Bindings(13)=(KeyLabel="Aim",Alias="AltFire")
     Bindings(14)=(KeyLabel="Reload",Alias="ForceReload")
     Bindings(15)=(KeyLabel="NextWeapon",Alias="NextWeapon")
     Bindings(16)=(KeyLabel="PrevWeapon",Alias="PrevWeapon")
     Bindings(17)=(KeyLabel="QuickSave",Alias="QuickSave")
     Bindings(18)=(KeyLabel="QuickLoad",Alias="QuickLoad")
     Bindings(19)=(KeyLabel="Display Objectives",Alias="ToggleObjectivesDisplay")
     Bindings(20)=(KeyLabel="Talk",Alias="ReadyToSay")
     Labels(0)="Forward"
     Labels(1)="Backward"
     Labels(2)="Strafe left"
     Labels(3)="Strafe right"
     Labels(4)="Action"
     Labels(5)="Crouch"
     Labels(6)="Jump"
     Labels(7)="Sprint"
     Labels(8)="Turn Left"
     Labels(9)="Turn Right"
     Labels(10)="Look Up"
     Labels(11)="Look Down"
     Labels(12)="Fire"
     Labels(13)="Zoom/Alt. Attack"
     Labels(14)="Reload"
     Labels(15)="Next Weapon"
     Labels(16)="Previous Weapon"
     Labels(17)="Quick Save"
     Labels(18)="Quick Load"
     Labels(19)="Objectives/Score"
     Labels(20)="Talk"
     NewIndex=-1
     Header="["
     Footer="] Perform this action "
     SectionLabelMargin=20.000000
     Controls(0)=BBListBox'DOTZMenu.DOTZControlSettings.KeyConfigKeyList'
     Controls(1)=GUIImage'DOTZMenu.DOTZControlSettings.KeyConfigBK1'
     Controls(2)=GUIImage'DOTZMenu.DOTZControlSettings.KeyConfigBK2'
     Controls(3)=GUILabel'DOTZMenu.DOTZControlSettings.KeyConfigAliasLabel'
     Controls(4)=GUILabel'DOTZMenu.DOTZControlSettings.KeyConfigAliasLabel2'
     Controls(5)=moCheckBox'DOTZMenu.DOTZControlSettings.InvertMouse_button'
     Controls(6)=GUILabel'DOTZMenu.DOTZControlSettings.invertLabel_l'
     Controls(7)=GUILabel'DOTZMenu.DOTZControlSettings.sens_label'
     Controls(8)=BBGuiSlider'DOTZMenu.DOTZControlSettings.sens_slider'
     Controls(9)=GUIButton'DOTZMenu.DOTZControlSettings.Map_Add'
     WinHeight=0.740000
}
