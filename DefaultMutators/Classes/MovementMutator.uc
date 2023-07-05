class MovementMutator extends Mutator
	transient;

function ModifyLogin(out class<playerpawn> SpawnClass, out string Portal, out string Options)
{
	Log("SpawnClass: " $ SpawnClass);

	if (string(SpawnClass) == "Aeons.Patrick")
	{
		SpawnClass = class'PatrickQuake';
	}

	Log("Changing spawn class to: " $ SpawnClass);

	if ( NextMutator != None )
		NextMutator.ModifyLogin(SpawnClass, Portal, Options);
}

function ModifyPlayer(Pawn Other)
{
	local PlayerPawn P;
	P = PlayerPawn(Other);

	if (Other.PlayerReplicationInfo != None)
		BroadcastMessage("The player"@Other.PlayerReplicationInfo.PlayerName@"respawned!");
	
	ServerSay("Modified player");
	
	if (NextMutator != None)
		NextMutator.ModifyPlayer(Other);
}


function bool ReplaceWith(actor Other, string aClassName)
{
	local Actor A;
	local class<Actor> aClass;

	aClass = class<Actor>(DynamicLoadObject(aClassName, class'Class'));
	if ( aClass != None )
		A = Spawn(aClass,Other.Owner,Other.tag,Other.Location, Other.Rotation);

	if ( A != None )
	{
		A.event = Other.event;
		A.tag = Other.tag;
		return true;
	}
	return false;
}

function bool CheckReplacement(Actor Other, out byte bSuperRelevant)
{
	bSuperRelevant = 1;
	
	if (Other.IsA('Health') && !Other.IsA('HealthVial'))
	{
		ReplaceWith( Other, "Aeons.HealthVial" );
		return false;
	}
	else if ( Other.IsA('ZoneInfo') )
	{
		//Note that the T_TournamentPlayer.Possess() changes the friction for the client-side.
		ZoneInfo(Other).ZoneGroundFriction *= 0.5;
	}

	bSuperRelevant = 0;
	return true;
}

function ServerSay(string Msg) {
	local Patrick P;

	ForEach AllActors (class 'Patrick', P)
	{
		P.ScreenMessage(Msg, 10.0, True);
	}
}