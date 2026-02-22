vim.cmd("cnoreabbrev nt botright vert new\n          cnoreabbrev mft %!saturn_fetch_tracks\n          cnoreabbrev mat %!saturn_add_tracks\n          cnoreabbrev mpc %!mpc clear\n          cnoreabbrev mpl %!mpc play")
local home = os.getenv("HOME")
local oil_abbreviations = {mi = "/misc/", mu = "/misc/music/", no = "/misc/notes/nota/", www = "/misc/notes/www/", rls = "/misc/notes/releases/", src = "/src/", cbg = "/src/codeberg.org/mtmn", tls = "/src/haravara.org/miro/tools"}
for abbrev, path in pairs(oil_abbreviations) do
  vim.cmd(("cnoreabbrev " .. abbrev .. " Oil " .. home .. path))
end
return nil
