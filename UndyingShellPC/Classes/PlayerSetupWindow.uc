//=============================================================================
// PlayerSetupWindow.
//=============================================================================
class PlayerSetupWindow expands ShellWindow;

//#exec Texture Import File=PSetup_0.bmp Mips=Off
//#exec Texture Import File=PSetup_1.bmp Mips=Off
//#exec Texture Import File=PSetup_2.bmp Mips=Off
//#exec Texture Import File=PSetup_3.bmp Mips=Off
//#exec Texture Import File=PSetup_4.bmp Mips=Off
//#exec Texture Import File=PSetup_5.bmp Mips=Off

//#exec Texture Import File=psetup_ok_ov.BMP	Mips=Off Flags=2
//#exec Texture Import File=psetup_ok_up.BMP	Mips=Off Flags=2
//#exec Texture Import File=psetup_ok_dn.BMP	Mips=Off Flags=2


var int PlayCount;
var int NumMeshes;
var int CurrentMesh;
var vector	ViewOffset;
var rotator ViewRotator;
var MeshActor Model;

var ShellButton Back;

var bool bSaveChanges;

//----------------------------------------------------------------------------

function Created()
{

	local int i;
	local color TextColor;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;
	local vector Delta;

	Super.Created();
	
	AeonsRoot = AeonsRootWindow(Root);

	if ( AeonsRoot == None ) 
	{
		Log("AeonsRoot is Null!");
		return;
	}

	RootScaleX = AeonsRoot.ScaleX;
	RootScaleY = AeonsRoot.ScaleY;

	// temp
	PlayCount = 3 ; 

// 3D Model view
//	Model = GetEntryLevel().Spawn(class'MeshActor', GetEntryLevel());
	Model = GetPlayerOwner().Spawn(class'MeshActor', GetEntryLevel());
	Model.Mesh = GetPlayerOwner().Mesh;
	Model.Skin = GetPlayerOwner().Skin;
	Model.NotifyClient = Self;
	SetMesh(Model.Mesh);


// Back Button
	Back = ShellButton(CreateWindow(class'ShellButton', 48*RootScaleX, 500*RootScaleY, 139*RootScaleX, 46*RootScaleY));

	Back.TexCoords.X = 0;
	Back.TexCoords.Y = 0;
	Back.TexCoords.W = 139;
	Back.TexCoords.H = 46;

	// position and size in designed resolution of 800x600
	Back.Template = NewRegion(48,500,139,46);

	Back.Manager = Self;
	Back.Text = "";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	Back.SetTextColor(TextColor);
	Back.Font = 0;

	Back.bBurnable = true;

	Back.UpTexture =   texture'audio_ok_up';
	Back.DownTexture = texture'audio_ok_dn';
	Back.OverTexture = texture'audio_ok_ov';
	Back.DisabledTexture = None;

	Root.Console.bBlackout = True;

	GetCurrentSettings();

/*
	SoundEmitter = GetPlayerOwner().Spawn( class'Engine.ParticleFX');
	SoundEmitter.AmbientSound = Sound(DynamicLoadObject("Aeons.Spells.E_Spl_SkullScream02", class'Sound'));
	SoundEmitter.SoundPitch=48;
	SoundEmitter.SOundRadius=255;
*/
	Resized();
}

//----------------------------------------------------------------------------

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

	if ( Back != None )
		Back.ManagerResized(RootScaleX, RootScaleY);
}

//----------------------------------------------------------------------------

