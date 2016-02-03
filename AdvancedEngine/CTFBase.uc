// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//-----------------------------------------------------------
//
//-----------------------------------------------------------
class CTFBase extends TeamTech;

enum TEAM_TYPE{
   TT_RED,
   TT_BLUE
};
var() TEAM_TYPE TeamType;


var CTFFlag myFlag;

var class<CTFFlag> BlueFlagType;
var class<CTFFlag> RedFlagType;

/*****************************************************************
 * BeginPlay
 *****************************************************************
 */
function BeginPlay()
{
	Super.BeginPlay();
//	bHidden = false;

   if (TeamType == TT_RED){
	  myFlag = Spawn(RedFlagType, self);
   } else {
     myFlag = Spawn(BlueFlagType, self);
   }

	if (myFlag==None)
	{
      if (TeamType == TT_RED){
		   warn(Self$" could not spawn flag of type '"$RedFlagType$"' at "$location);
      } else {
         warn(Self$" could not spawn flag of type '"$BlueFlagType$"' at "$location);
      }
		return;
	}
	else
	{
		myFlag.HomeBase = self;
		myFlag.TeamType = TeamType;
	}
   bHidden = true;
}

defaultproperties
{
}
