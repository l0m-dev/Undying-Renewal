//=============================================================================
// LoadSaveWindow.
//=============================================================================
class LoadSaveWindow expands ShellWindow;

//#exec Texture Import File=LoadSave_0.bmp Mips=Off
//#exec Texture Import File=LoadSave_1.bmp Mips=Off
//#exec Texture Import File=LoadSave_2.bmp Mips=Off
//#exec Texture Import File=LoadSave_3.bmp Mips=Off
//#exec Texture Import File=LoadSave_4.bmp Mips=Off
//#exec Texture Import File=LoadSave_5.bmp Mips=Off

//#exec Texture Import File=sload_cancel_dn.bmp	Mips=Off
//#exec Texture Import File=sload_cancel_ov.bmp	Mips=Off
//#exec Texture Import File=sload_cancel_up.bmp	Mips=Off
//#exec Texture Import File=sload_delete_dn.bmp	Mips=Off
//#exec Texture Import File=sload_delete_ov.bmp	Mips=Off
//#exec Texture Import File=sload_delete_up.bmp	Mips=Off
//#exec Texture Import File=sload_delete_ds.bmp	Mips=Off
//#exec Texture Import File=sload_load_dn.bmp		Mips=Off
//#exec Texture Import File=sload_load_ov.bmp		Mips=Off
//#exec Texture Import File=sload_load_up.bmp		Mips=Off
//#exec Texture Import File=sload_load_ds.bmp		Mips=Off
//#exec Texture Import File=sload_save_dn.bmp		Mips=Off
//#exec Texture Import File=sload_save_ov.bmp		Mips=Off
//#exec Texture Import File=sload_save_up.bmp		Mips=Off
//#exec Texture Import File=sload_save_ds.bmp		Mips=Off

//Dynamic #exec Texture Import File=Black.tga	Mips=Off
//Dynamic #exec Texture Import File=Screenshot4.tga	Mips=Off


var string ScreenShotName;
var ShellBitmap ScreenShot;

var ShellButton SaveGameButtons[10];

var ShellButton Cancel;
var ShellButton Load;
var ShellButton Save;
var ShellButton Delete;

var UWindowWindow Confirm;

var string SaveList;
var string SaveStrings[10];
var string MapNames[10];

var int Slots[10];
var int FreeSlot;

var int		SmokingWindows[4];
var float	SmokingTimers[4];

// index of selected button in button array, -1 = no selection
var int SelectedSlot;

var bool RememberBootShell;

//----------------------------------------------------------------------------

function Created()
{
	local int i;
	local color TextColor;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	Super.Created();
	
	AeonsRoot = AeonsRootWindow(Root);

	if ( AeonsRoot == None ) 
	{
		Log("AeonsRoot is Null!");
		return;
	}

	RootScaleX = AeonsRoot.ScaleX;
	RootScaleY = AeonsRoot.ScaleY;


// Save buttons
	for( i=0; i<ArrayCount(SaveGameButtons); i++ )
	{
		SaveGameButtons[i] = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));

		SaveGameButtons[i].Template = NewRegion(283, 225+31*i,420,31);

		SaveGameButtons[i].Manager = Self;
		SaveGameButtons[i].Align = TA_Left;
		SaveGameButtons[i].Text = "";
		SaveGameButtons[i].TextX = 0;
		SaveGameButtons[i].TextY = 0;
		
		SaveGameButtons[i].TextStyle = 5;
		
		TextColor.R = 102;
		TextColor.G = 0;
		TextColor.B = 0;
	
		SaveGameButtons[i].SetTextColor(TextColor);
		SaveGameButtons[i].Font = 3;
	
		//SaveGameButtons[i].UpTexture =		texture'Engine.DefaultTexture';
		//SaveGameButtons[i].TexCoords = NewRegion(0,0,64,64);
	}


// Cancel Button
	Cancel = ShellButton(CreateWindow(class'ShellButton', 48*RootScaleX, 500*RootScaleY, 160*RootScaleX, 64*RootScaleY));

	Cancel.TexCoords = NewRegion(0, 0, 160, 64);

	// position and size in designed resolution of 800x600
	Cancel.Template = NewRegion(33,506,160,64);

	Cancel.Manager = Self;

	Cancel.bBurnable = true;
	Cancel.Style = 5;

	Cancel.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Cancel.UpTexture =   texture'sload_cancel_up';
	Cancel.DownTexture = texture'sload_cancel_dn';
	Cancel.OverTexture = texture'sload_cancel_ov';
	Cancel.DisabledTexture = None;


