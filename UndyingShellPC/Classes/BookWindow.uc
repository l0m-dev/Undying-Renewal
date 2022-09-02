//=============================================================================
// BookWindow.
//=============================================================================
class BookWindow expands ShellWindow;

//----------------------------------------------------------------------------

/* 3D Book Implementation */
//#exec Texture Import File=Book_0.bmp Mips=Off
//#exec Texture Import File=Book_1.bmp Mips=Off
//#exec Texture Import File=Book_2.bmp Mips=Off
//#exec Texture Import File=Book_3.bmp Mips=Off
//#exec Texture Import File=Book_4.bmp Mips=Off
//#exec Texture Import File=Book_5.bmp Mips=Off

//#exec Texture Import File=Book_Icon.bmp Flags=2 Mips=Off
//#exec Texture Import File=Book01_Icon.bmp Flags=2 Mips=Off
//#exec Texture Import File=Book02_Icon.bmp Flags=2 Mips=Off

//Up button
//#exec Texture Import File=Book_Up_Up.bmp Mips=Off
//#exec Texture Import File=Book_Up_Ov.bmp Mips=Off
//#exec Texture Import File=Book_Up_Dn.bmp Mips=Off
//#exec Texture Import File=Book_Up_Ds.bmp Mips=Off

//Down button
//#exec Texture Import File=Book_Down_Up.bmp Mips=Off
//#exec Texture Import File=Book_Down_Ov.bmp Mips=Off
//#exec Texture Import File=Book_Down_Dn.bmp Mips=Off
//#exec Texture Import File=Book_Down_Ds.bmp Mips=Off

//Left button
//#exec Texture Import File=Book_Left_Up.bmp Mips=Off
//#exec Texture Import File=Book_Left_Ov.bmp Mips=Off
//#exec Texture Import File=Book_Left_Dn.bmp Mips=Off
//#exec Texture Import File=Book_Left_Ds.bmp Mips=Off

//Right button
//#exec Texture Import File=Book_Right_Up.bmp Mips=Off
//#exec Texture Import File=Book_Right_Ov.bmp Mips=Off
//#exec Texture Import File=Book_Right_Dn.bmp Mips=Off
//#exec Texture Import File=Book_Right_Ds.bmp Mips=Off

//Back button
//#exec Texture Import File=Book_Back_Up.bmp Mips=Off
//#exec Texture Import File=Book_Back_Ov.bmp Mips=Off
//#exec Texture Import File=Book_Back_Dn.bmp Mips=Off

//Obj button
//#exec Texture Import File=Book_Obj_Up.bmp Mips=Off
//#exec Texture Import File=Book_Obj_Ov.bmp Mips=Off
//#exec Texture Import File=Book_Obj_Dn.bmp Mips=Off
//#exec Texture Import File=Book_Obj_Ds.bmp Mips=Off

//----------------------------------------------------------------------------

var ShellButton Buttons[4];

var ShellButton BackToGame;

var transient BookJournal Book;

var int MAX_VISIBLE_BOOKS;

var ShellButton ObjectivesButton;
var ShellButton JournalButtons[5];
var ShellLabelAutoWrap	BookTitles[5];
//var int FirstJournalId;

var float fExitDelay;
var int AmbientSoundID;

var() Color UnreadColor;
var() Color ReadColor;

//----------------------------------------------------------------------------

