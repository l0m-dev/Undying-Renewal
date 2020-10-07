//=============================================================================
// 
//=============================================================================
class Visible extends Actor 
	abstract
	native
	nativereplication;


//-----------------------------------------------------------------------------
// Physics.

var rotator					Facing;			// Facing rotator (buffered rotation).
var vector					Acceleration;	// Acceleration.

// Physics properties.
var(Movement) float       Buoyancy;        // Water buoyancy.

//-----------------------------------------------------------------------------
// Sound.

//var(Impact) byte	ImpactID;
var(Impact) sound	ImpactSound[3];		// Possible Impact sounds for this actor
var(Impact) float	ImpactVolume;
var(Impact) float	ImpactVolumeVar;
var(Impact) float	ImpactPitch;
var(Impact) float	ImpactPitchVar;

var(Sounds) class<ImpactSoundSet> ImpactSoundClass;

var	transient byte	AnimStream[64];

//-----------------------------------------------------------------------------
// Network replication.

replication
{
	// Physics.
	unreliable if( bSimFall || (RemoteRole==ROLE_SimulatedProxy && bNetInitial && !bSimulatedPawn) )
		Acceleration;

	// Animation. 
	reliable if( DrawType==DT_Mesh && ((RemoteRole<=ROLE_AutonomousProxy && (/*!bNetOwner ||*/ !bClientAnim)) || bDemoRecording) )
		AnimStream;

}

defaultproperties
{
}