// Load Button
	Load = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));

	Load.TexCoords = NewRegion(0, 0, 160, 64);

	// position and size in designed resolution of 800x600
	Load.Template = NewRegion(40,193,160,64);

	Load.Manager = Self;

	Load.bBurnable = true;
	Load.Style = 5;

	Load.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Load.UpTexture =   texture'sload_Load_up';
	Load.DownTexture = texture'sload_Load_dn';
	Load.OverTexture = texture'sload_Load_ov';
	Load.DisabledTexture = texture'sload_Load_dn';

// Save Button
	Save = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));

	Save.TexCoords = NewRegion(0, 0, 160, 64);

	// position and size in designed resolution of 800x600
	Save.Template = NewRegion(43,114,160,64);

	Save.Manager = Self;

	Save.bBurnable = true;
	Save.Style = 5;

	Save.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Save.UpTexture =   texture'sload_Save_up';
	Save.DownTexture = texture'sload_Save_dn';
	Save.OverTexture = texture'sload_Save_ov';
	Save.DisabledTexture = texture'sload_Save_dn';

// Delete Button
	Delete = ShellButton(CreateWindow(class'ShellButton', 10, 10, 10, 10));

	Delete.TexCoords = NewRegion(0, 0, 160, 64);

	// position and size in designed resolution of 800x600
	Delete.Template = NewRegion(41,306,160,64);

	Delete.Manager = Self;

	Delete.bBurnable = true;
	Delete.Style = 5;

	Delete.OverSound=sound'Shell_HUD.Shell_Blacken01';	

	Delete.UpTexture =   texture'sload_Delete_up';
	Delete.DownTexture = texture'sload_Delete_dn';
	Delete.OverTexture = texture'sload_Delete_ov';
	Delete.DisabledTexture = texture'sload_Delete_dn';

//screenshot
	ScreenShot = ShellBitmap(CreateWindow(class'ShellBitmap', 10,10,10,10));
	ScreenShot.T = None;//Dynamic texture'Black';//Screenshot3';
	ScreenShot.R = NewRegion(0,0,116,88);//Dynamic 256,256);
	ScreenShot.Template = NewRegion(425,46,116,88);
	ScreenShot.bStretch = true;

	SelectedSlot = -1;

	UpdateButtons();

	Root.Console.bBlackout = True;

	Resized();
}

//----------------------------------------------------------------------------

function Message(UWindowWindow B, byte E)
{
	if ( (ShellButton(B) != None) && ShellButton(B).bDisabled ) 
		return;

	switch (E)
	{
		case DE_DoubleClick:
		case DE_Click:
			switch (B)
			{
				case Cancel:
					Close();
					break;

				case Load: 
					LoadPressed();
					break;

				case Save: 
					//AeonsHud(GetPlayerOwner().myHud).testSaveShot();
					SavePressed();
					break;

				case Delete: 
					DeletePressed();
					break;

				case SaveGameButtons[0]:
					SelectSlot(0);
					break;

				case SaveGameButtons[1]:
					SelectSlot(1);
					break;

				case SaveGameButtons[2]:
					SelectSlot(2);
					break;

				case SaveGameButtons[3]:
					SelectSlot(3);
					break;

				case SaveGameButtons[4]:
					SelectSlot(4);
					break;

				case SaveGameButtons[5]:
					SelectSlot(5);
					break;

				case SaveGameButtons[6]:
					SelectSlot(6);
					break;

				case SaveGameButtons[7]:
					SelectSlot(7);
					break;

				case SaveGameButtons[8]:
					SelectSlot(8);
					break;

				case SaveGameButtons[9]:
					SelectSlot(9);
					break;
			}
			break;

		case DE_Change:
			switch (B)
			{
			}
			break;

		case DE_MouseEnter:
			OverEffect(ShellButton(B));
			break;

	}
}

//----------------------------------------------------------------------------

function OverEffect(ShellButton B)
{
	switch (B) 
	{
		case Save:
			SmokingWindows[0] = 1;
			SmokingTimers[0] = 90;
			break;

		case Load:
			SmokingWindows[1] = 1;
			SmokingTimers[1] = 90;
			break;

		case Delete: 
			SmokingWindows[2] = 1;
			SmokingTimers[2] = 90;
			break;

		case Cancel: 
			SmokingWindows[3] = 1;
			SmokingTimers[3] = 90;
			break;

	}
}