function Created()
{
	local int i;
	local color TextColor;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	Log("BookWindow: Created");

	Super.Created();
	
	AeonsRoot = AeonsRootWindow(Root);

	if ( AeonsRoot == None ) 
	{
		Log("AeonsRoot is Null!");
		return;
	}

	RootScaleX = AeonsRoot.ScaleX;
	RootScaleY = AeonsRoot.ScaleY;
	if (RootScaleX > RootScaleY) {
		RootScaleX = RootScaleY;
	} else {
		RootScaleY = RootScaleX;
	}
	
	Buttons[0] = ShellButton(CreateWindow(class'ShellButton', 28*RootScaleX, 10*RootScaleY, 78*RootScaleX, 59*RootScaleY));
	Buttons[1] = ShellButton(CreateWindow(class'ShellButton', 28*RootScaleX, 534*RootScaleY, 76*RootScaleX, 52*RootScaleY));
	Buttons[2] = ShellButton(CreateWindow(class'ShellButton', 294*RootScaleX, 537*RootScaleY, 88*RootScaleX, 51*RootScaleY));
	Buttons[3] = ShellButton(CreateWindow(class'ShellButton', 486*RootScaleX, 537*RootScaleY, 88*RootScaleX, 51*RootScaleY));

	Buttons[0].Template = NewRegion(28,82,78,59);
	Buttons[1].Template = NewRegion(28,534,76,52);
	Buttons[2].Template = NewRegion(294,537,88,51);
	Buttons[3].Template = NewRegion(486,537,88,51);

	for ( i=0; i<4; i++ )
	{
		Buttons[i].Manager = Self;
		Buttons[i].Text = "";
		Buttons[i].TextX = 0;
		Buttons[i].TextY = 0;
		TextColor.R = 255;
		TextColor.G = 255;
		TextColor.B = 255;
		Buttons[i].Style = 5;
		Buttons[i].SetTextColor(TextColor);
		Buttons[i].Font = 0;

		Buttons[i].OverSound = None;
		Buttons[i].DownSound = sound'Aeons.I_BookScroll01';
	}

	//Up
	Buttons[0].UpTexture		= texture'Book_Up_up';		
	Buttons[0].DownTexture		= texture'Book_Up_dn';		
	Buttons[0].OverTexture		= texture'Book_Up_ov';		
	Buttons[0].DisabledTexture	= texture'Book_Up_ds';		
	Buttons[0].bRepeat = True;

	Buttons[0].TexCoords.X = 0;
	Buttons[0].TexCoords.Y = 0;
	Buttons[0].TexCoords.W = 78;
	Buttons[0].TexCoords.H = 59;

	//Down
	Buttons[1].UpTexture		= texture'Book_Down_up';		
	Buttons[1].DownTexture		= texture'Book_Down_dn';		
	Buttons[1].OverTexture		= texture'Book_Down_ov';		
	Buttons[1].DisabledTexture	= texture'Book_Down_ds';		
	Buttons[1].bRepeat = True;
	
	Buttons[1].TexCoords.X = 0;
	Buttons[1].TexCoords.Y = 0;
	Buttons[1].TexCoords.W = 76;
	Buttons[1].TexCoords.H = 52;


	//Left
	Buttons[2].DownSound = None; 

	Buttons[2].UpTexture =   texture'Book_Left_up';
	Buttons[2].DownTexture = texture'Book_Left_dn';
	Buttons[2].OverTexture = texture'Book_Left_ov';
	Buttons[2].DisabledTexture = None;

	Buttons[2].TexCoords = NewRegion(0,0,88,51);


	//Right
	Buttons[3].DownSound = None; 

	Buttons[3].UpTexture =   texture'Book_Right_up';		
	Buttons[3].DownTexture = texture'Book_Right_dn';		
	Buttons[3].OverTexture = texture'Book_Right_ov';		
	Buttons[3].DisabledTexture = None;

	Buttons[3].TexCoords = NewRegion(0,8,88,51);


// create buttons down left side for player to click on 
	for ( i=0; i<MAX_VISIBLE_BOOKS; i++ )
	{
		JournalButtons[i] = ShellButton(CreateWindow(class'ShellButton', 32*RootScaleX, (124+100*i)*RootScaleY, 64*RootScaleX, 64*RootScaleY));

		JournalButtons[i].Template = NewRegion(32,124+100*i,64,64);

		JournalButtons[i].Style = 5;
		JournalButtons[i].Manager = Self;
		JournalButtons[i].Text = "";
		TextColor.R = 255;
		TextColor.G = 255;
		TextColor.B = 255;
		JournalButtons[i].SetTextColor(TextColor);
		JournalButtons[i].Font = 0;

		JournalButtons[i].OverSound = None;
		JournalButtons[i].DownSound = sound'Aeons.I_BookSelect01';

		JournalButtons[i].UpTexture =  texture'Book02_Icon';		
		JournalButtons[i].DownTexture = texture'Book02_Icon';		
		JournalButtons[i].OverTexture = texture'Book02_Icon';		
		JournalButtons[i].DisabledTexture = None;

		JournalButtons[i].TexCoords = NewRegion( 0,0,64,64);

		JournalButtons[i].HideWindow();

		BookTitles[i] = ShellLabelAutoWrap(CreateWindow(class'ShellLabelAutoWrap', 16*RootScaleX, (184+100*i)*RootScaleY, 96*RootScaleX, 48*RootScaleY));

		BookTitles[i].Template=NewRegion(16, 184+100*i, 96, 48);
		BookTitles[i].Manager = Self;
		BookTitles[i].Text = "Book Title";
		BookTitles[i].TextStyle = 3;
		TextColor.R = 192;
		TextColor.G = 192;
		TextColor.B = 192;
		BookTitles[i].SetTextColor(TextColor);
		BookTitles[i].Font = 0;
		BookTitles[i].Align = TA_Center;

		BookTitles[i].HideWindow();
	}


// Back To Game
	BackToGame = ShellButton(CreateWindow(class'ShellButton', 10,10,10,10));

	BackToGame.TexCoords = NewRegion(0,0,160,64);

	BackToGame.Template = NewRegion(630,535,160,64);

	BackToGame.Manager = Self;
	BackToGame.Style=5;

	BackToGame.UpTexture   = texture'Book_Back_Up';
	BackToGame.DownTexture = texture'Book_Back_Dn';
	BackToGame.OverTexture = texture'Book_Back_Ov';

	BackToGame.bBurnable = true;
	BackToGame.OverSound=sound'Aeons.Shell_Blacken01';

// Objectives
	ObjectivesButton = ShellButton(CreateWindow(class'ShellButton', 30*RootScaleX, 66*RootScaleY, 73*RootScaleX, 54*RootScaleY));

	ObjectivesButton.TexCoords = NewRegion( 0,0,73,54);

	// position and size in designed resolution of 800x600
	ObjectivesButton.Template = NewRegion(30,10,73,54);

	ObjectivesButton.Manager = Self;
	ObjectivesButton.Text = "";
	TextColor.R = 255;
	TextColor.G = 255;
	TextColor.B = 255;
	ObjectivesButton.Style = 5;
	ObjectivesButton.SetTextColor(TextColor);
	ObjectivesButton.Font = 0;

	//Objectives.bBurnable = true;

	ObjectivesButton.UpTexture			= texture'Book_Obj_up';
	ObjectivesButton.DownTexture		= texture'Book_Obj_dn';
	ObjectivesButton.OverTexture		= texture'Book_Obj_ov';
	ObjectivesButton.DisabledTexture	= texture'Book_Obj_ds';

	ObjectivesButton.DownSound = sound'Aeons.I_BookSelect01';



	if ( GetPlayerOwner() != None )
	{
		if ( AeonsPlayer(GetPlayerOwner()) != None )
		{
			book = BookJournal(AeonsPlayer(GetPlayerOwner()).Book);
			if ( book == none )
			{
				Log("Book==None in BookWindow!  Wrong class perhaps?");
			}
		}
	}

	Book.FirstJournalId = Book.NumJournals-1;
	RefreshButtons();

	Root.Console.bBlackout = True;

	Resized();
}

