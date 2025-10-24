class CoopTranslocator extends Inventory;

// could make this a PlayerModifier if we don't need the ability to spawn and pick this item up in game

#exec Texture Import File=RedPixel.bmp

var bool bCanTranslocate;
var Pawn TargetPawn;
var int DisableUse;
var() localized String Selected;
var() localized String TranslocateFailed;
var() localized String PlayerMovesUp;
var() localized string NoSpaceAbove;
var() localized String StillDisabled;
var() localized String Ready;
var() globalconfig int DisableUseTime;

var Pawn Players[32];
var int NumPlayers;

var sound SuccessSound;
var sound FailedSound;

replication
{
	reliable if ( bNetOwner && Role == ROLE_Authority )
		TargetPawn;
	reliable if ( Role < ROLE_Authority )
		TrySelectTarget;
}

state Idle2
{
	function BeginState()
	{
		SetTimer(Level.TimeDilation, true);
	}
	function Timer()
	{
		if (bActive)
			BuildPlayersList();

		if (DisableUse > 0)
		{
			DisableUse--;
			if (DisableUse == 0 && bActive)
				Pawn(Owner).ChatMessage(None, Ready, 'Translocator');
		}
	}
}

function TrySelectTarget(GhelziabahrStone GhelziabahrStone)
{
	bActive = true;
	GhelziabahrStone.CoopTranslocator = self;

	if (bCanTranslocate)
		SelectTarget();
}

function TryTranslocate()
{
	if (bCanTranslocate)
		Translocate();
	Deactivate();
}

static simulated function bool canBeTarget(CoopTranslocator Translocator, Pawn Target)
{
	if (Target.PlayerReplicationInfo != None && !Target.IsA('Spectator') && !Target.IsA('Camera') && Target != Translocator.Owner)
	{
		Target.bAlwaysRelevant = True; // fix
		return true;
	}
	return false;
}

simulated function Deactivate()
{
	local Pawn pawn;

	bActive = false;
	TargetPawn = None;

	// reset bAlwaysRelevant
	if (Level.Role == ROLE_Authority && Level.PawnList != None)
	{
		for (pawn = Level.PawnList; pawn != None; pawn = pawn.NextPawn)
		{
			if (canBeTarget(self, pawn))
				pawn.bAlwaysRelevant = pawn.default.bAlwaysRelevant;
		}
	}
}

event TravelPreAccept()
{
	Super.TravelPreAccept();

	Deactivate();
}

function Destroyed()
{
	Super.Destroyed();
	
	Deactivate();
}

function SelectTarget()
{
	local int CurrentPlayerIndex;

	if (Owner == None)
		return;
	
	BuildPlayersList();

	CurrentPlayerIndex = -1;
	if (TargetPawn != None)
		CurrentPlayerIndex = FindPlayerIndex(TargetPawn);

	if ((CurrentPlayerIndex + 1)  >= NumPlayers)
	{
		Deactivate();
		return;
	}
	
	TargetPawn = Players[(CurrentPlayerIndex + 1) % NumPlayers];

	if (TargetPawn != None)
	{
		Owner.PlaySound(SuccessSound, SLOT_Misc, 4 * Pawn(Owner).VolumeMultiplier);
		//Pawn(Owner).ChatMessage(None, FormatString(Selected, "%p", TargetPawn.PlayerReplicationInfo.PlayerName), 'Translocator');
	}
	else
	{
		Owner.PlaySound(FailedSound, SLOT_Misc, 4 * Pawn(Owner).VolumeMultiplier);
	}
}

function SpawnEffect(vector Start, vector Dest)
{
	local actor e;

	//e = Spawn(class'TranslocOutEffect',,,start, Owner.Rotation);
	//e.Mesh = Owner.Mesh;
	//e.Animframe = Owner.Animframe;
	//e.Animsequence = Owner.Animsequence;
	//e.Velocity = 900 * Normal(Dest - Start);
}

