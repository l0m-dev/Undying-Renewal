class PlayerMeshClient extends UWindowDialogClientWindow;

var UWindowButton CenterButton;

var UWindowButton LeftButton, RightButton;

var MeshActor MeshActor;

var rotator CenterRotator, ViewRotator;

var bool bFace, bRotate, bTween;

function Created()
{
	Super.Created();

	MeshActor = GetEntryLevel().Spawn(class'MeshActor', GetEntryLevel());
	MeshActor.Mesh = GetPlayerOwner().Mesh;
	MeshActor.Skin = GetPlayerOwner().Skin;
	//MeshActor.NotifyClient = Self;

	//if(MeshActor.Mesh != None)
	//	MeshActor.PlayAnim('Breath3', 0.4);

	CenterButton = UWindowButton(CreateControl(class'UWindowButton', WinWidth/3, 0, WinWidth/3, WinHeight));
	CenterButton.bIgnoreLDoubleclick = True;
	ViewRotator = rot(0, 32768, 0);

	LeftButton = UWindowButton(CreateControl(class'UWindowButton', 0, 0, WinWidth/3, WinHeight));
	LeftButton.bIgnoreLDoubleclick = True;

	RightButton = UWindowButton(CreateControl(class'UWindowButton', (WinWidth/3)*2, 0, WinWidth/3, WinHeight));
	RightButton.bIgnoreLDoubleclick = True;
}

function Resized()
{
	Super.Resized();

	CenterButton.SetSize(WinWidth/3, WinHeight);
	CenterButton.WinLeft = WinWidth/3;

	LeftButton.SetSize(WinWidth/3, WinHeight);
	LeftButton.WinLeft = 0;

	RightButton.SetSize(WinWidth/3, WinHeight);
	RightButton.WinLeft = (WinWidth/3)*2;
}

function BeforePaint(Canvas C, float X, float Y)
{
	if (LeftButton.bMouseDown) {
		ViewRotator.Yaw += 512;
	} else if (RightButton.bMouseDown) {
		ViewRotator.Yaw -= 512;
	}	
}

function Paint(Canvas C, float X, float Y) 
{
	local float OldFov;

	//C.Style = GetPlayerOwner().ERenderStyle.STY_Modulated;
	//DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');
	C.Style = GetPlayerOwner().ERenderStyle.STY_Normal;

	if (MeshActor != None)
	{
		OldFov = GetPlayerOwner().FOVAngle;
		GetPlayerOwner().SetFOVAngle(30);
		if (bFace)
			DrawClippedActor( C, WinWidth/2, WinHeight/2, MeshActor, False, ViewRotator, vect(-10, 0, -3) );
		else
			DrawClippedActor( C, WinWidth/2, WinHeight/2, MeshActor, False, ViewRotator, vect(0, 0, 0) );
		GetPlayerOwner().SetFOVAngle(OldFov);
	}
}

function Tick(float Delta)
{
	if (bRotate)
		ViewRotator.Yaw += 128;
}

function SetSkin(texture NewSkin)
{
	MeshActor.Skin = NewSkin;
}

function SetMesh(mesh NewMesh)
{
	MeshActor.bMeshEnviroMap = False;
	MeshActor.DrawScale = MeshActor.Default.DrawScale;
	MeshActor.Mesh = NewMesh;
	if(MeshActor.Mesh != None)
		MeshActor.PlayAnim('Walk');//, 0.5);
}

function SetNoAnimMesh(mesh NewMesh)
{
	MeshActor.bMeshEnviroMap = False;
	MeshActor.DrawScale = MeshActor.Default.DrawScale;
	MeshActor.Mesh = NewMesh;
}

function SetMeshString(string NewMesh)
{
	SetMesh(mesh(DynamicLoadObject(NewMesh, Class'Mesh')));
}

function SetNoAnimMeshString(string NewMesh)
{
	SetNoAnimMesh(mesh(DynamicLoadObject(NewMesh, Class'Mesh')));
}

function SetNotifyClient(ShellWindow Client)
{
	MeshActor.NotifyClient = Client;
}

function Close(optional bool bByParent)
{
	Log("Mesh client closed!");
	Super.Close(bByParent);
	if(MeshActor != None)
	{
		MeshActor.Destroy();
		MeshActor = None;
	}
}

function Notify(UWindowDialogControl C, byte E)
{
	switch (E)
	{
		case DE_Click:
			switch (C)
			{
				//case LeftButton:
				//	LeftPressed();
				//	break;
				//case RightButton:
				//	RightPressed();
				//	break;
				case CenterButton:
					ViewRotator = rot(0, 32768, 0) + CenterRotator;
					break;
			}
			break;
	}
}

function LeftPressed()
{
	ViewRotator.Yaw += 128;
}

function RightPressed()
{
	ViewRotator.Yaw -= 128;
}

function AnimEnd(MeshActor MyMesh)
{
	if ( MyMesh.AnimSequence == 'Breath3' )
		MyMesh.TweenAnim('All', 0.4);
	else
		MyMesh.PlayAnim('Breath3', 0.4);
}

defaultproperties
{
     
}
