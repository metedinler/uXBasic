@echo off
setlocal
python tools\uxb_surface_to_browser_contract.py --language-surface-csv dist\language_surface_matrix.csv --keyword-layer-csv dist\keyword_layer_matrix.csv --out-dir dist\browser
exit /b %ERRORLEVEL%
