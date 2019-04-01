//=============================================================================
// SoundModifier.
//=============================================================================
class SoundModifier expands PlayerModifier;

// Anything in the game modifying the volume or other attributes

function AdjVolume(float mult, optional bool bSilent)
{
	local float cMult;	// current Multliplier
	local float FinalVolMultiplier;

	cMult = AeonsPlayer(Owner).VolumeMultiplier;
	
	if ( (cMult == 0) && (mult == 1) )
		cMult = 1;

	FinalVolMultiplier = cMult * mult;

	if ( bSilent )
		AeonsPlayer(Owner).VolumeMultiplier = 0;
	else
		AeonsPlayer(Owner).VolumeMultiplier = FinalVolMultiplier;

}

defaultproperties
{
}
