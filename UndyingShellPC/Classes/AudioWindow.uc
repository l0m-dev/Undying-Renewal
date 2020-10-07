//=============================================================================
// AudioWindow.
//=============================================================================
class AudioWindow expands ShellWindow;

//#exec OBJ LOAD FILE=\aeons\sounds\Shell_HUD.uax PACKAGE=Shell_HUD

//#exec Texture Import File=Audio_0.bmp Mips=Off
//#exec Texture Import File=Audio_1.bmp Mips=Off
//#exec Texture Import File=Audio_2.bmp Mips=Off
//#exec Texture Import File=Audio_3.bmp Mips=Off
//#exec Texture Import File=Audio_4.bmp Mips=Off
//#exec Texture Import File=Audio_5.bmp Mips=Off


//#exec Texture Import File=audio_amb_uparr_up.bmp	Mips=Off 
//#exec Texture Import File=audio_amb_uparr_ov.bmp	Mips=Off 
//#exec Texture Import File=audio_amb_uparr_dn.bmp 	Mips=Off 

//#exec Texture Import File=audio_voi_dnarr_up.bmp	Mips=Off 
//#exec Texture Import File=audio_voi_dnarr_ov.bmp	Mips=Off 
//#exec Texture Import File=audio_voi_dnarr_dn.bmp 	Mips=Off 

//#exec Texture Import File=audio_voi_uparr_up.bmp	Mips=Off 
//#exec Texture Import File=audio_voi_uparr_ov.bmp	Mips=Off 
//#exec Texture Import File=audio_voi_uparr_dn.bmp 	Mips=Off 

//#exec Texture Import File=audio_sfx_uparr_up.bmp	Mips=Off 
//#exec Texture Import File=audio_sfx_uparr_ov.bmp	Mips=Off 
//#exec Texture Import File=audio_sfx_uparr_dn.bmp 	Mips=Off 



/*
//#exec Texture Import File=audio_Voice_inc_up.BMP	Mips=Off Flags=2
//#exec Texture Import File=audio_Voice_inc_dn.BMP	Mips=Off Flags=2
//#exec Texture Import File=audio_Voice_dec_up.BMP	Mips=Off Flags=2
//#exec Texture Import File=audio_Voice_dec_dn.BMP	Mips=Off Flags=2

//#exec Texture Import File=audio_sfx_inc_up.BMP		Mips=Off Flags=2
//#exec Texture Import File=audio_sfx_inc_dn.BMP		Mips=Off Flags=2
//#exec Texture Import File=audio_sfx_dec_up.BMP		Mips=Off Flags=2
//#exec Texture Import File=audio_sfx_dec_dn.BMP		Mips=Off Flags=2

//#exec Texture Import File=audio_music_inc_up.BMP	Mips=Off Flags=2
//#exec Texture Import File=audio_music_inc_dn.BMP	Mips=Off Flags=2
//#exec Texture Import File=audio_music_dec_up.BMP	Mips=Off Flags=2
//#exec Texture Import File=audio_music_dec_dn.BMP	Mips=Off Flags=2
*/

//#exec Texture Import File=audio_ok_ov.BMP			Mips=Off Flags=2
//#exec Texture Import File=audio_ok_up.BMP			Mips=Off Flags=2
//#exec Texture Import File=audio_ok_dn.BMP			Mips=Off Flags=2

//#exec Texture Import File=Audio_slider_up.BMP		Mips=Off Flags=2

//#exec Texture Import File=Audio_slidr_up.BMP		Mips=Off
//#exec Texture Import File=Audio_slidr_ov.BMP		Mips=Off

//#exec Texture Import File=audio_X.BMP				Mips=Off Flags=2

//----------------------------------------------------------------------------

var int SoundVolume, OrigSoundVolume;
var int BackgroundVolume, OrigBackgroundVolume;
var int VoiceVolume, OrigVoiceVolume;

var bool bUse3DHardware, OrigbUse3DHardware;
var bool bHighSoundQuality, OrigbHighSoundQuality;

var vector SoundSliderSlots[10];
//var vector VoiceSliderSlots[10];
//var vector MusicSliderSlots[10];

