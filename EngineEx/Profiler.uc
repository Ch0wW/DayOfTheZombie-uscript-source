// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/**
 * Profiler - Hookup to native classes to parse and manage profiles.
 *
 * @author  Seelan Vamatheva
 * @version $Revision: #2 $
 * @date    March 2005
 */
class Profiler extends Object
    native;

// Load profile with name v
native static final function bool Load(int v);
// Save current profile
native static final function bool Save();
// Set a value associated with a key
native static final function SetValue(string vk, string vv);
// Return value given a key
native static final function string GetValue(string v);
// Create new profile with name v
native static final function int NewProfile(string v);
// Delete profile with name v
native static final function bool DeleteProfile(int v);
// Load up all profiles & get total count (refreshes list)
native static final function int GetProfileCount();

// Return an index given its name
native static final function int GetProfileByName(string v);

// Return name of profile given its index (call GetProfileCount first)
native static final function string GetProfileName(int v);
// Returns name of currently loaded profile ("" if no profile is loaded)
native static final function string GetCurrentProfileName();

native static final function bool IsValidProfile();

// Returns total number of checkpoints in profile
native static final function int GetTotalCheckpoints();
// Returns name of checkpoint at index v
native static final function string GetCheckpoint(int v);
native static final function string GetUID();

defaultproperties
{
}
