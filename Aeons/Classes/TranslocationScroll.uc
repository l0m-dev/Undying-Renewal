//=============================================================================
// TranslocationScroll.
//=============================================================================
class TranslocationScroll expands Items;

//#exec MESH IMPORT MESH=translocation_m SKELFILE=TransScroll.ngf
//#exec TEXTURE IMPORT NAME=TransScroll_Icon FILE=TransScroll_Icon.PCX GROUP=Icons FLAGS=2

var() float transLocateRange;

function activate()
{
	local int HitJoint;
	local vector startTrace, endTrace, HitLocation, HitNormal, viewDir;
	local vector myLocation, yourLocation, tempLocation;
	local actor Other;
	
	viewDir = Vector(PlayerPawn(Owner).ViewRotation);
	startTrace = PlayerPawn(Owner).location + (ViewDir * 32);
	endTrace = startTrace + (ViewDir * transLocateRange);
	Other = Trace(HitLocation,HitNormal,HitJoint,endTrace,startTrace,true,true);
	if ( Other != none )
	{
		if ( Other.isA('Pawn') )
		{
			// Translocate
			MyLocation = PlayerPawn(Owner).Location;
			YourLocation = Pawn(Other).Location;
			
			tempLocation = (MyLocation + YourLocation) * 0.5;
			Pawn(Other).SetLocation(tempLocation);
			PlayerPawn(Owner).SetLocation(YourLocation);
			Pawn(Other).SetLocation(myLocation);
			numcopies--;
		}
	}
	super.Activate();
	if ( numCopies < 0 )
	{
		SelectNext();
		Pawn(Owner).DeleteInventory(self);
	}
}

// lifted from WoT - need to optimize and rework
static function bool ActorFits( Actor MovingActor, vector DesiredLocation, float ActorFitsRadius, optional bool bFindCloseLoc, optional out vector validLocation )
{
	local bool bFits;
	local float RadiusOffset, HeightOffset, radiusDifference, HeightDifference;
	local vector Offset;

	local Actor iActor, nonCollidingActor;

	//if( MovingActor == None )
	//	return false;

	bFits = true;

	// Check all blocking actors for overlapping collision cylinders.
	if( MovingActor.bBlockActors || MovingActor.bBlockPlayers )
	{
		foreach MovingActor.RadiusActors(class'Actor', iActor, ActorFitsRadius, DesiredLocation )
			if( (iActor != MovingActor) && !iActor.IsA('Mover') )
				if( (iActor.bBlockActors) || (iActor.bBlockPlayers) )
				{
					Offset = iActor.Location - DesiredLocation;
					HeightOffset = Offset.z;
					Offset.z = 0;
					RadiusOffset = VSize(Offset);

					
					radiusDifference = (iActor.CollisionRadius + MovingActor.CollisionRadius) - RadiusOffset;
					heightDifference = (iActor.CollisionHeight + MovingActor.CollisionHeight) - HeightOffset;
					if ( (radiusDifference > 0) && (heightDifference > 0) )
					{
						bFits = false;
						break;
					} else {
						if (bFindCloseLoc)
							if ( (radiusDifference > iActor.CollisionRadius) && (heightDifference > iActor.CollisionHeight) ) {
								ValidLocation = MovingActor.Location + (Normal(MovingActor.Location - iActor.Location) * MovingActor.CollisionRadius);
								bFits = true;
							}
					}
				}
	}
	return bFits;
}

defaultproperties
{
     transLocateRange=2048
     ItemType=ITEM_Inventory
     InventoryGroup=108
     bActivatable=True
     bDisplayableInv=True
     PickupMessage="You gained a Translocation Scroll"
     ItemName="TranslocationScroll"
     PickupViewMesh=SkelMesh'Aeons.Meshes.translocation_m'
     PickupSound=Sound'Wpn_Spl_Inv.Inventory.I_ScrollPU01'
     Icon=Texture'Aeons.Icons.TransScroll_Icon'
     Mesh=SkelMesh'Aeons.Meshes.translocation_m'
}
