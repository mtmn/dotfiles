vim.cmd("cnoreabbrev nt botright vert new\n          cnoreabbrev sct %!saturn_copy_tracks\n          cnoreabbrev spt %!saturn_play_tracks")
local home = os.getenv("HOME")
local oil_abbreviations = {bl = "/misc/music/backlog/", mi = "/misc/", mu = "/misc/music/", no = "/misc/notes/nota/", src = "/src/", rls = "/misc/notes/releases/", pls = "/.config/mpd/playlists", mtmn = "/src/codeberg.org/mtmn"}
for abbrev, path in pairs(oil_abbreviations) do
  vim.cmd(("cnoreabbrev " .. abbrev .. " Oil " .. home .. path))
end
return nil
