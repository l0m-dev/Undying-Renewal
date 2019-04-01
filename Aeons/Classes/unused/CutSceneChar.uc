//=============================================================================
// CutSceneChar.
//=============================================================================
class CutSceneChar expands Visible;

var() int CutsceneID;
var() byte CSSeqPlaySoundGlobal[64];
var() float CSSeqVolume[64];
var() float CSSeqStrength[64];
var() float CSDialogTimes[64];
var() name CSDialogSeq[64];
var() Sound CSSounds[64];
var() name AnimName[64];
var() bool bAnimOverrideHide;
var int i, NextDialogIdx;
var int Take;
var float Age;
var sound foo;
var vector InitialLoc;
var Actor SceneCamera;

function PreBeginPlay()
{
	super.PreBeginPlay();
	InitialLoc = Location;
}

function SetupTake(int Cutscene, int Take);

function UnHide()
{
	bHidden = false;
}

function Hide()
{
	bHidden = true;
}

function PlayTake(int i)
{
	SetupTake(CutsceneID,i);
	Take = i;

	// if ( Take == 0 )
		// 	Age = 0;
	if (AnimName[Take] == 'Destroy')
		Destroy();
		
	if ( bAnimOverrideHide )
	{	
		if (AnimName[Take] != 'none')
		{
			UnHide();
		} else {
			Hide();
		}
	}
		
	if (AnimName[Take] != 'none')
	{
		UnHide();
		PlayAnim(AnimName[Take],,MOVE_AnimAbs,,0);
		ApplyAnim();
	}

	ResetLightCache();
	GotoState('PlayCSTake');
}

function Tick(float DeltaTime)	
{
	Age += DeltaTime;
}

state PlayCSTake
{

	function Tick(float DeltaTime)	
	{
		if (Age == 0.0)
			Age = 0.01;
		else
			Age += DeltaTime;
		if ( CSDialogTimes[NextDialogIdx]  != 0 )
		{
			if ( Age >= CSDialogTimes[NextDialogIdx] )
			{
				PlayAnimSound( CSDialogSeq[NextDialogIdx], CSSounds[NextDialogIdx],CSSeqStrength[NextDialogIdx],,CSSeqVolume[NextDialogIdx],,1, 1.0);
				SceneCamera.PlaySound (CSSounds[NextDialogIdx],,CSSeqVolume[NextDialogIdx]);

				/*
				// PlayAnimSound( name Sequence, sound Voice, optional float Amplitude, optional ESoundSlot Slot, optional float Volume, optional bool bNoOverride, optional float Radius, optional float Pitch );
				if ( (CSSeqPlaySoundGlobal[NextDialogIdx] > 0) && (SceneCamera != none))
				{
					//log("Playing Sound on the camera "$CSSounds[NextDialogIdx]$" lag="$Age$"-"$CSDialogTimes[NextDialogIdx], 'Misc' );
					SceneCamera.PlaySound ( CSSounds[NextDialogIdx],,CSSeqVolume[NextDialogIdx]);
				} else {
					//log("Playing Anim Sound "$CSDialogSeq[NextDialogIdx]$" sound: "$CSSounds[NextDialogIdx]$" lag="$Age$"-"$CSDialogTimes[NextDialogIdx], 'Misc' );
					PlayAnimSound( CSDialogSeq[NextDialogIdx], CSSounds[NextDialogIdx],CSSeqStrength[NextDialogIdx],,CSSeqVolume[NextDialogIdx],,65536.0, 1.0);
					// PlayAnimSound( Sequence, Voice, Amplitude, ESoundSlot, Volume, bNoOverride, Radius, Pitch );
				}
				*/

				NextDialogIdx ++; 
			}
		}
	}
 
	Begin:
}

defaultproperties
{
     LODBias=1.5
     DrawType=DT_Mesh
     ShadowImportance=1
     bGroundMesh=False
}