function bool Translocate()
{
	local Vector X, Y, Z;
	local Vector Start, Dest;
	local string Deny;
	local Inventory Inv;
	local bool bWarping;

	if (Owner == None)
		return false;
	
	if (TargetPawn == None || TargetPawn.Health < 0)
	{
		Owner.PlaySound(FailedSound, SLOT_Misc, 4 * Pawn(Owner).VolumeMultiplier);
		return false;
	}
	
	if (DisableUse > 0)
	{
		Deny = FormatString(StillDisabled, "%d", string(DisableUse));
		Pawn(Owner).ChatMessage(None, TranslocateFailed @ FormatString(Deny, "%p", TargetPawn.PlayerReplicationInfo.PlayerName), 'Translocator');
		Owner.PlaySound(FailedSound, SLOT_Misc, 4 * Pawn(Owner).VolumeMultiplier);
		return false;
	}

	GetAxes(TargetPawn.Rotation.Yaw * rot(0, 1, 0), X, Y, Z); // get rotation only over Z axis
	Dest = TargetPawn.Location + 
		TargetPawn.CollisionHeight * vect(0, 0, 2.5) - // make location above target
		TargetPawn.CollisionRadius * X; // and little at back

	if ((TargetPawn.Base != None && TargetPawn.Base.Velocity.Z > 0) || TargetPawn.Velocity.Z > 0)
	{
		Pawn(Owner).ChatMessage(None, TranslocateFailed @ FormatString(PlayerMovesUp, "%p", TargetPawn.PlayerReplicationInfo.PlayerName), 'Translocator');
		Owner.PlaySound(FailedSound, SLOT_Misc, 4 * Pawn(Owner).VolumeMultiplier);
		return false;
	}

	Start = Owner.Location;
	bWarping = Pawn(Owner).bWarping;
	Pawn(Owner).bWarping = true; // prevent telefrag
	if (!TargetPawn.FastTrace(Dest) || !Owner.SetLocation(Dest))
	{			
		if (!((TargetPawn.Velocity dot X) < 0 || (TargetPawn.Base != None && (TargetPawn.Base.Velocity dot X) < 0)))
		{
			// second attempt at back
			Dest = TargetPawn.Location - 2.5 * TargetPawn.CollisionRadius * X; // at back
			if (!TargetPawn.FastTrace(Dest) || !Owner.SetLocation(Dest))
			{
				Pawn(Owner).ChatMessage(None, TranslocateFailed @ FormatString(NoSpaceAbove, "%p", TargetPawn.PlayerReplicationInfo.PlayerName), 'Translocator');
				Owner.PlaySound(FailedSound, SLOT_Misc, 4 * Pawn(Owner).VolumeMultiplier);
				return false;
			}
		}
	}

	if (Owner == None) // instant kill at destination point
		return false;
	if (!Owner.Region.Zone.bWaterZone && Owner.Physics == PHYS_Walking)
		Owner.SetPhysics(PHYS_Falling);
	// set rotation same as target for Z axis, for allow press back for avoid team fire
	Pawn(Owner).ClientSetRotation(TargetPawn.Rotation.Yaw * rot(0, 1, 0));
	Owner.Velocity.X = 0;
	Owner.Velocity.Y = 0;
	Level.Game.PlayTeleportEffect(Owner, true, true);
	SpawnEffect(Start, Dest);
	TargetPawn = None;

	Pawn(Owner).bWarping = bWarping; // restore original value

	DisableUse = DisableUseTime;

	return true;
}

simulated function PostRender(Canvas C)
{
	local Actor OldViewTarget;
	local int i, CurrentSelection, offX, offY, tiles, tileX, tileY, x, y, size, visible, start, end, skip;
	local string label;
	local WindowConsole wconsole;
	local float Scale;
	
	if (!bActive)
		return;
	
	C.Font = C.MedFont;
	C.Style = ERenderStyle.STY_Normal;

	Scale = 1.0;
	wconsole = WindowConsole(PlayerPawn(Owner).Player.Console);

	if (wconsole != None)
		Scale = wconsole.Root.ScaleY;

	offY = 63.5*Scale;

	BuildPlayersList();

	tiles = 3;
	//tiles = 2;
	//if (NumPlayers > 3) tiles = 3;
	if (NumPlayers > 8) tiles = 4;
	tileX = c.ClipX - 2*offX;
	tileY = c.ClipY - 2*offY;
	tiles = Max(1, Min(Min(tiles, tileX/320), tileY/196)); // 320*196 at least
	tileX = tileX/tiles;
	tileY = tileY/tiles;

	CurrentSelection = FindPlayerIndex(TargetPawn);
	
	//skip = 1;
	//if (tiles == 1) skip = 0;
	
	visible = tiles*tiles - skip;
	start = Max(Min(CurrentSelection, NumPlayers - visible), 0);
	end = Min(start + visible, NumPlayers);

	if (PlayerPawn(Owner) == C.ViewPort.Actor)
	{
		OldViewTarget = PlayerPawn(Owner).ViewTarget;
		PlayerPawn(Owner).ViewTarget = self; // for view self
	}

	size = 5*Scale;

	for (i = start; i < end; i++) {
		x = offX + ((i - start + skip) % tiles)*tileX;
		y = offY + ((i - start + skip)/tiles)*tileY;
		C.DrawPortal(x, y, tileX, tileY, Players[i], Players[i].Location - 100*(vect(1,0,0) >> Players[i].Rotation), Players[i].Rotation);
		if (CurrentSelection == i)
		{
			C.DrawColor.R = 255; C.DrawColor.G = 0; C.DrawColor.B = 0;
			C.SetPos(x, y);
			C.DrawRect(Texture'RedPixel', TileX, size);
			C.SetPos(x, y + TileY - size);
			C.DrawRect(Texture'RedPixel', TileX, size);
			C.SetPos(x, y);
			C.DrawRect(Texture'RedPixel', size, TileY - size);
			C.SetPos(x + TileX - size, y);
			C.DrawRect(Texture'RedPixel', size, TileY - size);
		}
		C.SetPos(x + 10*Scale, y + size);
		C.DrawColor.R = 255; C.DrawColor.G = 255; C.DrawColor.B = 0;
		label = Players[i].PlayerReplicationInfo.PlayerName @ "("$int(Players[i].Health) @ "Health)";
		/*
		if (Players[i].Weapon != None)
		{
			if (Players[i].Weapon.ItemName != "")
				label = label @ Players[i].Weapon.ItemName;
			else
				label = label @ Players[i].Weapon.class.name;
		}
		*/
		C.DrawText(label);
	}

	if (PlayerPawn(Owner) == C.ViewPort.Actor)
		PlayerPawn(Owner).ViewTarget = OldViewTarget; // restore
}