var(Center)		vector	SoundCenter, BackgroundCenter, VoiceCenter;
var(ThetaStart) float	SoundThetaStart, VoiceThetaStart, BackgroundThetaStart;
var(ThetaEnd)	float	SoundThetaEnd, VoiceThetaEnd, BackgroundThetaEnd;
var(Radii)		float	SoundRadius, VoiceRadius, BackgroundRadius;

var ShellButton SoundVolumeUp, SoundVolumeDown;
var ShellButton BackgroundVolumeUp, BackgroundVolumeDown;
var ShellButton VoiceVolumeUp, VoiceVolumeDown;

var ShellCheckbox HighQuality, Use3D;//A3D, EAX;

var ShellButton OK;
var ShellButton Cancel;

var bool bSaveChanges;

var ShellBitmap SoundVolumeSlider;
var ShellBitmap BackgroundVolumeSlider;
var ShellBitmap VoiceVolumeSlider;

var actor SoundEmitter;

var sound ChangeSound;
var sound CheckboxSound;

var() float Theta;
var() float ThetaRate;
var() float Radius;

var bool bInitialized;

var int		SmokingWindows[2];
var float	SmokingTimers[2];

//----------------------------------------------------------------------------

function Created()
{

	local int i;
	local color TextColor;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;
	local vector Delta;
	local float ThetaStart, ThetaEnd, ThetaStep;

	Super.Created();
	
	AeonsRoot = AeonsRootWindow(Root);

	if ( AeonsRoot == None ) 
	{
		Log("AeonsRoot is Null!");
		return;
	}

	RootScaleX = AeonsRoot.ScaleX;
	RootScaleY = AeonsRoot.ScaleY;

	SmokingWindows[0] = -1;
	SmokingWindows[1] = -1;

// OK Button
	OK = ShellButton(CreateWindow(class'ShellButton', 30*RootScaleX, 408*RootScaleY, 139*RootScaleX, 46*RootScaleY));

	OK.TexCoords.X = 0;
	OK.TexCoords.Y = 0;
	OK.TexCoords.W = 139;
	OK.TexCoords.H = 60;

	// position and size in designed resolution of 800x600
	OK.Template = NewRegion(30,408,139,60);

	OK.Manager = Self;
	OK.Style = 5;

	OK.bBurnable = true;
	OK.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	OK.UpTexture =   texture'UndyingShellPC.Video_ok_up';
	OK.DownTexture = texture'UndyingShellPC.Video_ok_dn';
	OK.OverTexture = texture'UndyingShellPC.Video_ok_ov';
	OK.DisabledTexture = None;

// Cancel Button
	Cancel = ShellButton(CreateWindow(class'ShellButton', 30*RootScaleX, 500*RootScaleY, 138*RootScaleX, 60*RootScaleY));

	Cancel.TexCoords.X = 0;
	Cancel.TexCoords.Y = 0;
	Cancel.TexCoords.W = 138;
	Cancel.TexCoords.H = 60;

	// position and size in designed resolution of 800x600
	Cancel.Template = NewRegion(30,500,138,60);

	Cancel.Manager = Self;
	Cancel.Style = 5;

	Cancel.bBurnable = true;
	Cancel.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Cancel.UpTexture =   texture'UndyingShellPC.Video_cancel_up';
	Cancel.DownTexture = texture'UndyingShellPC.Video_cancel_dn';
	Cancel.OverTexture = texture'UndyingShellPC.Video_cancel_ov';
	Cancel.DisabledTexture = None;

// HighQuality
	HighQuality = ShellCheckbox(CreateWindow(class'ShellCheckBox', 325*RootScaleX, 429*RootScaleY, 39*RootScaleX, 37*RootScaleY));

	HighQuality.TexCoords.X = 0;
	HighQuality.TexCoords.Y = 0;
	HighQuality.TexCoords.W = 39;
	HighQuality.TexCoords.H = 37;

	// position and size in designed resolution of 800x600
	HighQuality.Template = NewRegion(325,429,39,37);

	HighQuality.Manager = Self;

	HighQuality.UpTexture =   None;
	HighQuality.DownTexture = texture'audio_x';
	HighQuality.OverTexture = None;
	HighQuality.DisabledTexture = None;

// Use3D
	Use3D = ShellCheckbox(CreateWindow(class'ShellCheckBox', 325*RootScaleX, 485*RootScaleY, 39*RootScaleX, 37*RootScaleY));

	Use3D.TexCoords.X = 0;
	Use3D.TexCoords.Y = 0;
	Use3D.TexCoords.W = 39;
	Use3D.TexCoords.H = 37;

	// position and size in designed resolution of 800x600
	Use3D.Template = NewRegion(325,485,39,37);

	Use3D.Manager = Self;

	Use3D.UpTexture =   None;
	Use3D.DownTexture = texture'audio_x';
	Use3D.OverTexture = None;
	Use3D.DisabledTexture = None;

// Sound Volume Slider
	SoundVolumeSlider = ShellBitmap(CreateWindow(class'ShellBitmap', 164*RootScaleX,224*RootScaleY,32*RootScaleX,32*RootScaleY));
	SoundVolumeSlider.T = texture'Audio_slidr_up';
	SoundVolumeSlider.R = NewRegion(0,0,32,32);
	SoundVolumeSlider.Template = NewRegion(0,0,32,32);
	SoundVolumeSlider.bStretch = true;
	SoundVolumeSlider.Style = 5;
	SoundVolumeSlider.Manager = Self;


// Voice Volume Slider
	VoiceVolumeSlider = ShellBitmap(CreateWindow(class'ShellBitmap', 114*RootScaleX,224*RootScaleY,32*RootScaleX,32*RootScaleY));
	VoiceVolumeSlider.T = texture'Audio_slidr_up';
	VoiceVolumeSlider.R = NewRegion(0,0,32,32);
	VoiceVolumeSlider.Template = NewRegion(0,0,32,32);
	VoiceVolumeSlider.bStretch = true;
	VoiceVolumeSlider.Style = 5;
	VoiceVolumeSlider.Manager = Self;

// Background Volume 
	BackgroundVolumeSlider = ShellBitmap(CreateWindow(class'ShellBitmap', 60*RootScaleX,224*RootScaleY,32*RootScaleX,32*RootScaleY));
	BackgroundVolumeSlider.T = texture'Audio_slidr_up';
	BackgroundVolumeSlider.R = NewRegion(0,0,32,32);
	BackgroundVolumeSlider.Template = NewRegion(0,0,32,32);
	BackgroundVolumeSlider.bStretch = true;
	BackgroundVolumeSlider.Style = 5;
	BackgroundVolumeSlider.Manager = Self;

	
// Sound Volume Up button	

	// 173,166
	SoundVolumeUp = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));

	//SoundVolumeUp.Template = NewRegion(172,152,64,64);
	SoundVolumeUp.Template = NewRegion(108,208,64,64);
	SoundVolumeUp.TexCoords = NewRegion(0,0,64,64);

	SoundVolumeUp.Manager = Self;
	SoundVolumeUp.Style = 5;

	SoundVolumeUp.bRepeat = True;

	SoundVolumeUp.UpTexture =   texture'audio_amb_uparr_up';
	SoundVolumeUp.DownTexture = texture'audio_amb_uparr_dn';
	SoundVolumeUp.OverTexture = texture'audio_amb_uparr_ov';
	SoundVolumeUp.DisabledTexture = None;

