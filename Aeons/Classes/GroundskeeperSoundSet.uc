//=============================================================================
// GroundskeeperSoundSet.
//=============================================================================
class GroundskeeperSoundSet expands SharedHumanSoundSet;

var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	EventIdle;
var(Sounds) CreatureSoundGroup	EventAlert;
var(Sounds) CreatureSoundGroup	EventRetreat;
var(Sounds) CreatureSoundGroup	EventBurn;

defaultproperties
{
     VDamage=(Sound0=Sound'Voiceover.Groundskeepers.1gro_001',Sound1=Sound'Voiceover.Groundskeepers.1gro_002',Sound2=Sound'Voiceover.Groundskeepers.1gro_003',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'Voiceover.Groundskeepers.1gro_010',Sound1=Sound'Voiceover.Groundskeepers.1gro_011',Sound2=Sound'Voiceover.Groundskeepers.1gro_012',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventIdle=(Sound0=Sound'Voiceover.Groundskeepers.1gro_013',Sound1=Sound'Voiceover.Groundskeepers.1gro_014',Sound2=Sound'Voiceover.Groundskeepers.1gro_015',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventAlert=(Sound0=Sound'Voiceover.Groundskeepers.1gro_007',Sound1=Sound'Voiceover.Groundskeepers.1gro_008',Sound2=Sound'Voiceover.Groundskeepers.1gro_009',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=2)
     EventRetreat=(Sound0=Sound'Voiceover.Groundskeepers.1gro_004',Sound1=Sound'Voiceover.Groundskeepers.1gro_005',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventBurn=(Sound0=Sound'Voiceover.Groundskeepers.1gro_016',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
}
