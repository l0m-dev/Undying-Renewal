//=============================================================================
// Canvas: A drawing canvas.
// This is a built-in Unreal class and it shouldn't be modified.
//
// Notes.
//   To determine size of a drawable object, set Style to STY_None,
//   remember CurX, draw the thing, then inspect CurX and CurYL.
//=============================================================================
class Canvas extends Object
	native
	noexport;

// Objects.
//#exec Font Import File=Textures\SmallFont.bmp Name=SmallFont
//#exec Font Import File=Textures\MedFont.pcx   Name=MedFont
//#exec Font Import File=Textures\LargeFont.pcx Name=LargeFont
//#exec Font Import File=Textures\BigFont.pcx   Name=BigFont

// Modifiable properties.
var font    Font;            // Font for DrawText.
var float   SpaceX, SpaceY;  // Spacing for after Draw*.
var float   OrgX, OrgY;      // Origin for drawing.
var float   ClipX, ClipY;    // Bottom right clipping region.
var float   CurX, CurY;      // Current position for drawing.
var float   Z;               // Z location. 1=no screenflash, 2=yes screenflash.
var byte    Style;           // Drawing style STY_None means don't draw.
var float   CurYL;           // Largest Y size since DrawText.
var color   DrawColor;       // Color for drawing.
var bool    bCenter;         // Whether to center the text.
var bool    bNoSmooth;       // Don't bilinear filter.
var const int SizeX, SizeY;  // Zero-based actual dimensions.

// Stock fonts.
var font SmallFont;          // Small system font.
var font MedFont;            // Medium system font.
var font BigFont;            // Big system font.
var font LargeFont;          // Large system font.
var font DebugFont;			 // Fixed-Width font used for stat rendering / debugging

// Internal.
var const viewport Viewport; // Viewport that owns the canvas.
var const int FramePtr;      // Scene frame pointer.
var const int RenderPtr;	 // Render device pointer, only valid during UGameEngine::Draw

//var float padding; // for some reason you can't have FontScale here, so add padding
//var float FontScale;

// native functions.
native(463) final function Draw3DLine( Color Color, Vector Start, Vector End);
native(464) final function StrLen( coerce string String, out float XL, out float YL );
native(465) final function DrawText( coerce string Text, optional bool CR );
native(466) final function DrawTile( texture Tex, float XL, float YL, float U, float V, float UL, float VL );
native(467) final function DrawActor( Actor A, bool WireFrame, optional bool ClearZ );
native(468) final function DrawTileClipped( texture Tex, float XL, float YL, float U, float V, float UL, float VL );
native(469) final function DrawTextClipped( coerce string Text, optional bool bCheckHotKey );
native(470) final function TextSize( coerce string String, out float XL, out float YL );
native(471) final function DrawClippedActor( Actor A, bool WireFrame, int X, int Y, int XB, int YB, optional bool ClearZ );
native(480) final function DrawPortal( int X, int Y, int Width, int Height, actor CamActor, vector CamLocation, rotator CamRotation, optional int FOV, optional bool ClearZ );
native(481) final function vector DeProject( vector v );
native(482) final function vector Project( vector v );

function DrawActorFixedFov( Actor A, float Fov, bool WireFrame, optional bool ClearZ )
{
	// used by inventory, weapons, spells
	// changing fov for DrawActor does nothing, leave this as a wrapper
	// only DrawActor has special logic for attached actors
	DrawActor(A, WireFrame, ClearZ);
}

function DrawClippedActorFixedFov( Actor A, float Fov, bool WireFrame, int X, int Y, int XB, int YB, optional bool ClearZ )
{
	local float OldFov;
	local PlayerPawn P;
	
	P = ViewPort.Actor;
	if (P != None)
	{
		OldFov = P.FOVAngle;
		P.SetFOVAngle(Fov);
	}
	DrawClippedActor(A, WireFrame, X, Y, XB, YB, ClearZ);
	if (P != None)
	{
		P.SetFOVAngle(OldFov);
	}
}

// UnrealScript functions.
event Reset()
{
	Font        = Default.Font;
	SpaceX      = Default.SpaceX;
	SpaceY      = Default.SpaceY;
	OrgX        = Default.OrgX;
	OrgY        = Default.OrgY;
	CurX        = Default.CurX;
	CurY        = Default.CurY;
	Style       = Default.Style;
	DrawColor   = Default.DrawColor;
	CurYL       = Default.CurYL;
	bCenter     = false;
	bNoSmooth   = false;
	Z           = 1.0;
	//FontScale	= 1.0;
}
final function SetPos( float X, float Y )
{
	CurX = X;
	CurY = Y;
}
final function SetOrigin( float X, float Y )
{
	OrgX = X;
	OrgY = Y;
}
final function SetClip( float X, float Y )
{
	ClipX = X;
	ClipY = Y;
}
final function DrawPattern( texture Tex, float XL, float YL, float Scale )
{
	DrawTile( Tex, XL, YL, (CurX-OrgX)*Scale, (CurY-OrgY)*Scale, XL*Scale, YL*Scale );
}
final function DrawIcon( texture Tex, float Scale )
{
	if ( Tex != None )
		DrawTile( Tex, Tex.USize*Scale, Tex.VSize*Scale, 0, 0, Tex.USize, Tex.VSize );
}
final function DrawIconTrimmed( texture Tex, float Scale )
{
	if ( Tex != None )
		DrawTile( Tex, Tex.USize*Scale, Tex.VSize*Scale, 1, 1, Tex.USize - 1, Tex.VSize - 1 );
}
final function DrawRect( texture Tex, float RectX, float RectY )
{
	DrawTile( Tex, RectX, RectY, 0, 0, Tex.USize, Tex.VSize );
}

defaultproperties
{
     Z=1
     Style=1
     DrawColor=(R=127,G=127,B=127,A=255)
     SmallFont=Font'Engine.SmallFont'
     MedFont=Font'Engine.MedFont'
     BigFont=Font'Engine.BigFont'
     LargeFont=Font'Engine.LargeFont'
     DebugFont=Font'Engine.SmallFont'
	 //FontScale=1
}
