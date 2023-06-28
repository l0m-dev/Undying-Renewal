//=============================================================================
// Monto.
//=============================================================================
class Monto expands ScriptedFlyer;

//#exec MESH IMPORT MESH=Monto_m SKELFILE=Monto.ngf
//#exec MESH MODIFIERS Cloth:Jello

//****************************************************************************
// Animation sequence notifications.
//****************************************************************************
//#exec MESH NOTIFY SEQ=attack_ranged_01_start TIME=1.000 FUNCTION=attack_ranged_01_cycle
//#exec MESH NOTIFY SEQ=attack_ranged_01_cycle TIME=1.000 FUNCTION=attack_ranged_01_cycle
//#exec MESH NOTIFY SEQ=attack_ranged_02_start TIME=1.000 FUNCTION=attack_ranged_02_cycle
//#exec MESH NOTIFY SEQ=attack_ranged_02_cycle TIME=1.000 FUNCTION=attack_ranged_02_cycle
//#exec MESH NOTIFY SEQ=attack_ranged_02_end TIME=0.300 FUNCTION=FireLightning
//#exec MESH NOTIFY SEQ=death_01_start TIME=1.000 FUNCTION=death_01_fall
//#exec MESH NOTIFY SEQ=death_01_fall TIME=1.000 FUNCTION=death_01_fall
//#exec MESH NOTIFY SEQ=death_02 TIME=1.000 FUNCTION=death_02
//#exec MESH NOTIFY SEQ=attack_melee_01 TIME=0.388 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_melee_01 TIME=0.408 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_melee_01 TIME=0.429 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_melee_01 TIME=0.449 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_melee_01 TIME=0.469 FUNCTION=DoNearDamage
//#exec MESH NOTIFY SEQ=attack_melee_02 TIME=0.306 FUNCTION=DoNearDamage2
//#exec MESH NOTIFY SEQ=attack_melee_02 TIME=0.327 FUNCTION=DoNearDamage2
//#exec MESH NOTIFY SEQ=attack_melee_02 TIME=0.347 FUNCTION=DoNearDamage2
//#exec MESH NOTIFY SEQ=attack_melee_02 TIME=0.367 FUNCTION=DoNearDamage2
//#exec MESH NOTIFY SEQ=death_creature_special TIME=0.540 FUNCTION=BitePlayer
//#exec MESH NOTIFY SEQ=death_creature_special TIME=1.000 FUNCTION=OJDidItAgain

