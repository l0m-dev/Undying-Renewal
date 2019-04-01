//=============================================================================
// StealthModifier.
//=============================================================================
class StealthModifier expands PlayerModifier;

var float AudibleStealth;
var float VisibleStealth;
var float MovementStealth;
var float TotalStealth;
var float CurrentAudible;

function SpikeAudible(float f)
{
	// AeonsPlayer(Owner).ClientMessage("Spiking audible stealth by "$f);
	CurrentAudible = FClamp((CurrentAudible + f), 0, 3);
}

auto State Idle
{
	function BeginState()
	{
		SetTimer(0.125, true);
	}

	function Tick(float deltaTime)
	{
		local vector HitLocation, HitNormal;
		local Texture HitTexture;
		local int HitJoint, flags;
		local Inventory Inv;
		local color c;
		local float Luminence;

/*
		HitTexture = TraceTexture(Owner.Location, Owner.Location + vect(0,0,-512), Flags);
		
		if (HitTexture != none)
		{
			Owner.Lighting[0].TextureMask = -1;
			Owner.Lighting[0].Diffuse = HitTexture.MipZero;
			Owner.Opacity = ((int(HitTexture.MipZero.r) + int(HitTexture.MipZero.g) + int(HitTexture.MipZero.b)) * 0.3333) / 255.0;
		}
	*/	
		if ( (Owner != None) && (PlayerPawn(Owner) != None) ) 
		{
			if ( PlayerPawn(Owner).Weapon == None )
			{
				c.r = 255;
				c.g = 255;
				c.b = 255;
				c.a = 255;
			} else
				c = PlayerPawn(Owner).Weapon.IncidentLight;

			Luminence = ((int(c.r) + int(c.g) + int(c.b)) * 0.33333) / 255.0;
	
			Luminence = FClamp(Luminence, 0.3333, 1.0);
	
			MovementStealth = VSize(PlayerPawn(Owner).Velocity) * 0.0025 ;
			AudibleStealth = AeonsPlayer(Owner).VolumeMultiplier * CurrentAudible;
			VisibleStealth = AeonsPlayer(Owner).Opacity * Luminence;
	
			
			// Inv = PlayerPawn(Owner).Inventory.FindItemInGroup(105);
	
			if ( AeonsPlayer(Owner).bLanternOn )
				VisibleStealth += 0.5;

			TotalStealth = (AudibleStealth + VisibleStealth + MovementStealth) * 0.33333333;

		} 
		else 
		{
			Destroy();
		}
	}

	function Timer()
	{
		if ( CurrentAudible > 0 )
		{
			CurrentAudible *= 0.875;
			// CurrentAudible -= 0.033333;
		}
	
		CurrentAudible = FClamp(CurrentAudible, 0, 1000);
	}
	

	Begin:
		
}

defaultproperties
{
     bTimedTick=True
     MinTickTime=0.25
}
