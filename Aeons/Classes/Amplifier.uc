//=============================================================================
// Amplifier.
//=============================================================================
class Amplifier expands Items;

//#exec MESH IMPORT MESH=Amplifier_m SKELFILE=Amplifier.ngf
//#exec AUDIO IMPORT  FILE="E_Spl_AmpOn01.WAV" NAME="E_Spl_AmpOn01" GROUP="Inventory"
//#exec AUDIO IMPORT  FILE="E_Spl_AmpOff01.WAV" NAME="E_Spl_AmpOff01" GROUP="Inventory"

//=============================================================================
var() sound AmplificationOn;
var() sound AmplificationOff;
var() sound ApplyAmplification;
var() sound DenyAmplification;
var ParticleFX pfx;
var float inc;
var vector InitialLocation;
var PlayerPawn PlayerPawnOwner;
var string str;
var() localized string AmpString;
//=============================================================================

function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	InitialLocation = Location;
	if ( Owner == none )
	{
		pfx = spawn(class 'AmplifierParticleFX',self,,Location);
		pfx.SetBase(self);
	}
	SetPhysics(PHYS_None);
	bCollideWorld = true;
}

//=============================================================================
function Destroyed()
{
	LogStack('Misc');
}

//=============================================================================
function Landed(vector HitNormal)
{

}

//=============================================================================
function PickupFunction(Pawn Other)
{
	if ( pfx != none )
		pfx.bShuttingDown = true;
	super.PickupFunction(Other);
}

//=============================================================================
function Tick(float DeltaTime)
{
	local vector Loc;
	local rotator r;
	
	if (Owner != none)
		AmbientSound = none;

	if ( GetStateName() == 'Pickup' )
	{
		if (Physics == PHYS_None)
		{
			r = rotation;
			r.yaw += (2048 * deltaTime);
			
			SetRotation(r);

			inc += DeltaTime;
			
			Loc.z = cos(inc) * 4;

			SetLocation(InitialLocation + Loc);
		} else {
			InitialLocation = Location;
		}
	}
}

//=============================================================================
function Activate()
{
	gotoState('Activated');
}

//=============================================================================
state Activated
{
	function Activate()
	{
		local bool bSucess;

		PlayerPawnOwner = PlayerPawn(Owner);
		if ( PlayerPawnOwner != None )
		{
			if ( PlayerPawnOwner.AttSpell != none )
			{
				if (PlayerPawnOwner.AttSpell.CastingLevel < 4)
				{
					Owner.PlaySound(ActivateSound);

					PlayerPawnOwner.AttSpell.CastingLevel ++;
					numcopies--;
					bSucess	= true;
					GotoState('Holding');
				}
			}
		}

		if ( !bSucess )
		{
			Super.Activate();
			if ( numCopies < 0 )
			{
				SelectNext();
				Pawn(Owner).DeleteInventory(self);
			}
			gotoState('Deactivated');
		}
	}

	Begin:
		Activate();
}

//=============================================================================
state Holding
{
	function Activate(){}
	
	function RenderOverlays(Canvas Canvas)
	{
		Canvas.SetPos(Canvas.ClipX * 0.35, Canvas.ClipY * 0.75 );
		Canvas.Font = Canvas.MedFont;
		Canvas.DrawText( str, false );
	}

	Begin:
		str = (""$PlayerPawnOwner.AttSpell.ItemName$" "$AmpString);
		AeonsPlayer(Owner).ScreenMessage(str, 3.0);
		if ( numCopies < 0 )
		{
			SelectNext();
			Pawn(Owner).DeleteInventory(self);
		}
		gotoState('Deactivated');
}

//=============================================================================
state Deactivated
{

	Begin:
		bActive = false;
}

//=============================================================================
//=============================================================================

defaultproperties
{
     AmpString="has been amplified"
     bCanHaveMultipleCopies=True
     bCanActivate=True
     ItemType=ITEM_Inventory
     InventoryGroup=103
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You gained an Amplifier"
     ItemName="Amplifier"
     PickupViewMesh=SkelMesh'Aeons.Meshes.Amplifier_m'
     PickupViewScale=0.25
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_AmplifierPU01'
     ActivateSound=Sound'Wpn_Spl_Inv.Inventory.I_AmplifierUse01'
     DeactivateSound=Sound'Aeons.Inventory.E_Spl_AmpOff01'
     Icon=Texture'Aeons.Icons.Amplifier_Icon'
     AmbientSound=Sound'Wpn_Spl_Inv.Inventory.I_AmplifierLp01'
     Style=STY_Translucent
     Texture=Texture'Aeons.Particles.Star8_pfx'
     Skin=Texture'Aeons.Particles.Star8_pfx'
     Mesh=SkelMesh'Aeons.Meshes.Amplifier_m'
     ShadowRange=64
     DrawScale=0.25
     SoundVolume=200
     CollisionRadius=8
     CollisionHeight=12
     bCollideWorld=True
     bCorona=True
}
