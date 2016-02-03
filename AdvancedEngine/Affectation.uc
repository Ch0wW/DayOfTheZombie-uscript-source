//-----------------------------------------------------------
//
//-----------------------------------------------------------
class Affectation extends AdvancedActor;

var StaticMesh StaticMesh2;
var Material Texture2;

function PostNetBeginPlay(){
    if (StaticMesh2 != none && Frand() > 0.5){
        SetStaticMesh(StaticMesh2);
    }
    else if (Texture2 != none && Frand() > 0.5){
        CopyMaterialsToSkins();
        Skins[0] = Texture2;
    }
}

event BaseChange(){
    if( base == None )
        SetPhysics(PHYS_Falling);
}

defaultproperties
{
     DrawType=DT_StaticMesh
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
