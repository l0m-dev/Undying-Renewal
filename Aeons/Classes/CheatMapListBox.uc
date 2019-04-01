class CheatMapListBox expands UMenuMapListBox;

/*
function bool ExternalDragOver(UWindowDialogControl ExternalControl, float X, float Y)
{
	if(ExternalControl.OwnerWindow != OwnerWindow || UMenuMapListInclude(ExternalControl) == None)
		return False;
	
	if(Super.ExternalDragOver(ExternalControl, X, Y))
	{
		Sort();
		return True;
	}

	return False;
}
*/

function ReceiveDoubleClickItem(UWindowListBox L, UWindowListBoxItem I)
{
	local UMenuMapList M;
	local string URL;
	/*
	Super.ReceiveDoubleClickItem(L, I);
	Sort();
	MakeSelectedVisible();
	*/

	//Log("ReceiveDoubleClickItem" $ L @ I );

	// UWindowListBoxItem

	//var string MapName;
	//var string DisplayName;

	M = UMenuMapList(I);

	//Log("DoubleClick: MapName = " $ M.MapName $ "   DisplayName = " $ M.DisplayName );

	URL  = "open " $ M.DisplayName;

	AeonsRootWindow(Root).MainMenu.Close();
	//Root.Console.CloseUWindow();
	GetPlayerOwner().ConsoleCommand( URL );
}

defaultproperties
{
}
