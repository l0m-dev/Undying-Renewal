//=============================================================================
// Decoration.
//=============================================================================
class Decoration extends Visible
	abstract
	native;

// If set, the pyrotechnic or explosion when item is damaged.
var() class<actor> EffectWhenDestroyed;
var() bool bPushable;
var() bool bOnlyTriggerable;
var bool bSplash;
var bool bBobbing;
var bool bWasCarried;
var() sound PushSound;
var const int	 numLandings; // Used by engine physics.
var() class<Pawn> SpawnCreature;
var() class<inventory> contents;
var() class<inventory> content2;
var() class<inventory> content3;
var() sound EndPushSound;
var bool bPushSoundPlaying;
var() sound DestroySound[3];
var int SoundID;

simulated function FollowHolder(Actor Other);

function Drop(vector newVel);

function Landed(vector HitNormall)
{
	local DamageInfo DInfo;
	if( bWasCarried && !SetLocation(Location) )
	{
		if( Instigator!=None && (VSize(Instigator.Location - Location) < CollisionRadius + Instigator.CollisionRadius) )
			SetLocation(Instigator.Location);
		
		DInfo = GetDamageInfo('landed');
		if (AcceptDamage(DInfo))
		{
			TakeDamage( Instigator, Location, Vect(0,0,1)*900,  DInfo);
		}
	}
	bWasCarried = false;
	bBobbing = false;
}

singular function ZoneChange( ZoneInfo NewZone )
{
	local float splashsize;
	local actor splash;
	local DamageInfo DInfo;

	if( NewZone.bWaterZone )
	{
		if( bSplash && !Region.Zone.bWaterZone && Mass<=Buoyancy 
			&& ((Abs(Velocity.Z) < 100) || (Mass == 0)) && (FRand() < 0.05) && !PlayerCanSeeMe() )
		{
			bSplash = false;
			SetPhysics(PHYS_None);
		}
		else if( !Region.Zone.bWaterZone && (Velocity.Z < -200) )
		{
			// Else play a splash.
			splashSize = FClamp(0.0001 * Mass * (250 - 0.5 * FMax(-600,Velocity.Z)), 1.0, 3.0 );
			if( NewZone.EntrySound != None )
				PlaySound(NewZone.EntrySound, SLOT_Interact, splashSize);
			if( NewZone.EntryActor != None )
			{
				splash = Spawn(NewZone.EntryActor); 
				if ( splash != None )
					splash.DrawScale = splashSize;
			}
		}
		bSplash = true;
	}
	else if( Region.Zone.bWaterZone && (Buoyancy > Mass) )
	{
		bBobbing = true;
		if( Buoyancy > 1.1 * Mass )
			Buoyancy = 0.95 * Buoyancy; // waterlog
		else if( Buoyancy > 1.03 * Mass )
			Buoyancy = 0.99 * Buoyancy;
	}

	if( NewZone.bPainZone && (NewZone.DamagePerSec > 0) )
	{
		DInfo.Damage = 100;
		DInfo.DamageType = NewZone.DamageType;
		if ( AcceptDamage(DInfo) )
			TakeDamage(None, location, vect(0,0,0), DInfo );
	}
}

function Trigger( actor Other, pawn EventInstigator )
{
	local DamageInfo DInfo;

	DInfo.Damage = 1000;
	DInfo.DamageType = 'exploded';
	Instigator = EventInstigator;
	if ( AcceptDamage(DInfo) )
		TakeDamage( Instigator, Location, Vect(0,0,1)*900, DInfo);
}

singular function BaseChange()
{
	local float decorMass, decorMass2;
	local DamageInfo DInfo;

	decormass= FMax(1, Mass);
	bBobbing = false;
	if( Velocity.Z < -500 )
	{
		DInfo.Damage = (1-Velocity.Z/30);
		DInfo.DamageType = 'crushed';
		if ( AcceptDamage(DInfo) )
			TakeDamage( Instigator,Location,vect(0,0,0) , DInfo);
	}

	if( (base == None) && (bPushable || IsA('Carcass')) && (Physics == PHYS_None) )
		SetPhysics(PHYS_Falling);
	else if( (Pawn(base) != None) && (Pawn(Base).CarriedDecoration != self) )
	{
		DInfo.Damage = (1-Velocity.Z/400)* decormass/Base.Mass;
		DInfo.DamageType = 'crushed';
		if ( Base.AcceptDamage(DInfo) )
			Base.TakeDamage( Instigator,Location,0.5 * Velocity , DInfo);
		Velocity.Z = 100;
		if (FRand() < 0.5)
			Velocity.X += 70;
		else
			Velocity.Y += 70;
		SetPhysics(PHYS_Falling);
	}
	else if( Decoration(Base)!=None && Velocity.Z<-500 )
	{
		decorMass2 = FMax(Decoration(Base).Mass, 1);
		DInfo.Damage = (1 - decorMass/decorMass2 * Velocity.Z/30);
		DInfo.DamageType = 'stomped';
		if ( Base.AcceptDamage(DInfo) )
			Base.TakeDamage( Instigator, Location, 0.2 * Velocity, DInfo);
		Velocity.Z = 100;
		if (FRand() < 0.5)
			Velocity.X += 70;
		else
			Velocity.Y += 70;
		SetPhysics(PHYS_Falling);
	}
	else
		instigator = None;
}

