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

var ShellButton Back;
var ShellButton FaceButton;
var ShellTextBox TextBox;

var ShellLabel NameLabel;

var localized string NameText, FaceText, BodyText;

var int		SmokingWindows[2];
var float	SmokingTimers[2];

//var actor SoundEmitter;

var bool bFace;

struct PlayerMeshInfo
{
	var() string Mesh;
	var() name Sequence;
};

var() PlayerMeshInfo PlayerMeshes[13];

var ShellButton		CrosshairLeft;
var ShellButton		CrosshairRight;

var PlayerMeshClient MeshWindow;

//----------------------------------------------------------------------------

function Created()
{
	local int i;
	local color TextColor;
	local float RootScaleX, RootScaleY;
	local vector Delta;

	Super.Created();
	
	SmokingWindows[0] = -1;

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	// temp
	PlayCount = 3 ; 

// 3D Model view
	MeshWindow = PlayerMeshClient(CreateWindow(class'PlayerMeshClient', 420*RootScaleX, 130*RootScaleY, 256*RootScaleY, 256*RootScaleY));
	MeshWindow.SetNotifyClient(self);
	MeshWindow.SetMesh(GetPlayerOwner().Mesh);
	MeshWindow.SetSkin(GetPlayerOwner().Skin);

// Back Button
	Back = ShellButton(CreateWindow(class'ShellButton', 48*RootScaleX, 500*RootScaleY, 160*RootScaleX, 64*RootScaleY));

	Back.TexCoords = NewRegion(0,0,160,64);
	Back.Template = NewRegion(48,500,160,64);

	Back.Manager = Self;
	Back.Style=5;

	Back.bBurnable = true;
	Back.OverSound=sound'Aeons.Shell_Blacken01';

	Back.UpTexture =   texture'ShellTextures.sload_cancel_up';
	Back.DownTexture = texture'ShellTextures.sload_cancel_dn';
	Back.OverTexture = texture'ShellTextures.sload_cancel_ov';
	
	/*
	FaceButton = ShellButton(CreateWindow(class'ShellButton', 60*RootScaleX, 350*RootScaleY, 160*RootScaleX, 40*RootScaleY));
	
	FaceButton.TexCoords = NewRegion(0,0,160,40);
	FaceButton.Template = NewRegion(60,350,160,40);
	
	FaceButton.Manager = Self;
	FaceButton.Style = 5;
	FaceButton.Text = BodyText;
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
	*/

	NameLabel = ShellLabel(CreateWindow(class'ShellLabel', 1,1,1,1));

	NameLabel.Template=NewRegion(50, 132, 158, 38);
	NameLabel.Manager = Self;
	NameLabel.Text = NameText;
	TextColor.R = 251;
	TextColor.G = 231;
	TextColor.B = 118;
	NameLabel.SetTextColor(TextColor);
	NameLabel.Align = TA_Center;
	NameLabel.Font = 4;
	
	TextBox = ShellTextBox(CreateWindow(class'ShellTextBox', 48*RootScaleX, 130*RootScaleY, 160*RootScaleX, 128*RootScaleY));

	//TextBox.TexCoords = NewRegion(0,0,160,128);
	TextBox.Template = NewRegion(48,130,160,128);
	TextBox.Font = 1;
	TextBox.Value = GetPlayerOwner().PlayerReplicationInfo.PlayerName;
	TextBox.CaretOffset = Len(TextBox.Value);

	TextBox.Manager = Self;
	
	//Root.Console.bBlackout = True;

	/*
	SoundEmitter = GetPlayerOwner().Spawn( class'Engine.ParticleFX');
	SoundEmitter.AmbientSound = Sound(DynamicLoadObject("Aeons.Spells.E_Spl_SkullScream02", class'Sound'));
	SoundEmitter.SoundPitch=48;
	SoundEmitter.SOundRadius=255;
	*/

	CrosshairLeft =	ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));
	CrosshairRight =	ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	CrosshairLeft.Style = 5;
	CrosshairRight.Style = 5;

	CrosshairLeft.Template =	NewRegion(400, 406, 88, 51);
	CrosshairRight.Template = NewRegion(635, 395, 88, 51);

	CrosshairLeft.TexCoords = NewRegion(0,0,88,51);
	CrosshairRight.TexCoords = NewRegion(0,0,88,51);

	CrosshairLeft.bRepeat = True;
	CrosshairRight.bRepeat = True;

	CrosshairLeft.key_interval = 0.08;
	CrosshairRight.key_interval = 0.08;

	

	CrosshairLeft.Manager = Self;

	CrosshairRight.Manager = Self;

	CrosshairLeft.UpTexture =   texture'Book_Left_Up';
	CrosshairLeft.DownTexture = texture'Book_Left_Dn';
	CrosshairLeft.OverTexture = texture'Book_Left_Ov';
	CrosshairLeft.DisabledTexture = texture'Book_Left_Ds';

	CrosshairRight.UpTexture =   texture'Book_Right_Up';
	CrosshairRight.DownTexture = texture'Book_Right_Dn';
	CrosshairRight.OverTexture = texture'Book_Right_Ov';
	CrosshairRight.DisabledTexture = texture'Book_Right_Ds';
	
	Resized();
}

