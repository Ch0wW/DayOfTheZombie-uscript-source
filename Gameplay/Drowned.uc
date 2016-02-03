// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class Drowned extends DamageType
	abstract;

static function class<Effects> GetPawnDamageEffect( vector HitLocation, float Damage, vector Momentum, Pawn Victim, bool bLowDetail )
{
	return Default.PawnDamageEffect;
}

defaultproperties
{
     DeathString="%o forgot to come up for air."
     FemaleSuicide="%o forgot to come up for air."
     MaleSuicide="%o forgot to come up for air."
     bArmorStops=False
     bNoSpecificLocation=True
     bCausesBlood=False
     FlashFog=(X=312.500000,Y=468.750000,Z=468.750000)
}