//----------------------------------------------------------------------------

function SelectSlot( int Slot ) 
{
	SelectedSlot = Slot;

/*
	//fix this will break when E m p t y is localized
	if ( Slots[SelectedSlot] >= 0 )//Left(SaveGameButtons[Slot].Text, 1) == "E" )
	{
		//dynamic GetPlayerOwner().LoadTextureFromBMP(texture'Screenshot4', "..\\save\\" $ Slots[SelectedSLot] $ "\\save.bmp");
		//dynamic ScreenShot.T = texture'Screenshot4';
		Load.bDisabled = false;
	}
	else
	{
		//dynamic ScreenShot.T = texture'Black';
		Delete.bDisabled = false;
		Save.bDisabled = false;
		Load.bDisabled = false;
	}

	// you can't save over quicksave slot since the only way we distinguish between quicksave and others 
	// is that the quicksave is always slot 0
	if ( Slots[SelectedSlot] == 0 ) 
		Save.bDisabled = true;
*/

	MapNametoScreenShot( MapNames[SelectedSlot] );
	

/*
	Delete.bDisabled = false;
	Save.bDisabled = false;
	Load.bDisabled = false;
*/

//	SaveGameButtons[Slot].UpTexture = texture'Aeons.cntrl_selec';
}

//----------------------------------------------------------------------------

function ShowConfirm(UwindowWindow W)
{
	if (Confirm == None ) 
		Confirm = ManagerWindow(Root.CreateWindow(class'ConfirmWindow', 0, 0, 200, 200, Root, True));

	Confirm.ShowWindow();		
	ConfirmWindow(Confirm).Owner = self;
	ConfirmWindow(Confirm).QuestionWindow = W;
}

//----------------------------------------------------------------------------

function DoSave()
{
	local int SaveSlot;
	local int token;
	
	if ( SelectedSlot < 0 ) 
		return;

	Log("DoSave");

	//AeonsHud(GetPlayerOwner().myHud).testSaveShot();

	PlayNewScreenSound();

	SaveSlot = -1;

	if ( Slots[SelectedSlot] >= 0 ) 
		SaveSlot = Slots[SelectedSlot];
	else if ( FreeSlot >= 0 )
		SaveSlot = FreeSlot;

	Close();
	ParentWindow.Close();
	AeonsRootWindow(Root).MainMenu.Close();

	if ( SaveSlot >= 0 )
	{
		//log("calling SaveGame " $ SaveSlot );
		GetPlayerOwner().ConsoleCommand("SaveGame " $ SaveSlot);	
	}
	else
	{
		Log(" invalid save game slot: " $ Slots[SelectedSlot] );
	}

}

//----------------------------------------------------------------------------

function DoDelete()
{
	if (SelectedSlot >= 0)
	{
		GetPlayerOwner().ConsoleCommand("DeleteGame " $ Slots[SelectedSlot]);	
		UpdateButtons();
	}
	else
		Log("LoadSaveWindow: DoDelete: invalid slot " $ SelectedSlot);
}

//----------------------------------------------------------------------------

function DoLoad()
{
	local int slot;

	Log("doLoad");
	
	if ( SelectedSlot < 0 ) 
		return;
	
	slot = Slots[SelectedSlot];

	PlayNewScreenSound();

	Close();
	ParentWindow.Close();
	AeonsRootWindow(Root).MainMenu.Close();

	if ( slot >= 0 )
	{
		log("calling LoadGame " $ slot );
		GetPlayerOwner().ConsoleCommand("LoadGame " $ slot);	
	}
	else
	{
		Log(" invalid save game slot: " $ slot );
	}
}

//----------------------------------------------------------------------------

function LoadPressed()
{
	RememberBootShell = GetPlayerOwner().Level.bLoadBootShellPSX2;

	GetPlayerOwner().Level.bLoadBootShellPSX2 = false;	
	ShowConfirm(Load);
}

//----------------------------------------------------------------------------

function SavePressed()
{
	Log("SavePressed");
/*
	if (Confirm == None ) 
		Confirm = ManagerWindow(Root.CreateWindow(class'ConfirmWindow', 0, 0, 200, 200, Root, True));
	else
	{
		Confirm.ShowWindow();		
		ConfirmWindow(Confirm).Owner = self;
		QuestionWindow = Save;
	}	
*/
	ShowConfirm(Save);
}

