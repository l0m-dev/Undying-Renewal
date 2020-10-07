//=============================================================================
// Parent class of all spells.
//=============================================================================
class Spell extends Inventory
	native 
    abstract;

// Share Weapon icon for now.
//#exec Texture Import File=Textures\Weapon.pcx Name=S_Weapon Mips=On Flags=2

var savable travel int castingLevel;	// casting level of the spell - the base casting level of the spell
var int LocalCastingLevel;				// casting level of the spell after modifications from the ghelziabahr stone.

var int amplitudeBonus;			// amplitude bunus to the castingLevel (i.e. from the Ghelzibahar Stone)
var() int     manaCostPerLevel[6];
var() int     damagePerLevel[6];

var   bool    bInControl;       // If true, then this is the currently active and rendered spell
var   bool    bPassControl;     // If true, then fire the other currently active spell (Attack or Defense)
var() float   MaxTargetRange;   // Maximum distance to target.
var   bool    bPointing;        // Indicates spell is being pointed
var() bool    bInstantHit;      // If true, instant hit rather than projectile firing
var() bool    bWaterFire; //can fire under water
var(SpellAI) bool     bWarnTarget;  // When firing projectile, warn the target
var   bool    bSpellUp;         // Used in Active State
var   bool    bChangeSpell;     // Used in Active State
var(SpellAI) bool     bSplashDamage;     // used by bot AI
var(SpellAI) bool     bRecommendSplashDamage; //if true, bot preferentially tries to use splash damage
                                              // rather than direct hits
var() bool    bOwnsCrosshair;   // this spell is responsible for drawing its own crosshair (in its postrender function)
var   bool    bHideSpell;      // if true, spell is not rendered

var()   vector  FireOffset;      // Offset from drawing location for projectile/trace start
var()   class<projectile> ProjectileClass;
var()   name    MyDamageType;   //set from the projectile's stats
var     float   ProjectileSpeed;//set from the projectile's stats
var     float   AimError;       // Aim Error for bots (note this value doubled if instant hit )
var()   float   ShakeMag;
var()   float   ShakeTime;
var()   float   ShakeVert;
var(SpellAI)   float   AIRating;
var(SpellAI)   float   RefireRate; //likelyhood that AI will immed. fire again
var()   float   Accuracy;       //inherent spell accuracy -for rapid fire spread

var()   float   ExtraFireDelay;     //sleep for this amount after fire anim
var()   float   ExtraSpellUpDelay;  //sleep for this amount after spell up anim
var()   float   ExtraSpellDownDelay;//sleep for this amount after spell down anim

//-----------------------------------------------------------------------------
// Sound Assignments
var() sound     FireSound;
var() sound     FizzleSound;
var() sound     SelectSound;
var() sound     Misc1Sound;
var() sound     Misc2Sound;
var() sound     Misc3Sound;

var() Localized string MessageNoMana;
var() Localized string DeathMessage;

var Rotator AdjustedAim;
var bool bFiring;

//-----------------------------------------------------------------------------
// Muzzle Flash
// spell is responsible for setting and clearing bMuzzleFlash whenever it wants the
// MFTexture drawn on the canvas (see RenderOverlays() )
var bool bSetFlashTime;
var(MuzzleFlash) bool bDrawMuzzleFlash;
var byte bMuzzleFlash;
var float FlashTime;
var(MuzzleFlash) float MuzzleScale, FlashY, FlashO, FlashC, FlashLength;
var(MuzzleFlash) int FlashS;    // size of (square) texture/2
var(MuzzleFlash) texture MFTexture;
var(MuzzleFlash) texture MuzzleFlare;
var(MuzzleFlash) float FlareOffset; 


// Network replication
//
replication
{
    // Things the server should send to the client.
    reliable if( Role==ROLE_Authority && bNetOwner )
        bHideSpell, bInControl, CastingLevel;
}

//=============================================================================
// Inventory travelling across servers.

function Destroyed()
{
    Super.Destroyed();
}

event TravelPostAccept()
{
    Super.TravelPostAccept();
    GotoState('Idle2');
}

