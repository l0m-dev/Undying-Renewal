//=============================================================================
// SPShotgun.
//=============================================================================
class SPShotgun expands SPWeapon;


//****************************************************************************
// Member vars.
//****************************************************************************
var(SPWeapon) int			NumPellets;			// Number of pellets fired in one shot.


//****************************************************************************
// Inherited member funcs.
//****************************************************************************
function Projectile FireProjectile()
{
	local int			i;
	local Projectile	P;

	for ( i=0; i<NumPellets; i++ )
	{
		P = super.FireProjectile();
		if ( ( P != none ) && ( i != 0 ) && ( SPPelletProjectile(P) != none ) )
			SPPelletProjectile(P).bMakeImpactSound = false;
	}
}


//****************************************************************************
// New class functions.
//****************************************************************************

defaultproperties
{
     numPellets=8
     ProjClass=Class'Aeons.SPPelletProjectile'
     RefireRate=1.2
     FireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_ShotFireReg01'
     bReloadable=True
     ReloadTime=3.75
     ReloadCount=2
     SpoolUpTime=0.1
     Accuracy=0.35
     AimAnim=attack_shotgun_idle
     RecoilAnim=attack_shotgun
     ReloadStartAnim=ReloadStart
     ReloadEndAnim=ReloadEnd
     FireSoundRadius=5000
     MuzzleFlashClass=Class'Aeons.RevolverMuzzleFlash'
     LightClass=Class'Aeons.RevolverWeaponLight'
     EffectClass=Class'Aeons.SmallShotgunSmokeFX'
     DropClass=Class'Aeons.Shotgun'
     PickupClass1=Class'Aeons.ShotgunAmmo'
     EffectOffset=(X=54)
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Shotgun3rd_m'
}
