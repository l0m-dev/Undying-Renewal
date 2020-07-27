# Clive Barker's Undying - Renewal
The goal for this mod is to finish multiplayer, add cut features and to balance the game.

Demo video: <https://youtu.be/5VtpuGM3oHI>

## Game Changes
  - Health can overcharge over 100, will drain slowly
  - Maximum health pickups - 5/10/15 - depending on the difficulty
  - Howlers attack faster after a missed attack
  - Lowered speargun lightning charging cost from 100 to 50
  - Reduced lightning spell cooldown
  - Ectoplasm gets better when leveled up
  - 4th skull for level 6
  - Removed the shaking of the skulls
  - Increased time before skulls get angry
  - Tibetian war cannon now has variable ranges and it has increased range when fully charged
  - Scrye time is increased 2 seconds per level
  - Speargun reloads and shoots faster
  - Reduced ammo and max ammo for the revolver and the shotgun
  - Increased lightning spell projectile speed and range
  - Made some cutscenes skippable
  - Nerfed shield health
  - Nerfed haste
  - Added a nice animation for deploying the stone
  - Added PS2 item list
  - Increased bird damage and melee range
  - Increased accuracy of the monk archer
  - Buffed flickerting stalkers (small floating heads)
  - Increased Monto speed (big blue floating things)
  - Improved molotov
  - Correct HUD scaling at all resolutions
  - Yellow Revolver icon from the BETA
  - Added unused Scrye and Shotgun sounds
  - Increased crosshair range
  - Added a scrye hint feature
  - Increased the time dead bodies stay on the ground
  - New gibs system!
  - Saves are no longer deleted on new game
  - Walking and crouching makes no noise

## Building
  - Create a folder called UndyingScripts on the C: drive.
  - Download and extract all the files from this repository in that folder.
  - Move all files files from the 'unused' folders to the 'Classes' folder, one directory back.
  - Open System.ini from the game's 'System' folder and change `SourceDir=\DWIUnreal` to `SourceDir=C:\UndyingScripts`
  - Edit System.ini with packages you want to build. If you get an error you might need to add other packages that are also required for that specific package. E.g.
    ```
    EditPackages=Engine
    EditPackages=Aeons
    ```
  - In the 'System' folder of the game type 'cmd' in the file path bar.
  - Type `ucc make` in the command prompt that opens.
