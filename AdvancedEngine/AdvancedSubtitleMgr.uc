// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class AdvancedSubtitleMgr extends AdvancedActor
   implements( HudDrawable );

var private GameSpecificLevelInfo theInfo;
var int CurrentSubtitleSeq;
var int CurrentSubtitle;
var string CurrentSubtitleText;
var float LastSubtitleTime;

var string Line1;
var string Line2;
//var bool bSubtitlesOn;

const MAX_LENGTH = 35;
const SUBTITLE = 2234;
const HUD_INIT_TIMER = 18293;

var bool RegisteredWithHud;


/*****************************************************************
 * BeginPlay
 *****************************************************************
 */
function PreBeginPlay(){
   local int i;

   super.PreBeginPlay();

   if (level.GameSpecificLevelInfo == none){
      return;
   }
   theInfo = GameSpecificLevelInfo(Level.GameSpecificLevelInfo);
   for ( i = 0; i < theInfo.TheSubtitles.length; ++i ){
      BindEvent(TheInfo.TheSubtitles[i].EventName);
   }
   SetMultiTimer( HUD_INIT_TIMER, 0.01, false );
}



/*****************************************************************
 * BindEvent
 * Add the specified event to the event bindings table.  Uses the
 * handler to store the event name, since TriggerEx doesn't provide
 * this itself.
 *****************************************************************
*/
function BindEvent( Name event ) {
   local EventHandlerMapping newBinding;
   newBinding.EventName = event;
   newBinding.HandledBy = event;
   EventBindings[EventBindings.length] = newBinding;
}


/*****************************************************************
 * Pass events through to the objectives...
 *****************************************************************
*/
function TriggerEx( Actor sender, Pawn instigator, Name handler ) {

   local int i;

   for ( i = 0; i < theInfo.TheSubtitles.length; ++i ){
      if (theInfo.TheSubtitles[i].EventName == handler){
         SetSubtitle(i,0);
         break;
      }
   }
}


/*****************************************************************
 * SetSubtitle
 *****************************************************************
 */
function SetSubtitle(int Seq, int SubtitleIndex){
   local float RelativeTime;
   local float AbsTime;
   local int i;

//   bSubtitlesOn = true;
  // Log(self $ "SetSubtitles");

   CurrentSubtitleSeq = Seq;
   CurrentSubtitle = SubtitleIndex;
   CurrentSubtitleText = theInfo.TheSubtitles[CurrentSubtitleSeq].GetText(CurrentSubtitle);
   if (CurrentSubtitleText == "END_OF_SEQUENCE"){
      Log("the end of the sequence was found");
      CurrentSubtitleSeq = theInfo.TheSubtitles[CurrentSubtitleSeq].GetNextSequenceNum();
      CurrentSubtitle = 0;
      Log(CurrentSubtitleSeq $ " is the next sequence we should do");
      if (CurrentSubtitleSeq == -1){
         log("killing any further subtitles");
         KillSubtitles();
         return;
      }
      SetSubtitle(CurrentSubtitleSeq, CurrentSubtitle);
      return;
//      SetMultiTimer(SUBTITLE, RelativeTime, false);
   }


   //Log(CurrentSubtitleText);

   Line1 = CurrentSubtitleText;
   Line2 = "";

   if (Len(CurrentSubtitleText) > MAX_LENGTH){
      for (i=MAX_LENGTH; i>=0; i--){
         if (Mid(CurrentSubtitleText,i,1) == " "){
            Line1 = Left(CurrentSubtitleText, i);
            Line2 = Mid(CurrentSubtitleText,i + 1);
            break;
         }
      }
   }

   Log(Line1);
   Log(line2);

   AbsTime=theInfo.TheSubtitles[CurrentSubtitleSeq].GetTime(CurrentSubtitle);
   RelativeTime = AbsTime - LastSubtitleTime;
   LastSubtitleTime = AbsTime;
   SetMultiTimer(SUBTITLE, RelativeTime, false);
}


/*****************************************************************
 * MultiTimer
 *****************************************************************
 */
function MultiTimer(int SlotID){
   local HUD temp;

   switch(SlotID){
      case HUD_INIT_TIMER:
         if (!RegisteredWithHud){
             temp = Level.GetLocalPlayerController().myHud;
             if (temp == none){
                SetMultiTimer( HUD_INIT_TIMER, 0.05, false );
                return;
             }
             AdvancedHud(Level.GetLocalPlayerController().myHud).register(self,false);
             //AdvancedHud(MyHUD).register(self, true);
             RegisteredWithHud = true;
         }
         break;
      case SUBTITLE:
//         if ( bSubtitlesOn == true){
            CurrentSubtitle++;
            SetSubtitle(CurrentSubtitleSeq, CurrentSubtitle);
  //       }
         break;
   }
}

function KillSubtitles(){
   CurrentSubtitleSeq = 0;
   CurrentSubtitle = 0;
   CurrentSubtitleText = "";
   Line1= "";
   Line2= "";
   LastSubtitleTime = 0;
//   bSubtitlesOn = false;
   SetMultiTimer(SUBTITLE, 0, false);

}

/****************************************************************
 * DrawToHUD
 ****************************************************************
 */
function drawToHUD( Canvas c, float scaleX, float scaleY ) {

   c.SetDrawColor( 255,255,255, 0 );
   c.Font = AdvancedHud(Level.GetLocalPlayerController().myHUD).
             GetSubtitleFontRef();

   if (Level.GetLocalPlayerController().Player.GUIController.bIsConsole) {
       // XBOX positioning

       //first line
       c.SetPos( scaleX, 775 * scaleY );
       c.bCenter = true;
       c.DrawText(Line1);

       //second line
       c.SetPos( scaleX, 820 * scaleY );
       c.DrawText(Line2);
       c.bCenter = false;
   } else {
       // PC positioning

       //first line
       c.SetPos( scaleX, 860 * scaleY );
       c.bCenter = true;
       c.DrawText(Line1);

       //second line
       c.SetPos( scaleX, 905 * scaleY );
       c.DrawText(Line2);
       c.bCenter = false;
   }
}


/****************************************************************
 * drawDebugToHUD
 ****************************************************************
 */
function drawDebugToHUD( Canvas c, float scaleX, float scaleY ) {

}

//===========================================================================
// DefaultProperties
//===========================================================================

defaultproperties
{
     bHidden=True
     bAlwaysTick=True
}
