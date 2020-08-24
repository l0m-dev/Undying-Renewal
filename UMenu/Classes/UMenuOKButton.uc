class UMenuOKButton extends UWindowButton;

//#exec TEXTURE IMPORT NAME=OKDown FILE=Textures\OKDown.bmp GROUP="Icons" MIPS=OFF
//#exec TEXTURE IMPORT NAME=OKOver FILE=Textures\OKOver.bmp GROUP="Icons" MIPS=OFF
//#exec TEXTURE IMPORT NAME=OKUp FILE=Textures\OKUp.bmp GROUP="Icons" MIPS=OFF


var UWindowWindow	CloseWindow;

function Created()
{

	bNoKeyboard = True;

	Super.Created();

	UpTexture=Texture'OKUp'; 
	DownTexture=Texture'OKDown';
	DisabledTexture=Texture'OKUp';
	OverTexture=Texture'OKOver';
	ToolTipString = "";
}

function Click(float X, float Y) 
{
	Super.Click(X, Y);
	ParentWindow.ParentWindow.Close();	
}

function KeyDown(int Key, float X, float Y)
{
	if(Key == 0x0D) 
		Click(X, Y);
	else
		Super.KeyDown(Key, X, Y);
}

defaultproperties
{
}
