-- [nfnl] aliases.fnl
vim.cmd("cnoreabbrev nt botright vert new\n          cnoreabbrev mn navigate-to-dir\n          cnoreabbrev crt %!copy-releases-tracks\n          cnoreabbrev mfp Mfoo\n          cnoreabbrev pst %!play-selected-tracks")
local home = os.getenv("HOME")
local oil_abbreviations = {bl = "/misc/music/backlog/", mi = "/misc/", mu = "/misc/music/", no = "/misc/notes/nota/", rls = "/misc/notes/releases/", pls = "/.config/mpd/playlists", src = "/src/"}
for abbrev, path in pairs(oil_abbreviations) do
  vim.cmd(("cnoreabbrev " .. abbrev .. " Oil " .. home .. path))
end
return nil
