# GitHub Setup (macOS) — SSH & HTTPS

```bash
ssh-keygen -t ed25519 -C "you@email"
eval "$(ssh-agent -s)"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519
pbcopy < ~/.ssh/id_ed25519.pub
ssh -T git@github.com
```
