//=============================================================================
// UndyingScoreBoard
//=============================================================================
class UndyingScoreBoard expands ScoreBoard;

var color GreenColor, WhiteColor, GoldColor, BlueColor, LightCyanColor, SilverColor, BronzeColor, CyanColor, RedColor;

var string PlayerNames[16];
var string TeamNames[16];
var float Scores[16];
var float Deaths[16];
var byte Teams[16];
var int Pings[16];
var int Admin[16];

function DrawHeader( canvas Canvas )
{
	local GameReplicationInfo GRI;
	local float XL, YL;

	if (Canvas.ClipX > 500)
	{
		foreach AllActors(class'GameReplicationInfo', GRI)
		{
			Canvas.bCenter = true;

			Canvas.SetPos(0.0, 32);
			Canvas.StrLen("TEST", XL, YL);
			Canvas.DrawColor.R = 0;
			Canvas.DrawColor.G = 125;
			Canvas.DrawColor.B = 255;
			if (Level.Netmode != NM_StandAlone)
				Canvas.DrawText(GRI.ServerName);
			Canvas.SetPos(0.0, 32 + YL);
			Canvas.DrawColor = WhiteColor;
			Canvas.DrawText("Game Type: "$GRI.GameName, true);
			Canvas.SetPos(0.0, 32 + 2*YL);
			if (Level.Title != "Untitled")
				Canvas.DrawText("Map Title: "$Level.Title, true);
			Canvas.SetPos(0.0, 32 + 3*YL);
			Canvas.SetPos(0.0, 32 + 3*YL);
			if (Level.Author != "")
				Canvas.DrawText("Author: "$Level.Author, true);
			Canvas.SetPos(0.0, 32 + 4*YL);
			if (Level.IdealPlayerCount != "")
				Canvas.DrawText("Ideal Player Load:"$Level.IdealPlayerCount, true);

			Canvas.SetPos(0, 32 + 6*YL);
			Canvas.DrawText(Level.LevelEnterText, true);

			Canvas.bCenter = false;
		}
	}
}

function DrawTrailer( canvas Canvas )
{
	local int Hours, Minutes, Seconds;
	local string HourString, MinuteString, SecondString;
	local float XL, YL;

	if (Canvas.ClipX > 500)
	{
		Seconds = int(Level.TimeSeconds);
		Minutes = Seconds / 60;
		Hours   = Minutes / 60;
		Minutes = Minutes - (Hours * 60);
		Seconds = Seconds - (Minutes * 60);

		if (Seconds < 10)
			SecondString = "0"$Seconds;
		else
			SecondString = string(Seconds);

		if (Minutes < 10)
			MinuteString = "0"$Minutes;
		else
			MinuteString = string(Minutes);

		if (Hours < 10)
			HourString = "0"$Hours;
		else
			HourString = string(Hours);

		Canvas.bCenter = true;
		Canvas.StrLen("Test", XL, YL);
		Canvas.SetPos(0, Canvas.ClipY - YL);
		Canvas.DrawText("Elapsed Time: "$HourString$":"$MinuteString$":"$SecondString, true);
		Canvas.bCenter = false;
	}
}

function DrawCategoryHeaders(Canvas Canvas)
{
	local float Offset, XL, YL;

	Offset = Canvas.CurY;
	Canvas.DrawColor = WhiteColor;

	Canvas.StrLen("Player", XL, YL);
	Canvas.SetPos((Canvas.ClipX / 8)*2 - XL/2, Offset);
	Canvas.DrawText("Player");

	Canvas.StrLen("Frags", XL, YL);
	Canvas.SetPos((Canvas.ClipX / 8)*5 - XL/2, Offset);
	Canvas.DrawText("Frags");

	Canvas.StrLen("Deaths", XL, YL);
	Canvas.SetPos((Canvas.ClipX / 8)*6 - XL/2, Offset);
	Canvas.DrawText("Deaths");
}

function DrawName( canvas Canvas, int I, float XOffset, int LoopCount )
{
	local bool bLocalPlayer;
	local PlayerPawn PlayerOwner;

	PlayerOwner = PlayerPawn(Owner);

	bLocalPlayer = (PlayerNames[I] == PlayerOwner.PlayerReplicationInfo.PlayerName);

	// Draw Name
	if ( Admin[I] == 1) {
		Canvas.DrawColor = WhiteColor;
	} else if ( bLocalPlayer ) {
		Canvas.DrawColor = GoldColor;
	} else {
		Canvas.DrawColor = CyanColor;
	}
	
	Canvas.SetPos(Canvas.ClipX * 0.2275, Canvas.ClipY/4 + (LoopCount * 16));
	//Canvas.SetPos(Canvas.ClipX/4, Canvas.ClipY/4 + (LoopCount * 16));
	Canvas.DrawText(PlayerNames[I], false);
}

