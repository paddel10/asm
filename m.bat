@echo off
if "%1"=="" goto error
echo Deleting previous compile...
cd bin
del %1.com
del %1.lst
echo Compiling...
cd ..
echo nasm -f bin src/%1.asm -l bin/%1.lst -o bin/%1.com
nasm -f bin src/%1.asm -l bin/%1.lst -o bin/%1.com
goto end
:error
echo What do you want to Make? (no suffix)
:end
echo Done. 