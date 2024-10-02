//=============================================================================
// LevelBase
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class LevelBase extends Object
	native
	noexport
	transient;

// Internal.
var private transient const int vtblOut;

// Database.
var transient const array<actor> Actors;
var transient const object Actors_Owner;

// Variables.
var transient const NetDriver NetDriver;
var transient const Engine Engine;
var transient const URL URL;
var transient const DemoRecDriver DemoRecDriver;
