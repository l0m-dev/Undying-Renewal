//=============================================================================
// KiesingerFace.
//=============================================================================
class KiesingerFace expands ScriptedEffect;
//#exec MESH IMPORT MESH=KiesingerFace_m SKELFILE=KiesingerFace.ngf 

//#exec AUDIO IMPORT  FILE="KiesLaugh.wav" NAME="KiesLaugh" GROUP="Effects"

var() float FadeLenIn;
var() float FadeLenOut;
var() float HoldLen;

var AeonsPlayer Player;

function FindPlayer()
{
	forEach AllActors(class 'AeonsPlayer',Player)
	{
		break;
	}
}

function Tick(float DeltaTime)
{
	if (Player == none)
		FindPlayer();

	if (Player != none)
		SetRotation(Rotator(Player.Location-Location));
}

auto state Idle
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		GotoState('FadeIn');
	}

	Begin:
		log("...................Kiesinger Face - Begin Idle state");
}

state FadeIn
{
	function Tick(float DeltaTime)
	{
	//	SetRotation(Rotator(Player.Location-Location));
		Opacity = FClamp(Opacity + (DeltaTime / FadeLenIn), 0,0.99);
	}

	function Timer()
	{
		GotoState('Hold');
	}

	Begin:
		SetTimer(FadeLenIn, false);
		log("...................Kiesinger Face - Begin FadeIn state");
}

state Hold
{
	function Trigger( Actor Other, Pawn EventInstigator )
	{
		GotoState('FadeOut');
	}
	
	function Timer()
	{
		GotoState('FadeOut');
	}

	Begin:
		log("...................Kiesinger Face - Begin Hold state");
		SetTimer(HoldLen,false);

}

state FadeOut
{
	function Tick(float DeltaTime)
	{
//		SetRotation(Rotator(Player.Location-Location));
		Opacity = FClamp(Opacity - (DeltaTime / FadeLenOut),0,0.99);
	}

	function Timer()
	{
		GotoState('Idle');
	}

	Begin:
		log("...................Kiesinger Face - Begin FadeOut state");
		SetTimer(FadeLenOut, false);

}

defaultproperties
{
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.KiesingerHead_m'
     Opacity=0.5
     CollisionRadius=16
     CollisionHeight=32
     bCollideActors=True
     bCollideWorld=True
}
