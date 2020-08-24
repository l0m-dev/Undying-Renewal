//=============================================================================
// ScriptedBiped.
//=============================================================================
class ScriptedBiped expands ScriptedPawn
	abstract;

//****************************************************************************
// Import the base animations.
//****************************************************************************
//#exec MESH IMPORT MESH=BaseBiped_m SKELFILE=BaseBiped.ngf
//#exec MESH JOINTNAME Head=Hair Neck=Head

// Animation Notifys
//#exec MESH NOTIFY SEQ=flight_start TIME=1.00 FUNCTION=flight_cycle
//#exec MESH NOTIFY SEQ=flight_cycle TIME=1.00 FUNCTION=flight_cycle
//#exec MESH NOTIFY SEQ=jump_start TIME=0.500 FUNCTION=TriggerJump
//#exec MESH NOTIFY SEQ=jump_start TIME=1.000 FUNCTION=jump_cycle
//#exec MESH NOTIFY SEQ=death_powerword_cycle TIME=1.000 FUNCTION=death_powerword_cycle

//#exec MESH NOTIFY SEQ=crouch_walk TIME=0.225806 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=crouch_walk TIME=1.0 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_gun_back TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_gun_back TIME=0.32 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gun_back TIME=0.32 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gun_back TIME=0.4 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_gun_back TIME=0.4 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_gun_back TIME=0.56 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=death_gun_back TIME=0.56 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gun_face TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_gun_face TIME=0.131148 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_gun_face TIME=0.147541 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gun_face TIME=0.491803 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_gun_face TIME=0.491803 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_gun_face TIME=0.606557 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_gutshot TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_gutshot TIME=0.142857 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gutshot TIME=0.2 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gutshot TIME=0.257143 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=death_gutshot TIME=0.257143 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gutshot TIME=0.4 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_gutshot TIME=0.485714 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=death_gutshot TIME=0.485714 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gutshot TIME=0.514286 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_gutshot TIME=0.742857 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_gutshot TIME=0.742857 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_gun_left TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_gun_left TIME=0.0645161 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gun_left TIME=0.451613 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_gun_left TIME=0.451613 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_gun_left TIME=0.516129 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_gun_left TIME=0.612903 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_gun_left TIME=0.612903 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gun_right TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_gun_right TIME=0.05 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gun_right TIME=0.325 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_gun_right TIME=0.325 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_gun_right TIME=0.325 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_gun_right TIME=0.4 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gun_right TIME=0.625 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_powerword_cycle TIME=0.0967742 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_powerword_cycle TIME=0.483871 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_powerword_end TIME=0.0 FUNCTION=PlaySound_N ARG="VDeath PVar=0.2"
//#exec MESH NOTIFY SEQ=death_powerword_end TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_powerword_end TIME=0.193548 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_powerword_end TIME=0.193548 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_powerword_end TIME=0.290323 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_powerword_end TIME=0.290323 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_powerword_end TIME=0.451613 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_powerword_end TIME=0.645161 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_powerword_end TIME=0.645161 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_revolver TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_revolver TIME=0.16129 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_revolver TIME=0.612903 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_revolver TIME=0.612903 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_revolver TIME=0.709677 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=death_revolver TIME=0.709677 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_revolver TIME=0.806452 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_revolver TIME=0.806452 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=hunt TIME=0.000 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=hunt TIME=0.500 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=hunt_backwards TIME=0.169 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=hunt_backwards TIME=0.669 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=run_backwards TIME=0.3125 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=run_backwards TIME=0.8125 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=run TIME=0.1785 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=run TIME=0.6785 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=swim TIME=0.075 FUNCTION=PlaySound_N ARG="Swim PVar=0.2 V=0.6 VVar=0.2"
//#exec MESH NOTIFY SEQ=swim_idle TIME=0.0 FUNCTION=PlaySound_N ARG="Swim PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=swim_idle TIME=0.133333 FUNCTION=PlaySound_N ARG="Swim PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=swim_idle TIME=0.6 FUNCTION=PlaySound_N ARG="Swim PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=turn_180 TIME=0.075 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.25"
//#exec MESH NOTIFY SEQ=turn_180 TIME=0.1 FUNCTION=C_TurnStepLeft
//#exec MESH NOTIFY SEQ=turn_180 TIME=0.4 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.25"
//#exec MESH NOTIFY SEQ=turn_180 TIME=0.525 FUNCTION=C_TurnStepLeft
//#exec MESH NOTIFY SEQ=turn_left TIME=0.106061 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.25"
//#exec MESH NOTIFY SEQ=turn_left TIME=0.272727 FUNCTION=C_TurnStepLeft
//#exec MESH NOTIFY SEQ=turn_left TIME=0.515152 FUNCTION=C_TurnStepRight
//#exec MESH NOTIFY SEQ=turn_left TIME=0.590909 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.25"
//#exec MESH NOTIFY SEQ=turn_left TIME=0.742424 FUNCTION=C_TurnStepLeft
//#exec MESH NOTIFY SEQ=turn_right TIME=0.133333 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.25"
//#exec MESH NOTIFY SEQ=turn_right TIME=0.288889 FUNCTION=C_TurnStepRight
//#exec MESH NOTIFY SEQ=turn_right TIME=0.488889 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.25"
//#exec MESH NOTIFY SEQ=turn_right TIME=0.622222 FUNCTION=C_TurnStepRight
//#exec MESH NOTIFY SEQ=walk_backwards TIME=0.2985 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=walk_backwards TIME=0.7985 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=walk TIME=0.105 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=walk TIME=0.605 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=jump_end TIME=0.471 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=jump_end TIME=0.588 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=jump_start TIME=0.500 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=jump_start TIME=0.500 FUNCTION=C_BackRight

