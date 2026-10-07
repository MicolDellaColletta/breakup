@echo off
rem Runs the story checker and the playthrough tests without opening a window.
rem Double-click this file, or run it from a terminal in the project folder.
rem If Godot moves, change the path on the next line.
set GODOT=C:\Users\clari\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe

cd /d "%~dp0.."
set FAILED=0
for %%T in (check_story test_prologue test_day_one test_evening test_night test_menu) do (
	echo.
	echo ===== %%T
	"%GODOT%" --headless --path . --script res://tests/%%T.gd
	if errorlevel 1 set FAILED=1
)
echo.
if %FAILED%==1 (echo SOME TESTS FAILED) else (echo ALL TESTS PASSED)
pause
