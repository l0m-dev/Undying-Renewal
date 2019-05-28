//=============================================================================
// MonkArcher.
//=============================================================================
class MonkArcher expands MonkSoldier;

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************


//****************************************************************************
// Structure defs.
//****************************************************************************


//****************************************************************************
// Member vars.
//****************************************************************************


//****************************************************************************
// Animation trigger functions.
//****************************************************************************


//****************************************************************************
// Inherited functions.
//****************************************************************************


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     MyPropInfo(0)=(Prop=None)
     LongRangeDistance=1000
     SK_PlayerOffset=(X=100)
     bHasNearAttack=False
     bHasFarAttack=True
     WeaponClass=Class'Aeons.SPCrossbow'
     WeaponJoint=Handposition
     WeaponAttachJoint=Handle
     WeaponAccuracy=1.0
     FarAttackBias=1
}
