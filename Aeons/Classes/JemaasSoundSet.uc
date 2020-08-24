//=============================================================================
// JemaasSoundSet.
//=============================================================================
class JemaasSoundSet expands SharedHumanSoundSet;

var(Sounds) CreatureSoundGroup	Signal;
var(Sounds) CreatureSoundGroup	Spear;
var(Sounds) CreatureSoundGroup	Stalk;
var(Sounds) CreatureSoundGroup	Twirl;
var(Sounds) CreatureSoundGroup	VCry;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	VEffort;
var(Sounds) CreatureSoundGroup	VExhale;
var(Sounds) CreatureSoundGroup	VGrunt;
var(Sounds) CreatureSoundGroup	VInhale;
var(Sounds) CreatureSoundGroup	EventScream;
var(Sounds) CreatureSoundGroup	VThrow;
var(Sounds) CreatureSoundGroup	MvmtLight;
var(Sounds) CreatureSoundGroup	SpeakEmph;
var(Sounds) CreatureSoundGroup	SpeakPoint;
var(Sounds) CreatureSoundGroup	SpeakYell;
var(Sounds) CreatureSoundGroup	SpeakAlarm;
var(Sounds) CreatureSoundGroup	SpeakCasual;
var(Sounds) CreatureSoundGroup	SpeakImp;
var(Sounds) CreatureSoundGroup	SpeakQuest;
var(Sounds) CreatureSoundGroup	EventFearSpot;
var(Sounds) CreatureSoundGroup	EventAttack;
var(Sounds) CreatureSoundGroup	SPKill;

defaultproperties
{
     Signal=(NumSounds=3,Pitch=1,Volume=1,Radius=1)
     spear=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Spear01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Stalk=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Stalk01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Stalk02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Stalk03',Sound3=Sound'CreatureSFX.Jemaas.C_Jemaas_Stalk04',Sound4=Sound'CreatureSFX.Jemaas.C_Jemaas_Stalk05',Sound5=Sound'CreatureSFX.Jemaas.C_Jemaas_Stalk06',NumSounds=6,Pitch=1,Volume=1,Radius=1)
     Twirl=(NumSounds=1,Pitch=1,Volume=1,Radius=1)
     VCry=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Vcry01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Vcry02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Vcry03',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1.5,Radius=2)
     VDamage=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Vdamage01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Vdamage02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Vdamage03',Sound3=Sound'CreatureSFX.Jemaas.C_Jemaas_Vdamage04',NumSounds=4,slot=SLOT_Pain,Pitch=1,Volume=1,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Vdeath01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Vdeath02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Vdeath03',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     VEffort=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Veffort01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Veffort02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Veffort03',Sound3=Sound'CreatureSFX.Jemaas.C_Jemaas_Veffort04',NumSounds=4,Pitch=1,Volume=1,Radius=1)
     VExhale=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Vexhale01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     VGrunt=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Vgrunt01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Vgrunt02',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     VInhale=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Vinhale01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     EventScream=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_VScream01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_VScream02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_VScream03',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     VThrow=(NumSounds=1,Pitch=1,Volume=1,Radius=1)
     MvmtLight=(Sound0=Sound'CreatureSFX.SharedHuman.C_ClothMvmt01',Sound1=Sound'CreatureSFX.SharedHuman.C_ClothMvmt02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     SpeakEmph=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak03',Sound3=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak04',Sound4=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak05',Sound5=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak06',Sound6=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak07',Sound7=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak08',Sound8=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak09',Sound9=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak10',NumSounds=10,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     SpeakPoint=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Vgrunt01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Vgrunt02',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     SpeakYell=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Vcry01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Vcry02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Vcry03',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     SpeakAlarm=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Vcry01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Vcry02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Vcry03',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     SpeakCasual=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak03',Sound3=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak04',Sound4=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak05',Sound5=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak06',Sound6=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak07',Sound7=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak08',Sound8=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak09',Sound9=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak10',NumSounds=10,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     SpeakImp=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak03',Sound3=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak04',Sound4=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak05',Sound5=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak06',Sound6=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak07',Sound7=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak08',Sound8=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak09',Sound9=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak10',NumSounds=10,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     SpeakQuest=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak03',Sound3=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak04',Sound4=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak05',Sound5=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak06',Sound6=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak07',Sound7=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak08',Sound8=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak09',Sound9=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak10',NumSounds=10,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventFearSpot=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Vcry01',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Vcry02',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Vgrunt02',NumSounds=3,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1)
     EventAttack=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak02',Sound1=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak03',Sound2=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak04',Sound3=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak05',Sound4=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak07',Sound5=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak08',Sound6=Sound'CreatureSFX.Jemaas.C_Jemaas_Speak10',Sound7=Sound'CreatureSFX.Jemaas.C_Jemaas_Vcry03',NumSounds=8,slot=SLOT_Talk,Pitch=1,Volume=1,Radius=1.5)
     SpKill=(Sound0=Sound'CreatureSFX.Jemaas.C_Jemaas_SpKill01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
}
