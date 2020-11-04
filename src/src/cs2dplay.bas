''
'' CS2D player module - players control
''
'' aug/2004 - written [v1ctor]
''


defint a-z
'$include: 'inc\2dfx.bi'
'$include: 'inc\dos.bi'
'$include: 'inc\cs2d.bi'
'$include: 'inc\cs2dint.bi'


declare function 	cs2dPlayerMoveHorz%	( cm as CS2DMAP, ti() as integer, _
										  byval px as single, byval py as single, _
										  byval prad as integer, xinc as single )

declare function 	cs2dPlayerMoveVert%	( cm as CS2DMAP, ti() as integer, _
										  byval px as single, byval py as single, _
										  byval prad as integer, yinc as single )

''globals

redim shared pTB( 0 ) as CS2DPLAYER

'':::::
sub cs2dPlayerInit

	redim pTB( 0 to CS2D.MAXPLAYERS-1 ) as CS2DPLAYER

end sub

'':::::
sub cs2dPlayerEnd

	erase pTB

end sub

'':::::
function cs2dPlayerFindStart% ( cm as CS2DMAP, byval typ as integer, _
								sx as single, sy as single, angle as integer )
    dim eTB(0 to 31) as integer

	if( typ = CS2D.PLAYER.CTERRORIST ) then
		entity = CS2D.ENT.INFOCT
	else
		entity = CS2D.ENT.INFOT
	end if

	cs2dPlayerFindStart = 0

	j = 0
	for e = 0 to cm.entities-1

		i = entTB(e).idx

		if( i <> -1 ) then
			select case entTB(e).typ
			case entity
				eTB(j) = e
				j = j + 1
				if( j > 31 ) then exit for
			end select
		end if
	next e

    if( j > 0 ) then
    	f = cint( rnd*(j-1) )
    	if( f > j-1 ) then f = j-1
    	e = eTB( f )

		sx = entTB(e).xpos * cm.ts.tilews + (cm.ts.tilews\2)
		sy = entTB(e).ypos * cm.ts.tilehs + (cm.ts.tilehs\2)
		angle = entINFOT( entTB(e).idx ).startangle

		cs2dPlayerFindStart = -1
	end if

end function

'':::::
sub setupWeapons( player as CS2DPLAYER )

	if( player.priweapon = 0 ) then
		player.priweapon = CS2D.DEFAULT.PRIWEAPON

		player.priammo = weaponTB(player.priweapon).maxammo
		if( player.isbot ) then
			player.prirefill = player.priammo*2
		else
			player.prirefill = 0
		end if
	end if

	if( player.secweapon = 0 ) then
		player.secweapon = CS2D.DEFAULT.SECWEAPON

		if( player.secweapon <> 0 ) then
			player.secammo = weaponTB(player.secweapon).maxammo
		else
			player.secammo = 0
		end if

		if( player.isbot ) then
			player.secrefill = player.secammo*2
		else
			player.secrefill = 0
		end if
	end if

	if( player.weapon = 0 ) then
		player.weapon = CS2D.WEAPON.PRIMARY
	end if

	player.reload = 0

end sub

'':::::
sub cs2dPlayerStart ( cm as CS2DMAP )
    dim x as single, y as single, angle as integer

	for i = 0 to cm.players-1

		''
		pTB(i).state 	= CS2D.PSTAT.WALKING

    	''
    	if( not cs2dPlayerFindStart( cm, pTB(i).typ, x, y, angle ) ) then
    	end if

		pTB(i).x		= x
		pTB(i).y		= y
		pTB(i).angle	= angle

		'' origin
		pTB(i).ox		= int( x )
		pTB(i).oy		= int( y )

    	pTB(i).step		= 0

    	''
		pTB(i).health	= CS2D.DEFAULT.HEALTH
		if( pTB(i).points <= 0 ) then
			pTB(i).points = CS2D.DEFAULT.POINTS
		end if
		if( pTB(i).energy < 0 ) then
			pTB(i).energy = CS2D.DEFAULT.ENERGY
		end if

		''
		setupWeapons pTB(i)

	next i

end sub

'':::::
sub cs2dPlayerRestart ( cm as CS2DMAP, byval winner as integer )

	cs2dPlayerStart cm

    if( winner <> -1 ) then
    	for i = 0 to cm.players-1
    		if( pTB(i).typ = winner ) then
    			pTB(i).points = pTB(i).points + CS2D.POINTS.WINNER
    			if( pTB(i).points > CS2D.POINTS.MAX ) then
    				pTB(i).points = CS2D.POINTS.MAX
    			end if
    		end if
    	next i
    end if

