@echo off

PowerShell.exe -executionpolicy unrestricted -Command "& '"%~dp0UpdateScript (nulstilling).ps1"' -Verb RunAs"

pause