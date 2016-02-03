// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//
// A Death Message.
//
// Switch 0: Kill
//	RelatedPRI_1 is the Killer.
//	RelatedPRI_2 is the Victim.
//	OptionalObject is the DamageType Class.
//

class AdvancedDeathMessage extends LocalMessage;

var(Message) localized string KilledString, SomeoneString;



static function string DecodeStringURL(string s) {
    local string r;
    local string c;
    local int i;

    for (i = 0; i < Len(s); ++i) {
        c = Mid(s,i,1);
        if (c == "_") {
            r = r $ " ";
        } else {
            r = r $ c;
        }
    }
    return r;
}



static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	local string KillerName, VictimName;

	if (Class<DamageType>(OptionalObject) == None)
		return "";

	if (RelatedPRI_2 == None)
		VictimName = Default.SomeoneString;
	else
		VictimName = DecodeStringURL(RelatedPRI_2.GamerTag);

	if ( Switch == 1 )
	{
		// suicide
		return class'GameInfo'.Static.ParseKillMessage(
			KillerName,
			VictimName,
			Class<DamageType>(OptionalObject).Static.SuicideMessage(RelatedPRI_2) );
	}

	if (RelatedPRI_1 == None)
		KillerName = Default.SomeoneString;
	else
		KillerName = DecodeStringURL(RelatedPRI_1.GamerTag);

	return class'GameInfo'.Static.ParseKillMessage(
		KillerName,
		VictimName,
		Class<DamageType>(OptionalObject).Static.DeathMessage(RelatedPRI_1, RelatedPRI_2) );
}


/*static function ClientReceive(
	PlayerController P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1,
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (RelatedPRI_1 == P.PlayerReplicationInfo)
	{
		// Interdict and send the child message instead.
		P.myHUD.LocalizedMessage( Default.ChildMessage, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
		P.myHUD.LocalizedMessage( Default.Class, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
	}
	else if (RelatedPRI_2 == P.PlayerReplicationInfo)
	{
		P.ReceiveLocalizedMessage( class'xVictimMessage', 0, RelatedPRI_1 );
		Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	}
	else
		Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}
*/

defaultproperties
{
     KilledString="was killed by"
     SomeoneString="someone"
     bIsSpecial=False
     DrawColor=(B=0,G=0)
}