end sub

'':::::
function cs2dPlayerNew%( cm as CS2DMAP, pname as string, _
				         byval typ as integer, byval team as integer, _
					     byval isbot as integer )

	static c as integer

	pTB(c).id	= c

	pTB(c).name = pname
	pTB(c).state= 0

	pTB(c).typ	= typ
	pTB(c).team	= team
	pTB(c).isbot= isbot

	pTB(c).x	= 0
	pTB(c).y	= 0
	pTB(c).angle= 0
	pTB(c).step	= 0

	pTB(c).xinc	= 0
	pTB(c).yinc	= 0
	pTB(c).speed= (1 * env.scale) * (CS2D.BASE.FPS / env.fps)

    '' weapons
    setupWeapons pTB(c)

	''
	pTB(c).energy	= CS2D.DEFAULT.ENERGY
	pTB(c).health	= CS2D.DEFAULT.HEALTH
	pTB(c).points	= CS2D.DEFAULT.POINTS

	cm.players	 = cm.players + 1

	cs2dPlayerNew = c

	c = c + 1

end function

'':::::
function cs2dPlayerAdd% ( cm as CS2DMAP, pname as string, byval typ as integer, byval team as integer )
	dim x as single, y as single, angle as integer
	dim p as integer

    cs2dPlayerAdd = -1

    p = cs2dPlayerNew( cm, pname, typ, team, 0 )

    cs2dPlayerAdd = p

end function

'':::::
function cs2dPlayerMoveHorz%( cm as CS2DMAP, ti() as integer, byval px as single, byval py as single, _
							  byval prad as integer, xinc as single ) static
	dim cmapofs as long
	dim x as integer, y as integer
	dim tx as single, ty as single

	cs2dPlayerMoveHorz = 0

	def seg = cm.map \ 65536&
	cmapofs = cm.map and &h0000FFFF&

    ty = py - prad
    tx = px + xinc
    for i = 0 to 1
    	x = int(tx) \ cm.ts.tilews
    	y = int(ty) \ cm.ts.tilehs

    	tofs = (y * cm.xsize) + x
    	t = peek( cmapofs + tofs )

    	select case ti(t)
    	case CS2D.TILE.WALL, CS2D.TILE.OBSTACLE, CS2D.TILE.BLOCK, IS >= CS2D.TILE.DEADLYNORMAL
    		if( sgn(xinc) = -1 ) then
	    		xinc = ((x * cm.ts.tilews + cm.ts.tilews-0) - int(px))
    		else
    			xinc = ((x * cm.ts.tilews) - int(px)) - 1
    		end if
    		cs2dPlayerMoveHorz = 1
    		exit for
    	end select

    	ty = ty + prad*2
    next i

end function

'':::::
function cs2dPlayerMoveVert%( cm as CS2DMAP, ti() as integer, byval px as single, byval py as single, _
							  byval prad as integer, yinc as single ) static
	dim cmapofs as long
	dim x as integer, y as integer
	dim tx as single, ty as single

	cs2dPlayerMoveVert = 0

	def seg = cm.map \ 65536&
	cmapofs = cm.map and &h0000FFFF&

    tx = px - prad
    ty = py + yinc
    for i = 0 to 1
    	x = int(tx) \ cm.ts.tilews
    	y = int(ty) \ cm.ts.tilehs

    	tofs = (y * cm.xsize) + x
    	t = peek( cmapofs + tofs )

    	select case ti(t)
    	case CS2D.TILE.WALL, CS2D.TILE.OBSTACLE, CS2D.TILE.BLOCK, IS >= CS2D.TILE.DEADLYNORMAL
    		if( sgn(yinc) = -1 ) then
	    		yinc = ((y * cm.ts.tilehs + cm.ts.tilehs-0) - int(py))
    		else
    			yinc = ((y * cm.ts.tilehs) - int(py)) - 1
    		end if

    		cs2dPlayerMoveVert = 1
    		exit for
    	end select

    	tx = tx + prad*2
    next i

end function

