class BBPBurster extends BBPGib;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter4
         StaticMesh=StaticMesh'DOTZSSpecial.Gore.BoneShardA'
         Acceleration=(Z=-900.000000)
         MaxParticles=20
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-5.000000,Max=5.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-50.000000,Max=50.000000))
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.500000,Max=0.500000),Y=(Min=-0.500000,Max=0.500000),Z=(Min=-0.500000,Max=0.500000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Max=5.000000),Y=(Max=5.000000),Z=(Max=5.000000))
         InitialParticlesPerSecond=1000000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-500.000000,Max=500.000000),Y=(Min=-500.000000,Max=500.000000),Z=(Max=600.000000))
         Name="MeshEmitter4"
     End Object
     Emitters(0)=MeshEmitter'BBParticles.BBPBurster.MeshEmitter4'
     Begin Object Class=MeshEmitter Name=MeshEmitter6
         StaticMesh=StaticMesh'DOTZSSpecial.Gore.BloodyChunk'
         Acceleration=(Z=-900.000000)
         MaxParticles=25
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(X=(Min=-10.000000,Max=10.000000),Y=(Min=-10.000000,Max=10.000000),Z=(Min=-50.000000,Max=50.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000),Y=(Min=-0.200000,Max=0.200000),Z=(Min=-0.200000,Max=0.200000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Max=3.000000),Y=(Max=3.000000),Z=(Max=3.000000))
         InitialParticlesPerSecond=100000000.000000
         AutomaticInitialSpawning=False
         LifetimeRange=(Min=0.750000,Max=0.750000)
         StartVelocityRange=(X=(Min=-500.000000,Max=500.000000),Y=(Min=-500.000000,Max=500.000000),Z=(Min=500.000000))
         Name="MeshEmitter6"
     End Object
     Emitters(1)=MeshEmitter'BBParticles.BBPBurster.MeshEmitter6'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter10
         Acceleration=(Z=-100.000000)
         FadeOutStartTime=0.250000
         FadeOut=True
         MaxParticles=25
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(Z=(Min=-50.000000,Max=50.000000))
         UseRotationFrom=PTRS_Actor
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=25.000000)
         StartSizeRange=(X=(Min=5.000000,Max=10.000000))
         UniformSize=True
         InitialParticlesPerSecond=1000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Darken
         Texture=None
         TextureUSubdivisions=2
         TextureVSubdivisions=1
         UseRandomSubdivision=True
         LifetimeRange=(Min=1.500000,Max=2.000000)
         StartVelocityRange=(X=(Min=-100.000000,Max=100.000000),Y=(Min=-100.000000,Max=100.000000),Z=(Max=150.000000))
         Name="SpriteEmitter10"
     End Object
     Emitters(2)=SpriteEmitter'BBParticles.BBPBurster.SpriteEmitter10'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter11
         Acceleration=(Z=-200.000000)
         FadeOutStartTime=0.750000
         FadeOut=True
         MaxParticles=30
         RespawnDeadParticles=False
         AutoDestroy=True
         StartLocationRange=(Z=(Min=-50.000000,Max=50.000000))
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=10.000000,Max=20.000000))
         UniformSize=True
         InitialParticlesPerSecond=1000000000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Darken
         Texture=Texture'SpecialFX.Particles.BloodSpurt'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=1.500000,Max=2.000000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Max=250.000000))
         Name="SpriteEmitter11"
     End Object
     Emitters(3)=SpriteEmitter'BBParticles.BBPBurster.SpriteEmitter11'
     Begin Object Class=SpriteEmitter Name=SpriteEmitter12
         Acceleration=(Z=-200.000000)
         FadeOut=True
         MaxParticles=800
         RespawnDeadParticles=False
         AutoDestroy=True
         AddLocationFromOtherEmitter=1
         SpinParticles=True
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=5.000000,Max=10.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
         UniformSize=True
         DrawStyle=PTDS_Darken
         Texture=None
         TextureUSubdivisions=2
         TextureVSubdivisions=1
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.500000,Max=0.500000)
         Name="SpriteEmitter12"
     End Object
     Emitters(4)=SpriteEmitter'BBParticles.BBPBurster.SpriteEmitter12'
     AutoDestroy=True
     bNoDelete=False
     bUnlit=False
}