//#exec MESH NOTIFY SEQ=Attack_Melee_01 TIME=0.0377358 FUNCTION=PlaySound_N ARG="VAttack PVar=0.15"
//#exec MESH NOTIFY SEQ=Attack_Melee_01 TIME=0.0943396 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee_01 TIME=0.150943 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee_01 TIME=0.150943 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee_01 TIME=0.150943 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=Attack_Melee_01 TIME=0.188679 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee_01 TIME=0.339623 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.15"
//#exec MESH NOTIFY SEQ=Attack_Melee_01 TIME=0.509434 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee_01 TIME=0.528302 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee_01 TIME=0.528302 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=Attack_Melee_01 TIME=0.566038 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee_02 TIME=0.0384615 FUNCTION=PlaySound_N ARG="VAttack PVar=0.15"
//#exec MESH NOTIFY SEQ=Attack_Melee_02 TIME=0.0769231 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee_02 TIME=0.0769231 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee_02 TIME=0.0769231 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=Attack_Melee_02 TIME=0.115385 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.15"
//#exec MESH NOTIFY SEQ=Attack_Melee_02 TIME=0.25 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee_02 TIME=0.384615 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee_02 TIME=0.461538 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Melee_02 TIME=0.461538 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Cycle TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Cycle TIME=0.0 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Cycle TIME=0.0322581 FUNCTION=PlaySound_N ARG="VAttack PVar=0.15"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Cycle TIME=0.0806452 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Cycle TIME=0.209677 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Cycle TIME=0.354839 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Cycle TIME=0.483871 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Cycle TIME=0.532258 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Cycle TIME=0.532258 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Cycle TIME=0.629032 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Cycle TIME=0.758065 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Cycle TIME=0.935484 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_End TIME=0.0 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_End TIME=0.0 FUNCTION=PlaySound_N ARG="VAttack2 PVar=0.15"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_End TIME=0.08 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.4 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_End TIME=0.36 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_End TIME=0.92 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_End TIME=0.92 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_End TIME=0.92 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Start TIME=0.105263 FUNCTION=PlaySound_N ARG="VAttack4 PVar=0.15"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Start TIME=0.368421 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.15"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Start TIME=0.421053 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Start TIME=0.578947 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Start TIME=0.578947 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Start TIME=0.578947 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=Attack_Ranged_01_Start TIME=0.0 FUNCTION=TrackLp
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Cycle TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Cycle TIME=0.0 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Cycle TIME=0.0322581 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.4 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Cycle TIME=0.129032 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Cycle TIME=0.177419 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Cycle TIME=0.532258 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Cycle TIME=0.532258 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Cycle TIME=0.532258 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Cycle TIME=0.774194 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_End TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_End TIME=0.0 FUNCTION=PlaySound_N ARG="VAttack2 PVar=0.15"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_End TIME=0.0 FUNCTION=PlaySound_N ARG="LightEnd"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_End TIME=0.0487805 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.4 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_End TIME=0.121951 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_End TIME=0.634146 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Start TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Start TIME=0.0 FUNCTION=PlaySound_N ARG="LightStart"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Start TIME=0.727273 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Start TIME=0.0 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Attack_Ranged_02_Start TIME=0.0 FUNCTION=LightLp
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.0322581 FUNCTION=PlaySound_N ARG="VDamage PVar=0.15"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.0645161 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.15"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.387097 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.419355 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.4 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.451613 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.483871 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.564516 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.596774 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Damage_Stun TIME=0.709677 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_End TIME=0.047619 FUNCTION=PlaySound_N ARG="VDeath PVar=0.15"
//#exec MESH NOTIFY SEQ=Death_01_End TIME=0.238095 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_End TIME=0.238095 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_End TIME=0.238095 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_End TIME=0.238095 FUNCTION=PlaySound_N ARG="Impact PVar=0.2"
//#exec MESH NOTIFY SEQ=Death_01_End TIME=0.714286 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=Death_01_Fall TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp CHANCE=0.4 PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.0 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.0206186 FUNCTION=PlaySound_N ARG="VDeath PVar=0.15"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.103093 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.134021 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.134021 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.340206 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.391753 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.7 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.525773 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.525773 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.628866 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.701031 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_01_Start TIME=0.896907 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_02 TIME=0.0 FUNCTION=PlaySound_N ARG="VDeath PVar=0.15"
//#exec MESH NOTIFY SEQ=Death_02 TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_02 TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_02 TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_02 TIME=0.0 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Death_02 TIME=0.0 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=Death_02 TIME=0.0 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=Death_02 TIME=0.0 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.15"
//#exec MESH NOTIFY SEQ=Death_02 TIME=0.0 FUNCTION=PlaySound_N ARG="Impact PVar=0.2"
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.0 FUNCTION=PlaySound_N ARG="Special"
//#exec MESH NOTIFY SEQ=Death_Creature_Special TIME=0.143 FUNCTION=PlaySound_N ARG="PatDeath"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.0434783 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.152174 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.521739 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.717391 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.717391 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt TIME=0.978261 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt_Backwards TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt_Backwards TIME=0.0434783 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt_Backwards TIME=0.282609 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt_Strafe_Left TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt_Strafe_Left TIME=0.130435 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt_Strafe_Left TIME=0.130435 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt_Strafe_Left TIME=0.543478 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt_Strafe_Right TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt_Strafe_Right TIME=0.282609 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt_Strafe_Right TIME=0.347826 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Hunt_Strafe_Right TIME=0.891304 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.0 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.0217391 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.130435 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.336957 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.336957 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.478261 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.5 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.554348 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.576087 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Alert TIME=0.652174 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Appear TIME=0.0425532 FUNCTION=PlaySound_N ARG="VAttack PVar=0.15"
//#exec MESH NOTIFY SEQ=Idle_Appear TIME=0.191489 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.15"
//#exec MESH NOTIFY SEQ=Idle_Appear TIME=0.212766 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Appear TIME=0.276596 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=Idle_Appear TIME=0.276596 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Appear TIME=0.468085 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Appear TIME=0.553191 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Appear TIME=0.638298 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Idle_Appear TIME=0.638298 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=Idle_Appear TIME=0.87234 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt02 TIME=0.0425532 FUNCTION=PlaySound_N ARG="VAttack PVar=0.15"
//#exec MESH NOTIFY SEQ=taunt02 TIME=0.0851064 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt02 TIME=0.148936 FUNCTION=PlaySound_N ARG="Whoosh PVar=0.15"
//#exec MESH NOTIFY SEQ=taunt02 TIME=0.170213 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt02 TIME=0.170213 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=taunt02 TIME=0.340426 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt02 TIME=0.361702 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt02 TIME=0.787234 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt02 TIME=0.851064 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt02 TIME=0.914894 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=taunt02 TIME=0.914894 FUNCTION=PlaySound_N ARG="Head PVar=0.2"
//#exec MESH NOTIFY SEQ=Turn_180 TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_180 TIME=0.0645161 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_180 TIME=0.290323 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_180 TIME=0.709677 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_180 TIME=0.83871 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_Left TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_Left TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_Left TIME=0.0625 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_Left TIME=0.34375 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_Left TIME=0.5625 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_Right TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_Right TIME=0.0 FUNCTION=PlaySound_N ARG="Slurp PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_Right TIME=0.0625 FUNCTION=PlaySound_N ARG="VIdle CHANCE=0.3 PVar=0.15 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_Right TIME=0.15625 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"
//#exec MESH NOTIFY SEQ=Turn_Right TIME=0.59375 FUNCTION=PlaySound_N ARG="Click PVar=0.2 V=0.9 VVar=0.1"