function DrawPing( canvas Canvas, int I, float XOffset, int LoopCount )
{
	local float XL, YL;

	if (Level.Netmode == NM_Standalone)
		return;

	Canvas.StrLen(Pings[I], XL, YL);
	//Canvas.SetPos(Canvas.ClipX/4 - XL - 8, Canvas.ClipY/4 + (LoopCount * 16));
	// Draw Ping
	Canvas.SetPos( Canvas.ClipX * 0.75 + XL*2 + 16,  Canvas.ClipY/4 + (LoopCount * 16) );
	Canvas.Font = Font(DynamicLoadObject("Aeons.Dauphin_Grey",class'Font'));;
	Canvas.DrawColor = WhiteColor;
	Canvas.DrawText( "Ping"$":"@Pings[I], false );
	Canvas.Font = Font(DynamicLoadObject("Aeons.Dauphin_Grey",class'Font'));;
	Canvas.DrawColor.R = 0;
	Canvas.DrawColor.G = 125;
	Canvas.DrawColor.B = 225;
}

function DrawScore( canvas Canvas, int I, float XOffset, int LoopCount )
{
	local float XL, YL, XL2, YL2, XL3, YL3;
	
	local bool bLocalPlayer;
	local PlayerPawn PlayerOwner;

	PlayerOwner = PlayerPawn(Owner);

	bLocalPlayer = (PlayerNames[I] == PlayerOwner.PlayerReplicationInfo.PlayerName);
	
	//Canvas.SetPos(Canvas.ClipX/4 * 3, Canvas.ClipY/4 + (LoopCount * 16));
	
	//Canvas.StrLen( "0000", XL, YL );

	Canvas.StrLen( int(Scores[I]), XL2, YL );
	Canvas.SetPos( Canvas.ClipX * 0.625 + XL * 0.5 - XL2, Canvas.ClipY/4 + (LoopCount * 16) );
	// Draw Score
	if ( !bLocalPlayer ) {
		//Canvas.DrawColor = WhiteColor;
	}

	if(Scores[I] >= 100.0)
		Canvas.CurX -= 6.0;
	if(Scores[I] >= 10.0)
		Canvas.CurX -= 6.0;
	if(Scores[I] < 0.0)
		Canvas.CurX -= 6.0;
	Canvas.DrawText(int(Scores[I]), false);
	
	// Draw Deaths
	Canvas.StrLen( int(Deaths[I]), XL2, YL );
	Canvas.SetPos( Canvas.ClipX * 0.75 + XL * 0.5 - XL2, Canvas.ClipY/4 + (LoopCount * 16) );
	Canvas.DrawText( int(Deaths[I]), false );
}

function Swap( int L, int R )
{
	local string TempPlayerName, TempTeamName;
	local float TempScore;
	local byte TempTeam;
	local byte TempDeath;
	local int TempPing;

	TempPlayerName = PlayerNames[L];
	TempTeamName = TeamNames[L];
	TempScore = Scores[L];
	TempDeath = Deaths[L];
	TempTeam = Teams[L];
	TempPing = Pings[L];
	
	PlayerNames[L] = PlayerNames[R];
	TeamNames[L] = TeamNames[R];
	Scores[L] = Scores[R];
	Deaths[L] = Deaths[R];
	Teams[L] = Teams[R];
	Pings[L] = Pings[R];
	
	PlayerNames[R] = TempPlayerName;
	TeamNames[R] = TempTeamName;
	Scores[R] = TempScore;
	Deaths[R] = TempDeath;
	Teams[R] = TempTeam;
	Pings[R] = TempPing;
}

function SortScores(int N)
{
	local int I, J, Max;
	
	for ( I=0; I<N-1; I++ )
	{
		Max = I;
		for ( J=I+1; J<N; J++ )
			if (Scores[J] > Scores[Max])
				Max = J;
		Swap( Max, I );
	}
}

