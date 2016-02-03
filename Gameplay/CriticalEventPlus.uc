// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
class CriticalEventPlus extends LocalMessage;

static function float GetOffset(int Switch, float YL, float ClipY )
{
	return (Default.YPos/768.0) * ClipY;
}

defaultproperties
{
     bIsUnique=True
     bFadeMessage=True
     DrawColor=(G=160,R=0)
     FontSize=1
}
