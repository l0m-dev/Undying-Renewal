//=============================================================================
// SilenceModifier.
//=============================================================================
class SilenceModifier expands PlayerModifier;

var float invVolMult;
var float VolMult;
var AeonsPlayer Player;


function PreBeginPlay()
{
	VolMult = 0.25;
	invVolMult = 1 / VolMult;
	if ( Owner.IsA('AeonsPlayer') )
		Player = AeonsPlayer(Owner);

	super.PreBeginPlay();
}

auto state Idle
{

	Begin:
}

function AddMaint(int i)
{


}

function RemMaint(int i)
{


}

state Activated
{
	function Timer()
	{
		gotoState('Deactivated');
	}

	Begin:
		if (Player != none)
			Player.bSilenceActive = true;
		bActive = true;
		if ( castingLevel == 0 ) {
			SoundModifier(AeonsPlayer(Owner).soundMod).AdjVolume(VolMult);
		} else if ( castingLevel == 1 ) {
			SoundModifier(AeonsPlayer(Owner).soundMod).AdjVolume(1, true);
		} else if ( castingLevel == 2 ) {
			SoundModifier(AeonsPlayer(Owner).soundMod).AdjVolume(1, true);
		} else if ( castingLevel == 3 ) {
			SoundModifier(AeonsPlayer(Owner).soundMod).AdjVolume(1, true);
			AeonsPlayer(Owner).bWeaponSound = false;						// Weapons do not make sounds
		} else if ( castingLevel == 4 ) {
			SoundModifier(AeonsPlayer(Owner).soundMod).AdjVolume(1, true);
			AeonsPlayer(Owner).bWeaponSound = false;						// Weapons do not make sounds
			AeonsPlayer(Owner).bMagicSound = false;							// Spells do not make sounds
		} else if ( castingLevel == 5 ) {
			SoundModifier(AeonsPlayer(Owner).soundMod).AdjVolume(1, true);
			AeonsPlayer(Owner).bWeaponSound = false;						// Weapons do not make sounds
			AeonsPlayer(Owner).bMagicSound = false;							// Spells do not make sounds
		} else {
			log("Casting Level is invalid!!!");
			gotoState('Deactivated');	// bail out
		}
		setTimer(30, false);
}

state Deactivated
{

	Begin:
		bActive = false;
		if (Player != none)
			Player.bSilenceActive = false;

		if ( castingLevel == 0 ) {
			SoundModifier(AeonsPlayer(Owner).soundMod).AdjVolume(invVolMult);
		} else {
			SoundModifier(AeonsPlayer(Owner).soundMod).AdjVolume(1);
		}
		AeonsPlayer(Owner).bWeaponSound = true;
		AeonsPlayer(Owner).bMagicSound = true;
		gotoState('Idle');
}

defaultproperties
{
     RemoteRole=ROLE_None
}
