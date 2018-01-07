@ECHO OFF & setlocal EnableDelayedExpansion

::USER INPUT

set /p photosfolder="Enter path to photos folder: "

IF NOT EXIST %photosfolder% (
    echo This folder does not exists
    goto :eof
)

echo Photos folder to be used %photosfolder%

set /p datafolder="Enter path to data folder: "

IF NOT EXIST %datafolder% (
    echo This folder does not exists
    goto :eof
)

echo Data folder to be used %datafolder%

set /p password="Enter password for archives: "

echo Password to be ued %password%

::USER INPUT
::CALCULATING SIZE OF ARCHIVES
set size=0

for /R %datafolder% %%F in (*) do ( set /a size=!size!+%%~zF )

set count=0

for /R %photosfolder% %%F in (*) do set /a count+=1

set /a filesize= %size%/1024/%count% * 2

::CALCULATING SIZE OF ARCHIVES
::CREATE FOLDER

IF EXIST encoded RMDIR /S /Q encoded
mkdir encoded

::CREATE FOLDER
::ARCHIVE AND COPY DATA

"C:\Program Files\WinRAR\Rar.exe" a -r -hp%password% -v%filesize%k "encoded\data.rar" %datafolder%

::ARCHIVE AND COPY DATE
::COPY PHOTOS

xcopy %photosfolder% encoded

::COPY PHOTOS
::RENAMING

cd encoded

set cnt=1372
for %%f in (*.jpg) do (
    set /a cnt+=1
    SET PADDED=000!cnt!
    SET PADDED=!PADDED:~-6!
    ren "%%f" "IMAG_!PADDED!.jpg"

)

::RENAMING
::MIXING

for %%A in (*.jpg) do (
  set imagefile=%%A
  call :getrarfile rarfile
    
  if exist "!rarfile!" (
     copy /b "!imagefile!" + "!rarfile!" "!imagefile!"
     del "!rarfile!"
  )
)

set /p out="Enter to exit"
exit

:getrarfile
FOR %%F IN (*.rar) DO (
   set %1=%%F
   goto :out
   )
:out
goto :eof