class UMenuPulldownMenu extends UWindowPulldownMenu;


#exec TEXTURE IMPORT NAME=BMenuArea FILE=Textures\MenuArea.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuTL FILE=Textures\MenuTL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuT FILE=Textures\MenuT.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuTR FILE=Textures\MenuTR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuL FILE=Textures\MenuL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuR FILE=Textures\MenuR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuBL FILE=Textures\MenuBL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuB FILE=Textures\MenuB.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuBR FILE=Textures\MenuBR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuHL FILE=Textures\MenuHL.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuHM FILE=Textures\MenuHM.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=BMenuHR FILE=Textures\MenuHR.bmp GROUP="Icons" MIPS=OFF
#exec TEXTURE IMPORT NAME=MenuLine FILE=Textures\MenuLine.bmp GROUP="Icons" MIPS=OFF

#exec AUDIO IMPORT FILE="Sounds\littleselect.WAV" NAME="LittleSelect" GROUP="Menu"


var UWindowPulldownMenuItem OldSelected;

function Created()
{
	Super.Created();
	ItemHeight=16;
	VBorder = 4;
	HBorder = 3;
}

function Select(UWindowPulldownMenuItem I)
{
	Super.Select(I);
//	if(OldSelected != I && I != None && I.Caption != "-")
//		GetPlayerOwner().PlaySound(sound'LittleSelect');
	OldSelected = I;
}


function ExecuteItem(UWindowPulldownMenuItem I) 
{
	Super.ExecuteItem(I);
}

function DrawMenuBackground(Canvas C)
{
	DrawClippedTexture(C, 0, 0, Texture'UMenu.BMenuTL');
	DrawStretchedTexture(C, 4, 0, WinWidth-8, 4, Texture'UMenu.BMenuT');
	DrawClippedTexture(C, WinWidth-4, 0, Texture'UMenu.BMenuTR');


	DrawClippedTexture(C, 0, WinHeight-4, Texture'UMenu.BMenuBL');
	DrawStretchedTexture(C, 4, WinHeight-4, WinWidth-8, 4, Texture'UMenu.BMenuB');
	DrawClippedTexture(C, WinWidth-4, WinHeight-4, Texture'UMenu.BMenuBR');

	DrawStretchedTexture(C, 0, 4, 4, WinHeight-8, Texture'UMenu.BMenuL');
	DrawStretchedTexture(C, WinWidth-4, 4, 4, WinHeight-8, Texture'UMenu.BMenuR');

	DrawStretchedTexture(C, 4, 4, WinWidth-8, WinHeight-8, Texture'UMenu.BMenuArea');
}



function DrawItem(Canvas C, UWindowList Item, float X, float Y, float W, float H)
{
	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;

	UWindowPulldownMenuItem(Item).ItemTop = Y + WinTop;

	if(UWindowPulldownMenuItem(Item).Caption == "-")
	{
		C.DrawColor.R = 255;
		C.DrawColor.G = 255;
		C.DrawColor.B = 255;
		DrawStretchedTexture(C, X, Y+5, W, 2, Texture'UMenu.MenuLine');
		return;
	}

	C.Font = Root.Fonts[F_Normal];

	if(Selected == Item)
	{
		DrawClippedTexture(C, X, Y, Texture'UMenu.BMenuHL');
		DrawStretchedTexture(C, X + 4, Y, W - 8, 16, Texture'UMenu.BMenuHM');
		DrawClippedTexture(C, X + W - 4, Y, Texture'UMenu.BMenuHR');
	}

	if(UWindowPulldownMenuItem(Item).bDisabled) 
	{


		// Black Shadow
		C.DrawColor.R = 96;
		C.DrawColor.G = 96;
		C.DrawColor.B = 96;
	}
	else
	{
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
	}



	// DrawColor will render the tick black white or gray.
	if(UWindowPulldownMenuItem(Item).bChecked)
		DrawClippedTexture(C, X + 1, Y + 3, Texture'MenuTick');

	if(UWindowPulldownMenuItem(Item).SubMenu != None)
		DrawClippedTexture(C, X + W - 9, Y + 3, Texture'MenuSubArrow');

	ClipText(C, X + TextBorder + 2, Y + 3, UWindowPulldownMenuItem(Item).Caption, True);	
}

defaultproperties
{
}
