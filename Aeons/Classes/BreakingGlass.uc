//=============================================================================
// BreakingGlass.
//=============================================================================
class BreakingGlass expands Effects;

var() int NumShards;
var() vector RandomOffset;
var() bool TriggerOnceOnly;
var() Texture GlassTexture;
var() float Force;

function Trigger(Actor Other, Pawn Instigator)
{
	local int i;
	local vector offset;
	local Actor A;

	if ( NumShards > 0 )
	{
		for( i=0; i<NumShards; i++ )
		{
			Offset.x = RandRange(-RandomOffset.x, RandomOffset.x);
			Offset.y = RandRange(-RandomOffset.y, RandomOffset.y);
			Offset.z = RandRange(-RandomOffset.z, RandomOffset.z);
			
			A = Spawn(class 'GlassShard', self,,Location + Offset, Rotation);
			if ( GlassTexture != none )
				A.SetTexture(1, GlassTexture);
			A.Velocity = Vector(Rotation) * Force;
		}
	}
	if (TriggerOnceOnly)
		Destroy();
}

defaultproperties
{
     NumShards=30
     bDirectional=True
     DrawType=DT_Sprite
}