//=============================================================================
// spell rendering
// Draw first person view of inventory
simulated event RenderOverlays( canvas Canvas )
{
    local rotator NewRot;
    local bool bPlayerOwner;
    local int Hand;
    local PlayerPawn PlayerOwner;
    local vector tempOffset;
	
	if ( bHideSpell || (Owner == None) || !bInControl )
		return;

    PlayerOwner = PlayerPawn(Owner);
    if ( PlayerOwner != None )
	{
		bPlayerOwner = true;
		Hand = PlayerOwner.Handedness;
	}

    if (  (Level.NetMode == NM_Client) && bPlayerOwner && (Hand == 2) )
	{
		bHideSpell = true;
		return;
	}

    if ( !bPlayerOwner || (PlayerOwner.Player == None) )
        Pawn(Owner).WalkBob = vect(0,0,0);

    if ( (bMuzzleFlash > 0) && bDrawMuzzleFlash && Level.bHighDetailMode && (MFTexture != None) )
    {
        MuzzleScale = Default.MuzzleScale * Canvas.ClipX/640.0;
        if ( !bSetFlashTime )
        {
            bSetFlashTime = true;
            FlashTime = Level.TimeSeconds + FlashLength;
        }
        else if ( FlashTime < Level.TimeSeconds )
            bMuzzleFlash = 0;
        if ( bMuzzleFlash > 0 )
        {
            if ( Hand == 0 )
                Canvas.SetPos(Canvas.ClipX/2 - MuzzleScale * FlashS + Canvas.ClipX * (-0.2 * Default.FireOffset.Y * FlashO), Canvas.ClipY/2 - MuzzleScale * FlashS + Canvas.ClipY * (FlashY + FlashC));
            else
                Canvas.SetPos(Canvas.ClipX/2 - MuzzleScale * FlashS + Canvas.ClipX * (Hand * Default.FireOffset.Y * FlashO), Canvas.ClipY/2 - MuzzleScale * FlashS + Canvas.ClipY * FlashY);

            Canvas.Style = 3;
            Canvas.DrawIcon(MFTexture, MuzzleScale);
            Canvas.Style = 1;
        }
    }
    else
        bSetFlashTime = false;

	tempOffset = PlayerViewOffset;
	PlayerViewOffset *= 100; //fix  weapon does this in BringUp.
    SetLocation( Owner.Location + CalcDrawOffset() );
    PlayerViewOffset = tempOffset;
    NewRot = Pawn(Owner).ViewRotation;

    if ( Hand == 0 )
        newRot.Roll = -2 * Default.Rotation.Roll;
    else
        newRot.Roll = Default.Rotation.Roll * Hand;

	// newRot += default.Rotation;
	setRotation(newRot);

    Canvas.DrawActor(self, false);
}

simulated function bool ClientFire( float Value )
{
//	logTime("Spell: ClientFire: Warning, this just returns True!");
	return true;
}

function ForceFire();

//-------------------------------------------------------
// AI related functions

function PostBeginPlay()
{
    Super.PostBeginPlay();
    MaxDesireability = 1.2 * AIRating;
    if ( ProjectileClass != None )
    {
        ProjectileSpeed = ProjectileClass.Default.Speed;
        MyDamageType = ProjectileClass.Default.MyDamageType;
    }
}

function float RateSelf( out int bUseAltMode )
{
    bUseAltMode = 0;
    return (AIRating + FRand() * 0.05);
}

// return delta to combat style
function float SuggestAttackStyle()
{
    return 0.0;
}

function float SuggestDefenseStyle()
{
    return 0.0;
}

//-------------------------------------------------------

simulated function PreRender( canvas Canvas );
simulated function PostRender( canvas Canvas );

// returns a number, either 1 or -1 - randomly cooses one.
function int randomSign()
{
	if (FRand() < 0.5)
		return 1;
	else
		return -1;
}

function bool HandlePickupQuery( inventory Item )
{
    local Pawn P;

    if (Item.Class == Class)
    {
        P = Pawn(Owner);
        P.ClientMessage(PickupMessage, 'Pickup');
        Item.PlaySound(Item.PickupSound);
		Item.MakeNoise(0.5, 640);

        Item.SetRespawn();   
        return true;
    }
    if ( Inventory == None )
        return false;

    return Inventory.HandlePickupQuery(Item);
}


//
// Change spell to that specificed by F 
simulated function Inventory FindItemInGroup( byte F )
{	
	if ( InventoryGroup == F )
	{
		return self;
	}
	else if ( Inventory == None )
		return None;
	else
		return Inventory.FindItemInGroup(F);
}


