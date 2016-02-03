class BBPCeilingDust extends BBPDestruction;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter9
         Acceleration=(Z=-10.000000)
         FadeOutStartTime=-4.000000
         FadeOut=True
         MaxParticles=100
         RespawnDeadParticles=False
         StartLocationRange=(X=(Min=-300.000000,Max=300.000000),Y=(Min=-300.000000,Max=300.000000))
         SpinParticles=True
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=0.100000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         UseSizeScale=True
         UseRegularSizeScale=False
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=50.000000))
         UniformSize=True
         InitialParticlesPerSecond=100000.000000
         AutomaticInitialSpawning=False
         DrawStyle=PTDS_Brighten
         Texture=Texture'SpecialFX.Particles.dust2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(Z=(Min=-500.000000,Max=-300.000000))
         UseVelocityScale=True
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Y=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.100000)
         Name="SpriteEmitter9"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPCeilingDust.SpriteEmitter9'
     AutoDestroy=True
     bNoDelete=False
     bUnlit=False
}
