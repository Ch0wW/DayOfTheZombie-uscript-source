class BBPBlood extends BBPHitFX;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'DOTZSSpecial.Gore.BoneShardA'
         Acceleration=(Z=-10000.000000)
         UseCollision=True
         UseMaxCollisions=True
         MaxCollisions=(Min=2.000000,Max=2.000000)
         SpawnFromOtherEmitter=1
         SpawnAmount=1
         MaxParticles=3
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000))
         StartSizeRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.000000,Max=0.000000),Z=(Min=0.000000,Max=0.000000))
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Max=8.000000)
         Name="MeshEmitter0"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPBlood.MeshEmitter0'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Right
         FadeOut=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=8
         RespawnDeadParticles=False
         UseRotationFrom=PTRS_Actor
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=5.000000,Max=20.000000),Y=(Min=1.000000,Max=3.000000))
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Darken
         Texture=Texture'SpecialFX.Blood.Bloodsplatter'
         LifetimeRange=(Min=0.250000,Max=0.500000)
         StartVelocityRange=(X=(Min=-25.000000,Max=-100.000000),Y=(Min=-2.000000,Max=2.000000),Z=(Min=-2.000000,Max=2.000000))
         Name="SpriteEmitter0"
     End Object
     Emitters(1)=SpriteEmitter'BBParticles.BBPBlood.SpriteEmitter0'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Right
         FadeOut=True
         CoordinateSystem=PTCS_Relative
         MaxParticles=15
         RespawnDeadParticles=False
         UseRotationFrom=PTRS_Actor
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=1.000000,Max=8.000000),Y=(Min=1.000000,Max=3.000000))
         InitialParticlesPerSecond=10000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Darken
         Texture=Texture'SpecialFX.Blood.Bloodsplatter'
         LifetimeRange=(Min=0.200000,Max=0.250000)
         StartVelocityRange=(X=(Min=25.000000,Max=50.000000),Y=(Min=-25.000000,Max=25.000000),Z=(Min=-25.000000,Max=25.000000))
         Name="SpriteEmitter1"
     End Object
     Emitters(2)=SpriteEmitter'BBParticles.BBPBlood.SpriteEmitter1'
     AutoDestroy=True
     bNoDelete=False
     bDirectional=True
     Tag="BBPBlood"
}
