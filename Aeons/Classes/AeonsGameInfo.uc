//=============================================================================
// AeonsGameInfo.
// default game info is normal single player
//=============================================================================
class AeonsGameInfo expands GameInfo;

//#exec AUDIO IMPORT FILE="Sounds\Generic\land1.WAV" NAME="Land1" GROUP="Generic"
//#exec AUDIO IMPORT FILE="Sounds\Generic\lsplash.WAV" NAME="LSplash" GROUP="Generic"
//#exec AUDIO IMPORT FILE="Sounds\pickups\genwep1.WAV" NAME="WeaponPickup" GROUP="Pickups"
//#exec AUDIO IMPORT FILE="Sounds\Generic\teleport1.WAV" NAME="Teleport1" GROUP="Generic"

var(DeathMessage) localized string DeathMessage[32];    // Player name, or blank if none.
var(DeathMessage) localized string DeathModifier[5];
var(DeathMessage) localized string MajorDeathMessage[8];
var(DeathMessage) localized string HeadLossMessage[2];
var(DeathMessage) localized string DeathVerb;
var(DeathMessage) localized string DeathPrep;
var(DeathMessage) localized string DeathTerm;
var(DeathMessage) localized string ExplodeMessage;
var(DeathMessage) localized string SuicideMessage;
var(DeathMessage) localized string FallMessage;
var(DeathMessage) localized string DrownedMessage;
var(DeathMessage) localized string BurnedMessage;
var(DeathMessage) localized string ElectrocutedMessage;
var(DeathMessage) localized string CrushedMessage;
var(DeathMessage) localized string StompedMessage;
var(DeathMessage) localized string HackedMessage;

var localized string GlobalNameChange;
var localized string NoNameChange;

var CutsceneManager CutsceneManager;

// left for compatibility with family grave
function int ReduceDamage( int Damage, name DamageType, pawn injured, pawn instigatedBy )
{
	return Super.ReduceDamage(Damage, DamageType, injured, instigatedBy);
}

/*
function int ReduceDamage(int Damage, name DamageType, pawn injured, pawn instigatedBy)
{
	if (injured.Region.Zone.bNeutralZone)
		return 0;

	if ( instigatedBy == None)
		return Damage;
	//skill level modification
	if ( instigatedBy.bIsPlayer )
	{
		if ( injured == instigatedby )
		{ 
			if ( instigatedby.skill == 0 )
				Damage = 0.25 * Damage;
			else if ( instigatedby.skill == 1 )
				Damage = 0.5 * Damage;
		}
		else if ( !injured.bIsPlayer )
			Damage = float(Damage) * (1.1 - 0.1 * injured.skill);
	}
	else if ( injured.bIsPlayer )
		Damage = Damage * (0.4 + 0.2 * instigatedBy.skill);d
	return (Damage * instigatedBy.DamageScaling);
}
*/

function PreBeginPlay()
{
	Super.PreBeginPlay();

	CutsceneManager = class'CutsceneManager'.static.GetCutsceneManager(Level);
}

function CutsceneManagerPlayerLogin(PlayerPawn Player, bool bCutSceneStartSpot)
{
	CutsceneManager.PlayerLogin(Player, bCutSceneStartSpot);
}

function CutsceneManagerPlayerLogout(PlayerPawn Player)
{
	CutsceneManager.PlayerLogout(Player);
}

exec function AdminSay(string Msg)
{
	ServerSay(Msg);
}

function ServerSay(string Msg)
{
	local Patrick P;

	ForEach AllActors(class 'Patrick', P)
	{
		P.ScreenMessage(Msg, 3.0, True);
	}
}

function float PlaySpawnEffect(inventory Inv)
{
	//spawn( class 'ReSpawn',,, Inv.Location );
	return 0.3;
}

function bool ShouldRespawn(Actor Other)
{
	return false;
}