//----------------------------------------------------------------------------

function NotifyBeforeLevelChange()
{
	Super.NotifyBeforeLevelChange();	
	// we have to break this connection manually so garbage-collection doesn't freak out
	Book = None;
}

//----------------------------------------------------------------------------

function Tick(float Delta) 
{
	if ( fExitDelay > 0.0 ) 
	{
		fExitDelay -= Delta;

		if ( fExitDelay <= 0.0 )
			HideWindow();

	}

}

//----------------------------------------------------------------------------

function Message(UWindowWindow B, byte E)
{
	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			switch (B)
			{
				case Buttons[0]:
					ScrollUp();
					break;

				case Buttons[1]:
					ScrollDown();
					break;	

				case Buttons[2]:

					PrevPagePressed();

					if ( FRand() < 0.5 )
						GetPlayerOwner().PlaySound( sound'Aeons.I_BookPageTurn01',SLOT_Misc, [Flags]482  );
					else
						GetPlayerOwner().PlaySound( sound'Aeons.I_BookPageTurn02',SLOT_Misc, [Flags]482   );
					
					break;

				case Buttons[3]:
					
					NextPagePressed();

					if ( FRand() < 0.5 )
						GetPlayerOwner().PlaySound( sound'Aeons.I_BookPageTurn01',SLOT_Misc, [Flags]482   );
					else
						GetPlayerOwner().PlaySound( sound'Aeons.I_BookPageTurn02',SLOT_Misc, [Flags]482   );
					
					break;

				case JournalButtons[0]:
					if ((book != None)&&(book.GetJournalEntry(Book.FirstJournalId) != None))
					{
						book.CurrentJournalIndex = Book.FirstJournalId;//VisibleJournals[0];
						book.RefreshPages();
						RefreshButtons();						
					}
					break;

				case JournalButtons[1]:
					if ((book != None)&&(book.GetJournalEntry(Book.FirstJournalId-1) != None)) 
					{
						book.CurrentJournalIndex = Book.FirstJournalId-1;
						book.RefreshPages();
						RefreshButtons();						
					}
					break;

				case JournalButtons[2]:
					if ((book != None)&&(book.GetJournalEntry(Book.FirstJournalId-2) != None))
					{
						book.CurrentJournalIndex = Book.FirstJournalId-2;
						book.RefreshPages();
						RefreshButtons();						
					}
					break;

				case JournalButtons[3]:
					if ((book != None)&&(book.GetJournalEntry(Book.FirstJournalId-3) != None))
					{
						book.CurrentJournalIndex = Book.FirstJournalId-3;
						book.RefreshPages();
						RefreshButtons();						
					}
					break;

				
				case JournalButtons[4]:
					if ((book != None)&&(book.GetJournalEntry(Book.FirstJournalId-4) != None))
					{
						book.CurrentJournalIndex = Book.FirstJournalId-4;
						book.RefreshPages();
						RefreshButtons();						
					}
					break;

				case ObjectivesButton:
					book.CurrentJournalIndex = -1;
					book.RefreshPages();
					RefreshButtons();
					break;

				case BackToGame:
					BackPressed();
			}
			break;

		case DE_Change:
			switch (B)
			{
			}
			break;
	}
}