function DrawNameAndPing(Canvas Canvas, PlayerReplicationInfo PRI, float XOffset, float YOffset, bool bCompressed)
{
	local float XL, YL, XL2, YL2, XL3, YL3;
	local Font CanvasFont;
	local bool bLocalPlayer;
	local PlayerPawn PlayerOwner;
	local int Time;

	PlayerOwner = PlayerPawn(Owner);

	bLocalPlayer = (PRI.PlayerName == PlayerOwner.PlayerReplicationInfo.PlayerName);

	// Draw Name
	if ( PRI.bAdmin ) {
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
	} else if ( bLocalPlayer ) {
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 215;
		Canvas.DrawColor.B = 0;
	} else {
		Canvas.DrawColor.R = 0;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
	}

	Canvas.SetPos(Canvas.ClipX * 0.1875, YOffset);
	Canvas.DrawText(PRI.PlayerName, False);

	Canvas.StrLen( "0000", XL, YL );

	// Draw Score
	if ( !bLocalPlayer ) {
		Canvas.DrawColor.R = 0;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
	}

	Canvas.StrLen( int(PRI.Score), XL2, YL );
	Canvas.SetPos( Canvas.ClipX * 0.625 + XL * 0.5 - XL2, YOffset );
	Canvas.DrawText( int(PRI.Score), false );

	// Draw Deaths
	Canvas.StrLen( int(PRI.Deaths), XL2, YL );
	Canvas.SetPos( Canvas.ClipX * 0.75 + XL * 0.5 - XL2, YOffset );
	Canvas.DrawText( int(PRI.Deaths), false );

	if ( (Canvas.ClipX > 512) && (Level.NetMode != NM_Standalone) )
	{
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
		//Canvas.Font = MyFonts.GetSmallestFont(Canvas.ClipX);

		// Draw Time
		Time = Max(1, (Level.TimeSeconds + PlayerOwner.PlayerReplicationInfo.StartTime - PRI.StartTime)/60);
		Canvas.TextSize( "Time"$": 999", XL3, YL3 );
		Canvas.SetPos( Canvas.ClipX * 0.75 + XL, YOffset );
		Canvas.DrawText( "Time"$":"@Time, false );

		// Draw FPH
		Canvas.TextSize( "FPH"$": 999", XL2, YL2 );
		Canvas.SetPos( Canvas.ClipX * 0.75 + XL, YOffset + 0.5 * YL );
		Canvas.DrawText( "FPH"$": "@int(60 * PRI.Score/Time), false );

		XL3 = FMax(XL3, XL2);
		// Draw Ping
		Canvas.SetPos( Canvas.ClipX * 0.75 + XL + XL3 + 16, YOffset );
		Canvas.DrawText( "Ping"$":"@PRI.Ping, false );
	}
}

function ShowScores( canvas Canvas )
{
	local PlayerReplicationInfo PRI;
	local int PlayerCount, LoopCount, I;
	local float XL, YL;

	Canvas.Font = Font(DynamicLoadObject("Aeons.Dauphin_Grey",class'Font'));;

	// Header
	DrawHeader(Canvas);

	// Trailer
	DrawTrailer(Canvas);

	// Wipe everything.
	for ( I=0; I<16; I++ )
	{
		Scores[I] = -500;
	}

	Canvas.DrawColor.R = 0;
	Canvas.DrawColor.G = 125;
	Canvas.DrawColor.B = 225;

	foreach AllActors (class'PlayerReplicationInfo', PRI)
	{
		PlayerNames[PlayerCount] = PRI.PlayerName;
		TeamNames[PlayerCount] = PRI.TeamName;
		Scores[PlayerCount] = PRI.Score;
		Deaths[PlayerCount] = PRI.Deaths;
		Teams[PlayerCount] = PRI.Team;
		Pings[PlayerCount] = PRI.Ping;
		Admin[PlayerCount] = int(PRI.bAdmin);

		PlayerCount++;
	}
	
	SortScores(PlayerCount);
	
	Canvas.SetPos(0, 160.0/768.0 * Canvas.ClipY);
	DrawCategoryHeaders(Canvas);
	
	LoopCount = 0;
	
	for ( I=0; I<PlayerCount; I++ )
	{
		// Player name
		DrawName(Canvas, I, 0, LoopCount);
		
		// Player ping
		DrawPing(Canvas, I, 0, LoopCount);

		// Player score
		DrawScore(Canvas, I, 0, LoopCount);
	
		LoopCount++;
	}

	Canvas.DrawColor.R = 0;
	Canvas.DrawColor.G = 0;
	Canvas.DrawColor.B = 125;
}

defaultproperties
{
	 GreenColor=(G=255)
     WhiteColor=(R=255,G=255,B=255)
     GoldColor=(R=255,G=255)
     BlueColor=(B=255)
     LightCyanColor=(R=128,G=255,B=255)
     SilverColor=(R=138,G=164,B=166)
     BronzeColor=(R=203,G=147,B=52)
     CyanColor=(G=128,B=255)
     RedColor=(R=255)
}
