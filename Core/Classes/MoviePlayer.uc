class MoviePlayer expands object
	transient
	noexport
	native;

//------------------------------------------------------------------------------
// Error handling for movie operations

enum EMovieError
{
	MOVIE_NoError,
	MOVIE_LoadFailed,
	MOVIE_NoMovieInPlayer,
	MOVIE_LibraryFailed,
	MOVIE_NotPlaying,
	MOVIE_KeyExit
};

enum EMovieFlags
{
	MOVFLAG_NormalRun,
	MOVFLAG_ExitOnKeyPress
};

var native private const pointer privatemembers;		// filler for the space needed for a struct pointer

native(2014) final function int Init();
native(2015) final function int Destroy();
native(2016) final function int Load(string filename);
native(2017) final function int Eject();
native(2018) final function int Play();
native(2019) final function int Pause();
native(2020) final function int FastForward();
native(2021) final function int Reset();
native(2022) final function int Stop();
native(2023) final function int Tick(int flags);
native(2024) final function byte Mute();
native(2025) final function byte NoAudio();
native(2026) final function byte IsPlaying();
native(2027) final function byte IsPaused();
native(2028) final function byte IsFastForwarding();
native(2029) final function byte IsEjected();
native(2030) final function byte IsMuted();
native(2031) final function int GetFrameNo();

defaultproperties
{
}