//----------------------------------------------------------------------------

function DeletePressed()
{
	Log("DeletePressed");
	// check to see if we have a selected slot
	ShowConfirm(Delete);
}

//----------------------------------------------------------------------------

function BeforePaint(Canvas C, float X, float Y)
{
	local int I;
	local color TextColor;
	
	Super.BeforePaint(C, X, Y);
	
	for( i=0; i<ArrayCount(SaveGameButtons); i++ )
	{
		if (AeonsHUd(GetPlayerOwner().MyHud).CanvasWidth < 1920)
		{
			TextColor.R = 255;
			TextColor.G = 255;
			TextColor.B = 255;
		}
		else
		{
			TextColor.R = 255;
			TextColor.G = 255;
			TextColor.B = 255;
		}
		
		SaveGameButtons[i].SetTextColor(TextColor);
	}
	
	// if a slot is selected
	if ( SelectedSlot >= 0 ) 
	{
		// map our slot to the actual save game slot

		// if slot is empty
		if ( Slots[SelectedSlot] < 0 )
		{
			Save.bDisabled = false;
			Delete.bDisabled = true;
			Load.bDisabled = true;
		}
		// else if it's a quicksave
		else if ( Slots[SelectedSlot] == 0 )
		{
			Delete.bDisabled = false;
			Save.bDisabled = true;
			Load.bDisabled = false;
		}
		else
		{
			Delete.bDisabled = false;
			Save.bDisabled = false;
			Load.bDisabled = false;
		}
	}
	else
	{
		//Dynamic Screenshot.T = Texture'Black';
		Delete.bDisabled = true;
		Save.bDisabled = true;
		Load.bDisabled = true;
	}

	// if we're in the boot level, we can't save since it's only to show the shell
	if ( GetPlayerOwner().Level.bLoadBootShellPSX2 )
	{
		Save.bDisabled = true;
	}
}

//----------------------------------------------------------------------------

function Paint(Canvas C, float X, float Y)
{
	local int W, H;
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;

	Super.Paint(C, X, Y);
	
	AeonsRoot = AeonsRootWindow(Root);

	if ( AeonsRoot == None ) 
	{
		Log("AeonsRoot is Null!");
		return;
	}

	RootScaleX = AeonsRoot.ScaleX;
	RootScaleY = AeonsRoot.ScaleY;

	if ( SelectedSlot >= 0 ) 
	{
		C.Style = 3;
		C.DrawColor.r = 255;
		C.DrawColor.g = 255;
		C.DrawColor.b = 255;
		C.DrawColor.a = 255;

		W = SaveGameButtons[SelectedSlot].WinWidth+20*RootScaleX;
		H = SaveGameButtons[SelectedSlot].WinHeight;
		X = SaveGameButtons[SelectedSlot].WinLeft-10*RootScaleX;
		Y = SaveGameButtons[SelectedSlot].WinTop;
		
		DrawStretchedTexture(C, X, Y, W, H, texture'Aeons.cntrl_selec');
		//DrawStretchedTexture(C, X, Y, W, H, texture'Aeons.Meshes.DispelFX');
	}
	else
	{
	}

	Super.PaintSmoke(C, Save, SmokingWindows[0], SmokingTimers[0]);
	Super.PaintSmoke(C, Load, SmokingWindows[1], SmokingTimers[1]);
	Super.PaintSmoke(C, Delete, SmokingWindows[2], SmokingTimers[2]);
	Super.PaintSmoke(C, Cancel, SmokingWindows[3], SmokingTimers[3]);

	/* Dynamic 
	{
		if ( SaveDelay == 0 ) 
		{
			DoSave();
			SaveDelay = -1;
			return;
		}

		if ( SaveDelay >= 1 ) 
			SaveDelay--;
	}
	*/
}

//----------------------------------------------------------------------------

