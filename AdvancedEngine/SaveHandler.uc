// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005

class SaveHandler extends Object
    interface;

/**
 * Called by AdvancedGameInfo whenever a game is saved (using the slot system).
 */
function PreSave();

/**
 * As above, but AFTER the save is done.
 */
function PostSave();

defaultproperties
{
}
