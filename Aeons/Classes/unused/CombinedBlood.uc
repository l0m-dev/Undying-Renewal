//=============================================================================
// CombinedBlood.
//=============================================================================
class CombinedBlood expands CombinedEffects;

defaultproperties
{
     bDeleteSelf=True
     EffectList(0)=(EffectClass=Class'Aeons.BloodImpactParticles')
     EffectList(1)=(EffectClass=Class'Aeons.BloodPuffFX')
     bAcceptDamage=False
}
