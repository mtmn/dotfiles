vim.cmd("cnoreabbrev nt botright vert new\n          cnoreabbrev sct %!saturn_copy_tracks\n          cnoreabbrev spt %!saturn_play_tracks")
local home = os.getenv("HOME")
local oil_abbreviations = {mi = "/misc/", mu = "/misc/music/", no = "/misc/notes/nota/", www = "/misc/notes/www/", rls = "/misc/notes/releases/", src = "/src/", cbg = "/src/codeberg.org/mtmn", tls = "/src/haravara.org/miro/tools"}
for abbrev, path in pairs(oil_abbreviations) do
  vim.cmd(("cnoreabbrev " .. abbrev .. " Oil " .. home .. path))
end
return nil
