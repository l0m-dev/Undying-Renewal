//=============================================================================
// SPSpeargun.
//=============================================================================
class SPSpeargun expands SPWeapon;


//****************************************************************************
// New class functions.
//****************************************************************************

defaultproperties
{
     ProjClass=Class'Aeons.SPSpearProjectile'
     FireSound=Sound'Wpn_Spl_Inv.Weapons.E_Wpn_Speargunfire01'
     bReloadable=True
     ReloadTime=3.5
     ReloadCount=1
     SpoolUpTime=0.1
     Accuracy=1
     AimAnim=attack_speargun_aim
     RecoilAnim=attack_speargun_reload
     FireSoundRadius=6500
     DropClass=Class'Aeons.Speargun'
     PickupClass1=Class'Aeons.SpearAmmo'
     DrawType=DT_Mesh
     Mesh=SkelMesh'Aeons.Meshes.Speargun_Jemaas_m'
}
