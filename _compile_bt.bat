@ECHO OFF

del recompile\bt.tap
del recompile\bt.bin
del bt_intercept.sna

set ASM=..\_tools\sjasmplus.exe

cls

%ASM% --syntax=abF --msg=err BT_main.asm

echo _
echo _

pause 
python tools\py_diff_bin.py original/game_5B00-FFFF.mem recompile/bt.bin

pause