//----------------------------------------------------------------------------

function BackPressed()
{
	PlayNewScreenSound(); //PlayExitSound();
	Close(); 
}

//----------------------------------------------------------------------------

function ScrollUp()
{
	local int i;

	if ( Book.FirstJournalId < Book.NumJournals-1 ) 
		Book.FirstJournalId++;

	RefreshButtons();
}

//----------------------------------------------------------------------------

function ScrollDown()
{
	local int i;

	if ( Book == None )
		return;

	if ( Book.FirstJournalId >= MAX_VISIBLE_BOOKS ) 
		Book.FirstJournalId--;

	RefreshButtons();
}

//----------------------------------------------------------------------------

function PrevPagePressed()
{
	local JournalEntry TempEntry;
	local int TempCharOffset;

	if ( Book == None )
		return;

	TempEntry = Book.GetJournalEntry(Book.CurrentJournalIndex);

	if ( TempEntry == None ) 
		return;

	if  ( TempEntry.CurrentPage > 0 ) 
		TempEntry.CurrentPage--;

	book.RefreshPages();
	RefreshButtons();
}

//----------------------------------------------------------------------------

function NextPagePressed()
{
	local JournalEntry TempEntry;
	
	if ( Book == None )
		return;

	TempEntry = Book.GetJournalEntry(Book.CurrentJournalIndex);

	if ( TempEntry == None ) 
		return;

	if ( TempEntry.CurrentPage < TempEntry.NumPages - 1 )
		TempEntry.CurrentPage++;

	book.RefreshPages();
	RefreshButtons();
}


