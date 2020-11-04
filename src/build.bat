@echo off
rem ::::::::::::::::
set pt=c:\prg\cmp\vbd
set lib1=lib\uglv
set gamecode=src
set engncode=src
set obj1=demo
set obj2=cs2dmain
set obj3=cs2dload
set obj4=cs2dents
set obj5=cs2dplay
set obj6=cs2dbots
set obj7=cs2dwepn
set obj8=cs2ddraw
set obj9=cs2dhud
set obja=cs2dsttp
set objb=cs2ditem
set objc=cs2dmenu
set objd=cs2dmsgs
set obje=queue
set objf=astar

echo. %obj1%.obj+%obj2%.obj+%obj3%.obj+%obj4%.obj+%obj5%.obj+%obj6%.obj+%obj7%.obj+%obj8%.obj+%obj9%.obj+%obja%.obj+%objb%.obj+%objc%.obj+%objd%.obj+%obje%.obj+%objf%.obj >obj.lst
echo. %obj1%.exe >>obj.lst
echo. >>obj.lst
echo. %pt%\lib\vbdcl10e+%lib1% >>obj.lst

rem ::::::::::::::::
if exist %obj1%.exe del %obj1%.exe

echo.
echo. %obj1% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %gamecode%\%obj1%;
echo.
echo. %obj2% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%obj2%;
echo.
echo. %obj3% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%obj3%;
echo.
echo. %obj4% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%obj4%;
echo.
echo. %obj5% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%obj5%;
echo.
echo. %obj6% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%obj6%;
echo.
echo. %obj7% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%obj7%;
echo.
echo. %obj8% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%obj8%;
echo.
echo. %obj9% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%obj9%;
echo.
echo. %obja% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%obja%;
echo.
echo. %objb% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%objb%;
echo.
echo. %objc% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%objc%;
echo.
echo. %objd% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%objd%;
echo.
echo. %obje% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%obje%;
echo.
echo. %objf% ::::::::::::::::::::::::::::
call %pt%\bcv /o /G3 /Fpi /r /e %engncode%\%objf%;

rem ::::::::::::::::
call link16 /seg:800 /ex /e @obj.lst;
if exist %obj1%.obj del *.obj
if exist obj.lst del obj.lst
move /y demo.exe ..\demo.exe

rem ::::::::::::::::
set objf=
set obje=
set objd=
set objc=
set objb=
set obja=
set obj9=
set obj8=
set obj7=
set obj6=
set obj5=
set obj4=
set obj3=
set obj2=
set obj1=
set lib1=
set pt=
