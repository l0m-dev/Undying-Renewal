class Vote extends Mutator
	transient;

var enum EVoteState
{
    VS_Inactive,
    VS_Active,
    VS_Succeeded
} VoteState;

enum EVoteOption
{
	VOTE_NONE,
	VOTE_YES,
	VOTE_NO
};

var struct VoteInfo
{
	var int PlayerId;
	var EVoteOption Option;
} PlayerVotes[32];

var int NeededVotes;
var int LastAllowedPlayerId;

var enum EVoteType
{
    VT_None,
    VT_Restart,
    VT_Map,
	VT_Kick
} VoteType;
var string VoteArgs;

const VOTE_DURATION = 12.0;
const VOTE_SUCCESS_DELAY = 5.0;
const VOTE_FRACTION = 0.66;

var color RedColor, GreenColor, BlueColor;

var localized string VoteRestartText;
var localized string VoteMapText;
var localized string VoteKickText;
var localized string VoteResultText;

function PostBeginPlay()
{
	Level.Game.RegisterMessageMutator(self);
}

function StartVote(PlayerReplicationInfo PRI, EVoteType vt, optional string Args)
{
	local int i, NumPlayers;
	local Pawn pawn;
	local string VoteStartMessage;

	if (VoteState != VS_Inactive)
	{
		Reply(PRI, "Vote in progress.", RedColor);
		return;
	}

	// verify arguments
	if (!VerifyVote(PRI, vt, Args))
		return;

	// save vote type and args
	VoteType = vt;
	VoteArgs = Args;

	// print the vote message
	switch(vt)
	{
		case VT_Restart:
			VoteStartMessage = FormatString(VoteRestartText, "%player", PRI.PlayerName);
			Print(VoteStartMessage, BlueColor);
			break;
		case VT_Map:
			VoteStartMessage = FormatString(VoteMapText, "%player", PRI.PlayerName);
			VoteStartMessage = FormatString(VoteStartMessage, "%map", Args);
			Print(VoteStartMessage, BlueColor);
			break;
		case VT_Kick:
			VoteStartMessage = FormatString(VoteKickText, "%player", PRI.PlayerName);
			VoteStartMessage = FormatString(VoteStartMessage, "%target", Args);
			Print(VoteStartMessage, BlueColor);
			break;
	}

	// reset votes
	for (i=0; i < ArrayCount(PlayerVotes); i++)
	{
		PlayerVotes[i].PlayerId = -1;
		PlayerVotes[i].Option = VOTE_NONE;
	}

	// determine needed votes and the last player id that can vote
	LastAllowedPlayerId = -1;
	NumPlayers = 0;
	for (pawn = Level.PawnList; pawn != None; pawn = pawn.NextPawn)
	{
		if (pawn.PlayerReplicationInfo != None )
		{
			if (pawn.PlayerReplicationInfo.PlayerID > LastAllowedPlayerId)
				LastAllowedPlayerId = pawn.PlayerReplicationInfo.PlayerID;
			NumPlayers++;
		}
	}

	NeededVotes = Ceil(NumPlayers * VOTE_FRACTION);
	
	// vote started
	VoteState = VS_Active;

	// assume the player wants to vote yes
	AddVote(PRI, VOTE_YES, true);

	// timer to end vote
	SetTimer(VOTE_DURATION, false);
}

function Timer()
{
	switch(VoteState)
	{
		case VS_Active:
			EndVote();
			break;
		case VS_Succeeded:
			DoVoteResultAction();
			break;
	}
}

function EndVote()
{
	local int i, VotedYes;
	local string VoteResult;

	// count and decide..
	for (i=0; i < ArrayCount(PlayerVotes); i++)
	{
		if (PlayerVotes[i].Option == VOTE_YES)
			VotedYes++;
	}

	VoteResult = FormatString(VoteResultText, "%num", string(VotedYes));
	VoteResult = FormatString(VoteResult, "%needed", string(NeededVotes));
	Print(VoteResult);

	if (VotedYes < NeededVotes)
	{
		Print("Vote failed.", RedColor);
		VoteState = VS_Inactive;
		return;
	}

	Print("Vote passed.", GreenColor);
	VoteState = VS_Succeeded;

	// timer to do the vote result action
	SetTimer(VOTE_SUCCESS_DELAY, false);
}

