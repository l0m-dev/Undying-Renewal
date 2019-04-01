//=============================================================================
// WaterWorm.
//=============================================================================
class WaterWorm expands Effects;

#exec OBJ LOAD FILE=\Aeons\Textures\PiratesCoveG.utx PACKAGE=PiratesCoveG
#exec MESH IMPORT MESH=WaterWorm_m SKELFILE=WaterWorm.ngf 

var() Texture NewTexture;
var savable bool bActive;

function StartLevel()
{
	if ( NewTexture != none )
	{
		SetTexture(1, NewTexture);
	}
}

function PreBeginPlay()
{
	super.PreBeginPlay();
	bHidden = true;
}

function PostLoadGame()
{
	if ( bActive )
		LoopAnim('Idle', 0.35,,,0);
}

function Trigger(Actor Other, Pawn Instigator)
{
	GotoState('Grow');
}

state Grow
{
	function Trigger(Actor Other, Pawn Instigator){}
	
	function Tick(float DeltaTime)
	{
		if ( Opacity < 1 )
			Opacity += DeltaTime;
		else
			Opacity = 1;
	}

	Begin:
		Opacity = 0;
		PlayAnim('Emerge', 0.35,,,0);
		bHidden = false;
		FinishAnim();
		bSavable=true;
		LoopAnim('Idle', 0.35);
}

defaultproperties
{
     NewTexture=WetTexture'PiratesCoveG.PierWaterPcG'
     DrawType=DT_Mesh
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.WaterWorm_m'
}