function ParseSavedGameList( string LoadGameList )
{
	local int token;
	local int currentrow;
	local string CurrentSave;
	local string SaveString;
	local int i;
	
	SaveString = SaveList;

	token = InStr( SaveString, "?" );

	for ( i=0; i<ArrayCount(SaveStrings); i++ )
		SaveStrings[i] = "";

	i=0;
	while ( (token > 0) && (i<arraycount(SaveStrings)) )
	{		
		CurrentSave = Left(SaveString, token-1);			

		//log("token=" $ token $ " CurrentString=" $ CurrentSave);

		SaveString = Right( SaveString,  Len(SaveString)-token-1 );

		SaveStrings[i] = CurrentSave;//SaveString;
		//log("Savestrings[" $ i $ " ] = " $ SaveStrings[i]);

		i++;

		token = InStr(SaveString, "?");
	}
}

function MapNametoScreenShot(string MapName)
{
	if ( InStr(MapName, "Catacombs") >= 0 )
	{
		ScreenShotName = "Screens.Catacomb"; 
	}
	else if ( InStr(MapName, "Cemetery") >= 0 )
	{
		ScreenShotName = "Screens.Cemetery"; 
	}
	else if ( InStr(MapName, "Cottage") >= 0 )
	{
		ScreenShotName = "Screens.Cottage"; 
	}
	else if ( InStr(MapName, "Dock") >= 0 )
	{
		ScreenShotName = "Screens.Dock"; 
	}
	else if ( InStr(MapName, "Eternal") >= 0 )
	{
		ScreenShotName = "Screens.Eternal"; 
	}
	else if ( InStr(MapName, "Lighthouse") >= 0 )
	{
		ScreenShotName = "Screens.Lighthouse";
	}
	else if ( InStr(MapName, "Manor") >= 0 )
	{
		ScreenShotName = "Screens.Manor";
	}
	else if ( InStr(MapName, "Mausoleum") >= 0 )
	{
		ScreenShotName = "Screens.Mausoleum";
	}
	else if ( InStr(MapName, "Oneiros") >= 0 )
	{
		ScreenShotName = "Screens.Oneiros"; 
	}
	else if ( InStr(MapName, "Past") >= 0 )
	{
		ScreenShotName = "Screens.Past"; 
	}
	else if ( (InStr(MapName, "Pirate") >= 0) || (InStr(MapName, "Coastal") >= 0) )
	{
		ScreenShotName = "Screens.Pirate"; 
	}
	else if ( InStr(MapName, "Present") >= 0 )
	{
		ScreenShotName = "Screens.Present"; 
	}
	else if ( InStr(MapName, "Stone") >= 0 )
	{
		ScreenShotName = "Screens.Stone"; 
	}
	else
		ScreenShotName = "Screens.Generic"; 


	log("MapNametoScreenSHot: ScreenShotName = " $ ScreenShotName);
	ScreenShot.T = Texture(DynamicLoadObject(ScreenShotName, class'texture'));

	log("MapNametoScreenSHot: ScreenShot.T = " $ ScreenShot.T);

}

//----------------------------------------------------------------------------

function UpdateButtons()
{
	local int Token;
	local int i;
	local string Temp;
	local string SaveMap, SaveTime;

	SaveList = GetPlayerOwner().GetSaveGameList();
	
	// after this call SaveStrings are filled with each save's information
	ParseSavedGameList(SaveList);

	FreeSlot = -1;

	log("LoadSaveWindow: UpdateButtons: SaveList = " $ SaveList);

	for ( i=0; i<ArrayCount(SaveStrings); i++ )
	{
		//LoadGameButtons[i].Text = LoadStrings[i];
		Log("SaveString = " $ SaveStrings[i]);
		
		if ( SaveStrings[i] != "" )
		{
			Token = InStr(SaveStrings[i], ",");
			Temp = Left(SaveStrings[i], Token);
			//log("slot = " $ Temp);
			Slots[i] = int(Temp);

			// keep track of highest save slot
			if ( Slots[i] >= FreeSlot )
				FreeSlot = Slots[i] + 1;

			Temp = Right(SaveStrings[i], Len(SaveStrings[i])-Token-1);
			//log("rest of Savestring after slot = " $ Temp);

			Token = InStr(Temp, ",");
			SaveMap = Left(Temp, Token);

			//log("map name  = " $ SaveMap);

			SaveTime = Right(Temp, Len(Temp)-Token-1);

			//log("save time = " $ SaveTime);

			if ( Slots[i] == 0 ) 
				SaveGameButtons[i].Text = SaveTime $ "-Q-" $ SaveMap;
			else
				SaveGameButtons[i].Text = SaveTime $ "-" $ SaveMap;


			SaveGameButtons[i].Align = TA_Left;
			//SaveGameButtons[i].ShowWindow();
		}
		else
		{
			//log("Savestrings[" $ i $ " ] is empty " $ SaveStrings[i]);
			Slots[i] = -1;
			SaveGameButtons[i].Align = TA_Center;
			SaveGameButtons[i].Text = "E m p t y";
			//SaveGameButtons[i].HideWindow();

			SaveMap = "";
		}

		MapNames[i] = SaveMap;

		//Log("SaveGameButtons[" $ i $ "].Text=" $ SaveGameButtons[i].Text $ " Alignment=" $ SaveGameButtons[i].Align);
		
	}

	if ( FreeSlot < 0 ) 
		FreeSlot = 0;

}

