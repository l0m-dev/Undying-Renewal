//=============================================================================
// AmbroseCutScene.
//=============================================================================
class AmbroseCutScene expands CutSceneChar;
 
//#exec MESH IMPORT MESH=AmbroseCS_m SKELFILE=AmbroseCS.ngf
//#exec MESH MODIFIERS Cloth01:Cloth

//#exec MESH NOTIFY SEQ=0415 TIME=0.836 FUNCTION=AxeInHand
//#exec MESH NOTIFY SEQ=0420 TIME=0.772 FUNCTION=SmallStoneInHand

var HeldProp Axe;
var GhelzStoneSmall SmallStone;

function PreBeginPlay()
{
	Super.PreBeginPlay();
	Axe = Spawn(class 'Aeons.AmbroseAxe',self,, Location);
	Axe.bHidden = true;
	Axe.bMRM = false;

}

function SmallStoneInHand()
{
	SmallStone = spawn(class 'GhelzStoneSmall',self,,Location);
	SmallStone.SetBase(self, 'RTHandle', 'Stone5');
	SmallStone.RemoteRole = ROLE_SimulatedProxy;
}

function PutAxeInRightHand()
{
	Axe.Setup( 'RTHandle', 'axe_2' );
}

function PutAxeInLeftHandNearBlade()
{
	Axe.SetBase(self, 'LTHandle', 'axe_3' );
}

function PutAxeInLeftHand()
{
	Axe.SetBase(self, 'LTHandle', 'axe_1' );
}

function AxeOnBack()
{
	if ( Axe != none )
	{
		Axe.bHidden = false;
		Axe.SetBase(self, 'Bone03', 'axe_3');
	}
}

function AxeInHand()
{
	if ( Axe != none )
	{
		Axe.bHidden = false;
		Axe.SetBase(self, 'RT_Axe_Attach', 'axe_1');
	}
}

function AxeIn_RIGHT_Hand()
{
	if ( Axe != none )
	{
		Axe.bHidden = false;
		Axe.SetBase(self, 'RTHandle', 'axe_2');
	}
}

function LogJointInfo()
{
	local int Nj, i;

	Nj = self.NumJoints();
	for (i=0; i< Nj; i++)
	{
		log("JointName: "$self.JointName(i), 'Cutscenes');
	}
}

function LogAxeInfo()
{
	local int Nj, i;

	Nj = axe.NumJoints();
	for (i=0; i< Nj; i++)
	{
		log("Axe JointName: "$axe.JointName(i), 'Cutscenes');
	}
}

function SetupTake(int Cutscene, int Take)
{
	// ====================================================
	// CU_04
	// ====================================================
	if ( Cutscene == 4 )
	{
		log("SetupTake "$Cutscene, 'Misc');
		
		switch( Take )
		{
			case 2:
				AxeOnBack();
				break;
			
			case 14:
				Axe.Destroy();
				break;
		
			case 20:
				break;
			
			case 21:
				SmallStone.Destroy();
				break;

			default:
				break;
		}
	}
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.AmbroseCS_m'
     CollisionHeight=64
}
