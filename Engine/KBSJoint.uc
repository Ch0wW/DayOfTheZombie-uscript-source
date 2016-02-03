// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// The Ball-and-Socket joint class.
//=============================================================================

#exec Texture Import File=Textures\S_KBSJoint.pcx Name=S_KBSJoint Mips=Off MASKED=1

class KBSJoint extends KConstraint
    native
    placeable;

defaultproperties
{
     Texture=Texture'Engine.S_KBSJoint'
}
