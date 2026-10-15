---
name: project-no-git-manual-zip-backups
description: "uxb git durumu (2026-10-15): origin metedinler/uXBasic, yerel main hâlâ 07550bb'de (gerçek e-postalı, gönderilmemiş; olduğu gibi push etme), MinGit kurulu, 137 değişen izlenen dosya Codex'te; git add -A YASAK; yayın dalı yayin/20261015 gönderildi (geçici indeks yöntemi); zip yedekleri duruyor."
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-10-15T12:09:23.188Z
---

Updated 2026-09-28 (Mete corrected me): `C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb\.git` exists — branch `main`
(ref fd42deeb…, 2026-09-24), remote `origin = https://github.com/metedinler/uXBasic.git`; Codex pushed the project. `.gitignore`
was cleaned (111k lines → 69). BUT there is **no `git` executable on PATH** (Git for Windows was uninstalled 2026-09-07;
Codex uses its own), so Claude/OpenClaw cannot run git commands until a git CLI is installed (needs Mete's OK to download).

Older state: before this, the repo had zero commits and Mete relied on full-folder `.zip` snapshots at the repo root
(`uxb(11.07).zip`, …, ~90 of them) — those still exist.

**Update 2026-09-28 (later):** Mete approved MinGit 2.55 (no bash) → `%LOCALAPPDATA%\Programs\MinGit\cmd\git.exe`, added to USER PATH
(new shells). Mete's condition: use git sparingly, never via bash, nothing lingering in RAM (each git call exits). At install:
HEAD fd42dee, 854 uncommitted changed files (all agents' work since 2026-09-24) — committing/pushing is outward-facing: ask Mete.

**Update 2026-09-28 (night):** Mete asked "commit the working tree". Committed `07550bb` (411 files: src M + 13 new
included src/native files + test suites run_all references), author set per-commit via GIT_AUTHOR_*/GIT_COMMITTER_* =
`metedinler <[e-posta]>` (repo config still has placeholder `Adınız`). NOT pushed. ~9700 untracked files
(tools/FreeBASIC toolchain, xtestx, logs, game/, old patch dirs) deliberately left out — Codex's last commit was
"Exclude private design and generated history from public tree". PowerShell: pass the message with `git commit -F file`
(a here-string piped to `-F -` was taken as a pathspec).

**Update 2026-10-14 (ölçüldü, hiçbir şey değiştirilmedi):** `git remote -v` tek uzak depo: `origin https://github.com/metedinler/uXBasic.git`.
`main` uzağa göre 1 commit önde (`07550bb`, yazar `metedinler <[e-posta]>`; yayınlanmış üç commit `Adınız` yer tutucusuyla;
`git config` hâlâ yer tutucu). 2 538 izlenen dosya, 137 değişen (src 121, tests 9, native 4…), `.gitignore` dışında **15 427 yeni dosya**
(tekdosyaklsoru 5 714, tools 3 926 — FreeBASIC 3 253 dahil —, docs 1 852, xtestx 1 448, tests 1 165…). `.gitignore` (69 satır) kasıtlı olarak
`/ai_koordinasyon/`, `/docs/tasarim/`, `/spec/`, `/reports/`, `/dist/`, `/bin/`, `/build/`, `/tmp/` ve `*.exe/*.dll/*.zip`'i dışarıda tutar;
`DESIGN-RIGHTS-RESERVED.md`: tasarım belgeleri yayında bilerek yoktur. `.gitnexus\lbug` 99,9 MB (GitHub sınırı 100 MB) git'e GİRMEMELİ.
Gizli anahtar taraması (değişen+yeni metin dosyaları): yalnız `change-this-token` yer tutucusu. **Göndermek 3 karar ister:** yazar e-postası
(gerçek mi, noreply mı), tasarım belgeleri yayında olacak mı (varsayılan hayır), dal (yeni dal önerilir). Plan: `ai_koordinasyon\DOSYA_ENVANTERI_VE_TEMIZLIK_ONERISI_20261014.md` bölüm 7. Bkz [[project_uxb_temizlik_github_plani_20261014]].

**Update 2026-10-15 (Mete onayıyla uygulandı):** yukarıdaki 3 karar verildi: kimlik noreply (`metedinler <62749570+metedinler@users.noreply.github.com>`), **tasarım belgeleri yayında olacak** (`.gitignore` ve `DESIGN-RIGHTS-RESERVED.md` dalda güncellendi; yalnız okumak için, lisans vermez), yeni dal. Gönderilen dal `yayin/20261015` (herkese açık depo); yerel `main`, `HEAD`, gerçek indeks, çalışma ağacı (137 değişiklik) ve yerel `.gitignore` DEĞİŞMEDİ; dal geçici indeksle kuruldu. Yerel `main` (07550bb) gerçek e-posta taşıyor: **olduğu gibi push etme**. Birleştirmeyi Mete GitHub'da yapar; sonra yerele almak için önce Codex'in yerel değişiklikleri commit'lenmeli. Ayrıntı: [[project_uxb_github_yayin_20261015]].

**Why:** undo safety depends on which mechanism is actually available; I wrongly told Mete "git yok" on 2026-09-28.
**How to apply:** check `.git` + a git binary before claiming either way. Until a git CLI exists, rely on YamaMotoru
history/rollback and direct file diffs; keep the "silme yok, sadece taşıma" rule ([[uxb-fix-plan-decisions-2026-09]]).
