class BBPMolotovTrail extends BBPMuzzleFlash;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter17
         FadeOut=True
         MaxParticles=200
         AutoDestroy=True
         SpinParticles=True
         StartSpinRange=(X=(Min=-0.650000,Max=-0.750000))
         StartSizeRange=(X=(Min=5.000000,Max=10.000000))
         UniformSize=True
         Texture=Texture'SpecialFX.Fire.LargeFlames2'
         TextureUSubdivisions=2
         TextureVSubdivisions=2
         UseRandomSubdivision=True
         LifetimeRange=(Min=0.750000,Max=0.750000)
         StartVelocityRange=(Z=(Min=10.000000,Max=20.000000))
         Name="SpriteEmitter17"
     End Object
     Emitters(0)=SpriteEmitter'BBParticles.BBPMolotovTrail.SpriteEmitter17'
     AutoDestroy=True
     bNoDelete=False
     bUnlit=False
}
