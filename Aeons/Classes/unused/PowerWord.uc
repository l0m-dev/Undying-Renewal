//=============================================================================
// PowerWord.
//=============================================================================
class PowerWord expands AttSpell;

var		Pawn			PawnOwner;
var 	PlayerPawn		PlayerPawnOwner;
var		bool			activeWord;
var		PowerWord_proj	pw;
var		ScriptedFX 		pFX;
var		int				NumPoints, cnt;
var 	Pawn 			Targets[8];
var 	ScriptedFX 		Shafts[8];
var		vector 			x, y, z;
var		vector			PLocs[256], lastLoc;

function PreBeginPlay ()
{
	Super.PreBeginPlay();
	PawnOwner = Pawn(Owner);
	PlayerPawnOwner = PlayerPawn(Owner);
	ActiveWord = false;
}

function GetEye(out vector Loc)
{
	local vector EyeHeight;

	EyeHeight.z = Pawn(Owner).EyeHeight;
	Loc = Pawn(Owner).Location + EyeHeight;
}

state NormalFire
{
	ignores FireAttSpell;

	Begin:
		FinishAnim();
		Finish();
}

function StartParticles()
{
	local int i;
	local vector EyeLoc;
	
	NumPoints = 0;
	cnt  = 0;

	GetEye(EyeLoc);
	pFX.Destroy();

	pFX = spawn(class 'PWSignParticleFX',self,, EyeLoc);
	pFX.setBase(self, 'Mid_Tip', 'root');
	
	for (i=0; i<256; i++)
	{
		PLocs[i] = vect(0,0,0);
	}

	AmbientSound = Sound'Aeons.E_Spl_PwrSuck01';
	SoundRadius = 16;
	LastLoc = JointPlace('Mid_Tip').pos;
	gotoState('GenParticles');
}

function StopParticles()
{
	AmbientSound = None;
	pFX.Destroy();
	pw = Spawn(class 'PowerWord_proj',Pawn(Owner),, Location);
	pw.parentSpell = self;
	GotoState('Idle');
}

/*
simulated event RenderOverlays( canvas Canvas )
{
	super.RenderOverlays(Canvas);
	if (pfx != none)
	    Canvas.DrawActor(pFX, false);
}
*/

state GenParticles
{
	function Tick(float DeltaTime)
	{
		local int i;
		local vector WorldLoc, LocalLoc;
		local vector EyeLoc;
		
		GetEye(EyeLoc);
		GetAxes(Pawn(Owner).ViewRotation, x, y, z);
		
		WorldLoc = JointPlace('Mid_Tip').pos;
	 	PLocs[cnt] = (WorldLoc - EyeLoc) << Pawn(Owner).ViewRotation;

		// from skulls
		// seekLoc = (skullPos >> Pawn(Owner).ViewRotation) + eyeLoc + tempSeekLoc;
		
		pFX.addParticle(NumPoints, LastLoc + (WorldLoc - LastLoc) * 0.5);
		// pFX.addParticle(NumPoints+1, WorldLoc);
		
		if ( NumPoints >= 1 )
		{
			for (i=0; i<(numPoints-1); i++)
			{
				pFX.GetParticleParams(i,pFX.Params);
				pFX.Params.Position = (Plocs[i] >> Pawn(Owner).ViewRotation) + EyeLoc;
				pFX.SetParticleParams(i, pFX.Params);
			}
		}

		// pFX.SetLocation( EyeLoc );
		// pFX.SetRotation( Pawn(Owner).ViewRotation );

		LastLoc = WorldLoc;
		NumPoints +=1;
		cnt ++;
	}

	Begin:
		cnt = 0;
		
}

state Idle
{
	ignores Fire;
	
	function Tick(float DeltaTime)
	{
		if (Pawn(Owner).bFireAttSpell == 0)
		{
			Finish();
		}
	}
	
	Begin:
		pfx.Destroy();
}


//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     HandAnim=PowerWord
     FireOffset=(X=128)
     RefireRate=1
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_PwrSpawn01'
     ItemType=SPELL_Offensive
     InventoryGroup=21
     PickupMessage="PowerWord"
     ItemName="PowerWord"
     PlayerViewOffset=(X=-3.5,Y=7.5,Z=-1)
     PlayerViewMesh=SkelMesh'Aeons.Meshes.SpellHand_m'
     PlayerViewScale=0.1
     Texture=Texture'Aeons.System.SpellIcon'
     Mesh=SkelMesh'Aeons.Meshes.SpellHand_m'
}