//****************************************************************************
// Structure defs.
//****************************************************************************
enum EMontoState
{
	EMONTO_None,
	EMONTO_TractorBeam,
	EMONTO_EnergyBlast
};

enum EMontoPFXState
{
	EMONTO_SeekOrbit,
	EMONTO_Orbit,
	EMONTO_Attack
};

struct MontoPFXInfo
{
	var() ParticleFX		PFX;				//
	var() rotator			Rotation;			//
	var() rotator			RotationRate;		//
	var() float				OrbitDistance;		//
	var() float				OrbitHeight;		//
	var vector				Location;			//
	var vector				TargetLocation;		//
	var float				Velocity;			//
	var EMontoPFXState		State;				//
};


//****************************************************************************
// Member vars.
//****************************************************************************
var() float					DodgeDistance;		// TEMP for tweaking
var() vector				TractorBeamOffset;	//
var() vector				EnergyBlastOffset;	//
var EMontoState				SubState;			//
var ParticleFX				MontoFX;			//
var vector					MontoFXOffset;		//
var TractorBeam				MontoBeam;			//
var MontoPFXInfo			BlastFX[10];		//
var() int					RotateSpeed[6];		//
var int						PFXCount;			//
var() bool					bLightning;			//
var() float					LightningRange;		//
var int						SoundID;			//


//****************************************************************************
// Animation trigger functions.
//****************************************************************************
function PlayNearAttack()
{
	if ( FRand() < 0.50 )
		PlayAnim( 'attack_melee_01' );
	else
		PlayAnim( 'attack_melee_02' );
}

function PlayFarAttack()
{
	PlayAnim( 'attack_ranged_02_start' );
}

function PlayTaunt()
{
	PlayAnim( 'taunt02' );
}

function PlayDying( name damage, vector HitLocation, DamageInfo DInfo )
{
	PlayAnim( 'death_01_start' );
//	PlayAnim( 'death_02' );
}

function PlayStunDamage()
{
	PlayAnim( 'damage_stun' );
}

