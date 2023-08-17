
corrupt_mode = false
paint_mode = false
max_actors = 64
play_music = true

function make_sparkle(k,x,y,col)
  local s = {
    x=x,y=y,k=k,
    frames=1,
    col=col,
    t=0, max_t = 8+rnd(4),
    dx = 0, dy = 0,
    ddy = 0
  }
  if (#sparkle < 512) then
    add(sparkle,s)
  end
  return s
end

function move_sparkle(sp)
  if (sp.t > sp.max_t) then
    del(sparkle,sp)
  end

  sp.x = sp.x + sp.dx
  sp.y = sp.y + sp.dy
  sp.dy= sp.dy+ sp.ddy
  sp.t = sp.t + 1
end

function bang_puff(mx,my,sp)
  local aa=rnd(1)
  for i=0,5 do
    local dx=cos(aa+i/6)/4
    local dy=sin(aa+i/6)/4
    local s=make_sparkle(sp,mx + dx, my + dy)
    s.dx = dx
    s.dy = dy
    s.max_t=10
  end
end

function atomize_sprite(s,mx,my,col)
  local sx=(s%16)*8
  local sy=flr(s/16)*8
  local w=0.04

  for y=0,7 do
    for x=0,7 do
      if (sget(sx+x,sy+y)>0) then
        local q=make_sparkle(0, mx+x/8, my+y/8)
        q.dx=(x-3.5)/32 +rnd(w)-rnd(w)
        q.dy=(y-7)/32   +rnd(w)-rnd(w)
        q.max_t=20+rnd(20)
        q.t=rnd(10)
        q.spin=0.05+rnd(0.1)
        if (rnd(2)<1) q.spin*=-1
        q.ddy=0.01
        q.col=col or sget(sx+x,sy+y)
      end
    end
  end
end


-- clear_cel using neighbour val; prefer empty, then non-ground then left neighbour
function clear_cel(x, y)
  local val0 = mget(x-1,y)
  local val1 = mget(x+1,y)
  if ((x>0 and val0 == 0) or
      (x<127 and val1 == 0)) then
    mset(x,y,0)
  elseif (not fget(val1,1)) then
    mset(x,y,val1)
  elseif (not fget(val0,1)) then
    mset(x,y,val0)
  else
    mset(x,y,0)
  end
end

function move_spawns(x0, y0)
  x0=flr(x0)
  y0=flr(y0)
  -- spawn actors close to x0,y0
  for y=0,16 do
    for x=x0-10,max(16,x0+14) do
      local val = mget(x,y)
      -- actor
      if (fget(val, 5)) then
        m = make_actor(val,x+0.5,y+1)
        clear_cel(x,y)
      end
    end
  end
end

function alive(a)
  if (not a) return false
  return not (a.life <=0 and (a.death_t and time() > a.death_t+0.5))
end

function outgame_logic()
  if death_t==0 and not alive(pl[1]) and not alive(pl[2]) then
    death_t=1
    music(-1)
    sfx(5)
  end

  if (finished_t > 0) then
    finished_t += 1
    if (finished_t > 60) then
      if (btnp(❎)) then
        fade_out()
        init_level(level+1)
      end
    end
  end

  if (death_t > 0) then
    death_t = death_t + 1
    if (death_t > 45 and
        btn()>0)
      then
      music(-1)
      sfx(-1)
      sfx(0)
      fade_out()
      -- restart cart end of slice
      init_level(level)
    end
  end
end

function monster_hit(m)
  if (m.hit_t>0) return

  m.life-=1
  m.hit_t=15
  m.dx/=4
  m.dy/=4
  -- survived: thunk sound
  if (m.life>0) sfx(21)
end

function player_hit(p)
  if (p.dash>0) return
  p.life-=1
end

function collide_event(a1, a2)
  if (a1.is_monster and a1.can_bump and a2.is_monster) then
    local d=sgn(a1.x-a2.x)
    if (a1.d!=d) then
      a1.dx=0
      a1.d=d
    end
  end

  -- bouncy mushroom
  if (a2.k==82) then
    if (a1.dy > 0 and not a1.standing) then
      a1.dy=-1.1
      a2.active_t=6
      sfx(18)
    end
  end

  if(a1.is_player) then
    if(a2.is_pickup) then
      if (a2.k==64) then
        a1.super = 30*4
        --sfx(17)
        a1.dx = a1.dx * 2
        --a1.dy = a1.dy-0.1
        -- a1.standing = false
        sfx(13)
      end

      -- watermelon
      if (a2.k==80) then
        a1.score+=5
        sfx(9)
      end

      -- end level
      if (a2.k==65) then
        finished_t=1
        bang_puff(a2.x,a2.y-0.5,108)
        del(actor,pl[1])
        del(actor,pl[2])
        music(-1,500)
        sfx(24)
      end

      -- glitch mushroom
      if (a2.k==84) then
        glitch_mushroom = true
        sfx(29)
      end

      -- gem
      if (a2.k==67) then
        a1.score = a1.score + 1
        -- total gems between players
        gems+=1
      end

      -- bridge builder
      if (a2.k==99) then
        local x,y=flr(a2.x)+.5,flr(a2.y+0.5)
        for xx=-1,1 do
          if (mget(x+xx,y)==0) then
            local a=make_actor(53,x+xx,y+1)
            a.dx=xx/2
          end
        end
      end

      a2.life=0

      s=make_sparkle(85,a2.x,a2.y-.5)
      s.frames=3
      s.max_t=15
      sfx(9)
    end

    -- charge or dupe monster
    if(a2.is_monster) then -- monster
      if ((a1.dash > 0 or a1.y < a2.y-a2.h/2) and a2.can_bump) then
        -- slow down player
        a1.dx *= 0.7
        a1.dy *= -0.7
        if (btn(🅾️,a1.id)) a1.dy -= .5
        monster_hit(a2)
      else
        -- player death
        a1.life=0
      end
    end
  end
end

function collide(a1, a2)
  if (not a1) return
  if (not a2) return
  if (a1==a2) return

  local dx = a1.x - a2.x
  local dy = a1.y - a2.y
  if (abs(dx) < a1.w+a2.w) then
    if (abs(dy) < a1.h+a2.h) then
      collide_event(a1, a2)
      collide_event(a2, a1)
    end
  end
end

function collisions()
  -- to do: optimize if too many actors
  for i=1,#actor do
    for j=i+1,#actor do
      collide(actor[i],actor[j])
    end
  end
end

-- called at start by pico-8
function _init()
  init_actor_data()
  init_level(level)

  menuitem(1, "restart level",
           function()
             init_level(level)
           end)
end

function _update()
  for a in all(actor) do
    a:update()
  end

  foreach(sparkle, move_sparkle)
  collisions()

  for i=1,#pl do
    move_spawns(pl[i].x,0)
  end

  outgame_logic()
  -- update_camera()

  if (glitch_mushroom or corrupt_mode) then
    for i=1,4 do
      poke(rnd(0x8000),rnd(0x100))
    end
  end

  level_t += 1
end

function draw_sparkle(s)
  --spinning
  if (s.k == 0) then
    local sx=s.x*8
    local sy=s.y*8
    line(sx,sy,
         sx+cos(s.t*s.spin)*1.4,
         sy+sin(s.t*s.spin)*1.4,
         s.col)
    return
  end

  if (s.col and s.col > 0) then
    for i=1,15 do
      pal(i,s.col)
    end
  end

  local fr = s.frames * s.t/s.max_t
  fr = s.k+mid(0,fr,s.frames-1)
  spr(fr, s.x*8-4, s.y*8-4)

  pal()
end

function apply_paint()
  if (tt==nil) tt=0
  tt=tt+0.25
  srand(flr(tt))
  local nn=rnd(128)
  local xx=0
  local yy=band(nn,127)
  for i=1,1000*13,13 do
    nn+=i
    nn*=33
    xx=band(nn,127)
    local col=pget(xx,yy)
    rectfill(xx,yy,xx+1,yy+1,col)
    line(xx-1,yy-1,xx+2,yy+2,col)
    nn+=i
    nn*=57
    yy=band(nn,127)
    rectfill(xx-1,yy-1,xx,yy,pget(xx,yy))
  end
end

-- draw the world at sx,sy with a view size: vw,vh
function draw_world(sx,sy,vw,vh,cam_x,cam_y)
  -- reduce jitter
  cam_x=flr(cam_x)
  cam_y=flr(cam_y)

  if (level>=4) cam_y = 0

  clip(sx,sy,vw,vh)
  cam_x -= sx

  local ldat=theme_dat[level]
  if (not ldat) ldat={}

  -- sky
  camera (cam_x/4, cam_y/4)

  -- sample palette colour
  local colx=120+level

  -- -- sky gradient
  -- if (ldat.sky) then
  --   for y=cam_y,127 do
  --     col=ldat.sky[flr(mid(1,#ldat.sky, (y+(y%4)*6) / 16))]
  --     line(0,y,511,y,col)
  --   end
  -- end

  -- elements
  for pass=0,1 do
    camera()

    -- for el in all(ldat.bgels) do
    --   if (pass==0 and el.xyz[3]>1) or (pass==1 and el.xyz[3]<=1) then
    --     pal()
    --     if (el.cols) then
    --       for i=1,#el.cols, 2 do
    --         if (el.cols[i+1]==-1) then
    --           palt(el.cols[i],true)
    --         else
    --           pal(el.cols[i],el.cols[i+1])
    --         end
    --       end
    --     end

    --     local s=el.src
    --     local pixw=s[3] * 8
    --     local pixh=s[4] * 8
    --     local sx=el.xyz[1]
    --     if (el.dx) then
    --       sx += el.dx*t()
    --     end

    --     local sy=el.xyz[2]
    --     sx = (sx-cam_x)/el.xyz[3]
    --     sy = (sy-cam_y)/el.xyz[3]

    --     repeat
    --       map(s[1],s[2],sx,sy,s[3],s[4])
    --       if (el.fill_up) then
    --         rectfill(sx,-1,sx+pixw-1,sy-1,el.fill_up)
    --       end
    --       if (el.fill_down) then
    --         rectfill(sx,sy+pixh,sx+pixw-1,128,el.fill_down)
    --       end
    --       sx+=pixw
    --     until sx >= 128 or not el.xyz[4]
    --   end
    -- end
    -- pal()

    if (pass==0) then
      draw_z1(cam_x,cam_y)
    end
  end

  clip()
end

-- map and actors
function draw_z1(cam_x,cam_y)
  camera (cam_x,cam_y)
  pal(12,0) -- 12 is transp
  map (0,0,0,0,128,64,0)
  pal()
  foreach(sparkle, draw_sparkle)
  for a in all(actor) do
    pal()
    if (a.hit_t>0 and a.t%4 < 2) then
      for i=1,15 do
        pal(i,8+(a.t/4)%4)
      end
    end
    a:draw() -- same as a.draw(a)
  end
  -- forground map
  map (0,0,0,0,128,64,1)
end

function draw_finished(tt)
  if (tt < 15) return
  tt -= 15

  local str="★ stage clear ★  "

  print(str,64-#str*2,31,14)
  print(str,64-#str*2,30,7)

  -- gems
  local n = total_gems

  for i=1,15 do
    pal(i,13)
  end

  for pass=0,1 do
    for i=0,n-1 do
      t2=tt-(i*4+15)
      q=i<gems and t2>=0
      if (pass == 0 or q) then
        local y=50-pass
        if (q) then
          y+=sin(t2/8)*4/(t2/2)
          if (not gem_sfx[i]) sfx(25)
          gem_sfx[i]=true
        end
        spr(67,64-n*4+i*8,y)
      end
    end
    pal()
  end

  if (tt > 45) then
    print("❎ continue",42,91,12)
    print("❎ continue",42,90,7)
  end
end

function fade_out()
  dpal={0,1,1, 2,1,13,6,4,4,9,3, 13,1,13,14}
  -- palette fade
  for i=0,40 do
    for j=1,15 do
      col = j
      for k=1,((i+(j%5))/4) do
        col=dpal[col]
      end
      pal(j,col,1)
    end
    flip()
  end
end

function _draw()
  if false then -- debug white background
    cls(7)
    rectfill(3*8, 3*8, 13*8-1, 13*8-1, 7)
  else
    cls(1)
    rectfill(3*8, 3*8, 13*8-1, 13*8-1, 0)
  end

  -- decide which side to draw
  -- player 1 view
  local view0_x = 0
  if (split and pl[1].x > pl[2].x) then
    view0_x = 64
  end

  draw_world(view0_x,0,128,128, cam_x,cam_y)

  camera()
  pal()
  clip()
  if (split) line(64,0,64,128,0)

  -- player score
  camera(0,0)
  color(7)

  if (death_t > 45) then
    print("❎ restart",
          44,10+1,14)
    print("❎ restart",
          44,10,7)
  end

  if (finished_t > 0) then
    draw_finished(finished_t)
  end

  if (paint_mode) apply_paint()

  -- draw_sign()
end
