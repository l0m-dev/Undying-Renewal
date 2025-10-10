//=============================================================================
// UndyingScoreboard
//=============================================================================
class UndyingScoreboard extends ScoreBoard;

var localized string MapTitle, Author, Restart, Continue, Ended, ElapsedTime, RemainingTime, FragGoal, TimeLimit;
var localized string PlayerString, FragsString, DeathsString, PingString;
var localized string TimeString, LossString, FPHString;
var color GreenColor, WhiteColor, GoldColor, BlueColor, LightCyanColor, SilverColor, BronzeColor, CyanColor, RedColor;
var PlayerReplicationInfo Ordered[32];
var float ScoreStart;	// top allowed score start
var bool bTimeDown;
var Font SmallFont, SmallestFont, BigFont, HugeFont;
var localized string MapTitleQuote;

var float ScaleX, ScaleY;

function PostBeginPlay()
{
	Super.PostBeginPlay();
	SmallestFont = Font(DynamicLoadObject(GetRenewalConfig().SmallFont,class'Font'));
	SmallFont = Font(DynamicLoadObject(GetRenewalConfig().MediumFont,class'Font'));
	BigFont = Font(DynamicLoadObject(GetRenewalConfig().MediumFont,class'Font'));
	HugeFont = BigFont;
}

function DrawHeader( canvas Canvas )
{
	local float XL, YL;

	Canvas.bCenter = true;

	Canvas.Font = HugeFont;

	Canvas.SetPos(0.0, 32*ScaleY);
	Canvas.StrLen("TEST", XL, YL);
	Canvas.DrawColor.R = 0;
	Canvas.DrawColor.G = 125;
	Canvas.DrawColor.B = 255;
	if (Level.Netmode != NM_StandAlone)
		Canvas.DrawText(Level.GRI.ServerName);
	Canvas.SetPos(0.0, 32*ScaleY + YL);
	Canvas.DrawColor = WhiteColor;
	Canvas.DrawText("Game Type: "$Level.GRI.GameName, true);
	Canvas.SetPos(0.0, 32*ScaleY + 2*YL);
	if (Level.Title != "Untitled")
		Canvas.DrawText("Map Title: "$Level.Title, true);
	Canvas.SetPos(0.0, 32*ScaleY + 3*YL);
	Canvas.SetPos(0.0, 32*ScaleY + 3*YL);
	if (Level.Author != "")
		Canvas.DrawText("Author: "$Level.Author, true);
	Canvas.SetPos(0.0, 32*ScaleY + 4*YL);
	if (Level.IdealPlayerCount != "")
		Canvas.DrawText("Ideal Player Load:"$Level.IdealPlayerCount, true);

	Canvas.SetPos(0, 32*ScaleY + 6*YL);
	Canvas.DrawText(Level.LevelEnterText, true);

	Canvas.bCenter = false;
}

function DrawHeaderTodo( canvas Canvas )
{
	local GameReplicationInfo GRI;
	local float XL, YL;
	local font CanvasFont;

	Canvas.DrawColor = WhiteColor;
	GRI = PlayerPawn(Owner).GameReplicationInfo;

	Canvas.Font = HugeFont;

	Canvas.bCenter = True;
	Canvas.StrLen("Test", XL, YL);
	ScoreStart = 45 * ScaleY;
	CanvasFont = Canvas.Font;
	if ( GRI.GameEndedComments != "" )
	{
		Canvas.DrawColor = GoldColor;
		Canvas.SetPos(0, ScoreStart);
		Canvas.DrawText(GRI.GameEndedComments, True);
	}
	else
	{
		Canvas.SetPos(0, ScoreStart);
		DrawVictoryConditions(Canvas);
	}
	Canvas.bCenter = False;
	Canvas.Font = CanvasFont;
}

function DrawVictoryConditions(Canvas Canvas)
{
	local AeonsGameReplicationInfo AGRI;
	local float XL, YL;

	AGRI = AeonsGameReplicationInfo(PlayerPawn(Owner).GameReplicationInfo);
	if ( AGRI == None )
		return;

	Canvas.DrawText(AGRI.GameName);
	Canvas.StrLen("Test", XL, YL);
	Canvas.SetPos(0, Canvas.CurY - YL);

	if ( AGRI.FragLimit > 0 )
	{
		Canvas.DrawText(FragGoal@AGRI.FragLimit);
		Canvas.StrLen("Test", XL, YL);
		Canvas.SetPos(0, Canvas.CurY - YL);
	}

	if ( AGRI.TimeLimit > 0 )
		Canvas.DrawText(TimeLimit@AGRI.TimeLimit$":00");
}