//----------------------------------------------------------------------------

function ShowWindow()
{
	Super.ShowWindow();

	UpdateButtons();
}

//----------------------------------------------------------------------------

function Resized()
{
	local AeonsRootWindow AeonsRoot;
	local float RootScaleX, RootScaleY;
	local int i;

	Super.Resized();

	AeonsRoot = AeonsRootWindow(Root);

	if (AeonsRoot != None)
	{
		RootScaleX = AeonsRoot.ScaleX;
		RootScaleY = AeonsRoot.ScaleY;
	}
	else 
	{
		// nasty
		RootScaleX = 1.0;
		RootScaleY = 1.0;
	}

	for( i=0; i<ArrayCount(SaveGameButtons); i++ )
		SaveGameButtons[i].ManagerResized(RootScaleX, RootScaleY);

	Cancel.ManagerResized(RootScaleX, RootScaleY);
	Load.ManagerResized(RootScaleX, RootScaleY);
	Save.ManagerResized(RootScaleX, RootScaleY);
	Delete.ManagerResized(RootScaleX, RootScaleY);
	ScreenShot.ManagerResized(RootScaleX, RootScaleY);

	if ( Confirm != None ) 
		Confirm.Resized();
}

//----------------------------------------------------------------------------

function Close(optional bool bByParent)
{
	//fix probably should clear selected slot here or on reentrance
	HideWindow();
}

//----------------------------------------------------------------------------

function HideWindow()
{
	Super.HideWindow();

	Root.Console.bBlackOut = False;

	SelectedSlot = -1;
}

//----------------------------------------------------------------------------

function QuestionAnswered( UWindowWindow W, int Answer )
{
	local int slot;

	log("LoadSaveWindow: QuestionAnswered: W=" $ W $ " Answer=" $ Answer);

	switch( W ) 
	{
		case Load:
			// answered yes
			if ( Answer == 1 ) 
			{
				//GetPlayerOwner().Level.bLoadBootShellPSX2 = false;	
				DoLoad();
			}
			// answered no
			else
			{
				GetPlayerOwner().Level.bLoadBootShellPSX2 = RememberBootShell;
				RememberBootShell = false;
			}



			break;

		case Save: 
			if ( Answer == 1 ) 
			{
				DoSave();

				/* Dynamic 
				{
					//Dynamic SaveDelay=2;
					if ( (SelectedSlot >= 0) && (Slots[SelectedSlot] >= 0) )
						slot = Slots[SelectedSlot];
					else 
					{
						log("LoadSave: User confirmed save to EMPTY slot, slot = " $ FreeSlot);
						assert(FreeSlot >= 0);
						slot = FreeSlot;
					}
					AeonsHud(GetPlayerOwner().myHud).testSaveShot("..\\Save\\" $ Slot $ "\\Save.bmp");
					//AeonsPlayer(GetPlayerOwner()).SavePath = "..\\Save\\" $ Slots[SelectedSlot] $ "\\Save.bmp";
				}
				*/
			}
			break;

		case Delete:
			if ( Answer == 1 ) 
				DoDelete();
			break;
	}


}

//----------------------------------------------------------------------------
//	Default Properties
//----------------------------------------------------------------------------

defaultproperties
{
     BackNames(0)="UndyingShellPC.LoadSave_0"
     BackNames(1)="UndyingShellPC.LoadSave_1"
     BackNames(2)="UndyingShellPC.LoadSave_2"
     BackNames(3)="UndyingShellPC.LoadSave_3"
     BackNames(4)="UndyingShellPC.LoadSave_4"
     BackNames(5)="UndyingShellPC.LoadSave_5"
}