static function string KillMessage( name damageType, pawn Other )
{
	local string message;
	
	switch ( damageType )
	{
		case 'Suicided':
			message = Default.SuicideMessage;
			break;
		case 'Fell':
			message = Default.FallMessage;
			break;
		case 'Drowned':
			message = Default.DrownedMessage;
			break;
		case 'Crushed':
			message = Default.CrushedMessage;
			break;
		case 'Stomped':
			message = Default.StompedMessage;
			break;
		case 'Special':
			message = Default.SpecialDamageString;
			break;
		case 'Burned':
		case 'fire':
		case 'gen_fire':
			message = Default.BurnedMessage;
			break;
		case 'electrical':
			message = Default.ElectrocutedMessage;
			break;
		case 'Exploded':
		case 'dyn_concussive':
		case 'skull_concussive':
		case 'sigil_concussive':
		case 'lbg_concussive':
		case 'phx_concussive':
		case 'gen_concussive':
			message = Default.ExplodeMessage;
			break;
		default:
			message = Default.DeathVerb$Default.DeathTerm;
	}
		
	return message;	
}

static function string CreatureKillMessage( name damageType, pawn Other )
{
	local string message;

	switch ( damageType )
	{
		case 'Hacked':
		case 'nearattack':
		case 'scythe':
		case 'scythedouble':
			message = Default.HackedMessage;
			break;
		case 'Stomped':
			message = Default.StompedMessage;
			break;
		case 'Burned':
		case 'fire':
		case 'gen_fire':
			message = Default.BurnedMessage;
			break;
		case 'electrical':
			message = Default.ElectrocutedMessage;
			break;
		case 'Exploded':
		case 'dyn_concussive':
		case 'skull_concussive':
		case 'sigil_concussive':
		case 'lbg_concussive':
		case 'phx_concussive':
		case 'gen_concussive':
			message = Default.ExplodeMessage;
			break;
		default:
			message = Default.DeathVerb$Default.DeathTerm;
	}

	return ( message$Default.DeathPrep );
}

static function string PlayerKillMessage( name damageType, PlayerReplicationInfo Other )
{
	local string message;
	local float decision;

	decision = FRand();

	if ( decision < 0.2 )
		message = Default.MajorDeathMessage[Rand(3)];
	else
	{
		if ( DamageType == 'Decapitated' )
			message = Default.HeadLossMessage[Rand(2)];
		else
			message = Default.DeathMessage[Rand(32)];

		if ( decision < 0.75 )
			message = Default.DeathModifier[Rand(5)]$message;
	}	
	
	return ( Default.DeathVerb$message$Default.DeathPrep );
} 	

function BroadcastRegularDeathMessage(pawn Killer, pawn Other, name damageType)
{
	local class WeaponClass;

	switch (damageType)
	{
		case 'ectoplasm':
			WeaponClass = class'Ectoplasm';
			break;
		case 'skull_concussive':
			WeaponClass = class'SkullStorm';
			break;
		case 'electrical':
			WeaponClass = class'Lightning';
			break;
		case 'powerword':
			WeaponClass = class'PowerWord';
			break;
		default:
			WeaponClass = Killer.Weapon.Class;
	}
	//creepingrot,sigil_concussive

	BroadcastLocalizedMessage(DeathMessageClass, 0, Killer.PlayerReplicationInfo, Other.PlayerReplicationInfo, WeaponClass);
}

function PlayTeleportEffect( actor Incoming, bool bOut, bool bSound)
{
	/* NEEDMOH ==================
	local PawnTeleportEffect PTE;

	if ( Incoming.IsA('Pawn') )
	{
		if ( bSound )
		{
			PTE = Spawn(class'PawnTeleportEffect',,, Incoming.Location, Incoming.Rotation);
			PTE.Initialize(Pawn(Incoming), bOut);
			if ( Incoming.IsA('PlayerPawn') )
				PlayerPawn(Incoming).SetFOVAngle(170);
			Incoming.PlaySound(sound'Teleport1',, 10.0);
		}
	}
	======================= NEEDMOH */
}

