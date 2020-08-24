//=============================================================================
// Shield3rdPerson.
//=============================================================================
class Shield3rdPerson expands PlayerEffects;

//#exec MESH IMPORT MESH=Shield3rd_m SKELFILE=Shield3rd_m.ngf

simulated function PreBeginPlay()
{
	DrawScale = 0;
	super.PreBeginPlay();
}

simulated function Tick(float deltaTime)
{
	setRotation(Pawn(Owner).Rotation);

	if (DrawScale < default.DrawScale)
		drawScale += 0.1;
	else
		gotoState('Holding');
}


state Holding
{
	simulated function Tick(float deltaTime)
	{
		setRotation(Pawn(Owner).Rotation);

		if ( Pawn(Owner).Health <= 0 ) 
			Destroy();
	}

//	Begin:
		
}

defaultproperties
{
     bOwnerNoSee=True
     DrawType=DT_Mesh
     Style=STY_Translucent
     Mesh=SkelMesh'Aeons.Meshes.Shield3rd_m'
     DrawScale=1.35
}