// Gore decal spawning notifications.
//#exec MESH NOTIFY SEQ=death_gun_left TIME=0.452 FUNCTION=SpawnGoreDecal
//#exec MESH NOTIFY SEQ=death_gun_back TIME=0.350 FUNCTION=SpawnGoreDecal


//****************************************************************************
// Import the player animations.
//****************************************************************************
//#exec MESH IMPORT MESH=PlayerBase_m SKELFILE=PlayerBase\PlayerBase.ngf INHERIT=BaseBiped_m
//#exec MESH JOINTNAME Head=Hair Neck=Head

// Animation Notifys
//#exec MESH NOTIFY SEQ=crouch_strafe_left TIME=0.566667 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=crouch_strafe_left TIME=0.9 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=crouch_strafe_right TIME=0.387097 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=crouch_strafe_right TIME=0.935484 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=crouch_walk_backwards TIME=0.366667 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=crouch_walk_backwards TIME=1.0 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=strafe_left TIME=0.120 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=strafe_left TIME=0.620 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=strafe_right TIME=0.120 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=strafe_right TIME=0.620 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=walk TIME=0.105 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=walk TIME=0.605 FUNCTION=C_BackLeft


//****************************************************************************
// Import the NPC animations.
//****************************************************************************
//#exec MESH IMPORT MESH=ScriptedBiped_m SKELFILE=NPC\ScriptedBiped.ngf INHERIT=BaseBiped_m
//#exec MESH JOINTNAME Head=Hair Neck=Head