// Sound Volume Down button

	// 211,328
	SoundVolumeDown = ShellButton(CreateWindow(class'ShellButton', 211*RootScaleX, 328*RootScaleY, 48*RootScaleX, 38*RootScaleY));
	//SoundVolumeDown.Template = NewRegion(206,319,64,64);
	SoundVolumeDown.Template = NewRegion(179,370,64,64);
	SoundVolumeDown.TexCoords = NewRegion(0,0,64,64);

	SoundVolumeDown.Manager = Self;
	SoundVolumeDown.Style = 5;

	SoundVolumeDown.bRepeat = True;

	SoundVolumeDown.UpTexture =   texture'audio_voi_dnarr_up';
	SoundVolumeDown.DownTexture = texture'audio_voi_dnarr_dn';
	SoundVolumeDown.OverTexture = texture'audio_voi_dnarr_ov';
	SoundVolumeDown.DisabledTexture = None;



	// Voice Volume Up
	VoiceVolumeUp = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));
	VoiceVolumeUp.Template = NewRegion(269,162,64,64);
	VoiceVolumeUp.TexCoords = NewRegion(0,0,64,64);

	VoiceVolumeUp.Manager = Self;
	VoiceVolumeUp.Style = 5;

	VoiceVolumeUp.bRepeat = True;

	VoiceVolumeUp.UpTexture =   texture'audio_voi_uparr_up';
	VoiceVolumeUp.DownTexture = texture'audio_voi_uparr_dn';
	VoiceVolumeUp.OverTexture = texture'audio_voi_uparr_ov';
	VoiceVolumeUp.DisabledTexture = None;

	// Voice Volume Down
	VoiceVolumeDown = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));
	VoiceVolumeDown.Template = NewRegion(250,303,64,64);
	VoiceVolumeDown.TexCoords = NewRegion(0,0,64,64);

	VoiceVolumeDown.Manager = Self;
	VoiceVolumeDown.Style = 5;

	VoiceVolumeDown.bRepeat = True;

	VoiceVolumeDown.UpTexture =   texture'audio_voi_dnarr_up';
	VoiceVolumeDown.DownTexture = texture'audio_voi_dnarr_dn';
	VoiceVolumeDown.OverTexture = texture'audio_voi_dnarr_ov';
	VoiceVolumeDown.DisabledTexture = None;




	// Background Volume Up
	BackgroundVolumeUp = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));
	BackgroundVolumeUp.Template = NewRegion(172,149,64,64);
	BackgroundVolumeUp.TexCoords = NewRegion(0,0,64,64);

	BackgroundVolumeUp.Manager = Self;
	BackgroundVolumeUp.Style = 5;

	BackgroundVolumeUp.bRepeat = True;

	BackgroundVolumeUp.UpTexture =   texture'audio_amb_uparr_up';
	BackgroundVolumeUp.DownTexture = texture'audio_amb_uparr_dn';
	BackgroundVolumeUp.OverTexture = texture'audio_amb_uparr_ov';
	BackgroundVolumeUp.DisabledTexture = None;

	// Background Volume Down
	BackgroundVolumeDown = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));
	BackgroundVolumeDown.Template = NewRegion(210,328,64,64);	
	BackgroundVolumeDown.TexCoords = NewRegion(0,0,64,64);

	BackgroundVolumeDown.Manager = Self;
	BackgroundVolumeDown.Style = 5;

	BackgroundVolumeDown.bRepeat = True;

	BackgroundVolumeDown.UpTexture =   texture'audio_voi_dnarr_up';
	BackgroundVolumeDown.DownTexture = texture'audio_voi_dnarr_dn';
	BackgroundVolumeDown.OverTexture = texture'audio_voi_dnarr_ov';
	BackgroundVolumeDown.DisabledTexture = None;


	SoundVolumeChanged(0);
	VoiceVolumeChanged(0);
	BackgroundVolumeChanged(0);

	Root.Console.bBlackout = True;

	GetCurrentSettings();

	SoundEmitter = GetPlayerOwner().Spawn( class'Engine.ParticleFX');
	SoundEmitter.AmbientSound = Sound(DynamicLoadObject("Aeons.Spells.E_Spl_SkullScream02", class'Sound'));
	SoundEmitter.SoundPitch=48;
	SoundEmitter.SOundRadius=255;

	Resized();

	bInitialized = True;
}