function PlaySpecialKill()
{
	PlayAnim( 'death_creature_special' );
}

function PlayMindshatterDamage()
{
	LoopAnim( 'damage_stun' );
}


//****************************************************************************
// Sound trigger functions.
//****************************************************************************
function PlaySoundDamage()
{
	PlaySound_P( "VDamage PVar=0.15" );
}

function PlaySoundDeath()
{
	PlaySound_P( "VDeath PVar=0.15" );
}


//****************************************************************************
// Inherited functions.
//****************************************************************************
function PreBeginPlay()
{
	super.PreBeginPlay();
	MontoBeam = Spawn( class'MontoTractorBeam', self,, Location );
	if ( MontoBeam != none )
		MontoBeam.SetBase( self );
//	SetLimbTangible( 'root', false );
	if (RGC())
	{
		AirSpeed = 350;
	}
}

function Destroyed()
{
	if ( MontoBeam != none )
	{
		MontoBeam.Destroy();
		MontoBeam = none;
	}

	super.Destroyed();
}

function bool NearStrikeValid( actor Victim, int DamageNum )
{
	if ( DamageNum == 1 )
		return JointStrikeValid( Victim, 'r_middle1', DamageRadius );
	else
		return JointStrikeValid( Victim, 'l_middle1', DamageRadius );
}

function bool FlankEnemy()
{
	return false;
}

function vector FlankPosition( vector target )
{
	return target;
}

function Tick( float DeltaTime )
{
	local int	lp;

	super.Tick( DeltaTime );
	if ( SubState == EMONTO_TractorBeam )
	{
		if ( MontoFX != none )
			MontoFX.SetLocation( LocalToWorld( MontoFXOffset ) );
	}
	else if ( SubState == EMONTO_EnergyBlast )
	{
		for ( lp=0; lp<ArrayCount(BlastFX); lp++ )
		{
			if ( BlastFX[lp].PFX != none )
			{
				switch ( BlastFX[lp].State )
				{
					case EMONTO_SeekOrbit:
						UpdateOrbit( BlastFX[lp], DeltaTime, false );
						if ( UpdateSeek( BlastFX[lp], DeltaTime ) )
							BlastFX[lp].State = EMONTO_Orbit;
						break;
					case EMONTO_Orbit:
						UpdateOrbit( BlastFX[lp], DeltaTime, true );
						break;
				}

				BlastFX[lp].PFX.SetLocation( BlastFX[lp].Location );
				BlastFX[lp].PFX.SetRotation( BlastFX[lp].Rotation );
			}
		}
	}
}

function bool AcknowledgeDamageFrom( pawn Damager )
{
	if ( Damager != none )
		return Damager.bIsPlayer;
	else
		return false;
}

function bool DoFarAttack()
{
	if ( EyesCanSee( Enemy.Location ) )
		return super.DoFarAttack();
	else
		return false;
}

function TakeMindshatter( pawn Instigator, int castingLevel )
{
}

function vector GetTotalPhysicalEffect( float DeltaTime )
{
	return vect(0,0,0);
}

function DamageInfo AdjustDamageByLocation ( DamageInfo DInfo )
{
	return DInfo;
}


//****************************************************************************
// New class functions.
//****************************************************************************
function MakeEffect( class<ParticleFX> FXClass, vector Offset )
{
	KillEffect();
	MontoFXOffset = Offset;
	MontoFX = Spawn( FXClass, self,, LocalToWorld( MontoFXOffset ) );
}

function KillEffect()
{
	if ( MontoFX != none )
	{
		MontoFX.Destroy();
		MontoFX = none;
	}
}

function BeamOn()
{
	if ( MontoBeam != none )
		MontoBeam.bIsActive = true;
}

function BeamOff()
{
	if ( MontoBeam != none )
		MontoBeam.bIsActive = false;
}

function vector PFXWorldLocation( MontoPFXInfo ThisPFX )
{
	return LocalToWorld( vector(ThisPFX.Rotation) * ThisPFX.OrbitDistance ) + vect(0,0,1) * ThisPFX.OrbitHeight;
}