// Animation Notifys
//#exec MESH NOTIFY SEQ=attack_spell_start TIME=1.00 FUNCTION=attack_spell_cycle
//#exec MESH NOTIFY SEQ=attack_spell_cycle TIME=1.00 FUNCTION=attack_spell_cycle
//#exec MESH NOTIFY SEQ=tuck_roll TIME=0.100 FUNCTION=RollLeaped
//#exec MESH NOTIFY SEQ=tuck_roll TIME=0.545 FUNCTION=RollLanded
//#exec MESH NOTIFY SEQ=death_powerword_start TIME=1.000 FUNCTION=death_powerword_cycle
//#exec MESH NOTIFY SEQ=defense_spell TIME=0.806 FUNCTION=DefenseSpell
//#exec MESH NOTIFY SEQ=damage_fire TIME=0.0163934 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_fire TIME=0.131148 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_fire TIME=0.278689 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_fire TIME=0.42623 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_fire TIME=0.57377 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_fire TIME=0.721311 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_fire TIME=0.868852 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_mindshatter TIME=0.0 FUNCTION=PlaySound_N ARG="VDamage PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=damage_mindshatter TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=damage_mindshatter TIME=0.0983607 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=damage_mindshatter TIME=0.213115 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_mindshatter TIME=0.42623 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_mindshatter TIME=0.540984 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=damage_mindshatter TIME=0.57377 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.04 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.08 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.09 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.15 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.29 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.8"
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.6 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.77 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=damage_stun TIME=0.89 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_chargedspear TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_chargedspear TIME=0.0661157 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_chargedspear TIME=0.0991736 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_chargedspear TIME=0.330579 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_chargedspear TIME=0.330579 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_chargedspear TIME=0.512397 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_chargedspear TIME=0.520661 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_chargedspear TIME=0.53719 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_chargedspear TIME=0.53719 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_chargedspear TIME=0.652893 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_chargedspear TIME=0.669421 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_ectoplasm TIME=0.0 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_ectoplasm TIME=0.1 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_ectoplasm TIME=0.2 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_ectoplasm TIME=0.25 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_ectoplasm TIME=0.6125 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_ectoplasm TIME=0.6125 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_ectoplasm TIME=0.7 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_ectoplasm TIME=0.8125 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_ectoplasm TIME=0.85 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.0 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.133333 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.344444 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.344444 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.377778 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.377778 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.488889 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.555556 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.555556 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.611111 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.733333 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.777778 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=death_explosion_back TIME=0.777778 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_front TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_explosion_front TIME=0.116667 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_front TIME=0.133333 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_front TIME=0.233333 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_explosion_front TIME=0.233333 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_explosion_front TIME=0.466667 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_front TIME=0.516667 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_explosion_front TIME=0.566667 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_explosion_left TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_explosion_left TIME=0.322581 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_left TIME=0.387097 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_left TIME=0.483871 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_explosion_left TIME=0.483871 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_explosion_left TIME=0.741935 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_right TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_explosion_right TIME=0.0333333 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_right TIME=0.0333333 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_right TIME=0.288889 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_right TIME=0.288889 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_explosion_right TIME=0.322222 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_explosion_right TIME=0.322222 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_explosion_right TIME=0.477778 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_explosion_right TIME=0.477778 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_explosion_right TIME=0.566667 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_explosion_right TIME=0.688889 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_gun_backhead TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_gun_backhead TIME=0.188235 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gun_backhead TIME=0.458824 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=death_gun_backhead TIME=0.458824 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gun_backhead TIME=0.505882 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=death_gun_backhead TIME=0.529412 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_gun_backhead TIME=0.764706 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_gun_backhead TIME=0.764706 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_lightning TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_lightning TIME=0.0444444 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_lightning TIME=0.0777778 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_lightning TIME=0.266667 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_lightning TIME=0.288889 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=death_lightning TIME=0.288889 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_lightning TIME=0.5 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_lightning TIME=0.522222 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_lightning TIME=0.522222 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_lightning TIME=0.9 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_lightning TIME=0.9 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_powerword_start TIME=0.192308 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_shotgun TIME=0.0 FUNCTION=PlaySound_N ARG="ImpBone P=1.2 PVar=0.1"
//#exec MESH NOTIFY SEQ=death_shotgun TIME=0.0666667 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_shotgun TIME=0.133333 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_shotgun TIME=0.183333 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=death_shotgun TIME=0.316667 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=death_shotgun TIME=0.45 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=death_shotgun TIME=0.45 FUNCTION=PlaySound_N ARG="ImpBone P=0.7 PVar=0.1 VVar=0.1"
//#exec MESH NOTIFY SEQ=death_shotgun TIME=0.516667 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=death_shotgun TIME=0.55 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=death_shotgun TIME=0.583333 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=idle_activating TIME=0.225 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=idle_activating TIME=0.225 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=idle_giving TIME=0.666667 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=idle_giving TIME=0.666667 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=idle_sitting_chair TIME=0.131868 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=idle_sitting_chair TIME=0.263736 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=speaking_casual2 TIME=0.019802 FUNCTION=PlaySound_N ARG="SpeakCasual PVar=0.1"
//#exec MESH NOTIFY SEQ=speaking_casual3 TIME=0.019802 FUNCTION=PlaySound_N ARG="SpeakCasual PVar=0.1"
//#exec MESH NOTIFY SEQ=speaking_implore TIME=0.0434783 FUNCTION=PlaySound_N ARG="SpeakImp PVar=0.1"
//#exec MESH NOTIFY SEQ=speaking_implore TIME=0.23913 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=speaking_implore TIME=0.543478 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.25 VVar=0.1"
//#exec MESH NOTIFY SEQ=speaking_question1 TIME=0.0357143 FUNCTION=PlaySound_N ARG="SpeakQuest PVar=0.1"
//#exec MESH NOTIFY SEQ=speaking_question2 TIME=0.0263158 FUNCTION=PlaySound_N ARG="SpeakQuest PVar=0.1"
//#exec MESH NOTIFY SEQ=tuck_roll TIME=0.0 FUNCTION=PlaySound_N ARG="VEffort PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=tuck_roll TIME=0.0 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=tuck_roll TIME=0.0 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=tuck_roll TIME=0.244444 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=tuck_roll TIME=0.311111 FUNCTION=BFallSmall
//#exec MESH NOTIFY SEQ=tuck_roll TIME=0.311111 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=tuck_roll TIME=0.466667 FUNCTION=C_BackRight

