//=============================================================================
// HUD: Superclass of the heads-up display.
//=============================================================================
class HUD extends Invisible
	abstract
	native
	config(user);

//=============================================================================
// Variables.

var globalconfig int HudMode;	
var globalconfig int Crosshair;
var() class<menu> MainMenuType;
var() string HUDConfigWindowType;
var color WhiteColor;
var	Menu MainMenu;
var Mutator HUDMutator;
var PlayerPawn PlayerOwner; // always the actual owner

// Letterbox control
var bool	bLetterbox;
var globalconfig bool bEnableLetterBox;
var globalconfig float LetterboxAspectRatio;
var float	LetterboxFadeRate;
var float	LetterboxFadeTime;
var int		LetterboxHeight;

var int LastDamageInflicted;

var string ReplayMessage;

struct SubtitleInfo
{
	var float Timer;
	var string Name;
	var string Text[10];
	var int Number;
	var int X, Y;
};

var SubtitleInfo Subtitle;

var float		ratio;
struct HUDLocalizedMessage
{
	var Class<LocalMessage> Message;
	var int Switch;
	var PlayerReplicationInfo RelatedPRI;
	var Object OptionalObject;
	var float EndOfLife;
	var float LifeTime;
	var bool bDrawing;
	var int numLines;
	var string StringMessage;
	var color DrawColor;
	var font StringFont;
	var float XL, YL;
	var float YPos;
};

function ClearMessage(out HUDLocalizedMessage M)
{
	M.Message = None;
	M.Switch = 0;
	M.RelatedPRI = None;
	M.OptionalObject = None;
	M.EndOfLife = 0;
	M.StringMessage = "";
	M.DrawColor = WhiteColor;
	M.XL = 0;
	M.bDrawing = false;
}

function CopyMessage(out HUDLocalizedMessage M1, HUDLocalizedMessage M2)
{
	M1.Message = M2.Message;
	M1.Switch = M2.Switch;
	M1.RelatedPRI = M2.RelatedPRI;
	M1.OptionalObject = M2.OptionalObject;
	M1.EndOfLife = M2.EndOfLife;
	M1.StringMessage = M2.StringMessage;
	M1.DrawColor = M2.DrawColor;
	M1.XL = M2.XL;
	M1.YL = M2.YL;
	M1.YPos = M2.YPos;
	M1.bDrawing = M2.bDrawing;
	M1.LifeTime = M2.LifeTime;
	M1.numLines = M2.numLines;
}

//=============================================================================
// Status drawing.

simulated event PreRender( canvas Canvas );
simulated event PostRender( canvas Canvas );
simulated event AddSubtitle( string NewSubtitle, optional string SoundName );
simulated function RemoveSubtitle();
simulated function InputNumber(byte F);
simulated function ChangeHud(int d);
simulated function ChangeCrosshair(int d);
simulated function DrawCrossHair( canvas Canvas, int StartX, int StartY, float Scale);
simulated function UpdateSubtitles(Float DeltaTime);
simulated function DrawSubtitles(Canvas C);

//=============================================================================
// Messaging.

simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name N );
simulated function ChatMessage( PlayerReplicationInfo PRI, coerce string Msg, name N, optional color Color );
simulated function LocalizedMessage( class<LocalMessage> Message, optional int Switch, optional PlayerReplicationInfo RelatedPRI_1, optional PlayerReplicationInfo RelatedPRI_2, optional Object OptionalObject, optional string CriticalString );

simulated function PlayReceivedMessage( string S, string PName, ZoneInfo PZone )
{
	PlayerPawn(Owner).ClientMessage(S);
	if (PlayerPawn(Owner).bMessageBeep)
		PlayerPawn(Owner).PlayBeepSound();
}

// DisplayMessages is called by the Console in PostRender.
// It offers the HUD a chance to deal with messages instead of the
// Console.  Returns true if messages were dealt with.
simulated function bool DisplayMessages(canvas Canvas)
{
	return false;
}

function bool ProcessKeyEvent( int Key, int Action, FLOAT Delta )
{
	return false;
}

//
simulated function Tick( float DeltaTime )
{
	LetterboxFadeTime -= DeltaTime;
	if ( LetterboxFadeTime < 0.0 )
		LetterboxFadeTime = 0.0;
	if (!bEnableLetterBox)
		LetterboxFadeTime = 0;
}

//
simulated function bool IsLetterboxed()
{
	return bLetterbox || ( LetterboxFadeTime != 0.0 );
}

//
simulated function SetLetterbox( bool B )
{
	bLetterbox = B;
	LetterboxFadeTime = LetterboxFadeRate - LetterboxFadeTime;
}

//
simulated function SetLetterboxAspectRatio( float aspect )
{
	//LetterboxAspectRatio = aspect; let's stay consistent and use config setting
}

//
simulated function SetLetterboxFadeRate( float rate )
{
	LetterboxFadeRate = rate;
}

//
simulated function LetterboxCanvas( Canvas canvas )
{
	local float		ySize;
	local float		FTime;

	if ( IsLetterboxed() )
	{
		if ( LetterboxFadeRate > 0.0 )
		{
			FTime = LetterboxFadeTime / LetterboxFadeRate;
			FTime = ( cos(FTime * 3.14159) + 1.0 ) * 0.5;
			if ( bLetterbox )
				ratio = FTime;
			else
				ratio = ( 1.0 - FTime );
		}
		else
			ratio = 1;
		
		//ySize = int((Canvas.SizeY - Canvas.SizeX / 2.333333/*LetterboxAspectRatio*/) / 2 * ratio); // original behavior, LetterboxAspectRatio = 21/9
		ySize = int(Canvas.SizeY * (ratio * LetterboxAspectRatio));
		
		//if (ySize < 150)
		//	ySize = 0; // too small, it will mess up subtitles

		LetterboxHeight = ySize;
	}
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     HudMode=1
     Crosshair=1
     HUDConfigWindowType="UMenu"
     WhiteColor=(G=128,B=255,A=255)
     LetterboxAspectRatio=0.12
     LetterboxFadeRate=1.5
	 bEnableLetterBox=True
     bHidden=True
     RemoteRole=ROLE_SimulatedProxy
}
