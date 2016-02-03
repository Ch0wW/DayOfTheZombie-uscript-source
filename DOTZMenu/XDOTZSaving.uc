// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 *
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @version $Revision: #1 $
 * @date    Sept 2003
 */
class XDOTZSaving extends XDOTZErrorPage;

var localized string SavingMessage;
var float MillisecondsAtStart;
var float SecondsAtStart;

var float MillisecondsElapsed;
var float SecondsElapsed;

var int counter;

/*****************************************************************
 * Opened
 *****************************************************************
 */
event Opened( GUIComponent Sender ) {
   Super.Opened(Sender);
   //Counter = 0.1 + period;     //we don't accept input for 0.1, then 1 cycle before the first call
   SetErrorCaption(SavingMessage);
   MillisecondsAtStart = PlayerOwner().Level.Millisecond;
   SecondsAtStart = PlayerOwner().Level.Second;
   Log(MillisecondsAtStart);

   counter = 0;
}


function Periodic(){
   super.Periodic();
   /*
   MillisecondsElapsed = PlayerOwner().Level.Millisecond;
   SecondsElapsed = PlayerOwner().Level.Second;
   Log((1000* SecondsElapsed + MillisecondsElapsed));
   Log((1000* SecondsAtStart + MillisecondsAtStart));
   Log("*** Out Periodic");
   if (((1000 * SecondsElapsed) + MillisecondsElapsed) - ((1000 * SecondsAtStart) + MillisecondsAtStart) >= 3000){
    //BBGuiController(Controller).CloseTo ('XDOTZSPPause');
    Log("*** In Periodic");
    Controller.ViewportOwner.Actor.Level.Game
        .SetPause( false, Controller.ViewportOwner.Actor );
    BBGuiController(Controller).CloseAll( false );
   }
   */
    counter++;
    //Log("Counter:" @ counter);
    if(counter >= 6)
    {
        //Log("Counter timed out");
        Controller.ViewportOwner.Actor.Level.Game.SetPause( false, Controller.ViewportOwner.Actor );
        BBGuiController(Controller).CloseAll( false );
    }
}


//===========================================================================
// defaultproperties
//===========================================================================

defaultproperties
{
     SavingMessage="Saving... Do not turn off your Xbox console."
     __OnKeyEvent__Delegate=XDOTZSaving.HandleKeyEvent
}
