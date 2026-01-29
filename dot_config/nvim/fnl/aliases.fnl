(vim.cmd "cnoreabbrev nt botright vert new
          cnoreabbrev sct %!saturn_copy_tracks
          cnoreabbrev spt %!saturn_play_tracks")

(local home (os.getenv :HOME))

(local oil-abbreviations
       {:bl :/misc/music/backlog/
        :mi :/misc/
        :mu :/misc/music/
        :no :/misc/notes/nota/
        :src :/src/
        :rls :/misc/notes/releases/
        :pls :/.config/mpd/playlists
        :mtmn :/src/codeberg.org/mtmn})

(each [abbrev path (pairs oil-abbreviations)]
  (vim.cmd (.. "cnoreabbrev " abbrev " Oil " home path)))