function string TwoDigitString(int Num)
{
	if ( Num < 10 )
		return "0"$Num;
	else
		return string(Num);
}

function DrawTrailer( canvas Canvas )
{
	local int Hours, Minutes, Seconds;
	local float XL, YL;
	local PlayerPawn PlayerOwner;

	Canvas.bCenter = true;
	Canvas.StrLen("Test", XL, YL);

	Canvas.DrawColor.R = 0;
	Canvas.DrawColor.G = 0;
	Canvas.DrawColor.B = 0;
	Canvas.DrawColor.A = 150;
	Canvas.SetPos(Canvas.ClipX * 0.25, Canvas.ClipY - Min(YL*6, Canvas.ClipY * 0.1));
	Canvas.Style = ERenderStyle.STY_AlphaBlend;
	Canvas.DrawRect(texture'HUD_Inv_Shad_Test', Canvas.ClipX * 0.5, Min(YL*6, Canvas.ClipY * 0.1));
	Canvas.Style = ERenderStyle.STY_Normal;

	Canvas.DrawColor = WhiteColor;
	PlayerOwner = PlayerPawn(Owner);
	Canvas.SetPos(0, Canvas.ClipY - 2 * YL);
	if ( (Level.NetMode == NM_Standalone) && Level.Game.IsA('DeathMatchGame') )
	{
		Canvas.DrawText(class'ChallengeBotInfo'.default.Skills[Level.Game.Difficulty]@PlayerOwner.GameReplicationInfo.GameName@MapTitle@MapTitleQuote$Level.Title$MapTitleQuote, true);
	}
	else
		Canvas.DrawText(PlayerOwner.GameReplicationInfo.GameName@MapTitle@Level.Title, true);

	Canvas.SetPos(0, Canvas.ClipY - YL);
	if ( bTimeDown || (PlayerOwner.GameReplicationInfo.RemainingTime > 0) )
	{
		bTimeDown = true;
		if ( PlayerOwner.GameReplicationInfo.RemainingTime <= 0 )
			Canvas.DrawText(RemainingTime@"00:00", true);
		else
		{
			Minutes = PlayerOwner.GameReplicationInfo.RemainingTime/60;
			Seconds = PlayerOwner.GameReplicationInfo.RemainingTime % 60;
			Canvas.DrawText(RemainingTime@TwoDigitString(Minutes)$":"$TwoDigitString(Seconds), true);
		}
	}
	else
	{
		Seconds = PlayerOwner.GameReplicationInfo.ElapsedTime;
		Minutes = Seconds / 60;
		Hours   = Minutes / 60;
		Seconds = Seconds - (Minutes * 60);
		Minutes = Minutes - (Hours * 60);
		Canvas.DrawText(ElapsedTime@TwoDigitString(Hours)$":"$TwoDigitString(Minutes)$":"$TwoDigitString(Seconds), true);
	}

	if ( PlayerOwner.GameReplicationInfo.GameEndedComments != "" )
	{
		Canvas.bCenter = true;
		Canvas.StrLen("Test", XL, YL);
		Canvas.SetPos(0, Canvas.ClipY - Min(YL*6, Canvas.ClipY * 0.1));
		Canvas.DrawColor = GreenColor;
		if ( Level.NetMode == NM_Standalone )
			Canvas.DrawText(Ended@Continue, true);
		else
			Canvas.DrawText(Ended, true);
	}
	/*
	// needs bAllowRespawn check
	else if ( (PlayerOwner != None) && (PlayerOwner.Health <= 0) )
	{
		Canvas.bCenter = true;
		Canvas.StrLen("Test", XL, YL);
		Canvas.SetPos(0, Canvas.ClipY - Min(YL*6, Canvas.ClipY * 0.1));
		Canvas.DrawColor = GreenColor;
		Canvas.DrawText(Restart, true);
	}
	*/
	Canvas.bCenter = false;
}

