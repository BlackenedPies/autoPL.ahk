### Automated Power Limit Script - Feedback

Hello,

I wrote an AHK script which automatically sets power limits based on the CPU package temperature and am looking for feedback to improve it

**Purpose:**

A power limit is the max power that the package (CPU+GPU) is allowed to pull. Higher power limits increase performance but affect power draw (battery life) and temperatures of nearby components like the battery and motherboard's power delivery system

Many users use scripts/hotkeys to switch between different power limits, but this requires human interaction or relies on timers

The two relevant power limits are PL1 and PL2, where PL2 is an additional boost for ~30 seconds (configurable by the user) if the package hasn't been operating at PL1 in the last period. Basically, for burst usage, you will often get PL2, but if it's consistently loaded near PL1 (like games), it'll mostly/always stay at PL1

**Requirements:**

It works on devices compatible with XTU-CLI such as the Pocket 2 or Win 2. This includes the majority of Intel devices, but some newer laptops, like my Latitude 7490, [need an extra step](https://jas-team.net/2019/07/30/intel-xtu-attempted-to-install-on-an-unsupported-platform/) to install xtucli. It will NOT work on the MicroPC, and certain devices like my Thinkpad X260 and P51 automatically set PL1, and xtucli doesn't work correctly. On some devices, you'll need to disable SpeedShift in BIOS as this also automatically sets PLs

1. AutoHotkey - installing AHK will let you run the script and compile to .exe if you want. You can edit it in any text editor - my preference is VSCode
2. XTU CLI. The latest versions of XTU don't have xtucli.exe. I use XTU version 6.4.1.25
3. CPU-Z installed in `C:\Program Files\CPUID\CPU-Z`. This isn't strictly required, and we're only using it to sample the current CPU package temperature. There are alternative ways to do this, but I chose CPU-Z for the reasons described under **Limitations**

**Description:**

Every 30 seconds: 

1. CPU-Z is polled and the current package temperature is read after five seconds. If the temp is above 75°, skip to step 2. Otherwise, poll CPU-Z again, wait, and read the temp. Average the two temps with the previously sampled temp (from the last loop)
2. if the absolute difference between the current average and previous average is less than five, skip to step 3. Otherwise, compare the temp in 5-degree increments to rules such as at 50° set PL1 at 7 and PL2 at 10 (for Pocket 2), or 4.5 and 5 at 80°. If it reaches 80, display a tooltip (message above the cursor)
3. if the absolute difference was less than five, don't set a new power limit and increment the temp by 1 and save it as the old temp. Either way, wait for the 30-second timer and then repeat from 1.

**Usage:**

The script must be run as Admin to avoid UAC prompts from CPU-Z and XTU. You can monitor the current PL1 and PL2 with HWiNFO and add tray icons if you want - my favorites for tray icons (depending on the device) are package power, package temp, max thread usage, charge rate, and PL1 and PL2

Run the script and then go to `C:\Program Files\CPUID\CPU-Z` and find `myreport.txt`. Search for 'temperature' - the first result should be the package temp. Note the line number: the script assumes it's line 94 (my Pocket 2), but different devices are different. If it's not line 94, edit the variable `linenum`

Edit the per-temperature power limits to your liking. Mine are set conservatively on the Pocket 2 as I typically run it fanless in a warm climate. With a fan, or on larger fanless devices like my Latitude 7370, they can be set significantly higher. Also, on 15W or 35+W devices, you will need to adjust these accordingly

You can set a hotkey to toggle the script on/off, such as `#z::suspend` (Win+Z), but make sure to put any hotkeys at the end of the script (unless you know what you're doing)

I start this on a timer after running initial XTU settings including undervolts. Basically, the PC boots and it launches an Admin script from Task Scheduler and then sets my initial XTU config, waits 60 seconds, and then launches this. I also launch between four and eight other scripts depending on the device (five scripts on the Pocket 2)

**Limitations:**

CPU-Z uses up to 5% CPU usage for almost two seconds when it's polled on my m3-8100Y, and XTU uses around 3% for one second. By my measurements, this increases average CPU usage by less than 0.9%, but you could set the priorities of CPU-Z and XTU as always 'Idle' with an app like ProcessLasso if you really need CPU performance (or just increase the timers)

There are alternative, better methods of sampling temperature, but I tried HWiNFO, HWMonitor, OpenHWM, and SpeedFan and didn't like each for various reasons. Using a tool like SpeedFan would work and allow higher-resolution sampling, but it constantly writes to the log every three seconds with no ability to change it and creates new logs every day. I'm still looking for a better solution if you have suggestions

The 5-degree increments that the script is comparing is not a great solution, and I'm very open to suggestions and critiques on my coding

**Thanks for reading!**

You can find the script below

https://github.com/BlackenedPies/autoPL.ahk/blob/master/autoPL.ahk
