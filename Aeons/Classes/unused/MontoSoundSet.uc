//=============================================================================
// MontoSoundSet.
//=============================================================================
class MontoSoundSet expands CreatureSoundSet;

var(Sounds) CreatureSoundGroup	Click;
var(Sounds) CreatureSoundGroup	Head;
var(Sounds) CreatureSoundGroup	Impact;
var(Sounds) CreatureSoundGroup	Slurp;
var(Sounds) CreatureSoundGroup	Special;
var(Sounds) CreatureSoundGroup	VAttack;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	VIdle;
var(Sounds) CreatureSoundGroup	Whoosh;
var(Sounds) CreatureSoundGroup	TrackLp;
var(Sounds) CreatureSoundGroup	VAttack2;
var(Sounds) CreatureSoundGroup	VAttack4;
var(Sounds) CreatureSoundGroup	LightLp;
var(Sounds) CreatureSoundGroup	LightStart;
var(Sounds) CreatureSoundGroup	LightEnd;
var(Sounds) CreatureSoundGroup	LightFire;
var(Sounds) CreatureSoundGroup	Spawn;

defaultproperties
{
     Click=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_Click01',Sound1=Sound'CreatureSFX.MontoShonoi.C_Monto_Click02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     Head=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_Head01',Sound1=Sound'CreatureSFX.MontoShonoi.C_Monto_Head02',NumSounds=2,Pitch=1,Volume=1,Radius=1)
     Impact=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_Impact01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Slurp=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_Slurp01',Sound1=Sound'CreatureSFX.MontoShonoi.C_Monto_Slurp02',Sound2=Sound'CreatureSFX.MontoShonoi.C_Monto_Slurp03',Sound3=Sound'CreatureSFX.MontoShonoi.C_Monto_Slurp04',NumSounds=4,Pitch=1,Volume=1,Radius=1)
     Special=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_Special01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     VAttack=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_VAttack01',Sound1=Sound'CreatureSFX.MontoShonoi.C_Monto_VAttack02',Sound2=Sound'CreatureSFX.MontoShonoi.C_Monto_VAttack03',Sound3=Sound'CreatureSFX.MontoShonoi.C_Monto_VAttack04',Sound4=Sound'CreatureSFX.MontoShonoi.C_Monto_VAttack05',NumSounds=5,slot=SLOT_Talk,Pitch=1,Volume=1.5,Radius=1)
     VDamage=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_VDamage01',Sound1=Sound'CreatureSFX.MontoShonoi.C_Monto_VDamage02',Sound2=Sound'CreatureSFX.MontoShonoi.C_Monto_VDamage03',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1.5,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_VDeath01',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1.5,Radius=1)
     VIdle=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_VIdle01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Whoosh=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_Whoosh01',NumSounds=1,Pitch=0.8,Volume=1.5,Radius=1)
     TrackLp=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_TrackLp1',NumSounds=1,slot=SLOT_Misc,Pitch=1,Volume=1.5,Radius=1)
     VAttack2=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_VAttack02',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1.5,Radius=1)
     VAttack4=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_VAttack04',NumSounds=1,slot=SLOT_Talk,Pitch=1,Volume=1.5,Radius=1)
     LightLp=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_LightLp1',NumSounds=1,slot=SLOT_Misc,Pitch=1,Volume=1.5,Radius=1)
     LightStart=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_LightStart1',NumSounds=1,slot=SLOT_Misc,Pitch=1,Volume=1.5,Radius=1)
     LightEnd=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_LightEnd1',NumSounds=1,slot=SLOT_Misc,Pitch=1,Volume=1.5,Radius=1)
     LightFire=(Sound0=Sound'Wpn_Spl_Inv.Spells.E_Spl_LightningStart01',NumSounds=1,slot=SLOT_Misc,Pitch=1,Volume=1.5,Radius=1)
     Spawn=(Sound0=Sound'CreatureSFX.MontoShonoi.C_Monto_Appear1',NumSounds=1,Pitch=1,Volume=10,Radius=10)
}
