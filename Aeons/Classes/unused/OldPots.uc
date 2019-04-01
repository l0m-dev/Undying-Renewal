//=============================================================================
// OldPots.
//=============================================================================
class OldPots expands Container
	abstract;

#exec OBJ LOAD FILE=\Aeons\Sounds\LevelMechanics.uax PACKAGE=LevelMechanics

function TakeDamage( Pawn EventInstigator, vector HitLocation, vector Momentum, DamageInfo DInfo)
{
	if ( EffectWhenDestroyed != none )
		Spawn(EffectWhenDestroyed,,,Location);
	Destroy();
}

defaultproperties
{
     EffectWhenDestroyed=Class'Aeons.CombinedPotBreakFX'
     bPushable=True
     PushSound=Sound'LevelMechanics.EternalAutumn.A14_VaseSlideLp'
     DestroySound(0)=Sound'LevelMechanics.EternalAutumn.A14_VaseCrash1'
     DestroySound(1)=Sound'LevelMechanics.EternalAutumn.A14_VaseCrash2'
     DestroySound(2)=Sound'LevelMechanics.EternalAutumn.A14_VaseCrash3'
     bStatic=False
     Physics=PHYS_Falling
     DrawType=DT_Mesh
     bCollideWorld=True
     bGroundMesh=False
     bBlockActors=True
     bBlockPlayers=True
     bProjTarget=True
}
