//=============================================================================
// ShamanCutscene.
//=============================================================================
class ShamanCutscene expands CutsceneChar;

//#exec MESH IMPORT MESH=ShamanCS_m SKELFILE=ShamanCS.ngf
//#exec MESH NOTIFY SEQ=0116 TIME=0.81 FUNCTION=Flash

var Actor Lt, Glow, Stone;

function AttachLight()
{
	Lt = spawn(class 'GreenLight',self,,JointPlace('Stone_Hand_Att').pos);
	Lt.SetBase(self, 'Stone_Hand_Att', 'root');
	Lt.RemoteRole = ROLE_SimulatedProxy;
	
	Stone = spawn(class 'GhelzStoneSmall',self,,JointPlace('Stone_Hand_Att').pos);
	Stone.SetBase(self, 'Stone_Hand_Att', 'root');
	Stone.RemoteRole = ROLE_SimulatedProxy;
}

function Flash()
{
	local Actor A;

	Glow = spawn(class 'DebugLocationMarker',,,Location);
	Glow.texture = WetTexture'FX.Gglow_wet';
	Glow.DrawScale = 0.5;
	Glow.SetBase(self, 'Stone_Hand_Att', 'root');
	Glow.RemoteRole = ROLE_SimulatedProxy;

	ForEach AllActors(class 'Actor',A,'GreenViewFlash')
	{
		A.Trigger(none, none);
	}
}
function SetupTake(int Cutscene, int Take)
{
	// ====================================================
	// CU_01
	// ====================================================
	if ( Cutscene == 1 )
	{
		switch( Take )
		{
			case 13:
				AttachLight();
				break;
		}
	}	// 01
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.ShamanCS_m'
}
