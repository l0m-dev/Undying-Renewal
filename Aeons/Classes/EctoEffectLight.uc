//=============================================================================
// EctoEffectLight.
//=============================================================================
class EctoEffectLight expands Light;

// serverside
// set bHidden to False to allow replication
// set DrawType to DT_None to hide sprite

function Tick(float DeltaTime)
{
     if (Owner == none)
     {
          Destroy();
          return;
     }
	
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
     bHidden=False
     DrawType=DT_None
}
