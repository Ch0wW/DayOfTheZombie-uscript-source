// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * 
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Mar 2004
 */
class CounterObjective extends TriggerObjective;


//===========================================================================
// Editable properties
//===========================================================================
var(Objective) int CountDownFrom;


//===========================================================================
// Internal data
//===========================================================================
var int count;
var String currentText;

const SUB_CHAR = "#";

//===========================================================================
// Implementation
//===========================================================================

/**
 */
function init( EventDispatcher ed, MessageDispatcher md ) {
    super.init( ed, md );
    count = CountDownFrom;
    currentText = substitute( SUB_CHAR, count, objectiveText );
}

/**
 * 
 */
function bool handleEvent( Name event ) {
    if ( event == successTag ) {
        if ( count > 0 ) count--;
        currentText = substitute( SUB_CHAR, count, objectiveText );
        if ( count <= 0 ) return super.HandleEvent( event );
        else return true;
    }
    else return super.HandleEvent( event );
}

/**
 */
function getObjListText( out Array<ObjText> objsText, int indentLevel ) {
    local ObjText myInfo;
    if ( bHidden ) return;
    myInfo.text        = currentText;
    myInfo.indentLevel = indentLevel;
    myInfo.isComplete  = isComplete;
    objsText[objsText.length] = myInfo;
}

/**
 */
function String substitute( coerce String marker, coerce String sub, 
                            String src ) {
    local int idx;

    idx = InStr( src, marker );
    if ( idx == -1 ) return src;

    // splice in sub in place of marker...
    return left(src, idx) $ sub $ right(src, Len(src) - Len(marker) - idx);
}

//===========================================================================
// Default Properties
//===========================================================================

defaultproperties
{
     ObjectiveText="# remaining"
}