// Either give this inventory to player Other, or spawn a copy
// and give it to the player Other, setting up original to be respawned.
function Inventory SpawnCopy( pawn Other )
{
    local Inventory Copy;
    local Spell newSpell;

    if( Level.Game.ShouldRespawn(self) )
    {
        Copy = spawn(Class,Other);
        Copy.Tag           = Tag;
        Copy.Event         = Event;
        GotoState('Sleeping');
    }
    else
        Copy = self;

    Copy.RespawnTime = 0.0;
    Copy.bHeldItem = true;
    Copy.GiveTo( Other );
    newSpell = Spell(Copy);
    newSpell.Instigator = Other;
    newSpell.AmbientGlow = 0;
    return newSpell;
}

// Toss this spell out
function DropFrom(vector StartLocation)
{
    if ( !SetLocation(StartLocation) )
        return; 
    AIRating = Default.AIRating;
    bMuzzleFlash = 0;
    Super.DropFrom(StartLocation);
}

// Become a pickup
function BecomePickup()
{
    Super.BecomePickup();
    SetDisplayProperties(Default.Style, Default.Texture, Default.bUnlit, Default.bMeshEnviromap );
}

function CheckVisibility()
{
    local Pawn PawnOwner;

    PawnOwner = Pawn(Owner);
    if( Owner.bHidden && (PawnOwner.Health > 0) && (PawnOwner.Visibility < PawnOwner.Default.Visibility) )
    {
        Owner.bHidden = false;
        PawnOwner.Visibility = PawnOwner.Default.Visibility;
    }
}

//**************************************************************************************
//
// Firing functions and states
//

function SayMagicWords()
{
	local Pawn P;


	ForEach RadiusActors(class 'Pawn', P, 2048)
	{
		if ( P != Pawn(Owner) )
			if ( FastTrace(Pawn(Owner).Location, P.Location) )
				P.SpellCastNotify(self.class.name, Pawn(Owner));
	}

	//Owner.playSound(FireSound);
	//PlayerPawn(Owner).MakePlayerNoise(1.0, 1280);
}

Event OwnerDead();	// The player calls this on his AttSpell and DefSpell when he dies....used for cleanup.

function AddGhelz(int cost);

function bool processCastingLevel()
{
	/*
	if ( PlayerPawn(Owner).bAmplifySpell )
	{
		if ( castingLevel < 4 )
		{
			castingLevel ++;
			PlayerPawn(Owner).bAmplifySpell = false;
			return false;
		}
	}
	*/
	localCastingLevel = CastingLevel;
	return true;
}

//if not bSpellUp it causes the weapon hand to come up in preparation for firing
//then if there's enough mana the spell will fire
function FireAttSpell( float Value )
{
	logTime("Spell: FireAttSpell");
    if ( Pawn(Owner).HeadRegion.Zone.bWaterZone && !bWaterFire)
    {
        PlayFireEmpty(); //perhaps a fizzle sound
    }
    else if ( !bSpellUp )
    {
        BringUp();
    } 
	else if ( ProcessCastingLevel() ) 
	{
	    if ( Pawn(Owner).UseMana(ManaCostPerLevel[castingLevel]) )
	    {
			AddGhelz(ManaCostPerLevel[castingLevel]);
	        GotoState('NormalFire');
	        if ( PlayerPawn(Owner) != None )
	            PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
	        bInControl = true;
	        bPointing = true;
// this is in aeonsspell			bCanClientFire = true;
	        PlayFiring();
	        if ( bInstantHit )
	            TraceFire(Value);
	        else
	            ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget,true);
	        if ( Owner.bHidden )
	            CheckVisibility();
	    } 
		else 
		{
	        PlayFireEmpty(); //perhaps a fizzle sound
	    }
	} 
	else 
	{
		PlayFireEmpty(); //perhaps a fizzle sound
	}
}

//if not bSpellUp it causes the weapon hand to come up in preparation for firing
//then if there's enough mana the spell will fire