function Resized()
{
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;
	local int i;

	Super.Resized();

	AeonsRoot = AeonsRootWindow(Root);

	if (AeonsRoot != None)
	{
		RootScaleX = AeonsRoot.ScaleX;
		RootScaleY = AeonsRoot.ScaleY;
	}
	else 
	{
		// nasty
		RootScaleX = 1.0;
		RootScaleY = 1.0;
	}

	SoundVolumeUp.ManagerResized(RootScaleX, RootScaleY);
	SoundVolumeDown.ManagerResized(RootScaleX, RootScaleY);
	BackgroundVolumeUp.ManagerResized(RootScaleX, RootScaleY);
	BackgroundVolumeDown.ManagerResized(RootScaleX, RootScaleY);
	VoiceVolumeUp.ManagerResized(RootScaleX, RootScaleY);
	VoiceVolumeDown.ManagerResized(RootScaleX, RootScaleY);
	
	SoundVolumeSlider.ManagerResized(RootScaleX, RootScaleY);
	VoiceVolumeSlider.ManagerResized(RootScaleX, RootScaleY);
	BackgroundVolumeSlider.ManagerResized(RootScaleX, RootScaleY);

	HighQuality.ManagerResized(RootScaleX, RootScaleY);
	Use3D.ManagerResized(RootScaleX, RootScaleY);

	OK.ManagerResized(RootScaleX, RootScaleY);
	Cancel.ManagerResized(RootScaleX, RootScaleY);
}

