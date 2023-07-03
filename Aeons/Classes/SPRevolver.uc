//=============================================================================
// SPRevolver.
//=============================================================================
class SPRevolver expands SPWeapon;

function PreBeginPlay()
{
	if (RGC())
		Accuracy = 1.0;
	super.PreBeginPlay();
}

//****************************************************************************
// New class functions.
//****************************************************************************

defaultproperties
{
     ProjClass=Class'Aeons.SPBulletProjectile'
     RefireRate=0.4
     FireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_RevFireReg01'
     bReloadable=True
     ReloadTime=2
     ReloadCount=6
     SpoolUpTime=0.1
     Accuracy=0.5
     AimAnim=attack_revolver_idle
     RecoilAnim=attack_revolver_cycle
     FireSoundRadius=5000
     MuzzleFlashClass=Class'Aeons.RevolverMuzzleFlash'
     LightClass=Class'Aeons.RevolverWeaponLight'
     EffectClass=Class'Aeons.SmallShotgunSmokeFX'
     DropClass=Class'Aeons.Revolver'
     PickupClass1=Class'Aeons.BulletAmmo'
     EffectOffset=(X=18)
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Revolver3rd_m'
     DrawScale=0.9
}
