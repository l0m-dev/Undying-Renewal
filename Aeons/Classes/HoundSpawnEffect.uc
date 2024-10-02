//=============================================================================
// HoundSpawnEffect.
//=============================================================================
class HoundSpawnEffect expands Effects;

//#exec OBJ LOAD FILE=\Aeons\Textures\FXB.utx PACKAGE=FXB

var() float rate;
var() Texture Textures[8];
var int iTex;

simulated function ChangeTexture()
{
	Texture = Textures[iTex];
	iTex ++;
	if (iTex >= 8)
		Destroy();
		// iTex = 0;
}

auto State GenEffect
{
	simulated function Tick(float DeltaTime)
	{
		DrawScale += 8 * DeltaTime;
	
		if (DrawScale > 4)
			Destroy();
	}
}

defaultproperties
{
     Rate=0.15
     DrawType=DT_Sprite
	 Style=STY_AlphaBlend
     Texture=WetTexture'fxB.FX.HoundPortalWet'
     DrawScale=1
     RemoteRole=ROLE_SimulatedProxy
}
