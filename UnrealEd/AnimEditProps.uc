// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// Object to facilitate properties editing
//=============================================================================
//  Animation / Mesh editor object to expose/shuttle only selected editable 
//  parameters from UMeshAnim/ UMesh objects back and forth in the editor.
//  

class AnimEditProps extends MeshObject
	hidecategories(Object)
	native;	

// (cpptext)
// (cpptext)
// (cpptext)
// (cpptext)

var const int WBrowserAnimationPtr;
var(Compression) float   GlobalCompression;
var(Compression) EAnimCompressMethod CompressionMethod;

cpptext
{
	void PostEditChange();

}


defaultproperties
{
     GlobalCompression=1.000000
}
