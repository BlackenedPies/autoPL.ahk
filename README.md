Hello,

I wrote an AHK script that automatically sets power limits based on the CPU package temperature and am looking for feedback to improve it

**Info:**

A power limit is the max power that the package (CPU+GPU) is allowed to pull. Higher power limits increase max performance but affect power draw (battery life) and the temperatures of nearby components like the battery and motherboard's power delivery system. CPU temperature itself is rarely a concern as it typically takes years to degrade a stock CPU with heat, but devices with small VRMs and poor batteries will see a reduced life span from high temps in certain cases. I specifically wrote this for an m3-8100Y GPD Pocket 2 (7" mini-laptop), which gets hot and users frequently report power and battery issues, and an m7-6Y75 Dell Latitude 7370 (13" fanless laptop), which has very low stock power limits (4.5W PL1) that can be tuned much higher (I usually run at around 7W PL). This script maxes at 80°C, but many devices are fine for moderate periods above that

Tuning power limits is most relevant on ~7W Y-series devices as they are typically heavily power-limited rather than clock-limited (their clock speeds are relatively very high). Most dual-core ~15W i5s max out at around 15W and i7s at 18W during 'normal use', which is within most devices' PL1 of 15W and PL2 of 25W, so it makes less difference for performance. The newer quad-core ~15W i5s can easily pull 25W, so it's more noticeable on them, and 35+W devices are similarly either clock or power limited based on the model. Power-limit performance scaling is generally non-linear, so you can throttle the power in return for better battery life

The two relevant power limits are PL1 and PL2, where PL2 is an additional boost for ~30 seconds (configurable by the user) if the package hasn't been operating at PL1 in the last period. For burst usage, you will often achieve PL2, but if it's consistently loaded near PL1, it'll mostly/always stay at PL1. Many users use scripts/hotkeys to switch between different power limits, but this requires human interaction or relies on timers

**Requirements:**

It works on everything compatible with XTU-CLI. This includes the majority of Intel devices, but some newer laptops, like my Latitude 7490, [need an extra step](https://jas-team.net/2019/07/30/intel-xtu-attempted-to-install-on-an-unsupported-platform/) to install xtucli. It will NOT work on newer SoC µarch devices (Celeron N4100 or Pentium N5000 etc.), and certain devices like my Thinkpad X260 and P51 automatically set PL1 so xtucli doesn't work correctly. On some 2016+ devices, you'll need to disable SpeedShift in BIOS as this also automatically sets PLs

1. AutoHotkey - installing AHK will let you run the script and compile to .exe if you want. You can edit it in any text editor - my preference is VSCode
2. XTU CLI. The latest versions of XTU don't have xtucli.exe, and I use XTU version 6.4.1.25 [here](https://ln2.sync.com/dl/6d69901f0/35smam2h-ed7mw4sx-drh67vsv-3dj6s79q)
3. CPU-Z installed in `C:\Program Files\CPUID\CPU-Z`. This isn't strictly required, and we're only using it to sample the current CPU package temperature. There are other ways to achieve this, but I chose CPU-Z for the reasons described under **Limitations** (I'm looking for a better alternative)

**Description:**

1. Every 30 seconds, CPU-Z is polled and the current package temperature is read after five seconds. If the temp is above 75°, skip to step 2. Otherwise, poll CPU-Z again, wait, and read the temp (if > 75° skip to step 2). Average the two temps with the previously sampled temp (from the prior loop)
2. If the difference between the current average and previous average is less than five, skip to step 3. Otherwise, compare the temp in 5-degree increments to rules such as at 50° set PL1 = 7 and PL2 = 10, or 4.5 and 5 at 80°. If it reaches 80, display a tooltip (message above the cursor). Save current average as old average
3. If the difference was less than five, don't set a new power limit and increment the temp by 1 and save it as the old average. Either way, wait for the 30-second timer and then repeat from 1.

**Usage:**

Run the script and then go to `C:\Program Files\CPUID\CPU-Z` and find `myreport.txt`. Search for 'temperature' - the first result should be the package temp. Note the line number: the script assumes it's line 94 (my Latitude 7370), but different devices are different. If it's not line 94, edit the variable `linenum`. Then, save, exit the script, and relaunch

The script must be run as Admin to avoid UAC prompts from CPU-Z and XTU. You can monitor the current PL1 and PL2 with HWiNFO and add tray icons if you want - my favorites for tray icons (depending on the device) are package power, package temp, max thread usage, charge rate, and PL1 and PL2. Make sure to set it as bold in HWiNFO's System Tray and adjust decimal digits in Custom

Edit the per-temperature power limits to your liking. The current PLs are for my GPD Pocket 2 (~7W m3-8100Y), which I typically run fanless in a warm environment. With a fan, or on larger fanless devices like my Latitude 7370 and most tablets, they can be set significantly higher. Also, on 15W or 35+W devices, you will need to adjust these accordingly

You can set a hotkey to toggle the script on/off, such as `#z::suspend` (Win+Z), but make sure to put any hotkeys at the end of the script unless you know what you're doing. Adding keys to exit and reload it are also very useful - I put `~^!r::reload` in all scripts so that Ctrl+Alt+R reloads everything at once 

I start this on a timer after running initial XTU settings including undervolts (not all devices support undervolting). The PC boots and it launches an Admin .exe script from Task Scheduler and then sets my initial XTU config with high PLs, waits 45 seconds, and then launches this (as part of another script). Using Task Scheduler avoids UAC prompts, and everything that an Admin AHK script runs is as Admin

**Limitations:**

CPU-Z causes around 3% CPU usage for two seconds when it's polled on my m3-8100Y, and XTU uses around 3% for one second. By my measurements, this increases average CPU usage by around 0.3%, but you could set the priorities of CPU-Z and XTU as always 'Idle' with an app like ProcessLasso if you really need CPU performance (or just increase the timers). Note that any CPU impact will mostly only affect performance while near 100%

There are alternative, better methods of sampling temperature, but I tried HWiNFO, HWMonitor, OpenHWM, and SpeedFan and didn't like each for various reasons. Using a tool like SpeedFan would work and allow higher-resolution sampling, but it constantly writes to the log every three seconds with no ability to change it and creates new logs every day. Two/three polls every 30 seconds isn't a great sample size, I'm looking for a better solution if you have suggestions

The 5-degree increments that the script is comparing is not a great solution, and I'm very open to suggestions and critiques on my logic and code

**Thanks for reading!**

You can find the script below

https://github.com/BlackenedPies/autoPL.ahk/blob/master/autoPL.ahk
