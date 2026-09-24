@echo off
setlocal
for %%F in (tests\step3_semantic_type_layout\*.bas) do call compiler\scripts\run_step3_semantic_type_layout_gate.bat "%%F"
endlocal