'':::::
function cs2dPlayerMove%( cm as CS2DMAP, ti() as integer, byval p as integer ) static
	dim xinc as single, yinc as single
	dim pradw as integer, pradh as integer
	dim x as single, y as single

	cs2dPlayerMove = 0

	xinc = pTB(p).xinc * pTB(p).speed
	yinc = pTB(p).yinc * pTB(p).speed

	if( (xinc = 0) and (yinc = 0) ) then
		exit function
	end if

	x = pTB(p).x
	y = pTB(p).y

	pradw = ((cm.ts.tilew-4)\2) * env.scale
	pradh = ((cm.ts.tileh-4)\2) * env.scale

	horz = 0
	select case sgn(xinc)
	case -1
		horz = cs2dPlayerMoveHorz( cm, ti(), x-pradw, y, pradw, xinc )
	case 1
		horz = cs2dPlayerMoveHorz( cm, ti(), x+pradw, y, pradw, xinc )
	end select

	vert = 0
	select case sgn(yinc)
	case -1
		vert = cs2dPlayerMoveVert( cm, ti(), x, y-pradh, pradh, yinc )
	case 1
		vert = cs2dPlayerMoveVert( cm, ti(), x, y+pradh, pradh, yinc )
	end select

	if( sgn( xinc ) = sgn( pTB(p).xinc ) ) then
		pTB(p).x = pTB(p).x + xinc
	end if
	if( sgn( yinc ) = sgn( pTB(p).yinc ) ) then
		pTB(p).y = pTB(p).y + yinc
	end if

	if( (xinc <> 0) or (yinc <> 0) ) then
		s = cint( (4 / pTB(p).speed) / env.scale )
		pTB(p).step = (pTB(p).step + 1) mod (8*s)

		cs2dPlayerMove = horz or vert

	else
		cs2dPlayerMove = -1

		pTB(p).step = 0
	end if

end function

'':::::
function cs2dPlayerUpdate%( cm as CS2DMAP, ti() as integer, byval p as integer, _
						   byval xinc as single, byval yinc as single, byval angle as integer ) static

	cs2dPlayerUpdate = 0

	pTB(p).angle = angle
    pTB(p).xinc = xinc
    pTB(p).yinc = yinc

	if( pTB(p).state and CS2D.PSTAT.SPECTATING ) then
		pTB(p).x = pTB(p).x + xinc * pTB(p).speed*2
		pTB(p).y = pTB(p).y + yinc * pTB(p).speed*2
		cs2dPlayerUpdate = -1
		exit function
	end if

	if( pTB(p).state and CS2D.PSTAT.DEAD ) then
		exit function
	end if

	if( not (pTB(p).state and CS2D.PSTAT.WALKING) ) then
		exit function
	end if

	cs2dPlayerUpdate = cs2dPlayerMove( cm, ti(), p )

end function

'':::::
function cs2dGetPlayerByID% ( cm as CS2DMAP, byval id as long ) static

	for i = 0 to cm.players-1
		if( pTB(i).id = id ) then
			cs2dGetPlayerByID = i
			exit function
		end if
	next i

	cs2dGetPlayerByID = -1

end function

'':::::
sub cs2dPlayerKill( cm as CS2DMAP, byval p as integer )

	pradw = (cm.ts.tilews-4)\2
	pradh = (cm.ts.tilehs-4)\2

	''
	pTB(p).state = CS2D.PSTAT.DEAD or CS2D.PSTAT.SPECTATING
	pTB(p).health 	= 0
	pTB(p).points 	= 0


	'' add blood
	cs2dStatParticleAdd env.blood, _
						cint(pTB(p).x)-pradw, cint(pTB(p).y)-pradh, 256, _
                        255,0,0, 256, env.fps*4, _
                        TFX.MONO or TFX.FACTMUL or TFX.SATADDALPHA

	'' drop weapon
	cs2dPlayerDropWeapon cm, p

	''
	pTB(p).priweapon= 0
	pTB(p).priammo  = 0
	pTB(p).prirefill= 0
	pTB(p).secweapon= 0
	pTB(p).secammo	= 0
	pTB(p).secrefill= 0

end sub

