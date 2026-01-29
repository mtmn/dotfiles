# dotfiles
Configuration files that I use across all of my machines.
```bash
chezmoi init https://codeberg.org/mtmn/dotfiles.git # https://www.chezmoi.io/quick-start
chezmoi apply --dry-run --verbose # remove `--dry-run` to apply all files
chezmoi apply ~/.zshrc # you can apply individual files as well
```
![](docs/screenshot.png)