function UpdateOrbit( out MontoPFXInfo ThisPFX, float DeltaTime, bool bUpdateLoc )
{
	ThisPFX.Rotation.Yaw += ThisPFX.RotationRate.Yaw * DeltaTime;
	ThisPFX.Rotation.Pitch += ThisPFX.RotationRate.Pitch * DeltaTime;
	if ( bUpdateLoc )
		ThisPFX.Location = PFXWorldLocation( ThisPFX );	//LocalToWorld( vector(ThisPFX.Rotation) * ThisPFX.OrbitDistance ) + vect(0,0,1) * ThisPFX.OrbitHeight;
}

function bool UpdateSeek( out MontoPFXInfo ThisPFX, float DeltaTime )
{
	local vector	DVect;

	ThisPFX.TargetLocation = PFXWorldLocation( ThisPFX );
	DVect = ThisPFX.TargetLocation - ThisPFX.Location;
	ThisPFX.Location += Normal(DVect) * 250.0 * DeltaTime;
	if ( VSize(DVect) < 10.0 )
		return true;
	return false;
}


//****************************************************************************
//****************************************************************************
// State code.
//****************************************************************************
//****************************************************************************

//****************************************************************************
// AIFarAttackAnim
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIFarAttackAnim
{
	// *** ignored functions ***

	// *** overridden functions ***

	// *** new (state only) functions ***

BEGIN:
	StopTimer();
	if ( FRand() < 0.50 )	//&& ( PlayerPawn(Enemy) != none ) )
		GotoState( 'AITractorBeam' );
	else
		GotoState( 'AIEnergyBlast' );
} // state AIFarAttackAnim


//****************************************************************************
// AITractorBeam
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AITractorBeam expands AIFarAttackAnim
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		SubState = EMONTO_TractorBeam;
		SoundID = 0;
	}

	function EndState()
	{
		super.EndState();
		SubState = EMONTO_None;
		BeamOff();
		KillEffect();
		AmbientSound = none;
	}

	function Timer()
	{
		GotoState( , 'TIMER' );
	}

	function Tick( float DeltaTime )
	{
		super.Tick( DeltaTime );
	}

	// *** new (state only) functions ***
	function TrackLp()
	{
		local SoundContainer.CreatureSoundGroup		SGroup;

		SGroup = class'MontoSoundSet'.default.TrackLp;
		AmbientSound = SGroup.Sound0;
	}


// Default entry point.
BEGIN:
	StopMovement();
	TurnToward( Enemy, 10 * DEGREES );
	PlayAnim( 'attack_ranged_01_start',, MOVE_None );
	TrackLp();
	MakeEffect( class'MontoTractorBeamFX', TractorBeamOffset );
	BeamOn();
	SetTimer( 5.0, false );

TURRET:
	if ( DistanceTo( Enemy ) < MeleeRange )
		GotoState( 'AINearAttack' );
	TurnToward( Enemy, 10 * DEGREES );
	Sleep( 0.10 );
	goto 'TURRET';

TIMER:
	KillEffect();
	BeamOff();
	PlayAnim( 'attack_ranged_01_end',, MOVE_None );
	FinishAnim();
	GotoState( 'AIAttack' );
} // state AITractorBeam