simulated function int FindPlayerIndex(Pawn Player)
{
	local int PlayerIndex, i;

	PlayerIndex = -1;
	for (i = 0; i < NumPlayers; i++)
	{
		if (Players[i] == Player)
		{
			PlayerIndex = i;
			break;
		}
	}

	return PlayerIndex;
}

simulated function BuildPlayersList()
{
	local Pawn pawn;
	
	NumPlayers = 0;
	if (Level.Role == ROLE_Authority && Level.PawnList != None)
	{
		for (pawn = Level.PawnList; pawn != None; pawn = pawn.NextPawn)
		{
			if (canBeTarget(self, pawn))
				Players[NumPlayers++] = pawn;
		}
	} else
	{
		forEach AllActors(class'Pawn', pawn)
		{
			if (canBeTarget(self, pawn))
				Players[NumPlayers++] = pawn;
		}
	}
	
	if (NumPlayers > 0)
		SortPlayers(self, 0, NumPlayers - 1);
}

// http://www.unreal.ut-files.com/3DEditing/Tutorials/unrealwiki-offline/quicksort.html
static Function SortPlayers(CoopTranslocator trans, Int Low, Int High) { //Sortage
//  low is the lower index, high is the upper index
//  of the region of array a that is to be sorted
	local Int i,j;
	local String x;
	Local Pawn tmp;

	i = Low;
	j = High;
	x = trans.Players[(Low+High)/2].PlayerReplicationInfo.PlayerName;

	do { //  partition
		while (trans.Players[i].PlayerReplicationInfo.PlayerName < x) i += 1; 
		while (trans.Players[j].PlayerReplicationInfo.PlayerName > x) j -= 1;
		if (i <= j) {
			tmp = trans.Players[j];
			trans.Players[j] = trans.Players[i];
			trans.Players[i] = tmp;
			
			i += 1; 
			j -= 1;
		}
	} until (i > j);

	//  recursion
	if (low < j) SortPlayers(trans, low, j);
	if (i < high) SortPlayers(trans, i, high);
}

defaultproperties
{
	InventoryGroup=119
	PickupMessage="You gained a Coop Translocator"
	ItemName="Coop Translocator"
	PickupViewMesh=SkelMesh'Aeons.Meshes.arcaneWhorls_m'
	PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_WizEyePU01'
	CollisionRadius=21
	CollisionHeight=16
	bGroundMesh=False
	bCanTranslocate=True
	Selected="Translocate target is %p."
	TranslocateFailed="Translocate failed:"
	PlayerMovesUp="%p goes up."
	NoSpaceAbove="not enough space above %p."
	DisableUseTime=15
	StillDisabled="Your CoopTranslocator will be usable in %d seconds."
	Ready="Your CoopTranslocator is ready to use."
	SuccessSound=Sound'Wpn_Spl_Inv.Inventory.I_WizEyeLook01'
	FailedSound=Sound'Wpn_Spl_Inv.Inventory.I_WizEyePop01'
}