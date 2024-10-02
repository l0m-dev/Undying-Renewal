//=============================================================================
// SPMindshatter.
//=============================================================================
class SPMindshatter expands SPWeapon;

//****************************************************************************
// Member vars.
//****************************************************************************
var() int					ProjAmplitude;		//

function PreBeginPlay()
{
     if (RGC())
     {
          Accuracy = 1.0;
     }
     super.PreBeginPlay();
}

//****************************************************************************
// Inherited member funcs.
//****************************************************************************
function Projectile FireProjectile()
{
	local Projectile	P;

	P = super.FireProjectile();
	if ( SpellProjectile(P) != none )
		SpellProjectile(P).castingLevel = ProjAmplitude;

	return P;
}


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     ProjAmplitude=2
     ProjClass=Class'Aeons.Mindshatter_proj'
     FireSound=Sound'Wpn_Spl_Inv.Spells.E_Spl_MindLaunch01'
     bReloadable=True
     ReloadTime=5
     ReloadCount=1
     bIsMagical=True
     SpoolUpTime=0.75
     Accuracy=0.9
     AimAnim=Attack_Spell_Start
}
