//=============================================================================
// GlassShard.
//=============================================================================
class GlassShard expands Decoration;

//#exec MESH IMPORT MESH=GlassShard01_m SKELFILE=GlassShard01.ngf 
//#exec MESH IMPORT MESH=GlassShard02_m SKELFILE=GlassShard02.ngf 
//#exec MESH IMPORT MESH=GlassShard03_m SKELFILE=GlassShard03.ngf 
//#exec MESH IMPORT MESH=GlassShard04_m SKELFILE=GlassShard04.ngf 
//#exec MESH IMPORT MESH=GlassShard05_m SKELFILE=GlassShard05.ngf 
//#exec MESH IMPORT MESH=GlassShard06_m SKELFILE=GlassShard06.ngf 
//#exec MESH IMPORT MESH=GlassShard07_m SKELFILE=GlassShard07.ngf 
//#exec MESH IMPORT MESH=GlassShard08_m SKELFILE=GlassShard08.ngf 
//#exec MESH IMPORT MESH=GlassShard09_m SKELFILE=GlassShard09.ngf 
//#exec MESH IMPORT MESH=GlassShard10_m SKELFILE=GlassShard10.ngf 

//#exec MESH IMPORT MESH=GlassShard11_m SKELFILE=GlassShard11.ngf 
//#exec MESH IMPORT MESH=GlassShard12_m SKELFILE=GlassShard12.ngf 
//#exec MESH IMPORT MESH=GlassShard13_m SKELFILE=GlassShard13.ngf 
//#exec MESH IMPORT MESH=GlassShard14_m SKELFILE=GlassShard14.ngf 
//#exec MESH IMPORT MESH=GlassShard15_m SKELFILE=GlassShard15.ngf 
//#exec MESH IMPORT MESH=GlassShard16_m SKELFILE=GlassShard16.ngf 
//#exec MESH IMPORT MESH=GlassShard17_m SKELFILE=GlassShard17.ngf 
//#exec MESH IMPORT MESH=GlassShard18_m SKELFILE=GlassShard18.ngf 
//#exec MESH IMPORT MESH=GlassShard19_m SKELFILE=GlassShard19.ngf 
//#exec MESH IMPORT MESH=GlassShard20_m SKELFILE=GlassShard20.ngf 

//#exec MESH IMPORT MESH=GlassShard21_m SKELFILE=GlassShard21.ngf 
//#exec MESH IMPORT MESH=GlassShard22_m SKELFILE=GlassShard22.ngf 
//#exec MESH IMPORT MESH=GlassShard23_m SKELFILE=GlassShard23.ngf 
//#exec MESH IMPORT MESH=GlassShard24_m SKELFILE=GlassShard24.ngf 
//#exec MESH IMPORT MESH=GlassShard25_m SKELFILE=GlassShard25.ngf 
//#exec MESH IMPORT MESH=GlassShard26_m SKELFILE=GlassShard26.ngf 
//#exec MESH IMPORT MESH=GlassShard27_m SKELFILE=GlassShard27.ngf 
//#exec MESH IMPORT MESH=GlassShard28_m SKELFILE=GlassShard28.ngf 
//#exec MESH IMPORT MESH=GlassShard29_m SKELFILE=GlassShard29.ngf 
//#exec MESH IMPORT MESH=GlassShard30_m SKELFILE=GlassShard30.ngf 

var float Len;

function PreBeginPlay()
{
	local int i;
	Super.PreBeginPlay();

	i = Rand(30);

	switch(i+1)
	{
		case 1:
			Mesh=SkelMesh'Aeons.GlassShard01_m';
			break;
		case 2:
			Mesh=SkelMesh'Aeons.GlassShard02_m';
			break;
		case 3:
			Mesh=SkelMesh'Aeons.GlassShard03_m';
			break;
		case 4:
			Mesh=SkelMesh'Aeons.GlassShard04_m';
			break;
		case 5:
			Mesh=SkelMesh'Aeons.GlassShard05_m';
			break;
		case 6:
			Mesh=SkelMesh'Aeons.GlassShard06_m';
			break;
		case 7:
			Mesh=SkelMesh'Aeons.GlassShard07_m';
			break;
		case 8:
			Mesh=SkelMesh'Aeons.GlassShard08_m';
			break;
		case 9:
			Mesh=SkelMesh'Aeons.GlassShard09_m';
			break;
		case 10:
			Mesh=SkelMesh'Aeons.GlassShard10_m';
			break;
		case 11:
			Mesh=SkelMesh'Aeons.GlassShard11_m';
			break;
		case 12:
			Mesh=SkelMesh'Aeons.GlassShard12_m';
			break;
		case 13:
			Mesh=SkelMesh'Aeons.GlassShard13_m';
			break;
		case 14:
			Mesh=SkelMesh'Aeons.GlassShard14_m';
			break;
		case 15:
			Mesh=SkelMesh'Aeons.GlassShard15_m';
			break;
		case 16:
			Mesh=SkelMesh'Aeons.GlassShard16_m';
			break;
		case 17:
			Mesh=SkelMesh'Aeons.GlassShard17_m';
			break;
		case 18:
			Mesh=SkelMesh'Aeons.GlassShard18_m';
			break;
		case 19:
			Mesh=SkelMesh'Aeons.GlassShard19_m';
			break;
		case 20:
			Mesh=SkelMesh'Aeons.GlassShard20_m';
			break;
		case 21:
			Mesh=SkelMesh'Aeons.GlassShard21_m';
			break;
		case 22:
			Mesh=SkelMesh'Aeons.GlassShard22_m';
			break;
		case 23:
			Mesh=SkelMesh'Aeons.GlassShard23_m';
			break;
		case 24:
			Mesh=SkelMesh'Aeons.GlassShard24_m';
			break;
		case 25:
			Mesh=SkelMesh'Aeons.GlassShard25_m';
			break;
		case 26:
			Mesh=SkelMesh'Aeons.GlassShard26_m';
			break;
		case 27:
			Mesh=SkelMesh'Aeons.GlassShard27_m';
			break;
		case 28:
			Mesh=SkelMesh'Aeons.GlassShard28_m';
			break;
		case 29:
			Mesh=SkelMesh'Aeons.GlassShard29_m';
			break;
		case 30:
			Mesh=SkelMesh'Aeons.GlassShard30_m';
			break;
		
		default:
			break;
	}

	DesiredRotation = RotRand(true);
	SetTimer(Len, false);
}

function Timer()
{
	GotoState('FadeAway');

}

state FadeAway
{

	function BeginState()
	{
		SetTimer(2, false);
	}
	
	function Tick( float DeltaTime )
	{
		Opacity -= DeltaTime * 0.5;
	}
	
	function Timer()
	{
		Destroy();
	}
		
	Begin:
		
}

defaultproperties
{
     Len=20
     bStatic=False
     Physics=PHYS_Falling
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=20
     RotationRate=(Pitch=60000,Yaw=60000,Roll=60000)
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.GlassShard01_m'
     CollisionRadius=18
     CollisionHeight=4
     bCollideWorld=True
     bBounce=True
     bFixedRotationDir=True
     bRotateToDesired=True
     NetPriority=1.4
}