function DoVoteResultAction()
{
	VoteState = VS_Inactive;
	
	switch(VoteType)
	{
		case VT_Restart:
			RestartMap();
			break;
		case VT_Map:
			ChangeMap(VoteArgs);
			break;
		case VT_Kick:
			Kick(VoteArgs);
			break;
	}
}

function AddVote(PlayerReplicationInfo PRI, EVoteOption Option, optional bool bHideMessage)
{
	local int i;

	if (VoteState != VS_Active)
	{
		Reply(PRI, "Vote not in progress.", RedColor);
		return;
	}

	if (!CanVote(PRI))
	{
		Reply(PRI, "You can't vote right now.", RedColor);
		return;
	}

	for (i=0; i < ArrayCount(PlayerVotes); i++)
	{
		if (PlayerVotes[i].PlayerId == PRI.PlayerID)
		{
			// player already voted
			Reply(PRI, "You already voted.", RedColor);
			break;
		}

		if (PlayerVotes[i].PlayerId == -1)
		{
			if (!bHideMessage)
				Print(PRI.PlayerName$" voted: "$OptionToString(Option));
			PlayerVotes[i].PlayerId = PRI.PlayerID;
			PlayerVotes[i].Option = Option;
			break;
		}
	}
}

function bool VerifyVote(PlayerReplicationInfo PRI, EVoteType vt, out string Args)
{
	local int i;

	if (vt == VT_Map)
	{
		Args = PRI.Owner.GetMapName(Args, "", 0);

		// remove the .sac extension
		i = InStr(Caps(Args), ".SAC");
		if (i != -1)
			Args = Left(Args, i);

		if (Args == "" || Args ~= "Entry" || Args ~= "Aeons")
		{
			Reply(PRI, "Invalid map..", RedColor);
			return false;
		}
	}

	return true;
}

function bool CanVote(PlayerReplicationInfo PRI)
{
	// player ids are incremented on login
	// so if we store the highest player id when the vote starts, we can prevent people from voting after the vote has started
	// this also prevents being able to vote again by reconnecting
	return PRI.PlayerID <= LastAllowedPlayerId;
}

function EVoteOption GetVoteResponse(string Msg)
{
	switch(Msg)
	{
		case "1":
		case "YES":
			return VOTE_YES;
		case "2":
		case "NO":
			return VOTE_NO;
	}

	return VOTE_NONE;
}

function bool MutatorTeamMessage( Actor Sender, Pawn Receiver, PlayerReplicationInfo PRI, coerce string Msg, name Type, optional bool bBeep )
{
	local string NextWord;
	local EVoteOption VoteResponse;

	// while a vote is active, accept responses without /vote
	if (VoteState == VS_Active)
	{
		VoteResponse = GetVoteResponse(Msg);
		if (VoteResponse != VOTE_NONE)
		{
			// make sure only the vote from the Sender is added
			if (Sender == Receiver)
				AddVote(PRI, VoteResponse);
			return false;
		}
	}

	// ignore messages going to other players
	if (Sender != Receiver)
		return Super.MutatorTeamMessage( Sender, Receiver, PRI, Msg, Type, bBeep );

	RemoveNextWord(Msg, NextWord);

	if (Caps(NextWord) ~= "/VOTE")
	{
		//Msg = Trim(Msg);

		RemoveNextWord(Msg, NextWord);

		// check if it's a yes/no response
		VoteResponse = GetVoteResponse(NextWord);
		if (VoteResponse != VOTE_NONE)
		{
			AddVote(PRI, VoteResponse);
			return false;
		}

		// check if it's a start vote command 
		switch(NextWord)
		{
			case "RESTART":
				StartVote(PRI, VT_Restart);
				break;
			case "MAP":
				RemoveNextWord(Msg, NextWord);
				StartVote(PRI, VT_Map, NextWord);
				break;
			case "KICK":
				RemoveNextWord(Msg, NextWord);
				StartVote(PRI, VT_Kick, NextWord);
				break;
		}

		// handled vote command
		return false;
	}

	return Super.MutatorTeamMessage( Sender, Receiver, PRI, Msg, Type, bBeep );
}

