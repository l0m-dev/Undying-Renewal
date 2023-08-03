//=============================================================================
// AeonsHUD.
//=============================================================================
class AeonsHUD expands HUD;

//=============================================================================
// Resources
//=============================================================================
//#exec TEXTURE IMPORT NAME=ShieldOverlay FILE=ShieldOverlay.PCX GROUP="HUD" FLAGS=2 MIPS=OFF
//#exec TEXTURE IMPORT NAME=InvWindow		FILE=InvWindow.bmp	MIPS=OFF FLAGS=2

//----------------------------------------------------------------------------
//			Conventional Weapon
//----------------------------------------------------------------------------
//#exec Texture Import File=Molotov_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Dynamite_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Cannon_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Revolver_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Shotgun_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=DoubleShotgun_Icon.bmp Group=Icons Mips=Off
//#exec Texture Import File=Scythe_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Scythe_Icon_Glow.pcx	Group=Icons	Mips=Off
//#exec Texture Import File=Speargun_Glow_Icon.pcx Group=Icons Mips=Off
//#exec Texture Import File=Speargun_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Ghelz_Icon.bmp		Group=Icons	Mips=Off

//----------------------------------------------------------------------------
//			Offensive Spells
//----------------------------------------------------------------------------
//#exec Texture Import File=Ectoplasm_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=SkullStorm_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=Lightning_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=Mindshatter_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=Phoenix_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=PowerWord_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=Ward_Icon.bmp			Group=Icons	Mips=Off
//#exec Texture Import File=Invoke_Icon.bmp		Group=Icons	Mips=Off

//----------------------------------------------------------------------------
//			Defensive Spells
//----------------------------------------------------------------------------
//#exec Texture Import File=Dispel_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Scrye_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Haste_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Shalas_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Shield_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Silence_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=FireFly_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Phase_Icon.bmp		Group=Icons	Mips=Off

//----------------------------------------------------------------------------
//			Inventory / Misc.
//----------------------------------------------------------------------------
//#exec Texture Import File=Mana_Icon.bmp 		Group=HUD	Mips=Off
//#exec Texture Import File=Mana_Icon_glow.pcx	Group=HUD	Mips=Off 
//#exec Texture Import File=FlightBar_Icon.bmp 	Group=HUD	Mips=Off
//#exec Texture Import File=Flight_Icon.bmp 		Group=HUD	Mips=Off
//#exec Texture Import File=null_Icon.bmp			Group=Icons	Mips=Off
//#exec Texture Import File=Book_Icon.bmp			Group=Icons	Mips=Off
//#exec Texture Import File=WizardEye_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=Bullet_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Bullet_Silver_Icon.bmp Group=Icons Mips=Off
//#exec Texture Import File=Shells_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Shells_Phos_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=EtherTrap_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=Flask_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=HealingRoot_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=Health.bmp			Group=Icons	Mips=Off
//#exec Texture Import File=Health_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=Key_Icon.bmp			Group=Icons	Mips=Off
//#exec Texture Import File=Lantern_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=MistFlute_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=MontoHeart_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=Phosphors_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=PuzzlePiece_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=Scroll_Icon.bmp		Group=Icons	Mips=Off
//#exec Texture Import File=SilverBullet_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=SirenPowder_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=SleedSeed_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=StalkerLure_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=TransScroll_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=VeragoInk_Icon.bmp	Group=Icons	Mips=Off
//#exec Texture Import File=Amplifier_Icon.bmp	Group=Icons	Mips=Off

//#exec Texture Import File=HUD_Numbers.bmp Mips=Off	Group=HUD

//#exec Texture Import File=Inv_bar_bottom.bmp Mips=Off	Group=HUD FLAGS=2
//#exec Texture Import File=Inv_bar_right.bmp Mips=Off	Group=HUD FLAGS=2
//#exec Texture Import File=Inv_bar_top.bmp Mips=Off		Group=HUD FLAGS=2
//#exec Texture Import File=HUD_Inv_Shad_Test.bmp Flags=4 Mips=Off	Group=HUD

//#exec Texture Import File=dot.bmp Name=dot Mips=Off 			Group=HUD
//#exec Texture Import File=dot_green.bmp Name=dot_green Mips=Off	Group=HUD

//#exec Texture Import File=StealthIcon.pcx Name=StealthIcon Mips=Off	Group=HUD

//#exec Texture Import File=SepiaTone.pcx Mips=Off Group=HUD

//#exec Texture Import File=scrnspry1.bmp Mips=Off
//#exec Texture Import File=scrnspry2.bmp Mips=Off
//#exec Texture Import File=scrnspry3.bmp Mips=Off

//#exec TEXTURE IMPORT FILE=CrossHair0.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair1.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair2.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair3.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair4.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair5.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair6.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair7.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair8.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair9.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair10.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair11.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair12.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair13.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair14.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair15.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair16.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair17.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair18.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair19.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair20.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair21.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair22.bmp	GROUP=Icons MIPS=OFF
//#exec TEXTURE IMPORT FILE=CrossHair23.bmp	GROUP=Icons MIPS=OFF

//#exec TEXTURE IMPORT FILE=Ghelz_Glow.pcx	GROUP=MuzzleFlashes MIPS=OFF
//#exec TEXTURE IMPORT FILE=Ghelz_Glow2.pcx	GROUP=MuzzleFlashes MIPS=OFF

//#exec TEXTURE IMPORT FILE=MuzzleFlash0.pcx	GROUP=MuzzleFlashes MIPS=OFF

//#exec TEXTURE IMPORT Name=ShieldCrack0 FILE=ShieldCrack0.pcx GROUP=HUD MIPS=OFF
//#exec TEXTURE IMPORT Name=ShieldCrack1 FILE=ShieldCrack1.pcx GROUP=HUD MIPS=OFF
//#exec TEXTURE IMPORT Name=ShieldCrack2 FILE=ShieldCrack2.pcx GROUP=HUD MIPS=OFF
//#exec Texture Import File=zeta.pcx Group=Icons Mips=Off

//#exec Font Import File=MorpheusFont.bmp Mips=Off	Group=Fonts
//#exec Font Import File=Dauphin10_pad2.bmp Mips=Off	Group=Fonts

//#exec Audio Import File=HUD_Favorite01.WAV
//#exec Audio Import File=HUD_Mvmt01.WAV
//#exec Audio Import File=HUD_Select01.WAV

//#exec OBJ LOAD FILE=\Aeons\Textures\fxB2.utx PACKAGE=fxB2
//#exec OBJ LOAD FILE=\Aeons\Textures\fxB.utx PACKAGE=fxB
//#exec OBJ LOAD FILE=\aeons\textures\FX.utx PACKAGE=FX

#exec Texture Import File=Revolver_Icon_Silver.bmp		Mips=Off
#exec Texture Import File=FlightBar_Icon_Fixed.bmp		Mips=Off FLAGS=2
#exec Texture Import File=HUD_Numbers_HD.bmp


//=============================================================================

// these are only needed for backwards compatibility (loading renewal saves in original undying)
var(Fonts) font MySmallFont, MyMediumFont, MyLargeFont;

var float aX, aY; //updated with input when PlayerPawn is in ControlObject State

var vector MouseBuffer[5];
var int BufferSlot;

var(Wheel) int RadiusThreshold;
var(Wheel) int RadiusThresholdPSX2;
var int LastSector;
var float WheelTextTimer;
var string SelectedName;
var vector AveragedMouseMove;
var int SelectedSector;

var Actor Arrow;	// debug arrow

var globalconfig bool bCrossOn;		// Indicates the crosshair is signaling a hit.

/////////////////////////////////////////////////////////////

var(Wheel) int Con_X[8];
var(Wheel) int Con_Y[8];
var(Wheel) int Con_InvGroup[8];

var(Wheel) int Def_X[8];
var(Wheel) int Def_Y[8];
var(Wheel) int Def_InvGroup[8];

var(Wheel) int Off_X[8];
var(Wheel) int Off_Y[8];
var(Wheel) int Off_InvGroup[8];

/////////////////////////////////////////////////////////////

var bool bShowCrosshairEnemyColor;
var MasterCameraPoint MP;
var int MAX_CROSSHAIRS;
var texture CrossHairs[24];

// Scrolling list of seven Items
var Inventory LuckySevenItems[7];		// these are the seven items that are displayed in the list - selected item is index [3]

struct Digit
{
	var byte cTimer;	// State of animation, if any
	var byte cValue;	// What character is showing
	var byte cLastValue;// Last character shown. Used for the flipping animation
};

var() texture Icons[30];
//var() texture Shadows[30];

struct Number
{
	var() int Offset[10];
	var() int Width[10];
};

var() Number DigitInfo;

var digit	rdAmmo[2];
var digit	rdHealth[3];
var digit	rdMana[3];

var int frameTime, fCount;
var float frameTimes[5];

var() float magicFrameRate;
var() bool showFrameRate;
var bool bShowTex;

var float Scale;
var float ScaleX;
var float ScaleY;

var int CanvasWidth;
var int CanvasHeight;

struct Splat
{
	var float StartX, StartY;
	var float X, Y;
	var float VelX, VelY;
	var float Timer;
	var texture Tex;
};

const MAXSPLATS = 50;

var Splat Splats[50];

var string CurrentMessage;
var float MOTDFadeOutTime;

var float IdentifyFadeTime;
var Pawn IdentifyTarget;
var Actor IdentifyActor;

// Identify Strings
var localized string IdentifyName;
var localized string IdentifyHealth;

var string VersionMessage;

var localized string TeamName[4];
var() color TeamColor[4];
var() color AltTeamColor[4];
var color RedColor, GreenColor, WhiteColor;

var int ArmorOffset;

var() Texture SlimeOverlay;
var() Texture WizardEyeOverlay;
var() Texture PhoenixOverlay;
var() Texture ScryeOverlay;
var() Texture ShieldOverlay;
var() Texture ShalasOverlay;
var() Texture ShieldCracks[3];
var() Texture SepiaOverlay;

var() texture DotTexture;

var() bool bDrawLevelInfo;
var() bool bDrawBuildInfo;
var bool bShowArrow;

var float LastMana;
var float UsedManaFlashTime;
var float UsedMana;

var Actor RicochetArrows[3];
var Rotator SavedView1;

var string NoWheelSelectionText;
var vector WheelDelta;
const ExtendRadiusThresholdAmount = 24; // allows selection cursor to move beyond required threshold
const WheelCursorSensitivity = 0.75;

var float DisplayObjectivesTime;

var(Wheel) int Item_InvGroup[8];

var int LastDrawnItemsCount;
var float HalfClipX;
var float HalfClipY;
var float HudScale;
var float ClampedHudScale;
var bool bAltHud;

const OSMClientMessage = true;

// 80 comes from 64 + 16
const WSI_Bottom = 80; // Weapon, Spells, Items bottom offset, old value is 72, undying original is 80,
					   // but some things like spell icon, book icon and mana icon were 72
const WSI_Right = 80;
const WSI_Top = 16;
var int WSI_Left;
var int WSI_Padding;

// Message Struct
Struct MessageStruct
{
	var name Type;
	var PlayerReplicationInfo PRI;
};

simulated function PostBeginPlay()
{

	MOTDFadeOutTime = 255;
	Super.PostBeginPlay();

	DigitInfo.Offset[0] = 6;
	DigitInfo.Width[0] = 22;

	DigitInfo.Offset[1] = 30;
	DigitInfo.Width[1] = 11;

	DigitInfo.Offset[2] = 47;
	DigitInfo.Width[2] = 23;

	DigitInfo.Offset[3] = 72;
	DigitInfo.Width[3] = 24;

	DigitInfo.Offset[4] = 98;
	DigitInfo.Width[4] = 22;

	DigitInfo.Offset[5] = 124;
	DigitInfo.Width[5] = 20;

	DigitInfo.Offset[6] = 147;
	DigitInfo.Width[6] = 23;

	DigitInfo.Offset[7] = 170;
	DigitInfo.Width[7] = 25;

	DigitInfo.Offset[8] = 197;
	DigitInfo.Width[8] = 23;

	DigitInfo.Offset[9] = 225;
	DigitInfo.Width[9] = 21;

	MyLargeFont =	Font(DynamicLoadObject("Aeons.MorpheusFont",class'Font'));
	MyMediumFont =	Font(DynamicLoadObject("Aeons.Dauphin_Grey",class'Font'));
	MySmallFont =	Font(DynamicLoadObject("Comic.Comic10", class'Font'));

	// original weapon order
	/*
	Con_InvGroup[0] = 1;
	Con_InvGroup[1] = 2;
	Con_InvGroup[2] = 5;
	Con_InvGroup[3] = 4;
	Con_InvGroup[4] = 3;
	Con_InvGroup[5] = 6;
	Con_InvGroup[6] = 28;
	Con_InvGroup[7] = 8;

	Off_InvGroup[0] = 7;
	Off_InvGroup[1] = 11;
	Off_InvGroup[2] = 14;
	Off_InvGroup[3] = 21;
	Off_InvGroup[4] = 12;
	Off_InvGroup[5] = 24;
	Off_InvGroup[6] = 25;
	Off_InvGroup[7] = 18;

	Def_InvGroup[0] = 16;
	Def_InvGroup[1] = 22;
	Def_InvGroup[2] = 13;
	Def_InvGroup[3] = 23;
	Def_InvGroup[4] = 17;
	Def_InvGroup[5] = 27;
	Def_InvGroup[6] = 26;
	Def_InvGroup[7] = 15;
	*/
}

simulated function PreBeginPlay()
{
	Arrow = spawn(class 'DebugArrow');
	Arrow.bHidden = true;
}
	
simulated function AddSubtitle( string NewSubtitle, optional string SoundName )
{
	local int i, timelen;
	
	// Parse out the portion of the string minus the duration.
	i = InStr (NewSubtitle, "&d=");
	Subtitle.Text[Subtitle.Number] = Trim(Left(NewSubtitle, i));

	// Get the length of the string that pertains to the duration.
	timelen = Len (NewSubtitle) - (i + 3);

	// If there is no soundname passed, that indicates this subtitle is part of a sequence.
	if (SoundName == "")
	{	
		Subtitle.Timer += Float (Right (NewSubtitle, timelen));
	}
	// Otherwise, it's the first subtitle of the sequence, and the timer should be set to the time, rather then
	// incremented.
	else
	{
		Subtitle.Name = SoundName;
		Subtitle.Number = 0;
		Subtitle.Timer = Float (Right (NewSubtitle, timelen));
	}
}

simulated function RemoveSubtitle()
{
	local int i;
	Subtitle.Timer = 0;
	Subtitle.Name = "";
	for (i = 0; i < Subtitle.Number; i++)
		Subtitle.Text[i] = "";
	Subtitle.Number = 0;
}

simulated function UpdateSubtitles(Float DeltaTime)
{
	local string NewName, NewText;
	if (Subtitle.Text[Subtitle.Number] == "")
		return;
	
	Subtitle.Timer -= DeltaTime;
	if (Subtitle.Timer < 0)
	{
		Subtitle.Number++;
		NewName = Subtitle.Name $ '_' $ string (Subtitle.Number);
		NewText = Localize ("SubtitlesText", NewName, "Subtitles", true);
		if (NewText == "")
		{
			RemoveSubtitle ();
			return;
		}
		AddSubtitle (NewText);
	}
}

simulated function DrawSubtitles(Canvas canvas)
{
	local float X, Y;
	local float W, H;
	local float StartHeight, SubtitleHeight;
	local int LineCount;
	
	// Check to see if there has been a level change. If so, zero out the current subtitle sequence.
	if (Level.LevelAction != LEVACT_None)
	{
		RemoveSubtitle ();
		return;		
	}

	if (Subtitle.Text[Subtitle.Number] != "")
	{
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
		
		Canvas.Font = Canvas.MedFont;
		
		Canvas.TextSize(Subtitle.Text[Subtitle.Number], W, H);
		//StartHeight = (HalfClipY-LetterboxHeight/2);
		StartHeight = LetterboxHeight;
		LineCount = ceil(W / Canvas.ClipX);
		SubtitleHeight = (H * LineCount);
		
		if (IsLetterBoxed())
		{
			Canvas.DrawColor.R = 252;
			Canvas.DrawColor.G = 190;
			Canvas.DrawColor.B = 17;
			if (LetterboxHeight <= 0)
				Y = Canvas.OrgY + ((Canvas.ClipY - Canvas.OrgY) * 0.90);
			
			Y = Canvas.SizeY - (StartHeight / 2) -  SubtitleHeight / 2;
		}
		else
			Y = Canvas.OrgY + ((Canvas.ClipY - Canvas.OrgY) * 0.82);
		
		if (Y > Canvas.SizeY - SubtitleHeight)
			Y = Canvas.SizeY - SubtitleHeight - 10*ScaleY;

		if (!IsLetterBoxed())
		{
			Canvas.Style = 4;
			Canvas.DrawColor = Canvas.Default.DrawColor;
			Canvas.SetPos(HalfClipX - W/2 - 4*ScaleY, Y);
			Canvas.DrawTileClipped( texture'HUD_Inv_Shad_Test', W + 8*ScaleY, SubtitleHeight, 0, 0, 60, 64);
			Canvas.DrawColor = WhiteColor;
		}

		Canvas.SetPos (Canvas.OrgX, Y);
		Canvas.bCenter = true;
		Canvas.Style = ERenderStyle.STY_AlphaBlend;
		Canvas.DrawText (Subtitle.Text[Subtitle.Number], true);
		Canvas.bCenter = false;
		Canvas.SetPos (Canvas.OrgX, Canvas.OrgY);
	}
}

function int ceil(float num) {
    local int inum;
	inum = int(num);
	
    if (num == float(inum)) {
        return inum;
    }
    return inum + 1;
}

exec function ShowArrow()
{
	bShowArrow = !bShowArrow;
	if (bShowArrow)
		Arrow.bHidden = false;
	else
		Arrow.bHidden = true;
}

exec function ShowRico()
{
	local int i;
	
	if (Owner == None)
		return;
	
	AeonsPlayer(Owner).bDrawRico = !AeonsPlayer(Owner).bDrawRico;
	if (!AeonsPlayer(Owner).bDrawRico)
	{
		for (i = 0; i < ArrayCount(RicochetArrows); i++)
		{
			if (RicochetArrows[i] != None)
				RicochetArrows[i].bHidden = true;
		}
	}
}

exec function SaveView1()
{
	SavedView1 = AeonsPlayer(Owner).ViewRotation;
}

exec function LoadView1()
{
	AeonsPlayer(Owner).ViewRotation = SavedView1;
}

exec function rico1()
{
	AeonsPlayer(Owner).ViewTarget = RicochetArrows[0];
}

exec function rico2()
{
	AeonsPlayer(Owner).ViewTarget = RicochetArrows[1];
}

exec function rico3()
{
	AeonsPlayer(Owner).ViewTarget = RicochetArrows[2];
}

exec function EnemyCrosshair()
{
	bShowCrosshairEnemyColor = !bShowCrosshairEnemyColor;
}

exec function BuildInfo()
{
	bDrawBuildInfo = !bDrawBuildInfo;
}

exec function LevelInfo()
{
	bDrawLevelInfo = !bDrawLevelInfo;
}

simulated function ChangeHud(int d)
{
	HudMode = HudMode + d;

	if ( HudMode > 1 ) 
		HudMode = 0;
	else if ( HudMode < 0 ) 
		HudMode = 1;
}

simulated function ChangeCrosshair(int d)
{
	Crosshair = Crosshair + d;

	if ( Crosshair>MAX_CROSSHAIRS-1 ) 
		Crosshair=0;
	else if ( Crosshair < 0 ) 
		Crosshair = MAX_CROSSHAIRS-1;
}

simulated function CreateMenu()
{

	if ( PlayerPawn(Owner).bSpecialMenu && (PlayerPawn(Owner).SpecialMenu != None) )
	{
		MainMenu = Spawn(PlayerPawn(Owner).SpecialMenu, self);
		PlayerPawn(Owner).bSpecialMenu = false;
	}
	
	if ( MainMenu == None )
		MainMenu = Spawn(MainMenuType, self);
		
	if ( MainMenu == None )
	{
		PlayerPawn(Owner).bShowMenu = false;
		Level.bPlayersOnly = false;
		return;
	}
	else
	{
		MainMenu.PlayerOwner = PlayerPawn(Owner);
		MainMenu.PlayEnterSound();
		MainMenu.MenuInit();
	}

}

simulated function HUDSetup(canvas canvas)
{
	// Setup the way we want to draw all HUD elements
	Canvas.Reset();
	Canvas.SpaceX=0;
	Canvas.bNoSmooth = True;
	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;	
	//Log("AeonsHud: HudSetup");
	Canvas.Font = Canvas.LargeFont;
}

simulated function DrawCrossHair( canvas Canvas, int StartX, int StartY, float Scale)
{
	local texture CurrentCrossHair;
	local Actor A;
	local vector HitLocation;
	local float CrosshairScale;

 	A = PlayerPawn(Owner).EyeTraceActor; //EyeTrace(HitLocation,,4096, true);
	
	Canvas.DrawColor = PlayerPawn(Owner).CrossHairColor;
	
	PlayerPawn(Owner).bHaveTarget = false;
	
	CrosshairScale = ScaleY;
	CurrentCrossHair = CrossHairs[ CrossHair ];	
	// if we are tracing a Scripted Pawn, change the crosshair to green.
	if ( A != none )
	{
		// Player is NOT scrying and the crosshair is tracing a bScryeOnly Actor
		if ( ((AeonsPlayer(Owner).ScryeTimer == 0) && A.bScryeOnly) || (AeonsPlayer(Owner).MindShatterMod != None && AeonsPlayer(Owner).MindShatterMod.bActive) )
		{
			// do nothing .. the crosshair color is already defined.
		}
		else if ( A.IsA('ScriptedPawn') )
		{
			if ( ScriptedPawn(A).bIllumCrosshair )
			{
				if ( ScriptedPawn(A).Health > 0 )
				{
					if ( (GetPlatform() == PLATFORM_PSX2) || bShowCrosshairEnemyColor )
					{
						Canvas.DrawColor = PlayerPawn(Owner).LitCrossHairColor;
						PlayerPawn(Owner).bHaveTarget = true;
					}
				}

				if (AeonsPlayer(Owner).AttSpell != none)
				{
					if (AeonsPlayer(Owner).AttSpell.IsA('Invoke') && (VSize(Pawn(Owner).Location - A.Location) <= 256.0))
					{
						if ( (ScriptedPawn(A).Health <= 0) || A.IsA('DecayedSaint') )
						{
							Canvas.DrawColor = PlayerPawn(Owner).CrossHairInvokeColor;
						}
					}
				}
			}
		}
	}
	
	Canvas.DrawColor.a = 255 * PlayerPawn(Owner).CrossHairAlpha;
	
	if ( HudMode == 0 ) 
		return;
	
	if (Crosshair>MAX_CROSSHAIRS-1) 
		Crosshair=0;
		
	Canvas.SetPos(StartX - 8*CrosshairScale, StartY - 8*CrosshairScale );
	Canvas.Style = 3;
		
	
	/*
	if		(Crosshair==0) 	Canvas.DrawIcon(Texture'Crosshair1', 1.0);  //fix  Kyle, Scale and Offset values will have to be replicated
	else if (Crosshair==1) 	Canvas.DrawIcon(Texture'Crosshair2', 1.0);  //     for this mindshatter crosshair modification to work	
	else if (Crosshair==2) 	Canvas.DrawIcon(Texture'Crosshair3', 1.0);  
	*/
	
	Canvas.bNoSmooth = false;
	
	if ( CurrentCrossHair != None ) 
		Canvas.DrawIcon( CurrentCrossHair, CrosshairScale );
		
	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;
	Canvas.DrawColor.a = 255;
	
	Canvas.Style = 1;
}

