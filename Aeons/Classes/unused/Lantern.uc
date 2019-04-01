//=============================================================================
// Lantern.
//=============================================================================
class Lantern expands Items;

#exec TEXTURE IMPORT NAME=Torch_Icon FILE=Torch_Icon.PCX GROUP=Icons FLAGS=2

// Sounds
#exec AUDIO IMPORT  FILE="I_LanternFlicker01.WAV" NAME="I_LanternFlicker01" GROUP="Inventory"
#exec AUDIO IMPORT  FILE="I_LanternOn01.WAV" NAME="I_LanternOn01" GROUP="Inventory"
#exec AUDIO IMPORT  FILE="I_LanternOff01.WAV" NAME="I_LanternOff01" GROUP="Inventory"

var() class<Light> LanternSpot;
var() class<Light> LanternLocalLight;
var Light mainLight, PlayerLight;
var() Sound FlickerSound;

function Activate()
{
	gotoState('Activated');
}

function bool AngleCheck(vector Loc, vector A, Actor Other, float angleThreshold)
{
	local vector vA, vB;
	local float angle;
	local float pi;

	pi = 3.1415926535897932384626433832795;

	angleThreshold *= (pi / 180.0);
	vA = Normal(A - Loc);
	vB = Vector(Pawn(Other).ViewRotation);
	angle = vA dot vB;

	return ( cos(angleThreshold * 0.5) < angle );
}


state Activated
{
	function Tick(float deltaTime)
	{
		local vector eyeheight;
		
		if (Owner.Region.Zone.bWaterZone)
			GotoState('Deactivated');

		eyeheight.z = Pawn(Owner).Eyeheight;
		MainLight.setRotation(Pawn(Owner).ViewRotation);
		MainLight.setLocation((Pawn(Owner).Location + eyeHeight) + Vector(Pawn(Owner).ViewRotation) * 48);
		PlayerLight.setLocation( Pawn(Owner).Location );
	}


	function Timer()
	{
		local ScriptedPawn SP;
		local vector EyeHeight, EyeLoc;
		
		EyeHeight.z = Pawn(Owner).EyeHeight;
		EyeLoc = Pawn(Owner).Location + eyeHeight;
		
		if (FRand() < 0.025)
			PlaySound(FlickerSound);

		if (MainLight != none)
		{
			ForEach RadiusActors(class 'ScriptedPawn', SP, Square(MainLight.LightRadius), Owner.Location)
			{
				// make sure we have line of sight to the ScriptedPawn;
				if ( FastTrace(sp.Location, EyeLoc) )
				{
					if (!SP.bScryeOnly)
					{
						// Test the local lantern light
						if (PlayerLight != none)
							if ( vSize(EyeLoc - SP.Location) < Square(PlayerLight.LightRadius) )
								// SP is within the local player light radius - bump him
								SP.LanternBump(self);	//SP.LanternBump(PlayerPawn(Owner))
						
						// Test the [cone] lantern light
						if ( AngleCheck(EyeLoc, SP.Location, Owner, MainLight.LightCone) )
							SP.LanternBump(self);	//SP.LanternBump(PlayerPawn(Owner))
					}
				}
			}
		}
	}

	function Activate()
	{
		local vector spawnLocation, eyeHeight;

		if ( Pawn(Owner) != None )
		{
			if ((mainLight == none) && !Owner.Region.Zone.bWaterZone)
			{
				Owner.PlaySound(ActivateSound,, 0.5);

				setTimer(0.25,true);
				bActive = true;
				AeonsPlayer(Owner).bLanternOn = true;

				eyeheight.z = Pawn(Owner).Eyeheight;
				spawnLocation = (Pawn(Owner).Location + eyeHeight) + Vector(Pawn(Owner).ViewRotation) * 20;
				mainLight = spawn(LanternSpot,Pawn(Owner),,SpawnLocation, Pawn(Owner).ViewRotation);
				PlayerLight = spawn(LanternLocalLight,Pawn(Owner),,SpawnLocation, Pawn(Owner).ViewRotation);
			} else {
				gotoState('Deactivated');
			}
		}
	}	
	
	Begin:
		Activate();
}

state Deactivated
{
	ignores Timer;
	
	function Activate()
	{
		gotoState('Activated');
	}

	Begin:
		Owner.PlaySound(DeactivateSound,, 0.5);
		setTimer(0,false);
		bActive = false;
		AeonsPlayer(Owner).bLanternOn = false;
		mainLight.Destroy();
		PlayerLight.Destroy();
		mainLight = none;
		PlayerLight = none;
}

defaultproperties
{
     LanternSpot=Class'Aeons.LanternSpotlight'
     LanternLocalLight=Class'Aeons.LanternLight'
     FlickerSound=Sound'Aeons.Inventory.I_LanternFlicker01'
     bCanActivate=True
     ItemType=ITEM_Inventory
     InventoryGroup=105
     bActivatable=True
     bDisplayableInv=True
     ItemName="Lantern"
     ActivateSound=Sound'Aeons.Inventory.I_LanternOn01'
     DeactivateSound=Sound'Aeons.Inventory.I_LanternOff01'
     Icon=Texture'Aeons.Icons.Lantern_Icon'
     DrawType=DT_Sprite
     Texture=Texture'Engine.S_Light'
     LightBrightness=111
     LightHue=53
     LightSaturation=103
     LightRadius=16
     LightRadiusInner=14
}
