(vim.cmd "cnoreabbrev nt botright vert new
          cnoreabbrev mn navigate-to-dir
          cnoreabbrev crt %!copy-releases-tracks
          cnoreabbrev mfp Mfoo
          cnoreabbrev psst %!play-selected-tracks")

(local home (os.getenv :HOME))

(local oil-abbreviations {:bl :/misc/music/backlog/
                          :mi :/misc/
                          :mu :/misc/music/
                          :no :/misc/notes/nota/
                          :rls :/misc/notes/releases/
                          :pls :/.config/mpd/playlists
                          :src :/src/})

(each [abbrev path (pairs oil-abbreviations)]
  (vim.cmd (.. "cnoreabbrev " abbrev " Oil " home path)))
