class MemoryCard
	expands object
	transient
	noexport
	native;

// Minimum size of a save game.  This should include icon sizes.
const MemoryCardGameSizeOverhead					= 270052;

native(206) final function bool QuerySlot(int Port);
native(207) final function bool IsFormated();
native(208) final function bool Format();
native(209) final function bool UnFormat();
native(228) final function int GetNumSaveGames();
native(238) final function RewindSaveGameList();
native(241) final function bool GetNextSaveGame(out int slot, out int size, out string name);
native(253) final function DeleteSaveGame(int slot);
native(257) final function bool CreateNewSaveGame(out int slot, string name);
native(268) final function bool OpenSaveGame(int slot, bool write);
native(269) final function bool CloseSaveGame();
native(270) final function int GetAvailableMemory();
native(271) final function DeleteOtherSaveGames();
native(273) final function int GetOtherGamesSize();

defaultproperties
{
}