//----------------------------------------------------------------------------

function SoundVolumeChanged(float Delta)
{
	local float ThetaRange;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	AeonsRoot = AeonsRootWindow(Root);

	if (AeonsRoot != None)
	{
		RootScaleX = AeonsRoot.ScaleX;
		RootScaleY = AeonsRoot.ScaleY;
	}
	else 
	{
		// nasty
		RootScaleX = 1.0;
		RootScaleY = 1.0;
	}


	Soundvolume += Delta;
	SoundVolume = Clamp( SoundVolume, 0, 255);

	ThetaRange = SoundThetaEnd - SoundThetaStart;

	SoundVolumeSlider.Template.X = SoundCenter.x + SoundRadius * cos( SoundThetaStart + (SoundVolume/255.0) * ThetaRange) - SoundVolumeSlider.Template.W/2;
	SoundVolumeSlider.Template.Y = SoundCenter.y - SoundRadius * sin( SoundThetaStart + (SoundVolume/255.0) * ThetaRange) - SoundVolumeSlider.Template.H/2;
	
	SoundVolumeSlider.ManagerResized(RootScaleX, RootScaleY);

	if ( Abs(Delta) > 0.0 ) 
	{	
		if ( (ChangeSound != None) && bInitialized )
			GetPlayerOwner().PlaySound( ChangeSound, [Flags]482 );

		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume "$ SoundVolume);
	}
}

//----------------------------------------------------------------------------

function BackgroundVolumeChanged(float Delta)
{
	local float ThetaRange;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	AeonsRoot = AeonsRootWindow(Root);

	if (AeonsRoot != None)
	{
		RootScaleX = AeonsRoot.ScaleX;
		RootScaleY = AeonsRoot.ScaleY;
	}
	else 
	{
		// nasty
		RootScaleX = 1.0;
		RootScaleY = 1.0;
	}


	Backgroundvolume += Delta;
	BackgroundVolume = Clamp( BackgroundVolume, 0, 255);

	ThetaRange = BackgroundThetaEnd - BackgroundThetaStart;

	BackgroundVolumeSlider.Template.X = BackgroundCenter.x + BackgroundRadius * cos( BackgroundThetaStart + (BackgroundVolume/255.0) * ThetaRange ) - BackgroundVolumeSlider.Template.W/2;
	BackgroundVolumeSlider.Template.Y = BackgroundCenter.y - BackgroundRadius * sin( BackgroundThetaStart + (BackgroundVolume/255.0) * ThetaRange ) - BackgroundVolumeSlider.Template.H/2;
	
	BackgroundVolumeSlider.ManagerResized(RootScaleX, RootScaleY);
	
	if ( Abs(Delta) > 0.0 ) 
	{	
		if ( (ChangeSound != None) && bInitialized )
			GetPlayerOwner().PlaySound( ChangeSound, [Flags](482 + 8) );

		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice BackgroundVolume "$ BackgroundVolume);
	}
}

