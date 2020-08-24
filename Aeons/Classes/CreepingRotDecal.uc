//=============================================================================
// CreepingRotDecal.
//=============================================================================
class CreepingRotDecal expands AeonsDecal;

var int inc;

function Tick(float DeltaTime)
{
	super.Tick(DeltaTime);
	inc += DeltaTime;
	
	if (Owner == none)
		Destroy();
	
	//SetDrawScale(Owner.CollisionRadius + )

}

/*
function Destroyed()
{
	spawn (class 'SmokyExplosionFX'  ,,,Location);
	Super.Destroyed();
}*/

defaultproperties
{
     DecalTextures(0)=WetTexture'fxB2.Spells.WardGWet'
     NumDecals=1
     DecalLifetime=0
     FadeTime=0
     Style=STY_AlphaBlend
     Texture=None
     DrawScale=1
}
