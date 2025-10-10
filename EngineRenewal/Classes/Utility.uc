//=============================================================================
// Utility.
//=============================================================================
class Utility expands Object
	noexport
	native;

native static final function texture LoadBMPFromFile(string Filename, optional texture Texture); // optionally use passed in Texture instead of creating a new one (untested)
native static final function DestroyTexture(texture Texture); // calls: delete Texture
native static final function Screenshot(PlayerPawn Player, string Filename, optional bool bHideHud, optional bool bHideConsole);
native static final function string GetSavePath();
native static final function ComputeRenderSize(Canvas Canvas);
native static final function bool ReplaceFunction(class<Object> ReplaceClass, class<Object> WithClass, name ReplaceFunctionName, name WithFunctionName, optional name InState);
native static final function string GetLanguage();

// Math helper functions. These could be moved to Object.uc, but at the risk of naming conflicts.
static final function int Ceil(float num)
{
    local int inum;
    inum = int(num);

    if (float(inum) < num)
    {
        return inum + 1;
    }
    return inum;
}

static final function int Floor(float num)
{
    local int inum;
    inum = int(num);

    if (float(inum) > num)
    {
        return inum - 1;
    }
    return inum;
}

static final function int Round(float num)
{
    if (num >= 0.0)
    {
        return int(num + 0.5);
    }
    else
    {
        return int(num - 0.5);
    }
}

defaultproperties
{
     
}