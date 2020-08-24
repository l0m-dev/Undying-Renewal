//=============================================================================
// BulletScriptFX. 
//=============================================================================
class BulletScriptFX expands ScriptedFX;

var float scaleFactor;
var float trailLen;
var float pTrailLen;		// parametric trail length
var vector inVec, outVec;
var color trailColor;
var particleParams p;
var color c;

simulated function genEffect()
{
	local int i;
	
	// log("TrailLen"$TrailLen);
	inVec = Normal(inVec);
	outVec = Normal(outVec);
	//spawn(class 'LightningPoint',,,(inVec * -trailLen));
	//spawn(class 'LightningPoint',,,(outVec * trailLen));
	c.r = 255;
	c.g = 255;
	c.b = 255;

	addParticle(1,location+ (inVec * -trailLen));

		getParticleParams(1,p);
		p.Alpha = 0;
		p.width = 0.1 * scaleFactor;
		setParticleParams(1,p);
		
	addParticle(2,location + (inVec * -trailLen * 0.5));

		getParticleParams(2,p);
		p.Alpha = 0.5;
		p.width = 1 * scaleFactor;
		setParticleParams(2,p);

	addParticle(3,location);

		getParticleParams(3,p);
		p.Alpha = 0.75;
		p.width = 4 * scaleFactor;
		setParticleParams(3,p);

	addParticle(4,location + (outVec * trailLen * 0.5));

		getParticleParams(4,p);
		p.Alpha = 0.5;
		p.width = 1 * scaleFactor;
		setParticleParams(4,p);


	addParticle(5,location + (outVec * trailLen));

		getParticleParams(5,p);
		p.Alpha = 0;
		p.width = 0.1 * scaleFactor;
		setParticleParams(5,p);

	
	bUpdate = true;

	for (i=1; i<6; i++)
	{
		RecomputeDeltas(i);
	}
}

defaultproperties
{
     Lifetime=(Base=0.5)
     ColorStart=(Base=(R=255,G=255,B=255))
     ColorEnd=(Base=(R=255,G=255,B=255))
     AlphaEnd=(Base=0)
     SizeEndScale=(Base=0)
     bUpdate=False
     Textures(0)=Texture'Aeons.Particles.SoftShaft01'
     LifeSpan=3
}