function FireDefSpell( float Value ){}
/*{
    if ( Pawn(Owner).HeadRegion.Zone.bWaterZone && !bWaterFire)
    {
        PlayFireEmpty(); //perhaps a fizzle sound
    }
    else
    if ( !bSpellUp )
    {
        BringUp();
    }
    else
    if ( Pawn(Owner).UseMana(ManaCostPerLevel[castingLevel]) )
    {
        GotoState('NormalFire');
        if ( PlayerPawn(Owner) != None )
            PlayerPawn(Owner).ShakeView(ShakeTime, ShakeMag, ShakeVert);
        bInControl = true;
        bPointing=True;
        PlayFiring();
        if ( bInstantHit )
            TraceFire(Value);
        else
            ProjectileFire(ProjectileClass, ProjectileSpeed, bWarnTarget, true);
        if ( Owner.bHidden )
            CheckVisibility();
    }
    else
    {
        PlayFireEmpty(); //perhaps a fizzle sound
    }
}
*/

function PlayFiring()
{
    //Play firing animation and sound
}

function Projectile ProjectileFire(class<projectile> ProjClass, float ProjSpeed, bool bWarn, bool bMakeImpactSound)
{
    local Vector Start, EndTrace, X,Y,Z;
    local Pawn PawnOwner;

    PawnOwner = Pawn(Owner);
    PlayerPawn(Owner).MakePlayerNoise(1.0);
    if (PlayerPawn(Owner).bUsingAutoAim)
		GetAxes(AutoAimDir,X,Y,Z);
	else
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
    Start = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
    AdjustedAim = PawnOwner.AdjustAim(ProjSpeed, Start, AimError, True, bWarn); 
    EndTrace = Start + Accuracy * (FRand() - 0.5 )* Y * 1000
        + Accuracy * (FRand() - 0.5 ) * Z * 1000;
    AdjustedAim = rotator( (EndTrace - Start) + 10000 * vector(AdjustedAim) );
    return Spawn(ProjClass,,, Start,AdjustedAim);   
}

function TraceFire(float Accuracy, optional out vector HitLocation, optional out vector HitNormal)
{
    local vector StartTrace, EndTrace, X,Y,Z;
    local actor Other;
    local Pawn PawnOwner;

    PawnOwner = Pawn(Owner);

    PlayerPawn(Owner).MakePlayerNoise(1.0);
    if (PlayerPawn(Owner).bUsingAutoAim)
		GetAxes(AutoAimDir,X,Y,Z);
	else
		GetAxes(Pawn(owner).ViewRotation,X,Y,Z);
    StartTrace = Owner.Location + CalcDrawOffset() + FireOffset.X * X + FireOffset.Y * Y + FireOffset.Z * Z; 
    AdjustedAim = PawnOwner.AdjustAim(1000000, StartTrace, 2.75*AimError, False, False);  
    EndTrace = StartTrace + Accuracy * (FRand() - 0.5 )* Y * 1000
        + Accuracy * (FRand() - 0.5 ) * Z * 1000 ;
    X = vector(AdjustedAim);
    EndTrace += (10000 * X); 
    Other = PawnOwner.TraceShot(HitLocation,HitNormal,EndTrace,StartTrace);
    ProcessTraceHit(Other, HitLocation, HitNormal, X,Y,Z);
    // log("TraceZoneLocation: "$(Level.getZone(HitLocation)));
}

function ProcessTraceHit(Actor Other, Vector HitLocation, Vector HitNormal, Vector X, Vector Y, Vector Z)
{
    //Spawn appropriate effects at hit location, any spell lights, and damage hit actor
}

function PassControl();

// Finish a firing sequence
// supplied by child class
function Finish();

//**********************************************************************************
state NormalFire
{
    function FireAttSpell(float Value) 
    {
    }

    function FireDefSpell(float Value) 
    {	    
    }

Begin:
	SayMagicWords();
	FinishAnim();
    Sleep(ExtraFireDelay);
    Finish();
    //If Finish didn't change the state then we will here
    GotoState('Idle');
}

//**********************************************************************************
// spell is up, but not firing
state Idle
{
    /*
    function AnimEnd()
    {
        PlayIdleAnim();
    }
    */

    function bool PutDown()
    {
        GotoState('DownSpell');
        return True;
    }

Begin:
    bFiring = false;
	bPointing=False;
    //Disable('AnimEnd');
    PlayIdleAnim(); //if one is provided then play it once
    FinishAnim();
    GotoState('DownSpell');
}

