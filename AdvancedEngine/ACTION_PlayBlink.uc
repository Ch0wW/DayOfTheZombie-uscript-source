// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
/*****************************************************************
 * ACTION_PlayFaceAnimation
 * Authon: Professor J. LaChapelle
 *****************************************************************
 */
class ACTION_PlayBlink extends ACTION_PlayMultiBoneAnim;

defaultproperties
{
     StartChannel=24
     Bones(0)="UpperEyeR"
     Bones(1)="LowerEyeR"
     Bones(2)="UpperEyeL"
     Bones(3)="LowerEyeL"
     ActionString="playblinkanim"
}
