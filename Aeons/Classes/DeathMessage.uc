//
// An Death Message.
//
// Switch 0: Kill
//	RelatedPRI_1 is the Killer.
//	RelatedPRI_2 is the Victim.
//	OptionalObject is the Killer's Weapon Class.
//
// Switch 1: Suicide
//	RelatedPRI_1 guy who killed himself.

class DeathMessage extends LocalMessage;

var localized string KilledString;

static function string GetString(
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject 
	)
{
	local string WeaponName, WeaponDeathMessage;
	switch (Switch)
	{
		case 0:
			if (RelatedPRI_1 == None)
				return "";
			if (RelatedPRI_1.PlayerName == "")
				return "";
			if (RelatedPRI_2 == None)
				return "";
			if (RelatedPRI_2.PlayerName == "")
				return "";
			if (Class<Weapon>(OptionalObject) == None && Class<Spell>(OptionalObject) == None)
			{
				return "";
			}
			if (Class<Weapon>(OptionalObject) != None)
			{
				WeaponName = Class<Weapon>(OptionalObject).Default.ItemName;

				if (Rand(2) == 0)
					WeaponDeathMessage = Class<Weapon>(OptionalObject).Default.DeathMessage;
				else
					WeaponDeathMessage = Class<Weapon>(OptionalObject).Default.AltDeathMessage;
			}
			else
			{
				WeaponName = Class<Spell>(OptionalObject).Default.ItemName;

				if (Rand(2) == 0)
					WeaponDeathMessage = Class<Spell>(OptionalObject).Default.DeathMessage;
				else
					WeaponDeathMessage = Class<Spell>(OptionalObject).Default.AltDeathMessage;
			}
			
			return class'GameInfo'.Static.ParseKillMessage(
				RelatedPRI_1.PlayerName, 
				RelatedPRI_2.PlayerName,
				WeaponName,
				WeaponDeathMessage
			);
			break;
		case 1: // Suicided
			if (RelatedPRI_1 == None)
				return "";
			if (RelatedPRI_1.bIsFemale)
				return RelatedPRI_1.PlayerName$class'AeonsGameInfo'.Default.SuicideMessage;
			else
				return RelatedPRI_1.PlayerName$class'AeonsGameInfo'.Default.SuicideMessage;
			break;
		case 2: // Fell
			if (RelatedPRI_1 == None)
				return "";
			return RelatedPRI_1.PlayerName$class'AeonsGameInfo'.Default.FallMessage;
			break;
		case 3: // Exploded
			if (RelatedPRI_1 == None)
				return "";
			return RelatedPRI_1.PlayerName$class'AeonsGameInfo'.Default.ExplodeMessage;
			break;
		case 4:	// Drowned
			if (RelatedPRI_1 == None)
				return "";
			return RelatedPRI_1.PlayerName$class'AeonsGameInfo'.Default.DrownedMessage;
			break;
		case 5: // Burned
			if (RelatedPRI_1 == None)
				return "";
			return RelatedPRI_1.PlayerName$class'AeonsGameInfo'.Default.BurnedMessage;
			break;
		case 6: // Electrocuted
			if (RelatedPRI_1 == None)
				return "";
			return RelatedPRI_1.PlayerName$class'AeonsGameInfo'.Default.ElectrocutedMessage;
			break;
		case 7: // Crushed
			if (RelatedPRI_1 == None)
				return "";
			return RelatedPRI_1.PlayerName$class'AeonsGameInfo'.Default.CrushedMessage;
			break;
		case 8: // Stomped
			if (RelatedPRI_1 == None)
				return "";
			return RelatedPRI_1.PlayerName$class'AeonsGameInfo'.Default.StompedMessage;
			break;
		//case 8: // Telefrag
		//	if (RelatedPRI_1 == None)
		//		return "";
		//	if (RelatedPRI_2 == None)
		//		return "";
		//	return class'GameInfo'.Static.ParseKillMessage(
		//		RelatedPRI_1.PlayerName,
		//		RelatedPRI_2.PlayerName,
		//		class'Translocator'.Default.ItemName,
		//		class'Translocator'.Default.DeathMessage
		//	);
		//	break;
	}
}

static function ClientReceive( 
	PlayerPawn P,
	optional int Switch,
	optional PlayerReplicationInfo RelatedPRI_1, 
	optional PlayerReplicationInfo RelatedPRI_2,
	optional Object OptionalObject
	)
{
	if (RelatedPRI_1 == P.PlayerReplicationInfo)
	{
		// Interdict and send the child message instead.
		if ( AeonsPlayer(P).myHUD != None )
		{
			AeonsPlayer(P).myHUD.LocalizedMessage( Default.ChildMessage, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
			AeonsPlayer(P).myHUD.LocalizedMessage( Default.Class, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject );
		}

		if ( Default.bIsConsoleMessage )
		{
			AeonsPlayer(P).Player.Console.AddString(Static.GetString( Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject ));
		}

		if ( AeonsHUD(P.MyHUD) != None )
			AeonsHUD(P.MyHUD).ScoreTime = AeonsPlayer(P).Level.TimeSeconds;
	} 
	else if (RelatedPRI_2 == P.PlayerReplicationInfo) 
	{
		AeonsPlayer(P).ReceiveLocalizedMessage( class'VictimMessage', 0, RelatedPRI_1 );
		Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
	} 
	else
		Super.ClientReceive(P, Switch, RelatedPRI_1, RelatedPRI_2, OptionalObject);
}

defaultproperties
{
      KilledString="was killed by"
      ChildMessage=Class'Aeons.KillerMessage'
      DrawColor=(G=0,B=0)
}
