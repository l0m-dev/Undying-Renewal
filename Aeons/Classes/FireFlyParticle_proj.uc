//=============================================================================
// FireFlyParticle_proj.
//=============================================================================
class FireFlyParticle_proj expands SpellProjectile;

var ParticleFX pFX;

simulated function PreBeginPlay()
{
	pFX = spawn(class 'FireFlyTrailFX',,,Location);
	pFX.setBase(self);

	Velocity = VRand() * Projectile(Owner).speed * 2;
}

simulated function SetLifeSpan(float f)
{
	log("Setting the Timer to "$f, 'Misc');
	SetTimer(f, false);
}

simulated function Timer()
{
	Destroy();
}

simulated function Destroyed()
{
	if ( pFX != None )
		pFX.Shutdown();
}

simulated function Tick(float deltaTime)
{
	local vector cDir, seekDir, FinalDir;
	
	if (Owner == none)
	{
		Log("FireFlyParticle_Proj: Tick: OWner = none , Destroying");
		Destroy();
		return;
	} 
	else if (Owner.IsA('Pawn')) 
	{
		if (Pawn(Owner).Health <= 0)
		{
			Destroy();
			return;
		}
	}

	cDir = normal(Velocity);
	
	seekDir = Normal(Owner.Location - Location);
	
	finalDir = Normal((cDir * 0.25) + (seekDir * 0.75) + (VRand() * 0.5));
	
	Velocity = finalDir * FClamp(VSize(Owner.Velocity) * 2, 64, 10000);

}

//----------------------------------------------------------------------------

simulated function SetRoll(vector NewVelocity) 
{
	local rotator newRot;	

	newRot = rotator(NewVelocity);	
	SetRotation(newRot);	
}
//----------------------------------------------------------------------------

simulated function HitWall (vector HitNormal, actor Wall, byte TextureID)
{
	// Velocity -= 2 * ( Velocity dot HitNormal) * HitNormal;  
	Velocity -= 2 * ( Velocity dot HitNormal) * HitNormal;  
	SetRoll(Velocity);

}

//----------------------------------------------------------------------------

defaultproperties
{
     Speed=300
     bMagical=True
     bCollideActors=False
}
