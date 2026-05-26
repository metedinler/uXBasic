import { ux } from "./ux_runtime.js";

// Browser-safe file helpers. Direct arbitrary disk paths are not allowed by browsers;
// use File System Access API when available or in-memory handles otherwise.

ux.pickTextFile = async function () {
  if (!window.showOpenFilePicker) {
    ux.diag("File System Access API yok; <input type=file> fallback gerekir.", "UXB_FILE_PICKER_MISSING");
    return "";
  }
  const [handle] = await window.showOpenFilePicker();
  const file = await handle.getFile();
  return await file.text();
};

ux.saveTextFile = async function (suggestedName, text) {
  if (!window.showSaveFilePicker) {
    const blob = new Blob([String(text)], {type: "text/plain"});
    const a = document.createElement("a");
    a.href = URL.createObjectURL(blob);
    a.download = suggestedName || "uxbasic.txt";
    a.click();
    return 1;
  }
  const handle = await window.showSaveFilePicker({suggestedName: suggestedName || "uxbasic.txt"});
  const w = await handle.createWritable();
  await w.write(String(text));
  await w.close();
  return 1;
};
