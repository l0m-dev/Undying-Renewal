//=============================================================================
// SharedHumanSoundSet.
//=============================================================================
class SharedHumanSoundSet expands CreatureSoundSet;

////#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	Hand;
var(Sounds) CreatureSoundGroup	Whoosh;
var(Sounds) CreatureSoundGroup	Swim;

defaultproperties
{
     hand=(Sound0=Sound'CreatureSFX.SharedHuman.C_Hand01',Sound1=Sound'CreatureSFX.SharedHuman.C_Hand02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     Whoosh=(Sound0=Sound'CreatureSFX.SharedHuman.C_Whoosh01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     swim=(Sound0=Sound'CreatureSFX.SharedHuman.P_Swim01',Sound1=Sound'CreatureSFX.SharedHuman.P_Swim02',Sound2=Sound'CreatureSFX.SharedHuman.P_Swim03',NumSounds=3,Pitch=1,Volume=1,Radius=1)
}