//****************************************************************************
// AIEnergyBlast
// Attack far enemy with animation (projectile, non-weapon).
//****************************************************************************
state AIEnergyBlast expands AIFarAttackAnim
{
	// *** ignored functions ***

	// *** overridden functions ***
	function BeginState()
	{
		DebugBeginState();
		SubState = EMONTO_EnergyBlast;
		SoundID = 0;
	}

	function EndState()
	{
		super.EndState();
		KillFX();
		SubState = EMONTO_None;
		AmbientSound = none;
	}

	function Timer()
	{
		if ( PFXCount < ArrayCount(BlastFX) )
		{
			MakePFX( PFXCount );
			PFXCount++;
			if ( PFXCount == ArrayCount(BlastFX) )
				SetTimer( FVariant( 0.75, 0.25 ), false );
			else
				SetTimer( FVariant( 0.10, 0.05 ), false );
		}
		else
			GotoState( , 'TIMER' );
	}

	// *** new (state only) functions ***
	function MakePFX( int Which )
	{
		BlastFX[Which].PFX = Spawn( class'MontoEnergyBlastFX', self,, LocalToWorld( EnergyBlastOffset * DrawScale ) );
		if ( BlastFX[Which].PFX != none )
		{
			BlastFX[Which].PFX.DrawScale = DrawScale;
			BlastFX[Which].OrbitDistance = FVariant( 100.0, 20.0 ) * DrawScale;
			BlastFX[Which].OrbitHeight = FVariant( 150.0, 60.0 ) * DrawScale;
			BlastFX[Which].Rotation.Yaw = 16000 - Rand(32000);
			BlastFX[Which].RotationRate.Yaw = RotateSpeed[Rand(ArrayCount(RotateSpeed))];
			BlastFX[Which].Location = LocalToWorld( EnergyBlastOffset * DrawScale );
			BlastFX[Which].State = EMONTO_SeekOrbit;
		}
	}

	function KillFX()
	{
		local int				lp;

		for ( lp=0; lp<ArrayCount(BlastFX); lp++ )
		{
			if ( BlastFX[lp].PFX != none )
			{
				BlastFX[lp].PFX.bShuttingDown = true;
				BlastFX[lp].PFX = none;
			}
		}
	}

	function FireFrom( vector StartLoc )
	{
		local vector			X, Y, Z;
		local vector			TDir;
		local LtngBlast_proj	LB;

		GetAxes( Rotation, X, Y, Z );
		StartLoc = StartLoc + X * 50.0;
		TDir = vector(WeaponAimAt( Enemy, StartLoc, WeaponAccuracy, true, 3000 ));
		LB = Spawn( class'LtngBlast_proj', self,, StartLoc, rotator(TDir) );
		if ( LB != none )
		{
			LB.CastingLevel = 1;
			LB.StartLoc = StartLoc;
			LB.Charge = 1;
		}
	}

	function FireLightning()
	{
		if ( bLightning )
		{
			FireFrom( JointPlace('l_lowerarm').pos );
			FireFrom( JointPlace('r_lowerarm').pos );
			AmbientSound = none;
			PlaySound_P( "LightFire" );
		}
	}

	function LightLp()
	{
		local SoundContainer.CreatureSoundGroup		SGroup;

		SGroup = class'MontoSoundSet'.default.LightLp;
		AmbientSound = SGroup.Sound0;
	}


// Default entry point.
BEGIN:
	StopMovement();
	TurnToward( Enemy, 10 * DEGREES );
	PlayAnim( 'attack_ranged_02_start',, MOVE_None );
	LightLp();
	PFXCount = 0;
	SetTimer( FVariant( 0.10, 0.05 ), false );

TURRET:
	if ( DistanceTo( Enemy ) < MeleeRange )
		GotoState( 'AINearAttack' );
	TurnToward( Enemy, 10 * DEGREES );
	Sleep( 0.10 );
	goto 'TURRET';

TIMER:
	KillFX();
	PlayAnim( 'attack_ranged_02_end',, MOVE_None );
	FinishAnim();
	GotoState( 'AIAttack' );
} // state AIEnergyBlast


