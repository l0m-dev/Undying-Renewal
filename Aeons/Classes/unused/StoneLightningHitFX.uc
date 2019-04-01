//=============================================================================
// StoneLightningHitFX. 
//=============================================================================
class StoneLightningHitFX expands LightningHitFX;

defaultproperties
{
     SourceHeight=(Base=0)
     SourceDepth=(Base=8)
     AngularSpreadWidth=(Base=30)
     AngularSpreadHeight=(Base=30)
     Speed=(Base=20)
     Lifetime=(Rand=1)
     ColorStart=(Base=(R=139,G=139,B=139))
     ColorEnd=(Base=(R=75,G=75,B=75))
     SizeWidth=(Rand=4)
     SizeLength=(Base=3)
     SizeEndScale=(Base=0,Rand=0.5)
     SpinRate=(Base=-1,Rand=2)
     Elasticity=0.15
     Textures(0)=Texture'UWindow.WhiteTexture'
     RenderPrimitive=PPRIM_Shard
}
