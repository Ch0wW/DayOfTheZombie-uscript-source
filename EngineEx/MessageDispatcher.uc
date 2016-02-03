// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * MessageDispatcher - insulates the objectives system from
 *     dependencies on GameInfo.
 *
 * @version $Revision: #1 $
 * @author  Neil Gower (neilg@digitalextremes.com)
 * @date    Feb 2004
 */
class MessageDispatcher extends Object
    interface;

/**
 * Posts a global message, up to the dispatcher to decide the type.
 */
function DispatchMessage( String msg );

defaultproperties
{
}
