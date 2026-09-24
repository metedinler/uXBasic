#!/usr/bin/env python3
from pathlib import Path
import json, csv, datetime
root=Path(__file__).resolve().parents[3]
deps=root/'uxb/dist/runtime_ext/deps/uxllama'
deps.mkdir(parents=True,exist_ok=True)
items=[
 {'name':'llama.cpp','role':'LLM inference CLI','source':'https://github.com/ggml-org/llama.cpp','local_path':str((deps/'llama.cpp')).replace('\\','/')},
 {'name':'llama-cli.exe','role':'CPU text completion executable','source':'built from llama.cpp','local_path':str((deps/'llama-cli.exe')).replace('\\','/')},
 {'name':'uxllama.dll','role':'uXBasic DLL wrapper','source':'uxb/runtime_ext/uxllama','local_path':str((root/'uxb/dist/runtime_ext/uxllama.dll')).replace('\\','/')},
]
for it in items: it['exists']=Path(it['local_path']).exists()
reg={'schema_version':'uxllama-dependency-registry-1','generated_at':datetime.datetime.now().isoformat(timespec='seconds'),'items':items}
(deps/'uxllama_dependency_registry.json').write_text(json.dumps(reg,indent=2),encoding='utf-8')
with (deps/'uxllama_dependency_registry.csv').open('w',newline='',encoding='utf-8') as f:
    w=csv.DictWriter(f,fieldnames=['name','role','source','local_path','exists']); w.writeheader(); w.writerows(items)
print('OK:',deps/'uxllama_dependency_registry.json')
