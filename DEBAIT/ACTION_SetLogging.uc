// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * ACTION_SetLogging
 * 
 * @author  Neil Gower (neilg@digitialextremes.com)
 * @version $Rev $
 * @date    July 2004
 */
class ACTION_SetLogging extends ScriptedAction;


var(Action) bool bEnableLogging;


/**
 * Ugh this is slow!
 */
function bool InitActionFor( ScriptedController c ) {
    local VGSPAIController myAI;
    myAI = VGSPAIController( c );
    if ( myAI == None ) return false;

    myAI.bDebugLogging = bEnableLogging;
    return false;	
}

/**
 */
function string GetActionString() {
    return ActionString @ bEnableLogging;
}

defaultproperties
{
     ActionString="join stage"
}
