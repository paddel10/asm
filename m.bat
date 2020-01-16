@echo off
if "%1"=="" goto error
echo Deleting previous compile...
del %1.com
del %1.lst
echo Compiling...
nasm -f bin %1.asm -l %1.lst -o %1.com
goto end
:error
echo What do you want to Make? (no suffix)
:end
echo Done. 