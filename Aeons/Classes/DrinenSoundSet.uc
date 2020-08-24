//=============================================================================
// DrinenSoundSet.
//=============================================================================
class DrinenSoundSet expands CreatureSoundSet;

var(Sounds) CreatureSoundGroup	Breath;
var(Sounds) CreatureSoundGroup	Search;
var(Sounds) CreatureSoundGroup	StaffDrop;
var(Sounds) CreatureSoundGroup	StaffRing;
var(Sounds) CreatureSoundGroup	StaffSlam;
var(Sounds) CreatureSoundGroup	StaffSpin;
var(Sounds) CreatureSoundGroup	StaffTap;
var(Sounds) CreatureSoundGroup	VDamage;
var(Sounds) CreatureSoundGroup	VDeath;
var(Sounds) CreatureSoundGroup	Whoosh;
var(Sounds) CreatureSoundGroup	EventFearSpot;
var(Sounds) CreatureSoundGroup	SpinA;
var(Sounds) CreatureSoundGroup	SpinB;
var(Sounds) CreatureSoundGroup	FleshSlice;
var(Sounds) CreatureSoundGroup	HeadShot;
var(Sounds) CreatureSoundGroup	Teleport;

defaultproperties
{
     Breath=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_Breath01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Search=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_Search01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     StaffDrop=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_StaffDrop01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     StaffRing=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_StaffRing01',NumSounds=1,Pitch=1,Volume=1.5,Radius=1)
     StaffSlam=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_StaffSlam01',NumSounds=1,Pitch=1,Volume=1.5,Radius=1)
     StaffSpin=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_StaffSpin01',Sound1=Sound'CreatureSFX.Drinen.C_Dri_StaffSpin02',Sound2=Sound'CreatureSFX.Drinen.C_Dri_StaffSpin03',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     StaffTap=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_StaffTap01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     VDamage=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_VDamage01',Sound1=Sound'CreatureSFX.Drinen.C_Dri_VDamage02',Sound2=Sound'CreatureSFX.Drinen.C_Dri_VDamage03',NumSounds=3,slot=SLOT_Pain,Pitch=1,Volume=1.5,Radius=1)
     VDeath=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_VDeath01',Sound1=Sound'CreatureSFX.Drinen.C_Dri_VDeath02',NumSounds=2,slot=SLOT_Talk,Pitch=1,Volume=1.5,Radius=2)
     Whoosh=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_Whoosh01',Sound1=Sound'CreatureSFX.Drinen.C_Dri_Whoosh02',NumSounds=2,Pitch=1,Volume=1.5,Radius=1)
     EventFearSpot=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_VDamage01',Sound1=Sound'CreatureSFX.Drinen.C_Dri_VDamage02',Sound2=Sound'CreatureSFX.Drinen.C_Dri_VDamage03',NumSounds=3,Pitch=1,Volume=1,Radius=1)
     SpinA=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_StaffSpin01',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     SpinB=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_StaffSpin02',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     FleshSlice=(Sound0=Sound'Impacts.GoreSpecific.E_Imp_FleshSlice02',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     HeadShot=(Sound0=Sound'Impacts.GoreSpecific.E_Imp_Headshot',NumSounds=1,Pitch=1,Volume=1,Radius=1)
     Teleport=(Sound0=Sound'CreatureSFX.Drinen.C_Dri_Teleport01',NumSounds=1,Pitch=1,Volume=1,Radius=4)
}