// Gore decal spawning notifications.
//#exec MESH NOTIFY SEQ=death_gun_backhead TIME=0.775 FUNCTION=SpawnGoreDecal
//#exec MESH NOTIFY SEQ=death_lightning TIME=0.528 FUNCTION=SpawnGoreDecal


//****************************************************************************
// Import the Trsanti base animations.
//****************************************************************************
//#exec MESH IMPORT MESH=TrsantiBase_m SKELFILE=TrsantiBase\TrsantiBase.ngf INHERIT=ScriptedBiped_m
//#exec MESH JOINTNAME Head=Hair Neck=Head

// Animation Notifys
//#exec MESH NOTIFY SEQ=trip TIME=0.484 FUNCTION=SlowMovement
//#exec MESH NOTIFY SEQ=trip TIME=0.548 FUNCTION=SlowMovement
//#exec MESH NOTIFY SEQ=trip TIME=0.645 FUNCTION=TripLanded
//#exec MESH NOTIFY SEQ=draw_back TIME=0.400 FUNCTION=DrawWeaponBack
//#exec MESH NOTIFY SEQ=draw_left TIME=0.125 FUNCTION=DrawWeaponLeft
//#exec MESH NOTIFY SEQ=attack_throw TIME=0.486 FUNCTION=AttackThrow

//#exec MESH NOTIFY SEQ=attack_throw TIME=0.0 FUNCTION=PlaySound_N ARG="VEffort PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=attack_throw TIME=0.222222 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=attack_throw TIME=0.472222 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.111111 FUNCTION=PlaySound_N ARG="VEffort PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.135802 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.135802 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.382716 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=get_up TIME=0.469136 FUNCTION=PlaySound_N ARG="MvmtLight PVar=0.2 V=0.5 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.469136 FUNCTION=PlaySound_N ARG="MvmtHeavy PVar=0.2 V=0.4 VVar=0.2"
//#exec MESH NOTIFY SEQ=get_up TIME=0.567901 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=trip TIME=0.025641 FUNCTION=PlaySound_N ARG="VDamage PVar=0.2 VVar=0.1"
//#exec MESH NOTIFY SEQ=trip TIME=0.025641 FUNCTION=C_BackLeft
//#exec MESH NOTIFY SEQ=trip TIME=0.230769 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.2 V=0.8 VVar=0.2"
//#exec MESH NOTIFY SEQ=trip TIME=0.358974 FUNCTION=BFallBig
//#exec MESH NOTIFY SEQ=trip TIME=0.641026 FUNCTION=C_BackRight
//#exec MESH NOTIFY SEQ=trip TIME=0.692308 FUNCTION=C_BackLeft


