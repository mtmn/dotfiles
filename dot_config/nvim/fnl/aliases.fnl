(vim.cmd "cnoreabbrev nt botright vert new
          cnoreabbrev sct %!saturn_copy_tracks
          cnoreabbrev spt %!saturn_play_tracks")

(local home (os.getenv :HOME))

(local oil-abbreviations
       {:mi :/misc/
        :mu :/misc/music/
        :no :/misc/notes/nota/
        :www :/misc/notes/www/
        :rls :/misc/notes/releases/
        :src :/src/
        :cbg :/src/codeberg.org/mtmn
        :tls :/src/haravara.org/miro/tools})

(each [abbrev path (pairs oil-abbreviations)]
  (vim.cmd (.. "cnoreabbrev " abbrev " Oil " home path)))
