@echo off
::
:: Downloads Perl binary release from https://strawberryperl.com.
::
:: SHELL: CMD Or MSVC Build Tools
::
set ResultCode=0
if not defined GNUWIN32 (
  call "%~dp0GNUGet.bat" 1>nul
  set ResultCode=!ErrorLevel!
  if not "/!ResultCode!/"=="/0/" (
    echo GNUGet.bat error.
    echo -----------------
    goto :EOS
  )
)

set BASEDIR=%~dp0
set BASEDIR=%BASEDIR:~0,-1%
set PKGDIR=%BASEDIR%\pkg
set BLDDIR=%BASEDIR%\bld
set DEVDIR=%BASEDIR%\dev
set HOMPERL=%DEVDIR%\perl
set ResultCode=0

if not exist "%PKGDIR%" mkdir "%PKGDIR%"
pushd "%PKGDIR%"


set PerlURLPrefix=https://strawberryperl.com
call "%~dp0DownloadFile.bat" "%PerlURLPrefix%" "perl-info.txt"
if not "/%ErrorLevel%/"=="/0/" (set ResultCode=%ErrorLevel%)
set CommandText=grep.exe -o -m 1 "/download/[0-9.]*/strawberry-perl-[0-9.]*-32bit.msi" perl-info.txt 
for /f "Usebackq delims=" %%G in (`%CommandText%`) do (
  set URLx32=%%~G
  set URLx32=%PerlURLPrefix%!URLx32:msi=zip!
)

call "%~dp0DownloadFile.bat" %URLx32%
if not "/%ErrorLevel%/"=="/0/" exit /b %ErrorLevel%
set Perlx32File=%FileName%

if not exist "%HOMPERL%\bin\perl.exe" (
  if exist "%HOMPERL%" rmdir /S /Q "%HOMPERL%" 2>nul
  set TARPATTERN=perl
  call "%~dp0ExtractArchive.bat" %Perlx32File% "%HOMPERL%\.."
  if not "/!ErrorLevel!/"=="/0/" exit /b !ErrorLevel!
)

if "/!Path!/"=="/!Path:%HOMPERL%\bin=!/" set Path=%HOMPERL%\bin;%Path%
set PERL=1

echo.
echo ============= Perl installation is complete. ============
echo ResultCode: %ResultCode% (^>0 - errors occured). Check the log files for errors. 
echo.

:EOS

:: Cleanup
set HOMPERL=
set PERLURLPrefix=
set URLx32=
set Perlx32File=
set URL=
set FileLen=
set FileName=
set FileSize=
set FileURL=
set Flag=
set Folder=
set ArchiveName=
set CommandText=

popd

exit /b %ResultCode%
