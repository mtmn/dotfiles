vim.cmd("cnoreabbrev nt botright vert new\n          cnoreabbrev spt %!saturn_play_tracks")
local home = os.getenv("HOME")
local oil_abbreviations = {mi = "/misc/", src = "/src/"}
for abbrev, path in pairs(oil_abbreviations) do
  vim.cmd(("cnoreabbrev " .. abbrev .. " Oil " .. home .. path))
end
return nil
