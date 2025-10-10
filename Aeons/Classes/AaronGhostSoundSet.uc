//=============================================================================
// AaronGhostSoundSet.
//=============================================================================
class AaronGhostSoundSet expands SharedHumanSoundSet;

////#exec OBJ LOAD FILE=..\Sounds\CreatureSFX.uax PACKAGE=CreatureSFX

var(Sounds) CreatureSoundGroup	PageTurn;
var(Sounds) CreatureSoundGroup	PaintA;
var(Sounds) CreatureSoundGroup	PaintB;
var(Sounds) CreatureSoundGroup	PaintC;
var(Sounds) CreatureSoundGroup	DropBook;

defaultproperties
{
     Pageturn=(Sound0=Sound'CreatureSFX.Monk.C_PageTurn01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     PaintA=(Sound0=Sound'CreatureSFX.Aaron.C_Paint01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     PaintB=(Sound0=Sound'CreatureSFX.Aaron.C_Paint02',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     PaintC=(Sound0=Sound'CreatureSFX.Aaron.C_Paint03',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     DropBook=(Sound0=Sound'CreatureSFX.Monk.C_DropBook01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
}
