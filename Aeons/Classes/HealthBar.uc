class HealthBar expands Object;

#exec Texture Import File=HealthBar.bmp Mips=Off

var private int X, Y, W, H;

var float MaxHealth;
var bool bManual;
var private float Percent;
var private float DisplayPercent;

var private float LastTimeSeconds;

var Pawn Owner;

enum EHealthBarState
{
	HBS_Vulnerable,
	HBS_ReallyVulnerable,
	HBS_VulnerableScythe,
	HBS_Invulnerable
};

var texture InfoIcon;

var EHealthBarState State;

var color VulnerableColor, VulnerableScytheColor, InvulnerableColor, BackgroundColor;

static final function HealthBar CreateHealthBar(Pawn Owner, bool bManual)
{
	local HealthBar HealthBar;
	local ScriptedPawn SP;

	HealthBar = new(Owner.XLevel) class'HealthBar';

	HealthBar.Owner = Owner;
	HealthBar.bManual = bManual;

	SP = ScriptedPawn(Owner);
	if ( SP != None )
		HealthBar.MaxHealth = SP.InitHealth;
	else
		HealthBar.MaxHealth = Owner.default.Health;

	if ( bManual )
	{
		HealthBar.Percent = 1.0;
		HealthBar.DisplayPercent = 1.0;
	}
	else
	{
		HealthBar.Percent = Owner.Health / HealthBar.MaxHealth;
		HealthBar.DisplayPercent = HealthBar.Percent;
	}

	HealthBar.LastTimeSeconds = Owner.Level.TimeSeconds;

	return HealthBar;
}

function SetPercent(float NewPercent)
{
	Percent = NewPercent;
}

function Paint(Canvas C)
{
	local float OrgX, OrgY, ClipX, ClipY;
	local byte Style;
	local color DrawColor;
	local float Scale, DeltaTime;
	local float TextW, TextH;
	local float P1, P2;

	if (!bManual)
		Percent = FClamp(Owner.Health / MaxHealth, 0, 1);

	DeltaTime = FClamp(Owner.Level.TimeSeconds - LastTimeSeconds, 0.001, 0.05);
	LastTimeSeconds = Owner.Level.TimeSeconds;

	DisplayPercent = Lerp(DeltaTime * 20, DisplayPercent, Percent);

	if (DisplayPercent < 0.001)
	{
		DisplayPercent = 0;
		return;
	}
	
	Scale = C.SizeY / 600.0;

	W = 530*Scale;
	H = 58*Scale; // 72

	X = (C.SizeX - W) * 0.5;
	Y = 10*Scale;

	// Save
	OrgX = C.OrgX;
	OrgY = C.OrgY;
	ClipX = C.ClipX;
	ClipY = C.ClipY;
	Style = C.Style;
	DrawColor = C.DrawColor;

	C.Style = 5;
	C.SetOrigin(X, Y);
	C.SetClip(W, H);

	// Draw the background
	C.SetPos(0, 0);
	C.DrawColor = BackgroundColor;

	//C.bNoSmooth = true;
	const Offset = 2; // needed if we don't use bNoSmooth
	
	C.DrawTileClipped(Texture'HealthBar', W*0.5, H, 2, 2, 215-Offset, 34);
	C.DrawTileClipped(Texture'HealthBar', W*0.5, H, 5+Offset, 42, 215-Offset, 34);

	// Draw the health
	C.SetPos(0, 0);
	switch (State)
	{
		case HBS_Vulnerable:
			C.DrawColor = VulnerableColor;
			break;
		case HBS_ReallyVulnerable:
			C.DrawColor = VulnerableScytheColor;
			break;
		case HBS_VulnerableScythe:
			C.DrawColor = VulnerableScytheColor;
			break;
		case HBS_Invulnerable:
			C.DrawColor = InvulnerableColor;
			break;
	}

	P1 = FMin(DisplayPercent, 0.5);
	P2 = DisplayPercent - P1;

	C.DrawTileClipped(Texture'HealthBar', W*P1, H, 2, 2, 215*P1*2-Offset, 34);
	C.DrawTileClipped(Texture'HealthBar', W*P2, H, 5+Offset, 42, 215*P2*2-Offset, 34);

	// Draw scythe icon
	if (State == HBS_VulnerableScythe)
	{
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;

		// Draw the Berserk Glow
		//if (Scythe(PlayerTarget.Weapon).bBerserk)
		C.Style = 3;
		C.SetPos(-64*Scale, 0);
		C.DrawTile(Texture'Aeons.Icons.Scythe_Icon_Glow', H, H, 0, 0, 64, 64);
		
		// Draw the normal icon
		C.Style = 5;
		C.SetPos(-64*Scale, 0);
		C.DrawTile(Texture'Aeons.Icons.Scythe_Icon', H, H, 0, 0, 64, 64);
	}
	else if (InfoIcon != None)
	{
		// Draw info icon
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;

		C.Style = 5;
		C.SetPos(-InfoIcon.USize*Scale, 0);
		C.DrawTile(InfoIcon, H, H, 0, 0, InfoIcon.USize, InfoIcon.VSize);
	}

	// Draw pawn name
	C.Style = 1;
	C.Font = C.LargeFont;
	C.DrawColor = BackgroundColor;
	C.TextSize(Owner.MenuName, TextW, TextH);
	C.SetPos((W-TextW)/2, 5*Scale);
	C.DrawText(Owner.MenuName);
	
	// Restore
	C.SetClip(ClipX, ClipY);
	C.SetOrigin(OrgX, OrgY);
	C.Style = Style;
	C.DrawColor = DrawColor;
}

defaultproperties
{
     VulnerableColor=(R=156,G=8,B=8,A=255)
     VulnerableScytheColor=(R=255,G=0,B=0,A=255)
     InvulnerableColor=(R=50,G=50,B=50,A=255)
     BackgroundColor=(R=255,G=255,B=255,A=255)
}