'':::::
sub cs2dPlayerHit( cm as CS2DMAP, byval p as integer, _
				   byval damage as integer, byval sid as long, _
				   byval xinc as single, byval yinc as single )

    dim e as integer
    dim x as single, y as single

	e = cs2dGetPlayerByID( cm, sid )

	'' check for friendly fire
	if( pTB(p).typ = pTB(e).typ ) then
		exit sub
	end if

	if( pTB(p).energy > 0 ) then
		pTB(p).energy = pTB(p).energy - damage
		if( pTB(p).energy < 0 ) then pTB(p).energy = 0
		damage = damage \ 2
	end if

	pTB(p).health = pTB(p).health - damage

	if( pTB(p).health <= 0 ) then

		cs2dPlayerKill cm, p

		'' add msg
		cs2dMsgAddPublic CS2D.MSG.KILLEDBY, e, p

		'' add credits to shooter
		pTB(e).points = pTB(e).points + CS2D.POINTS.DEATH
		if( pTB(e).points > CS2D.POINTS.MAX ) then
			pTB(e).points = CS2D.POINTS.MAX
		end if

	else
		pradw = (cm.ts.tilews-4)\2
		pradh = (cm.ts.tilehs-4)\2

		'' add blood
		bw = 32 * env.scale
		x = -xinc * (16 * env.scale)
		y = -yinc * (16 * env.scale)
		cs2dStatParticleAddEx env.fragments, cint(rnd*2)*bw, 2*bw, bw, bw, _
						  	  cint(pTB(p).x+x)-pradw, cint(pTB(p).y+y)-pradh, _
						  	  256, 255,0,0, 192, env.fps, _
                              TFX.MONO or TFX.FACTMUL or TFX.SATADDALPHA


		'' turn player to shooter
		if( pTB(p).isbot ) then
			if( not pTB(p).state and CS2D.PSTAT.SHOOTING ) then

				a = cs2dGetAngle( int(pTB(p).x), int(pTB(p).y), int(pTB(e).x), int(pTB(e).y) ) + _
			    	cint( rnd * (6 * cm.botskills ) )

				pTB(p).angle = (a + 90) mod 360

			end if
		end if
	end if
end sub

'':::::
sub cs2dPlayerDropWeapon( cm as CS2DMAP, byval p as integer )

	if( pTB(p).weapon = CS2D.WEAPON.PRIMARY ) then
		if( pTB(p).secweapon <> 0 ) then
			pTB(p).weapon = CS2D.WEAPON.SECUNDARY
		else
			pTB(p).weapon = 0
		end if

		w = pTB(p).priweapon
		a = pTB(p).priammo
		r = pTB(p).prirefill

		pTB(p).priweapon = 0
		pTB(p).priammo 	 = 0
		pTB(p).prirefill = 0

	else
		pTB(p).weapon = CS2D.WEAPON.PRIMARY

		w = pTB(p).secweapon
		a = pTB(p).secammo
		r = pTB(p).secrefill

		pTB(p).secweapon = 0
		pTB(p).secammo 	 = 0
		pTB(p).secrefill = 0
	end if

	if( (w <> 0) and (a > 0) ) then
		item = cs2dItemAdd( cint(pTB(p).x + 4 - rnd*8), cint(pTB(p).y + 4 - rnd*8), pTB(p).angle, w )
		dynitemTB(item).w.ammo   = a
		dynitemTB(item).w.refill = r
	end if

end sub

'':::::
sub cs2dPlayerShoot ( cm as CS2DMAP, ti() as integer, byval p as integer )
	dim w as integer, a as integer, r as integer
	dim xinc as single, yinc as single
	dim dx as single, dy as single, f as single

	''
	'' choose weapon
	''
	if( pTB(p).weapon = CS2D.WEAPON.PRIMARY ) then
		w = pTB(p).priweapon
		a = pTB(p).priammo
		r = pTB(p).prirefill
	else
		w = pTB(p).secweapon
		a = pTB(p).secammo
		r = pTB(p).secrefill
	end if

	''
	'' check ammo
	''
	if( a = 0 ) then
		if( r = 0 ) then exit sub

		if( pTB(p).reload = 0 ) then
			pTB(p).reload = env.fps*2
		end if
		exit sub
	end if

	''
	'' check time between shoots
	''
	if( abs(env.frmcnt - pTB(p).lastshoot) < weaponTB(w).frmspershoot ) then
		exit sub
	end if

	pTB(p).lastshoot = env.frmcnt

	''
	'' calc tragetory
	''
	f = weaponTB(w).precision
	xinc = 0 + (f/2) - (rnd*f)
	yinc = 1 + (f/2) - (rnd*f)
	cs2dRotateVector (pTB(p).angle+180) mod 360, xinc, yinc, env.scale

	''
	'' add bullet
	''
	dx = weaponTB(w).dx
	dy = weaponTB(w).dy
	cs2dRotateVector (pTB(p).angle+180) mod 360, dx, dy, env.scale

	cs2dBulletAdd cm, ti(), w, pTB(p).x+dx, pTB(p).y+dy, xinc, yinc, pTB(p).angle, pTB(p).id

    ''
    '' save ammo
    ''
	a = a - 1

	if( pTB(p).weapon = CS2D.WEAPON.PRIMARY ) then
		pTB(p).priammo = a
	else
		pTB(p).secammo = a
	end if

