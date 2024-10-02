//=============================================================================
// DamageTrigger.
//=============================================================================
class DamageTrigger expands Trigger;

//#exec TEXTURE IMPORT NAME=TrigDamage FILE=TrigDamage.pcx GROUP=System Mips=Off Flags=2

var() name 	DamageTypes[8];
var() int	DamageThreshold[8];
var() enum ELogic
{
	LOGIC_or,
	LOGIC_and,
	LOGIC_not
} LogicType;

var() bool bDestroy;

var float CumulativeDamage;

state() DamageTrig
{
	function Touch( actor Other );

	// Check the DamageTypes supplied by the designer against
	// the damage type given by the thing damaging me
	function bool CheckDamageTypes(DamageInfo DInfo)
	{
		local int i;
		local bool bLogic;

		// electrical damage accumulates
		if ( DInfo.DamageType == 'electrical' )
		{
			CumulativeDamage += DInfo.Damage;
			DInfo.Damage = CumulativeDamage;
		}
		
		// OR logic - any one satisfication of the test will return true
		if (LogicType == LOGIC_or)
			for (i=0; i<8; i++)
			{
				if ( DamageTypes[i] != 'none' )
				{
					if ( (DInfo.DamageType == DamageTypes[i]) && (DInfo.Damage > DamageThreshold[i]) )
						return true;
				}
			}

		// AND logic - ALL DamageType tests must be satsfied
		if (LogicType == LOGIC_and)
		{
			bLogic = true;
			for (i=0; i<8; i++)
				if ( DamageTypes[i] != 'none' )
					if ( !((DInfo.DamageType == DamageTypes[i]) && (DInfo.Damage > DamageThreshold[i])) )
					{
						bLogic = false;
						break;
					}
			
			if ( bLogic )
				return true;
			else
				return false;
		}

		// NOT logic - NO DamageType tests can be satsfied
		if (LogicType == LOGIC_not)
		{
			bLogic = true;
			for (i=0; i<8; i++)
				if ( DamageTypes[i] != 'none' )
					if ( (DInfo.DamageType == DamageTypes[i]) && (DInfo.Damage > DamageThreshold[i]) )
					{
						bLogic = false;
						break;
					}
			if ( bLogic )
				return true;
			else
				return false;
		}


	}

	function Trigger(Actor Other, Pawn Instigator)
	{
		bInitiallyActive = !bInitiallyActive;
	}
	
	function TakeDamage( Pawn instigatedBy, Vector hitlocation, Vector momentum, DamageInfo DInfo)
	{
		local actor A;

		// check the conditional event name - this checks the supplied event in the player
		if ( !bInitiallyActive )
			return;

		if ( !CheckConditionalEvent(Condition) )
			return;

		if ( CheckDamageTypes(DInfo) )
		{
			if ( bInitiallyActive && (instigatedBy != None) )
			{
				if ( ReTriggerDelay > 0 )
				{
					if ( Level.TimeSeconds - TriggerTime < ReTriggerDelay )
						return;
					TriggerTime = Level.TimeSeconds;
				}
				// Broadcast the Trigger message to all matching actors.
				if( Event != '' )
					foreach AllActors( class 'Actor', A, Event )
					{

						if ( A.IsA('Trigger') )
						{
							// handle Pass Thru message
							if ( Trigger(A).bPassThru )
							{
								Trigger(A).PassThru(InstigatedBy);
							}
						}

						if( bTriggerOnceOnly )
							// Ignore future touches.
							SetCollision(False);
						A.Trigger( instigatedBy, instigatedBy );
					}

				if( Message != "" && Level.bDebugMessaging)
					// Send a string message to the toucher.
					instigatedBy.Instigator.ClientMessage( Message );

				if ( bDestroy )
					Destroy();
			}
		}
	}

	Begin:

}

defaultproperties
{
     InitialState=DamageTrig
     Texture=Texture'Aeons.System.TrigDamage'
     DrawScale=0.5
     bProjTarget=True
}