function GetCurrentSettings()
{
/*
	// get current values for Music, Sound and VoiceOver Volumes and remember them in case they cancel
	OrigMusicVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice MusicVolume ")) * (9.0 / 255.0);
	OrigSoundVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice SoundVolume ")) * (9.0 / 255.0);
	OrigVoiceVolume = int(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice VoiceVolume ")) * (9.0 / 255.0);
	OrigbUse3DHardware = bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice Use3dHardware")); 
	OrigbHighSoundQuality = ! bool(GetPlayerOwner().ConsoleCommand("get ini:Engine.Engine.AudioDevice LowSoundQuality"));

	// set local values to current values
	MusicVolume = OrigMusicVolume;
	SoundVolume = OrigSoundVolume;
	VoiceVolume = OrigVoiceVolume;
	bUse3DHardware = OrigbUse3DHardware;
	bHighSoundQuality = OrigbHighSoundQuality;

	// link up shell components with variables
	HighQuality.bChecked = bHighSoundQuality;
	EAx.bChecked = bUse3DHardware;	
	MusicVolumeChanged(0.0);
	SoundVolumeChanged(0.0);
	VoiceVolumeChanged(0.0);
*/
}

//----------------------------------------------------------------------------

function UndoChanges()
{
/*
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume "$Clamp(OrigSoundVolume*255.0/9.0,0,255) );
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$Clamp(OrigMusicVolume*255.0/9.0,0,255) );
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice VoiceVolume "$Clamp(OrigVoiceVolume*255.0/9.0,0,255) );

	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice Use3dHardware " $ OrigbUse3DHardware);
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality " $ !OrigbHighSoundQuality);
	
	GetPlayerOwner().SaveConfig();
*/
}

function SaveChanges()
{
/*
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice SoundVolume "$Clamp(SoundVolume*255.0/9.0,0,255) );
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice MusicVolume "$Clamp(MusicVolume*255.0/9.0,0,255) );
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice VoiceVolume "$Clamp(VoiceVolume*255.0/9.0,0,255) );
	
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice Use3dHardware " $ bUse3DHardware);
	GetPlayerOwner().ConsoleCommand("set ini:Engine.Engine.AudioDevice LowSoundQuality " $ !bHighSoundQuality);

	GetPlayerOwner().SaveConfig();
*/
}

//----------------------------------------------------------------------------

function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			switch (B)
			{
				case Back:
					bSaveChanges = true;
					Close();
					break;

			}
			break;

		case DE_Change:
			break;
	}
}


