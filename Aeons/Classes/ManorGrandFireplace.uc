//=============================================================================
// ManorGrandFireplace.
//=============================================================================
class ManorGrandFireplace expands FullFireFX;

//#exec OBJ LOAD FILE=\Aeons\Sounds\LevelMechanics.uax PACKAGE=LevelMechanics

defaultproperties
{
     ParticlesPerSec=(Base=256)
     SourceWidth=(Base=64)
     SourceDepth=(Base=128)
     ColorStart=(Base=(R=128,G=0,B=0))
     ColorEnd=(Base=(G=128,B=64),Rand=(R=255,G=255,B=128))
     SizeWidth=(Base=32,Rand=8)
     SizeLength=(Base=32,Rand=8)
     SizeEndScale=(Rand=2)
     Elasticity=0.01
     Attraction=(Z=-2)
     AmbientSound=Sound'LevelMechanics.EternalAutumn.A13_FireLp01'
     SoundRadius=28
     SoundRadiusInner=15
     SoundVolume=110
}