simulated function DisplayProgressMessage( canvas Canvas )
{
	local int i;
	local float YOffset, XL, YL;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.bCenter = true;
	Canvas.Font = Canvas.MedFont;
	YOffset = 0;
	Canvas.StrLen("TEST", XL, YL);
	for (i=0; i<8; i++)
	{
		Canvas.SetPos(0, 0.25 * Canvas.ClipY + YOffset);
		Canvas.DrawColor = PlayerPawn(Owner).ProgressColor[i];
		Canvas.DrawText(PlayerPawn(Owner).ProgressMessage[i], false);
		YOffset += YL + 1;
	}
	Canvas.bCenter = false;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function PreRender( canvas Canvas )
{
	HudScale = Owner.GetRenewalConfig().HudScale;
	ClampedHudScale = FMax(HudScale, 1.0);
	bAltHud = Owner.GetRenewalConfig().bAltHud;
	
	if (WindowConsole(PlayerPawn(Owner).Player.Console).Root == None)
		return;
	
	// used throughout AeonsHUD to scale currentres with respect to 800x600
	//
	ScaleX = Canvas.ClipX / WindowConsole(PlayerPawn(Owner).Player.Console).Root.OriginalWidth * HudScale;
	ScaleY = Canvas.ClipY / WindowConsole(PlayerPawn(Owner).Player.Console).Root.OriginalHeight * HudScale;
	Scale = ScaleY;

	HalfClipX = Canvas.ClipX / 2;
	HalfClipY = Canvas.ClipY / 2;

	if (bAltHud)
	{
		WSI_Padding = 4;
		WSI_Left = 8; // needs to be smaller since health icon is smaller than 64
	}
	else
	{
		WSI_Padding = 16;
		WSI_Left = 16;
	}

	/*
	if we use root's scale, we need to call RenderUWindow when resolution changes (alt tab) outside of menus
	to calculate ScaleX again, so it's easier to just use our ClipX

	if (WindowConsole(PlayerPawn(Owner).Player.Console).Root.WinHeight != Canvas.ClipY)
	{
		WindowConsole(PlayerPawn(Owner).Player.Console).Root.Console.RenderUWindow(Canvas);
		return;
	}

	ScaleX = WindowConsole(PlayerPawn(Owner).Player.Console).Root.ScaleX;
	ScaleY = WindowConsole(PlayerPawn(Owner).Player.Console).Root.ScaleY;
	Scale = ScaleY;
	*/
	

	if (PlayerPawn(Owner).Weapon != None)
		PlayerPawn(Owner).Weapon.PreRender(Canvas);
	
	CanvasWidth  = Canvas.ClipX;
	CanvasHeight = Canvas.ClipY;

	//Log("AeonsHud: PreRender");
}

simulated function DisplayMenu( canvas Canvas )
{
    
	local float VersionW, VersionH;

	if ( MainMenu == None )
		CreateMenu();
	if ( MainMenu != None )
		MainMenu.DrawMenu(Canvas);

	if ( MainMenu.Class == MainMenuType )
	{
		/*
		Canvas.bCenter = false;
		Canvas.Font = Canvas.MedFont;
		Canvas.Style = 1;
		Canvas.StrLen(VersionMessage@Level.EngineVersion, VersionW, VersionH);
		Canvas.SetPos(Canvas.ClipX - VersionW - 4, 4);	
		Canvas.DrawText(VersionMessage@Level.EngineVersion, False);	
		*/
	}
    
}


exec function ShowTex()
{
	bShowTex = !bShowTex;
}

function DrawDecalInfo(Canvas Canvas)
{
	Canvas.Font = Canvas.SmallFont;

	Canvas.DrawColor.R = 216;
	Canvas.DrawColor.G = 154;
	Canvas.DrawColor.B = 255;

	Canvas.SetPos( 8, 128 + 12);
	Canvas.DrawText( ("Num Decals: "$Level.DMan.NumDecals), false);
	
	Canvas.SetPos( 8, 128 + (12*2));
	Canvas.DrawText( ("Soft: "$Level.DMan.SoftDecalLimit), false);

	Canvas.SetPos( 8, 128 + (12*3));
	Canvas.DrawText( ("Hard: "$Level.DMan.HardDecalLimit), false);

	Canvas.SetPos( 8, 128 + (12*4));
	Canvas.DrawText( ("OverLimit?: "$(Level.DMan.NumDecals >Level.DMan.HardDecalLimit) ), false);

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

function DrawTexData(Canvas Canvas)
{
	local Texture T;
	local string TypeStr;
	local vector EyeHeight, start, end;
	local PlayerPawn Player;
	local int Flags;
	
	if (PlayerPawn(Owner) != none)
	{
		Player = PlayerPawn(Owner);
		EyeHeight.z = Player.EyeHeight;
		
		Start = Player.Location + eyeHeight;
		End = Start + Vector(Player.ViewRotation) * 65536;

		T = TraceTexture(end, start, Flags, true);
		
		if (T != none)
		{
			Canvas.Font = Canvas.SmallFont;
	
			Canvas.DrawColor.R = 197;
			Canvas.DrawColor.G = 145;
			Canvas.DrawColor.B = 255;
	
			Canvas.SetPos( 8, 128+36);
			Canvas.DrawText( ("Texture Info"), false);
	
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
	
			Canvas.SetPos( 8, 128 + 12+36);
			Canvas.DrawText( ("Name: "$T.Name), false);

			switch ( int(T.ImpactID) )
			{
				case 0:
					TypeStr = "Default";
					break;
				case 1:
					TypeStr = "Glass";
					break;
				case 2:
					TypeStr = "Water";
					break;
				case 3:
					TypeStr = "Leaves";
					break;
				case 4:
					TypeStr = "Snow";
					break;
				case 5:
					TypeStr = "Grass";
					break;
				case 6:
					TypeStr = "Organic";
					break;
				case 7:
					TypeStr = "Carpet";
					break;
				case 8:
					TypeStr = "Earth";
					break;
				case 9:
					TypeStr = "Sand/Gravel";
					break;
				case 10:
					TypeStr = "Wood-Hollow";
					break;
				case 11:
					TypeStr = "Wood-Solid";
					break;
				case 12:
					TypeStr = "Stone";
					break;
				case 13:
					TypeStr = "Metal";
					break;
				case 14:
					TypeStr = "None";
					break;
				case 15:
					TypeStr = "None";
					break;
				default:
					TypeStr = "Undefined";
					break;
			};
		
			Canvas.SetPos( 8, 128 + (12*2)+36);
			Canvas.DrawText( ("Surface Type: "$TypeStr), false);

			Canvas.SetPos( 8, 128 + (12*3)+36);
			Canvas.DrawText( ("Size: "$T.USize$" x "$T.VSize), false);

			Canvas.DrawColor.R = T.MipZero.r;
			Canvas.DrawColor.G = T.MipZero.g;
			Canvas.DrawColor.B = T.MipZero.b;

			Canvas.SetPos( 8, 128 + (12*4)+36);
			Canvas.DrawText( ("Base Color: R:"$T.MipZero.r$" G:"$T.MipZero.g$" B:"$T.MipZero.b), false);

			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;

			Canvas.SetPos( 8, 128 + (12*5)+36);
			Canvas.DrawText( ("Climb: "$T.Climb), false);

			Canvas.SetPos( 8, 128 + (12*6)+36);
			Canvas.DrawText( ("Flammability: "$T.Flammability), false);

			Canvas.SetPos( 8, 128 + (12*7)+36);
			Canvas.DrawText( ("JumpMult: "$T.JumpMultiplier), false);

			Canvas.SetPos( 8, 128 + (12*8)+36);
			Canvas.DrawText( ("Friction: "$T.Friction), false);
	
			Canvas.SetPos( 8, 128 + (12*9)+36);
			Canvas.DrawText( ("Dustiness: "$T.Dustiness), false);

			Canvas.SetPos( 8, 128 + (12*10)+36);
			Canvas.DrawText( ("Elasticity: "$T.Elasticity), false);

			Canvas.SetPos( 8, 128 + (13*10)+36);
			Canvas.DrawText( ("Flags: "$Flags), false);

			Canvas.SetPos( 8, 128 + (14*10)+36);
			Canvas.DrawText( ("EffectClass: "$T.EffectClass), false);

			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
		}
	}
}

/*
exec function testSaveShot(string SavePath)
{
	if ( AeonsPlayer(Owner) != None )
	{
		AeonsPlayer(Owner).SavePath = SavePath;
		AeonsPlayer(Owner).bRequestedShot = true;
	}
}
*/

exec function testSound( string soundname )
{
	Owner.PlaySound(Sound(DynamicLoadObject(soundname, class'Sound')), SLOT_None, 1.0, true, 1600.0, 1.0);
}

exec function showFPS()
{
	if ( showFrameRate )
		showFrameRate = false;
	else
		showFrameRate = true;
}

exec function Flight()
{
	if ( Level.bAllowFlight )
		Level.bAllowFlight = false;
	else
		Level.bAllowFlight = true;
}

/*
simulated function SetFlight(bool bFlight)
{

	if ( bFlight )
	{
		if ( AeonsPlayer(Owner) != None )
		{
			if ( AeonsPlayer(Owner).Flight == None )
				AeonsPlayer(Owner).Flight = Spawn(class'Aeons.FlightModifier', Owner);
		}
	}
	else
	{
		if ((AeonsPlayer(Owner) != None)&&(AeonsPlayer(Owner).Flight != None))
				AeonsPlayer(Owner).Flight.Destroy();
	}
	
}*/

function FindMasterCameraPoint()
{
	ForEach AllActors(class 'MasterCameraPoint', MP)
	{
		break;
	}
}

function DrawCutsceneDebug(Canvas Canvas)
{
	Canvas.Font = Canvas.SmallFont;

	Canvas.DrawColor.R = 200;
	Canvas.DrawColor.G = 200;
	Canvas.DrawColor.B = 200;

	Canvas.SetPos( 4 , 12);
	Canvas.DrawText("Cutscene: "$MP.CutsceneName, false);

	Canvas.SetPos( 4 , 12*2);
	Canvas.DrawText("TotalTime: "$MP.TotalTime, false);

	Canvas.SetPos( 4 , 12*3);
	Canvas.DrawText("Take: "$MP.CurrentTake$"   ("$MP.CurrentTake+1$")", false);

	Canvas.SetPos( 4 , 12*4);
	Canvas.DrawText("TakeTime: "$MP.TakeTime, false);

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

}

simulated function DrawRicochet(canvas Canvas)
{
	local vector HitLocation, HitNormal, StartTrace, EndTrace, ShotNormal;
	local int HitJoint, i;
	local Vector X,Y,Z, EyeHeight;
	local vector barrelPlace, prevLoc;
	local actor Other;
	
	local int Flags;
	local Texture HitTexture;
	
	EyeHeight.z = Pawn(Owner).EyeHeight;
	
	GetAxes(Pawn(Owner).ViewRotation,X,Y,Z);
	
	barrelPlace = Owner.Location + EyeHeight + (X*Owner.CollisionRadius); // fire from your eye
	
	StartTrace = barrelPlace;
	ShotNormal = vector(Pawn(Owner).ViewRotation);
	
	for (i = 0; i < ArrayCount(RicochetArrows); i++)
	{
		RicochetArrows[i].bHidden = true;
	}
	
	for ( i=0; i < 3; i++ ) // maxWallHits + 1
	{
		EndTrace = StartTrace + ShotNormal * 4096.0;

		Other = Owner.Trace(HitLocation, HitNormal, HitJoint, EndTrace, StartTrace, false, true); // bTraceActors, bIgnorePermeable,
		
		if (HitLocation == vect(0, 0, 0))
			break;
			
		HitTexture = Owner.TraceTexture(HitLocation - HitNormal * 64, HitLocation + HitNormal * 64 , flags );
		
		prevLoc = StartTrace;
		StartTrace = HitLocation;
		ShotNormal = reflect(-ShotNormal, HitNormal);
		
		if (i > 0)
		{
			Canvas.Draw3DLine( WhiteColor, prevLoc, HitLocation);
		}
		
		if (HitTexture == None || (Flags & 134217728) != 0)
			break;
		
		if (HitTexture.ImpactID != TID_Stone && HitTexture.ImpactID != TID_Metal)
			break;
		
		if (RicochetArrows[i] == None)
			RicochetArrows[i] = spawn(class 'DebugArrow');
		
		RicochetArrows[i].bHidden = false;
		RicochetArrows[i].SetLocation(HitLocation);
		RicochetArrows[i].SetRotation(Rotator(ShotNormal));
	}
	
	//native(480) final function DrawPortal( int X, int Y, int Width, int Height, actor CamActor, vector CamLocation, rotator CamRotation, optional int FOV, optional bool ClearZ );
	///if (!RicochetArrows[0].bHidden)
	//	Canvas.DrawPortal(Pawn(Owner).Health, 480, Pawn(Owner).Health, 480, RicochetArrows[0], RicochetArrows[0].Location, RicochetArrows[0].Rotation, 90, true );
}

simulated function PostRender( canvas Canvas )
{
	local int FPS;
	local PlayerPawn PlayerOwner;
	local int YDelta;
	local bool bDrawHUD;
	local float WeaponX;
	
	bDrawHUD = true;
	
	HUDSetup(canvas);

	if ( IsLetterBoxed() )
		bDrawHud = false;

	if ( PlayerPawn(Owner) != None && PlayerPawn(Owner).Level.bLoadBootShellPSX2 && GetPlatform() == PLATFORM_PSX2 )
		bDrawHud = false;		


	if ( IsLetterBoxed() )
	{
		if (Level.bSepiaOverlay)
			DrawSepiaOverlay(Canvas);
		
		if (LetterboxHeight > 0 && bEnableLetterBox)
		{
			//YDelta = HalfClipY-LetterboxHeight/2;
			YDelta = LetterboxHeight;

			Canvas.SetPos(0,0);
			Canvas.DrawTile( Texture'UWindow.BlackTexture', Canvas.ClipX, YDelta, 0, 0, 32, 32);

			Canvas.SetPos(0,Canvas.ClipY - YDelta);
			Canvas.DrawTile( Texture'UWindow.BlackTexture', Canvas.ClipX, YDelta, 0, 0, 32, 32);
		}
		
		// BURT: FIX 1
		// force draw on screen messages during cutscenes
		if (AeonsPlayer(Owner).OSMMod != none)
		{
			AeonsPlayer(Owner).OSMMod.RenderOverlays(Canvas);
		}
		else if (AeonsPlayer(Owner).OverlayActor != none &&
				 AeonsPlayer(Owner).OverlayActor.IsA('OnScreenMessage'))
		{
			AeonsPlayer(Owner).OverlayActor.RenderOverlays(Canvas);		
		}
		// --BURT

		// Draw debug Cutscene Info
		if (MP == none)
			FindMasterCameraPoint();

		if (MP != none)
		{
			if (MP.bDebugMode)
			{
				if ( Level.bDebugMessaging )
					DrawCutsceneDebug(Canvas);
				// DrawCameraDebug(Canvas);
			}
		}
		bDrawHUD = false;
	} 

	//if ( AeonsPlayer(Owner).OverlayActor != none )
	//{
		//AeonsPlayer(Owner).OverlayActor.RenderOverlays(Canvas);		
		/*
		if ( AeonsPlayer(Owner).OverlayActor.IsA('OnScreenMessage') )
			if ( OnScreenMessage(AeonsPlayer(Owner).OverlayActor).bHideHUD )
				bDrawHUD = false;
		*/
	//}

	
	if ( bDrawHUD )
	{
		if ( !AeonsPlayer(Owner).bPhoenix )
		{
			if (!AeonsPlayer(Owner).bWizardEye)
			{
				// we're not viewing through the wizardeye
				if (AeonsPlayer(Owner).Health > 0)
				{
					DrawScryeOverlay(Canvas);

					if (AeonsPlayer(Owner).ScryeTimer == 0 )
						DrawShieldOverlay(Canvas);
				
					if (AeonsPlayer(Owner).ShalasMod != none)
						if ( AeonsPlayer(Owner).ShalasMod.bActive )
							DrawShalasOverlay(Canvas);

					if (AeonsPlayer(Owner).SlimeMod != none)
						if ( AeonsPlayer(Owner).SlimeMod.bActive )
							DrawSlimeOverlay(Canvas, SlimeModifier(AeonsPlayer(Owner).SlimeMod).EffectIntensity );
				}
			} else {
				// we're viewing through the wizardeye, don't draw any other overlays
				DrawWizardEyeOverlay(Canvas);
			}
		} else {
			DrawPhoenixOverlay(Canvas);
		}
	
		PlayerOwner = PlayerPawn(Owner);
	
	
		if ( PlayerOwner != None )
		{
			if ( PlayerOwner.PlayerReplicationInfo == None )
				return;
	
			if ( PlayerOwner.bShowMenu )
			{
				DisplayMenu(Canvas);
				return;
			}
	
			if ( PlayerOwner.bShowScores )
			{
	//			if ( (AeonsPlayer(Owner).bDrawCrosshair) && ( PlayerOwner.Weapon != None ) && ( !PlayerOwner.Weapon.bOwnsCrossHair ) )
	//				 DrawCrossHair(Canvas, HalfClipX + AeonsPlayer(Owner).crossHairOffsetX, HalfClipY + AeonsPlayer(Owner).crossHairOffsetY, AeonsPlayer(Owner).crossHairScale);
				if ( (PlayerOwner.Scoring == None) && (PlayerOwner.ScoringType != None) )
					PlayerOwner.Scoring = Spawn(PlayerOwner.ScoringType, PlayerOwner);
				if ( PlayerOwner.Scoring != None )
				{ 
					PlayerOwner.Scoring.ShowScores(Canvas);
					return;
				}
			}
			
			if ( !PlayerOwner.bBehindView && (PlayerOwner.Weapon != None) && (Level.LevelAction == LEVACT_None) )
			{
				PlayerOwner.Weapon.PostRender(Canvas);
				if ( !PlayerOwner.Weapon.bOwnsCrossHair && !AeonsPlayer(PlayerOwner).bSelectObject )
					DrawCrossHair(Canvas, HalfClipX + AeonsPlayer(Owner).crossHairOffsetX, HalfClipY + AeonsPlayer(Owner).crossHairOffsetY, AeonsPlayer(Owner).crossHairScale);
			}
	
			if ( !PlayerOwner.bBehindView && (PlayerOwner.AttSpell != None) && (Level.LevelAction == LEVACT_None) )
				PlayerOwner.AttSpell.PostRender(Canvas);
	
			// km no defensive spells anymore
			if ( !PlayerOwner.bBehindView && (PlayerOwner.DefSpell != None) && (Level.LevelAction == LEVACT_None) )
				PlayerOwner.DefSpell.PostRender(Canvas);
	
			
			if ( PlayerPawn(Owner).ProgressTimeOut > Level.TimeSeconds )
				DisplayProgressMessage(Canvas);
		}
	
		DrawDebugInfo(Canvas);
	
		if ( ReplayMessage != "" )
			DrawReplayMessage(Canvas);


		// DrawDecalInfo(Canvas);
		
		//This is a crosshair test
		// if ( AeonsPlayer(Owner).bDrawCrossHair )
			// DrawCrossHair(Canvas, (HalfClipX - 8) + AeonsPlayer(Owner).crossHairOffsetX, (HalfClipY - 8) + AeonsPlayer(Owner).crossHairOffsetY,AeonsPlayer(Owner).crossHairScale);
		// this next line always draws a stationary cross hair - for debugging mindshatter
		// DrawCrossHair(Canvas, (HalfClipX - 8), (HalfClipY - 8),1);
	
		//if (AeonsPlayer(Owner).bDrawStealth || AeonsPlayer(Owner).bDrawDebugHUD )
		//	DrawStealth(Canvas);
		
		if (AeonsPlayer(Owner).bDrawRico)
		{
			DrawRicochet(Canvas);
		}
	
		if ( AeonsPlayer(Owner).bDrawDebugHUD )
		{
			DrawCoords(Canvas);
			DrawTouchList(Canvas);
		}
	
		if (bAltHud)
		{
			DrawHealth(Canvas, (64+WSI_Padding+WSI_Left)*ScaleY, Canvas.ClipY - 64*Scale);
			DrawMana(Canvas, (128+60+WSI_Left+WSI_Padding*3)*ScaleY, Canvas.ClipY - 64*Scale);
		}
		else
		{
			DrawHealth(Canvas, HalfClipX - (64+19)*ScaleY, Canvas.ClipY - 64*ScaleY, true); // was 68 in renewal
			DrawMana(Canvas, HalfClipX + (64+19)*ScaleY, Canvas.ClipY - 64*ScaleY);
		}
	
		if (Level.bDebugMessaging)
			DrawManaInfo(Canvas);		// mana maintenence values
	
		// Stealth Icons have been cut from the game 11/19/2000
		if (AeonsPlayer(Owner).bDrawStealth)
			DrawStealthIcons(Canvas);
	
		DrawFlightMana(Canvas);
		DrawCenterPiece(Canvas);
		
		if (Owner.GetRenewalConfig().bShowUsedMana)
		{
			if (bAltHud)
			{
				DrawUsedMana(Canvas, 120*ScaleX + 64*ScaleY, Canvas.ClipY - 96*ScaleY);
			}
			else
			{
				DrawUsedMana(Canvas, HalfClipX + 26*ScaleX + 64*ScaleY, Canvas.ClipY - 96*ScaleY);
			}
		}
		
		if ( bShowArrow )
			MoveDebugArrow();
		
		if ( PlayerPawn(Owner).Health > 0 )
		{
			if ( AeonsPlayer(Owner).bDrawDebugHUD )
			{
				DrawGhelzUse(Canvas, Canvas.sizeX - 50, 30);
				DrawInvCount(Canvas, 104*ScaleY, Canvas.ClipY-88*ScaleY);
			}

			if (bAltHud)
			{
				if (AeonsPlayer(Owner).DefSpell != none)
					DrawInventoryItem(Canvas, Canvas.ClipX - (WSI_Left + 256 + WSI_Padding*3)*ScaleY, Canvas.ClipY - WSI_Bottom*ScaleY);
				else
					DrawInventoryItem(Canvas, Canvas.ClipX - (WSI_Left + 192 + WSI_Padding*2)*ScaleY, Canvas.ClipY - WSI_Bottom*ScaleY);
			}
			else
			{
				DrawInventoryItem(Canvas, 64*ScaleY + (WSI_Left + WSI_Padding)*ScaleY, Canvas.ClipY-WSI_Bottom*ScaleY);
			}
			
			WeaponX = WSI_Left*ScaleY;
			if (bAltHud)
			{
				if (AeonsPlayer(Owner).DefSpell != none)
					WeaponX = Canvas.ClipX - (WSI_Left + 192 + WSI_Padding*2)*ScaleY;
				else
					WeaponX = Canvas.ClipX - (WSI_Left + 128 + WSI_Padding)*ScaleY;
			}
			
			DrawAmmo(Canvas, WeaponX + 2*ScaleX, Canvas.ClipY-WSI_Bottom*ScaleY - 8*ScaleY/HudScale); // TextSize would be the proper way
			DrawConventionalWeapon(Canvas, WeaponX, Canvas.ClipY - WSI_Bottom*ScaleY);
		}

		DrawOffensiveSpellAmplitude(Canvas, Canvas.ClipX - (WSI_Right-2)*ScaleY, Canvas.ClipY - (WSI_Bottom+8)*ScaleY);
		DrawOffensiveSpell(Canvas, Canvas.ClipX - WSI_Right*ScaleY, Canvas.ClipY - WSI_Bottom*ScaleY);	

		DrawDefensiveSpellAmplitude(Canvas, Canvas.ClipX - (WSI_Left + 128 + WSI_Padding)*ScaleY, Canvas.ClipY - (WSI_Bottom+8)*ScaleY);	
		DrawDefensiveSpell(Canvas, Canvas.ClipX - (WSI_Left + 128 + WSI_Padding)*ScaleY, Canvas.ClipY - WSI_Bottom*ScaleY);
		
		DrawActiveSpells(Canvas);

		// if their are any unread entries in the book, draw the hud icon
		DrawBookInfo(Canvas);
		
		// draw objectives
		DrawObjectives(Canvas);
		
		if (AeonsPlayer(Owner).bDrawInvList && (!AeonsPlayer(Owner).bSelectObject || AeonsPlayer(Owner).SelectMode != SM_Item))
			DrawHeldItems(Canvas);
	
		if (AeonsPlayer(Owner).bDrawDebugHUD && bShowTex)
			DrawTexData(Canvas);
		
		if (AeonsPlayer(Owner).bDrawDebugHUD)
		{
			DrawWeaponStateInfo(Canvas);
			DrawSpellStateInfo(Canvas);
			// DrawWeaponStateInfo(Canvas);
			DrawStateInfo(Canvas);
			DrawDamageInfo(Canvas);
		}
		

		if ( Level.bDebugMessaging )
		{
			if ( bDrawBuildInfo )
				DrawBuildInfo(Canvas);

			if ( bDrawLevelInfo )
				DrawLevelInfo(Canvas);
		}
	
		if ( (AeonsPlayer(Owner).bDrawDebugHUD || showFrameRate) && (HudMode > 0) )
		{
			Canvas.Font = Canvas.LargeFont;
			// Canvas.SetPos(0, 0.01 * Canvas.ClipY);
			Canvas.SetPos(2, 2);
	
			FPS = 1000.0/GetFrameTime();
	
			//if ( frameTime < magicFrameRate )
			if ( FPS < magicFrameRate )
			{
				Canvas.DrawColor.R = 255;
				Canvas.DrawColor.G = 0;
				Canvas.DrawColor.B = 0;
			} else {
				Canvas.DrawColor.R = 0;
				Canvas.DrawColor.G = 255;
				Canvas.DrawColor.B = 0;
			}
	
			//Canvas.DrawText((""$FrameTime), false);
			Canvas.DrawText((""$FPS), false);
	
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
		}
	
		// circular HUD's
		DrawSelectHUD(Canvas);
	   
	
		/*
		// Display Frag count
		if ( (Level.Game == None) || Level.Game.bDeathMatch ) 
		{
			if (HudMode<3) DrawFragCount(Canvas, Canvas.ClipX-32,Canvas.ClipY-64);
			else if (HudMode==3) DrawFragCount(Canvas, 0,Canvas.ClipY-64);
			else if (HudMode==4) DrawFragCount(Canvas, 0,Canvas.ClipY-32);
		}
		*/
	
		// Display Identification Info
		DrawIdentifyInfo(Canvas, 0, Canvas.ClipY - 64.0);
	
		//if (AeonsPlayer(Owner).AttSpell.IsA('PowerWord'))
		//	DrawPowerWordDebug(Canvas);
	
		if ( AeonsPlayer(Owner).bDrawPawnName )
			DrawPawnName(Canvas, 0, Canvas.ClipY - 64.0);
		
		if ( AeonsPlayer(Owner).bDrawActorName )
			DrawActorName(Canvas);
	
		if (MOTDFadeOutTime != 0.0)
			DrawMOTD(Canvas);
	
		/*
		// Team Game Synopsis
		if ( PlayerPawn(Owner) != None )
		{
			if ( (PlayerPawn(Owner).GameReplicationInfo != None) && PlayerPawn(Owner).GameReplicationInfo.bTeamGame)
				DrawTeamGameSynopsis(Canvas);
		}
		*/
		
		DrawSplats(Canvas);
	

		// this really should be last in the render process
		//fix only if debug build or other criteria
	
		//	if ( AeonsPlayer(Owner).bDrawDebugHUD )
		//	DrawIconsofShame(Canvas);
	}
	
	/*
	if ( AeonsPlayer(Owner) != None ) 
	{
		if ( AeonsPlayer(Owner).bRequestedShot )
		{
			AeonsPlayer(Owner).bRequestedShot = false;

			if ( AeonsPlayer(Owner).SavePath != "" )
			{
				Owner.ConsoleCommand("shot " $ AeonsPlayer(Owner).SavePath);
				Owner.ConsoleCommand("SaveShot " $ AeonsPlayer(Owner).SavePath);
			}
			
			AeonsPlayer(Owner).SavePath = "";
		}
	}
	*/
	
	// Draw the subtitles
	if (Aeonsplayer(Owner).bEnableSubtitles)
		DrawSubtitles (Canvas);
	
}

function MoveDebugArrow()
{
	Arrow.SetLocation(PlayerPawn(Owner).EyeTraceLoc);
	Arrow.SetRotation(Rotator(PlayerPawn(Owner).EyeTraceNormal));
}

simulated function UpdateSplats(float DeltaTime)
{
	local int i;
	local float StretchY;

	for ( i=0; i<ArrayCount(Splats); i++ )
	{
		if ( Splats[i].Timer > 0 )
		{
			Splats[i].X += Splats[i].VelX * DeltaTime;
			Splats[i].Y += Splats[i].VelY * DeltaTime;		

			if ( Splats[i].Y >= CanvasHeight )
				Splats[i].Timer = 0;

			Splats[i].Timer -= DeltaTime;

			if ( Splats[i].Timer < 0 ) 
				Splats[i].Timer = 0;
		}
	}
}

simulated function DrawSplats(Canvas Canvas)
{
	local int i;
	local int StretchY;
	local string TextureName;

	for ( i=0; i<ArrayCount(Splats); i++ )
	{
		if ( Splats[i].Timer > 0)
		{
			if ( Splats[i].VelY > 0 )
			{
				StretchY = (Splats[i].Y - Splats[i].StartY);

				if ( StretchY < 0 ) 
					StretchY = -StretchY;

				if ( StretchY > 128 ) 
					StretchY = 128;
			}
			else
				StretchY = 0;

			Canvas.SetPos(Splats[i].X, Splats[i].Y - StretchY );

			Canvas.DrawColor.r = 255;
			Canvas.DrawColor.g = 255;
			Canvas.DrawColor.b = 255;
			
			if ( Splats[i].Timer <= 1.0 )
			{
				Canvas.DrawColor.a = Splats[i].Timer * 254;
			}
			else 
				Canvas.DrawColor.a = 255;

			Canvas.Style = ERenderStyle.STY_AlphaBlend;

			Canvas.DrawTileClipped( Splats[i].Tex, 128*Scale, (128 + StretchY)*Scale, 0, 0, 128, 128); 

			Canvas.Style = 1;
		}
	}

	Canvas.DrawColor.a = 255;
}
	


simulated function DrawFragCount(Canvas Canvas, int X, int Y)
{
    
	Canvas.SetPos(X,Y);
	//Canvas.DrawIcon(Texture'IconSkull', 1.0);	
	Canvas.CurX -= 19;
	Canvas.CurY += 23;
	if ( Pawn(Owner).PlayerReplicationInfo == None )
		return;
	Canvas.Font = Canvas.SmallFont;//Font'TinyWhiteFont';
	if (Pawn(Owner).PlayerReplicationInfo.Score<100) 
		Canvas.CurX+=6;
	if (Pawn(Owner).PlayerReplicationInfo.Score<10) 
		Canvas.CurX+=6;	
	if (Pawn(Owner).PlayerReplicationInfo.Score<0) 
		Canvas.CurX-=6;
	if (Pawn(Owner).PlayerReplicationInfo.Score<-9)
		Canvas.CurX-=6;
	Canvas.DrawText(int(Pawn(Owner).PlayerReplicationInfo.Score),False);
	
}

simulated function DrawInvCount(Canvas Canvas, int X, int Y)
{
	local inventory Inv;

	if ( (Owner.Inventory == None) || (PlayerPawn(Owner).selectedItem == none) )
		return;

	if(HudMode == 1)
	{
		Inv = PlayerPawn(Owner).selectedItem;
		if ( Inv.ItemType == ITEM_Inventory )
		{
			Canvas.Font = Canvas.SmallFont;

			//Canvas.SetPos( 8, Canvas.ClipY - 37-12);
			Canvas.SetPos( X, Y );
		
			Canvas.DrawColor.R = 128;
			Canvas.DrawColor.G = 128;
			Canvas.DrawColor.B = 255;

			Canvas.DrawText( (""$(Pickup(Inv).numCopies + 1)), false);
			
		}
		
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;				

	}

}

simulated function DrawReplayMessage(Canvas Canvas)
{
	Canvas.Font = Canvas.SmallFont;

	Canvas.DrawColor.R = 200;
	Canvas.DrawColor.G = 200;
	Canvas.DrawColor.B = 200;

	Canvas.SetPos( 1 , Canvas.ClipY - 48 );
	
	Canvas.DrawText(""$ReplayMessage, false);

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

}

simulated function DrawLevelInfo(Canvas Canvas)
{
	local string LevelName;
	local int i;
	local string url;

	url = Level.GetLocalURL();

	i=instr(url, "?");
	
	if ( i >0 ) 
		LevelName = Left(url, i);
	else
		LevelName = url;

	Canvas.Font = Canvas.SmallFont;

	Canvas.DrawColor.R = 200;
	Canvas.DrawColor.G = 200;
	Canvas.DrawColor.B = 200;

	Canvas.SetPos( 1 , (Canvas.ClipY - 36*ScaleY));
	if ( Level.bPSX2Level )
		Canvas.DrawText("[PSX2] Title: "$Level.Title$"    "$Level.TimeSeconds, false);
	else
		Canvas.DrawText("Title: "$Level.Title$"    "$Level.TimeSeconds, false);
	
	Canvas.SetPos( 1 , (Canvas.ClipY - 24*ScaleY));

	Canvas.DrawText(""$LevelName$" Skill: "$Level.Game.Difficulty, false);

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function DrawBuildInfo(Canvas Canvas)
{
	Canvas.Font = Canvas.SmallFont;

	Canvas.DrawColor.R = 100;
	Canvas.DrawColor.G = 100;
	Canvas.DrawColor.B = 100;
	
	Canvas.SetPos( 1 , (Canvas.ClipY - 12*ScaleY));
	Canvas.DrawText(""$VersionMessage, false);
	
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function DrawDamageInfo(Canvas Canvas)
{
	if(HudMode == 1)
	{
		Canvas.Font = Canvas.SmallFont;

		Canvas.SetPos( 8, 64-24);

		Canvas.DrawColor.R = 150;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 100;

		Canvas.DrawText("Last Damage Inflicted: "$LastDamageInflicted, false);

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
	}
}

simulated function DrawStateInfo(Canvas Canvas)
{
	local bool bClimbing;
	
	if(HudMode == 1)
	{
		Canvas.Font = Canvas.SmallFont;

		bClimbing = (AeonsPlayer(Owner).bCanFly && (GetStateName() == 'PlayerWalking'));

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 100;

		Canvas.SetPos( 8, 64-12);
		Canvas.DrawText("Standing On: "$ (Pawn(Owner).StandingOn())$" bPainZone = "$Pawn(Owner).FootRegion.Zone.bPainZone$" ScryeTimer = "$PlayerPawn(Owner).ScryeTimer, false);

		Canvas.SetPos( 8, 64);
		Canvas.DrawText("State: "$(AeonsPlayer(Owner).getStateName())$" AnimSequence = "$AeonsPlayer(Owner).AnimSequence$" Crouching = "$AeonsPlayer(Owner).bIsCrouching$" bDuck = "$AeonsPlayer(Owner).bDuck$" CrouchTime = "$AeonsPlayer(Owner).CrouchTime, false);

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
	}
}


simulated function DrawSpellStateInfo(Canvas Canvas)
{
	if(HudMode == 1)
	{
		Canvas.Font = Canvas.SmallFont;

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 100;

		Canvas.SetPos( 8, 64 + 12);
		Canvas.DrawText("AttSpell: "$(AeonsPlayer(Owner).AttSpell.Class.name)$" Level: "$AttSpell(AeonsPlayer(Owner).AttSpell).LocalCastingLevel$" "$AeonsPlayer(Owner).AttSpell.PlayerViewOffset$" bFiring: "$AttSpell(AeonsPlayer(Owner).AttSpell).bFiring$" PendingAttSpell = "$AeonsPlayer(Owner).PendingAttSpell, false);

		Canvas.SetPos( 8, 64 + 2*12);
		Canvas.DrawText("Att Spell state: "$(AeonsPlayer(Owner).AttSpell.GetStateName()$" __ Anim: "$AeonsPlayer(Owner).AttSpell.AnimSequence ), false);

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 100;
		Canvas.DrawColor.B = 255;

		Canvas.SetPos( 8, 64 + 3*12);
		Canvas.DrawText("DefSpell: "$(AeonsPlayer(Owner).DefSpell.Class.name)$" Level: "$DefSpell(AeonsPlayer(Owner).DefSpell).LocalCastingLevel, false);

		Canvas.SetPos( 8, 64 + 4*12);
		Canvas.DrawText("Def Spell state: "$(AeonsPlayer(Owner).defSpell.GetStateName()$" __ Anim: "$AeonsPlayer(Owner).DefSpell.AnimSequence), false);

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
	}
}

simulated function DrawCameraDebug(Canvas Canvas)
{
	local rotator r;
	local vector v;

	r = AeonsPlayer(Owner).CamDebugRotDiff;
	v = AeonsPlayer(Owner).CamDebugPosDiff;

	Canvas.Font = Canvas.SmallFont;

	Canvas.DrawColor.R = 100;
	Canvas.DrawColor.G = 100;
	Canvas.DrawColor.B = 150;

	Canvas.SetPos( 256, 4);
	Canvas.DrawText("Rotator Difference: Yaw "$r.yaw$" Pitch "$r.pitch$" Roll "$r.roll, false);
	Canvas.SetPos( 256, 4+14);
	Canvas.DrawText("Pos Difference: "$v, false);
	Canvas.SetPos( 256, 4+ 2*14);
	Canvas.DrawText("LookAt[1]: "$AeonsPlayer(Owner).LookAt1, false);
	Canvas.SetPos( 256, 4+ 3*14);
	Canvas.DrawText("LookAt[2]: "$AeonsPlayer(Owner).LookAt2, false);
	Canvas.SetPos( 256, 4+ 4*14);
	Canvas.DrawText("LookDir: "$AeonsPlayer(Owner).LookDir, false);
	Canvas.SetPos( 256, 4+ 5*14);
	Canvas.DrawText("Fov: Current"$AeonsPlayer(Owner).DesiredFov, false);
	Canvas.SetPos( 256, 4+ 6*14);
	Canvas.DrawText("Parametric Dist: "$AeonsPlayer(Owner).pDist, false);

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function DrawWeaponStateInfo(Canvas Canvas)
{
	local AeonsWeapon PlayerWeapon;
	local int VerticalOffset;

	if(HudMode == 1)
	{
		if ( (Owner != None) && (AeonsPlayer(Owner) != None))
				PlayerWeapon = AeonsWeapon(AeonsPlayer(Owner).Weapon);

		if ( PlayerWeapon != None )
		{
			Canvas.Font = Canvas.SmallFont;

			Canvas.DrawColor.R = 200;
			Canvas.DrawColor.G = 45;
			Canvas.DrawColor.B = 100;

			VerticalOffset = 124; // 60 + 5*12
			Canvas.SetPos( 8, VerticalOffset);
			Canvas.DrawText("Weapon: "$(PlayerWeapon.Class.Name)$" Pending Weapon: "$AeonsPlayer(Owner).PendingWeapon.name$" bFiring = "$AeonsWeapon(AeonsPlayer(Owner).Weapon).bFiring, false);

			VerticalOffset += 12;
			Canvas.SetPos( 8, VerticalOffset);
			Canvas.DrawText("Weapon State: "$(PlayerWeapon.GetStateName())$" HeldTime: "$AeonsPlayer(Owner).FireHeldTime$"Ammo Type = "$PlayerWeapon.AmmoType$" Ammo Count = "$PlayerWeapon.AmmoType.AmmoAmount$" bAltAmmo = "$PlayerWeapon.bAltAmmo, false);

			VerticalOffset += 12;
			Canvas.SetPos( 8, VerticalOffset);
			Canvas.DrawText("Weapon Sequence: "$(PlayerWeapon.AnimSequence), false);

			// do the offset anyway so that we can keep fixed locations below us
			VerticalOffset += 12;

/*
			if (PlayerWeapon.bCanClientFire) 
			{
				Canvas.SetPos( 8, VerticalOffset);
				Canvas.DrawText("CanClientFire", false);
			}


			// do the offset anyway so that we can keep fixed locations below us
			VerticalOffset += 12;

			if (PlayerWeapon.bForceFire) 
			{
				Canvas.SetPos( 8, VerticalOffset);
				Canvas.DrawText("ForceFire", false);
			}

			if (PlayerWeapon.IsA('Scythe'))
			{
				VerticalOffset += 12;
				Canvas.SetPos( 8, VerticalOffset);
				Canvas.DrawText("OverDrive: "$(Scythe(PlayerWeapon).OTime), false);

				VerticalOffset += 12;
				Canvas.SetPos( 8, VerticalOffset);
				Canvas.DrawText("Enemy 0: "$(Scythe(PlayerWeapon).Enemies[0]), false);

				VerticalOffset += 12;
				Canvas.SetPos( 8, VerticalOffset);
				Canvas.DrawText("Enemy 1: "$(Scythe(PlayerWeapon).Enemies[1]), false);

				VerticalOffset += 12;
				Canvas.SetPos( 8, VerticalOffset);
				Canvas.DrawText("Enemy 2: "$(Scythe(PlayerWeapon).Enemies[2]), false);

				VerticalOffset += 12;
				Canvas.SetPos( 8, VerticalOffset);
				Canvas.DrawText("Enemy 3: "$(Scythe(PlayerWeapon).Enemies[3]), false);
			}
*/

			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
		}
	}
}


simulated function DrawManaInfo(Canvas Canvas)
{
	local float ManaInfoX;
	
	if ( (AeonsPlayer(Owner).ManaMod == None) )
		return;

	if(HudMode == 1)
	{
		Canvas.Font = Canvas.SmallFont;

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 100;
		
		ManaInfoX = HalfClipX + 26*ScaleX + 128*ScaleY;
		if (bAltHud)
			ManaInfoX = (128+60+60+WSI_Left+WSI_Padding*3)*ScaleY;

		Canvas.SetPos(ManaInfoX, Canvas.ClipY - 50*ScaleY);
		Canvas.DrawText(("+"$ManaModifier(AeonsPlayer(Owner).ManaMod).ManaPerSec), false);

		Canvas.SetPos(ManaInfoX, Canvas.ClipY - 30*ScaleY);
		Canvas.DrawText(("-"$(ManaModifier(AeonsPlayer(Owner).ManaMod).ManaMaint + ManaModifier(AeonsPlayer(Owner).ManaMod).ScytheMaint)), false);

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
	}
}


function DrawStealth(Canvas Canvas)
{
	local float a,v,m,t,ca;
	local color c;
	
	if ( (AeonsPlayer(Owner).StealthMod == None) )
		return;

	if (HudMode == 1)
	{
		ca = StealthModifier(AeonsPlayer(Owner).StealthMod).CurrentAudible;
		a = StealthModifier(AeonsPlayer(Owner).StealthMod).AudibleStealth;
		v = StealthModifier(AeonsPlayer(Owner).StealthMod).VisibleStealth;
		m = StealthModifier(AeonsPlayer(Owner).StealthMod).MovementStealth;
		t = StealthModifier(AeonsPlayer(Owner).StealthMod).TotalStealth;

		Canvas.Font = Canvas.SmallFont;

		Canvas.DrawColor.R = 0;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 156;

		Canvas.SetPos( 8, HalfClipY + 52 + 48 );
		Canvas.DrawText( ("Player Stealth Info"), false);

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;

		Canvas.SetPos( 8, HalfClipY + 64 + 48);
		Canvas.DrawText( ("Audible:  "$a$" Ca:"$ca), false);

		c = PlayerPawn(Owner).Weapon.IncidentLight;
		Canvas.DrawColor.R = c.r;
		Canvas.DrawColor.G = c.g;
		Canvas.DrawColor.B = c.b;

		Canvas.SetPos( 8, HalfClipY + 64 + 12 + 48 );
		Canvas.DrawText( ("Visible:  "$v), false);

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;

		Canvas.SetPos( 8, HalfClipY + 64 + 24 + 48 );
		Canvas.DrawText( ("Movement: "$m), false);

		Canvas.SetPos( 8, HalfClipY + 64 + 36 + 48);
		Canvas.DrawText( ("Total:    "$t), false);

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
	}
}

function DrawTouchList(Canvas Canvas)
{
	Canvas.Font = Canvas.SmallFont;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 168;
	Canvas.DrawColor.B = 125;

	if ( Owner.Touching[0] != None )
	{
		Canvas.SetPos( 128, 2);
		Canvas.DrawText( ("Touch[0]: "$Owner.Touching[0].name), false);
	}

	if ( Owner.Touching[1] != None )
	{
		Canvas.SetPos( 128, 2 + 12);
		Canvas.DrawText( ("Touch[1]: "$Owner.Touching[1].name), false);
	}

	if ( Owner.Touching[2] != None )
	{
		Canvas.SetPos( 256, 2);
		Canvas.DrawText( ("Touch[2]: "$Owner.Touching[2].name), false);
	}

	if ( Owner.Touching[3] != None )
	{
		Canvas.SetPos( 256, 2 + 12);
		Canvas.DrawText( ("Touch[3]: "$Owner.Touching[3].name), false);
	}

	if ( Owner.Touching[4] != None )
	{
		Canvas.SetPos( 128, 2 + 2*12);
		Canvas.DrawText( ("Touch[4]: "$Owner.Touching[4].name), false);
	}

	if ( Owner.Touching[5] != None )
	{
		Canvas.SetPos( 128, 2 + 3*12);
		Canvas.DrawText( ("Touch[5]: "$Owner.Touching[5].name), false);
	}

	if ( Owner.Touching[6] != None )
	{
		Canvas.SetPos( 256, 2 + 2*12);
		Canvas.DrawText( ("Touch[6]: "$Owner.Touching[6].name), false);
	}

	if ( Owner.Touching[7] != None )
	{
		Canvas.SetPos( 256, 2 + 3*12);
		Canvas.DrawText( ("Touch[7]: "$Owner.Touching[7].name), false);
	}
	
	Canvas.SetPos( 384, 2 + 3*12);
	Canvas.DrawText( ("Overlay Actor: "$AeonsPlayer(Owner).OverlayActor), false);

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

function DrawCoords(Canvas Canvas)
{
	local vector pos, dir;
	local int x, y, z;
	local string xStr, yStr, zStr;

	if(HudMode == 1)
	{
		
		pos = AeonsPlayer(Owner).Location;
		dir = Vector(AeonsPlayer(Owner).ViewRotation);

		Canvas.Font = Canvas.SmallFont;

		Canvas.DrawColor.R = 156;
		Canvas.DrawColor.G = 0;
		Canvas.DrawColor.B = 255;

		Canvas.SetPos( 8, HalfClipY + 128 + 48);
		Canvas.DrawText( ("Coordinate Info"), false);

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;


		//x = (Dir.x * 100);
		//y = (Dir.y * 100);
		//z = (Dir.z * 100);
		
		if (x<0)
			xStr = ("-0."$int(abs(x)));
		else
			xStr = (" 0."$x);

		if (y<0)
			yStr = ("-0."$int(abs(y)));
		else
			yStr = (" 0."$y);

		if (z<0)
			zStr = ("-0."$int(abs(z)));
		else
			zStr = (" 0."$z);

		Canvas.SetPos( 8, HalfClipY + 128 + 12 + 48);
		Canvas.DrawText( ("Location: "$int(pos.x)$"  "$int(pos.y)$"  "$int(pos.z)), false);

		Canvas.SetPos( 8, HalfClipY + 128 + 24 + 48);
		Canvas.DrawText( ("Dir:      "$Dir.x$"  "$Dir.y$"  "$Dir.z), false);

		Canvas.SetPos( 8, HalfClipY + 128 + 36 + 48);
		Canvas.DrawText(("Speed:    "$int(VSize(Pawn(Owner).Velocity))), false);

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;
	}
}



simulated function DrawActiveSpells(Canvas canvas)
{
	local AeonsPlayer Player;
	local int OffsetX, tempX;
	local int Slot;
	
	Player = AeonsPlayer(Owner);
	
	if ( Player != None )	
	{
	
		OffsetX = Canvas.ClipX - 40*Scale;
		
		if ( Player.bWardActive )//( Player.WardMod != None )&&( Player.WardMod.bActive ))
		{

			Canvas.SetPos( OffsetX, 8*Scale );
			Canvas.DrawTile( Icons[24], 32*Scale, 32*Scale, 0, 0, 64, 64 );
			OffsetX -= (32 + 8)*Scale;

			//rb we need to add NumWards to AeonsPlayer so the modifier can adjust that
			//Canvas.SetPos( OffsetX, 8 );
			//Canvas.DrawText(""$WardModifier(Player.WardMod).numWards, false);
		}

		if ( (Player.ScryeMod != None) && (Player.ScryeMod.bActive) )
		//if ( Player.bScryeActive )
		{

			Canvas.SetPos( OffsetX, 8*Scale );
			Canvas.DrawTile( Icons[16], 32*Scale, 32*Scale, 0, 0, 64, 64 );
			OffsetX -= (32 + 8)*Scale;
		}
		
		if ( Player.bHasteActive )//( Player.HasteMod != None )&&( Player.HasteMod.bActive ))
		{
			Canvas.SetPos( OffsetX, 8*Scale );
			Canvas.DrawTile( Icons[15], 32*Scale, 32*Scale, 0, 0, 64, 64 );
			if ( Level.bDebugMessaging )
			{
				Canvas.SetPos( OffsetX, 8*Scale );
				Canvas.DrawText(class'UWindowBase'.static.TrimFloat(HasteModifier(Player.HasteMod).TimeLeft, 2), false);
			}
			OffsetX -= (32 + 8)*Scale;
		}


		if ( Level.bDebugMessaging )
		{
			if (( Player.ShieldMod != None )&&( Player.ShieldMod.bActive ))
			{
				Canvas.Font = Canvas.SmallFont;
				Canvas.SetPos( OffsetX, 8*Scale );
				Canvas.DrawTile( Icons[17], 32*Scale, 32*Scale, 0, 0, 64, 64 );
				Canvas.SetPos( OffsetX, 8*Scale );
				Canvas.DrawText(""$ShieldModifier(Player.ShieldMod).shieldHealth, false);
				OffsetX -= (32 + 8)*Scale;
			}
		}

		if (( Player.SilenceMod != None )&&( Player.SilenceMod.bActive ))
		{
			/*
			Canvas.SetPos( OffsetX, 8 );
			Canvas.DrawTileClipped( Texture'HUDIcons', 32, 32, 64, 96, 32, 32);
			OffsetX -= (32 + 8);
			*/
			Canvas.SetPos( OffsetX, 8*Scale );
			Canvas.DrawTile( Icons[23], 32*Scale, 32*Scale, 0, 0, 64, 64 );
			OffsetX -= (32 + 8)*Scale;
		}

		if ( Player.bPhaseActive )//( Player.PhaseMod != None )&&( Player.PhaseMod.bActive ))
		{
			/*
			Canvas.SetPos( OffsetX, 8 );
			Canvas.DrawTileClipped( Texture'HUDIcons', 32, 32, 32, 96, 32, 32);
			OffsetX -= (32 + 8);
			*/
			Canvas.SetPos( OffsetX, 8*Scale );
			Canvas.DrawTile( Icons[22], 32*Scale, 32*Scale, 0, 0, 64, 64 );
			OffsetX -= (32 + 8)*Scale;
		}

		if (( Player.DispelMod != None )&&( Player.bDispelActive ))
		{
			/*
			Canvas.SetPos( OffsetX, 8 );
			Canvas.DrawTileClipped( Texture'HUDIcons', 32, 32, 96, 96, 32, 32);
			OffsetX -= (32 + 8);
			*/
			Canvas.SetPos( OffsetX, 8*Scale );
			Canvas.DrawTile( Icons[13], 32*Scale, 32*Scale, 0, 0, 64, 64 );
			OffsetX -= (32 + 8)*Scale;

		}
	
		if (( Player.FireFlyMod != None )&&( Player.FireFlyMod.bActive ))
		{
			/*
			Canvas.SetPos( OffsetX, 8 );
			Canvas.DrawTileClipped( Texture'HUDIcons', 32, 32, 192, 96, 32, 32);
			OffsetX -= (32 + 8);
			*/
			Canvas.SetPos( OffsetX, 8*Scale );
			Canvas.DrawTile( Icons[27], 32*Scale, 32*Scale, 0, 0, 64, 64 );
			OffsetX -= (32 + 8)*Scale;
		}

		if (( Player.MindShatterMod != None )&&( Player.MindShatterMod.bActive ))
		{
			/*
			Canvas.SetPos( OffsetX, 8 );
			Canvas.DrawTileClipped( Texture'HUDIcons', 32, 32, 192, 64, 32, 32);
			OffsetX -= (32 + 8);
			*/
			Canvas.SetPos( OffsetX, 8*Scale );
			Canvas.DrawTile( Icons[25], 32*Scale, 32*Scale, 0, 0, 64, 64 );
			OffsetX -= (32 + 8)*Scale;
		}

		if (( Player.ShalasMod != None )&&( Player.ShalasMod.bActive ))
		{
			/*
			Canvas.SetPos( OffsetX, 8 );
			Canvas.DrawTileClipped( Texture'HUDIcons', 32, 32, 160, 96, 32, 32);
			OffsetX -= (32 + 8);
			*/
			Canvas.SetPos( OffsetX, 8*Scale );
			Canvas.DrawTile( Icons[26], 32*Scale, 32*Scale, 0, 0, 64, 64 );
			OffsetX -= (32 + 8)*Scale;
		}

		
		if (( Player.SphereofColdMod != None )&&( Player.SphereofColdMod.bActive ))
		{
			//fix SphereofCold has no states ?
			Canvas.SetPos( OffsetX, 8 );
			//Canvas.DrawTileClipped( Texture'HUDIcons', 32, 32, 128, 64, 32, 32);
			//Canvas.DrawTile( Icons[6], 32*Scale, 32*Scale, 0, 0, 64, 64 );
			Canvas.Style = ERenderStyle.STY_Modulated;
			Canvas.DrawTile(Texture'Aeons.Trails.sphereOfCold_projTex', 32*Scale, 32*Scale, 0, 0, 128, 128 );
			Canvas.Style = ERenderStyle.STY_Normal;
			OffsetX -= (32 + 8)*Scale;
		}


/* ???
		if (( Player.HealthMod != None )&&( Player.HealthMod.bActive ))
		{
			Canvas.SetPos( OffsetX, 8 );
			//Canvas.DrawTileClipped( Texture'HUDIcons', 32, 32, 192, 64, 32, 32);
			OffsetX -= (32 + 8);
		}

		if (( Player.ManaMod != None )&&( Player.ManaMod.bActive ))
		{
			Canvas.SetPos( OffsetX, 8 );
			//Canvas.DrawTileClipped( Texture'HUDIcons', 32, 32, 192, 64, 32, 32);
			OffsetX -= (32 + 8);
		}
*/	
		

	}
}

exec function DisplayObjectives()
{
	DisplayObjectivesTime = Level.TimeSeconds + 5;
}

// Returns the next item in the inventory list
simulated function Inventory GetNextInvItem(Inventory Inv)
{
	if ( Inv == None )
	{
		Inv = Pawn(Owner).Inventory.GetNext();
		if ( Inv.IsA('Ammo') ) {
			if ((Ammo(Inv)).AmmoAmount > 0)
				return Inv;
		} else {
			return Inv;
		}
	}

	if ( Inv.Inventory!=None )
		Inv = Inv.Inventory.GetNext(); 
	else
		Inv = Pawn(Owner).Inventory.GetNext();

	if ( Inv == None )
		Inv = Pawn(Owner).Inventory.GetNext();

	if ( Inv.IsA('Ammo') )
	{
		if ((Ammo(Inv)).AmmoAmount > 0)
			return Inv;
	} else {
		return Inv;
	}
}

// Returns the previous item in the inventory list
simulated function Inventory GetPrevInvItem(Inventory cInv)
{
	local Inventory Inv, LastItem;
	
	if ( cInv == None )
	{
		cInv = Pawn(Owner).Inventory.GetNext();
		Return cInv;
	}

	if ( cInv.Inventory != None ) 
		for( Inv=cInv.Inventory; Inv!=None; Inv=Inv.Inventory )
		{
			if ( Inv == None)
				break;

			if ( (Inv.ItemType == ITEM_Inventory) && (Inv.bDisplayableInv) ) // && (!Inv.bActive && Inv.IsA('Ammo')) )
				if ( Inv.IsA('Ammo') ) {
					if ((Ammo(Inv)).AmmoAmount > 0)
						LastItem=Inv;
				} else {
					LastItem=Inv;
				}
		}

	for( Inv = Pawn(Owner).Inventory; Inv != cInv; Inv=Inv.Inventory )
	{
		if (Inv==None)
			Break;
		if ( (Inv.ItemType == ITEM_Inventory) && (Inv.bDisplayableInv) ) // && (!Inv.bActive && Inv.IsA('Ammo')) )
			if ( Inv.IsA('Ammo') ) {
				if ((Ammo(Inv)).AmmoAmount > 0)
					LastItem=Inv;
			} else {
				LastItem=Inv;
			}
	}

	if ( LastItem != None )
		cInv = LastItem;

	return cInv;
}

// checks the LuckySevenItems array for the presence of Inv
// this is used to make sure I'm not displaying an inventory item more than once in the list.
simulated function bool CheckLuckSeven(Inventory Inv)
{
	local int i;
	
	for (i=0; i<7; i++)
	{
		if (LuckySevenItems[i] == Inv)
			return false;
	}
	return true;
}

// draw the book icon if their are unread entries in the book
simulated function DrawBookInfo(Canvas Canvas)
{
	local AeonsPlayer AP;

	if ( Owner != None )
		AP = AeonsPlayer(Owner);
	
	if (AP.Book == None || bAltHud) // don't draw this hud element with new hud
		return;

	// Check to see if the newest unread should be refreshed or if data is corrupted.
	if (((AP.Book.NewestUnread == None) && (AP.Book.NumUnreadJournals > 0)) || (AP.Book.NumUnreadJournals < 0))
	{
		AP.Book.RefreshUnread();
	}

	if ((AP != None) && (AP.Book != None) && (AP.Book.NewestUnread!=None) &&
		((AP.Book.NewestUnread.Icon != None) || (AP.Book.NewestUnread.HUDIcon != None))) 
	{
		if ( AP.Book.NumUnreadJournals > 0 )
		{
			// draw book icon
			Canvas.Style = ERenderStyle.STY_AlphaBlend;
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;
			Canvas.DrawColor.A = 255;
			//Canvas.SetPos( 10, 10 );
			if (bAltHud)
			{
				Canvas.SetPos( 1 * ScaleY, Canvas.ClipY - 136*ScaleY );
			}
			else
			{
				if (AeonsPlayer(Owner).DefSpell != none)
					Canvas.SetPos( Canvas.ClipX - (WSI_Left + 192 + WSI_Padding*2)*ScaleY, Canvas.ClipY - WSI_Bottom*ScaleY );
				else
					Canvas.SetPos( Canvas.ClipX - (WSI_Left + 128 + WSI_Padding)*ScaleY, Canvas.ClipY - WSI_Bottom*ScaleY );
			}
			
			if ( AP.Book.NewestUnread.HUDIcon != None ) 
				Canvas.DrawTileClipped( AP.Book.NewestUnread.HUDIcon, 64*Scale, 64*Scale, 0, 0, 64, 64);
			else
				Canvas.DrawTileClipped( AP.Book.NewestUnread.Icon, 64*Scale, 64*Scale, 0, 0, 64, 64);

		}
	}
}


// draw objectives
simulated function DrawObjectives(Canvas Canvas)
{
	local string TempString;
	local int Token;
	local int i;

	if (Level.TimeSeconds < DisplayObjectivesTime)
	{
		Canvas.DrawColor = WhiteColor;
		Canvas.Font = Canvas.SmallFont;
		Canvas.Style = ERenderStyle.STY_Normal;

		for ( i=0; i<ArrayCount(Aeonsplayer(Owner).Objectives); i++ )
		{
			Canvas.SetPos( 50*ScaleY, (25+25*i)*ScaleY );
			
			TempString = Aeonsplayer(Owner).ObjectivesText[ Aeonsplayer(Owner).Objectives[i] ];
			Token = InStr(TempString, ",");
			
			if (Token >= 0)
			{
				TempString = Right(TempString, Len(TempString)-Token-1);
			}
			
			Canvas.DrawText( "" $ TempString, false );
		}
	}
}


// Draws the held list of inventory items
simulated function DrawHeldItems(Canvas Canvas)
{
	local inventory Inv, tempInv;
	local int cnt, i, nextGroup, PrevGroup, nextIdx, PrevIdx, SelectedGroup;
	local string InvName;
	local int InvCount;

	local float TextWidth, TextHeight, TextLeftMargin;
	local int Spacing;
	local float IconSize;
	local float XOffset, YOffset, CurrentY;

	XOffset = 4;
	//YOffset = 25;
	YOffset = 114;

	Canvas.Font = Canvas.SmallFont;
	Canvas.TextSize( "TEST", TextWidth, TextHeight );
	//Spacing = TextHeight + 8;
	Spacing = 14 * ScaleY;
	IconSize = TextHeight + 2;
	TextLeftMargin = 5 * ScaleY;
	
	cnt = 0;
	
	if(HudMode == 1)
	{

		if ( Pawn(Owner).Inventory == None )
			return;
			
		if ( PlayerPawn(Owner).selectedItem == none )
			PlayerPawn(Owner).Inventory.SelectNext();

		// must change window if on PSX2
		if ( GetPlatform() == PLATFORM_PSX2 )
		{
			// draw window texture all at once
			Canvas.Style = 2;
			Canvas.DrawColor = Canvas.Default.DrawColor;
			Canvas.SetPos( 0, 64*Scale );
			Canvas.DrawTileClipped( texture'InvWindow', 356*Scale, (256+16)*Scale, 0, 0, 128, 128);
		}
		else
		{
			// draw shadow behind inventory holder
			Canvas.Style = 4;
			Canvas.DrawColor = Canvas.Default.DrawColor;
			Canvas.SetPos( 0, (64+32)*Scale );
			Canvas.DrawTileClipped( texture'HUD_Inv_Shad_Test', 178*Scale, (128+3)*Scale, 0, 0, 64, 64);

			// draw top
			Canvas.Style = 2;
			Canvas.DrawColor = Canvas.Default.DrawColor;
			Canvas.SetPos( 0, 64*Scale );
			Canvas.DrawIcon(texture'Inv_Bar_Top', Scale);

			// draw right side
			Canvas.SetPos( 149*Scale, (64+11)*Scale);
			Canvas.DrawTileClipped( texture'Inv_Bar_Right', 64*Scale, 128*Scale, 0, 0, 64, 128);

			// draw bottom
			Canvas.SetPos( 0, (64+64+64)*Scale);
			Canvas.DrawIcon(texture'Inv_Bar_Bottom', Scale);
		}
	
		for (i=0; i<7; i++)
			LuckySevenItems[i] = none;

		// this is the selected Item
		LuckySevenItems[3] = PlayerPawn(Owner).selectedItem;

		// SLOT 2
		Inv = GetPrevInvItem(LuckySevenItems[3]);
		if ( CheckLuckSeven(Inv) )
			LuckySevenItems[2] = Inv;

		// SLOT 4
		Inv = GetNextInvItem(LuckySevenItems[3]);
		if ( CheckLuckSeven(Inv) )
			LuckySevenItems[4] = Inv;

		// SLOT 1
		Inv = GetPrevInvItem(LuckySevenItems[2]);
		if ( CheckLuckSeven(Inv) )
			LuckySevenItems[1] = Inv;

		// SLOT 5
		Inv = GetNextInvItem(LuckySevenItems[4]);
		if ( CheckLuckSeven(Inv) )
			LuckySevenItems[5] = Inv;

		// SLOT 0
		Inv = GetPrevInvItem(LuckySevenItems[1]);
		if ( CheckLuckSeven(Inv) )
			LuckySevenItems[0] = Inv;

		// SLOT 6
		Inv = GetNextInvItem(LuckySevenItems[5]);
		if ( CheckLuckSeven(Inv) )
			LuckySevenItems[6] = Inv;

		// again, draw text differently if on PSX2
		if ( GetPlatform() == PLATFORM_PSX2 )
		{
			Canvas.Style = 1;
			Canvas.Font = Canvas.MedFont;
		}
		else
		{
			Canvas.Style = 3;
			Canvas.Font = Canvas.SmallFont;
		}

		for (i=0; i<7; i++)
		{
			// one last time, position text differently on PSX2
			Inv = LuckysevenItems[i];

			if (bAltHud)
			{
				CurrentY = YOffset*ScaleY + (i * Spacing) + Spacing / 2.0; // centered spacing
				Canvas.Style = ERenderStyle.STY_AlphaBlend;
				Canvas.DrawColor = WhiteColor;
				Canvas.DrawColor.a = 255;
				Canvas.bNoSmooth = false;
				Canvas.SetPos( XOffset*ScaleX, CurrentY - IconSize / 2.0 );
				Canvas.DrawIcon(Inv.Icon, IconSize / 64.0);

				// draw text
				Canvas.SetPos( XOffset*ScaleX + IconSize + TextLeftMargin, CurrentY - TextHeight / 2.0 );
			}
			else
			{
				if ( GetPlatform() == PLATFORM_PSX2 )
					Canvas.SetPos( 8*Scale, (80 + (i * 36))*Scale );
				else
					Canvas.SetPos( 8*Scale, (114 + (i * 14))*Scale );
			}
					
			if ( i == 3 )
			{
				// canvas color for the middle (selected) item
				Canvas.DrawColor.R = 100;
				Canvas.DrawColor.G = 100;
				Canvas.DrawColor.B = 200;
			} else {
				if ((i == 2) || (i == 4))
				{
					Canvas.DrawColor.R = 75;
					Canvas.DrawColor.G = 75;
					Canvas.DrawColor.B = 100;
				} else if ((i == 1) || (i == 5)) {
					Canvas.DrawColor.R = 50;
					Canvas.DrawColor.G = 50;
					Canvas.DrawColor.B = 75;
				} else if ((i == 0) || (i == 6)) {
					Canvas.DrawColor.R = 25;
					Canvas.DrawColor.G = 25;
					Canvas.DrawColor.B = 50;
				}
			}
			
			if ( Inv == none )
			{
				InvName = ("");		// empty slot
				// InvName = ("---  :  ------- : ---");		// empty slot
			}
			else
			{
				if (Inv.IsA('Ammo'))
					InvCount = Ammo(Inv).AmmoAmount;
				else if (Pickup(Inv).numCopies > 0)
					InvCount = Pickup(Inv).numCopies + 1;
				else
					InvCount = 0;

				InvName = ""$Inv.ItemName;
				if (InvCount > 0)
				{
					InvName = InvName$": ";
					InvName = InvName$InvCount;
				}
			}
			Canvas.DrawText( (""$InvName), false);
		}
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;				
	}
}

simulated function DrawAmmo(Canvas Canvas, int X, int Y)
{
	local string tmpStr;
	local int Ammocount, ClipCount;
	local Ammo ammo;

	ammo = Pawn(Owner).Weapon.ammoType;

	if (ammo != none && ammo.MaxAmmo > 0)
	{
		clipCount = AeonsWeapon(Pawn(Owner).Weapon).ClipCount;
		AmmoCount = ammo.AmmoAmount - clipCount;
		AmmoCount = Clamp(AmmoCount, 0, 99999);
		
		if (ammo.AmmoAmount == 0)
			ClipCount = 0;

		tmpStr = (ClipCount$"/"$AmmoCount);
		Canvas.Font = Canvas.SmallFont;
		Canvas.SetPos( X, Y );
	
		Canvas.DrawColor.R = 200;
		Canvas.DrawColor.G = 200;
		Canvas.DrawColor.B = 255;
		
		Canvas.DrawText( tmpStr, false);
	}
}

simulated function DrawNumber(Canvas Canvas, int X, int Y, int Number, optional bool bRightAligned, optional float DigitScale)
{
	local float TotalWidth;
	local int Digits[10];
	local int i, NumDigits, Digit;

	// force zero to draw by checking NumDigits
	while (Number != 0 || NumDigits == 0)
	{
		Digit = Number % 10;
		Digits[NumDigits++] = Digit;
		TotalWidth += DigitInfo.Width[Digit]*ScaleY;
		Number /= 10;
	}

	// right align number
	if (bRightAligned)
		Canvas.CurX -= TotalWidth;

	for (i = NumDigits - 1; i >= 0; i--)
	{
		DrawDigit(Canvas, Digits[i], DigitScale);
	}
}

simulated function DrawHealth(Canvas Canvas, int X, int Y, optional bool bRightAligned)
{
	local int iTempHealth;

	if ( Pawn(Owner).Health < 0 )
		Pawn(Owner).Health = 0;

	if (HudMode > 0)
	{
		Canvas.Style = ERenderStyle.STY_AlphaBlend;

		iTempHealth = Pawn(Owner).Health;
		if ( ( iTempHealth == 0 ) && ( pawn(Owner).Health > 0.0 ) )
			iTempHealth = 1;

		if ( iTempHealth > 75 )
		{
			Canvas.DrawColor.r = 192;
			Canvas.DrawColor.g = 192;
			Canvas.DrawColor.b = 192;
		} 
		else if ( iTempHealth > 50 ) 
		{
			Canvas.DrawColor.r = 192;
			Canvas.DrawColor.g = 128;
			Canvas.DrawColor.b = 128;
		}
		else if ( iTempHealth > 25 ) 
		{
			Canvas.DrawColor.r = 192;
			Canvas.DrawColor.g = 64;
			Canvas.DrawColor.b = 64;	
		} 
		else 
		{
			Canvas.DrawColor.r = 192;
			Canvas.DrawColor.g = 32;
			Canvas.DrawColor.b = 32;	
		}

		Canvas.CurX = X;
		Canvas.CurY = Y;

		Canvas.bNoSmooth = false;

		DrawNumber(Canvas, X, Y, iTempHealth, bRightAligned);

		Canvas.DrawColor.r = 255;
		Canvas.DrawColor.g = 255;
		Canvas.DrawColor.b = 255;	
		
		Canvas.Style = ERenderStyle.STY_Normal;
	}
}

simulated function DrawConventionalWeapon(Canvas Canvas, int X, int Y)
{
	local int Slot;
	local Weapon whatToDraw;
	
	if ( (Owner == None) || (Pawn(Owner) == None) )
		return;

	if ( AeonsPlayer(Owner) != None && AeonsPlayer(Owner).bScrollObject
		&& AeonsPlayer(Owner).SelectMode == SM_Weapon )
	{
		// in this case, we don't draw the weapon held--
		// we draw the weapon to be selected
		// also draw swirly behind it, with weapon name above
		whatToDraw = Weapon(AeonsPlayer(Owner).SelectedInvPSX2);
		DrawSelectHighlightPSX2(Canvas,X,Y);
	}
	else
	{
		whatToDraw = Pawn(Owner).Weapon;
	}

	if ( whatToDraw == None )
	{
		return;
	}
	else
	{
		Slot = whatToDraw.InventoryGroup;
		
		if (HudMode > 0)
		{
			Canvas.DrawColor.r = 255;
			Canvas.DrawColor.g = 255;
			Canvas.DrawColor.b = 255;

			Canvas.Style = ERenderStyle.STY_AlphaBlend;
	
			Canvas.SetPos( X, Y );
	
			Canvas.DrawColor.r = 255;
			Canvas.DrawColor.g = 255;
			Canvas.DrawColor.b = 255;
			Canvas.DrawColor.a = 255;
	
			//fix check for valid group
			if (WhatToDraw.IsA('Shotgun'))
			{
				if (AeonsPlayer(Owner).bDoubleShotgun)
					Canvas.DrawTileClipped( Icons[29], 64*Scale, 64*Scale, 0, 0, 64, 64); 
				else	
					Canvas.DrawTileClipped( Icons[whatToDraw.InventoryGroup], 64*Scale, 64*Scale, 0, 0, 64, 64); 
			} else if (WhatToDraw.IsA('Scythe')) {
				// Draw the Berserk Glow
				Canvas.Style = ERenderStyle.STY_Translucent;
				if (Scythe(AeonsPlayer(Owner).Weapon).bBerserk)
					Canvas.DrawTileClipped( Texture'Aeons.Icons.Scythe_Icon_Glow', 64*Scale, 64*Scale, 0, 0, 64, 64); 
				// Draw the normal icon
				Canvas.Style = ERenderStyle.STY_AlphaBlend;
				Canvas.SetPos( X, Y );
				Canvas.DrawTileClipped( Icons[whatToDraw.InventoryGroup], 64*Scale, 64*Scale, 0, 0, 64, 64); 
			} else if (WhatToDraw.IsA('Speargun')) {
				// Lightning Glow
				Canvas.Style = ERenderStyle.STY_Translucent;
				if (Speargun(AeonsPlayer(Owner).Weapon).bCharged)
					Canvas.DrawTileClipped( Texture'Aeons.Icons.Speargun_Glow_Icon', 64*Scale, 64*Scale, 0, 0, 64, 64); 
				// Draw the normal icon
				Canvas.Style = ERenderStyle.STY_AlphaBlend;
				Canvas.SetPos( X, Y );
				Canvas.DrawTileClipped( Icons[whatToDraw.InventoryGroup], 64*Scale, 64*Scale, 0, 0, 64, 64); 
			} else {
				if ( Icons[whatToDraw.InventoryGroup] != None )
					Canvas.DrawTileClipped( Icons[whatToDraw.InventoryGroup], 64*Scale, 64*Scale, 0, 0, 64, 64); 
			}

	
			Canvas.DrawColor.r = 255;
			Canvas.DrawColor.g = 255;
			Canvas.DrawColor.b = 255;	
			Canvas.Style = ERenderStyle.STY_Normal;

			if ( Level.bDebugMessaging )
			{
				if ( slot == class'TibetianWarCannon'.default.InventoryGroup )
				{
					Canvas.SetPos( X+8, Y );
					Canvas.DrawText((""$TibetianWarCannon(whatToDraw).InternalMana$"  "$TibetianWarCannon(whatToDraw).ChargedMana), false);
				}
			}
		}
	}
}

simulated function DrawStealthIcons(Canvas Canvas)
{
	local string str;
	local int X, Y, ai, vi, mi;
	local float a, v, m;

	if (AeonsPlayer(Owner) == none)
		return;

	if ( (AeonsPlayer(Owner).StealthMod == None) )
		return;
	
	if ( AeonsPlayer(Owner).AttSpell != None )
	{
		if (HudMode == 1)
		{

			Canvas.Style = 3;

			a = StealthModifier(AeonsPlayer(Owner).StealthMod).AudibleStealth - 0.05;
			v = StealthModifier(AeonsPlayer(Owner).StealthMod).VisibleStealth - 0.05;
			m = StealthModifier(AeonsPlayer(Owner).StealthMod).MovementStealth - 0.05;
	
			ai = Clamp((a * 10), 0, 11);
			vi = Clamp((v * 10), 0, 11);
			mi = Clamp((m * 10), 0, 11);

			Canvas.DrawColor.R = 100;
			Canvas.DrawColor.G = 100;
			Canvas.DrawColor.B = 255;

			Canvas.SetPos(HalfClipX - 28 * ScaleX, Canvas.ClipY - 18*Scale);
			Canvas.DrawTileClipped( Texture'Aeons.StealthIcon', 16*Scale, 16*Scale, 0 + (16*vi), 0, 16, 16);

			Canvas.DrawColor.R = 100;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 100;

			Canvas.SetPos(HalfClipX - 8 * ScaleX, Canvas.ClipY - 18*Scale);
			Canvas.DrawTileClipped( Texture'Aeons.StealthIcon', 16*Scale, 16*Scale, 0 + (16*ai), 0, 16, 16);

			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 100;

			Canvas.SetPos(HalfClipX + 12 * ScaleX, Canvas.ClipY - 18*Scale);
			Canvas.DrawTileClipped( Texture'Aeons.StealthIcon', 16*Scale, 16*Scale, 0 + (16*mi), 0, 16, 16);
		}
	}
}


simulated function DrawDefensiveSpellAmplitude(Canvas Canvas, int X, int Y)
{
	local string 	str;
	local int 		i, Lvl;
	local bool		bGhelz;
		
	if (AeonsPlayer(Owner) == none)
		return;

	if ( AeonsPlayer(Owner).DefSpell != None )
	{
		Lvl = AeonsPlayer(Owner).DefSpell.castingLevel;
		if ( AeonsPlayer(Owner).Weapon.IsA('GhelziabahrStone') )
		{
			bGhelz = true;
			Lvl ++;
		}

		if (HudMode == 1)
		{
			Canvas.DrawColor.R = 200;
			Canvas.DrawColor.G = 200;
			Canvas.DrawColor.B = 255;

			if (PlayerPawn(Owner).bAmplifySpell && (AeonsPlayer(Owner).DefSpell.castingLevel <= 3))
			{
				Canvas.DrawColor.R = 255;
				Canvas.DrawColor.G = 100;
				Canvas.DrawColor.B = 100;
			}

			Canvas.Style = 3;

			for (i=0; i<6; i++)
			{
				if ( Lvl >= i )
				{
					Canvas.SetPos(X + (i*9) * Scale, Y);
					if (bGhelz && (i == Lvl))
					{
						Canvas.DrawTileClipped( Texture'Aeons.dot_green', 8*Scale, 8*Scale, 0, 0, 8, 8);
					} else {
						Canvas.DrawTileClipped( Texture'Aeons.dot', 8*Scale, 8*Scale, 0, 0, 8, 8);
					}
				}
			}
		}
	}
}

simulated function DrawOffensiveSpellAmplitude(Canvas Canvas, int X, int Y)
{
	local string 	str;
	local int 		i, Lvl;
	local bool		bGhelz;
	
	if (AeonsPlayer(Owner) == none)
		return;

	if ( AeonsPlayer(Owner).AttSpell != None )
	{
		Lvl = AeonsPlayer(Owner).AttSpell.castingLevel;
		if ( AeonsPlayer(Owner).Weapon.IsA('GhelziabahrStone') )
		{
			bGhelz = true;
			Lvl ++;
		}

		if (HudMode == 1)
		{
			Canvas.DrawColor.R = 200;
			Canvas.DrawColor.G = 200;
			Canvas.DrawColor.B = 255;

			if (PlayerPawn(Owner).bAmplifySpell && (AeonsPlayer(Owner).AttSpell.castingLevel <= 3))
			{
				Canvas.DrawColor.R = 255;
				Canvas.DrawColor.G = 100;
				Canvas.DrawColor.B = 100;
			}

			Canvas.Style = 3;

			for (i=0; i<6; i++)
			{
				if ( Lvl >= i )
				{
					Canvas.SetPos(X + (i*9) * Scale, Y);
					if (bGhelz && (i == Lvl))
					{
						Canvas.DrawTileClipped( Texture'Aeons.dot_green', 8*Scale, 8*Scale, 0, 0, 8, 8);
					} else {
						Canvas.DrawTileClipped( Texture'Aeons.dot', 8*Scale, 8*Scale, 0, 0, 8, 8);
					}
				}
			}
		}
	}
}

simulated function DrawOffensiveSpell(Canvas Canvas, int X, int Y)
{
	local int Slot;
	local Spell whatToDraw;
	
	if (AeonsPlayer(Owner) == none)
		return;

	if ( AeonsPlayer(Owner).bScrollObject && AeonsPlayer(Owner).SelectMode == SM_AttSpell )
	{
		// in this case, we don't draw the spell held--
		// we draw the spell to be selected
		// also draw swirly behind it, with spell name above
		whatToDraw = Spell(AeonsPlayer(Owner).SelectedInvPSX2);
		DrawSelectHighlightPSX2(Canvas,X,Y);
	}
	else
	{
		whatToDraw = AeonsPlayer(Owner).AttSpell;
	}

	if ( whatToDraw != None )
	{
		Slot = whatToDraw.InventoryGroup - 11;		
		if (HudMode > 0)
		{
			Canvas.DrawColor.r = 255;
			Canvas.DrawColor.g = 255;
			Canvas.DrawColor.b = 255;

/*			Shadows
			Canvas.Style = ERenderStyle.STY_Modulated;
			Canvas.bNoSmooth = false;
			//Canvas.SetPos( X-64*1.0*Scale/2.0, Y-64*1.0*Scale/2.0 );
			//Canvas.SetPos( Canvas.ClipX - (64+16+64+16+8)*Scale, Canvas.ClipY - (64+8+8)*Scale );
			Canvas.SetPos( X, Y );
			Canvas.DrawIcon( Shadows[whatToDraw.InventoryGroup], 1.25*Scale);//extra 32 pixels
*/


			Canvas.Style = ERenderStyle.STY_AlphaBlend;
	
			Canvas.SetPos( X, Y );
				
			Canvas.DrawColor.r = 255;
			Canvas.DrawColor.g = 255;
			Canvas.DrawColor.b = 255;	
			Canvas.DrawColor.a = 255;
			
			//Canvas.DrawTileClipped( Texture'HUDIcons', 32, 32, Slot*32 , 64, 32, 32);
			
			if (whatToDraw.InventoryGroup == 16) //scrye has a black bar on the left for whatever reason
				Canvas.DrawTileClipped( Icons[whatToDraw.InventoryGroup], 64*Scale, 64*Scale, 1, 0, 64, 64);
			else
				Canvas.DrawTileClipped( Icons[whatToDraw.InventoryGroup], 64*Scale, 64*Scale, 0, 0, 64, 64);
	
			Canvas.DrawColor.r = 255;
			Canvas.DrawColor.g = 255;
			Canvas.DrawColor.b = 255;	
			Canvas.DrawColor.a = 255;

			Canvas.Style = ERenderStyle.STY_Normal;
		}
	}
	else
	{
		// no active off spell
	}
}

simulated function DrawDefensiveSpell(Canvas Canvas, int X, int Y)
{
	local int Slot;
	local Spell whatToDraw;
	
	if (AeonsPlayer(Owner) == none)
		return;

	if ( AeonsPlayer(Owner).DefSpell == none ) 
		return;

	if ( AeonsPlayer(Owner).bScrollObject && AeonsPlayer(Owner).SelectMode == SM_DefSpell )
	{
		// in this case, we don't draw the spell held--
		// we draw the spell to be selected
		// also draw swirly behind it, with spell name above
		whatToDraw = Spell(AeonsPlayer(Owner).SelectedInvPSX2);
		DrawSelectHighlightPSX2(Canvas,X,Y);
	}
	else
	{
		whatToDraw = AeonsPlayer(Owner).DefSpell;
	}

	if ( whatToDraw == None )
	{
		return;
	}
	else
	{
		Slot = whatToDraw.InventoryGroup - 21;
		
		if (HudMode > 0 )
		{


			Canvas.DrawColor.r = 255;
			Canvas.DrawColor.g = 255;
			Canvas.DrawColor.b = 255;

/*			Shadows
			Canvas.Style = ERenderStyle.STY_Modulated;
			Canvas.bNoSmooth = false;
	
			//Canvas.SetPos( Canvas.ClipX - (64+16+8)*Scale, Canvas.ClipY - (64+8+8)*Scale );
			Canvas.SetPos( X, Y);

			Canvas.DrawIcon( Shadows[whatToDraw.InventoryGroup], 1.25*Scale);//extra 32 pixels
*/

			Canvas.Style = ERenderStyle.STY_AlphaBlend;
	
			Canvas.SetPos(X, Y);
	
			Canvas.DrawColor.r = 255;
			Canvas.DrawColor.g = 255;
			Canvas.DrawColor.b = 255;
			Canvas.DrawColor.a = 255;
	
			// replace this with a 
			//Canvas.DrawTileClipped( Texture'HUDIcons', 32, 32, Slot*32 , 96, 32, 32);
			Canvas.DrawTileClipped( Icons[whatToDraw.InventoryGroup], 64*Scale, 64*Scale, 0, 0, 64, 64);

			Canvas.DrawColor.r = 255;
			Canvas.DrawColor.g = 255;
			Canvas.DrawColor.b = 255;
			Canvas.DrawColor.a = 255;
			
			Canvas.Style = ERenderStyle.STY_Normal;
		}
	}
}

simulated function DrawSelectHighlightPSX2(Canvas Canvas, int X, int Y)
{
	local string SelectedName;
	local float TextWidth, TextHeight;
	local texture BackLayer;

	if ( AeonsPlayer(Owner) == None )
		return;

	// Draw swirly at coordinates provided
	Canvas.SetPos( X - 128*Scale/4, Y - 128*Scale/4 );
	
	Canvas.bNoSmooth = false;

	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;
	Canvas.Style = 3;

	BackLayer = FireTexture'FX.Swirl';		
	Canvas.DrawTileClipped(BackLayer, 128*Scale, 128*Scale, 0, 0, 64, 64);

	// Now draw text above icon
	Canvas.Style = 1;
	if ( AeonsPlayer(Owner).SelectedInvPSX2 != None )
	{
		SelectedName = AeonsPlayer(Owner).SelectedInvPSX2.ItemName;

		if ( AeonsPlayer(Owner).SelectedInvPSX2.ItemName != "" )
		{
			Canvas.TextSize( SelectedName, TextWidth, TextHeight );
			if ( AeonsPlayer(Owner).SelectMode == SM_Weapon )
				Canvas.SetPos( X, Y - 128*Scale/3 - TextHeight*2 );
			else if ( AeonsPlayer(Owner).SelectMode == SM_AttSpell )
				Canvas.SetPos( X - TextWidth/2, Y - 128*Scale/3 - TextHeight*2 );
			else
				Canvas.SetPos( X - TextWidth/2, Y - 128*Scale/3 - TextHeight*2 );

			Canvas.Font = Canvas.MedFont;
			Canvas.DrawColor = WhiteColor;
			Canvas.DrawText( SelectedName );
		}
	}

	Canvas.bNoSmooth = true;
	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;
	Canvas.DrawColor.a = 255;
}

simulated function DrawInventoryItem(Canvas Canvas, int X, int Y)
{
	local inventory Inv;

	if (Owner == none)
		return;

	if (HudMode == 1)
	{
		if ( Owner.Inventory!=None ) 
		{
			for ( Inv=Owner.Inventory; Inv!=None; Inv=Inv.Inventory )
			{
				//Log("InventoryGroup = " $ Inv.InventoryGroup $ " bActive = " $ Inv.bActive );
				//fix just a note that Inventory contains everything.
				//fix so our lists of attspell, defspell, weapon are duplicates
				if ( (Inv == PlayerPawn(Owner).selectedItem) && (Inv.InventoryGroup >= 100))
				{
					Canvas.Style = ERenderStyle.STY_Alphablend;
					// km Canvas.Style = ERenderStyle.STY_Masked;
			
					if (!Inv.bActiveToggle || Inv.bActive)
					{
						Canvas.DrawColor.r = 255;
						Canvas.DrawColor.g = 255;
						Canvas.DrawColor.b = 255;	
					} 
					else 
					{
						Canvas.DrawColor.r = 128;
						Canvas.DrawColor.g = 128;
						Canvas.DrawColor.b = 128;	
					}
			
					Canvas.SetPos( X, Y );
	
					Canvas.DrawIcon(Inv.Icon, Scale);
					
					Canvas.DrawColor.r = 255;
					Canvas.DrawColor.g = 255;
					Canvas.DrawColor.b = 255;	
					
					Canvas.Style = ERenderStyle.STY_Normal;

				}
			}			
		}
	}
}


//----------------------------------------------------------------------------

simulated function DrawWheel(Canvas Canvas, int InvGroup[8])
{
	local int X, Y;
	local int CenterX, CenterY;
	local int i;

	CenterX = Canvas.sizeX * 0.5;
	CenterY = Canvas.sizeY * 0.5;

	//Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.Style = ERenderStyle.STY_AlphaBlend;

	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;	

	for ( i = 0; i < 8; i++ )
	{
		X = CenterX + Scale * Con_X[i] / ClampedHudScale;
		Y = CenterY + Scale * Con_Y[i] / ClampedHudScale;
		DrawWheelIcon(Canvas, InvGroup[i], i, X, Y, 64, 64 );
	}

	Canvas.Style = ERenderStyle.STY_Normal;
}


simulated function DrawGhelzUse( canvas Canvas, int X, int Y )
{
	local int useAmount;
	
	if (AeonsPlayer(Owner) == none)
		return;

	if ( AeonsPlayer(Owner).Weapon.IsA('GhelziabahrStone') )
	{
		useAmount = GhelziabahrStone(AeonsPlayer(Owner).Weapon).useMeter;

		Canvas.Font = Canvas.SmallFont;
		Canvas.SetPos( X, Y );
	
		Canvas.DrawColor.R = 200;
		Canvas.DrawColor.G = 200;
		Canvas.DrawColor.B = 255;
		
		Canvas.DrawText( UseAmount, false);
	}

}


simulated function DrawCenterpiece( canvas Canvas )
{
	local float ManaX;
	if ( HudMode == 0 ) 
		return;

	Canvas.DrawColor.r = 192;
	Canvas.DrawColor.g = 192;
	Canvas.DrawColor.b = 192;
	Canvas.DrawColor.a = 255;

	Canvas.bNoSmooth = false;

	if (bAltHud)
		Canvas.SetPos(WSI_Left*ScaleY, Canvas.ClipY - 62*ScaleY);
	else
		Canvas.SetPos( HalfClipX - (64+19)*ScaleY, Canvas.ClipY - 62*ScaleY); // was 68
	Canvas.Style = ERenderStyle.STY_AlphaBlend;
	Canvas.DrawTileClipped( Texture'Health', 64*ScaleY, 60*ScaleY, 0, 0, 64, 60);

	ManaX = HalfClipX + 19 * ScaleY;
	if (bAltHud)
		ManaX = (128 + WSI_Left + WSI_Padding*2)*ScaleY;
	
	// glow on mana icon - shows when you don't have enough mana
	if (Level.TimeSeconds < AeonsPlayer(Owner).NoManaFlashTime)
	{
		Canvas.SetPos( ManaX, Canvas.ClipY - 62*ScaleY);
		Canvas.Style = ERenderStyle.STY_Translucent;
		Canvas.DrawTileClipped( Texture'Mana_Icon_Glow', 64*ScaleY, 64*ScaleY, 0, 0, 64, 64);
	}

	Canvas.SetPos( ManaX, Canvas.ClipY - 62*ScaleY); // was 66 in old renewal, 62 in undying
	Canvas.Style = ERenderStyle.STY_AlphaBlend;
	Canvas.DrawTileClipped( Texture'Mana_Icon', 64*ScaleY, 60*ScaleY, 0, 0, 64, 60);
}


simulated function DrawFlightMana( canvas Canvas )
{
	local int Fuel;
	local int Height;
	local float FuelRatio;
	
	if (AeonsPlayer(Owner) == none)
		return;

	if ( HudMode == 0 ) 
		return;

	if ( AeonsPlayer(Owner).Flight == None || !Level.bAllowFlight )
		return;


	Fuel = AeonsPlayer(Owner).Flight.Fuel;
	FuelRatio = Fuel / 60.0;
	
//	Canvas.Font = Canvas.LargeFont;
//	Canvas.SetPos( X, Y );

	if ( Fuel >= 30 ) 
	{
		Canvas.DrawColor.R = 0;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 0;
	}
	else
	{
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 0;
		Canvas.DrawColor.B = 0;
	}

/*
	Canvas.DrawColor.R = 192 - 192*FuelRatio;
	Canvas.DrawColor.G = FuelRatio*192;
	Canvas.DrawColor.B = 0;
*/
	
	Height = 30 * FuelRatio;
  
	Canvas.Style = ERenderStyle.STY_Masked;
	Canvas.SetPos( HalfClipX - 19*ScaleY, Canvas.ClipY - (Height+21)*ScaleY); 
	Canvas.DrawTileClipped( Texture'FlightBar_Icon_Fixed', 40*ScaleY, (Height+6)*ScaleY, 0, 32-Height, 32, Height);

	Canvas.DrawColor.r = 192;
	Canvas.DrawColor.g = 192;
	Canvas.DrawColor.b = 192;
	Canvas.DrawColor.a = 255;

	Canvas.Style = 5;

	Canvas.SetPos( HalfClipX - 72*ScaleY, Canvas.ClipY - 75.0*ScaleY); 
	Canvas.DrawTileClipped( Texture'Flight_Icon', 144*ScaleY, 64*ScaleY, 0, 0, 144, 64);
}

simulated function DrawMana(Canvas Canvas, int X, int Y, optional bool bRightAligned)
{
	local int iTempMana;

	if (AeonsPlayer(Owner) == none)
		return;

	if ( AeonsPlayer(Owner).Mana < 0 )
		AeonsPlayer(Owner).Mana = 0;

	if (HudMode > 0)
	{
		Canvas.Style = ERenderStyle.STY_Masked;

		Canvas.CurX = 0;
		Canvas.CurY = Canvas.ClipY - WSI_Bottom*ScaleY;
/*
		else
		{
			Canvas.CurY = Canvas.ClipY - 229;
			Canvas.DrawTile( Texture'LeftHud', 72, 228, 0, 0, 72, 228 );		
		}
*/

/*
		Canvas.CurX = 81;
		Canvas.CurY = Canvas.ClipY - 43;

		iFound = 1;
		iWidth = 23 + 35 * iFound;
		Canvas.DrawTileClipped( Texture'SlidingPieces', iWidth, 43, 205 - iWidth, 0, iWidth, 43);
*/
		iTempMana = AeonsPlayer(Owner).Mana;
	
		if ( iTempMana > 75 )
		{
			Canvas.DrawColor.r = 192;
			Canvas.DrawColor.g = 192;
			Canvas.DrawColor.b = 192;
		}
		else if ( iTempMana > 50 )
		{
			Canvas.DrawColor.r = 192;
			Canvas.DrawColor.g = 128;
			Canvas.DrawColor.b = 128;
		}
		else if ( iTempMana > 25 )
		{
			Canvas.DrawColor.r = 192;
			Canvas.DrawColor.g = 64;
			Canvas.DrawColor.b = 64;
		}
		else
		{
			Canvas.DrawColor.r = 192;
			Canvas.DrawColor.g = 32;
			Canvas.DrawColor.b = 32;	
		}

		Canvas.CurX = X;	
		Canvas.CurY = Y;

		Canvas.bNoSmooth = false;
		Canvas.Style = ERenderStyle.STY_AlphaBlend;

		DrawNumber(Canvas, X, Y, iTempMana, bRightAligned);

		/*
		if (Level.Pauser=="")
		{
			if ( FRand() < 0.1 ) 
				Pawn(Owner).Health -= 1;
		}
		*/

		//if ( Pawn(Owner).Health < 0 )
		//	Pawn(Owner).Health = 100;

		//if (Pawn(Owner).Health<25) Canvas.Font = Font'LargeRedFont';
		//Canvas.DrawIcon(Texture'IconHealth', 1.0);
		//Canvas.CurY += 29;	
		//DrawIconValue(Canvas, Max(0,Pawn(Owner).Health));
		//Canvas.CurY -= 29;		
		//if (HudMode==0) 
		//Canvas.DrawText(Max(0,Pawn(Owner).Health),False);	
		//Canvas.CurY = Y+29;		
		//Canvas.CurX = X+2;
		//if (HudMode!=1 && HudMode!=2 && HudMode!=4) 
		//	Canvas.DrawTile(Texture'HudLine',FMin(27.0*(float(Pawn(Owner).Health)/float(Pawn(Owner).Default.Health)),27),2.0,0,0,32.0,2.0);	
		
		Canvas.Style = ERenderStyle.STY_Normal;
	}
}

simulated function DrawUsedMana(Canvas Canvas, int X, int Y, optional bool bRightAligned)
{
	local float fTempMana;

	if (AeonsPlayer(Owner) == none)
		return;

	fTempMana = AeonsPlayer(Owner).Mana;
	
	if (LastMana - fTempMana >= 5)
	{
		// draw mana use
		UsedManaFlashTime = Level.TimeSeconds + 1;
		UsedMana = LastMana - fTempMana;
	}
	LastMana = fTempMana;
	
	if ( UsedManaFlashTime <= Level.TimeSeconds || HudMode <= 0 )
		return;
	
	Canvas.bNoSmooth = false;
	Canvas.Style = ERenderStyle.STY_AlphaBlend;
	Canvas.bCenter = false;
	
	// - sign outline
	Canvas.CurX = X - 1;	
	Canvas.CurY = Y + 15 * ScaleY;
	Canvas.DrawColor.r = 30;
	Canvas.DrawColor.g = 0;
	Canvas.DrawColor.b = 0;
	Canvas.DrawTileClipped(Texture'UWindow.WhiteTexture', 16*ScaleY*0.5 + 2, 5*ScaleY*0.5 + 2, 0, 0, 8, 8);
	
	// - sign
	Canvas.CurX = X;	
	Canvas.CurY = Y + 16 * ScaleY;
	Canvas.DrawColor.r = 200;
	Canvas.DrawColor.g = 5;
	Canvas.DrawColor.b = 5;
	Canvas.DrawTileClipped(Texture'UWindow.WhiteTexture', 16*ScaleY*0.5, 5*ScaleY*0.5, 0, 0, 8, 8);
	
	Canvas.CurX += 2 * ScaleX;
	Canvas.CurY = Y;
	
	DrawNumber(Canvas, X, Y, UsedMana, bRightAligned, 0.5);
	
	//Canvas.DrawText(("-"$UsedMana), false);

	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.bCenter = false;
}

simulated function DrawTypingPrompt( canvas Canvas, console Console )
{
	local string TypingPrompt;
	local float XL, YL;

	if ( Console.bTyping )
	{
		Canvas.DrawColor.r = 255;
		Canvas.DrawColor.g = 255;
		Canvas.DrawColor.b = 255;	
		TypingPrompt = "> "$Console.TypedStr$"_";
		Canvas.Font = Canvas.MedFont;
		Canvas.Style = ERenderStyle.STY_AlphaBlend;
		Canvas.StrLen( TypingPrompt, XL, YL );
		Canvas.SetPos( 50*Scale, Canvas.ClipY - 150*Scale);// Console.FrameY - Console.ConsoleLines - YL - 1 );
		Canvas.DrawText( TypingPrompt, false );
	}

}

simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name Type )
{
	Super.Message(PRI, Msg, Type);
	if (OSMClientMessage && Type == 'Pickup')
		AeonsPlayer(Owner).ScreenMessage(Msg, 4.0);
}

simulated function bool DisplayMessages( canvas Canvas )
{
	local string TypingPrompt;
	local float XL, YL;
	local int I, J, YPos, ExtraSpace;
	local float PickupColor;
	local console Console;
	local inventory Inv;
	local MessageStruct ShortMessages[4];
	local string MessageString[4];
	local name MsgType;

	if (Owner == none)
		return false;

	Console = PlayerPawn(Owner).Player.Console;

	Canvas.Font = Canvas.SmallFont;//Font'WhiteFont';

	if ( !Console.Viewport.Actor.bShowMenu )
		DrawTypingPrompt(Canvas, Console);

	if ( (Console.TextLines > 0) && (!Console.Viewport.Actor.bShowMenu || Console.Viewport.Actor.bShowScores) )
	{
		MsgType = Console.GetMsgType(Console.TopLine);
		if ( !OSMClientMessage && MsgType == 'Pickup' )
		{
			Canvas.Font = Canvas.MedFont;
			Canvas.bCenter = true;
			// STY_AlphaBlend or STY_Normal = outline, STY_Translucent = no outline
			//fix if ( Level.bHighDetailMode )
				Canvas.Style = ERenderStyle.STY_Translucent;
			//else
			//	Canvas.Style = ERenderStyle.STY_Normal;
			PickupColor = 42.0 * FMin(6, Console.GetMsgTick(Console.TopLine));
			Canvas.DrawColor.r = PickupColor;
			Canvas.DrawColor.g = PickupColor;
			Canvas.DrawColor.b = PickupColor;
			Canvas.SetPos(4*ScaleX, Canvas.ClipY * 0.76);
			Canvas.DrawText( Console.GetMsgText(Console.TopLine), true );
			Canvas.bCenter = false;
			Canvas.Style = 1;
			J = Console.TopLine - 1;
		} 
		else if ( (MsgType == 'CriticalEvent') || (MsgType == 'LowCriticalEvent')
					|| (MsgType == 'RedCriticalEvent') ) 
		{
			Canvas.bCenter = true;
			Canvas.Style = 3; //fix 1
			Canvas.DrawColor.r = 0;
			Canvas.DrawColor.g = 128;
			Canvas.DrawColor.b = 255;
			if ( MsgType == 'CriticalEvent' ) 
				Canvas.SetPos(0, Console.FrameY/2 - 32*ScaleY);
			else if ( MsgType == 'LowCriticalEvent' ) 
				Canvas.SetPos(0, Console.FrameY/2 + 32*ScaleY);
			else if ( MsgType == 'RedCriticalEvent' ) {
				PickupColor = 42.0 * FMin(6, Console.GetMsgTick(Console.TopLine));
				Canvas.DrawColor.r = PickupColor;
				Canvas.DrawColor.g = 0;
				Canvas.DrawColor.b = 0;	
				Canvas.SetPos(4, Console.FrameY - 44*ScaleY);
			}

			Canvas.DrawText( Console.GetMsgText(Console.TopLine), true );
			Canvas.bCenter = false;
			J = Console.TopLine - 1;
		} 
		else 
			J = Console.TopLine;

		I = 0;
		while ( (I < 4) && (J >= 0) )
		{
			MsgType = Console.GetMsgType(J);
			if ((MsgType != '') && (MsgType != 'Log'))
			{
				MessageString[I] = Console.GetMsgText(J);
				if ( (MessageString[I] != "") && (Console.GetMsgTick(J) > 0.0) )
				{
					if ( (MsgType == 'Event') || (MsgType == 'DeathMessage') )
					{
						ShortMessages[I].PRI = None;
						ShortMessages[I].Type = MsgType;
						I++;
					} 
					else if ( (MsgType == 'Say') || (MsgType == 'TeamSay') )
					{
						ShortMessages[I].PRI = Console.GetMsgPlayer(J);
						ShortMessages[I].Type = MsgType;
						I++;
					}
				}
			}
			J--;
		}

		// decide which speech message to show face for
		// FIXME - get the face from the PlayerReplicationInfo.TalkTexture
		J = 0;
		Canvas.Font = Canvas.SmallFont;//Font'WhiteFont';
		Canvas.StrLen("TEST", XL, YL );
		for ( I=0; I<4; I++ )
			if (MessageString[3 - I] != "")
			{
				YPos = 2 + (10 * J) + (10 * ExtraSpace); 
				if ( !DrawMessageHeader(Canvas, ShortMessages[3 - I], YPos*ScaleY) )
				{
					if (ShortMessages[3 - I].Type == 'DeathMessage')
						Canvas.DrawColor = RedColor;
					else 
					{
						Canvas.DrawColor.r = 200;
						Canvas.DrawColor.g = 200;
						Canvas.DrawColor.b = 200;	
					}
					Canvas.SetPos(4*ScaleX, YPos*ScaleY);
				}
				if ( !SpecialType(ShortMessages[3 - I].Type) ) {
					Canvas.DrawText(MessageString[3-I], false );
					J++;
				}
				if ( YL == 18.0*ScaleY )
					ExtraSpace++;
			}
	}
	return true;
}

simulated function bool SpecialType(Name Type)
{
	if (Type == '')
		return true;
	if (Type == 'Log')
		return true;
	if (Type == 'Pickup')
		return true;
	if (Type == 'CriticalEvent')
		return true;
	if (Type == 'LowCriticalEvent')
		return true;
	if (Type == 'RedCriticalEvent')
		return true;
	return false;
}

simulated function float DrawNextMessagePart( Canvas Canvas, coerce string MString, float XOffset, int YPos )
{
	local float XL, YL;

	Canvas.SetPos(4*ScaleX + XOffset, YPos);
	Canvas.StrLen( MString, XL, YL );
	XOffset += XL;
	Canvas.DrawText( MString, false );
	return XOffset;
}

simulated function bool DrawMessageHeader(Canvas Canvas, MessageStruct ShortMessage, int YPos)
{
	local float XOffset;

	if ( ShortMessage.Type != 'Say' )
		return false;

	Canvas.DrawColor = WhiteColor;
	XOffset += ArmorOffset*ScaleX;
	XOffset = DrawNextMessagePart(Canvas, ShortMessage.PRI.PlayerName$": ", XOffset, YPos);	
	Canvas.SetPos(4*ScaleX + XOffset, YPos);
	return true;
}

function float avgFrameTime()
{
	local float f;
	f = (frameTimes[0] + frameTimes[1] + frameTimes[2] + frameTimes[3] + frameTimes[4]) * 0.2;
	return f;
}

simulated function Tick(float DeltaTime)
{
	super.Tick( DeltaTime );

	IdentifyFadeTime -= DeltaTime;
	if (IdentifyFadeTime < 0.0)
		IdentifyFadeTime = 0.0;
	
	if (MOTDFadeOutTime > 200)
		MOTDFadeOutTime -= DeltaTime * 15;
	else
		MOTDFadeOutTime -= DeltaTime * 45;
		
	if (MOTDFadeOutTime < 0.0)
		MOTDFadeOutTime = 0.0;

	WheelTextTimer -= DeltaTime;
	if ( WheelTextTimer < 0.0 ) 
		WheelTextTimer = 0.0;

	// update blood splats on HUD
	UpdateSplats(DeltaTime);

	// update subtitles, if any
	UpdateSubtitles(DeltaTime);

	// framerate counter
	frameTimes[fCount] = DeltaTime;		// add deltatime to shortlist of last 5 frame times
	fCount ++;
	if ( fCount > 4 )
		fCount = 0;
	frameTime = (1.0 / avgFrameTime());
}

simulated function bool TraceIdentify(canvas Canvas)
{
	local actor Other;
	local vector HitLocation, HitNormal, X, Y, Z, StartTrace, EndTrace;
	local int HitJoint;

	StartTrace = Owner.Location;
	StartTrace.Z += Pawn(Owner).BaseEyeHeight;

	EndTrace = StartTrace + vector(Pawn(Owner).ViewRotation) * 1000.0;

	Other = Trace(HitLocation, HitNormal, HitJoint, EndTrace, StartTrace, true);

	if ( (Pawn(Other) != None) && (Pawn(Other).bIsPlayer) )
	{
		IdentifyTarget = Pawn(Other);
		IdentifyFadeTime = 3.0;
	}

	if ( IdentifyFadeTime == 0.0 )
		return false;

	if ( (IdentifyTarget == None) || (!IdentifyTarget.bIsPlayer) ||
		 (IdentifyTarget.bHidden) || (IdentifyTarget.PlayerReplicationInfo == None ))
		return false;

	return true;
}

simulated function bool TraceIdentifyPawn(canvas Canvas)
{
	local actor Other;
	local vector HitLocation, HitNormal, X, Y, Z, StartTrace, EndTrace, EyeHeight;
	local int HitJoint;

	EyeHeight.z = Pawn(Owner).EyeHeight;
	StartTrace = Owner.Location + EyeHeight;

	EndTrace = StartTrace + vector(Pawn(Owner).ViewRotation) * 2048;

	Other = Trace(HitLocation, HitNormal, HitJoint, EndTrace, StartTrace, true);

	if ( Pawn(Other) != None)
	{
		IdentifyTarget = Pawn(Other);
		IdentifyFadeTime = 0.5;
	}

	if ( IdentifyFadeTime == 0.0 )
		return false;

	if ( (IdentifyTarget == None) || (IdentifyTarget.bHidden) )
		return false;

	return true;
}

simulated function name TraceIdentifyJoint()
{
	local vector Start, End, EyeOffset, HitLocation, HitNormal;
	local int HitJoint;
	local Actor A;
	
	EyeOffset.z = Pawn(Owner).EyeHeight;
	
	Start = Pawn(Owner).Location + eyeOffset;
	End = Start + (Vector(Pawn(Owner).ViewRotation) * 2048);
	
	A = Trace(HitLocation, HitNormal, HitJoint, end, start, true, true, vect(0,0,0));
	
	if (A != none)
		return A.JointName(HitJoint);
	else
		return 'none';
}

simulated function DrawPawnName(canvas Canvas, float PosX, float PosY)
{

	local float XL, YL, XOffset;

	if (!TraceIdentifyPawn(Canvas))
		return;

	Canvas.Font = Canvas.SmallFont;
	Canvas.Style = 3;

	Canvas.DrawColor.R = 100;
	Canvas.DrawColor.G = 100;
	Canvas.DrawColor.B = 255;

	Canvas.SetPos(4, HalfClipY - 16);
	Canvas.DrawText("Name: "$IdentifyTarget.name);

	Canvas.DrawColor.R = 50;
	Canvas.DrawColor.G = 50;
	Canvas.DrawColor.B = 255;

	Canvas.SetPos(4, HalfClipY);
	Canvas.DrawText("Health: "$IdentifyTarget.Health);

	Canvas.SetPos(4, HalfClipY + 16);
	Canvas.DrawText("State: "$IdentifyTarget.GetStateName());

	Canvas.SetPos(4, HalfClipY + 2*16);
	Canvas.DrawText("Enemy: "$IdentifyTarget.Enemy);

	Canvas.SetPos(4, HalfClipY + 3*16);
	Canvas.DrawText("Trace Joint: "$TraceIdentifyJoint());

	Canvas.SetPos(4, HalfClipY + 4*16);
	Canvas.DrawText("GroundFriction: "$IdentifyTarget.GroundFriction);

	Canvas.Style = 1;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function bool TraceIdentifyActor(canvas Canvas)
{
	local actor Other;
	local vector HitLocation, HitNormal, X, Y, Z, StartTrace, EndTrace, EyeHeight;
	local int HitJoint;

	EyeHeight.z = Pawn(Owner).EyeHeight;
	StartTrace = Owner.Location + EyeHeight;

	EndTrace = StartTrace + vector(Pawn(Owner).ViewRotation) * 2048;

	Other = Trace(HitLocation, HitNormal, HitJoint, EndTrace, StartTrace, true);

	if ( Other != None)
	{
		IdentifyActor = Other;
		IdentifyFadeTime = 0.5;
	}

	if ( IdentifyFadeTime == 0.0 )
		return false;

	if ( (IdentifyActor == None) || (IdentifyActor.bHidden) )
		return false;

	return true;
}

simulated function DrawActorName(canvas Canvas)
{

	if (!TraceIdentifyActor(Canvas))
		return;

	Canvas.Font = Canvas.SmallFont;
	Canvas.Style = 3;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 200;
	Canvas.DrawColor.B = 200;

	Canvas.SetPos(8, 64);
	Canvas.DrawText("Name = "$IdentifyActor.name);

	Canvas.SetPos(8, 64 + 14);
	Canvas.DrawText("State = "$IdentifyActor.GetStateName());

	if ( IdentifyActor.IsA('UndMover') )
	{
		Canvas.SetPos(8, 64 + 2*14);
		Canvas.DrawText("PendingSeq = "$UndMover(IdentifyActor).PendingSeq);

		Canvas.SetPos(8, 64 + 3*14);
		Canvas.DrawText("KeyNum = "$UndMover(IdentifyActor).KeyNum);
	
	} else {
		Canvas.SetPos(8, 64 + 2*14);
		Canvas.DrawText("Opacity = "$IdentifyActor.Opacity);
	}
		
	Canvas.Style = 1;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

}


simulated function DrawIdentifyInfo(canvas Canvas, float PosX, float PosY)
{

	local float XL, YL, XOffset;

	if (!TraceIdentify(Canvas))
		return;

	Canvas.Font = Canvas.SmallFont;//rb Font'WhiteFont';
	Canvas.Style = 3;

	XOffset = 0.0;
	Canvas.StrLen(IdentifyName$": "$IdentifyTarget.PlayerReplicationInfo.PlayerName, XL, YL);
	XOffset = HalfClipX - XL/2;
	Canvas.SetPos(XOffset, Canvas.ClipY - 54);
	
	if(IdentifyTarget.IsA('PlayerPawn'))
		if(PlayerPawn(IdentifyTarget).PlayerReplicationInfo.bFeigningDeath)
			return;

	if(IdentifyTarget.PlayerReplicationInfo.PlayerName != "")
	{
		Canvas.DrawColor.R = 0;
		Canvas.DrawColor.G = 160 * (IdentifyFadeTime / 3.0);
		Canvas.DrawColor.B = 0;

		Canvas.StrLen(IdentifyName$": ", XL, YL);
		XOffset += XL;
		Canvas.DrawText(IdentifyName$": ");
		Canvas.SetPos(XOffset, Canvas.ClipY - 54);

		Canvas.DrawColor.R = 0;
		Canvas.DrawColor.G = 255 * (IdentifyFadeTime / 3.0);
		Canvas.DrawColor.B = 0;

		Canvas.StrLen(IdentifyTarget.PlayerReplicationInfo.PlayerName, XL, YL);
		Canvas.DrawText(IdentifyTarget.PlayerReplicationInfo.PlayerName);
	}

	Canvas.Style = 1;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

}

simulated function DrawPowerWordDebug(canvas Canvas)
{
	local PowerWord pw;
	
	pw = PowerWord(AeonsPlayer(Owner).AttSpell);

	Canvas.Font = Canvas.SmallFont;
	Canvas.Style = 3;

	Canvas.DrawColor.R = 150;
	Canvas.DrawColor.G = 100;
	Canvas.DrawColor.B = 255;

	Canvas.SetPos(4, (Canvas.ClipY * 0.25) - 16);
	Canvas.DrawText("State: "$pw.getStateName());

	Canvas.SetPos(4, (Canvas.ClipY * 0.25));
	Canvas.DrawText("Target 0: "$pw.Targets[0]$" pFX: "$pw.Shafts[0]);

	Canvas.SetPos(4, (Canvas.ClipY * 0.25) + 16);
	Canvas.DrawText("Target 1: "$pw.Targets[1]$" pFX: "$pw.Shafts[1]);

	Canvas.SetPos(4, (Canvas.ClipY * 0.25) + 2*16);
	Canvas.DrawText("Target 2: "$pw.Targets[2]$" pFX: "$pw.Shafts[2]);

	Canvas.SetPos(4, (Canvas.ClipY * 0.25) + 3*16);
	Canvas.DrawText("Target 3: "$pw.Targets[3]$" pFX: "$pw.Shafts[3]);

	Canvas.Style = 1;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}


simulated function DrawMOTD(Canvas Canvas)
{
    local GameReplicationInfo GRI;
	local float XL, YL;

	if(Owner == None) return;

	Canvas.Font = Canvas.MedFont;//Font'WhiteFont';
	Canvas.Style = 3;

	Canvas.DrawColor.R = MOTDFadeOutTime;
	Canvas.DrawColor.G = MOTDFadeOutTime;
	Canvas.DrawColor.B = MOTDFadeOutTime;

	Canvas.bCenter = true;

	foreach AllActors(class'GameReplicationInfo', GRI)
	{
		if (GRI.GameName != "Game")
		{
			Canvas.DrawColor.R = 0;
			Canvas.DrawColor.G = MOTDFadeOutTime / 2;
			Canvas.DrawColor.B = MOTDFadeOutTime;
			Canvas.SetPos(0.0, 32);
			Canvas.StrLen("TEST", XL, YL);
			if (Level.NetMode != NM_Standalone)
				Canvas.DrawText(GRI.ServerName);
			Canvas.DrawColor.R = MOTDFadeOutTime;
			Canvas.DrawColor.G = MOTDFadeOutTime;
			Canvas.DrawColor.B = MOTDFadeOutTime;

			Canvas.SetPos(0.0, 32 + YL);
			Canvas.DrawText("Game Type: "$GRI.GameName, true);
			Canvas.SetPos(0.0, 32 + 2*YL);
			if (Level.Title != "Untitled")
				Canvas.DrawText("Map Title: "$Level.Title, true);
			Canvas.SetPos(0.0, 32 + 3*YL);
			if (Level.Author != "")
				Canvas.DrawText("Author: "$Level.Author, true);
			Canvas.SetPos(0.0, 32 + 4*YL);
			if (Level.IdealPlayerCount != "")
				Canvas.DrawText("Ideal Player Load:"$Level.IdealPlayerCount, true);

			Canvas.DrawColor.R = 0;
			Canvas.DrawColor.G = MOTDFadeOutTime / 2;
			Canvas.DrawColor.B = MOTDFadeOutTime;

			Canvas.SetPos(0, 32 + 6*YL);
			Canvas.DrawText(Level.LevelEnterText, true);

			Canvas.SetPos(0.0, 32 + 8*YL);
			Canvas.DrawText(GRI.MOTDLine1, true);
			Canvas.SetPos(0.0, 32 + 9*YL);
			Canvas.DrawText(GRI.MOTDLine2, true);
			Canvas.SetPos(0.0, 32 + 10*YL);
			Canvas.DrawText(GRI.MOTDLine3, true);
			Canvas.SetPos(0.0, 32 + 11*YL);
			Canvas.DrawText(GRI.MOTDLine4, true);
		}
	}
	Canvas.bCenter = false;

	Canvas.Style = 1;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}


simulated function DrawDigit(canvas Canvas, int iDigit, optional float DigitScale)
{
	if (DigitScale == 0)
		DigitScale = 1.0;

	//Canvas.DrawTileClipped( Texture'HUD_Numbers', DigitInfo.Width[iDigit]*ScaleY, 64*ScaleY, DigitInfo.Offset[iDigit], 0, DigitInfo.Width[iDigit], 64);
	Canvas.DrawTileClipped( Texture'HUD_Numbers_HD', DigitInfo.Width[iDigit]*ScaleY*DigitScale, 64*ScaleY*DigitScale, DigitInfo.Offset[iDigit]*4, 0, DigitInfo.Width[iDigit]*4, 64*4);
}


simulated function AddSplat(byte count, vector HitLocation)
{
	local int i;
	local int found;
	local int iPercent;
	local bool bNeedsBigSplat;

	//fix
	if ( PlayerPawn(Owner).GoreLevel == 0.0 ) 
		return;

	found = 0;
	
	for ( i=0; i<MAXSPLATS; i++)
	{
		if ( Splats[i].Timer == 0 )
		{
			found++;
			
			Splats[i].X = FRand() * (CanvasWidth - 128.0); 
			Splats[i].Y = FRand() * (CanvasHeight - 128.0 - 64.0);  // - 64.0 = sliding room
			
			Splats[i].Timer=(FRand())+1.5;

			Splats[i].StartX = Splats[i].X;
			Splats[i].StartY = Splats[i].Y;
			
			iPercent = FRand()*100;

			if ( iPercent > 75 ) 
			{
				Splats[i].VelY = (FRand()*40)+10;
				Splats[i].Tex = Texture'scrnspry3';
			}
			else if ( iPercent > 38 )
			{
				Splats[i].VelY = 0;
				Splats[i].Tex = Texture'scrnspry1';
			}
			else
			{
				Splats[i].VelY = 0;
				Splats[i].Tex = Texture'scrnspry2';
			}

			if ( found == count ) 
				break;
		}

	}
}

simulated function DrawDebugInfo(canvas Canvas)
{
	local Actor a;
	local PlayerPawn player;
	local vector vecPawnView;
	local float fX;
	local float fY;
	local float RangeToTarget;
	local float DistanceScale;

	local vector X, Y, Z;
	local float width, height;

	player = PlayerPawn(Owner);
	
	if ( player.ViewTarget != none )
	{
		a = player.ViewTarget;
		if ( a.bHidden || !a.bShowDebugInfo )
			return;

		fX = 0.0;
		fY = HalfClipY;

		Canvas.Style = ERenderStyle.STY_Translucent;
		Canvas.Font = Canvas.SmallFont;
		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 0;

		Canvas.StrLen(a.name $ " - " $ a.GetStateName(), width, height);
		Canvas.SetPos(fX, fY);
		Canvas.DrawText(a.name $ " - " $ a.GetStateName(), false);

		Canvas.DrawColor.R = 255;
		Canvas.DrawColor.G = 255;
		Canvas.DrawColor.B = 255;

		Canvas.StrLen(a.GetDebugInfo(), width, height);
		Canvas.SetPos(fX, fY + height + 1);
		Canvas.DrawText(a.GetDebugInfo(), false);

		Canvas.StrLen(a.GetDebugInfo2(), width, height);
		Canvas.SetPos(fX, fY + height * 2 + 2);
		Canvas.DrawText(a.GetDebugInfo2(), false);

		Canvas.StrLen(a.GetDebugInfo3(), width, height);
		Canvas.SetPos(fX, fY + height * 3 + 3);
		Canvas.DrawText(a.GetDebugInfo3(), false);
		return;
	}

	GetAxes(player.ViewRotation, X, Y, Z);

	foreach VisibleActors(class'Actor', a, , player.Location)
	{
		if ( a.bHidden )
			continue;

		if ( a.bShowDebugInfo != true ) 
			continue;
			
		// Get a vector from the player to the pawn
		vecPawnView = a.Location - player.Location - (CollisionHeight/2)*vect(0,0,1);// + (p.EyeHeight*vect(0,0,1));// - (player.EyeHeight * vect(0,0,1));// - 75*vect(0,0,1));
	
		if ( (vecPawnView Dot X) > 0 )
		//if(IsValidTarget(vecPawnView, X, p))  // note that vecPawnView Dot X > 0 ensures that the target is in front of you.
		{
			// range to the pawn
			RangeToTarget = VSize(a.Location - player.Location);
			
			DistanceScale = (640 / RangeToTarget) * 90 / player.FOVAngle;
			
			fX = (HalfClipX) + ((vecPawnView Dot Y)) * ((HalfClipX) / tan(player.FOVAngle * Pi / 360)) / (vecPawnView Dot X);
			fY = (HalfClipY) + (-(vecPawnView Dot Z)) * ((HalfClipX) / tan(player.FOVAngle * Pi / 360)) / (vecPawnView Dot X);

			Canvas.Style = ERenderStyle.STY_Translucent;
			Canvas.Font = Canvas.SmallFont;
			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 0;

			Canvas.StrLen(a.name $ " - " $ a.GetStateName(), width, height);
			Canvas.SetPos(fX - width/2 , fY - height * 3 - 3);
			Canvas.DrawText(a.name $ " - " $ a.GetStateName(), false);

			Canvas.DrawColor.R = 255;
			Canvas.DrawColor.G = 255;
			Canvas.DrawColor.B = 255;

			Canvas.StrLen(a.GetDebugInfo(), width, height);
			Canvas.SetPos(fX - width/2 , fY - height * 2 - 2);
			Canvas.DrawText(a.GetDebugInfo(), false);

			Canvas.StrLen(a.GetDebugInfo2(), width, height);
			Canvas.SetPos(fX - width/2 , fY - height - 1);
			Canvas.DrawText(a.GetDebugInfo2(), false);

			Canvas.StrLen(a.GetDebugInfo3(), width, height);
			Canvas.SetPos(fX - width/2 , fY);
			Canvas.DrawText(a.GetDebugInfo3(), false);
		}
	}
}

simulated function InitSelectMode()
{
	local int i;
	
//	local Actor D;
	
	/*
	for ( i=0; i<ArrayCount(MouseBuffer); i++ )
	{
		MouseBuffer[i].X = 0;
		MouseBuffer[i].Y = 0;
		MouseBuffer[i].Z = 0;
	}
	*/
	
	BufferSlot = 0;
	WheelDelta = vect(0,0,0);
 
	aX = 0;
	aY = 0;

	SelectedSector = -1;
	LastSector = SelectedSector;

/* come back to this later to find out what "truly" happens when Actors are spawned from a simulated function
//	if (Level.NetMode == NM_CLIENT )
//	{	
		D = Spawn(class'BulletHit',,,Owner.Location);

		if ( D != None )
		{
			D.RemoteRole = ROLE_None;
			//D.bNetTemporary = TRUE;
		}
//	}
*/

	//bIsSelecting = true;

}

simulated function FinishSelectMode()
{
	//bIsSelecting = false;
}


simulated function DrawIconsofShame(Canvas Canvas)
{
	local PlayerPawn P;


	if ( HudMode == 0 ) 
		return;

	P = PlayerPawn(Owner);
	
	if ( P != None )
	{
		if ( P.IconsofShame != None )
		{
			P.IconsofShame.DrawIconsofShame(Canvas);
		}
	}

}


simulated function DrawScryeOverlay(Canvas Canvas)
{
	local PlayerPawn P;
	//local float ScryePercent; 

	P = PlayerPawn(Owner);
	
	if  ( P == None ) 
		return;

	if ( P.ViewTarget != none )
		return;
	
	if ( P.ScryeTimer <= 0.0f ) 
		return;
	
	// should we expose ScryeFraction() to script ?	
	/*
	if (( P.ScryeTimer >= P.ScryeRampTime )&&( P.ScryeTimer <= (P.ScryeFullTime - P.ScryeRampTime)))
	{
		ScryePercent = 1.0f;
	}
	else if ( P.ScryeTimer < P.ScryeRampTime )
	{
		ScryePercent = P.ScryeTimer / P.ScryeRampTime;
	}
	else
	{
		ScryePercent = 1.0 - (P.ScryeTimer - (P.ScryeFullTime - P.ScryeRampTime))  / P.ScryeRampTime;
	}
	
	Canvas.Style = ERenderStyle.STY_Modulated;

	
	Canvas.DrawColor.R = 96 - ScryePercent * 96;
	Canvas.DrawColor.G = 96 - ScryePercent * 96;
	Canvas.DrawColor.B = 255 - ScryePercent * 200;
	*/
	Canvas.SetPos(0,0);
	
	Canvas.Style = ERenderStyle.STY_Modulated;
	Canvas.bNoSmooth = FALSE;
	
	/*
	if ( HighDetail ) 
		Canvas.DrawTileClipped( HighDetailOverlay, Canvas.ClipX, Canvas.ClipY, 0, 0, 128, 128);
	else
	*/
	Canvas.DrawTileClipped( ScryeOverlay, Canvas.ClipX, Canvas.ClipY, 0, 0, 64, 64);

	//restor default drawing values
	Canvas.Style = ERenderStyle.STY_Normal;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	
}


simulated function DrawShieldOverlay(Canvas Canvas)
{
	local AeonsPlayer P;
	local float ShieldPercent; 
	local int i;
	local int X, Y;

	P = AeonsPlayer(Owner);
	
	if  ( P == None )
		return;
	
	if (P.ShieldMod == none)
		return;

	if ( !P.ShieldMod.bActive )
		return;

	ShieldPercent = 1.0-(ShieldModifier(P.ShieldMod).overlayStr); // * 0.5;
	
	Canvas.Style = ERenderStyle.STY_Translucent;

	Canvas.DrawColor.R = 100 - ShieldPercent * 100;
	Canvas.DrawColor.G = 100 - ShieldPercent * 100;
	Canvas.DrawColor.B = 150 - ShieldPercent * 150;
	Canvas.SetPos(0,0);
	Canvas.bNoSmooth = FALSE;
	Canvas.DrawTileClipped( ShieldOverlay, Canvas.ClipX, Canvas.ClipY, 0, 0, 64, 64);


	Canvas.Style = ERenderStyle.STY_Translucent;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	
	for (i=0; i<8; i++)
	{
		if ( ShieldModifier(P.ShieldMod).CrackStr[i] > 0 )
		{
			X = Canvas.ClipX * ShieldModifier(P.ShieldMod).CrackLocations[i].x;
			Y = Canvas.ClipY * ShieldModifier(P.ShieldMod).CrackLocations[i].y;
			Canvas.SetPos(X, Y);

			Canvas.DrawColor.R = 100 * (ShieldModifier(P.ShieldMod).CrackStr[i] / ShieldModifier(P.ShieldMod).InitialCrackStr[i]);
			Canvas.DrawColor.G = 100 * (ShieldModifier(P.ShieldMod).CrackStr[i] / ShieldModifier(P.ShieldMod).InitialCrackStr[i]);
			Canvas.DrawColor.B = 128 * (ShieldModifier(P.ShieldMod).CrackStr[i] / ShieldModifier(P.ShieldMod).InitialCrackStr[i]);
			Canvas.DrawTileClipped( ShieldCracks[ShieldModifier(P.ShieldMod).CrackID[i]], 128 * 1.2, 128 * 1.2, 0, 0, 128, 128);
		}
	}

	//restor default drawing values
	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

}

simulated function DrawSepiaOverlay( Canvas Canvas )
{
	local AeonsPlayer P;

	P = AeonsPlayer(Owner);

	if  ( P == none )
		return;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.DrawColor.A = 255;

	Canvas.Style = ERenderStyle.STY_Modulated;
	Canvas.SetPos(0,0);
	Canvas.bNoSmooth = false;
	Canvas.DrawTileClipped( SepiaOverlay, Canvas.ClipX, Canvas.ClipY, 0, 0, 64, 64);

	Canvas.Style = ERenderStyle.STY_Normal;

}

simulated function DrawSlimeOverlay( Canvas Canvas, float Intensity )
{
	local AeonsPlayer P;

	P = AeonsPlayer(Owner);

	if  ( ( P == none ) || ( P.SlimeMod == none ) || !P.SlimeMod.bActive )
		return;

	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
	Canvas.DrawColor.A = Intensity * 255;

	Canvas.Style = ERenderStyle.STY_AlphaBlend;
	Canvas.SetPos(0,0);
	Canvas.bNoSmooth = false;
	Canvas.DrawTileClipped( SlimeOverlay, Canvas.ClipX, Canvas.ClipY, 0, 0, 64, 64);

	//restor default drawing values
	Canvas.Style = ERenderStyle.STY_Normal;
	//Canvas.DrawColor.R = 255;
	//Canvas.DrawColor.G = 255;
	//Canvas.DrawColor.B = 255;

}

simulated function DrawWizardEyeOverlay(Canvas Canvas)
{
	local AeonsPlayer P;
	local float ShieldPercent; 
	local int i;
	local int X, Y;

	P = AeonsPlayer(Owner);
	
	if  ( P == None )
		return;
	
	if (!P.bWizardEye)
		return;

	Canvas.Style = ERenderStyle.STY_Translucent;

	Canvas.DrawColor.R = 100 - ShieldPercent * 100;
	Canvas.DrawColor.G = 100 - ShieldPercent * 100;
	Canvas.DrawColor.B = 150 - ShieldPercent * 150;
	Canvas.SetPos(0,0);
	Canvas.bNoSmooth = FALSE;
	Canvas.DrawTileClipped( WizardEyeOverlay, Canvas.ClipX, Canvas.ClipY, 0, 0, 64, 64);

	//restor default drawing values
	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function DrawPhoenixOverlay(Canvas Canvas)
{
	local AeonsPlayer P;
	local float ShieldPercent; 
	local int i;
	local int X, Y;

	P = AeonsPlayer(Owner);
	
	if  ( P == None )
		return;
	
	if (!P.bPhoenix)
		return;

	Canvas.Style = ERenderStyle.STY_Translucent;

	Canvas.DrawColor.R = 100 - ShieldPercent * 100;
	Canvas.DrawColor.G = 100 - ShieldPercent * 100;
	Canvas.DrawColor.B = 150 - ShieldPercent * 150;
	Canvas.SetPos(0,0);
	Canvas.bNoSmooth = FALSE;
	Canvas.DrawTileClipped( PhoenixOverlay, Canvas.ClipX, Canvas.ClipY, 0, 0, 64, 64);

	//restor default drawing values
	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;
}

simulated function DrawShalasOverlay(Canvas Canvas)
{
	local AeonsPlayer P;
	local int i;
	local int X, Y;

	P = AeonsPlayer(Owner);
	
	if  ( P == None )
		return;

	if (ShalasOverlay == none)
		return;

	Canvas.Style = ERenderStyle.STY_Translucent;

	Canvas.DrawColor.R = 100;
	Canvas.DrawColor.G = 150;
	Canvas.DrawColor.B = 150;
	Canvas.SetPos(0,0);
	Canvas.bNoSmooth = FALSE;
	Canvas.DrawTileClipped( ShalasOverlay, Canvas.ClipX, Canvas.ClipY, 0, 0, 64, 64);

	//restore default drawing values
	Canvas.Style = ERenderStyle.STY_Normal;
	Canvas.DrawColor.R = 255;
	Canvas.DrawColor.G = 255;
	Canvas.DrawColor.B = 255;

}

simulated function WheelMouseInput(float DeltaTime)
{
	local float ExtendedRadius;
	local float Delta;

	if (aX != 0)
		WheelDelta.X += aX * WheelCursorSensitivity * DeltaTime;
	if (aY != 0)
		WheelDelta.Y += aY * WheelCursorSensitivity * DeltaTime;

	if (aX != 0 || aY != 0)
	{
		Delta = VSize(WheelDelta) * ClampedHudScale;
		ExtendedRadius = RadiusThreshold + ExtendRadiusThresholdAmount;

		if (Delta > ExtendedRadius)
			WheelDelta.X = WheelDelta.X / Delta * ExtendedRadius;
		
		if (Delta > ExtendedRadius)
			WheelDelta.Y = WheelDelta.Y / Delta * ExtendedRadius;
	}
}

simulated function int GetSectionFromPos(vector CursorPos)
{
	local float Theta;

	if ( Abs(CursorPos.X) < 0.01 ) 
		CursorPos.X = 0.01;
		
	if ( CursorPos.X < 0 ) 
	{
		Theta = 270 - ATan( CursorPos.Y/CursorPos.X )*57.3;
	}
	else
	{
		Theta = 90 - ATan( CursorPos.Y/CursorPos.X )*57.3;
	}

	if ( Theta > 337 )
		return 0;
	else
		return ((Theta + 23) / 45);
}

simulated function DrawSelectHUD(Canvas Canvas)
{
    local AeonsPlayer PPawn;
    local float Delta;

	PPawn = AeonsPlayer(Owner);

    if (PPawn == None)
        return;

	if ( !PPawn.bSelectObject )
		return;

	// If on PSX2, must handle things a little differently
	if (GetPlatform() == PLATFORM_PSX2)
	{
		Delta = Sqrt(aX * aX + aY * aY);
		if ( Delta > RadiusThresholdPSX2 * PPawn.MouseSensitivity )
		{
			SelectedSector = GetSectionFromPos(vect(1,0,0)*aX + vect(0,1,0)*aY);

			if ( SelectedSector != LastSector ) 
			{
				LastSector = SelectedSector;
				WheelTextTimer = 1.5;
				PlayerPawn(Owner).PlaySound( sound'Aeons.HUD_Mvmt01',SLOT_Misc,0.25 );
			}
		}
	}
	else
	{
		Delta = VSize(WheelDelta) * ClampedHudScale;

		if ( Delta >= RadiusThreshold )
		{
			SelectedSector = GetSectionFromPos(WheelDelta);

			if ( SelectedSector != LastSector ) 
			{
				LastSector = SelectedSector;
				WheelTextTimer = 1.5;
				PlayerPawn(Owner).PlaySound( sound'Aeons.HUD_Mvmt01',SLOT_Misc,0.25 );
			}
		}
		else if (SelectedSector != -1 && (Delta < RadiusThreshold / 2 || GetSectionFromPos(WheelDelta) != SelectedSector))
		{
			SelectedSector = -1;
			LastSector = SelectedSector;
		}
		
		Canvas.SetPos( HalfClipX - 64*Scale/2.0 + WheelDelta.X*Scale, HalfClipY - 64*Scale/2.0 - WheelDelta.Y*Scale );
	
		Canvas.bNoSmooth = false;

		Canvas.DrawColor.r = 0;
		Canvas.DrawColor.g = 255;
		Canvas.DrawColor.b = 255;
		Canvas.Style = 3;

		Canvas.DrawTileClipped(FireTexture'FX.Swirl', 64*Scale, 64*Scale, 0, 0, 64, 64);
	}

	if ( PPawn.SelectMode == SM_Weapon )
		DrawWheel(Canvas, Con_InvGroup);
    else if ( PPawn.SelectMode == SM_AttSpell )
		DrawWheel(Canvas, Off_InvGroup);
    else if ( PPawn.SelectMode == SM_DefSpell )
		DrawWheel(Canvas, Def_InvGroup);
	else if ( PPawn.SelectMode == SM_Item )
	{
		DrawAllItems(Canvas);
		DrawWheel(Canvas, Item_InvGroup);
	}
	Canvas.Style = ERenderStyle.STY_Normal;

}

function DrawAllItems(Canvas Canvas)
{
	local Inventory Inv;
	local string InvName;
	local int InvCount;
	local int i, j;
	local bool bQuickSelectItem;
	local float TextWidth, TextHeight, TextLeftMargin;
	local int Spacing;
	local float IconSize;
	local float XOffset, YOffset, CurrentY;

	XOffset = 4;
	YOffset = 25;

	Canvas.Font = Canvas.SmallFont;
	Canvas.TextSize( "TEST", TextWidth, TextHeight );
	Spacing = TextHeight + 8;
	IconSize = TextHeight + 2;
	TextLeftMargin = 5 * ScaleY;

	// draw shadow behind items
	if (LastDrawnItemsCount > 0)
	{
		Canvas.Style = 4;
		Canvas.DrawColor = Canvas.Default.DrawColor;
		Canvas.SetPos(0, YOffset*ScaleY + Spacing / 2.0);
		Canvas.DrawTileClipped( texture'HUD_Inv_Shad_Test', 178*Scale, (LastDrawnItemsCount + 1) * Spacing, 0, 0, 60, 64);
	}

	for ( Inv=Owner.Inventory; Inv!=None; Inv=Inv.Inventory )
	{
		if (Inv.ItemType != ITEM_Inventory || !Inv.bDisplayableInv)
			continue;

		// don't show items from items wheel
		bQuickSelectItem = false;
		for (j = 0; j < ArrayCount(Item_InvGroup); j++)
		{
			if (Item_InvGroup[j] == Inv.InventoryGroup)
			{
				bQuickSelectItem = true;
				break;
			}
		}

		if (bQuickSelectItem)
			continue;
		
		i++;
		
		CurrentY = YOffset*ScaleY + (i * Spacing) + Spacing / 2.0; // centered spacing
		Canvas.Style = ERenderStyle.STY_AlphaBlend;
		Canvas.DrawColor = WhiteColor;
		Canvas.DrawColor.a = 255;
		Canvas.bNoSmooth = false;
		Canvas.SetPos( XOffset*ScaleX, CurrentY - IconSize / 2.0 );
		Canvas.DrawIcon(Inv.Icon, IconSize / 64.0);
		
		// draw text
		Canvas.SetPos( XOffset*ScaleX + IconSize + TextLeftMargin, CurrentY - TextHeight / 2.0 );
		
		if ( Inv == none )
		{
			InvName = "";
		}
		else
		{
			if (Inv.IsA('Ammo'))
				InvCount = Ammo(Inv).AmmoAmount;
			else if (Pickup(Inv).numCopies > 0)
				InvCount = Pickup(Inv).numCopies + 1;
			else
				InvCount = 0;

			InvName = ""$Inv.ItemName;
			if (InvCount > 0)
			{
				InvName = InvName$": ";
				InvName = InvName$InvCount;
			}
		}
		
		Canvas.DrawText( (""$InvName), false);
	}
	LastDrawnItemsCount = i;
}

function DrawWheelIcon( Canvas Canvas, int InventoryGroup, int Slot, int X, int Y, int W, int H )
{
	local int u, v, ul, vl;
	local texture sprite;
	local int iState;
	local int TextureRow;
	local texture BackLayer;
	local Inventory WheelSelection;
	local float TextWidth, TextHeight;
	local string InvName;
	local int InvCount;
	
	iState = 0;

	if ( Slot == SelectedSector ) 
	{
		iState = 1;
	}
	else
	{
		if ( InventoryGroup < 10 ) 
		{
			if ((AeonsPlayer(Owner).FavWeapon1 == InventoryGroup ) || (AeonsPlayer(Owner).FavWeapon2 == InventoryGroup))
			{
				iState = 2;
			}
		}
		else if ( InventoryGroup < 20 ) 
		{
			if ((AeonsPlayer(Owner).FavAttSpell1 == InventoryGroup ) || (AeonsPlayer(Owner).FavAttSpell2 == InventoryGroup))
			{
				iState = 2;
			}
		}
		else if ( InventoryGroup >= 100 ) 
		{
			if ((AeonsPlayer(Owner).FavItem1 == InventoryGroup ) || (AeonsPlayer(Owner).FavItem2 == InventoryGroup))
			{
				iState = 2;
			}
		}
		else
		{
			if ((AeonsPlayer(Owner).FavDefSpell1 == InventoryGroup ) || (AeonsPlayer(Owner).FavDefSpell2 == InventoryGroup))
			{
				iState = 2;
			}
		}
	
	}

	if (InventoryGroup>0)
	{
		WheelSelection = Owner.Inventory.FindItemInGroup(InventoryGroup);

		// don't accept the molotov who hasn't had any ammo as valid
		if (Weapon(WheelSelection) != None && Weapon(WheelSelection).bSpecialIcon) 
			WheelSelection = None;
	}

	if (( iState == 1 )&&(HUDMode == 1))
	{
		Canvas.SetPos( X - 128*Scale/2.0, Y - 128*Scale/2.0 );
		
		Canvas.bNoSmooth = false;

		Canvas.DrawColor.r = 255;
		Canvas.DrawColor.g = 255;
		Canvas.DrawColor.b = 255;
		Canvas.Style = 3;

			
		//		BackLayer = texture( DynamicLoadObject("FX.Swirl", class'FireTexture'));		
		BackLayer = FireTexture'FX.Swirl';		
		Canvas.DrawTileClipped(BackLayer, 128*Scale, 128*Scale, 0, 0, 64, 64);

		//BackLayer = texture( DynamicLoadObject("FX.MyTex5", class'FireTexture'));
		//Canvas.DrawIcon( texture'Aeons.Particles.Soft_pfx', 2*Scale);
		//Canvas.DrawIcon( texture'Glow', 1.5*Scale);
		//Canvas.DrawTileClipped(texture'Aeons.Particles.Soft_pfx', 128*Scale, 128*Scale, 0, 0, 64, 64);
		//Canvas.DrawTileClipped(BackLayer, 128*Scale, 128*Scale, 0, 0, 64, 64);
		
		if (InventoryGroup>0)
		{
			// WheelSelection = Owner.Inventory.FindItemInGroup(InventoryGroup);
			if ( WheelSelection != None )
			{
				if ( SelectedName != WheelSelection.ItemName )
					SelectedName = WheelSelection.ItemName;
				}
			else
			{
				if ( SelectedName != NoWheelSelectionText )
					SelectedName = NoWheelSelectionText;
			}
				if ( WheelTextTimer > 0.0 ) 
				{
					Canvas.Font = Canvas.MedFont;
					Canvas.Style = ERenderStyle.STY_Normal;

					Canvas.TextSize( SelectedName, TextWidth, TextHeight );

					// fade out last 0.5 seconds
					if ( WheelTextTimer >= 0.5 ) 
						Canvas.DrawColor = WhiteColor;
					else
					{
						Canvas.DrawColor.r = 511.0 * WheelTextTimer;
						Canvas.DrawColor.g = 511.0 * WheelTextTimer;
						Canvas.DrawColor.b = 511.0 * WheelTextTimer;
				}

					Canvas.SetPos( HalfClipX - TextWidth/2, HalfClipY - TextHeight/2 );

					Canvas.DrawText( SelectedName );
				}
		}
	}
	else if (( iState == 2 ) &&(HUDMode == 1)&&(InventoryGroup>0))
	{		
		Canvas.SetPos( X - 128*Scale/2.0, Y - 128*Scale/2.0 );

		Canvas.DrawColor.r = 0;
		Canvas.DrawColor.g = 0;
		Canvas.DrawColor.b = 255;
		Canvas.Style = 3;
		Canvas.bNoSmooth = false;

		BackLayer = FireTexture'FX.Swirl';		
		Canvas.DrawTileClipped(BackLayer, 128*Scale, 128*Scale, 0, 0, 64, 64);
		//Canvas.DrawTileClipped(texture'Aeons.Particles.Soft_pfx', 128*Scale, 128*Scale, 0, 0, 64, 64);
		//Canvas.DrawIcon( texture'Aeons.Particles.Soft_pfx', 2*Scale);
		//Canvas.DrawIcon( texture'Glow', 2*Scale);
	
		Canvas.DrawColor.r = 255;
		Canvas.DrawColor.g = 255;
		Canvas.DrawColor.b = 255;

		Canvas.Style = 1;
	}

	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;
	Canvas.DrawColor.a = 255;


/*	Shadows
	Canvas.Style = 4;
	Canvas.bNoSmooth = false;
	Canvas.SetPos( X-(64+8)*Scale/2.0, Y-(64+8)*Scale/2.0 );
	Canvas.DrawIcon( Shadows[InventoryGroup], 1.25*Scale);
*/

	if ( InventoryGroup > 0 )
	{
		Canvas.Style = 5;
	}
	else
	{
		Canvas.DrawColor.r = 128;
		Canvas.DrawColor.g = 128;
		Canvas.DrawColor.b = 128;
		Canvas.DrawColor.a = 128;

		canvas.Style = 3;
	}
	Canvas.bNoSmooth = false;
	Canvas.SetPos( X-64*Scale/2.0, Y-64*Scale/2.0 );
	if (WheelSelection != none) //&&(!Weapon(WheelSelection).bSpecialIcon))
	{
		if ( InventoryGroup < 10 && !WheelSelection.bHaveTokens )
			Canvas.DrawColor.a = 64;

		if (InventoryGroup >= 100)
		{
			if (WheelSelection.bActiveToggle && !WheelSelection.bActive)
			{
				Canvas.DrawColor.r = 128;
				Canvas.DrawColor.g = 128;
				Canvas.DrawColor.b = 128;
			}
			Canvas.DrawIcon(WheelSelection.Icon, Scale);
		}
		else
		{
			Canvas.DrawIconTrimmed(Icons[InventoryGroup], Scale);
		}
	}
	else 
	{
		Canvas.DrawColor.a = 64;
		Canvas.DrawIcon(Icons[0], Scale);
	}

	if (WheelSelection != none && InventoryGroup >= 100)
	{
		if (WheelSelection.IsA('Ammo'))
			InvCount = Ammo(WheelSelection).AmmoAmount;
		else if (Pickup(WheelSelection).numCopies >= 0)
			InvCount = Pickup(WheelSelection).numCopies + 1;
		
		//InvName = ""$WheelSelection.ItemName;
		if (InvCount > 1)
		{
			//InvName = InvName$": ";
			InvName = InvName$InvCount;
		}

		Canvas.Font = Canvas.MedFont;
		Canvas.DrawColor = WhiteColor;
		Canvas.TextSize( InvName, TextWidth, TextHeight );
		Canvas.SetPos( X - TextWidth/2, Y - TextHeight/2 + 38 * Scale);
		Canvas.DrawText( InvName );
	}
	
	Canvas.bNoSmooth = true;
	Canvas.Style = 1;
	Canvas.DrawColor.r = 255;
	Canvas.DrawColor.g = 255;
	Canvas.DrawColor.b = 255;
	Canvas.DrawColor.a = 255;
}

static final function string LTrim(coerce string S)
{
	while (Left(S, 1) == " ")
		S = Right(S, Len(S) - 1);
	return S;
}

static final function string RTrim(coerce string S)
{
	while (Right(S, 1) == " ")
		S = Left(S, Len(S) - 1);
	return S;
}

static final function string Trim(coerce string S)
{
	return LTrim(RTrim(S));
}

//////////////////////////////////////////////////////////////////////////////
//	Default Properties
//////////////////////////////////////////////////////////////////////////////

defaultproperties
{
     RadiusThreshold=164
     RadiusThresholdPSX2=500
     Con_X(1)=133
     Con_X(2)=188
     Con_X(3)=133
     Con_X(5)=-133
     Con_X(6)=-188
     Con_X(7)=-133
     Con_Y(0)=-188
     Con_Y(1)=-133
     Con_Y(3)=133
     Con_Y(4)=188
     Con_Y(5)=133
     Con_Y(7)=-133
     Con_InvGroup(0)=1
     Con_InvGroup(1)=2
     Con_InvGroup(2)=3
     Con_InvGroup(3)=4
     Con_InvGroup(4)=5
     Con_InvGroup(5)=6
     Con_InvGroup(6)=7
     Con_InvGroup(7)=8
     Def_X(1)=133
     Def_X(2)=188
     Def_X(3)=133
     Def_X(5)=-133
     Def_X(6)=-188
     Def_X(7)=-133
     Def_Y(0)=-188
     Def_Y(1)=-133
     Def_Y(3)=133
     Def_Y(4)=188
     Def_Y(5)=133
     Def_Y(7)=-133
     Def_InvGroup(0)=26
     Def_InvGroup(1)=22
     Def_InvGroup(2)=24
     Def_InvGroup(3)=23
     Def_InvGroup(4)=25
     Def_InvGroup(5)=27
     Def_InvGroup(6)=21
     Def_InvGroup(7)=20
     Off_X(1)=133
     Off_X(2)=188
     Off_X(3)=133
     Off_X(5)=-133
     Off_X(6)=-188
     Off_X(7)=-133
     Off_Y(0)=-188
     Off_Y(1)=-133
     Off_Y(3)=133
     Off_Y(4)=188
     Off_Y(5)=133
     Off_Y(7)=-133
     Off_InvGroup(0)=11
     Off_InvGroup(1)=13
     Off_InvGroup(2)=14
     Off_InvGroup(3)=15
     Off_InvGroup(4)=12
     Off_InvGroup(5)=16
     Off_InvGroup(6)=17
     Off_InvGroup(7)=18
	 Item_InvGroup(0)=110//ammo
     Item_InvGroup(1)=111//silver
     Item_InvGroup(2)=101//health
     Item_InvGroup(3)=109//ether
     Item_InvGroup(4)=112//shells
     Item_InvGroup(5)=113//phosphorus
     Item_InvGroup(6)=116//dynamite
     Item_InvGroup(7)=103//amplifier
     bShowCrosshairEnemyColor=True
     MAX_CROSSHAIRS=24
     CrossHairs(0)=Texture'Aeons.Icons.CrossHair0'
     CrossHairs(1)=Texture'Aeons.Icons.CrossHair1'
     CrossHairs(2)=Texture'Aeons.Icons.CrossHair2'
     CrossHairs(3)=Texture'Aeons.Icons.CrossHair3'
     CrossHairs(4)=Texture'Aeons.Icons.CrossHair4'
     CrossHairs(5)=Texture'Aeons.Icons.CrossHair5'
     CrossHairs(6)=Texture'Aeons.Icons.CrossHair6'
     CrossHairs(7)=Texture'Aeons.Icons.CrossHair7'
     CrossHairs(8)=Texture'Aeons.Icons.CrossHair8'
     CrossHairs(9)=Texture'Aeons.Icons.CrossHair9'
     CrossHairs(10)=Texture'Aeons.Icons.CrossHair10'
     CrossHairs(11)=Texture'Aeons.Icons.CrossHair11'
     CrossHairs(12)=Texture'Aeons.Icons.CrossHair12'
     CrossHairs(13)=Texture'Aeons.Icons.CrossHair13'
     CrossHairs(14)=Texture'Aeons.Icons.CrossHair14'
     CrossHairs(15)=Texture'Aeons.Icons.CrossHair15'
     CrossHairs(16)=Texture'Aeons.Icons.CrossHair16'
     CrossHairs(17)=Texture'Aeons.Icons.CrossHair17'
     CrossHairs(18)=Texture'Aeons.Icons.CrossHair18'
     CrossHairs(19)=Texture'Aeons.Icons.CrossHair19'
     CrossHairs(20)=Texture'Aeons.Icons.CrossHair20'
     CrossHairs(21)=Texture'Aeons.Icons.CrossHair21'
     CrossHairs(22)=Texture'Aeons.Icons.CrossHair22'
     CrossHairs(23)=Texture'Aeons.Icons.CrossHair23'
     Icons(0)=Texture'Aeons.Icons.null_Icon'
     Icons(1)=Texture'Aeons.Icons.Revolver_Icon'
     Icons(2)=Texture'Aeons.Icons.Ghelz_Icon'
     Icons(3)=Texture'Aeons.Icons.Scythe_Icon'
     Icons(4)=Texture'Aeons.Icons.Cannon_Icon'
     Icons(5)=Texture'Aeons.Icons.Shotgun_Icon'
     Icons(6)=Texture'Aeons.Icons.Speargun_Icon'
     Icons(7)=Texture'Aeons.Icons.Phoenix_Icon'
     Icons(8)=Texture'Aeons.Icons.Molotov_Icon'
     Icons(11)=Texture'Aeons.Icons.Ectoplasm_Icon'
     Icons(12)=Texture'Aeons.Icons.SkullStorm_Icon'
     Icons(13)=Texture'Aeons.Icons.Dispel_Icon'
     Icons(14)=Texture'Aeons.Icons.Lightning_Icon'
     Icons(15)=Texture'Aeons.Icons.Haste_Icon'
     Icons(16)=Texture'Aeons.Icons.Scrye_Icon'
     Icons(17)=Texture'Aeons.Icons.Shield_Icon'
     Icons(18)=Texture'Aeons.Icons.Invoke_Icon'
     Icons(20)=Texture'Aeons.Icons.PowerWord_Icon'
     Icons(21)=Texture'Aeons.Icons.PowerWord_Icon'
     Icons(22)=Texture'Aeons.Icons.Phase_Icon'
     Icons(23)=Texture'Aeons.Icons.Silence_Icon'
     Icons(24)=Texture'Aeons.Icons.Ward_Icon'
     Icons(25)=Texture'Aeons.Icons.Mindshatter_Icon'
     Icons(26)=Texture'Aeons.Icons.Shalas_Icon'
     Icons(27)=Texture'Aeons.Icons.FireFly_Icon'
     Icons(28)=Texture'Aeons.Icons.Dynamite_Icon'
     Icons(29)=Texture'Aeons.Icons.DoubleShotgun_Icon'
     magicFrameRate=20
     IdentifyName="Name"
     IdentifyHealth="Health"
     VersionMessage="Build 06/29/2023"
     RedColor=(R=255,G=64,B=64)
     GreenColor=(R=64,G=255,B=64)
     WhiteColor=(R=255,G=255,B=255)
     SlimeOverlay=WetTexture'fxB.HUD.ScarrowSlime'
     WizardEyeOverlay=WetTexture'fxB.DSpells.MyTex4'
     PhoenixOverlay=WetTexture'fxB2.Phoenix_Overlay'
     ScryeOverlay=WetTexture'fxB.Spells.ScryeWet'
     ShieldOverlay=WetTexture'fxB.Spells.ShieldWet'
     ShalasOverlay=WetTexture'fxB.DSpells.MyTex4'
     ShieldCracks(0)=Texture'Aeons.HUD.ShieldCrack0'
     ShieldCracks(1)=Texture'Aeons.HUD.ShieldCrack1'
     ShieldCracks(2)=Texture'Aeons.HUD.ShieldCrack2'
     SepiaOverlay=Texture'Aeons.HUD.SepiaTone'
     DotTexture=Texture'Aeons.HUD.Dot'
     bDrawLevelInfo=True
     bDrawBuildInfo=True
	 NoWheelSelectionText=""
}