//----------------------------------------------------------------------------

function VoiceVolumeChanged(float Delta)
{
	local float ThetaRange;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	AeonsRoot = AeonsRootWindow(Root);

	if (AeonsRoot != None)
	{
		RootScaleX = AeonsRoot.ScaleX;
		RootScaleY = AeonsRoot.ScaleY;
	}
	else 
	{
		// nasty
		RootScaleX = 1.0;
		RootScaleY = 1.0;
	}


	Voicevolume += Delta;
	VoiceVolume = Clamp( VoiceVolume, 0, 255);

	ThetaRange = VoiceThetaEnd - VoiceThetaStart;

	VoiceVolumeSlider.Template.X = VoiceCenter.x + VoiceRadius * cos( VoiceThetaStart + (VoiceVolume/255.0) * ThetaRange ) - VoiceVolumeSlider.Template.W/2;
	VoiceVolumeSlider.Template.Y = VoiceCenter.y - VoiceRadius * sin( VoiceThetaStart + (VoiceVolume/255.0) * ThetaRange ) - VoiceVolumeSlider.Template.H/2;

	VoiceVolumeSlider.ManagerResized(RootScaleX, RootScaleY);
	
	if ( Abs(Delta) > 0.0 ) 
	{	
		if ( (ChangeSound != None) && bInitialized )
			GetPlayerOwner().PlaySound( ChangeSound, [Flags](482 + 16));

		GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice VoiceVolume "$ VoiceVolume);
	}
}

/* 
function int ForcePowerOfTwo( int Value ) 
{
	local int i;
	local float powtwo;

	if ( Value == 1 ) 
		return 1;

	for ( i=0; i<=8; i++ )
	{
		powtwo = 2 ** i;
		if ( powtwo >= Value ) 
			return i;
	}
}
*/


//----------------------------------------------------------------------------

function GetCurrentSettings()
{
	// get current values for Music, Sound and VoiceOver Volumes and remember them in case they cancel
	OrigSoundVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice SoundVolume "));
	OrigBackgroundVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice BackgroundVolume "));
	OrigVoiceVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice VoiceVolume "));

	OrigbUse3DHardware = bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice Use3dHardware")); 
	OrigbHighSoundQuality = ! bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice LowSoundQuality"));
 
/* 
	OrigSoundVolume =		ForcePowerOfTwo(OrigSoundVolume);
	OrigBackgroundVolume =	ForcePowerOfTwo(OrigBackgroundVolume);
	OrigVoiceVolume =		ForcePowerOfTwo(OrigVoiceVolume);
*/

	// set local values to current values
	SoundVolume = OrigSoundVolume;
	BackgroundVolume = OrigBackgroundVolume;
	VoiceVolume = OrigVoiceVolume;

	bUse3DHardware = OrigbUse3DHardware;
	bHighSoundQuality = OrigbHighSoundQuality;

	// link up shell components with variables
	HighQuality.bChecked = bHighSoundQuality;
	Use3D.bChecked = bUse3DHardware;	
	SoundVolumeChanged(0);
	VoiceVolumeChanged(0);
	BackgroundVolumeChanged(0);

	// Will save changes by default
	bSaveChanges = True;
}

//----------------------------------------------------------------------------

function UndoChanges()
{
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume "$ OrigSoundVolume );
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice BackgroundVolume "$ OrigBackgroundVolume );
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice VoiceVolume "$ OrigVoiceVolume );

	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice Use3dHardware " $ OrigbUse3DHardware);
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality " $ !OrigbHighSoundQuality);
	
	GetPlayerOwner().SaveConfig();
}

//----------------------------------------------------------------------------

function SaveChanges()
{
	//GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume "$ SoundVolume );
	
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice Use3dHardware " $ bUse3DHardware);
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality " $ !bHighSoundQuality);

	GetPlayerOwner().SaveConfig();
}

//----------------------------------------------------------------------------