function Destroyed()
{
	local actor dropped, A;
	local class<actor> tempClass;
	local float decision;

	if( (Pawn(Base) != None) && (Pawn(Base).CarriedDecoration == self) )
		Pawn(Base).DropDecoration();
	if( (Contents!=None) && !Level.bStartup )
	{
		tempClass = Contents;
		if (Content2!=None && FRand()<0.3) tempClass = Content2;
		if (Content3!=None && FRand()<0.3) tempClass = Content3;
		dropped = Spawn(tempClass);
		dropped.RemoteRole = ROLE_DumbProxy;
		dropped.SetPhysics(PHYS_Falling);
		dropped.bCollideWorld = true;
		if ( inventory(dropped) != None )
			inventory(dropped).GotoState('Pickup', 'Dropped');
	}	
	
	if( (SpawnCreature!=None) && !Level.bStartup )
	{
		tempClass = SpawnCreature;
		dropped = Spawn(tempClass);
		dropped.RemoteRole = ROLE_DumbProxy;
		dropped.SetPhysics(PHYS_Falling);
		dropped.bCollideWorld = true;
	}	

	if( Event != '' )
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Self, None );

	if ( bPushSoundPlaying )
	{
		if (SoundID > 0)
		{
			StopSound(SoundID);
			SoundID = 0;
		}
		PlaySound(EndPushSound, SLOT_Misc,0.0);
	}
			
	if ( DestroySound[0] != none )
	{
		decision = FRand();
		if ( (decision > 0.667) && DestroySound[2] != none )
			PlaySound(DestroySound[2]);
		else if ((decision > 0.3334) && DestroySound[1] != none )
			PlaySound(DestroySound[1]);
		else 
			PlaySound(DestroySound[0]);
	}

	Super.Destroyed();
}

simulated function skinnedFrag(class<fragment> FragType, texture FragSkin, vector Momentum, float DSize, int NumFrags) 
{
	local int i;
	local actor A, Toucher;
	local Fragment s;

	if ( bOnlyTriggerable )
		return; 
	if (Event!='')
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Toucher, pawn(Toucher) );
	if ( Region.Zone.bDestructive )
	{
		Destroy();
		return;
	}
	for (i=0 ; i<NumFrags ; i++) 
	{
		s = Spawn( FragType, Owner);
		s.CalcVelocity(Momentum/100,0);
		s.Skin = FragSkin;
		s.DrawScale = DSize*0.5+0.7*DSize*FRand();
	}

	Destroy();
}

simulated function Frag(class<fragment> FragType, vector Momentum, float DSize, int NumFrags) 
{
	local int i;
	local actor A, Toucher;
	local Fragment s;

	if ( bOnlyTriggerable )
		return; 
	if (Event!='')
		foreach AllActors( class 'Actor', A, Event )
			A.Trigger( Toucher, pawn(Toucher) );
	if ( Region.Zone.bDestructive )
	{
		Destroy();
		return;
	}
	for (i=0 ; i<NumFrags ; i++) 
	{
		s = Spawn( FragType, Owner);
		s.CalcVelocity(Momentum,0);
		s.DrawScale = DSize*0.5+0.7*DSize*FRand();
	}

	Destroy();
}

function Timer()
{
	if (SoundID > 0)
	{
		StopSound(SoundID);
		SoundID = 0;
	}
	bPushSoundPlaying=False;
}

function Bump( actor Other ) 
{
	local float Speed, oldZ;
	if( bPushable && (Pawn(Other)!=None) && (Other.Mass > 40) )
	{
		bBobbing = false;
		oldZ = Velocity.Z;
		Speed = VSize(Other.Velocity);
		Velocity = Other.Velocity * FMin(120.0, 20 + Speed)/Speed;
		if ( Physics == PHYS_None ) {
			Velocity.Z = 25;
			if (!bPushSoundPlaying && (SoundID == 0) )
				SoundID = PlaySound(PushSound, SLOT_Misc,0.25);
			bPushSoundPlaying = True;			
		}
		else
			Velocity.Z = oldZ;
		SetPhysics(PHYS_Falling);
		PlaySound(EndPushSound, SLOT_Misc,0.0);
		SetTimer(0.3,False);
		Instigator = Pawn(Other);
	}
}

defaultproperties
{
     bStatic=True
     bStasis=True
     Texture=None
     ShadowImportance=1
     Mass=0
}
