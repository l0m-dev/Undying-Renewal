//=============================================================================
// NarratorScript.
//=============================================================================
class NarratorScript expands Info;

//#exec TEXTURE IMPORT FILE=NarratorScript.pcx GROUP=System Mips=Off

//****************************************************************************
//****************************************************************************


//****************************************************************************
// Structure defs.
//****************************************************************************
enum EScriptAction
{
	ACTION_None,
	ACTION_WalkToPoint,			// [ActionName=NavigationPoint.Tag, ActionValue=Optional post-move delay]
	ACTION_RunToPoint,			// [ActionName=NavigationPoint.Tag, ActionValue=Optional post-move delay]
	ACTION_WalkToPlayer,		// [ActionValue=Distance offset, ActionValue=Optional post-move delay]
	ACTION_RunToPlayer,			// [ActionValue=Distance offset, ActionValue=Optional post-move delay]
	ACTION_SpeakCasual,			// [ActionSound=Sound identifier, ActionValue=Optional post-action delay]
	ACTION_SpeakImplore,		// [ActionSound=Sound identifier, ActionValue=Optional post-action delay]
	ACTION_SpeakInquisitive,	// [ActionSound=Sound identifier, ActionValue=Optional post-action delay]
	ACTION_SpeakMumble,			// [ActionSound=Sound identifier, ActionValue=Optional post-action delay]
	ACTION_PlayAnimation,		// [ActionName=Animation sequence]
	ACTION_LoopAnimation,		// [ActionName=Animation sequence]
	ACTION_Trigger,				// [ActionName=Trigger event]
	ACTION_Wait,				// [ActionValue=Time in seconds]
	ACTION_Goto,				// [ActionValue=Action number]
	ACTION_GotoState,			// [ActionName=State identifier]
	ACTION_GotoScript,			// [ActionName=NarratorScript.Tag, ActionValue=Starting action number]
	ACTION_UnlockPlayer,		// [no parameters]
	ACTION_PlayerSpeak,			// [ActionSound=Sound identifier, ActionValue=Optional post-action delay]
	ACTION_Unlook,				// [no parameters]
	ACTION_LeashPlayer,			// [ActionBool=Leash/Unleash flag]
	ACTION_JumpToPoint,			// [ActionName=NavigationPoint.Tag, ActionValue=Optional post-move delay]
	ACTION_Vanish,				// [no parameters]
	ACTION_PlayerDetect,		// [ActionBool=Yes/No flag]
	ACTION_EndScript,			// [no parameters]
	ACTION_CallState,			// [ActionName=State identifier]
	ACTION_CallScript,			// [ActionName=NarratorScript Tag, ActionValue=Starting action number]
	ACTION_Return,				// [no parameters]
	ACTION_SetTag,				// [ActionName=Tag to set own Tag to]
	ACTION_Die,					// [no parameters]
	ACTION_FadeIn,				// [ActionValue=Fade time (seconds)]
	ACTION_FadeOut,				// [ActionValue=Fade time (seconds)]
	ACTION_LookAt,				// [ActionName=Target actor tag]
	ACTION_PlaySpecialSound,	// [ActionValue=Bitfield parameter to pass to PlaySound]
	ACTION_Turret,				// [ActionBool=Yes/No flag]
	ACTION_Custom,				// [ActionValue=Action number]
	ACTION_ForcePlayerTouch		// [ActionName=Target actor(s) tag]
};

struct ScriptActionInfo
{
	var() EScriptAction		Action;
	var() name				ActionName;
	var() Sound				ActionSound;
	var() float				ActionValue;
	var() bool				ActionBool;
};


//****************************************************************************
// Member vars.
//****************************************************************************
var() ScriptActionInfo		ActionList[20];		// List of actions
var() bool					bClickThrough;		//


//****************************************************************************
// Inherited member funcs.
//****************************************************************************


//****************************************************************************
// New member funcs.
//****************************************************************************
function EScriptAction GetAction( int Num )
{
	return ActionList[Num].Action;
}

function name GetName( int Num )
{
	return ActionList[Num].ActionName;
}

function Sound GetSound( int Num )
{
	return ActionList[Num].ActionSound;
}

function float GetValue( int Num )
{
	return ActionList[Num].ActionValue;
}

function bool GetBool( int Num )
{
	return ActionList[Num].ActionBool;
}

function int NextAction( int cAction )
{
	cAction += 1;
	if ( cAction >= ArrayCount(ActionList) )
		cAction = 0;
	return cAction;
}


//****************************************************************************
// Def props.
//****************************************************************************

defaultproperties
{
     Texture=Texture'Aeons.System.NarratorScript'
}