function Paint(Canvas C, float X, float Y)
{
	local vector SoundLocation;

	Super.Paint(C, X, Y);

	Super.PaintSmoke(C, OK, SmokingWindows[0], SmokingTimers[0]);
	Super.PaintSmoke(C, Cancel, SmokingWindows[1], SmokingTimers[1]);
	
	Theta += ThetaRate;
	if ( Theta > 6.28 ) 
		Theta -= 6.28;
	else if ( Theta < -6.28 )
		Theta += 6.28;

	SoundLocation = GetPlayerOwner().Location;

	SoundLocation.X += cos(Theta) * Radius;
	SoundLocation.Y += sin(Theta) * Radius;

	SoundEmitter.SetLocation(SoundLocation);

	SoundEmitter.SoundRadius = 255;
}

function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			switch (B)
			{
				case SoundVolumeDown:
					SoundVolumeChanged(-17);
					break;

				case SoundVolumeUp:
					SoundVolumeChanged(17);
					break;
	
				case BackgroundVolumeDown:
					BackgroundVolumeChanged(-17);	
					break;

				case BackgroundVolumeUp:
					BackgroundVolumeChanged(17);
					break;

				case VoiceVolumeDown:
					VoiceVolumeChanged(-17);	
					break;

				case VoiceVolumeUp:
					VoiceVolumeChanged(17);
					break;

				case OK:
					bSaveChanges = true;
					PlayNewScreenSound();
					Close();
					break;

				case Cancel:
					bSaveChanges = false;
					PlayNewScreenSound();
					Close();
					break;
			}
			break;

		case DE_Change:
			switch (B)
			{
				case HighQuality:
					bHighSoundQuality = HighQuality.bChecked;

					if ( (CheckboxSound != none) && bInitialized )
						GetPlayerOwner().PlaySound( CheckboxSound,, 0.25, [Flags]482 );
					break;

				case Use3D:
					bUse3DHardware = Use3D.bChecked;

					if ( (CheckboxSound != none) && bInitialized )
						GetPlayerOwner().PlaySound( CheckboxSound,, 0.25, [Flags]482 );
					break;
			}
			break;

		case DE_MouseEnter:
			OverEffect(ShellButton(B));
			break;
	}
}

function OverEffect(ShellButton B)
{
	switch (B) 
	{
		case OK:
			SmokingWindows[0] = 1;
			SmokingTimers[0] = 90;
			break;

		case Cancel:
			SmokingWindows[1] = 1;
			SmokingTimers[1] = 90;
			break;
	}
}

function Close(optional bool bByParent)
{
	SoundEmitter.SoundRadius = 0;

	if ( bSaveChanges ) 
		SaveChanges();
	else
		UndoChanges();

	bSaveChanges = false;

	HideWindow();
}

/*
function HideWindow()
{
	local int i;

	Root.Console.bBlackOut = False;
	Super.HideWindow();

	for ( i=0; i<6; i++ )
	{
		if ( Back[i] != None )
			GetPlayerOwner().UnloadTexture( Back[i] );
	}

}
*/

function ShowWindow()
{
	Super.ShowWindow();

	GetCurrentSettings();
}

defaultproperties
{
     SoundCenter=(X=280,Y=257)
     BackgroundCenter=(X=307,Y=245)
     VoiceCenter=(X=313,Y=255)
     SoundThetaStart=4
     VoiceThetaStart=3.927
     BackgroundThetaStart=3.927
     SoundThetaEnd=3.2
     VoiceThetaEnd=2.3
     BackgroundThetaEnd=2.8
     SoundRadius=154
     VoiceRadius=79
     BackgroundRadius=128
     ChangeSound=Sound'Shell_HUD.Shell.SHELL_SliderClick'
     CheckboxSound=Sound'Shell_HUD.Shell.SHELL_CheckBox'
     BackNames(0)="UndyingShellPC.Audio_0"
     BackNames(1)="UndyingShellPC.Audio_1"
     BackNames(2)="UndyingShellPC.Audio_2"
     BackNames(3)="UndyingShellPC.Audio_3"
     BackNames(4)="UndyingShellPC.Audio_4"
     BackNames(5)="UndyingShellPC.Audio_5"
}
