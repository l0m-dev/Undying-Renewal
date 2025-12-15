//=============================================================================
// LevelBase
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class LevelBase extends Object
	native
	noexport
	transient;

// Internal.
var native private const pointer vtblOut;

// Database.
var transient const array<actor> Actors;
var native private const object Actors_Owner;

// Variables.
var native private const NetDriver NetDriver;
var transient const Engine Engine;
var transient const URL URL;
var native private const DemoRecDriver DemoRecDriver;