function DrawCategoryHeaders(Canvas Canvas)
{
	local float Offset, XL, YL;

	Offset = Canvas.CurY;
	Canvas.DrawColor = WhiteColor;

	Canvas.StrLen(PlayerString, XL, YL);
	Canvas.SetPos((Canvas.ClipX / 8)*2 - XL/2, Offset);
	Canvas.DrawText(PlayerString);

	Canvas.StrLen(FragsString, XL, YL);
	Canvas.SetPos((Canvas.ClipX / 8)*4 - XL/2, Offset);
	Canvas.DrawText(FragsString);

	Canvas.StrLen(DeathsString, XL, YL);
	Canvas.SetPos((Canvas.ClipX / 8)*5 - XL/2, Offset);
	Canvas.DrawText(DeathsString);

	Canvas.StrLen(PingString, XL, YL);
	Canvas.SetPos((Canvas.ClipX / 8)*6 - XL/2, Offset);
	Canvas.DrawText(PingString);
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
	Canvas.Font = BigFont;

	// Draw Name
	if ( PRI.bAdmin )
		Canvas.DrawColor = WhiteColor;
	else if ( bLocalPlayer ) 
		Canvas.DrawColor = GoldColor;
	else 
		Canvas.DrawColor = CyanColor;

	Canvas.SetPos(Canvas.ClipX * 0.1875, YOffset);
	Canvas.DrawText(PRI.PlayerName, False);

	Canvas.StrLen( "0000", XL, YL );

	// Draw Score
	if ( !bLocalPlayer )
		Canvas.DrawColor = LightCyanColor;

	Canvas.StrLen( int(PRI.Score), XL2, YL );
	Canvas.SetPos( Canvas.ClipX * 0.5 + XL * 0.5 - XL2, YOffset );
	Canvas.DrawText( int(PRI.Score), false );

	// Draw Deaths
	Canvas.StrLen( int(PRI.Deaths), XL2, YL );
	Canvas.SetPos( Canvas.ClipX * 0.625 + XL * 0.5 - XL2, YOffset );
	Canvas.DrawText( int(PRI.Deaths), false );

	// Draw Ping
	Canvas.SetPos( Canvas.ClipX * 0.75 + XL * 0.5 - XL2, YOffset );
	Canvas.DrawText( PRI.Ping, false );

	/*
	if ( (Canvas.ClipX > 512) && (Level.NetMode != NM_Standalone) )
	{
		Canvas.DrawColor = WhiteColor;
		Canvas.Font = SmallestFont;

		// Draw Time
		Time = Max(1, (Level.TimeSeconds + PlayerOwner.PlayerReplicationInfo.StartTime - PRI.StartTime)/60);
		Canvas.TextSize( TimeString$": 999", XL3, YL3 );
		Canvas.SetPos( Canvas.ClipX * 0.75 + XL, YOffset );
		Canvas.DrawText( TimeString$":"@Time, false );

		// Draw FPH
		Canvas.TextSize( FPHString$": 999", XL2, YL2 );
		Canvas.SetPos( Canvas.ClipX * 0.75 + XL, YOffset + 0.5 * YL );
		Canvas.DrawText( FPHString$": "@int(60 * PRI.Score/Time), false );

		XL3 = FMax(XL3, XL2);
		// Draw Ping
		Canvas.SetPos( Canvas.ClipX * 0.75 + XL + XL3 + 16, YOffset );
		Canvas.DrawText( PingString$":"@PRI.Ping, false );
	}
	*/
}

function SortScores(int N)
{
	local int I, J, Max;
	local PlayerReplicationInfo TempPRI;
	
	for ( I=0; I<N-1; I++ )
	{
		Max = I;
		for ( J=I+1; J<N; J++ )
		{
			if ( Ordered[J].Score > Ordered[Max].Score )
				Max = J;
			else if ((Ordered[J].Score == Ordered[Max].Score) && (Ordered[J].Deaths < Ordered[Max].Deaths))
				Max = J;
			else if ((Ordered[J].Score == Ordered[Max].Score) && (Ordered[J].Deaths == Ordered[Max].Deaths) &&
					 (Ordered[J].PlayerID < Ordered[Max].Score))
				Max = J;
		}

		TempPRI = Ordered[Max];
		Ordered[Max] = Ordered[I];
		Ordered[I] = TempPRI;
	}
}

