(vim.cmd "cnoreabbrev nt botright vert new
          cnoreabbrev spt %!saturn_play_tracks")

(local home (os.getenv :HOME))

(local oil-abbreviations {:mi :/misc/
                          :src :/src/})

(each [abbrev path (pairs oil-abbreviations)]
  (vim.cmd (.. "cnoreabbrev " abbrev " Oil " home path)))
