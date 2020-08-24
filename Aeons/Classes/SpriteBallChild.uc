//=============================================================================
// SpriteBallChild.
//=============================================================================
class SpriteBallChild expands SpriteBallExplosion;

Function PostBeginPlay()
{
	Texture = SpriteAnim[int(FRand()*5)];
	DrawScale = FRand()*2.0+2.0;
}

defaultproperties
{
     bHighDetail=True
     DrawScale=2.5
     LightType=LT_None
}
