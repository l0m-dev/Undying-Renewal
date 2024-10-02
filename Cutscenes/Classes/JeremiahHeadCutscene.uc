//=============================================================================
// JeremiahHeadCutscene.
//=============================================================================
class JeremiahHeadCutscene expands CutsceneChar;

//#exec MESH IMPORT MESH=JeremiahHeadCutscene_m SKELFILE=JeremiahHeadCutscene.ngf

//#exec MESH NOTIFY SEQ=0733 TIME=0.267 FUNCTION=UnHide
//#exec MESH NOTIFY SEQ=0417 TIME=0.728 FUNCTION=UnHide

function PreBeginPlay()
{
	bHidden = true;
}

function UnHide()
{
	log("Jeremiah Head Unhiding",'Cutscenes');
	bHidden = false;
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
		PlayAnim(AnimName[Take],,MOVE_AnimAbs,,0);
		ApplyAnim();
	}

	ResetLightCache();
	GotoState('PlayCSTake');
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


function SetupTake(int Cutscene, int Take)
{
	// ====================================================
	// CU_04
	// ====================================================
	if ( Cutscene == 4 )
	{
		switch( Take )
		{
			case 16:
				log("Jeremiah Head take 16 reached - hiding",'Cutscenes');
				bHidden = true;
				break;
		}
	}

	// ====================================================
	// CU_07
	// ====================================================
	if ( Cutscene == 7 )
	{
		switch( Take )
		{
			case 0:
				Hide();
				break;
			case 11:
				UnHide();
				break;
			case 15:
				Hide();
				break;
			case 32:
				Hide();
				break;
			case 33:
				UnHide();
				break;
			case 34:
				Destroy();
				break;
		}
	}
}

defaultproperties
{
     Mesh=SkelMesh'Cutscenes.Meshes.JeremiahHeadCutscene_m'
}
