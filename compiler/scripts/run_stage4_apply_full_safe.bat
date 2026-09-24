@echo off
setlocal
cd /d "%~dp0..\..\.."
python uxb\tools\uxb_stage4_source_artifact_audit.py --apply --move-tests-to-root --move-root-src-duplicate
endlocal
