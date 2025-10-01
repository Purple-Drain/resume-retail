# JB Hi-Fi Burwood — Safe Mode Expanded (v3.1)

Fully expanded. Resume + Cover + Application Pack in all three folders. JB-only extras live in `jb_hifi/`.

## Windows (PowerShell)
```powershell
.\scripts\quick_build.ps1         # PDFs + DOCX (fallbacks)
.\scripts\quick_build.ps1 -NoDocx # PDFs only
.\scripts\build.ps1 -Docx         # PDFs + DOCX
```

## macOS / Linux / WSL
```bash
make all
```

## Repo init & push (one-shot)
**Windows (PowerShell):**
```powershell
# SSH
.\scripts\init_repo.ps1 -Repo . -Remote "git@github.com:<user>/<repo>.git"
# HTTPS
.\scripts\init_repo.ps1 -Repo . -Remote "https://github.com/<user>/<repo>.git"
```

**macOS / Linux / WSL:**
```bash
./scripts/init_repo.sh "git@github.com:<user>/<repo>.git"
# or HTTPS
./scripts/init_repo.sh "https://github.com/<user>/<repo>.git"
```

## Release
- Edit VERSION (current: 1.0.1), commit & push.
- Run `make release` then `git push origin v1.0.1` to trigger CI GitHub Release.


### Repo structure
- resume/main — standard resume, cover, application pack
- resume/jb — JB Hi‑Fi specific resume, cover, application pack

### SSH success message
If you see `Hi <username>! You've successfully authenticated, but GitHub does not provide shell access.` — that's expected.