//----------------------------------------------------------------------------

function Resized()
{
	local float RootScaleX, RootScaleY;
	local int i;

	Super.Resized();

	RootScaleX = Root.ScaleX;
	RootScaleY = Root.ScaleY;

	MeshWindow.SetSize(256*RootScaleY, 256*RootScaleY);
	MeshWindow.WinLeft = 420*RootScaleX;
	MeshWindow.WinTop = 130*RootScaleY;
	
	if ( FaceButton != None )
		FaceButton.ManagerResized(RootScaleX, RootScaleY);
		
	if ( TextBox != None )
		TextBox.ManagerResized(RootScaleX, RootScaleY);
		
	if ( NameLabel != None )
		NameLabel.ManagerResized(RootScaleX, RootScaleY);
		
	if ( Back != None )
		Back.ManagerResized(RootScaleX, RootScaleY);

	if ( CrosshairLeft != None ) 
		CrosshairLeft.ManagerResized(RootScaleX, RootScaleY);

	if ( CrosshairRight != None ) 
		CrosshairRight.ManagerResized(RootScaleX, RootScaleY);
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
					PlayNewScreenSound();
					Close();
					break;
				case FaceButton:
					FacePressed();
					break;
				case CrosshairLeft:
					ChangeMesh(-1);
					break;
				case CrosshairRight:
					ChangeMesh(1);
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
	//SoundEmitter.SoundRadius = 0;
	
	//GetPlayerOwner().ConsoleCommand("name " $ TextBox.Value);
	GetPlayerOwner().ChangeName(TextBox.GetValue());
	GetPlayerOwner().UpdateURL("Name", TextBox.GetValue(), True);

	HideWindow();
}

function Tick(float Delta)
{
	if (false) //bRotate
		ViewRotator.Yaw += 128;
}


function Paint(Canvas C, float X, float Y) 
{
	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;
	Super.Paint(C, X, Y);
	
	Super.PaintSmoke(C, Back, SmokingWindows[0], SmokingTimers[0]);
}

function FacePressed()
{
	bFace = !bFace;
	if (bFace)
		FaceButton.Text = FaceText;
	else
		FaceButton.Text = BodyText;
}

//----------------------------------------------------------------------------

// used for Multiplayer - Player Model viewing
function AnimEnd(MeshActor MyMesh)
{
//	if ( MyMesh.AnimSequence == 'Idle' )
//		MyMesh.TweenAnim('All', 0.4);
//	else
//		MyMesh.PlayAnim('Walk');//, 0.4);

	if ( MyMesh.AnimSequence == 'Breath3' )
		MyMesh.TweenAnim('All', 0.4);
	else
		MyMesh.PlayAnim('Breath3', 0.4);

	MyMesh.PlayAnim('Walk');	
}

function ChangeMesh(int d)
{
	CurrentMesh += d;
	if (CurrentMesh >= ArrayCount(PlayerMeshes))
	{
		CurrentMesh = 0;
	}
	else if (CurrentMesh < 0)
	{
		CurrentMesh = ArrayCount(PlayerMeshes) - 1;
	}

	// change mesh
	MeshWindow.SetMesh(SkelMesh(DynamicLoadObject(PlayerMeshes[CurrentMesh].Mesh, class'SkelMesh')));
	MeshWindow.MeshActor.PlayAnim(PlayerMeshes[CurrentMesh].Sequence);

	// apply changes
	// disabled until proper weapon attachment for other meshes
	//GetPlayerOwner().UpdateURL("Mesh", string(MeshWindow.MeshActor.Mesh), True);
}

