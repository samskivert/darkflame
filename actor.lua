-- actor routines
-- adapted from zep

max_actors = 64

function make_actor(k,x,y,d)
  local arx = room_x
  local ary = room_y
  function check_room (rx, ry)
    return rx == arx and ry == ary
  end

  local a = {
    k=k,
    frame=0,
    frames=4,
    frame_offsets=nil,
    life = 1,
    hit_t=0,
    x=x,y=y,dx=0,dy=0,
    homex=x,homey=y,
    ddx = 0.02, -- acceleration
    ddy = 0.06, -- gravity
    w=3/8,h=0.5, -- half-width
    d=d or -1, -- direction
    bounce=0.8,
    friction=0.9,
    can_bump=true,
    dash=0,
    super=0,
    t=0,
    standing = false,
    check=check_room,
    draw=draw_actor,
    update=update_actor,
  }

  -- attributes by flag
  if (fget(k,6)) then
    a.is_pickup=true
  end

  if (fget(k,5)) then
    a.is_monster=true
    a.update=update_monster
  end

  if (fget(k,4)) then
    a.ddy = 0 -- zero gravity
  end

  -- attributes from actor_dat
  for k,v in pairs(actor_dat[k]) do
    a[k]=v
  end

  if (#actor < max_actors) then
    add(actor, a)
  end

  return a
end

-- test if a point is solid
function solid (x, y, ignore)
  if (x < 0 or x >= 128 ) then
    return true
  end

  local val = mget(x, y)

  -- flag 6: can jump up through (and only top half counts)
  if (fget(val,6)) then
    if (ignore) then
      return false
    end
    -- bottom half: solid iff solid below
    if (y%1 > 0.5) return solid(x,y+1)
  end

  -- flag 3: solid terrain tile
  return fget(val, 3)
end

function smash(x,y,b)
  local val = mget(x, y, 0)
  if (not fget(val,4)) then
    -- not smashable
    -- -> pass on to solid()
    return solid(x,y,b)
  end

  -- spawn
  if (val == 48) then
    local a=make_actor(loot[#loot], x+0.5,y-0.2)
    a.dy=-0.8
    a.d=flr(rnd(2))*2-1
    a.d=0.25 -- swirly
    loot[#loot]=nil
  end

  clear_cel(x,y)
  sfx(10)

  -- make debris
  for by=0,1 do
    for bx=0,1 do
      s=make_sparkle(22, 0.25+flr(x) + bx*0.5, 0.25+flr(y) + by*0.5, 0)
      s.dx = (bx-0.5)/4
      s.dy = (by-0.5)/4
      s.max_t = 30
      s.ddy = 0.02
    end
  end

  return false -- not solid
end

function update_actor(a)
  if (a.life <= 0) then
    del(actor,a)
  end

  a.standing=false

  -- when dashing, call smash()
  -- for any touched blocks
  -- (except for landing blocks)
  local ssolid = a.dash>0 and smash or solid

  -- solid going down -- only
  -- smash when holding down
  local ssolidd = a.dash>0 and (btn(3,a.id)) and smash or solid

  --ignore jump-up-through
  --blocks only when have gravity
  local ign=a.ddy > 0

  -- x movement

  -- candidate position
  x1 = a.x + a.dx + sgn(a.dx)/4

  if not ssolid(x1,a.y-0.5,ign) then
    -- nothing in the way->move
    a.x += a.dx
  else -- hit wall
    -- bounce
    if (a.dash > 0) sfx(12)
    a.dx *= -1
    a.hit_wall=true
    -- monsters turn around
    if (a.is_monster) then
      a.d *= -1
      a.dx = 0
    end
  end

  -- y movement
  local fw=0.25

  if (a.dy < 0) then
    -- going up
    if (ssolid(a.x-fw, a.y+a.dy-1,ign) or ssolid(a.x+fw, a.y+a.dy-1,ign)) then
      a.dy=0
      -- snap to roof
      a.y=flr(a.y+.5)
    else
      a.y += a.dy
    end
  else
    -- going down
    local y1=a.y+a.dy
    if ssolidd(a.x-fw,y1) or ssolidd(a.x+fw,y1) then
      -- bounce
      if (a.bounce > 0 and a.dy > 0.2) then
        a.dy = a.dy * -a.bounce
      else
        a.standing=true
        a.dy=0
      end
      -- snap to top of ground
      a.y=flr(a.y+0.75)
    else
      a.y += a.dy
    end
    -- pop up
    while solid(a.x,a.y-0.05) do
      a.y -= 0.125
    end
  end

  -- gravity and friction
  a.dy += a.ddy
  a.dy *= 0.95

  -- x friction
  a.dx *= 0.9
  if (a.standing) then
    a.dx *= a.friction
  end
  --end

  -- counters
  a.t = a.t + 1
end

function draw_actor(a)

  local fr=a.k
  if a.frame_offsets then
    fr += a.frame_offsets[flr(a.frame+1)]
  else
    fr += a.frame
  end

  -- rainbow colour when dashing
  if (a.dash>0) then
    for i=2,15 do pal(i,7+((a.t/2) % 8))
    end
  end

  local sx=a.x*8-4
  local sy=a.y*8-8

  -- sprite flag 3 (green): draw one pixel up
  if (fget(fr,3)) sy-=1

  -- draw the sprite
  spr(fr, sx,sy,1,1,a.d<0)

  -- sprite flag 2 (yellow): repeat top line (for mimo's ears!)
  if (fget(fr,2)) then
    pal(14,7)
    spr(fr,sx,sy-1,1,1/8, a.d<0)
  end

  pal()
end

function make_player(k, x, y, d)
  local a = make_actor(k, x, y, d)
  a.is_player=true
  a.update=update_player
  a.score   = 0
  a.bounce  = 0
  a.delay   = 0
  a.id      = 0 -- player 1
  a.life    = 6
  a.friction = 0.8
  a.frame_offsets = {0,1,0,2}
  a.check = function (rx, ry) return true end
  return a
end

function update_player(pl)
  update_actor(pl)

  if (pl.y > 18) pl.life=0

  local b = pl.id
  if (pl.life <= 0) then
    for i=1,32 do
      s=make_sparkle(69, pl.x, pl.y-0.6)
      s.dx = cos(i/32)/2
      s.dy = sin(i/32)/2
      s.max_t = 30
      s.ddy = 0.01
      s.frame=69+rnd(3)
      s.col = 7
    end

    sfx(17)
    pl.death_t=time()
    return
  end

  local accel = 0.05
  local q=0.7
  if (pl.dash > 10) then
    accel = 0.08
  end

  if (pl.super > 0) then
    q*=1.5
    accel*=1.5
  end

  if (not pl.standing) then
    accel = accel / 2
  end

  -- player control
  if (btn(0,b)) then
    pl.dx = pl.dx - accel; pl.d=-1
  end
  if (btn(1,b)) then
    pl.dx = pl.dx + accel; pl.d=1
  end
  if ((btn(4,b)) and pl.standing) then
    pl.dy = -0.5
    sfx(8)
  end

  -- charge
  -- if (btn(5,b) and pl.delay == 0) then
  --   pl.dash = 15
  --   pl.delay= 20
  --   -- charge in dir of buttons
  --   dx=0 dy=0
  --   if (btn(0,b)) dx-=1*q
  --   if (btn(1,b)) dx+=1*q

  --   -- keep controls to 4 btns
  --   if (btn(2,b)) dy-=1*q
  --   if (btn(3,b)) dy+=1*q

  --   if (dx==0 and dy==0) then
  --     pl.dx += pl.d * 0.4
  --   else
  --     local aa=atan2(dx,dy)
  --     pl.dx += cos(aa)/2
  --     pl.dy += sin(aa)/3

  --     pl.dy=max(-0.5,pl.dy)
  --   end

  --   -- tiny extra vertical boost
  --   if (not pl.standing) then
  --     pl.dy = pl.dy - 0.2
  --   end

  --   sfx(11)
  -- end

  -- super: give more dash
  if (pl.super > 0) pl.dash=2

  -- dashing
  if pl.dash > 0 then
    if (abs(pl.dx) > 0.4 or abs(pl.dy) > 0.2) then
      for i=1,3 do
        local s = make_sparkle(
          69+rnd(3),
          pl.x+pl.dx*i/3,
          pl.y+pl.dy*i/3 - 0.3,
          (pl.t*3+i)%9+7)
        if (rnd(2) < 1) then
          s.col = 7
        end
        s.dx = -pl.dx*0.1
        s.dy = -0.05*i/4
        s.x = s.x + rnd(0.6)-0.3
        s.y = s.y + rnd(0.6)-0.3
      end
    end
  end

  pl.dash = max(0,pl.dash-1)
  pl.delay = max(0,pl.delay-1)
  pl.super = max(0, pl.super-1)

  -- frame
  if (pl.standing) then
    pl.frame = (pl.frame+abs(pl.dx)*2) % pl.frames
  else
    pl.frame = (pl.frame+abs(pl.dx)/2) % pl.frames
  end

  if (abs(pl.dx) < 0.1) pl.frame = 0
end

function update_monster(m)
  update_actor(m)

  if (m.life<=0) then
    bang_puff(m.x,m.y-0.5,104)
    sfx(14)
    return
  end

  m.dx = m.dx + m.d * m.ddx
  m.frame = (m.frame+abs(m.dx)*3+4) % m.frames

  -- jump
  if (false and m.standing and rnd(10) < 1) then
    m.dy = -0.5
  end

  -- hit cooldown (can't get hit twice within half a second)
  if (m.hit_t > 0) m.hit_t -= 1
end

function init_actor_data()

  function dummy()
  end

  actor_dat={
    [23]={
      frame_offsets={0,1,0,2}
    },

    -- bridge builder
    [53]={
      ddy=0,
      friction=1,
      update=update_builder,
      draw=dummy
    },

    [64]={
      draw=draw_charge_powerup
    },

    [65]={
      draw=draw_exit
    },

    -- swirly
    [80]={
      life=2,
      frames=1,
      bounce=0,
      ddy=0, -- gravity
      update=update_swirly,
      draw=draw_swirly,
      can_bump=false,
      d=0.25,
      r=5 -- collisions
    },

    -- bouncy mushroom
    [82]={
      ddx=0,
      frames=1,
      active_t=0,
      update=update_mushroom
    },

    -- glitch mushroom
    [84]={
      draw=draw_glitch_mushroom
    },

    -- bird
    [93]={
      update=update_bird,
      draw=draw_bird,

      bounce=0,
      ddy=0.03,-- default:0.06
    },

    -- frog
    [96]={
      update=update_frog,
      draw=draw_frog,
      bounce=0,
      friction=1,
      tongue=0,
      tongue_t=0
    },

    [116]={
      draw=draw_tail
    }
  }
end