//
// Spawn any default inventory for the player.
//
function AddDefaultInventory( pawn PlayerPawn )
{
	local Weapon newWeapon;
	local class<Weapon> WeapClass;
	local Inventory newItem;
	local Spell newSpell;
	local PlayerModifier newPM;

	//Log("AddDefaultInventory");

	PlayerPawn.JumpZ = PlayerPawn.Default.JumpZ * PlayerJumpZScaling();

	if( PlayerPawn.IsA('Spectator') )
		return;

	if( PlayerPawn(PlayerPawn).GetEntryLevelSafe() == PlayerPawn.Level )
	{
		// limit tampering with the entry level (like spawning things)
		PlayerPawn(PlayerPawn).bCheatsEnabled = false;

		// don't give default inventory to prevent things like activating scrye and the ambient sound staying permanently
		return;
	}

	// ****************************************************
	// NEEDAEONS -DEFAULT WEAPON IS NOT ASSIGNED

	/*
	newItem = Spawn(class'Aeons.Flashlight');
	if (newItem != None)
	{
		newItem.GiveTo(PlayerPawn);
	}
	*/

	// -------------------------------------------------------------------------
	// Player Modifiers --------------------------------------------------------
	// -------------------------------------------------------------------------

	// give the player client side modifiers
	AeonsPlayer(PlayerPawn).GiveClientSideModifiers();

	// give the player a SlimeModifier
	if ( AeonsPlayer(PlayerPawn).SlimeMod == None )
		AeonsPlayer(PlayerPawn).SlimeMod = Spawn(class'Aeons.SlimeModifier', PlayerPawn);

	// give the player a SlothModifier
	if ( AeonsPlayer(PlayerPawn).SlothMod == None )
		AeonsPlayer(PlayerPawn).SlothMod = Spawn(class'Aeons.SlothModifier', PlayerPawn);

	// Friction Modifier
	if ( AeonsPlayer(PlayerPawn).FrictionMod == None )
		AeonsPlayer(PlayerPawn).FrictionMod = Spawn(class'Aeons.FrictionModifier', PlayerPawn);

	// Player Bloody Footprint Modifier
	if ( AeonsPlayer(PlayerPawn).BloodMod == None )
		AeonsPlayer(PlayerPawn).BloodMod = Spawn(class'Aeons.BloodFootprintModifier', PlayerPawn);

	// Player Invoke Modifier
	if ( AeonsPlayer(PlayerPawn).InvokeMod == None )
		AeonsPlayer(PlayerPawn).InvokeMod = Spawn(class'Aeons.InvokeModifier', PlayerPawn);

	// Player Speed Modifier
	if ( AeonsPlayer(PlayerPawn).SpeedMod == None )
		AeonsPlayer(PlayerPawn).SpeedMod = Spawn(class'Engine.SpeedModifier', PlayerPawn);

	// Player Glow Modifier
	if ( AeonsPlayer(PlayerPawn).GlowMod == None )
		AeonsPlayer(PlayerPawn).GlowMod = Spawn(class'Aeons.GlowModifier', PlayerPawn);

	// Player Wet Modifier
	if ( AeonsPlayer(PlayerPawn).WetMod == None && Level.NetMode == NM_Standalone ) // disabled in multiplayer for now
		AeonsPlayer(PlayerPawn).WetMod = Spawn(class'Aeons.WetModifier', PlayerPawn);

	// Player Fire Modifier
	if ( AeonsPlayer(PlayerPawn).FireMod == None )
		AeonsPlayer(PlayerPawn).FireMod = Spawn(class'Aeons.FireModifier', PlayerPawn);

	// Flight Modifier
	if ( AeonsPlayer(PlayerPawn).Flight == None )
		AeonsPlayer(PlayerPawn).Flight = Spawn(class'Aeons.FlightModifier', PlayerPawn);

	// give the player a Mindshatter Modifier
	if ( AeonsPlayer(PlayerPawn).MindshatterMod == None )
		AeonsPlayer(PlayerPawn).MindshatterMod = Spawn(class'Aeons.MindshatterModifier', PlayerPawn);

	// Mana Modifier
	if ( AeonsPlayer(PlayerPawn).ManaMod == None )
		AeonsPlayer(PlayerPawn).ManaMod = Spawn(class'Aeons.ManaModifier', PlayerPawn);

	// give the player a Ward Modifier
	if ( AeonsPlayer(PlayerPawn).WardMod == None )
		AeonsPlayer(PlayerPawn).WardMod = Spawn(class'Aeons.WardModifier', PlayerPawn);

	// give the player a Haste Modifier
	if ( AeonsPlayer(PlayerPawn).HasteMod == None )
		AeonsPlayer(PlayerPawn).HasteMod = Spawn(class'Aeons.HasteModifier', PlayerPawn);

	// give the player a Shield ModModifier
	if ( AeonsPlayer(PlayerPawn).ShieldMod == None )
		AeonsPlayer(PlayerPawn).ShieldMod = Spawn(class'Aeons.ShieldModifier', PlayerPawn);

	// give the player a SphereOfCold Modifier
	if ( AeonsPlayer(PlayerPawn).SphereOfColdMod == None )
		AeonsPlayer(PlayerPawn).SphereOfColdMod = Spawn(class'Aeons.SphereOfColdModifier', PlayerPawn);

	// give the player a Phase Modifier
	if ( AeonsPlayer(PlayerPawn).PhaseMod == None )
		AeonsPlayer(PlayerPawn).PhaseMod = Spawn(class'Aeons.PhaseModifier', PlayerPawn);

	// give the player a Silence Modifier
	if ( AeonsPlayer(PlayerPawn).SilenceMod == None )
		AeonsPlayer(PlayerPawn).SilenceMod = Spawn(class'Aeons.SilenceModifier', PlayerPawn);

	// give the player a Dispel Magic Modifier
	if ( AeonsPlayer(PlayerPawn).DispelMod == None )
		AeonsPlayer(PlayerPawn).DispelMod = Spawn(class'Aeons.DispelModifier', PlayerPawn);

	// give the player a Shala's Vortex Modifier
	if ( AeonsPlayer(PlayerPawn).ShalasMod == None )
		AeonsPlayer(PlayerPawn).ShalasMod = Spawn(class'Aeons.ShalasModifier', PlayerPawn);

	// give the player a FireFlyModifier
	if ( AeonsPlayer(PlayerPawn).FireFlyMod == None )
		AeonsPlayer(PlayerPawn).FireFlyMod = Spawn(class'Aeons.FireFlyModifier', PlayerPawn);

	// give the player a ScryeModifier
	if ( AeonsPlayer(PlayerPawn).ScryeMod == None )
		AeonsPlayer(PlayerPawn).ScryeMod = Spawn(class'Aeons.ScryeModifier', PlayerPawn);

	// give the player a HealthModifier
	if ( AeonsPlayer(PlayerPawn).HealthMod == None )
		AeonsPlayer(PlayerPawn).HealthMod = Spawn(class'Aeons.HealthModifier', PlayerPawn);

	// give the player a SoundModifier
	if ( AeonsPlayer(PlayerPawn).SoundMod == None )
		AeonsPlayer(PlayerPawn).SoundMod = Spawn(class'Aeons.SoundModifier', PlayerPawn);

	// give the player a StealthModifier
	if ( AeonsPlayer(PlayerPawn).StealthMod == None )
		AeonsPlayer(PlayerPawn).StealthMod = Spawn(class'Aeons.StealthModifier', PlayerPawn);

	// give the player a GameStateModifier
	if ( AeonsPlayer(PlayerPawn).GameStateMod == None )
		AeonsPlayer(PlayerPawn).GameStateMod = Spawn(class'Aeons.GameStateModifier', PlayerPawn);

	// -------------------------------------------------------------------------

	// give the player all weapons and all spells
	AeonsPlayer(PlayerPawn).GiveStartupWeapons();

	// Spawn default weapon.
	WeapClass = BaseMutator.MutatedDefaultWeapon();
	if( (WeapClass!=None) && (PlayerPawn.FindInventoryType(WeapClass)==None) )
	{
		newWeapon = Spawn(WeapClass);
		if( newWeapon != None )
		{
			newWeapon.Instigator = PlayerPawn;
			newWeapon.BecomeItem();
			PlayerPawn.AddInventory(newWeapon);
			newWeapon.BringUp();
			newWeapon.GiveAmmo(PlayerPawn);
			newWeapon.SetSwitchPriority(PlayerPawn);
			newWeapon.WeaponSet(PlayerPawn);
		}
	}
	
	// default Defense/Misc Spell
	/*
	newSpell = Spawn(class'Aeons.ShalasVortex');
	if( newSpell != None )
	{
		newSpell.BecomeItem();
		PlayerPawn.AddInventory(newSpell);
		newSpell.Instigator = PlayerPawn;
		PlayerPawn.DefSpell = newSpell;
	}
	
 	// example default spell
	newSpell = Spawn(class'Aeons.Spell');
	if( newSpell != None )
	{
		newSpell.BecomeItem();
		PlayerPawn.AddInventory(newSpell);
		newSpell.Instigator = PlayerPawn;
		// force assign it to player's AttSpell or DefSpell vars?
	}

	newWeapon = Spawn(class'Aeons.hand');
	if( newWeapon != None )
	{
		newWeapon.BecomeItem();
		PlayerPawn.AddInventory(newWeapon);
		newWeapon.BringUp();
		newWeapon.Instigator = PlayerPawn;
		newWeapon.GiveAmmo(PlayerPawn);
		newWeapon.SetSwitchPriority(PlayerPawn);
		newWeapon.WeaponSet(PlayerPawn);
	}
	*/

	BaseMutator.ModifyPlayer(PlayerPawn);
}

