//=============================================================================
// ScryeHintTrigger.
//=============================================================================
class ScryeHintTrigger expands Trigger;

//#exec TEXTURE IMPORT NAME=TrigScryeHint FILE=TrigScryeHint.pcx GROUP=System Mips=Off Flags=2

#exec OBJ LOAD FILE=\Aeons\Sounds\Shell_HUD.uax PACKAGE=Shell_HUD

var bool bCanPlayScryeSound, bEventSeen;
var int NumTimesTriggered;

var sound ScryeHintSounds[5];

// User Vars
var() bool bDisableAfterPlayerScrye;
var() float Vol1, Vol2, Vol3;

var string ScryeHintMessage;

//=============================================================================

function PreBeginPlay()
{
	super.PreBeginPlay();
	ScryeHintMessage = Localize("Aeons.ScryeHintTrigger", "ScryeHintMessage", "Renewal");
}

function PassThru(Actor Other)
{
	if ( !bPassThru || !bInitiallyActive)
		return;

	if ( !CheckConditionalEvent(Condition) )
		return;

	if ( Other.IsA('AeonsPlayer') )
		if ( AeonsPlayer(Other).Weapon.IsA('GhelziabahrStone') )
			GhelziabahrStone(AeonsPlayer(Other).Weapon).Glow();
}

function Timer()
{
	bCanPlayScryeSound = true;
}	

function UnTouch(Actor Other)
{
	if ( Other.IsA('AeonsPlayer') )
	{
		if ( AeonsPlayer(Other).Weapon.IsA('GhelziabahrStone') )
			GhelziabahrStone(AeonsPlayer(Other).Weapon).bGlowStone = false;
			
		if ( AeonsPlayer(Other).ScryeMod.bActive )
			AeonsPlayer(Other).bShowScryeHint = false;
	}
}

function Touch( actor Other )
{
	// event already seen?
	if (bEventSeen && bDisableAfterPlayerScrye)
		return;

	// check the conditional event name - this checks the supplied event in the player
	if ( !CheckConditionalEvent(Condition) )
		return;

	if ( IsRelevant(Other) )
	{
		if ( Other.IsA('AeonsPlayer') )
		{
			if ( AeonsPlayer(Other).bShowScryeHint )
				AeonsPlayer(Other).ScreenMessage(ScryeHintMessage, 5.0);
			
			if ( AeonsPlayer(Other).ScryeMod.bActive )
				AeonsPlayer(Other).bShowScryeHint = false;
		
			NumTimesTriggered ++;

			if ( bDisableAfterPlayerScrye && AeonsPlayer(Other).ScryeMod.bActive ){
				bEventSeen = true;
				if ( AeonsPlayer(Other).Weapon.IsA('GhelziabahrStone') )
					GhelziabahrStone(AeonsPlayer(Other).Weapon).bGlowStone = false;
			}

			if ( bCanPlayScryeSound )
			{
				switch ( NumTimesTriggered )
				{
					case 1:
						AeonsPlayer(Other).PlaySound(ScryeHintSounds[Rand(5)],,Vol1);
						bCanPlayScryeSound = false;
						break;

					case 2:
						AeonsPlayer(Other).PlaySound(ScryeHintSounds[Rand(5)],,Vol2);
						bCanPlayScryeSound = false;
						break;
					
					case 3:
						AeonsPlayer(Other).PlaySound(ScryeHintSounds[Rand(5)],,Vol3);
						bCanPlayScryeSound = false;
						break;

					default:
						AeonsPlayer(Other).PlaySound(ScryeHintSounds[Rand(5)],,Vol3);
						bCanPlayScryeSound = false;
						break;
				}
				SetTimer(3, false);
			}
			
			if ( AeonsPlayer(Other).Weapon.IsA('GhelziabahrStone') )
				GhelziabahrStone(AeonsPlayer(Other).Weapon).bGlowStone = true;
			Super.Touch(Other);
		}
	}
}

//=============================================================================

defaultproperties
{
     bCanPlayScryeSound=True
     ScryeHintSounds(0)=Sound'Shell_HUD.HUD.Scrye_Look'
     ScryeHintSounds(1)=Sound'Shell_HUD.HUD.Scrye_LookAround'
     ScryeHintSounds(2)=Sound'Shell_HUD.HUD.Scrye_Scrye'
     ScryeHintSounds(3)=Sound'Shell_HUD.HUD.Scrye_ScryeNow'
     ScryeHintSounds(4)=Sound'Shell_HUD.HUD.Scrye_See'
     bDisableAfterPlayerScrye=True
     Vol1=0.33
     Vol2=0.5
     Vol3=1
     Texture=Texture'Aeons.System.TrigScryeHint'
     DrawScale=0.5
}
