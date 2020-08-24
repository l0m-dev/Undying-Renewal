//=============================================================================
// JeremiahSoundSet.
//=============================================================================
class JeremiahSoundSet expands SharedHumanSoundSet;

//#exec OBJ LOAD FILE=\Aeons\Sounds\Voiceover.uax PACKAGE=Voiceover

var(Sounds) CreatureSoundGroup	VDeath;

defaultproperties
{
     VDeath=(Sound0=Sound'Voiceover.Jeremiah.Je_034',Sound1=Sound'Voiceover.Jeremiah.Je_035',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
}
