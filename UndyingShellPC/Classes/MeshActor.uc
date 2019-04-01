class MeshActor extends Info;

var vector ViewOffset;
var ShellWindow NotifyClient;

function AnimEnd()
{
	NotifyClient.AnimEnd(Self);
}

defaultproperties
{
     ViewOffset=(X=75,Y=9,Z=3)
     bHidden=False
     bOnlyOwnerSee=True
     bAlwaysTick=True
     Physics=PHYS_Rotating
     RemoteRole=ROLE_None
     DrawType=DT_Mesh
     DrawScale=0.1
     AmbientGlow=255
     bUnlit=True
     CollisionRadius=0
     CollisionHeight=0
}
