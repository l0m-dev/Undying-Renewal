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
var(DeathMessage) localized string CorrodedMessage;
var(DeathMessage) localized string HackedMessage;

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
		Damage = Damage * (0.4 + 0.2 * instigatedBy.skill);
	return (Damage * instigatedBy.DamageScaling);
}

function float PlaySpawnEffect(inventory Inv)
{
//	spawn( class 'ReSpawn',,, Inv.Location );
	return 0.3;
}

function bool ShouldRespawn(Actor Other)
{
	return false;
}

static function string KillMessage( name damageType, pawn Other )
{
	local string message;
	
	if (damageType == 'Exploded')
		message = Default.ExplodeMessage;
	else if (damageType == 'Suicided')
		message = Default.SuicideMessage;
	else if ( damageType == 'Fell' )
		message = Default.FallMessage;
	else if ( damageType == 'Drowned' )
		message = Default.DrownedMessage;
	else if ( damageType == 'Special' )
		message = Default.SpecialDamageString;
	else if ( damageType == 'Burned' )
		message = Default.BurnedMessage;
	else if ( damageType == 'Corroded' )
		message = Default.CorrodedMessage;
	else
		message = Default.DeathVerb$Default.DeathTerm;
		
	return message;	
}

static function string CreatureKillMessage( name damageType, pawn Other )
{
	local string message;
	
	if (damageType == 'exploded')
		message = Default.ExplodeMessage;
	else if ( damageType == 'Burned' )
		message = Default.BurnedMessage;
	else if ( damageType == 'Corroded' )
		message = Default.CorrodedMessage;
	else if ( damageType == 'Hacked' )
		message = Default.HackedMessage;
	else
		message = Default.DeathVerb$Default.DeathTerm;

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
	local Inventory newItem;
	local Spell newSpell;
	local PlayerModifier newPM;
	local BookJournalBase TempBook;
	local class<BookJournalBase> BookJournalClass;
	local JournalEntry TempEntry;

	//Log("AddDefaultInventory");

	PlayerPawn.JumpZ = PlayerPawn.Default.JumpZ * PlayerJumpZScaling();

	if( PlayerPawn.IsA('Spectator') )
		return;

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

	// give the player a On Screen Message Modifier
	if ( AeonsPlayer(PlayerPawn).OSMMod == None )
		AeonsPlayer(PlayerPawn).OSMMod = Spawn(class'Aeons.OnScreenMessageModifier', PlayerPawn);

	// give the player a SlimeModifier
	if ( AeonsPlayer(PlayerPawn).SlimeMod == None )
		AeonsPlayer(PlayerPawn).SlimeMod = Spawn(class'Aeons.SlimeModifier', PlayerPawn);

	// give the player a SlothModifier
	if ( AeonsPlayer(PlayerPawn).SlothMod == None )
		AeonsPlayer(PlayerPawn).SlothMod = Spawn(class'Aeons.SlothModifier', PlayerPawn);

	// Friction Modifier
	if ( AeonsPlayer(PlayerPawn).FrictionMod == None )
		AeonsPlayer(PlayerPawn).FrictionMod = Spawn(class'Aeons.FrictionModifier', PlayerPawn);

	// Rain Modifier
	if ( AeonsPlayer(PlayerPawn).RainMod == None )
		AeonsPlayer(PlayerPawn).RainMod = Spawn(class'Aeons.RainModifier', PlayerPawn);

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
	if ( AeonsPlayer(PlayerPawn).WetMod == None )
		AeonsPlayer(PlayerPawn).WetMod = Spawn(class'Aeons.WetModifier', PlayerPawn);

	// Player Fire Modifier
	if ( AeonsPlayer(PlayerPawn).FireMod == None )
		AeonsPlayer(PlayerPawn).FireMod = Spawn(class'Aeons.FireModifier', PlayerPawn);

	// Player Damage Physics Modifier
	if ( AeonsPlayer(PlayerPawn).PlayerDamageMod == None )
		AeonsPlayer(PlayerPawn).PlayerDamageMod = Spawn(class'Aeons.PlayerDamageModifier', PlayerPawn);

	// Flight Modifier
	if ( AeonsPlayer(PlayerPawn).Flight == None )
		AeonsPlayer(PlayerPawn).Flight = Spawn(class'Aeons.FlightModifier', PlayerPawn);

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

	// give the player a Mindshatter Modifier
	if ( AeonsPlayer(PlayerPawn).MindshatterMod == None )
		AeonsPlayer(PlayerPawn).MindshatterMod = Spawn(class'Aeons.MindshatterModifier', PlayerPawn);

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

	// give the player a Shala's Vortex Modifier
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
	
	AeonsPlayer(PlayerPawn).InvDisplayMan = spawn(class 'InvDisplayManager',PlayerPawn,,Location);

	// give the player all weapons and all spells
	AeonsPlayer(PlayerPawn).GiveStartupWeapons();

	// give em somethin' to read
	if ( AeonsPlayer(PlayerPawn).Book == None )
	{
		if (GetPlatform() == PLATFORM_PSX2)
		{
			TempBook = Spawn(class'Aeons.BookJournalPSX2', PlayerPawn);
		}
		else
		{
			//Log("We're on the PC, so give em a PC book.");
			BookJournalClass = class<BookJournalBase>(DynamicLoadObject("Aeons.BookJournal", class'Class'));
			if ( BookJournalClass != None )
			{
				//Log("BookJournalClass != None, it = "$BookJournalClass);
				TempBook = Spawn(BookJournalClass, PlayerPawn);

// The book spawns it's ObjectivesJournal in it's PostBeginPlay
//				if ( TempBook != None )
//				{
//					AeonsPlayer(PlayerPawn).GiveJournal(class'ObjectivesJournal');
//				}
			}
		}

		TempBook.GiveTo(PlayerPawn);
		AeonsPlayer(PlayerPawn).Book = TempBook;
	}

	/*
	// default Defense/Misc Spell
	newSpell = Spawn(class'Aeons.ShalasVortex');
	if( newSpell != None )
	{
		newSpell.BecomeItem();
		PlayerPawn.AddInventory(newSpell);
		newSpell.Instigator = PlayerPawn;
		PlayerPawn.DefSpell = newSpell;
	}

	// default Attack Spell
	newSpell = Spawn(class'Aeons.Phoenix');
	if( newSpell != None )
	{
		newSpell.BecomeItem();
		PlayerPawn.AddInventory(newSpell);
		newSpell.Instigator = PlayerPawn;
		PlayerPawn.AttSpell = newSpell;
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
}

/* NEEDAEONS -Need to add these properties
	 DefaultWeapon=Class'Moh.Pistol'
	 GameMenuType=Class'Moh.MohGameOptionsMenu'
*/

defaultproperties
{
     DefaultPlayerClass=Class'Aeons.Patrick'
     HUDType=Class'Aeons.AeonsHUD'
     GameReplicationInfoClass=Class'Engine.GameReplicationInfo'
}