function ChangeMap( string URL )
{
	Level.ServerTravel( URL, true );
}

function RestartMap()
{
	Level.Game.RestartGame();
}

function Kick( string S ) 
{
	local Pawn aPawn;
	for( aPawn=Level.PawnList; aPawn!=None; aPawn=aPawn.NextPawn )
		if
		(	aPawn.bIsPlayer && !aPawn.PlayerReplicationInfo.bAdmin
			&&	aPawn.PlayerReplicationInfo.PlayerName~=S 
			&&	(PlayerPawn(aPawn)==None || NetConnection(PlayerPawn(aPawn).Player)!=None ) )
		{
			aPawn.Destroy();
			return;
		}
}

function KickBan( string S ) 
{
	local Pawn aPawn;
	local string IP;
	local int j;
	for( aPawn=Level.PawnList; aPawn!=None; aPawn=aPawn.NextPawn )
		if
		(	aPawn.bIsPlayer && !aPawn.PlayerReplicationInfo.bAdmin
			&&	aPawn.PlayerReplicationInfo.PlayerName~=S 
			&&	(PlayerPawn(aPawn)==None || NetConnection(PlayerPawn(aPawn).Player)!=None ) )
		{
			IP = PlayerPawn(aPawn).GetPlayerNetworkAddress();
			if(Level.Game.CheckIPPolicy(IP))
			{
				IP = Left(IP, InStr(IP, ":"));
				Log("Adding IP Ban for: "$IP);
				for(j=0;j<50;j++)
					if(Level.Game.IPPolicies[j] == "")
						break;
				if(j < 50)
					Level.Game.IPPolicies[j] = "DENY,"$IP;
				Level.Game.SaveConfig();
			}
			aPawn.Destroy();
			return;
		}
}

function Print( string Msg, optional color Color )
{
	local Pawn P;

	// server logging
	logTime(Msg);

	for( P=Level.PawnList; P!=None; P=P.nextPawn )
		if( P.bIsPlayer || P.IsA('MessagingSpectator') )
			P.ChatMessage( None, Msg, 'vote', Color );
}

static function Reply( PlayerReplicationInfo PRI, string Msg, optional color Color )
{
	if (Pawn(PRI.Owner) != None)
		Pawn(PRI.Owner).ChatMessage( None, Msg, 'vote', Color );
}

// Find the next word - but don't split up HTML tags.
static final function RemoveNextWord(out string Text, out string NextWord)
{
	local int i;

	i = InStr(Text, " ");
	if(i == -1)
	{
		NextWord = Text;
		Text = "";
		return;
	}

	NextWord = Left(Text, i);
	while(Mid(Text, i, 1) == " ")
		i++;	
	Text = Mid(Text, i);
}

static final function string OptionToString(EVoteOption Option)
{
	switch(Option)
	{
		case VOTE_YES:
			return "yes";
		case VOTE_NO:
			return "no";
	}

	return "none";
}

static final function color MakeRGB( int R, int G, int B )
{
	local color		C;

	C.R = R;
	C.G = G;
	C.B = B;

	return C;
}

static final function int Ceil(float num)
{
    local int inum;
	inum = int(num);
	
    if (num == float(inum))
	{
        return inum;
    }
    return inum + 1;
}

defaultproperties
{
     RedColor=(R=255,G=64,B=64,A=255)
     GreenColor=(R=64,G=255,B=64,A=255)
     BlueColor=(R=0,G=102,B=255)
     VoteRestartText="%player started a vote to restart the map"
     VoteMapText="%player started a vote to change map to %map"
     VoteKickText="%player started a vote to kick %target"
     VoteResultText="Vote results: got %num out of %needed required votes"
}
