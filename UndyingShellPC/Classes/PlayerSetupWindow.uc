//=============================================================================
// PlayerSetupWindow.
//=============================================================================
class PlayerSetupWindow expands ShellWindow;

#exec Texture Import File=PSetup_0.bmp Mips=Off
#exec Texture Import File=PSetup_1.bmp Mips=Off
#exec Texture Import File=PSetup_2.bmp Mips=Off
#exec Texture Import File=PSetup_3.bmp Mips=Off
#exec Texture Import File=PSetup_4.bmp Mips=Off
#exec Texture Import File=PSetup_5.bmp Mips=Off

#exec Texture Import File=psetup_ok_ov.BMP	Mips=Off Flags=2
#exec Texture Import File=psetup_ok_up.BMP	Mips=Off Flags=2
#exec Texture Import File=psetup_ok_dn.BMP	Mips=Off Flags=2


var int PlayCount;
var int NumMeshes;
var int CurrentMesh;
var vector	ViewOffset;
var rotator ViewRotator;
var MeshActor Model;

var ShellButton Back;
var ShellButton FaceButton;

var localized string FaceText, BodyText;

var int		SmokingWindows[2];
var float	SmokingTimers[2];

var actor SoundEmitter;

var bool bFace;
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
	
	SmokingWindows[0] = -1;

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
	Back = ShellButton(CreateWindow(class'ShellButton', 48*RootScaleX, 500*RootScaleY, 160*RootScaleX, 64*RootScaleY));

	Back.TexCoords = NewRegion(0,0,160,64);
	Back.Template = NewRegion(48,500,160,64);

	Back.Manager = Self;
	Back.Style=5;

	Back.bBurnable = true;
	Back.OverSound=sound'Aeons.Shell_Blacken01';

	Back.UpTexture =   texture'sload_cancel_up';
	Back.DownTexture = texture'sload_cancel_dn';
	Back.OverTexture = texture'sload_cancel_ov';
	
	FaceButton = ShellButton(CreateWindow(class'ShellButton', 130*RootScaleX, 350*RootScaleY, 140*RootScaleX, 40*RootScaleY));
	
	FaceButton.TexCoords = NewRegion(0,0,140,40);
	FaceButton.Template = NewRegion(130,350,140,40);
	
	FaceButton.Manager = Self;
	FaceButton.Style = 5;
	FaceButton.Text = FaceText;
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	FaceButton.SetTextColor(TextColor);
	FaceButton.TextStyle=1;
	FaceButton.Align = TA_Center;
	FaceButton.Font = 4;

	FaceButton.UpTexture =		texture'Video_resol_up';
	FaceButton.DownTexture =		texture'Video_resol_up';
	FaceButton.OverTexture =		texture'Video_resol_ov';
	FaceButton.DisabledTexture =	None;
	
	//Root.Console.bBlackout = True;

	SoundEmitter = GetPlayerOwner().Spawn( class'Engine.ParticleFX');
	SoundEmitter.AmbientSound = Sound(DynamicLoadObject("Aeons.Spells.E_Spl_SkullScream02", class'Sound'));
	SoundEmitter.SoundPitch=48;
	SoundEmitter.SOundRadius=255;

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

function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			switch (B)
			{
				case Back:
					Close();
					break;
				case FaceButton:
					FacePressed();
					break;
			}
			break;

		case DE_Change:
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
		case Back:
			SmokingWindows[0] = 1;
			SmokingTimers[0] = 90;
			break;
	}
}

function Close(optional bool bByParent)
{
	SoundEmitter.SoundRadius = 0;

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
	if (false) //bRotate
		ViewRotator.Yaw += 128;
}


function Paint(Canvas C, float X, float Y) 
{
	local float OldFov;

	C.Style = GetPlayerOwner().ERenderStyle.STY_Modulated;
	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
	Super.Paint(C, X, Y);
	
	Super.PaintSmoke(C, Back, SmokingWindows[0], SmokingTimers[0]);

	if (Model != None)
	{
		OldFov = GetPlayerOwner().FOVAngle;
		GetPlayerOwner().SetFOVAngle(30);
	    if (bFace)
			DrawClippedActor( C, WinWidth/5, WinHeight/5, Model, False, ViewRotator, Model.ViewOffset + vect(-40, 0, 0 ));
		else
			DrawClippedActor( C, WinWidth/5, WinHeight/5, Model, False, ViewRotator, Model.ViewOffset);
		GetPlayerOwner().SetFOVAngle(OldFov);
	}
}

function FacePressed()
{
	bFace = !bFace;
	if (bFace)
		FaceButton.Text = BodyText;
	else
		FaceButton.Text = FaceText;
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

// function SetMeshString(string NewMesh)
// {
	// SetMesh(mesh(DynamicLoadObject(NewMesh, Class'Mesh')));
// }

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
	//SetMeshString(MyMesh);
}

//----------------------------------------------------------------------------

function ShowWindow()
{
	Super.ShowWindow();
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
	 FaceText="Face"
     BodyText="Body"
}