//**********************************************************************************
// Bring newly active spell up
state Active
{
    function FireAttSpell(float Value) 
    {
        //if we're an aborted defensive spell being asked to switch
        if ( ItemType == SPELL_Defensive && Pawn(Owner).bFireDefSpell == 0 )
        {
        	PutDown();
            bPassControl = true;
        }
    }

/*    function FireDefSpell(float Value) 
    {
	    //if we're an aborted offensive spell being asked to switch
        if ( ItemType == SPELL_Offensive && Pawn(Owner).bFireAttSpell == 0 )
        {
            PutDown();
            bPassControl = true;
        }
    }
*/
    function BringUp()
    {
        //just keep bringing it up
    }

    function bool PutDown()
    {
        if ( bSpellUp )
            GotoState('DownSpell');
        else
            bChangeSpell = true;
        return True;
    }

    function BeginState()
    {
        bChangeSpell = false;
    }

Begin:
    FinishAnim();
    Sleep(ExtraSpellUpDelay);
    if ( bChangeSpell )
        GotoState('DownSpell');
    bSpellUp = True;
// this is only in AeonsSpell 	bCanClientFire = True;
    PlayPostSelect();
    FinishAnim();
    if ( bChangeSpell )
        GotoState('DownSpell');
    if ( ItemType == SPELL_Offensive )
        Global.FireAttSpell(0);
    else
        Global.FireDefSpell(0);
    GotoState('Idle');
}

//**********************************************************************************
// Putting down spell in favor of a new one.
State DownSpell
{
    function FireAttSpell(float Value) 
    {
        //if we're an aborted defensive spell being asked to switch
        if ( ItemType == SPELL_Defensive && Pawn(Owner).bFireDefSpell == 0 )
            bPassControl = true;
    }

/*
    function FireDefSpell(float F) 
    {
        //if we're an aborted offensive spell being asked to switch
        if ( ItemType == SPELL_Offensive && Pawn(Owner).bFireAttSpell == 0 )
            bPassControl = true;
    }
*/

    function bool PutDown()
    {
        return true; //just keep putting it down
    }

    function BeginState()
    {
        bChangeSpell = false;
        bMuzzleFlash = 0;
    }

Begin:
    TweenDown();
    FinishAnim();
    Sleep(ExtraSpellDownDelay);
    bSpellUp = false;
    bInControl = false;
    if ( Pawn(Owner) != None)
        Pawn(Owner).ChangedSpell();
    PassControl();
    GotoState('Idle2'); //Null state
}

//**********************************************************************************
function BringUp()
{
    bInControl = true;
    bSpellUp = false;
    PlaySelect();
    GotoState('Active');
}

function RaiseUp(Spell OldSpell)
{
    BringUp();
}

function bool PutDown()
{
    bChangeSpell = true;
    return true; 
}

function TweenDown()
{
    if ( (AnimSequence != '') && (GetAnimGroup(AnimSequence) == 'Select') )
        TweenAnim( AnimSequence );
    else
        PlayAnim('Down');
}

function TweenSelect()
{
    TweenAnim('Select',0.001);
}

function PlaySelect()
{
    PlayAnim('Select');
    Owner.PlaySound(SelectSound, SLOT_Misc, 1.0);
    PlayerPawn(Owner).MakePlayerNoise(0.5, 640);
}

function PlayPostSelect()
{
    //Pawn(Owner).ClientMessage(""$ItemName);
}

function PlayIdleAnim()
{
}

function PlayFireEmpty()
{
    //only put sounds here not anims
}

defaultproperties
{
     MaxTargetRange=4096
     bWaterFire=True
     ProjectileSpeed=1000
     aimerror=550
     shakemag=300
     shaketime=0.1
     shakevert=5
     AIRating=0.1
     RefireRate=0.5
     MessageNoMana=" out of mana."
     DeathMessage="%o was killed by %k's %w."
     MuzzleScale=4
     FlashLength=0.1
     AutoSwitchPriority=1
     InventoryGroup=1
     PickupMessage="You got a spell"
     ItemName="Spell"
     RespawnTime=30
     PlayerViewOffset=(X=-30,Y=75,Z=-10)
     MaxDesireability=0.5
     Icon=Texture'Engine.S_Weapon'
     bClientAnim=True
     Texture=Texture'Engine.S_Weapon'
     bNoSmooth=True
}