//****************************************************************************
// AICantReachEnemy
// can see, but can't reach Enemy
//****************************************************************************
state AICantReachEnemy
{
	// *** ignored functions ***
	function EnemyNotVisible(){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}

	// *** overridden functions ***
	function BeginState()
	{
		super.BeginState();
		StopTimer();
	}

	// *** new (state only) functions ***
	function NavigationPoint FindAttackPoint( vector thisLoc )
	{
		local NavigationPoint	BestPoint, aPoint;
		local float				MinDist;
		local float				pDist;

		BestPoint = none;
		foreach AllActors( class'NavigationPoint', aPoint )
		{
			if ( FastTrace( aPoint.Location, thisLoc ) &&
				 ( PathDistanceTo( aPoint ) > 0.0 ) )
			{
				pDist = VSize(aPoint.Location - thisLoc);
				if ( ( BestPoint == none ) || ( pDist < MinDist) )
				{
					BestPoint = aPoint;
					MinDist = pDist;
				}
			}
		}
		return BestPoint;
	}

	// Check if point is a good attack point.
	function bool GoodAttackPoint( NavigationPoint cPoint )
	{
		// Override to impose stricter rules, like the commented rule below.
//		if ( EnemyCanSee( cPoint.Location ) || EnemyCanSee( cPoint.Location + vect(0,0,1) * CollisionHeight ) )
//			return false;
//		if ( VSize(cPoint.Location - Enemy.Location) < ( SafeDistance * 1.20 ) )
//			return false;
		return true;
	}


// Entry point when returning from AITakeDamage
DAMAGED:
	TookDamage( SensedActor );

// Entry point when resuming this state
RESUME:
DODGED:

// Default entry point
BEGIN:
	TargetActor = FindAmbushWhenLost( Enemy.Location );
	if ( ( TargetActor != none ) && ( !CloseToPoint( TargetActor.Location, 2.0 ) ) )
	{
		DebugInfoMessage( ".AICantReachEnemy, FindAmbushWhenLost() found " $ TargetActor.name $ " as reachable ambush point" );
		goto 'AMBUSH';
	}

	TargetActor = FindAttackPoint( Enemy.Location );
	if ( TargetActor != none )
	{
		PlayRun();
GOTOPT:
		if ( actorReachable( TargetActor ) )
		{
			MoveToward( TargetActor, FullSpeedScale );
		}
		else
		{
			PathObject = PathToward( TargetActor );
			if ( PathObject != none )
			{
				MoveToward( PathObject, FullSpeedScale );
				goto 'GOTOPT';
			}
		}
		PlayWait();
		StopMovement();
	}
	else
	{
		PlayTaunt();
		FinishAnim();
		PlayWait();
	}
	GotoState( 'AIAttack' );
} // state AICantReachEnemy


//****************************************************************************
// AISpecialKill
//****************************************************************************
state AISpecialKill
{
	// *** overridden functions ***
	function PostSpecialKill()
	{
		TargetActor = SK_TargetPawn;
		GotoState( 'AIDance', 'DANCE' );
		SK_TargetPawn.GotoState( 'SpecialKill', 'SpecialKillComplete' );
	}

	function StartSequence()
	{
		GotoState( , 'MONTOSTART' );
	}

	// *** new (state only) functions ***
	function BitePlayer()
	{
		local vector	DVect;
		local int		lp;
		local actor		Blood;

		DVect = SK_TargetPawn.JointPlace('head').pos;
		for ( lp = 0; lp < 2; lp++ )
			Spawn( class'Aeons.WeakGibBits',,, DVect, rotator(VRand()) );
		Blood = Spawn( class'Aeons.BloodParticles',,, DVect, SK_TargetPawn.Rotation );
		Blood.SetBase( SK_TargetPawn, 'head', 'root');
		SK_TargetPawn.Decapitate();
	}

	function OJDidItAgain()
	{
		PlayerBleedOutFromJoint( 'neck' );
	}


MONTOSTART:
	NoLook();
	DebugDistance( "before anim" );
	SK_TargetPawn.PlayAnim( 'monto_death', [TweenTime] 0.0 );
	PlayAnim( 'death_creature_special', [TweenTime] 0.0 );
	FinishAnim();
	goto 'LOST';

} // state AISpecialKill


//****************************************************************************
// Dying (override base class implementation)
// handle death (take it!)
//****************************************************************************
state Dying
{
	// *** ignored functions ***

	// *** overridden functions ***
	function Landed( vector hitNormal )
	{
		DebugInfoMessage( ".Dying.Landed()" );
		PlayAnim( 'death_01_end' );
	}

	function PostAnim()
	{
		SetCollision( InitCollideActors, InitBlockActors, InitBlockPlayers );
	}

} // state Dying


