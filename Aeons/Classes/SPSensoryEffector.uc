//=============================================================================
// SPSensoryEffector.
//=============================================================================
class SPSensoryEffector expands SPEffector;

//****************************************************************************
// This is a class of persistent effectors held by ScriptedPawns
// to keep track of its senses
// When the sensor is stimulated, it begins to raise its awareness of the sense
// for the duration of time specified by the stimulant
// Once the duration has been passed, the sensor will drop its awareness of the
// sense at a rate specified by DesensitizeRate (a value of 1.0 causes the rate
// to drop at the same rate it rises, at 0.5 it will drop at half the rate, 2.0
// at twice the rate, 0.0 no drop at all, etc.)
// A threshold can be specified that, when exceed, will cause the sensor to
// send an alarm to the host
// The sensor can be disabled for a specified duration, after which it will
// re-enable itself
// While disabled, the sensor will continue to tick the duration and drop awareness
//
// Use Stimulate( float, actor ) to stimulate the sensor for the duration passed
// Use GetSensorLevel() to obtain the current awareness [0..1]
// Use IsEnabled() to query sensor status
// Use DisableSensor( float ) to disable the sense for the duration passed, passing
// a negative value will disable permanently (until re-enabled)
// Use EnableSensor() to re-enable the sense
//****************************************************************************


//****************************************************************************
// member vars
//****************************************************************************

var float					StimulusTimer;		// how long to stimulate
var float					StimulusStrength;	// original stimulus strength
var actor					SensedActor;		// the (most recent) actor sensed
var float					SensorLevel;		// level the sensor it at
var float					AlarmThreshold;		// level at which to signal an alarm
var float					AlarmFrequency;		// how often alarms can be triggered
var float					DesensitizeRate;	// rate to desensitize
var float					DisableTimer;		// sense is disabled when > 0.0


//****************************************************************************
// inherited member funcs
//****************************************************************************

// handle per-frame tick
function Tick( float DeltaTime )
{
	super.Tick( DeltaTime );

	if ( DisableTimer < 0.0 )	// negative value indicates permanently disabled
		return;

	DisableTimer -= DeltaTime;
	if ( DisableTimer < 0.0 )
		DisableTimer = 0.0;

	if ( DisableTimer > 0.0 )
	{
		// sensor is disabled, tick the stimulant and desensitize
		StimulusTimer -= ( DeltaTime * StimulusStrength );
		if ( StimulusTimer < 0.0 )
			StimulusTimer = 0.0;
		SensorLevel -= DesensitizeRate * DeltaTime;
		if ( SensorLevel < 0.0 )
			SensorLevel = 0.0;
		return;
	}

	if ( StimulusTimer > 0.0 )
	{
		// stimulate
		SensorLevel += ( DeltaTime * StimulusStrength );
		StimulusTimer -= ( DeltaTime * StimulusStrength );
		if ( StimulusTimer < 0.0 )
		{
			SensorLevel += StimulusTimer;
			StimulusTimer = 0.0;
		}
		if ( SensorLevel >= AlarmThreshold )
		{
			// alarm level reached
			SensorLevel = AlarmThreshold - AlarmFrequency;		// clamp notifications @ AlarmFrequency
			AlarmHost();
		}
	}
	else
	{
		// desensitize
		SensorLevel -= DesensitizeRate * DeltaTime;
		if ( SensorLevel < 0.0 )
			SensorLevel = 0.0;
	}
}


//****************************************************************************
// new member funcs
//****************************************************************************

// stimulate this sense
function Stimulate( float duration, optional actor sensed )
{
	StimulusTimer += duration;
	StimulusStrength = StimulusTimer;
	if ( sensed != none )
		SensedActor = sensed;
}

// called when SensorLevel exceeds AlarmThreshold
function AlarmHost()
{
}

// returns the SensorLevel as a % of AlarmThreshold
function float GetSensorLevel()
{
	if ( AlarmThreshold > 0.0 )
		return SensorLevel / AlarmThreshold;
	else
		return 1.0;
}

// set SensorLevel to the specified % of AlarmThreshold
function SetSensorLevel( float pct )
{
	SensorLevel = AlarmThreshold * pct;
	StimulusTimer *= pct;
	StimulusStrength *= pct;
}

// query effector status
function bool IsEnabled()
{
	return ( DisableTimer == 0.0 );
}

// disable the sense
function DisableSensor( float duration )
{
	DisableTimer = duration;
}

// enable the sense
function EnableSensor()
{
	DisableTimer = 0.0;
}

// set AlarmThreshold
function SetAlarmThreshold( float newThresh )
{
	AlarmThreshold = newThresh;
	if ( SensorLevel > AlarmThreshold )
		SensorLevel = AlarmThreshold;
}

// set the decay (desensitization) rate as a scale of the default rate
function SetDecayRate( float scale )
{
	DesensitizeRate = default.DesensitizeRate * scale;
}

// set the alarm frequency
function SetAlarmFrequency( float freq )
{
	AlarmFrequency = freq;
}

// Reset to 0.
function Reset()
{
	SensorLevel = 0.0;
	StimulusTimer = 0.0;
}


//****************************************************************************
// def props
//****************************************************************************

defaultproperties
{
     AlarmThreshold=2
     DesensitizeRate=0.3
}
