//=============================================================================
// ScryeSoldier.
//=============================================================================
class ScryeSoldier expands MonkSoldier;


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	local actor		A;

	super.PreBeginPlay();
	A = Spawn( class'ScryeSoldierHalo', self,, Location );
	if ( A == none )
		DebugInfoMessage( ".PreBeginPlay(), unable to spawn halo." );
}

function PlaySoundAlerted()
{
}

defaultproperties
{
     MeleeInfo(0)=(Damage=15,EffectStrength=0.2)
     bGiveScytheHealth=False
     PhysicalScalar=0
     ConcussiveScalar=0
     bIsEthereal=True
     Health=60
     PE_StabEffect=None
     PE_BiteEffect=None
     PE_BluntEffect=None
     PE_BulletEffect=None
     PE_BulletKilledEffect=None
     PE_RipSliceEffect=None
     PD_StabDecal=None
     PD_BiteDecal=None
     PD_BluntDecal=None
     PD_BulletDecal=None
     PD_RipSliceDecal=None
     PD_GenLargeDecal=None
     PD_GenMediumDecal=None
     PD_GenSmallDecal=None
     bScryeOnly=True
}
