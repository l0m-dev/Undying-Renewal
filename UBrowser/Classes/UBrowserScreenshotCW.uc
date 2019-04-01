class UBrowserScreenshotCW expands UWindowClientWindow;

var Texture Screenshot;
var string MapName;
var string ScreenShotName;

function Paint(Canvas C, float MouseX, float MouseY)
{
	local float X, Y, W, H;
	local int i;
	local string M;
	local UBrowserServerList L;

	L = UBrowserInfoClientWindow(GetParent(class'UBrowserInfoClientWindow')).Server;
	
	if( L != None )
	{
		M = L.MapName;
		if( M != MapName )
		{
			MapName = M;
			if( MapName == "" )
				ScreenShot = None;
			else
			{
				i = InStr(Caps(MapName), ".SAC");
				if(i != -1)
					MapName = Left(MapName, i);
				
				MapNametoScreenShot( MapName );
			}
		}
	}
	else
	{
		ScreenShot = None;
		MapName = "";
	}

	DrawStretchedTexture(C, 0, 0, WinWidth, WinHeight, Texture'BlackTexture');

	if(Screenshot != None)
	{
		W = Min(WinWidth, Screenshot.USize);
		H = Min(WinHeight, Screenshot.VSize);
		
		if(W > H)
			W = H;
		if(H > W)
			H = W;

		X = (WinWidth - W) / 2;
		Y = (WinHeight - H) / 2;
			
		DrawStretchedTexture(C, X, Y, W, H, Screenshot);	
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

	ScreenShot = Texture(DynamicLoadObject(ScreenShotName, class'texture'));
}

defaultproperties
{
}
