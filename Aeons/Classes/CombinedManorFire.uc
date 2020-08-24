//=============================================================================
// CombinedManorFire.
//=============================================================================
class CombinedManorFire expands CombinedEffects;

defaultproperties
{
     EffectList(0)=(EffectClass=Class'Aeons.ManorGrandFireplace')
     EffectList(1)=(Offset=(Z=48),EffectClass=Class'Aeons.ManorFireplaceSmoke')
     EffectList(2)=(Offset=(Z=16),EffectClass=Class'Aeons.ManorFireplaceSparksFX')
     EffectList(3)=(EffectClass=Class'Aeons.ConflagationTrigger')
     SoundVolume=64
}