end sub

'':::::
sub cs2dPlayerPickup( cm as CS2DMAP, byval p as integer, byval item as integer )
    dim i as integer
    dim picked as integer

    '' enough time elapsed? (don't get own dropped weapon too fast)
    f = dynitemTB(item).frame
    if( f <> -1 ) then
    	if( ((CS2D.ITEM.MAXTIME * env.fps) - f) < (env.fps*3) ) then
    		exit sub
    	end if
    end if

    i = dynitemTB(item).id

    picked = 0
    select case itemTB(i).typ
    case CS2D.ITEMTYPE.WEAPON

		if( i <= CS2D.ITEM.Fiveseven ) then
			if( (pTB(p).priweapon = 0) or ((pTB(p).priammo = 0) and (pTB(p).prirefill = 0)) ) then
				picked = -1
				pTB(p).priweapon = i
				pTB(p).priammo 	 = dynitemTB(item).w.ammo
				pTB(p).prirefill = dynitemTB(item).w.refill
			end if
		else
			if( (pTB(p).secweapon = 0) or ((pTB(p).secammo = 0) and (pTB(p).secrefill = 0)) ) then
				picked = -1
				pTB(p).secweapon = i
				pTB(p).secammo 	 = dynitemTB(item).w.ammo
				pTB(p).secrefill = dynitemTB(item).w.refill
			end if
		end if

    end select

    if( picked ) then
    	cs2dItemDel item
    end if

end sub

'':::::
sub cs2dPlayerUpdateAll( cm as CS2DMAP, ti() as integer ) static
	dim i as integer, w as integer, r as integer, a as integer
    dim x as integer, y as integer
    dim xini as integer, yini as integer
    dim tw as integer, th as integer
    dim item as integer

	xini = (cm.xini * cm.ts.tilews)
	yini = (cm.yini * cm.ts.tilehs)
	tw = cm.ts.tilews
	th = cm.ts.tilehs

	'' update players' frame variables
	for i = 0 to cm.players-1
		if( not (pTB(i).state and CS2D.PSTAT.DEAD) ) then

			''
			x = cm.xdif + (cint(pTB(i).x) - xini) - cm.tx
			y = cm.ydif + (cint(pTB(i).y) - yini) - cm.ty

        	if( ((x >= -tw) and (x < env.xres+tw)) and ((y >= -th) and (y < env.yres+th)) ) then
            	pTB(i).onscreen = -1
        	else
        		pTB(i).onscreen = 0
        	end if

			''
			if( pTB(i).weapon = CS2D.WEAPON.PRIMARY ) then
				w = pTB(i).priweapon
				r = pTB(i).prirefill
			else
				w = pTB(i).secweapon
				r = pTB(i).secrefill
			end if

			'' reloading?
			if( pTB(i).reload > 0 ) then
				pTB(i).reload = pTB(i).reload - 1

				if( pTB(i).reload = 0 ) then
					a = weaponTB(w).maxammo
					r = r - a
					if( r < 0 ) then
						a = a + r
						r = 0
					end if

					if( pTB(i).weapon = CS2D.WEAPON.PRIMARY ) then
						pTB(i).priammo	 = a
						pTB(i).prirefill = r
					else
						pTB(i).secammo	 = a
						pTB(i).secrefill = r
					end if
				end if
			end if

			'' invulnerability ?
			'' ...


			'' over any map item?
			item = cs2dItemIsOver( cm, cint(pTB(i).x), cint(pTB(i).y) )
            if( item <> -1 ) then
            	cs2dPlayerPickup cm, i, item
            end if

		end if
	next i

end sub

'':::::
function cs2dPlayerCanBuy%( cm as CS2DMAP, byval p as integer )
    dim dx as long, dy as long, dist as long
    dim maxdist as long

	cs2dPlayerCanBuy = 0

	dx = clng(pTB(p).ox - pTB(p).x)
	dy = clng(pTB(p).oy - pTB(p).y)

	dist = (dx*dx) + (dy*dy)

	maxdist = cm.ts.tilews*cm.ts.tilews*8

	if( dist > maxdist ) then
		exit function
	end if

	cs2dPlayerCanBuy = -1

end function

'':::::
sub cs2dPlayerBuyItem( cm as CS2DMAP, byval p as integer, byval i as integer )

	price = itemTB(i).price

	if( pTB(p).points < price ) then
		exit sub
	end if

	select case itemTB(i).typ
	''
	case CS2D.ITEMTYPE.WEAPON
		'' primary?
		if( i <= CS2D.ITEM.Fiveseven ) then
			w = pTB(p).priweapon
			a = pTB(p).priammo
			r = pTB(p).prirefill
			pTB(p).priweapon = i
			pTB(p).priammo 	 = weaponTB(i).maxammo
			pTB(p).prirefill = 0
		else
			w = pTB(p).secweapon
			a = pTB(p).secammo
			r = pTB(p).secrefill
			pTB(p).secweapon = i
			pTB(p).secammo 	 = weaponTB(i).maxammo
			pTB(p).secrefill = 0
		end if

		if( w <> 0 ) then
			r = cm.ts.tilews\2
			item = cs2dItemAdd( cint(pTB(p).x + 4 - rnd*8)-r, cint(pTB(p).y + 4 - rnd*8)-r, pTB(p).angle, w )
			dynitemTB(item).w.ammo   = a
			dynitemTB(item).w.refill = r
		end if

    ''
    case CS2D.ITEMTYPE.AMMO

    	if( i = CS2D.ITEM.PrimaryAmmo ) then
    		if( pTB(p).priweapon <> 0 ) then
    			a = weaponTB(pTB(p).priweapon).maxammo
    			pTB(p).priammo 	 = a
    			pTB(p).prirefill = a*4
    		end if
    	else
    		if( pTB(p).secweapon <> 0 ) then
    			a = weaponTB(pTB(p).secweapon).maxammo
    			pTB(p).secammo 	 = a
    			pTB(p).secrefill = a*4
    		end if
    	end if

    ''
    case CS2D.ITEMTYPE.EQUIPAMENT
    	select case i
    	case CS2D.ITEM.Kevlar
    		pTB(p).energy = pTB(p).energy + 30
    		if( pTB(p).energy > 100 ) then pTB(p).energy = 100
    	case CS2D.ITEM.KevlarHelm
    		pTB(p).energy = pTB(p).energy + 50
    		if( pTB(p).energy > 100 ) then pTB(p).energy = 100
    	end select

    end select

	pTB(p).points = pTB(p).points - price

end sub

'':::::
sub cs2dPlayerSelWeapon( byval p as integer, byval w as integer )

	pTB(p).weapon = w

end sub

'':::::
sub cs2dPlayerSelTeam( cm as CS2DMAP, p as integer, byval typ as integer, byval team as integer )
    dim x as single, y as single, angle as integer

	if( p <> -1 ) then
		cs2dPlayerKill cm, p

		pTB(p).typ	= typ
		pTB(p).team	= team

    	setupWeapons pTB(p)

		pTB(p).energy	= CS2D.DEFAULT.ENERGY
		pTB(p).health	= CS2D.DEFAULT.HEALTH
		pTB(p).points	= CS2D.DEFAULT.POINTS

	else
		p = cs2dPlayerAdd( cm, "", typ, team )
	end if

    if( not cs2dPlayerFindStart( cm, pTB(p).typ, x, y, angle ) ) then
    end if

	pTB(p).x		= x
	pTB(p).y		= y
	pTB(p).angle	= angle

	pTB(p).ox		= int( x )
	pTB(p).oy		= int( y )

    pTB(p).step		= 0

    pTB(p).state 	= CS2D.PSTAT.WALKING

end sub


'':::::
function cs2dPlayerIsOverOnScreen%( cm as CS2DMAP, byval x as integer, byval y as integer )
	dim i as integer
	dim px as integer, py as integer
	dim dist as long, dx as long, dy as long, mindist as integer

	cs2dPlayerIsOverOnScreen = -1

	mindist = (cm.ts.tilews*cm.ts.tilews) \ 4

	for i = 0 to cm.players-1
		if( not (pTB(i).state and CS2D.PSTAT.DEAD) ) then
		if( pTB(i).onscreen ) then

			px = (cm.xdif + (cint(pTB(i).x) - (cm.xini * cm.ts.tilews)) - cm.tx) - (cm.ts.tilews\2)
			py = (cm.ydif + (cint(pTB(i).y) - (cm.yini * cm.ts.tilehs)) - cm.ty) - (cm.ts.tilehs\2)

			dx = px - x
			dy = py - y
			dist = dx*dx + dy*dy
			if( dist <= mindist ) then
				cs2dPlayerIsOverOnScreen = i
				exit function
			end if
		end if
		end if
	next i

end function

