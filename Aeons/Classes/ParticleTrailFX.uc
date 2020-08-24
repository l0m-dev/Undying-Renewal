//=============================================================================
// ParticleTrailFX. 
//=============================================================================
class ParticleTrailFX expands AeonsParticleFX;

defaultproperties
{
     ParticlesPerSec=(Base=16)
     Speed=(Base=0)
     ColorStart=(Base=(R=79,G=64,B=255))
     ColorEnd=(Base=(G=255,B=255))
     SizeEndScale=(Base=0.25)
     Distribution=DIST_Uniform
     Textures(0)=Texture'UWindow.WhiteTexture'
     RenderPrimitive=PPRIM_Line
}
