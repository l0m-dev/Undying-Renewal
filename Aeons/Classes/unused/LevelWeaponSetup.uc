//=============================================================================
// LevelWeaponSetup.
//=============================================================================
class LevelWeaponSetup expands Info;

#exec TEXTURE IMPORT FILE=lws.pcx GROUP=System Mips=Off

var AeonsPlayer Player;

var(Weapons) bool Revolver;
var(Weapons) bool Shotgun;
var(Weapons) bool Speargun;
var(Weapons) bool WarCannon;
var(Weapons) bool Dynamite;
var(Weapons) bool Molotov;
var(Weapons) bool Scythe;
var(Weapons) bool Ghelziabahr;

var(AttSpell) bool Ectoplasm;
var(AttSpell) bool SkullStorm;
var(AttSpell) bool Ward;
var(AttSpell) bool PowerWord;
var(AttSpell) bool Lightning;
var(AttSpell) bool Mindshatter;
var(AttSpell) bool Phoenix;
var(AttSpell) bool Invoke;

var(AttSpell) int Ectoplasm_Amp;
var(AttSpell) int SkullStorm_Amp;
var(AttSpell) int Ward_Amp;
var(AttSpell) int PowerWord_Amp;
var(AttSpell) int Lightning_Amp;
var(AttSpell) int Mindshatter_Amp;
var(AttSpell) int Phoenix_Amp;
var(AttSpell) int Invoke_Amp;

var(DefSpell) bool Phase;
var(DefSpell) bool Haste;
var(DefSpell) bool Silence;
var(DefSpell) bool Scrye;
var(DefSpell) bool DispelMagic;
var(DefSpell) bool FireFly;
var(DefSpell) bool Shield;
var(DefSpell) bool Shalas;

var(DefSpell) int Phase_Amp;
var(DefSpell) int Haste_Amp;
var(DefSpell) int Silence_Amp;
var(DefSpell) int Scrye_Amp;
var(DefSpell) int DispelMagic_Amp;
var(DefSpell) int FireFly_Amp;
var(DefSpell) int Shield_Amp;
var(DefSpell) int Shalas_Amp;

