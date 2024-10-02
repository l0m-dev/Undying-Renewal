//=============================================================================
// AxeCutScene.
//=============================================================================
class AxeCutScene expands CutSceneChar;

//#exec MESH IMPORT MESH=AxeCutscene_m SKELFILE=AxeCutscene.ngf

var GhelzStoneSmall SmallStone;
var GhelzTrailFX			GhelzStoneTrail;
var actor Glow;

function SmallStoneInAxe()
{
	SmallStone = spawn(class 'GhelzStoneSmall',self,,Location);
	SmallStone.SetBase(self,'Axe_03','Stone5');
	SmallStone.RemoteRole = ROLE_SimulatedProxy;
}

function TriggerFlash()
{
	local Actor A;
	local AeonsPlayer P;

	ForEach AllActors(class 'AeonsPlayer', P)
	{
		P.ClientFlash( 1, vect(0,1000,0));
	}

	Glow = spawn(class 'DebugLocationMarker',,,JointPlace('Axe_03').pos );
	Glow.texture = WetTexture'FX.Gglow_wet';
	Glow.DrawScale = 0.5;
	Glow.SetBase(self, 'Axe_03', 'root');
	Glow.Lifespan = 0.25;
	Glow.RemoteRole = ROLE_SimulatedProxy;
	
	if ( GhelzStoneTrail == none )
	{
		GhelzStoneTrail = spawn( class'GhelzTrailFX', SmallStone,, SmallStone.JointPlace('Stone5').pos );
		GhelzStoneTrail.SetBase( self, 'Axe_03', 'root' );
		GhelzStoneTrail.RemoteRole = ROLE_SimulatedProxy;
	}

	ForEach AllActors (class 'Actor', A, 'StoneInAxe')
	{
		A.Trigger(none, none);
	}	
}

function SetupTake(int Cutscene, int Take)
{
	// ====================================================
	// CU_04
	// ====================================================
	if ( Cutscene == 4 )
	{
		switch( Take )
		{
			case 21:
				SmallStoneInAxe();
				TriggerFlash();
				bHidden = false;
				break;

			default:
				break;
		}
	}
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.AxeCutscene_m'
}
