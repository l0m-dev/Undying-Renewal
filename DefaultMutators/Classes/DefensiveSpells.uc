class DefensiveSpells extends Mutator;

function ModifyLogin(out class<playerpawn> SpawnClass, out string Portal, out string Options)
{
	Log("SpawnClass: " $ SpawnClass);

	if (string(SpawnClass) == "Aeons.Patrick")
	{
		//SpawnClass = class'PatrickQuake';
	}

	//Log("Changing spawn class to: " $ SpawnClass);

	if ( NextMutator != None )
		NextMutator.ModifyLogin(SpawnClass, Portal, Options);
}

function ModifyPlayer(Pawn Other)
{
	local PlayerPawn P;
	P = PlayerPawn(Other);

	if (Other.PlayerReplicationInfo != None)
		BroadcastMessage("The player"@Other.PlayerReplicationInfo.PlayerName@"respawned!");

	if (NextMutator != None)
		NextMutator.ModifyPlayer(Other);
}

function Timer()
{
	local AeonsPlayer aPlayer;
	
	Super.Timer();

	foreach AllActors(class'AeonsPlayer', aPlayer)
	{
		aPlayer.DefAll();
		aPlayer.bDrawStealth = true;
	}
}

function PostBeginPlay()
{
	SetTimer(1.5, false);
}