//****************************************************************************
// Member vars.
//****************************************************************************
// Initial wait modes.
enum ESBWaitMode
{
	SBWAIT_Normal,
	SBWAIT_Working,
	SBWAIT_WorkingCrouched,
	SBWAIT_SittingOnGround,
	SBWAIT_SittingOnChair,
	SBWAIT_Speaking,
	SBWAIT_Responding
};

var() ESBWaitMode			WaitMode;			// Initial waiting mode.
var() float					WaitDelay;			// Delay between animation triggers.
var() float					WaitVariance;		// Delay variance.
var float					PWDeathTimer;		//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayStunDamage()
{
	PlayAnim( 'damage_stun', 1.50, MOVE_None );
}

function PlayMindshatterDamage()
{
	LoopAnim( 'damage_mindshatter',, MOVE_None );
}

function PlayRunOnFire()
{
	PlayRun();
	LoopAnim( 'damage_fire',, MOVE_Anim,,, 'spine2', false );
}

function PlayOnFireDamage()
{
	LoopAnim( 'damage_fire',, MOVE_None );
}

function PlayExplosionDeath( vector HitLocation )
{
	local vector	DVect;
	local vector	X, Y, Z;
	local float		DP;

	GetAxes( Rotation, X, Y, Z );
	DVect = HitLocation - Location;
	DP = Normal(DVect) dot X;

	if ( DP > 0.707 )
	{
		PlayAnim( 'death_explosion_front',, MOVE_Anim );
	}
	else if ( DP < -0.707 )
	{
		PlayAnim( 'death_explosion_back',, MOVE_Anim );
	}
	else
	{
		if ( ( Normal(DVect) dot Y ) < 0.0 )
		{
			PlayAnim( 'death_explosion_left',, MOVE_Anim );
		}
		else
		{
			PlayAnim( 'death_explosion_right',, MOVE_Anim );
		}
	}
}

// Play death animation, based on damage type.
function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	local vector	TraceLocation, HitNormal, End;
	local int		HitJoint;
	local vector	DVect;
	local float		DP;
	local bool		bHeadShot;
	local bool		bFromFront;
	local vector	X, Y, Z;

