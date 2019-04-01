//=============================================================================
// EctoEffectLight.
//=============================================================================
class EctoEffectLight expands Light;

function Tick(float DeltaTime)
{
	if (Owner == none)
		Destroy();
	
	SetLocation(Owner.Location);
}

defaultproperties
{
     bStatic=False
     bNoDelete=False
     Texture=None
     LightBrightness=164
     LightHue=153
     LightSaturation=25
     LightRadius=20
     LightRadiusInner=8
}
