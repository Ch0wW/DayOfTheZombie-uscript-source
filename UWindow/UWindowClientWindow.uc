// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// UWindowClientWindow - a blanked client-area window.
//=============================================================================
class UWindowClientWindow extends UWindowWindow;

#exec TEXTURE IMPORT NAME=Background FILE=Textures\Background.pcx GROUP="Icons" MIPS=OFF


function Close(optional bool bByParent)
{
	if(!bByParent)
		ParentWindow.Close(bByParent);

	Super.Close(bByParent);
}

defaultproperties
{
}