function PlayWinMessage(PlayerPawn Player, bool bWinner)
{
	if ( Player.IsA('AeonsPlayer') )
		AeonsPlayer(Player).PlayWinMessage(bWinner, Player.ViewTarget);
}

event OnSaveGame(int Slot)
{
	//ServerSay("GAME SAVED");
	BroadcastMessage(class'Console'.default.DoneSaveMessage);
}

/* NEEDAEONS -Need to add these properties
	 DefaultWeapon=Class'Moh.Pistol'
	 GameMenuType=Class'Moh.MohGameOptionsMenu'
*/

defaultproperties
{
     DeathMessage(0)="killed"
     DeathMessage(1)="ruled"
     DeathMessage(2)="smoked"
     DeathMessage(3)="slaughtered"
     DeathMessage(4)="annihilated"
     DeathMessage(5)="put down"
     DeathMessage(6)="splooged"
     DeathMessage(7)="perforated"
     DeathMessage(8)="shredded"
     DeathMessage(9)="destroyed"
     DeathMessage(10)="whacked"
     DeathMessage(11)="canned"
     DeathMessage(12)="busted"
     DeathMessage(13)="creamed"
     DeathMessage(14)="smeared"
     DeathMessage(15)="shut out"
     DeathMessage(16)="beaten down"
     DeathMessage(17)="smacked down"
     DeathMessage(18)="pureed"
     DeathMessage(19)="sliced"
     DeathMessage(20)="diced"
     DeathMessage(21)="ripped"
     DeathMessage(22)="blasted"
     DeathMessage(23)="torn up"
     DeathMessage(24)="spanked"
     DeathMessage(25)="eviscerated"
     DeathMessage(26)="neutered"
     DeathMessage(27)="whipped"
     DeathMessage(28)="shafted"
     DeathMessage(29)="trashed"
     DeathMessage(30)="smashed"
     DeathMessage(31)="trounced"
     DeathModifier(0)="thoroughly "
     DeathModifier(1)="completely "
     DeathModifier(2)="absolutely "
     DeathModifier(3)="totally "
     DeathModifier(4)="utterly "
     MajorDeathMessage(0)="ripped a new one"
     MajorDeathMessage(1)="messed up real bad"
     MajorDeathMessage(2)="given a new definition of pain"
     MajorDeathMessage(3)=""
     MajorDeathMessage(4)=""
     MajorDeathMessage(5)=""
     MajorDeathMessage(6)=""
     MajorDeathMessage(7)=""
     HeadLossMessage(0)="decapitated"
     HeadLossMessage(1)="beheaded"
     DeathVerb=" was "
     DeathPrep=" by "
     DeathTerm="killed"
     ExplodeMessage=" was jibbed"
     SuicideMessage=" perished."
     FallMessage=" splatted."
     DrownedMessage=" met the drown god."
     BurnedMessage=" was scorched"
     ElectrocutedMessage=" was shocked"
     CrushedMessage=" got pulverized."
     StompedMessage=" was trampled"
     HackedMessage=" was hacked"
     GlobalNameChange=" changed name to "
     NoNameChange=" is already in use"
     DefaultPlayerClass=Class'Aeons.Patrick'
     HUDType=Class'Aeons.AeonsHUD'
     GameReplicationInfoClass=Class'Engine.GameReplicationInfo'
     DeathMessageClass=Class'Aeons.DeathMessage'
     DefaultWeapon=Class'Aeons.Revolver'
}
