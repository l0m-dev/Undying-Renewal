class UMenuComboList extends UWindowComboList;

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
	local string Text;
	local string Underline;

	C.DrawColor.R = 255;
	C.DrawColor.G = 255;
	C.DrawColor.B = 255;


	C.Font = Root.Fonts[F_Normal];
	ParseAmpersand(UWindowComboListItem(Item).Value, Text, Underline, True);

	if(Selected == Item)
	{
		DrawClippedTexture(C, X, Y, Texture'UMenu.BMenuHL');
		DrawStretchedTexture(C, X + 4, Y, W - 8, 16, Texture'UMenu.BMenuHM');
		DrawClippedTexture(C, X + W - 4, Y, Texture'UMenu.BMenuHR');
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
	}
	else
	{
		C.DrawColor.R = 0;
		C.DrawColor.G = 0;
		C.DrawColor.B = 0;
	}

	ClipText(C, X + TextBorder + 2, Y + 3, Text);
	ClipText(C, X + TextBorder + 2, Y + 5, Underline);
}

defaultproperties
{
}
