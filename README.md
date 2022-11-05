# Clive Barker's Undying - Renewal
Mod that helps you play Undying on modern systems, tries to improve the gameplay and add cut features.

## Building
  Building is now automated with the [renewal launcher](https://www.moddb.com/mods/undying-renewal1). All scripts are placed in System/Scripts folder. Running the game through the launcher will build the scripts.

## Building manually
  - Create a folder called UndyingScripts on the C: drive.
  - Download and extract all the files from this repository in that folder.
  - Open System.ini from the game's 'System' folder and change `SourceDir=\DWIUnreal` to `SourceDir=C:\UndyingScripts`
  - Edit System.ini with packages you want to build. If you get an error you might need to add other packages that are also required for that specific package. E.g.
    ```
    EditPackages=Engine
    EditPackages=UWindow
    EditPackages=UBrowser
    EditPackages=UMenu
    EditPackages=Aeons
    EditPackages=UndyingShellPC
    ```
  - In the 'System' folder of the game type 'cmd' in the file path bar.
  - Type `ucc make` in the command prompt that opens.
