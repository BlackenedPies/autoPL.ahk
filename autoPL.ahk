#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2
#SingleInstance force
#InputLevel, 3
#Persistent

global cput0 := 50  ;initializing the value; not necessary

SetTimer, readlog, 30000  ;30 second timer

readlog:
global linenum = 94 ;SET THIS FOR YOUR DEVICE
gosub readtemp2   ;read last sample
global cput1 := regout
gosub readtemp ;read current sample
global cput2 := regout
if (cput2 >= 75)  ;if 75+°C, jump to PLs
{
  global cput := cput2
  gosub PL
}
else
sleep 10
gosub readtemp
global cput3 := regout
if (cput3 >= 75)
{
  global cput := cput3
  gosub PL
}
else
sleep 10
global cput := Round(((cput1 + cput2 + cput3)/3), 0)  ;average the values
gosub PL
return

PL:
if (A_ComputerName = "BPOK"){
    if ((abs(cput0 - cput) >= 5) && cput < 80)  ;if difference from old is < 5
    {
    if (cput >= 75 && cput < 80)  ;temp between 75 and 79
        {
            global pl1 := 4.5
            global pl2 := 5.5
            plfunc()  ;run xtucli with pl1 and pl2
        }
    else if (cput < 75 && cput >= 70)
        {
            global pl1 := 5
            global pl2 := 6
            plfunc()
        }
    else if (cput < 70 && cput >= 65)
        {
            global pl1 := 5.5
            global pl2 := 6.5
            plfunc()
        }
    else if (cput < 65 && cput >= 60)
        {
            global pl1 := 6
            global pl2 := 7.5
            plfunc()
        }
    else if (cput < 60 && cput >= 55)
        {
            global pl1 := 6.5
            global pl2 := 8
            plfunc()
        }
    else if (cput < 55 && cput >= 50)
        {
            global pl1 := 7
            global pl2 := 9
            plfunc()
        }
    else if (cput < 50)
        {
            global pl1 := 8
            global pl2 := 10
            plfunc()
        }
    global cput0 := cput  ;create old temp value
    }
  else if ((abs(cput0 - cput) >= 5) && cput <= 80)
    {
        global pl1 := 4.5
        global pl2 := 5
        plfunc()
        tooltip 80 ;1 second tooltip displaying '80'
        sleep 1000
        tooltip
        global cput0 := cput
    }
else  ;if absolue value < 5
{
  global cput0 := (cput + 1)  ;increment by one to increase chance of next trigger
  sleep 1000
}
return
}
else
return

readtemp:  ;CPU-Z takes around 3 seconds to generate the report - this runs and reads after 5 secs
run "C:\Program Files\CPUID\CPU-Z\cpuz.exe" -txt=myreport
sleep 5000
filereadline, lineout, C:\Program Files\CPUID\CPU-Z\myreport.txt, linenum
RegExMatch(lineout, ".. degC", regmat)
global regout := regexreplace(regmat,"( degC)", "")
return

readtemp2: ;this doesn't run CPU-Z and just reads the last value
filereadline, lineout, C:\Program Files\CPUID\CPU-Z\myreport.txt, linenum
RegExMatch(lineout, ".. degC", regmat)
regout := regexreplace(regmat,"( degC)", "")
return

plfunc(){ ;xtucli
run %comspec% /k ""C:\Program Files (x86)\Intel\Intel(R) Extreme Tuning Utility\Client\xtucli.exe" -t -id 48 -v %pl1%",,hide
run %comspec% /k ""C:\Program Files (x86)\Intel\Intel(R) Extreme Tuning Utility\Client\xtucli.exe" -t -id 47 -v %pl2%",,hide
return
}