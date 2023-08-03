//=============================================================================
// CommandRepeater.
//=============================================================================
class CommandRepeater expands Invisible;

var string PressCommand;
var string ReleaseCommand;
var float HoldDuration;
var float RepeatDelay;

var PlayerPawn POwner;
var bool bNeedsRelease;

function Start(string Command, float _HoldDuration, float _RepeatDelay)
{
     local int Token;

     POwner = PlayerPawn(Owner);

     Token = InStr(Command, ";");
     if (Token >= 0)
	{
		PressCommand = Left(Command, Token);
          ReleaseCommand = Right(Command, Len(Command)-Token-1);
	}
     else
     {
          PressCommand = Command;
          ReleaseCommand = "";
     }

     HoldDuration = _HoldDuration;
     RepeatDelay = _RepeatDelay;

     GotoState('Repeating');
}

function Stop()
{
     GotoState(, 'Finish');
}

function DoMultiCommand(string Command)
{
     local int Token;
     local string CurrentCommand;
     
     Token = InStr(Command, "|");
     while (Token >= 0)
     {
          CurrentCommand = Left(Command, Token);
          Command = Right(Command, Len(Command)-Token-1);

          Token = InStr(Command, "|");

          POwner.ConsoleCommand(CurrentCommand);
     }

     POwner.ConsoleCommand(Command);
}

state Idle
{
}

state Repeating
{
     function DoPressCommand()
     {
          DoMultiCommand(PressCommand);
          bNeedsRelease = true;
     }
     function DoReleaseCommand()
     {
          DoMultiCommand(ReleaseCommand);
          bNeedsRelease = false;
     }
     Begin:
     Repeat:
          DoPressCommand();
          Sleep(HoldDuration);
          DoReleaseCommand();
          Sleep(RepeatDelay);
          GotoState(, 'Repeat');
     
     Finish:
          if (bNeedsRelease)
               DoReleaseCommand();
          GotoState('Idle');
}

defaultproperties
{
     bHidden=True
     DrawType=DT_None
     bTravel=True
}