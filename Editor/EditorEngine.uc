// Copyright (C) 2005 Brainbox Games. All Rights Reserved.
// September 27, 2005
//=============================================================================
// EditorEngine: The UnrealEd subsystem.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class EditorEngine extends Engine
	native
	noexport
	transient;

#exec Texture Import File=Textures\Bad.pcx
#exec Texture Import File=Textures\BadHighlight.pcx
#exec Texture Import File=Textures\Bkgnd.pcx
#exec Texture Import File=Textures\BkgndHi.pcx
#exec Texture Import File=Textures\MaterialArrow.pcx MASKED=1
#exec Texture Import File=Textures\MaterialBackdrop.pcx
#exec Texture Import File=Textures\Grid.tga
#exec Texture Import File=Textures\SkyTexMarker.tga
#exec Texture Import File=Textures\ZonePortalMarker.tga

#exec NEW StaticMesh File="models\TexPropCube.Ase" Name="TexPropCube"
#exec NEW StaticMesh File="models\TexPropSphere.Ase" Name="TexPropSphere"

// Objects.
var const level       Level;
var const model       TempModel;
var const texture     CurrentTexture;
var const staticmesh  CurrentStaticMesh;
var const mesh		  CurrentMesh;
var const class       CurrentClass;
var const transbuffer Trans;
var const textbuffer  Results;
var const int         Pad[8];

// Textures.
var const texture Bad, Bkgnd, BkgndHi, BadHighlight, MaterialArrow, MaterialBackdrop;

// Used in UnrealEd for showing materials
var staticmesh	TexPropCube;
var staticmesh	TexPropSphere;

// Toggles.
var const bool bFastRebuild, bBootstrapping;

// Other variables.
var const config int AutoSaveIndex;
var const int AutoSaveCount, Mode, TerrainEditBrush, ClickFlags;
var const float MovementSpeed;
var const package PackageContext;
var const vector AddLocation;
var const plane AddPlane;

// Misc.
var const array<Object> Tools;
var const class BrowseClass;

// Grid.
var const int ConstraintsVtbl;
var(Grid) config bool GridEnabled;
var(Grid) config bool SnapVertices;
var(Grid) config float SnapDistance;
var(Grid) config vector GridSize;

// Rotation grid.
var(RotationGrid) config bool RotGridEnabled;
var(RotationGrid) config rotator RotGridSize;

// Advanced.
var(Advanced) config bool UseSizingBox;
var(Advanced) config bool UseAxisIndicator;
var(Advanced) config float FovAngleDegrees;
var(Advanced) config bool GodMode;
var(Advanced) config bool AutoSave;
var(Advanced) config byte AutosaveTimeMinutes;
var(Advanced) config string GameCommandLine;
var(Advanced) config array<string> EditPackages;
var(Advanced) config bool AlwaysShowTerrain;
var(Advanced) config bool UseActorRotationGizmo;
var(Advanced) config bool LoadEntirePackageWhenSaving;

defaultproperties
{
     Bad=Texture'Editor.Bad'
     Bkgnd=Texture'Editor.Bkgnd'
     BkgndHi=Texture'Editor.BkgndHi'
     BadHighlight=Texture'Editor.BadHighlight'
     MaterialArrow=Texture'Editor.MaterialArrow'
     MaterialBackdrop=Texture'Editor.MaterialBackdrop'
     TexPropCube=StaticMesh'Editor.TexPropCube'
     TexPropSphere=StaticMesh'Editor.TexPropSphere'
     AutoSaveIndex=6
     GridEnabled=True
     SnapDistance=10.000000
     GridSize=(X=16.000000,Y=16.000000,Z=16.000000)
     RotGridEnabled=True
     RotGridSize=(Pitch=1024,Yaw=1024,Roll=1024)
     UseAxisIndicator=True
     FovAngleDegrees=90.000000
     GodMode=True
     AutoSave=True
     AutosaveTimeMinutes=5
     GameCommandLine="-log"
     EditPackages(0)="Core"
     EditPackages(1)="EngineEx"
     EditPackages(2)="Engine"
     EditPackages(3)="Fire"
     EditPackages(4)="Editor"
     EditPackages(5)="UWindow"
     EditPackages(6)="UnrealEd"
     EditPackages(7)="IpDrv"
     EditPackages(8)="UWeb"
     EditPackages(9)="GamePlay"
     EditPackages(10)="UDebugMenu"
     EditPackages(11)="UPreview"
     EditPackages(12)="GUI"
     EditPackages(13)="BBParticles"
     EditPackages(14)="BBGui"
     EditPackages(15)="AdvancedEngine"
     EditPackages(16)="DebaitAdapters"
     EditPackages(17)="DEBAIT"
     EditPackages(18)="DOTZEngine"
     EditPackages(19)="DOTZItems"
     EditPackages(20)="DOTZAI"
     EditPackages(21)="DOTZCharacters"
     EditPackages(22)="DOTZWeapons"
     EditPackages(23)="XDOTZCharacters"
     EditPackages(24)="DOTZGame"
     EditPackages(25)="DOTZMenu"
     CacheSizeMegs=32
}
