//=============================================================================
// KingSoundSet.
//=============================================================================
class KingSoundSet expands CreatureSoundSet;

var(Sounds) CreatureSoundGroup	AcidSpray;
var(Sounds) CreatureSoundGroup	WhooshHvy;
var(Sounds) CreatureSoundGroup	WhooshLt;
var(Sounds) CreatureSoundGroup	HeadRetract;
var(Sounds) CreatureSoundGroup	ClickA;
var(Sounds) CreatureSoundGroup	ClickB;
var(Sounds) CreatureSoundGroup	ClickC;
var(Sounds) CreatureSoundGroup	HeadShoots;
var(Sounds) CreatureSoundGroup	Mvmt;
var(Sounds) CreatureSoundGroup	ClickAll;
var(Sounds) CreatureSoundGroup	HeadShot;
var(Sounds) CreatureSoundGroup	HeadClose;
var(Sounds) CreatureSoundGroup	HeadOpen;
var(Sounds) CreatureSoundGroup	HeadOpenVocal;
var(Sounds) CreatureSoundGroup	HeadBeat;
var(Sounds) CreatureSoundGroup	HeadRecover;
var(Sounds) CreatureSoundGroup	Taunt;
var(Sounds) CreatureSoundGroup	SuctionStart;
var(Sounds) CreatureSoundGroup	SuctionLoop;
var(Sounds) CreatureSoundGroup	SuctionEnd;
var(Sounds) CreatureSoundGroup	HeavyHit;
var(Sounds) CreatureSoundGroup	LightHit;
var(Sounds) CreatureSoundGroup	VDamage;
/*
var(Sounds) CreatureSoundGroup	snd05;
var(Sounds) CreatureSoundGroup	snd06;
var(Sounds) CreatureSoundGroup	snd07;
var(Sounds) CreatureSoundGroup	snd08;
var(Sounds) CreatureSoundGroup	snd09;
var(Sounds) CreatureSoundGroup	snd10;
var(Sounds) CreatureSoundGroup	snd11;
var(Sounds) CreatureSoundGroup	snd12;
var(Sounds) CreatureSoundGroup	snd13;
var(Sounds) CreatureSoundGroup	snd14;
var(Sounds) CreatureSoundGroup	snd15;
var(Sounds) CreatureSoundGroup	snd16;
var(Sounds) CreatureSoundGroup	snd17;
var(Sounds) CreatureSoundGroup	snd18;
var(Sounds) CreatureSoundGroup	snd19;
var(Sounds) CreatureSoundGroup	snd20;

	snd05=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd06=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd07=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd08=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd09=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd10=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd11=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd12=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd13=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd14=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd15=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd16=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd17=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd18=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd19=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
	snd20=(Radius=1.0,NumSounds=1,Slot=SLOT_None,Volume=1.0,VolumeVar=0.0,Pitch=1.0,PitchVar=0.0,Sound0=Sound'CreatureSFX.King.C_King_')
*/

defaultproperties
{
     Acidspray=(Sound0=Sound'CreatureSFX.King.C_King_AcidSpray01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     WhooshHvy=(Sound0=Sound'CreatureSFX.King.C_King_WhooshHvy01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     WhooshLt=(Sound0=Sound'CreatureSFX.King.C_King_WhooshLt01',Sound1=Sound'CreatureSFX.King.C_King_WhooshLt02',NumSounds=2,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     HeadRetract=(Sound0=Sound'CreatureSFX.King.C_King_HeadRetract01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     ClickA=(Sound0=Sound'CreatureSFX.King.C_King_Click01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     ClickB=(Sound0=Sound'CreatureSFX.King.C_King_Click02',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     ClickC=(Sound0=Sound'CreatureSFX.King.C_King_Click03',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     Headshoots=(Sound0=Sound'CreatureSFX.King.C_King_HeadShoots01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     Mvmt=(Sound0=Sound'CreatureSFX.King.C_King_Mvmt01',Sound1=Sound'CreatureSFX.King.C_King_Mvmt02',NumSounds=2,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     ClickAll=(Sound0=Sound'CreatureSFX.King.C_King_Mvmt01',Sound1=Sound'CreatureSFX.King.C_King_Mvmt02',NumSounds=3,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     HeadShot=(Sound0=Sound'CreatureSFX.King.C_King_Headshot01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     HeadClose=(Sound0=Sound'CreatureSFX.King.C_King_HeadCloseSFX01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     HeadOpen=(Sound0=Sound'CreatureSFX.King.C_King_HeadOpenSFX01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     HeadOpenVocal=(Sound0=Sound'CreatureSFX.King.C_King_HeadOpenVcl01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     HeadBeat=(Sound0=Sound'CreatureSFX.King.C_King_Headbeat01',NumSounds=1,Pitch=1,Volume=2,Radius=5)
     HeadRecover=(Sound0=Sound'CreatureSFX.King.C_King_RecoverVcl01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     Taunt=(Sound0=Sound'CreatureSFX.King.C_King_Taunt01',Sound1=Sound'CreatureSFX.King.C_King_AmbVocal01',Sound2=Sound'CreatureSFX.King.C_King_AmbVocal02',Sound3=Sound'CreatureSFX.King.C_King_AmbVocal03',Sound4=Sound'CreatureSFX.King.C_King_AmbVocal04',NumSounds=5,Pitch=1,PitchVar=0.2,Volume=1.5,Radius=5)
     SuctionStart=(Sound0=Sound'CreatureSFX.King.C_King_SuctionStart01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     SuctionLoop=(Sound0=Sound'CreatureSFX.King.C_King_SuctionLoop01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     SuctionEnd=(Sound0=Sound'CreatureSFX.King.C_King_SuctionEnd01',NumSounds=1,Pitch=1,PitchVar=0.2,Volume=2,Radius=5)
     HeavyHit=(Sound0=Sound'CreatureSFX.King.C_King_HeavyHit01',Sound1=Sound'CreatureSFX.King.C_King_HeavyHit02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     LightHit=(Sound0=Sound'CreatureSFX.King.C_King_LightHit01',Sound1=Sound'CreatureSFX.King.C_King_LightHit02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'CreatureSFX.King.C_King_VDamage01',Sound1=Sound'CreatureSFX.King.C_King_VDamage02',Sound2=Sound'CreatureSFX.King.C_King_VDamage03',NumSounds=3,Pitch=1,PitchVar=0.2,Volume=3,Radius=5)
     PatDeath=(PitchVar=0.2,Volume=2,Radius=5)
}