function go()
{
	local Inventory Inv;
	
	// Find the player
	ForEach AllActors (class 'AeonsPlayer', Player)
	{
		break;
	}

	// Molotov
	Inv = Player.Inventory.FindItemInGroup(class'Molotov'.default.InventoryGroup);
	if ( (Inv != none) && !Molotov )
		Player.DeleteInventory(Inv);
	else if ( Molotov )
		Player.GiveMe('Molotov');

	// Ghelziabahr
	Inv = Player.Inventory.FindItemInGroup(class'GhelziabahrStone'.default.InventoryGroup);
	if ( (Inv != none) && !Ghelziabahr )
		Player.DeleteInventory(Inv);
	else if ( Ghelziabahr )
		Player.GiveMe('Ghelz');

	// Scythe
	Inv = Player.Inventory.FindItemInGroup(class'Scythe'.default.InventoryGroup);
	if ( (Inv != none) && !Scythe )
		Player.DeleteInventory(Inv);
	else if ( Scythe )
		Player.GiveMe('Scythe');

	// Revolver
	Inv = Player.Inventory.FindItemInGroup(class'Revolver'.default.InventoryGroup);
	if ( (Inv != none) && !Revolver )
		Player.DeleteInventory(Inv);
	else if ( Revolver )
		Player.GiveMe('Revolver');

	// Shotgun
	Inv = Player.Inventory.FindItemInGroup(class'Shotgun'.default.InventoryGroup);
	if ( (Inv != none) && !Shotgun )
		Player.DeleteInventory(Inv);
	else if ( Shotgun )
		Player.GiveMe('Shotgun');

	// WarCannon
	Inv = Player.Inventory.FindItemInGroup(class'TibetianWarCannon'.default.InventoryGroup);
	if ( (Inv != none) && !WarCannon )
		Player.DeleteInventory(Inv);
	else if ( WarCannon )
		Player.GiveMe('Cannon');

	// Speargun
	Inv = Player.Inventory.FindItemInGroup(class'Speargun'.default.InventoryGroup);
	if ( (Inv != none) && !Speargun )
		Player.DeleteInventory(Inv);
	else if ( Speargun )
		Player.GiveMe('Speargun');
	
	// Dynamite
	Inv = Player.Inventory.FindItemInGroup(class'Dynamite'.default.InventoryGroup);
	if ( (Inv != none) && !Dynamite )
		Player.DeleteInventory(Inv);
	else if ( Dynamite )
		Player.GiveMe('Speargun');

	// =========================================================================
	// Attack Spells ===========================================================
	
	// Ectoplasm
	Inv = Player.Inventory.FindItemInGroup(class'Ectoplasm'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Ectoplasm )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Ectoplasm_Amp;
	} else if ( Ectoplasm )
		Player.GiveMe('Ectoplasm', Ectoplasm_Amp);

	// SkullStorm
	Inv = Player.Inventory.FindItemInGroup(class'SkullStorm'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !SkullStorm )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = SkullStorm_Amp;
	} else if ( SkullStorm )
		Player.GiveMe('SkullStorm', SkullStorm_Amp);

	// Ward
	Inv = Player.Inventory.FindItemInGroup(class'Ward'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Ward )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Ward_Amp;
	} else if ( Ward )
		Player.GiveMe('Ward', Ward_Amp);

	// Lightning
	Inv = Player.Inventory.FindItemInGroup(class'Lightning'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Lightning )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Lightning_Amp;
	} else if ( Lightning )
		Player.GiveMe('Lightning', Lightning_Amp);

	// Phoenix
	Inv = Player.Inventory.FindItemInGroup(class'Phoenix'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Phoenix )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Phoenix_Amp;
	} else if ( Phoenix )
		Player.GiveMe('Phoenix', Phoenix_Amp);

	// PowerWord
	Inv = Player.Inventory.FindItemInGroup(class'PowerWord'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !PowerWord )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = PowerWord_Amp;
	} else if ( PowerWord )
		Player.GiveMe('PowerWord', PowerWord_Amp);

	// Mindshatter
	Inv = Player.Inventory.FindItemInGroup(class'Mindshatter'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Mindshatter )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Mindshatter_Amp;
	} else if ( Mindshatter )
		Player.GiveMe('Mindshatter', Mindshatter_Amp);

	// Invoke
	Inv = Player.Inventory.FindItemInGroup(class'Invoke'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Invoke )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Invoke_Amp;
	} else if ( Invoke )
		Player.GiveMe('Invoke', Invoke_Amp);

	// =========================================================================
	// Defense Spells ==========================================================
	
	// Scrye
	Inv = Player.Inventory.FindItemInGroup(class'Scrye'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Scrye )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Scrye_Amp;
	} else if ( Scrye )
		Player.GiveMe('Scrye', Scrye_Amp);

	// Phase
	Inv = Player.Inventory.FindItemInGroup(class'Phase'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Phase )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Phase_Amp;
	} else if ( Scrye )
		Player.GiveMe('Phase', Phase_Amp);

	// Silence
	Inv = Player.Inventory.FindItemInGroup(class'IncantationOfSilence'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Silence )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Silence_Amp;
	} else if ( Silence )
		Player.GiveMe('Silence', Silence_Amp);


	// DispelMagic
	Inv = Player.Inventory.FindItemInGroup(class'DispelMagic'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !DispelMagic )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = DispelMagic_Amp;
	} else if ( DispelMagic )
		Player.GiveMe('DispelMagic', DispelMagic_Amp);

	// Shield
	Inv = Player.Inventory.FindItemInGroup(class'Shield'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Shield )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Shield_Amp;
	} else if ( Shield )
		Player.GiveMe('Shield', Shield_Amp);

	// Shalas
	Inv = Player.Inventory.FindItemInGroup(class'ShalasVortex'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Shalas )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Shalas_Amp;
	} else if ( Shalas )
		Player.GiveMe('Shalas', Shalas_Amp);

	// Firefly
	Inv = Player.Inventory.FindItemInGroup(class'Firefly'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Firefly )
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Firefly_Amp;
	} else if ( Firefly )
		Player.GiveMe('Firefly', Firefly_Amp);

	// Haste
	Inv = Player.Inventory.FindItemInGroup(class'Haste'.default.InventoryGroup);
	if ( Inv != none )
	{
		if ( !Haste)
			Player.DeleteInventory(Inv);
		else
			AttSpell(Inv).CastingLevel = Haste_Amp;
	} else if ( Haste )
		Player.GiveMe('Haste', Haste_Amp);
}

defaultproperties
{
     Revolver=True
     Ghelziabahr=True
     Ectoplasm=True
     Scrye=True
     Texture=Texture'Aeons.System.lws'
}
