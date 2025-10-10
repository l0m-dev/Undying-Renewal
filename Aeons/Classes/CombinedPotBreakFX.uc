//=============================================================================
// CombinedPotBreakFX.
//=============================================================================
class CombinedPotBreakFX expands CombinedEffects;

#exec OBJ LOAD FILE=..\Sounds\LevelMechanics.uax PACKAGE=LevelMechanics

defaultproperties
{
     TriggeredSound=Sound'LevelMechanics.EternalAutumn.A14_VaseCrash2'
     EffectList(0)=(EffectClass=Class'Aeons.OldPotShatter')
     EffectList(1)=(EffectClass=Class'Aeons.OldPotDust')
}
