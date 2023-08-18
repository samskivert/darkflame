-- themes (backgrounds)

level=1
room_x=0
room_y=0

theme_dat={
  [1]={
    sky={12,12,12,12,12},
    bgels={
      { -- clouds
        src={16,56,16,8},
        xyz = {0,28*4,4,true},
        dx=-8,
        cols={15,7,1,-1},
        fill_down = 12
      },
      { -- mountains
        src={0,56,16,8},
        xyz = {0,28*4,4,true},
        fill_down=13,
      },
      { -- leaves: light
        src={32,48,16,6},
        xyz = {(118*8),-8,1.5},
        cols={1,3},
        fill_up=1
      },
      { -- leaves: dark (foreground)
        src={32,48,16,6},
        xyz = {(118*8),-12,0.8},
        cols={3,1},
        fill_up=1
      },
    }
  },

  --------------------------
  -- level 2
  [2]={
    sky={12},
    bgels={
      { -- gardens
        src={32,56,16,8},
        xyz = {0,100,4,true},
        --cols={7,6,15,6},
        cols={3,13,7,13,10,13,1,13,11,13,9,13,14,13,15,13,2,13},
        fill_down=13
      },
      { -- foreground shrubbery
        src={16,56,16,8},
        xyz = {0,64*0.8,0.6,true},
        cols={15,1,7,1},
        fill_down = 12
      },
      { -- foreground shrubbery feature
        src={32,56,8,8},
        xyz = {60,60*0.9,0.8,false},
        cols={15,1,7,1,3,1,11,1,10,1,9,1},
      },
      { -- foreground shrubbery feature
        src={32,56,8,8},
        xyz = {260,60*0.9,0.8,false},
        cols={15,1,7,1,3,1,11,1,10,1,9,1},
      },
      { -- leaves: indigo
        src={32,48,16,6},
        xyz = {40,64,4,true},
        cols={1,13,3,13},
        fill_up=13
      },
      { -- leaves: light
        src={32,48,16,6},
        xyz = {0,-4,1.5,true},
        cols={1,3},
        fill_up=1
      },
      { -- leaves: dark (foreground)
        src={32,48,16,6},
        xyz = {-40,-6,0.8,true},
        cols={3,1},
        fill_up=1
      }
    },
  },

  ----------------
  -- double mountains
  [3]={
    sky={12,14,14,14,14},
    bgels={
      { -- mountains indigo (far)
        src={0,56,16,8},
        xyz = {-64,30,8,true},
        fill_down=13,
        cols={6,15,13,6}
      },
      { -- clouds inbetween
        src={16,56,16,8},
        xyz = {0,50,8,true},
        dx=-30,
        cols={15,7,1,-1},
        fill_down = 7
      },
      { -- mountains close
        src={0,56,16,8},
        xyz = {0,140,8,true},
        fill_down=13,
        cols={6,5,13,1}
      },
    }
  },

}

function show_room (rx, ry)
  cls()
  room_x = rx
  room_y = ry

  local rsize = 12
  local loff = (16-rsize)/2
  for y=0,rsize-1 do
    memcpy(0x2000+128*loff+128*ry*rsize+128*y+loff, 0x2000+128*y+16+rx*rsize, rsize)
  end
end

function room_update ()
  local p1 = pl[1]
  if (p1.x > 14) then
    show_room(room_x+1, room_y)
    p1.x -= 12
  elseif p1.x < 2 then
    show_room(room_x-1, room_y)
    p1.x += 12
  end
  -- TODO: moving up and down? or will we warp to new areas?
end

function init_level(lev)
  level=lev
  level_t = 0
  death_t = 0
  finished_t = 0
  gems = 0
  gem_sfx = {}
  total_gems = 0
  glitch_mushroom = false

  music(-1)

  if play_music then
    if (level==1) music(0)
    if (level==2) music(4)
    if (level==3) music(16)
  end

  actor = {}
  sparkle = {}
  pl = {}
  loot = {}

  reset()
  reload()

  show_room(room_x, room_y)

  -- spawn player
  for y=0,15 do for x=0,127 do
    local val=mget(x, y)
    if (val == 1) then
      clear_cel(x, y)
      pl[1] = make_player(1, x+0.5, y+0.5, 1)
    end

    -- count gems
    if (val==67) then
      total_gems+=1
    end

    -- lootboxes
    if (val==48) then
      add(loot,67)
    end
  end end

  local num_booby=0
  -- shuffle lootboxes
  if (#loot > 1) then
    -- ~25% are booby prizes
    num_booby=flr((#loot+2) / 4)
    for i=1,num_booby do
      loot[i]=96
      if (rnd(10)<1) then
        loot[i]=84 -- mushroom
      end
    end

    -- shuffle
    for i=1,#loot do
      -- swap 2 random items
      j=flr(rnd(#loot))+1
      k=flr(rnd(#loot))+1
      loot[j],loot[k]=loot[k],loot[j]
    end
  end

  total_gems += #loot - num_booby
  if (not pl[1]) then
    pl[1] = make_player(72,4,4,1)
  end
end
