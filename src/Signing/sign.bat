PATH=%PATH%;%WSDK81%\bin\x86;C:\Program Files\7-Zip;C:\Program Files (x86)\7-Zip

set VC_VERSION=1.25-RC2
set VC_VERSION_NBRE=1.25.2
set SIGNINGPATH=%~dp0
cd %SIGNINGPATH%

rem call "..\..\doc\chm\create_chm.bat"

cd %SIGNINGPATH%

rem sign using SHA-256
signtool sign /v /sha1 2B174F12D921AF2FF576D867BE91E97E4ADC7D07 /ac GlobalSign_SHA256_EV_CodeSigning_CA.cer /fd sha256 /tr http://timestamp.digicert.com /td SHA256 "..\Release\Setup Files\veracrypt.sys" "..\Release\Setup Files\veracrypt-x64.sys" "..\Release\Setup Files\veracrypt-arm64.sys"

signtool sign /v /sha1 2B174F12D921AF2FF576D867BE91E97E4ADC7D07 /ac GlobalSign_SHA256_EV_CodeSigning_CA.cer /fd sha256 /tr http://timestamp.digicert.com /td SHA256 "..\Release\Setup Files\VeraCrypt.exe" "..\Release\Setup Files\VeraCrypt Format.exe" "..\Release\Setup Files\VeraCryptExpander.exe" "..\Release\Setup Files\VeraCrypt-x64.exe" "..\Release\Setup Files\VeraCrypt Format-x64.exe" "..\Release\Setup Files\VeraCryptExpander-x64.exe" "..\Release\Setup Files\VeraCrypt-arm64.exe" "..\Release\Setup Files\VeraCrypt Format-arm64.exe" "..\Release\Setup Files\VeraCryptExpander-arm64.exe" "..\Release\Setup Files\VeraCrypt COMReg.exe" "..\Release\Setup Files\VeraCryptSetup.dll"

rem create setup and MSI
cd "..\Release\Setup Files\"
copy ..\..\LICENSE .
copy ..\..\License.txt .
copy ..\..\NOTICE .
copy ..\..\Resources\Texts\License.rtf .
copy ..\..\Common\VeraCrypt.ico .
copy ..\..\Setup\VeraCrypt_setup_background.bmp .
copy ..\..\Setup\VeraCrypt_setup.bmp .
copy ..\..\Setup\Setup.ico .
del *.xml
rmdir /S /Q Languages
mkdir Languages
copy /V /Y ..\..\..\Translations\*.xml Languages\.
del Languages.zip
7z a -y Languages.zip Languages
rmdir /S /Q docs
mkdir docs\html\en
mkdir docs\EFI-DCS
copy /V /Y ..\..\..\doc\html\* docs\html\en\.
copy "..\..\..\doc\chm\VeraCrypt User Guide.chm" docs\.
copy "..\..\..\doc\EFI-DCS\*.pdf" docs\EFI-DCS\.
del docs.zip
7z a -y docs.zip docs
"VeraCrypt Setup.exe" /p
"VeraCrypt Portable.exe" /p
call build_msi_x64.bat %VC_VERSION_NBRE%
del LICENSE
del License.txt
del NOTICE
del License.rtf
del VeraCrypt.ico
del VeraCrypt_setup_background.bmp
del VeraCrypt_setup.bmp
del Setup.ico
del "VeraCrypt User Guide.chm"
del Languages.zip
del docs.zip
rmdir /S /Q Languages
rmdir /S /Q docs

cd %SIGNINGPATH%

rem sign Setup using SHA-256
signtool sign /v /sha1 2B174F12D921AF2FF576D867BE91E97E4ADC7D07 /ac GlobalSign_SHA256_EV_CodeSigning_CA.cer /fd sha256 /tr http://timestamp.digicert.com /td SHA256 "..\Release\Setup Files\VeraCrypt Setup %VC_VERSION%.exe" "..\Release\Setup Files\VeraCrypt Portable %VC_VERSION%.exe" "..\Release\Setup Files\bin\VeraCrypt_%VC_VERSION_NBRE%_Setup_x64.msi" "..\Release\Setup Files\bin\VeraCrypt_%VC_VERSION_NBRE%_Setup_x64_en-us.msi"

pause
