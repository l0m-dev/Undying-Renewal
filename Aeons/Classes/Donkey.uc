//=============================================================================
// Donkey.
//=============================================================================
class Donkey expands Sheep;

//#exec MESH IMPORT MESH=DonkeyDead_m SKELFILE=Poses\DonkeyDead.ngf

//#exec MESH IMPORT MESH=Donkey_m SKELFILE=Donkey.ngf
//#exec MESH JOINTNAME Head=Neck Head1=Head


//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=graze TIME=0.450 FUNCTION=GrazeLoop	//

//#exec MESH NOTIFY SEQ=damage_stun TIME=0.04 FUNCTION=PlaySound_N ARG="Damage PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=death TIME=0.016129 FUNCTION=PlaySound_N ARG="Death PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=death TIME=0.451613 FUNCTION=PlaySound_N ARG="BodyFall PVar=0.2 V=0.6 VVar=0.1"
//#exec MESH NOTIFY SEQ=graze TIME=0.142857 FUNCTION=PlaySound_N ARG="Chewing CHANCE=0.25 PVar=0.2 V=0.35 VVar=0.2"
//#exec MESH NOTIFY SEQ=graze TIME=0.888889 FUNCTION=PlaySound_N ARG="Graze CHANCE=0.25 PVar=0.2 V=0.7 VVar=0.3"
//#exec MESH NOTIFY SEQ=graze_cycle TIME=0.03125 FUNCTION=PlaySound_N ARG="Chewing CHANCE=0.25 PVar=0.2 V=0.35 VVar=0.2"
//#exec MESH NOTIFY SEQ=graze_cycle TIME=0.03125 FUNCTION=PlaySound_N ARG="Graze CHANCE=0.25 PVar=0.2 V=0.7 VVar=0.3"
//#exec MESH NOTIFY SEQ=idle TIME=0.0333333 FUNCTION=PlaySound_N ARG="Graze CHANCE=0.25 PVar=0.2 V=0.7 VVar=0.3"
//#exec MESH NOTIFY SEQ=walk TIME=0.0344828 FUNCTION=PlaySound_N ARG="Hoof PVar=0.2 V=0.4 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=0.0689655 FUNCTION=PlaySound_N ARG="Hoof PVar=0.2 V=0.4 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=0.448276 FUNCTION=PlaySound_N ARG="Hoof PVar=0.2 V=0.4 VVar=0.1"
//#exec MESH NOTIFY SEQ=walk TIME=0.482759 FUNCTION=PlaySound_N ARG="Hoof PVar=0.2 V=0.4 VVar=0.1"


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
// Animation/audio notification handlers [SFX].
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
     HatedClass=Class'Aeons.BossHowler'
     bIsHated=True
     BaseEyeHeight=42
     Health=80
     SoundSet=Class'Aeons.DonkeySoundSet'
     Mesh=SkelMesh'Aeons.Meshes.Donkey_m'
     CollisionRadius=48
     CollisionHeight=48
}
