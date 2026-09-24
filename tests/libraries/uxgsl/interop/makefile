all: imports link

imports:
	cmd /c build_import.bat

link:
	cmd /c link_command.bat

clean:
	del /Q import_objs\*.o 2>nul
	del /Q interop_program.exe 2>nul
