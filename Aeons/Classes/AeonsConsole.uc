//=============================================================================
// AeonsConsole.
//=============================================================================
class AeonsConsole expands WindowConsole;

var bool bRequestedBook;
var bool bRequestWindow;
var int CursorPos;
var bool bControlDown;

function RequestBook(Pawn P)
{
	Aeonsplayer(P).ShowBook();
}

event Tick( float Delta )
{
	Super.Tick(Delta);
	if (bRequestWindow || bRequestedBook)
	{
		LaunchUWindow();
		// don't reset bRequestedBook
		bRequestWindow = false;
	}
}

state Typing
{
	exec function Type()
	{
		TypedStr="";
		CursorPos=0;
		gotoState( '' );
	}
	function bool KeyType( EInputKey Key )
	{
		if ( bNoStuff )
		{
			bNoStuff = false;
			return true;
		}
		if( Key>=0x20 && Key<0x100 && Key!=Asc("~") && Key!=Asc("`") )
		{
			//TypedStr = TypedStr $ Chr(Key);
			TypedStr = Left(TypedStr,CursorPos) $ Chr(Key) $ Right(TypedStr,Len(TypedStr)-CursorPos);
			CursorPos++;
			Scrollback=0;
			return true;
		}
	}
	function bool KeyEvent( EInputKey Key, EInputAction Action, FLOAT Delta )
	{
		local string Temp;

		bNoStuff = false;
		if( Key==IK_Escape )
		{
			if( Scrollback!=0 )
			{
				Scrollback=0;
			}
			else if( TypedStr!="" )
			{
				TypedStr="";
				CursorPos=0;
			}
			else
			{
				ConsoleDest=0.0;
				GotoState( '' );
			}
			Scrollback=0;
		}
		else if( global.KeyEvent( Key, Action, Delta ) )
		{
			return true;
		}
		else if( Action != IST_Press )
		{
			return false;
		}
		else if( Key==IK_Enter )
		{
			if( Scrollback!=0 )
			{
				Scrollback=0;
			}
			else
			{
				if( TypedStr!="" )
				{
					// Print to console.
					if( ConsoleLines!=0 )
						Message( None, "(>" @ TypedStr, 'Console' );

					// Update history buffer.
					History[HistoryCur++ % MaxHistory] = TypedStr;
					if( HistoryCur > HistoryBot )
						HistoryBot++;
					else
						HistoryCur = HistoryBot;
					if( HistoryCur - HistoryTop >= MaxHistory )
						HistoryTop = HistoryCur - MaxHistory + 1;

					// Make a local copy of the string.
					Temp=TypedStr;
					TypedStr="";
					CursorPos=0;
					if( !ConsoleCommand( Temp ) )
						Message( None, Localize("Errors","Exec","Core"), 'Console' );
					Message( None, "", 'Console' );
				}
				if( ConsoleDest==0.0 )
					GotoState('');
				Scrollback=0;
			}
		}
		else if( Key==IK_Up )
		{
			if( HistoryCur > HistoryTop )
			{
				History[HistoryCur % MaxHistory] = TypedStr;
				TypedStr = History[--HistoryCur % MaxHistory];
				CursorPos=Len(TypedStr);
			}
			Scrollback=0;
		}
		else if( Key==IK_Down )
		{
			History[HistoryCur % MaxHistory] = TypedStr;
			if( HistoryCur < HistoryBot )
				TypedStr = History[++HistoryCur % MaxHistory];
			else
				TypedStr="";
			CursorPos=Len(TypedStr);
			Scrollback=0;
		}
		else if( Key==IK_PageUp )
		{
			if( ++Scrollback >= MaxLines )
				Scrollback = MaxLines-1;
		}
		else if( Key==IK_PageDown )
		{
			if( --Scrollback < 0 )
				Scrollback = 0;
		}
		else if( Key==IK_Backspace )
		{
			if( Len(TypedStr)>0 )
			{
				//TypedStr = Left(TypedStr,Len(TypedStr)-1);
				TypedStr = Left(TypedStr,CursorPos-1) $ Right(TypedStr,Len(TypedStr)-CursorPos);
				CursorPos--;
			}
			Scrollback = 0;
		}
		else if ( Key==IK_Left )
		{
			CursorPos = Max(0, CursorPos-1);
		}
		else if ( Key==IK_Right )
		{
			CursorPos = Min(Len(TypedStr), CursorPos+1);
		}
		else if ( Key==IK_CTRL )
		{
			if ( Action == EInputAction.IST_Press )
				bControlDown = True;
			else if ( Action == EInputAction.IST_Release )
				bControlDown = False;
		}
		else if ( Key==IK_C )
		{
			if (bControlDown)
			{
				Viewport.Actor.CopyToClipboard(TypedStr);
			}
		}
		else if ( Key==IK_V )
		{
			if (bControlDown)
			{
				TypedStr=Left(TypedStr,CursorPos) $ Viewport.Actor.PasteFromClipboard() $ Right(TypedStr,Len(TypedStr)-CursorPos);
				CursorPos=Len(TypedStr);
			}
		}

		return true;
	}
	function BeginState()
	{
		bTyping = true;
		Viewport.Actor.Typing(bTyping);
	}
	function EndState()
	{
		bTyping = false;
		Viewport.Actor.Typing(bTyping);
		//log("Console leaving Typing");
		ConsoleDest=0.0;
	}
}

defaultproperties
{
     ShowDesktop=True
     UWindowKey=IK_None
}