function Close(optional bool bByParent)
{
	//SoundEmitter.SoundRadius = 0;

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

function Tick(float Delta)
{
//	if (bRotate)
		ViewRotator.Yaw += 128;
}


function Paint(Canvas C, float X, float Y) 
{
	local float OldFov;

//	C.Style = GetPlayerOwner().ERenderStyle.STY_Modulated;
//	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
//	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
	Super.Paint(C, X, Y);

	if (Model != None)
	{
		OldFov = GetPlayerOwner().FOVAngle;
		GetPlayerOwner().SetFOVAngle(30);
//		if (bFace)
//			DrawClippedActor( C, WinWidth/2, WinHeight/2, Model, False, ViewRotator, vect(-10, 0, -3) );
//		else
			DrawClippedActor( C, WinWidth/5, WinHeight/5, Model, False, ViewRotator, Model.ViewOffset);//vect(0, 0, 0) );
		GetPlayerOwner().SetFOVAngle(OldFov);
	}
}

//----------------------------------------------------------------------------

function SetMesh(mesh NewMesh)
{
	Model.bMeshEnviroMap = False;
	Model.DrawScale = Model.Default.DrawScale;
	Model.Mesh = NewMesh;
	if(Model.Mesh != None)
		Model.PlayAnim('Walk');//, 0.5);
}

//----------------------------------------------------------------------------

function SetNoAnimMesh(mesh NewMesh)
{
	Model.bMeshEnviroMap = False;
	Model.DrawScale = Model.Default.DrawScale;
	Model.Mesh = NewMesh;
}

//----------------------------------------------------------------------------

function SetMeshString(string NewMesh)
{
	SetMesh(mesh(DynamicLoadObject(NewMesh, Class'Mesh')));
}

//----------------------------------------------------------------------------

function SetNoAnimMeshString(string NewMesh)
{
	SetNoAnimMesh(mesh(DynamicLoadObject(NewMesh, Class'Mesh')));
}

//----------------------------------------------------------------------------

// used for Multiplayer - Player Model viewing
function AnimEnd(MeshActor MyMesh)
{
//	if ( MyMesh.AnimSequence == 'Idle' )
//		MyMesh.TweenAnim('All', 0.4);
//	else
//		MyMesh.PlayAnim('Walk');//, 0.4);


	PlayCount--;

	//switch( int(FRand()*11) )
	if ( PlayCount >= 0 ) 
	{
		MyMesh.PlayAnim('Walk');
		return;
	}
	else
	{
		PlayCount = 3;
		CurrentMesh++;

		if (CurrentMesh >= NumMeshes)
		{
			CurrentMesh = 0;
		}
	}

	switch( CurrentMesh )
	{
		case 0: 
			MyMesh.Mesh = SkelMesh(DynamicLoadObject("Aeons.Meshes.AaronBoss_m", class'SkelMesh'));
			MyMesh.PlayAnim('Walk');
			break;

		case 1:
			MyMesh.Mesh = SkelMesh(DynamicLoadObject("Aeons.Meshes.Bethany_m", class'SkelMesh'));
			MyMesh.PlayAnim('Walk');
			break;

		case 2: 
			MyMesh.Mesh = SkelMesh(DynamicLoadObject("Aeons.Meshes.Ambrose_m", class'SkelMesh'));
			MyMesh.PlayAnim('Walk');
			break;

		case 3: 
			MyMesh.Mesh = SkelMesh(DynamicLoadObject("Aeons.Meshes.Kiesinger_m", class'SkelMesh'));
			MyMesh.PlayAnim('Walk');
			break;

		case 4: 
			MyMesh.Mesh = SkelMesh(DynamicLoadObject("Aeons.Meshes.Jemaas_m", class'SkelMesh'));
			MyMesh.PlayAnim('Walk');
			break;

		case 5: 
			MyMesh.Mesh = SkelMesh(DynamicLoadObject("Aeons.Meshes.Jeremiah_m", class'SkelMesh'));
			MyMesh.PlayAnim('Walk');
			break;

		case 6: 
			MyMesh.Mesh = SkelMesh(DynamicLoadObject("Aeons.Meshes.MonkSoldier_m", class'SkelMesh'));
			MyMesh.PlayAnim('Walk');
			break;

		case 7: 
			MyMesh.Mesh = SkelMesh(DynamicLoadObject("Aeons.Meshes.Butler_m", class'SkelMesh'));
			MyMesh.PlayAnim('Walk');
			break;

		case 8: 
			MyMesh.Mesh = SkelMesh(DynamicLoadObject("Aeons.Meshes.Shaman_m", class'SkelMesh'));
			MyMesh.PlayAnim('Walk');
			break;

		case 9: 
			MyMesh.Mesh = SkelMesh(DynamicLoadObject("Aeons.Meshes.Lizbeth_m", class'SkelMesh'));
			MyMesh.PlayAnim('Walk');
			break;

		case 10: 
			MyMesh.Mesh = SkelMesh(DynamicLoadObject("Aeons.Meshes.MonkAbbott_m", class'SkelMesh'));
			MyMesh.PlayAnim('Walk');
			break;

		case 11: 
			MyMesh.Mesh = SkelMesh(DynamicLoadObject("Aeons.Meshes.Patrick_m", class'SkelMesh'));
			MyMesh.PlayAnim('Walk');
			break;

	}
	// SetMeshString()

}

//----------------------------------------------------------------------------

function ShowWindow()
{
	Super.ShowWindow();

	GetCurrentSettings();
}

//----------------------------------------------------------------------------

defaultproperties
{
     NumMeshes=12
     ViewRotator=(Yaw=32768)
     BackNames(0)="UndyingShellPC.PSetup_0"
     BackNames(1)="UndyingShellPC.PSetup_1"
     BackNames(2)="UndyingShellPC.PSetup_2"
     BackNames(3)="UndyingShellPC.PSetup_3"
     BackNames(4)="UndyingShellPC.PSetup_4"
     BackNames(5)="UndyingShellPC.PSetup_5"
}
