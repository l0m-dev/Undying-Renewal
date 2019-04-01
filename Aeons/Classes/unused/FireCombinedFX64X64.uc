//=============================================================================
// FireCombinedFX64X64.
//=============================================================================
class FireCombinedFX64X64 expands CombinedEffects;

defaultproperties
{
     EffectList(0)=(EffectClass=Class'Aeons.Fireplace64X64')
     EffectList(1)=(Offset=(Z=32),EffectClass=Class'Aeons.FireplaceSmoke64X64')
     EffectList(2)=(Offset=(Z=16),EffectClass=Class'Aeons.FireSparksFX64X64')
     EffectList(3)=(EffectClass=Class'Aeons.ConflagationTrigger')
     Tag=64X64FireCombinedFX
     SoundRadius=24
     SoundRadiusInner=8
}
