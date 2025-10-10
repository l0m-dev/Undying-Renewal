//=============================================================================
// AeonsConsole.
//=============================================================================
class AeonsConsole expands WindowConsole;

var bool bRequestedBook;
var bool bRequestWindow;
var int CursorPos;
var bool bControlDown;
var bool bChatting;

function RequestBook(Pawn P)
{
	Aeonsplayer(P).ShowBook();
}

state UWindow
{
	event PostRender( canvas Canvas )
	{
		local int i;
		local float YOffset, XL, YL;

		Super.PostRender(Canvas);

		if (Viewport.Actor.ProgressTimeOut > Viewport.Actor.Level.TimeSeconds)
		{
			DrawProgressMessage(Canvas, 0.9 * Canvas.ClipY);
		}
	}
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

exec function Type()
{
	bChatting = false;
	TypedStr="";
	GotoState( 'Typing' );
}

exec function Chat()
{
	Talk();
}
 
exec function Talk()
{
	bChatting = true;
	TypedStr="";
	bNoStuff = true;
	GotoState( 'Typing' );
}

exec function TeamTalk()
{
	bChatting = true;
	TypedStr="";
	bNoStuff = true;
	GotoState( 'Typing' );
}

state Typing
{
	exec function Type()
	{
		bControlDown = false;
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
		if( Key>=0x20 && Key<0x100 && Key!=Asc("~") && Key!=Asc("`") && Key!=Asc("") )
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
		local int TempCursorPos;

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
		else if ( Key==IK_CTRL )
		{
			if ( Action == IST_Press )
				bControlDown = True;
			else
				bControlDown = False;
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
					if (!bChatting)
					{
						History[HistoryBot++ % MaxHistory] = TypedStr;
						HistoryCur = HistoryBot;
						if( HistoryCur - HistoryTop >= MaxHistory )
							HistoryTop = HistoryCur - MaxHistory + 1;
					}

					// Make a local copy of the string.
					Temp=TypedStr;
					TypedStr="";
					CursorPos=0;
					if (bChatting)
					{
						ConsoleCommand( "Say"@Temp ); 
					}
					else
					{
						if( !ConsoleCommand( Temp ) )
							Message( None, Localize("Errors","Exec","Core"), 'Console' );
						Message( None, "", 'Console' );
					}
				}
				if( ConsoleDest==0.0 )
					GotoState('');
				Scrollback=0;
			}
		}
		else if( Key==IK_Up )
		{
			if (!bChatting)
			{
				if( HistoryCur > HistoryTop )
				{
					TypedStr = History[--HistoryCur % MaxHistory];
					CursorPos=Len(TypedStr);
				}
				Scrollback=0;
			}
		}
		else if( Key==IK_Down )
		{
			if (!bChatting)
			{
				if( HistoryCur < HistoryBot )
					TypedStr = History[++HistoryCur % MaxHistory];
				else
					TypedStr="";
				CursorPos=Len(TypedStr);
				Scrollback=0;
			}
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
			if( CursorPos>0 )
			{
				if (bControlDown)
				{
					TempCursorPos = CursorPos;
					while(TempCursorPos > 0 && Mid(TypedStr, TempCursorPos - 1, 1) == " ")
						TempCursorPos--;
					while(TempCursorPos > 0 && Mid(TypedStr, TempCursorPos - 1, 1) != " ")
						TempCursorPos--;
					TypedStr = Left(TypedStr,TempCursorPos) $ Right(TypedStr,Len(TypedStr)-CursorPos);
					CursorPos = TempCursorPos;
				}
				else
				{
					TypedStr = Left(TypedStr,CursorPos-1) $ Right(TypedStr,Len(TypedStr)-CursorPos);
					CursorPos--;
				}
			}
			Scrollback = 0;
		}
		else if ( Key==IK_Left )
		{
			if (bControlDown)
			{
				while(CursorPos > 0 && Mid(TypedStr, CursorPos - 1, 1) == " ")
					CursorPos--;
				while(CursorPos > 0 && Mid(TypedStr, CursorPos - 1, 1) != " ")
					CursorPos--;
			}
			else
			{
				CursorPos = Max(0, CursorPos-1);
			}
		}
		else if ( Key==IK_Right )
		{
			if (bControlDown)
			{
				while(CursorPos < Len(TypedStr) && Mid(TypedStr, CursorPos, 1) != " ")
					CursorPos++;
				while(CursorPos < Len(TypedStr) && Mid(TypedStr, CursorPos, 1) == " ")
					CursorPos++;
			}
			else
			{
				CursorPos = Min(Len(TypedStr), CursorPos+1);
			}
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
				Temp = Viewport.Actor.PasteFromClipboard();

				// strip crlf
				Viewport.Actor.ReplaceText(Temp, Chr(13)$Chr(10), "");
				Viewport.Actor.ReplaceText(Temp, Chr(13), "");
				Viewport.Actor.ReplaceText(Temp, Chr(10), "");

				TypedStr=Left(TypedStr,CursorPos) $ Temp $ Right(TypedStr,Len(TypedStr)-CursorPos);
				CursorPos=Len(TypedStr);
			}
		}

		return true;
	}
	function BeginState()
	{
		bTyping = true;
		Viewport.Actor.Typing(bTyping);
		CursorPos=Len(TypedStr);
		HistoryCur = HistoryBot;
	}
	function EndState()
	{
		bTyping = false;
		bChatting = false;
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
