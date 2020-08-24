//=============================================================================
// HoundSpawnEffect.
//=============================================================================
class HoundSpawnEffect expands Effects;

//#exec OBJ LOAD FILE=\Aeons\Textures\FXB.utx PACKAGE=FXB

var() float rate;
var() Texture Textures[8];
var int iTex;

function ChangeTexture()
{
	Texture = Textures[iTex];
	iTex ++;
	if (iTex >= 8)
		Destroy();
		// iTex = 0;
}

auto State GenEffect
{
	function Tick(float DeltaTime)
	{
		DrawScale += DeltaTime * 2;
	}

	Begin:

}

defaultproperties
{
     Rate=0.15
     DrawType=DT_Sprite
     Texture=WetTexture'fxB.FX.HoundPortalWet'
     DrawScale=3
}
