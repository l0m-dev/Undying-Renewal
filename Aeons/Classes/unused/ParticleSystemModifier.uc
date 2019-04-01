//=============================================================================
// ParticleSystemModifier.
//=============================================================================
class ParticleSystemModifier expands Info;

#exec TEXTURE IMPORT FILE=ParticleSysMod.pcx GROUP=System Mips=Off

// Wish List:
// Change time - like trigger lights

var ParticleFX PFX;

var() float Speed;
var() bool bSpeed;

var() float ParticlesPerSec;
var() bool bParticlesPerSec;

var() color ColorStart;
var() bool bColorStart;

var() color ColorEnd;
var() bool bColorEnd;

var() float SizeWidth;
var() bool bSizeWidth;

var() float SizeLength;
var() bool bSizeLength;

var() float SizeEndScale;
var() bool bSizeEndScale;

var() float Lifetime;
var() bool bLifetime;

var() float AlphaStart;
var() bool bAlphaStart;

var() float AlphaEnd;
var() bool bAlphaEnd;

var() float Chaos;
var() bool bChaos;

var() float Elasticity;
var() bool bElasticity;

var() vector Gravity;
var() bool bGravity;

var() float AngularSpreadWidth;
var() bool bAngularSpreadWidth;

var() float AngularSpreadHeight;
var() bool bAngularSpreadHeight;

function Trigger(Actor Other, Pawn Instigator)
{
	local int i;

	ForEach AllActors(class 'ParticleFX', PFX, Event)
	{

		if ( bSpeed ) PFX.Speed.Base = Speed;
		if ( bParticlesPerSec )	PFX.ParticlesPerSec.Base = ParticlesPerSec;
		if ( bColorStart ) PFX.ColorStart.Base = ColorStart;
		if ( bColorEnd ) PFX.ColorEnd.Base = ColorEnd;
		if ( bSizeWidth ) PFX.SizeWidth.Base = SizeWidth;
		if ( bSizeLength ) PFX.SizeLength.Base = SizeLength;
		if ( bSizeEndScale ) PFX.SizeEndScale.Base = SizeEndScale;
		if ( bLifetime ) PFX.Lifetime.Base = Lifetime;
		if ( bAlphaStart ) PFX.AlphaStart.Base = AlphaStart;
		if ( bAlphaEnd ) PFX.AlphaEnd.Base = AlphaEnd;
		if ( bChaos ) PFX.Chaos = Chaos;
		if ( bElasticity ) PFX.Elasticity = Elasticity;
		if ( bGravity ) PFX.Gravity = Gravity;
		if ( bAngularSpreadWidth ) PFX.AngularSpreadWidth.Base = AngularSpreadWidth;
		if ( bAngularSpreadHeight ) PFX.AngularSpreadHeight.Base = AngularSpreadHeight;

	}
}

defaultproperties
{
     Texture=Texture'Aeons.System.ParticleSysMod'
}