//	DebugInfoMessage( ".PlayDying(), MyKiller is " $ MyKiller.name $ ", damage name is " $ damage $ ", delta to HitLocation is " $ (HitLocation - Location) $ ", DInfo.Jointname is " $ DInfo.Jointname );
	// Determine damage type (based on "damage" parameter) and trigger appropriate animation.
	switch ( damage )
	{
		case 'fire':
		case 'electrical':
			PlayAnim( 'death_lightning' );
			break;
		case 'chargedspear':
			PlayAnim( 'death_chargedspear' );
			break;
		case 'ectoplasm':
			PlayAnim( 'death_ectoplasm' );
			break;
		case 'dyn_concussive':
		case 'skull_concussive':
		case 'sigil_concussive':
		case 'lbg_concussive':
		case 'phx_concussive':
			PlayExplosionDeath( HitLocation );
			break;
		case 'powerword':
			bNoBloodPool = true;
			PWDeathTimer = 2.0;
			PlayAnim( 'death_powerword_start' );
			break;
		case 'bullet':
		case 'pellet':
		case 'silverbullet':
		case 'spear':
			if ( MyKiller != none )
				DVect = MyKiller.Location - Location;
			else
				DVect = HitLocation - Location;
			DVect.Z = 0.0;
			GetAxes( Rotation, X, Y, Z );
			DP = X dot Normal(DVect);

			bHeadShot = ( DInfo.JointName == 'neck' ) || ( DInfo.JointName == 'head' ) || ( DInfo.JointName == 'spine3' ) || ( DInfo.JointName == 'hair1' ) ||
						( DInfo.JointName == 'hair1' ) || ( DInfo.JointName == 'hair2' ) || ( DInfo.JointName == 'hair3' ) || ( DInfo.JointName == 'hair4' ) || ( DInfo.JointName == 'hair5' ) ||
						( DInfo.JointName == 'l_ear' ) || ( DInfo.JointName == 'r_ear' ) ||
						( DInfo.JointName == 'r_ear1' ) || ( DInfo.JointName == 'r_ear2' ) || ( DInfo.JointName == 'r_ear3' ) ||
						( DInfo.JointName == 'l_ear1' ) || ( DInfo.JointName == 'l_ear2' ) || ( DInfo.JointName == 'l_ear3' ) ||
						( DInfo.JointName == 'jaw' ) || ( DInfo.JointName == 'mouth' );

			if ( bHeadShot )
			{
				if ( DP > 0.0 )
				{
					PlayAnim( 'death_gun_face' );
				}
				else
				{
					PlayAnim( 'death_gun_backhead' );
				}
			}
			else if ( DP > 0.707 )
			{
				if ( damage == 'pellet' )
				{
					PlayAnim( 'death_shotgun' );
				}
				else
				{
					PlayAnim( 'death_gutshot' );
				}
			}
			else if ( DP < -0.707 )
			{
				PlayAnim( 'death_gun_back' );
			}
			else
			{
				if ( ( DVect dot Y ) < 0.0 )
				{
					PlayAnim( 'death_gun_left' );
				}
				else
				{
					PlayAnim( 'death_gun_right' );
				}
			}
			break;
		case 'scythe':
		case 'scythedouble':
		case 'sphereofcold':
		case 'chargedsphereofcold':
		case 'creepingrot':
		default:
			switch ( Rand(4) )
			{
				case 0:
					PlayAnim( 'death_gun_backhead' );
					break;
				case 1:
					PlayAnim( 'death_gun_back' );
					break;
				case 2:
					PlayAnim( 'death_gun_left' );
					break;
				case 3:
					PlayAnim( 'death_lightning' );
					break;
			}
	}
}

// Play close-range attack animation.
function PlayNearAttack()
{
	PlayAnim( 'melee', 1.0 );
}

// Default taunt, for subclasses that might not have one.
function PlayTaunt()
{
}


//****************************************************************************
// Sound trigger functions.
//****************************************************************************
function PlaySoundDamage()
{
	PlaySound_P( "VDamage PVar=0.2 VVar=0.1" );
}

function PlaySoundDeath()
{
	PlaySound_P( "VDeath PVar=0.2" );
}

function C_TurnStepLeft()
{
	C_BackLeft();
}