function RefreshButtons()
{
	local int i;
	local JournalEntry TempEntry;

	if ( Book == None )
		return;

	if ( Book.FirstJournalId < Book.NumJournals-1 )
	{
		Buttons[0].bDisabled = false;
		//Buttons[0].ShowWindow();
	}
	else
	{
		Buttons[0].bDisabled = true;
		//Buttons[0].HideWindow();
	}


	if ( Book.FirstJournalId >= MAX_VISIBLE_BOOKS )
	{
		Buttons[1].bDisabled = false;
		//Buttons[1].ShowWindow();		
	}
	else
	{
		Buttons[1].bDisabled = true;
		//Buttons[1].HideWindow();
	}

	TempEntry = Book.GetJournalEntry(Book.CurrentJournalIndex);

	if ( TempEntry == None )
		return;
		
	//Log("CurrentPage=" $ TempEntry.CurrentPage $ " NumPages=" $ TempEntry.NumPages);

	// Check to see if we need to hide or show the PrevPage / NextPage buttons
	if ( TempEntry.CurrentPage == 0 ) 
	{
		//log("RefreshButtons: CurrentPage=0, hiding button 2");
		Buttons[2].HideWindow();
	}
	else 
	{
		//log("RefreshButtons: CurrentPage!=0, showing button 2");
		Buttons[2].ShowWindow();
	}

	if ( TempEntry.CurrentPage == (TempEntry.NumPages-1) )
	{
		//log("RefreshButtons: CurrentPage==numpages-1, hiding button 3");
		Buttons[3].HideWindow();
	}
	else
	{
		//log("RefreshButtons: CurrentPage!=numpages-1, showing button 3");
		Buttons[3].ShowWindow();
	}

	for ( i = Book.FirstJournalId; i > Book.FirstJournalId - MAX_VISIBLE_BOOKS; i-- )
	{

		if ( i >= 0 && Book.GetJournalEntry(i) != None )
		{
			JournalButtons[Book.FirstJournalId-i].OverTexture= Book.GetJournalEntry(i).Icon;
			JournalButtons[Book.FirstJournalId-i].UpTexture	= Book.GetJournalEntry(i).Icon;
			JournalButtons[Book.FirstJournalId-i].DownTexture= Book.GetJournalEntry(i).Icon;
			//Log("JournalButtons[" $ i $  "] texture = " $ Book.GetJournalEntry(i).Icon);

			JournalButtons[Book.FirstJournalId-i].ShowWindow();
			BooKTitles[Book.FirstJournalId-i].Text = Book.GetJournalEntry(i).Title;

			if ( Book.GetJournalEntry(i).bRead )
				BooKTitles[Book.FirstJournalId-i].TextColor = ReadColor;
			else
				BooKTitles[Book.FirstJournalId-i].TextColor = UnreadColor;

			BookTitles[Book.FirstJournalId-i].ShowWindow();
		}
		else
		{
			//JournalButtons[FirstJournalId-i].UpTexture = None;
			//JournalButtons[FirstJournalId-i].DownTexture = None;
			//JournalButtons[FirstJournalId-i].OverTexture = None;
			//Log("GetJournalEntry("$i$") == None!");
			JournalButtons[Book.FirstJournalId-i].HideWindow();
			BookTitles[Book.FirstJournalId-i].HideWindow();
		}
	}
}

//----------------------------------------------------------------------------

function BeforePaint(Canvas C, float X, float Y)
{
	local JournalEntry TempEntry;

	Super.BeforePaint(C, X, Y);

	if ( Book == None )
		return;

	TempEntry = Book.GetJournalEntry(Book.CurrentJournalIndex);

	if ( TempEntry == None ) 
		return;

	// Check to see if we need to hide or show the PrevPage / NextPage buttons
	if ( TempEntry.CurrentPage == 0 ) 
	{
		Buttons[2].HideWindow();
	}
	else 
	{
		Buttons[2].ShowWindow();
	}

	if ( TempEntry.CurrentPage == (TempEntry.NumPages-1) )
	{
		Buttons[3].HideWindow();
	}
	else
	{
		Buttons[3].ShowWindow();
	}

}

//----------------------------------------------------------------------------

function Paint(Canvas C, float X, float Y)
{
	local int i;
	local PlayerPawn P; 
	local int SwirlX, SwirlY;
	local int JournalDelta;
  	local float RootScaleX, RootScaleY;

	if ( ( Root != None ) && (AeonsRootWindow(Root)!=None) )
	{
		RootScaleX = AeonsRootWindow(Root).ScaleX;
		RootScaleY = AeonsRootWindow(Root).ScaleY;
	}
	else
	{
		RootScaleX = 1.0;
		RootScaleY = 1.0;
	}

	if (RootScaleX > RootScaleY) {
		RootScaleX = RootScaleY;
	} else {
		RootScaleY = RootScaleX;
	}

	//log("BookWindow: Paint");

	Super.Paint(C, X, Y);

	JournalDelta = Book.FirstJournalId-book.CurrentJournalIndex;
	
	if ( (book.CurrentJournalIndex >= 0) && (Book.FirstJournalId >= 0) && (JournalDelta >= 0 && JournalDelta<=(MAX_VISIBLE_BOOKS-1)) ) 
	{
		SwirlX = JournalButtons[ JournalDelta ].WinLeft-10*RootScaleX;
		SwirlY = JournalButtons[ JournalDelta ].WinTop-10*RootScaleY;

		C.SetPos(SwirlX,SwirlY);
		C.DrawColor.r = 192;
		C.DrawColor.g = 192;
		C.DrawColor.b = 192;
		C.Style = 3;

		//BackLayer = FireTexture'FX.Swirl';		
		C.DrawTileClipped(FireTexture'FX.Swirl', 84*RootScaleX, 84*RootScaleY, 0, 0, 64, 64);
	}
	
	P = GetPlayerOwner();

	if ( AmbientSoundID == 0 )
		AmbientSoundID = GetPlayerOwner().PlaySound( Sound(DynamicLoadObject("Shell_HUD.Shell_BookAmb", class'Sound')), SLOT_None, 0.5, true, 1600.0, 1.0, 491 );	

	if ((P != None)&&(AeonsPlayer(P) != None))
		Book = BookJournal(AeonsPlayer(P).Book);

	if (Book != None)
	{	
		if(book.bDisplay3D)
		{
			//P = GetPlayerOwner();
			
			if ( P != None ) 
			{
				OldFov = P.FOVAngle;
				P.SetFOVAngle(90);
				DrawClippedActor( C, InnerWidth/2, InnerHeight/2, book, False, book.BookRotation, book.BookOffset );//rot(32767,16300,16300), vect(35, 6, 1) ); // (33,2,0)
				P.SetFOVAngle(OldFov);
			}
		}
		else
		{
			// should assert here		
		}

	}
	else 
	{
		//fix redundant ?
		Book = BookJournal(AeonsPlayer(GetPlayerOwner()).Book);

		RefreshButtons();
	}

	C.DrawColor = C.Default.DrawColor;

}