//****************************************************************************
// AISpawn
// The Monto spawns in a lightning bolt
//****************************************************************************
auto state AISpawn
{
	// *** ignored functions ***
	function Bump( actor Other ){}
	function EffectorSeePlayer( actor sensed ){}
	function EffectorHearNoise( actor sensed ){}
	function SeeHatedPawn( pawn aPawn ){}
	function HearNoise( float Loudness, actor NoiseMaker ){}
	function SeePlayer( actor Other ){}
	function WarnTarget( pawn Other, float projSpeed, vector FireDir ){}
	function EffectorWarnTarget( vector shotLocation, float projSpeed, vector FireDir ){}
	function Falling(){}
	function Landed( vector hitNormal ){}
	function HitWall( vector hitNormal, actor hitWall, byte textureID ){}
	function ZoneChange( ZoneInfo newZone ){}
	function EnemyNotVisible(){}
	function TakeDamage( Pawn Instigator, vector HitLocation, vector Momentum, DamageInfo DInfo ){}
	function Trigger( actor Other, pawn EventInstigator ){}

	// *** overridden functions ***
	function Timer()
	{
		local PlayerPawn	P;

		OpacityEffector.SetFade( 1.0, 1.0 );

		// find the player.
		foreach AllActors( class'PlayerPawn', P )
		{
			if ( P.bIsPlayer )
				break;
		}

		if ( ( P != none ) && P.CanSee( self ) )
		{
			P.ClientFlash( 1, vect(1000, 1000, 1000) );
			GotoState( 'AIAttackPlayer' );
		}
		else
		{
			GotoState( 'AIWait' );
		}
	}

	function BeginState()
	{
		local int			i;
		local vector		Loc, Start, End;
		local LightningBolt	lb;

		DebugBeginState();
		for ( i=0; i<8; i++ )
		{
			Loc = Location + ( VRand() * 512 * DrawScale );

			Start = Loc;
			End = Location;

			lb = Spawn( class'MontoLightningBolt',,, Location );
			lb.start = Start;
			lb.end = End;
			lb.Init( 1, Start, End );
		}
	}

BEGIN:
	PlaySound_P( "Spawn" );
	ClearAnims();
	Opacity = 0;
	SetTimer( 1, false );

} // state AISpawn


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     DodgeDistance=125
     TractorBeamOffset=(X=40)
     EnergyBlastOffset=(X=40,Z=-15)
     RotateSpeed(0)=20000
     RotateSpeed(1)=32000
     RotateSpeed(2)=40000
     RotateSpeed(3)=-20000
     RotateSpeed(4)=-32000
     RotateSpeed(5)=-40000
     bLightning=True
     LightningRange=2000
     HoverAltitude=200
     HoverVariance=70
     HoverRadius=10
     bCanHover=True
     WaitGlideScalar=0.3
     bNoSeekHeight=True
     bNoDeathSpin=True
     SafeDistance=640
     LongRangeDistance=1500
     Aggressiveness=1
     bHasFarAttack=True
     MeleeInfo(0)=(Damage=50,EffectStrength=0.65,Method=RipSlice)
     MeleeInfo(1)=(Damage=50,EffectStrength=0.65,Method=RipSlice)
     WeaponAccuracy=0.8
     DamageRadius=75
     SK_PlayerOffset=(X=140,Z=85)
     bHasSpecialKill=True
     SK_WalkDelay=12
     HearingEffectorThreshold=0.4
     VisionEffectorThreshold=0.4
     WalkSpeedScale=0.3
     bGiveScytheHealth=True
     PhysicalScalar=0.5
     MagicalScalar=0.75
     FireScalar=0.25
     bCanStrafe=True
     MeleeRange=120
     AirSpeed=300
     MaxStepHeight=60
     SightRadius=3000
     PeripheralVision=0.25
     BaseEyeHeight=70
     Health=400
     SoundSet=Class'Aeons.MontoSoundSet'
     RotationRate=(Pitch=1000,Yaw=60000,Roll=0)
     Style=STY_Masked
     Mesh=SkelMesh'Aeons.Meshes.Monto_m'
     SoundRadius=40
     TransientSoundRadius=1500
     CollisionRadius=120
     CollisionHeight=120
     bGroundMesh=False
}
