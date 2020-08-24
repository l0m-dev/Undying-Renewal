//=============================================================================
// GameStateModifier.
//=============================================================================
class GameStateModifier expands PlayerModifier;

var Pawn PawnOwner;
var string LevelName;
var float FPS;
var float	fHealth,
			fMana,
			fBullets,
			fShells,
			fSpears,
			fDynamite,
			fMolotov, 
			fPhoenix, 
			fCannon, 
			fScythe, 
			fGhelz,
			fEcto, 
			fSkulls, 
			fScrye, 
			fHaste, 
			fDispel, 
			fShield, 
			fInvoke, 
			fLightning;
			

function Activate();
function Deactivate();

auto State Idle
{
	function Activate()
	{
		bActive = true;
	}
	
	function Deactivate()
	{
		bActive = false;
		setTimer(0, false);
	}
	
	function Timer()
	{
		local string LevelName;
		local int i;
		local string url;
		local AeonsPlayer AP;
		
		url = Level.GetLocalURL();

		i=instr(url, "?");
		
		if ( i >0 ) 
			LevelName = Left(url, i);
		else
			LevelName = url;

		if ( Owner != None )
			AP = AeonsPlayer(Owner);

		if ( bActive || ((AP != None) && AP.bLogGameState) )
		{
			FPS = (1000.0 / GetFrameTime()) * 0.01;
			
			fHealth = PawnOwner.Health * 0.01;
			fMana = PawnOwner.Mana * 0.01;

			if ( AP.ScryeTimer > 0 )
				fScrye = 1.0; 
			if ( AP.HasteMod.bActive )
				fHaste = 1.0;
			if ( AP.ShieldMod.bActive )
				fShield = 1.0;

			log(""$LevelName$"	"$fHealth$"	"$fMana$"	"$fBullets$"	"$fShells$"	"$fSpears$"	"$fDynamite$"	"$fMolotov$"	"$fPhoenix$"	"$fCannon$"	"$fScythe$"	"$fGhelz$"	"$fEcto$"	"$fSkulls$"	"$fDispel$"	"$fInvoke$"	"$fLightning$"	"$fScrye$"	"$fHaste$"	"$fShield$"	"$FPS,'GameState');
			
			fBullets = 0;
			fShells = 0;
			fSpears = 0;
			fDynamite = 0;
			fMolotov = 0; 
			fPhoenix = 0; 
			fCannon = 0; 
			fScythe = 0; 
			fGhelz = 0;
			fEcto = 0; 
			fSkulls = 0; 
			fDispel = 0; 
			fInvoke = 0; 
			fLightning = 0;

			fScrye = 0; 
			fHaste = 0; 
			fShield = 0; 
		}
	}

	function BeginState()
	{
		SetTimer(0.25, true);
		if ( Pawn(Owner) == none ) 
		{
			Log("Owner is none... destroying");
			//rb caused crash in multiplayer	Destroy();
			
		} else {
			PawnOwner = Pawn(Owner);
			log("",'GameState');
			log("LevelName Health Mana Bullets Shells Spears Dynamite Molotov Phoenix Cannon Scythe Ghelz Ecto Skulls Dispel Invoke Lightning Scrye Haste Shield FPS",'GameState');
			log("",'GameState');
		}
	}

	Begin:
		
}

defaultproperties
{
}