function Close(optional bool bByParent)
{
	if ( fExitDelay <= 0.0 )
	{
		if ( FRand() < 0.5 )
			GetPlayerOwner().PlaySound( sound'Aeons.I_BookClose01' ,SLOT_Misc, [Flags]482  );
		else
			GetPlayerOwner().PlaySound( sound'Aeons.I_BookClose02',SLOT_Misc, [Flags]482   );

		fExitDelay = 0.25;
	}
}


function ShowWindow()
{
	local int i;

	//log("BookWindow: ShowWindow");
	Super.ShowWindow();

	Root.Console.bLocked = True;

	if ( FRand() < 0.5 )
		GetPlayerOwner().PlaySound( sound'Aeons.I_BookOpen01',SLOT_Misc, [Flags]482   );
	else
		GetPlayerOwner().PlaySound( sound'Aeons.I_BookOpen02',SLOT_Misc, [Flags]482  );

	Book = BookJournal(AeonsPlayer(GetPlayerOwner()).Book);

	//Log("ShowWindow");

	if ( book != none ) 
	{
		Book.UpdateObjectives();
		Book.FirstJournalId = Book.NumJournals-1;
		Book.RefreshPages();
		RefreshButtons();
	}
	else
	{
		Log("Book==None in BookWindow!  Wrong class perhaps?");
	}

}

//----------------------------------------------------------------------------

function HideTest()
{
	Super.HideWindow();
}

//----------------------------------------------------------------------------

function HideWindow()
{
	if ( AmbientSoundID != 0 )
	{
		GetPlayerOwner().StopSound(AmbientSoundID);
		AmbientSoundID = 0;
	}

	Root.Console.bBlackOut = False;
	Super.HideWindow();
	AeonsRootWindow(Root).MainMenu.ShowWindow();
	Root.Console.bLocked = False;
	Root.Console.CloseUWindow();
}

//----------------------------------------------------------------------------

function Resized()
{
	local int W, H, XMod, YMod, i;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	Super.Resized();

	AeonsRoot = AeonsRootWindow(Root);

	if (AeonsRoot != None)
	{
		RootScaleX = AeonsRoot.ScaleX;
		RootScaleY = AeonsRoot.ScaleY;
	}
	else
	{
		RootScaleX = 1.0;	
		RootScaleY = 1.0;
	}

	if (RootScaleX > RootScaleY) {
		RootScaleX = RootScaleY;
	} else {
		RootScaleY = RootScaleX;
	}

	for ( i=0; i<4; i++ )
	{
		Buttons[i].ManagerResized(RootScaleX, RootScaleY);
	}

	for ( i=0; i<MAX_VISIBLE_BOOKS; i++ )
	{
		JournalButtons[i].ManagerResized(RootScaleX, RootScaleY);
		BookTitles[i].ManagerResized(RootScaleX, RootScaleY);
	}

	BackToGame.ManagerResized(RootScaleX, RootScaleY);

	ObjectivesButton.ManagerResized(RootScaleX, RootScaleY);
}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     MAX_VISIBLE_BOOKS=4
     UnreadColor=(R=255,G=255,B=255)
     ReadColor=(R=25,G=25,B=255)
     BackNames(0)="UndyingShellPC.Book_0"
     BackNames(1)="UndyingShellPC.Book_1"
     BackNames(2)="UndyingShellPC.Book_2"
     BackNames(3)="UndyingShellPC.Book_3"
     BackNames(4)="UndyingShellPC.Book_4"
     BackNames(5)="UndyingShellPC.Book_5"
}
