class ExtraKeyBindings expands Object;

/*
How to use this,

1) subclass Undying.
2) put the name of your mod in the SectionName variable
3) put the descriptions of the actions in the LabelList array.
4) put the exec functions to be bound in the AliasNames array.
5) make a PackageName.int file with the following data in it:

[Public]
Object=(Name=MyPackage.MyKeyBindingsClass,Class=Class,MetaClass=UndyingShellPC.ExtraKeyBindings)
*/

var string SectionName;
var string LabelList[30];
var string AliasNames[30];

//example:

//defaultproperties
//{
//    SectionName="Capture the Mage"
//	LabelList(0)="Cast Spell"
//	LabelList(1)="Activate Shield"
//  AliasNames(0)="castspell"
//	AliasNames(1)="activateshield"
//}

defaultproperties
{
}
