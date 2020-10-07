# Clive Barker's Undying - Widescreen Fix
This branch doesn't change anything gameplay related.

## Building
  - Create a folder called UndyingScripts on the C: drive.
  - Download and extract all the files from this repository in that folder.
  - Open System.ini from the game's 'System' folder and change `SourceDir=\DWIUnreal` to `SourceDir=C:\UndyingScripts`
  - Edit System.ini with packages you want to build. If you get an error you might need to add other packages that are also required for that specific package. E.g.
    ```
    EditPackages=Engine
    EditPackages=Aeons
    ```
  - In the 'System' folder of the game type 'cmd' in the file path bar.
  - Type `ucc make` in the command prompt that opens.
