//=============================================================================
// UWindowGridColumn - a grid column
//=============================================================================
class UWindowGridColumn extends UWindowWindow;

var UWindowGridColumn NextColumn;
var UWindowGridColumn PrevColumn;
var bool				bSizing;
var string				ColumnHeading;
var int					ColumnNum;
var int					DefaultWidth;

function Created() {
	Super.Created();
	DefaultWidth = WinWidth;
}

function BeforePaint(Canvas C, float X, float Y)
{
	Super.BeforePaint(C, X, Y);
	WinWidth = DefaultWidth*Root.ScaleY;
	if(WinWidth < 1) WinWidth = 1;
}

function LMouseDown(float X, float Y)
{
	Super.LMouseDown(X, Y);

	if(X > Min(WinWidth - 5*Root.ScaleY, ParentWindow.WinWidth - WinLeft - 5*Root.ScaleY) && Y < 12*Root.ScaleY)
	{
		bSizing = True;
		UWindowGrid(ParentWindow.ParentWindow).bSizingColumn = True;
		Root.CaptureMouse();
	}

}

function Notify(byte E)
{
	//fix   ????  does this need to be deleted or at least calling super.notify ?
	//Log("GridColumn Notify E =" $ E);
}
function LMouseUp(float X, float Y)
{
	Super.LMouseUp(X, Y);

	UWindowGrid(ParentWindow.ParentWindow).bSizingColumn = False;
}

function MouseMove(float X, float Y)
{
	if(X > Min(WinWidth - 5*Root.ScaleY, ParentWindow.WinWidth - WinLeft - 5*Root.ScaleY) && Y < 12*Root.ScaleY)
	{
		Cursor = Root.HSplitCursor;
	}
	else
	{
		Cursor = Root.DefaultNormalCursor;
	}

	if(bSizing && bMouseDown)
	{
		WinWidth = X;
		if(WinWidth < 1) WinWidth = 1;
		if(WinWidth > ParentWindow.WinWidth - WinLeft - 1) WinWidth = ParentWindow.WinWidth - WinLeft - 1;
		DefaultWidth = WinWidth/Root.ScaleY;
	}
	else
	{
		bSizing = False;
		UWindowGrid(ParentWindow.ParentWindow).bSizingColumn = False;
	}
}

function Paint(Canvas C, float X, float Y)
{
	local Region R;
	local Texture T;
	local Color FC;

	UWindowGrid(ParentWindow.ParentWindow).PaintColumn(C, Self, X, Y);

	if(IsActive())
	{
		T = LookAndFeel.Active;
		FC = LookAndFeel.HeadingActiveTitleColor;
	}
	else
	{
		T = LookAndFeel.InActive;
		FC = LookAndFeel.HeadingInactiveTitleColor;
	}

	C.DrawColor.r = 255;
	C.DrawColor.g = 255;
	C.DrawColor.b = 255;

	DrawUpBevel( C, 0, 0, WinWidth, LookAndFeel.ColumnHeadingHeight*Root.ScaleY, T);

	C.DrawColor = FC;

	ClipText( C, 2, 1, ColumnHeading);

	C.DrawColor.r = 255;
	C.DrawColor.g = 255;
	C.DrawColor.b = 255;
}
function RClick(float X, float Y)
{
//	Log("GridColumn RClick: X=" $ X $ " Y=" $ Y);

	ParentWindow.ParentWindow.KeyDown(2, X, Y ) ;

/*
	if ( bSelecting ) 
	{
		ProcessMenuKey( 2, mid(string(GetEnum(enum'EInputKey', 2)),3) );
		bSelecting = False;
		return;
	}
*/	
}

function MClick(float X, float Y)
{
//	Log("GridColumn MClick: X=" $ X $ " Y=" $ Y);

	ParentWindow.ParentWindow.KeyDown(4, X, Y ) ;

/*
	if ( bSelecting ) 
	{
		ProcessMenuKey( 4, mid(string(GetEnum(enum'EInputKey', 4)),3) );
		bSelecting = False;
		return;
	}
*/
}

function Click(float X, float Y)
{
	local int Row;

//	Log("GridColumn Click: X=" $ X $ " Y=" $ Y);

	ParentWindow.ParentWindow.KeyDown(1, X, Y ) ;
/*	
	if ( ControlsGrid(ParentWindow.ParentWindow).bSelecting ) 
	{
		ProcessMenuKey( 1, mid(string(GetEnum(enum'EInputKey', 1)),3) );
		bSelecting = False;
		return;
	}
*/
	if(Y < 12*Root.ScaleY)
	{
		if(X <= Min(WinWidth - 5*Root.ScaleY, ParentWindow.WinWidth - WinLeft - 5*Root.ScaleY))
		{
			UWindowGrid(ParentWindow.ParentWindow).SortColumn(Self);
		}
	}
	else
	{
		Row = ((Y - 12*Root.ScaleY) / UWindowGrid(ParentWindow.ParentWindow).RowHeight) + UWindowGrid(ParentWindow.ParentWindow).TopRow;
		UWindowGrid(ParentWindow.ParentWindow).SelectRow(Row);
		UWindowGrid(ParentWindow.ParentWindow).ClickCell(Self, Row);
	}
}

function RMouseDown(float X, float Y)
{
	local int Row;
	Super.RMouseDown(X, Y);

	if(Y > 12*Root.ScaleY)
	{
		Row = ((Y - 12*Root.ScaleY) / UWindowGrid(ParentWindow.ParentWindow).RowHeight) + UWindowGrid(ParentWindow.ParentWindow).TopRow;
		UWindowGrid(ParentWindow.ParentWindow).SelectRow(Row);
		UWindowGrid(ParentWindow.ParentWindow).RightClickRowDown(Row, X+WinLeft, Y+WinTop);
	}
}

function RMouseUp(float X, float Y)
{
	local int Row;
	Super.RMouseUp(X, Y);
	
	//Log("GridColumn RMouseUp: X=" $ X $ " Y=" $ Y);


	if(Y > 12*Root.ScaleY)
	{
		Row = ((Y - 12*Root.ScaleY) / UWindowGrid(ParentWindow.ParentWindow).RowHeight) + UWindowGrid(ParentWindow.ParentWindow).TopRow;
		UWindowGrid(ParentWindow.ParentWindow).SelectRow(Row);
		UWindowGrid(ParentWindow.ParentWindow).RightClickRow(Row, X+WinLeft, Y+WinTop);
	}
}

function DoubleClick(float X, float Y)
{
	local int Row;

	if(Y < 12*Root.ScaleY)
	{
		Click(X, Y);
	}
	else
	{
		Row = ((Y - 12*Root.ScaleY) / UWindowGrid(ParentWindow.ParentWindow).RowHeight) + UWindowGrid(ParentWindow.ParentWindow).TopRow;
		UWindowGrid(ParentWindow.ParentWindow).DoubleClickRow(Row);
	}
}

function MouseLeave()
{
	Super.MouseLeave();
	UWindowGrid(ParentWindow.ParentWindow).MouseLeaveColumn(Self);
}

defaultproperties
{
}