function C_TurnStepRight()
{
	C_BackRight();
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreSetMovement()
{
	super.PreSetMovement();
	bCanSwim = true;
}


//****************************************************************************
// New class functions.
//****************************************************************************


//****************************************************************************
// Animation/audio notification handlers [SFX].
//****************************************************************************
function C_FS();

function PlaySoundFallImpact()
{
	local Texture	HitTexture;
	local int		Flags;

	HitTexture = TraceTexture( Location - vect(0,0,500), Location, Flags );
	if ( HitTexture != none )
	{
		PlayImpactSound( 1, HitTexture, 0, Location, 1.0, 800.0, 1.0 );
	}
}

function BFallBig()
{
	ImpactSoundClass = class'Aeons.BodyFallBImpactSoundSet';
	PlaySoundFallImpact();
}

function BFallSmall()
{
	ImpactSoundClass = class'Aeons.BodyFallSImpactSoundSet';
	PlaySoundFallImpact();
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AIWait
// wait for encounter at current location
//****************************************************************************
state AIWait
{
	// *** overridden functions ***
	function BeginState()
	{
		global.BeginState();
		Dispatch();
	}

	function CueNextEvent()
	{
		SetTimer( FVariant( WaitDelay, WaitVariance ), false );
	}

	// *** new (state only) functions ***
	function Dispatch()
	{
		switch ( WaitMode )
		{
			case SBWAIT_Working:
				GotoState( 'AIWaitWorking' );
				break;
			case SBWAIT_WorkingCrouched:
				GotoState( 'AIWaitWorkingCrouched' );
				break;
			case SBWAIT_SittingOnGround:
				GotoState( 'AIWaitSittingOnGround' );
				break;
			case SBWAIT_SittingOnChair:
				GotoState( 'AIWaitSittingOnChair' );
				break;
			case SBWAIT_Speaking:
				GotoState( 'AIWaitSpeaking' );
				break;
			case SBWAIT_Responding:
				GotoState( 'AIWaitResponding' );
				break;
		}
	}

} // state AIWait


//****************************************************************************
// AIWaitWorking
// wait for encounter at current location
//****************************************************************************
state AIWaitWorking expands AIWait
{
	// *** overridden functions ***
	function TriggerEvent()
	{
		switch ( Rand(8) )
		{
			case 0:
				PlayAnim( 'idle_giving' );
				break;
			case 1:
				PlayAnim( 'idle_activating' );
				break;
			default:
				PlayAnim( 'idle_working_standing' );
				break;
		}
	}

} // state AIWaitWorking


//****************************************************************************
// AIWaitWorkingCrouched
// wait for encounter at current location
//****************************************************************************
state AIWaitWorkingCrouched expands AIWait
{
	// *** ignored functions ***
	function PlayWaitAnim(){}

	// *** overridden functions ***
	function TriggerEvent()
	{
		switch ( Rand(8) )
		{
			default:
				PlayAnim( 'idle_working_crouch' );
				break;
		}
	}

} // state AIWaitWorkingCrouched


//****************************************************************************
// AIWaitSittingOnGround
// wait for encounter at current location
//****************************************************************************
state AIWaitSittingOnGround expands AIWait
{
	// *** ignored functions ***
	function PlayWaitAnim(){}

	// *** overridden functions ***
	function TriggerEvent()
	{
		PlayAnim( 'idle_sitting_crosslegged' );
	}

} // state AIWaitSittingOnGround


//****************************************************************************
// AIWaitSittingOnChair
// wait for encounter at current location
//****************************************************************************
state AIWaitSittingOnChair expands AIWait
{
	// *** ignored functions ***
	function PlayWaitAnim(){}

	// *** overridden functions ***
	function TriggerEvent()
	{
		PlayAnim( 'idle_sitting_chair' );
	}

} // state AIWaitSittingOnChair


//****************************************************************************
// AIWaitSpeaking
// wait for encounter at current location
//****************************************************************************
state AIWaitSpeaking expands AIWait
{
	// *** overridden functions ***
	function TriggerEvent()
	{
		switch ( Rand(7) )
		{
			case 0:
				PlayAnim( 'idle_giving' );
				break;
			case 1:
			case 2:
				PlayAnim( 'speaking_casual1' );
				break;
			case 3:
			case 4:
				PlayAnim( 'speaking_casual2' );
				break;
			case 5:
			case 6:
				PlayAnim( 'speaking_casual3' );
				break;
		}
	}

} // state AIWaitSpeaking


//****************************************************************************
// AIWaitResponding
// wait for encounter at current location
//****************************************************************************
state AIWaitResponding expands AIWait
{
	// *** overridden functions ***
	function TriggerEvent()
	{
		switch ( Rand(5) )
		{
			case 0:
				PlayAnim( 'idle_giving' );
				break;
			case 1:
			case 2:
				PlayAnim( 'speaking_question1' );
				break;
			case 3:
			case 4:
				PlayAnim( 'speaking_question2' );
				break;
		}
	}

} // state AIWaitResponding


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Tick( float DeltaTime )
	{
		if ( PWDeathTimer > 0.0 )
		{
			PWDeathTimer -= DeltaTime;
			if ( PWDeathTimer <= 0.0 )
				PlayAnim( 'death_powerword_end' );
		}
		super.Tick( DeltaTime );
	}

	// *** new (state only) functions ***

} // state Dying


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     WaitDelay=1
     WaitVariance=0.5
     JumpDownDistance=140
     bCanCrouch=True
     GroundSpeed=300
     AirSpeed=400
     MaxStepHeight=35
     BaseEyeHeight=40
     Mesh=SkelMesh'Aeons.Meshes.ScriptedBiped_m'
     CollisionRadius=17
     CollisionHeight=64
}