//----------------------------------------------------------------------------

function ShowWindow()
{
	Super.ShowWindow();
	AnimEnd(MeshWindow.MeshActor);
}

//----------------------------------------------------------------------------

/*
PlayerMeshes(0)=(Mesh="Aeons.Meshes.Patrick_m",Sequence=Walk)
PlayerMeshes(1)=(Mesh="Aeons.Meshes.TrsantiBase_m",Sequence=Walk)
PlayerMeshes(2)=(Mesh="Aeons.Meshes.Shaman_m",Sequence=Walk)

PlayerMeshes(0)=(Mesh="Aeons.Meshes.AaronGhost_m",Sequence=Walk)
PlayerMeshes(1)=(Mesh="Aeons.Meshes.Bethany_m",Sequence=Walk)
PlayerMeshes(2)=(Mesh="Aeons.Meshes.Ambrose_m",Sequence=Walk)
PlayerMeshes(3)=(Mesh="Aeons.Meshes.Kiesinger_m",Sequence=Walk)
PlayerMeshes(4)=(Mesh="Aeons.Meshes.Jemaas_m",Sequence=Walk)
PlayerMeshes(5)=(Mesh="Aeons.Meshes.Jeremiah_m",Sequence=Walk)
PlayerMeshes(6)=(Mesh="Aeons.Meshes.MonkSoldier_m",Sequence=Walk)
PlayerMeshes(7)=(Mesh="Aeons.Meshes.Drinen_m",Sequence=Walk)
PlayerMeshes(8)=(Mesh="Aeons.Meshes.Shaman_m",Sequence=Walk)
PlayerMeshes(9)=(Mesh="Aeons.Meshes.Lizbeth_m",Sequence=Walk)
PlayerMeshes(10)=(Mesh="Aeons.Meshes.MonkAbbott_m",Sequence=Walk)
PlayerMeshes(11)=(Mesh="Aeons.Meshes.Evelyn_m",Sequence=Walk)
*/

defaultproperties
{
     NumMeshes=12
     ViewRotator=(Yaw=32768)
     NameText="Name"
     FaceText="Face"
     BodyText="Body"
     BackNames(0)="ShellTextures.PSetup_0"
     BackNames(1)="ShellTextures.PSetup_1"
     BackNames(2)="ShellTextures.PSetup_2"
     BackNames(3)="ShellTextures.PSetup_3"
     BackNames(4)="ShellTextures.PSetup_4"
     BackNames(5)="ShellTextures.PSetup_5"
     PlayerMeshes(0)=(Mesh="Aeons.Meshes.Patrick_m",Sequence=Walk)
     PlayerMeshes(1)=(Mesh="Aeons.Meshes.AaronGhost_m",Sequence=Walk)
     PlayerMeshes(2)=(Mesh="Aeons.Meshes.Bethany_m",Sequence=Walk)
     PlayerMeshes(3)=(Mesh="Aeons.Meshes.Ambrose_m",Sequence=Walk)
     PlayerMeshes(4)=(Mesh="Aeons.Meshes.Kiesinger_m",Sequence=Walk)
     PlayerMeshes(5)=(Mesh="Aeons.Meshes.Jemaas_m",Sequence=Walk)
     PlayerMeshes(6)=(Mesh="Aeons.Meshes.Jeremiah_m",Sequence=Walk)
     PlayerMeshes(7)=(Mesh="Aeons.Meshes.MonkSoldier_m",Sequence=Walk)
     PlayerMeshes(8)=(Mesh="Aeons.Meshes.Drinen_m",Sequence=Walk)
     PlayerMeshes(9)=(Mesh="Aeons.Meshes.Shaman_m",Sequence=Walk)
     PlayerMeshes(10)=(Mesh="Aeons.Meshes.Lizbeth_m",Sequence=Walk)
     PlayerMeshes(11)=(Mesh="Aeons.Meshes.MonkAbbott_m",Sequence=Walk)
     PlayerMeshes(12)=(Mesh="Aeons.Meshes.Evelyn_m",Sequence=Walk)
}
