//=============================================================================
// CreatureSoundSet.
//=============================================================================
class CreatureSoundSet expands SoundContainer;

//#exec OBJ LOAD FILE=\Aeons\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX
//#exec OBJ LOAD FILE=\Aeons\Sounds\Voiceover.uax PACKAGE=Voiceover
//#exec OBJ LOAD FILE=\Aeons\Sounds\Impacts.uax PACKAGE=Impacts
//#exec OBJ LOAD FILE=\Aeons\Sounds\Wpn_Spl_Inv.uax PACKAGE=Wpn_Spl_Inv
//#exec OBJ LOAD FILE=\Aeons\Sounds\LevelMechanics.uax PACKAGE=LevelMechanics
//#exec OBJ LOAD FILE=\Aeons\Sounds\Footsteps.uax PACKAGE=Footsteps

var(Sounds) CreatureSoundGroup	PatDeath;

defaultproperties
{
     PatDeath=(Sound0=Sound'Voiceover.Patrick.Pa_130',Sound1=Sound'Voiceover.Patrick.Pa_131',Sound2=Sound'Voiceover.Patrick.Pa_132',NumSounds=3,Pitch=1,Volume=1,Radius=1)
}
