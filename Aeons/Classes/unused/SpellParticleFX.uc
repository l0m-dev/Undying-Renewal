//=============================================================================
// SpellParticleFX.
//=============================================================================
class SpellParticleFX expands AeonsParticleFX;

#exec Texture Import Name=Star1_pfx File=Star1_pfx.pcx Group=Particles Mips=OFF
#exec Texture Import Name=Star2_pfx File=Star2_pfx.pcx Group=Particles Mips=OFF
#exec Texture Import Name=Star3_pfx File=Star3_pfx.pcx Group=Particles Mips=OFF
#exec Texture Import Name=Star4_pfx File=Star4_pfx.pcx Group=Particles Mips=OFF
#exec Texture Import Name=Star5_pfx File=Star5_pfx.pcx Group=Particles Mips=OFF
#exec Texture Import Name=Star6_pfx File=Star6_pfx.pcx Group=Particles Mips=OFF
#exec Texture Import Name=Star7_pfx File=Star7_pfx.pcx Group=Particles Mips=OFF
#exec Texture Import Name=Star8_pfx File=Star8_pfx.pcx Group=Particles Mips=OFF

#exec Texture Import Name=Smoke_mpfx File=Smoke_mpfx.pcx Group=Particles Mips=OFF
#exec Texture Import Name=Smoke2_mpfx File=Smoke2_mpfx.pcx Group=Particles Mips=OFF
#exec Texture Import Name=Smoke3_mpfx File=Smoke3_mpfx.pcx Group=Particles Mips=OFF

var int castingLevel;
var() color AmpColors[5];

function Attach(Actor Other)
{
	log(name $ " attached to " $ base.name);

}

defaultproperties
{
     AmpColors(0)=(R=255,G=255,B=255)
     AmpColors(1)=(R=255,G=255,B=255)
     AmpColors(2)=(R=255,G=255,B=255)
     AmpColors(3)=(R=255,G=255,B=255)
     AmpColors(4)=(R=255,G=255,B=255)
     RemoteRole=ROLE_DumbProxy
}