function ShowScores( canvas Canvas )
{
	local PlayerReplicationInfo PRI;
	local int PlayerCount, i;
	local float XL, YL, Scale;
	local float YOffset, YStart;
	local font CanvasFont;

	ScaleX = 1.0;
	ScaleY = 1.0;

	if (AeonsHUD(OwnerHUD) != None)
	{
		ScaleX = AeonsHUD(OwnerHUD).ScaleX;
		ScaleY = AeonsHUD(OwnerHUD).ScaleY;
	}

	Canvas.Style = ERenderStyle.STY_Normal;

	// Header
	Canvas.SetPos(0, 0);
	DrawHeader(Canvas);

	// Wipe everything.
	for ( i=0; i<ArrayCount(Ordered); i++ )
		Ordered[i] = None;
	for ( i=0; i<32; i++ )
	{
		if (PlayerPawn(Owner).GameReplicationInfo.PRIArray[i] != None)
		{
			PRI = PlayerPawn(Owner).GameReplicationInfo.PRIArray[i];
			if ( !PRI.bIsSpectator || PRI.bWaitingPlayer )
			{
				Ordered[PlayerCount] = PRI;
				PlayerCount++;
				if ( PlayerCount == ArrayCount(Ordered) )
					break;
			}
		}
	}
	SortScores(PlayerCount);
	
	CanvasFont = Canvas.Font;
	Canvas.Font = BigFont;

	Canvas.SetPos(0, 125 * ScaleY);
	DrawCategoryHeaders(Canvas);

	Canvas.StrLen( "TEST", XL, YL );
	YStart = Canvas.CurY;
	YOffset = YStart;
	if ( PlayerCount > 15 )
		PlayerCount = FMin(PlayerCount, (Canvas.ClipY - YStart)/YL - 1);

	Canvas.SetPos(Canvas.ClipX * 0.1875 - XL/2, YStart);
	Canvas.Style = ERenderStyle.STY_Modulated;
	Canvas.DrawRect(texture'HUD_Inv_Shad_Test', Canvas.ClipX * (1.0 - 0.1875*2) + XL, PlayerCount * YL);
	Canvas.Style = ERenderStyle.STY_Normal;

	Canvas.SetPos(0, 0);
	for ( I=0; I<PlayerCount; I++ )
	{
		YOffset = YStart + I * YL;
		DrawNameAndPing( Canvas, Ordered[I], 0, YOffset, false );
	}
	Canvas.DrawColor = WhiteColor;
	Canvas.Font = CanvasFont;

	// Trailer
	if ( !Level.bLowRes )
	{
		Canvas.Font = SmallFont;
		DrawTrailer(Canvas);
	}
	Canvas.DrawColor = WhiteColor;
	Canvas.Font = CanvasFont;
}

defaultproperties
{
      MapTitle="in"
      Author="by"
      Restart="You are dead.  Hit [Fire] to respawn!"
      Continue=" Hit [Fire] to continue!"
      Ended="The match has ended."
      ElapsedTime="Elapsed Time: "
      RemainingTime="Remaining Time: "
      FragGoal="Frag Limit:"
      TimeLimit="Time Limit:"
      PlayerString="Player"
      FragsString="Frags"
      DeathsString="Deaths"
      PingString="Ping"
      TimeString="Time"
      LossString="Loss"
      FPHString="FPH"
      GreenColor=(R=0,G=255,B=0,A=0)
      WhiteColor=(R=255,G=255,B=255,A=0)
      GoldColor=(R=255,G=255,B=0,A=0)
      BlueColor=(R=0,G=0,B=255,A=0)
      LightCyanColor=(R=128,G=255,B=255,A=0)
      SilverColor=(R=138,G=164,B=166,A=0)
      BronzeColor=(R=203,G=147,B=52,A=0)
      CyanColor=(R=0,G=128,B=255,A=0)
      RedColor=(R=255,G=0,B=0,A=0)
      Ordered(0)=None
      Ordered(1)=None
      Ordered(2)=None
      Ordered(3)=None
      Ordered(4)=None
      Ordered(5)=None
      Ordered(6)=None
      Ordered(7)=None
      Ordered(8)=None
      Ordered(9)=None
      Ordered(10)=None
      Ordered(11)=None
      Ordered(12)=None
      Ordered(13)=None
      Ordered(14)=None
      Ordered(15)=None
      Ordered(16)=None
      Ordered(17)=None
      Ordered(18)=None
      Ordered(19)=None
      Ordered(20)=None
      Ordered(21)=None
      Ordered(22)=None
      Ordered(23)=None
      Ordered(24)=None
      Ordered(25)=None
      Ordered(26)=None
      Ordered(27)=None
      Ordered(28)=None
      Ordered(29)=None
      Ordered(30)=None
      Ordered(31)=None
      ScoreStart=0.000000
      bTimeDown=False
      MapTitleQuote=""
}