''
'' CS2D draw module - map, players, entities, etc drawing
''
'' aug/2004 - written [v1ctor]
''
'' obs: needs PDS or VBDOS to compile, 'cause the BYVAL's used
''


defint a-z
'$include: 'inc\ugl.bi'
'$include: 'inc\2dfx.bi'
'$include: 'inc\dos.bi'
'$include: 'inc\cs2d.bi'
'$include: 'inc\cs2dint.bi'


declare sub 		drawENVSPRITE		( byval dst as long, byval x as integer, byval y as integer, byval e as integer )


'':::::
sub cs2dClearScreen( byval dst as long, cm as CS2DMAP )

	if( cm.ydif > 0 ) then
    	uglRectF dst, 0, 0, env.xres, cm.ydif-1, 0
    end if

	if( cm.xdif > 0 ) then
    	uglRectF dst, 0, 0, cm.xdif-1, env.yres, 0
    end if

    dx = (cm.xend - cm.xini) * cm.ts.tilews
    if( cm.xdif + dx < env.xres ) then
    	uglRectF dst, cm.xdif + dx + 1, 0, env.xres, env.yres, 0
    end if

    dy = (cm.yend - cm.yini) * cm.ts.tilehs
    if( cm.ydif + dy < env.yres ) then
    	uglRectF dst, 0, cm.ydif + dy + 1, env.xres, env.yres, 0
    end if

end sub

'':::::
sub cs2dMakeScreenMap( cm as CS2DMAP, sm() as CS2DSCRMAP, byval p as integer )
    dim cmapofs as integer, ofs as integer
    dim px as integer, py as integer
    dim x as integer, y as integer
    dim t as integer, i as integer

	def seg = cm.map \ 65536&
	cmapofs = cm.map and &h0000FFFF&

	''
	px = int(pTB(p).x)
	py = int(pTB(p).y)


	''
	'' clip
	''
	if( px < 0 ) then
		px = 0
	elseif( px > cm.xmax ) then
		px = cm.xmax
	end if

	if( py < 0 ) then
		py = 0
	elseif( py > cm.ymax ) then
		py = cm.ymax
	end if

	''
	'' fractions
	''
	cm.tx = (px and (cm.ts.tilews-1))
	cm.ty = (py and (cm.ts.tilehs-1))

    ''
    '' yini
    ''
    cm.ydif = -1
    cm.yini = (py \ cm.ts.tilehs) - (((env.yres\2)+(cm.ts.tilehs-1)) \ cm.ts.tilehs + 1)
    if( cm.yini < 0 ) then
    	cm.ydif = cm.ydif + -cm.yini
    	cm.yini = 0
    end if

    cm.yend = cm.yini + ((env.yres+(cm.ts.tilehs-1)*2) \ cm.ts.tilehs) - cm.ydif
    if( cm.yend > cm.ysize-1 ) then
    	cm.yend = cm.ysize-1
    end if

    frac = (env.yres\2) mod cm.ts.tilehs
    if( frac > 0 ) then frac = cm.ts.tilehs - frac
    cm.ydif = (cm.ydif * cm.ts.tilehs) - frac

    ''
    '' xini
    ''
    cm.xdif = -1
    cm.xini = (px \ cm.ts.tilews) - (((env.xres\2)+(cm.ts.tilews-1)) \ cm.ts.tilews + 1)
    if( cm.xini < 0 ) then
    	cm.xdif = cm.xdif + -cm.xini
    	cm.xini = 0
    end if

    cm.xend = cm.xini + ((env.xres+(cm.ts.tilews-1)*2) \ cm.ts.tilews) - cm.xdif
    if( cm.xend > cm.xsize-1 ) then
    	cm.xend = cm.xsize-1
    end if

    frac = (env.xres\2) mod cm.ts.tilews
    if( frac > 0 ) then frac = cm.ts.tilews - frac
    cm.xdif = (cm.xdif * cm.ts.tilews) - frac

    ''
	'' create on screen map
	''
    i = 0
    for y = cm.yini to cm.yend

    	ofs = cmapofs + (y * cm.xsize) + cm.xini

    	for x = cm.xini to cm.xend
    		t = peek( ofs )
    		ofs = ofs + 1

    		sm(i).t = t
    		sm(i).a = 0
    		i = i + 1
    	next x
	next y

end sub

'':::::
sub cs2dMakeFOVMap( cm as CS2DMAP, sm() as CS2DSCRMAP, ti() as integer, byval p as integer ) static
    dim x as single, y as single
    dim px as integer, py as integer
    dim xinc as single, yinc as single
    dim k as integer, i as integer

const INCANGLE% = 2
const FOV% = CS2D.PLAYER.FOV+(CS2D.PLAYER.FOV\2)

    xsize  = (cm.xend - cm.xini) + 1
    ysize  = (cm.yend - cm.yini) + 1
    xsizeh = xsize \ 2
    ysizeh = ysize \ 2

    maxdist = sqr( (csng(xsizeh)*xsizeh) + (csng(ysizeh)*ysizeh) ) / env.scale

    a = (pTB(p).angle + 180) mod 360
    a = a - (FOV\2)
    if( a < 0 ) then a = 360 + a

	for i = 0 to FOV-1 step INCANGLE
		x = xsizeh
		y = ysizeh
		xinc = 0
		yinc = 1
		cs2dRotateVector a, xinc, yinc, env.scale

		for j = 1 to maxdist
    		px = cint( x )
    		py = cint( y )
			if( (px < 0) or (px >= xsize) ) then exit for
			if( (py < 0) or (py >= ysize) ) then exit for

    		k = (py * xsize) + px
    		sm(k).a = -1

    		select case ti( sm(k).t )
    		case CS2D.TILE.WALL, CS2D.TILE.BLOCK
				exit for
			end select

			x = x + xinc
		    y = y + yinc
		next j

		a = (a + INCANGLE) mod 360
	next i

end sub

'':::::
sub cs2dDrawTiles( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP ) static

    dim xo as integer, yo as integer
    dim tx as integer, ty as integer
    dim ix as integer, iy as integer
    dim i as integer

    xo = cm.xdif
    yo = cm.ydif

    if( cm.dofov ) then
    	tfxSetFactor 192, 192, 192
    end if

    i = 0
    ty = -cm.ty
    for y = cm.yini to cm.yend
    	tx = -cm.tx

    	if( not cm.dofov ) then
    		for x = cm.xini to cm.xend
				t = sm(i).t
				iy = (t \ cm.ts.xtiles) * cm.ts.tileh
    			ix = (t mod cm.ts.xtiles) * cm.ts.tilew
    			if( not env.scaletiles ) then
    				uglBlit dst, xo + tx, yo + ty, cm.ts.dc, ix, iy, cm.ts.tilew, cm.ts.tileh
    			else
    				uglBlitScl dst, xo + tx, yo + ty, env.scale, env.scale, cm.ts.dc, ix, iy, cm.ts.tilew, cm.ts.tileh
    			end if

    			tx = tx	+ cm.ts.tilews
    			i = i + 1
    		next x

		else
    		for x = cm.xini to cm.xend
				t = sm(i).t
				iy = (t \ cm.ts.xtiles) * cm.ts.tileh
    			ix = (t mod cm.ts.xtiles) * cm.ts.tilew
    			if( sm(i).a ) then
    				if( not env.scaletiles ) then
    					uglBlit dst, xo + tx, yo + ty, cm.ts.dc, ix, iy, cm.ts.tilew, cm.ts.tileh
    				else
    					uglBlitScl dst, xo + tx, yo + ty, env.scale, env.scale, cm.ts.dc, ix, iy, cm.ts.tilew, cm.ts.tileh
    				end if
    			else
            		if( not env.scaletiles ) then
            			tfxBlitBlit dst, xo + tx, yo + ty, cm.ts.dc, ix, iy, cm.ts.tilew, cm.ts.tileh, TFX.FACTMUL
    				else
    					tfxBlitBlitScl dst, xo + tx, yo + ty, cm.ts.dc, ix, iy, cm.ts.tilew, cm.ts.tileh, env.scale8, env.scale8, TFX.FACTMUL
    				end if
    			end if

    			tx = tx	+ cm.ts.tilews
    			i = i + 1
    		next x

		end if

    	ty = ty + cm.ts.tilehs
    next y

end sub

'':::::
sub cs2dDrawShadows( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, ti() as integer )

    dim xo as integer, yo as integer
    dim tx as integer, ty as integer
    dim ix as integer, iy as integer
    dim i as integer

    mask = TFX.MONO or TFX.SATSUB

    xo = cm.xdif
    yo = cm.ydif

    sw = 32 * env.scale

    wdt = (cm.xend - cm.xini) + 1

    i = 0
    ty = -cm.ty
    for r = cm.yini to cm.yend
    	tx = -cm.tx
    	for c = cm.xini to cm.xend
			t = sm(i).t

			if( (ti(t) = CS2D.TILE.WALL) or (ti(t) = CS2D.TILE.OBSTACLE) ) then

				if( ti(t) = CS2D.TILE.WALL )  then
					xofs = 0*sw
				else
					xofs = 1*sw
				end if

				if( c = cm.xend ) then
					tr = 0
				else
					tr = sm(i+1).t
					tr = ti(tr) >= CS2D.TILE.FLOORDIRT and ti(tr) <= CS2D.TILE.FLOORMETAL
				end if

				if( c = cm.xini ) then
					tl = CS2D.TILE.WALL
				else
					tl = ti(sm(i-1).t)
				end if

				if( r = cm.yini ) then
					tt = CS2D.TILE.WALL
				else
					tt = ti(sm(i-wdt).t)
				end if

				if( r = cm.yend ) then
					tb = 0
				else
					tb = sm(i+wdt).t
					tb = ti(tb) >= CS2D.TILE.FLOORDIRT and ti(tb) <= CS2D.TILE.FLOORMETAL
				end if

				x = xo + tx
				y = yo + ty
				w = cm.ts.tilews
				h = cm.ts.tilehs

				if( tr ) then
					if( tt = CS2D.TILE.WALL or tt = CS2D.TILE.OBSTACLE ) then
						tfxBlitBlit dst, x + w, y, env.shadmap, xofs, 3*sw, sw, sw, mask
					else
						tfxBlitBlit dst, x + w, y, env.shadmap, xofs, 4*sw, sw, sw, mask
					end if
				end if
				if( tb ) then
					if( tl = CS2D.TILE.WALL or tl = CS2D.TILE.OBSTACLE ) then
						tfxBlitBlit dst, x, y + h, env.shadmap, xofs, 0*sw, sw, sw, mask
					else
						tfxBlitBlit dst, x, y + h, env.shadmap, xofs, 1*sw, sw, sw, mask
					end if
				end if
				if( tr and tb ) then
					tfxBlitBlit dst, x + w, y + h, env.shadmap, xofs, 2*sw, sw, sw, mask
				end if
			end if

    		tx = tx	+ cm.ts.tilews
    		i = i + 1

    	next c
    	ty = ty + cm.ts.tilehs
    next r

end sub

'':::::
sub cs2dDrawPlayers( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, byval p as integer ) static
    dim i as integer
    dim x as integer, y as integer
    dim t as integer
    dim a as integer
    dim pradw as integer, pradh as integer
    dim dx as single, dy as single
    dim scl as single

	pradw = (cm.ts.tilews-4)\2
	pradh = (cm.ts.tilehs-4)\2

	scl = env.scale

	xsize  = (cm.xend - cm.xini) + 1

	for i = 0 to cm.players-1
		if( pTB(i).onscreen ) then
		if( not (pTB(i).state and CS2D.PSTAT.DEAD) ) then

			px = int(pTB(i).x)
			py = int(pTB(i).y)

			x = (cm.xdif + (px - (cm.xini * cm.ts.tilews)) - cm.tx)
			y = (cm.ydif + (py - (cm.yini * cm.ts.tilehs)) - cm.ty)

			if( cm.dofov ) then
				if( i <> p) then
					py = (y + cm.ts.tilehs-1) \ cm.ts.tilehs
					px = (x + cm.ts.tilews-1) \ cm.ts.tilews
					j = (py * xsize) + px
					if( not sm(j).a ) then goto skip
				end if
			end if

			x = x - pradw
			y = y - pradh

			t = pTB(i).team
			if( pTB(i).typ = CS2D.PLAYER.TERRORIST ) then
				t = CS2D.PLAYER.BASET + t
			else
				t = CS2D.PLAYER.BASECT + t
			end if

			s = cint( 4 / pTB(i).speed )
			a = pTB(i).angle
			v = pTB(i).step \ (4*s)
			u = (pTB(i).step mod (4*s)) \ s

			'' legs
			dx = 0
			dy = 8
			cs2dRotateVector a, dx, dy, scl
			uglBlitMskRotScl dst, x + dx, y + dy, a, scl, scl, env.legs, u*32, v*32, 32, 32

			'' body
			uglBlitMskRotScl dst, x, y, a, scl, scl, env.players, t*32, 0, 32, 32

			'' weapon
			if( pTB(i).weapon = CS2D.WEAPON.PRIMARY ) then
				w = pTB(i).priweapon
			else
				w = pTB(i).secweapon
			end if
			dx = 0
			dy = -16
			cs2dRotateVector a, dx, dy, scl
			uglBlitMskRotScl dst, x + dx, y + dy, a, scl, scl, env.weapons, weaponTB(w).u, 0, 32, 32

			'' reload
			if( i = p ) then
				r = pTB(i).reload
				if( r > 0 ) then
					v = 4 * scl
					r = (cm.ts.tilews * ((env.fps*2) - r)) \ (env.fps*2)
					uglVLine dst, x-2, y + pradh*2 + v, y + pradh*2 + v + v, -1
					uglVLine dst, x+cm.ts.tilews+2, y + pradh*2 + 4, y + pradh*2 + v + v, -1
					uglRectF dst, x, y + pradh*2 + v, x + r, y + pradh*2 + v + v, -1
				end if
			end if

		end if
		end if
skip:
	next i

end sub

'':::::
sub drawENVSPRITE( byval dst as long, byval x as integer, byval y as integer, byval e as integer ) static
    dim dc as long
    dim mask as integer
    dim alpha as integer, angle as integer
    dim r as integer, g as integer, b as integer
    dim wdt as integer, hgt as integer
    dim xsize as integer, ysize as integer

    entENVSPRITE(e).rotangle = (entENVSPRITE(e).rotangle + entENVSPRITE(e).rotspeed) mod 360

    dc 		= entENVSPRITE(e).dc
    alpha	= entENVSPRITE(e).alpha
    angle	= entENVSPRITE(e).rotangle
    r		= entENVSPRITE(e).r
    g		= entENVSPRITE(e).g
    b		= entENVSPRITE(e).b
    wdt		= entENVSPRITE(e).wdt
    hgt		= entENVSPRITE(e).hgt
    xsize	= entENVSPRITE(e).xsize
    ysize	= entENVSPRITE(e).ysize

    '' sprite mode
    select case entENVSPRITE(e).mode
    case 0, 1									'' normal
    	mask = 0
    case 2										'' alpha map (PNG's)
    	mask = TFX.MASK or TFX.MONO or TFX.SATADD
    case 4										'' masked
    	mask = TFX.MASK
    end select


    '' sprite blend mode
    select case entENVSPRITE(e).blendmode
    case 1										'' alpha: r = ( a * s ) + ( ( 1.0 - a ) * d )
    	mask = mask or TFX.ALPHA

    case 2										'' multiply: r = ( ( s / 255.0 ) * ( d / 255.0 ) ) * 255.0
    	mask = mask or TFX.MONOMUL

    case 3, 4									'' add: r = ( s * a ) + d
    	mask = mask or TFX.MONO or TFX.SATADD

    end select

	edraw = 1
	if( alpha <> 256 ) then
		edraw = 0
		tfxSetAlpha 256 - alpha					'' 2dfx alpha is inverted
		if( (mask and TFX.SATADD) ) then
			mask = (mask and not TFX.SATADD) or TFX.SATADDALPHA
		else
			mask = mask or TFX.ALPHA
		end if
	end if

	if( angle > 0 ) then
		mask = mask or TFX.HVFLIP				'' <-- fake rotation with flipping :/
	end if

	if( xsize < 0 ) then
		xsize = -xsize
		x = x - xsize*env.scale
		mask = mask or TFX.HFLIP
	end if

	if( ysize < 0 ) then
		ysize = -ysize
		y = y - ysize*env.scale
		mask = mask or TFX.VFLIP
	end if

	if( (r > 0) or (g > 0) or (b > 0) ) then
		tfxSetFactor r, g, b
		mask = mask or TFX.FACTMUL
	end if

	x = x + entENVSPRITE(e).xoffset*env.scale
	y = y + entENVSPRITE(e).yoffset*env.scale

	if( (wdt = xsize) and (hgt = ysize) ) then
		if( env.scale = 1 ) then
			tfxBlit dst, x, y, dc, mask
		else
			tfxBlitScl dst, x, y, dc, env.scale8, env.scale8, mask
		end if
	else
		xscale = cint((clng(xsize)*256&)\wdt) * env.scale
		yscale = cint((clng(ysize)*256&)\hgt) * env.scale
		tfxBlitScl dst, x, y, dc, xscale, yscale, mask
	end if

end sub

'':::::
sub cs2dDrawEntities( byval dst as long, cm as CS2DMAP )
    dim e as integer, i as integer
    dim x as integer, y as integer
    dim dc as long

	for e = 0 to cm.entities-1

		i = entTB(e).idx

		if( i <> -1 ) then
			x = cm.xdif + (entTB(e).xpos - cm.xini) * cm.ts.tilews - cm.tx
			y = cm.ydif + (entTB(e).ypos - cm.yini) * cm.ts.tilehs - cm.ty

			select case entTB(e).typ
			case CS2D.ENT.ENVIMAGE
				dc = entENVIMAGE(i).dc
				if( dc <> 0 ) then
					if( env.scale = 1 ) then
						uglPutMsk dst, x, y, dc
					else
						uglPutMskScl dst, x, y, env.scale, env.scale, dc
					endif
				end if

			case CS2D.ENT.ENVSPRITE
				dc = entENVSPRITE(i).dc
				if( dc <> 0 ) then drawENVSPRITE dst, x, y, i
			end select

		end if

	next e

end sub

'':::::
sub cs2dDrawWaypoints( byval dst as long, cm as CS2DMAP )
    dim i as integer
    dim x as integer, y as integer

	c& = uglColor( env.cfmt, 128, 128, 128 )

	for i = 0 to cm.waypoints-1

		x = cm.xdif + (wp(i).xpos - cm.xini) * cm.ts.tilews - cm.tx + (cm.ts.tilews\2)
		y = cm.ydif + (wp(i).ypos - cm.yini) * cm.ts.tilehs - cm.ty + (cm.ts.tilehs\2)

		uglCircleF dst, x, y, 2, c&

	next i




	for i = 0 to cm.waypntconns-1

		ip = wpc(i).inip
		ep = wpc(i).endp

		x1 = cm.xdif + (wp(ip).xpos - cm.xini) * cm.ts.tilews - cm.tx + (cm.ts.tilews\2)
		y1 = cm.ydif + (wp(ip).ypos - cm.yini) * cm.ts.tilehs - cm.ty + (cm.ts.tilehs\2)

		x2 = cm.xdif + (wp(ep).xpos - cm.xini) * cm.ts.tilews - cm.tx + (cm.ts.tilews\2)
		y2 = cm.ydif + (wp(ep).ypos - cm.yini) * cm.ts.tilehs - cm.ty + (cm.ts.tilehs\2)

		uglLine dst, x1, y1, x2, y2, c&

	next i

end sub

'':::::
sub cs2dDrawBotPath( byval dst as long, cm as CS2DMAP )

	clr& = uglColor( env.cfmt, 128, 128, 128 )

	for p = 0 to CS2D.MAXPLAYERS-1
		if( pTB(p).isbot ) then

			if( (pTB(p).state and CS2D.PSTAT.DEAD) ) then
				exit sub
			end if

    		idx = pTB(p).b.idx

			'' source
			t = pathTB(idx + pTB(p).b.nodes-1)
			x1 = t mod cm.xsize
			y1 = t \ cm.xsize

			x1 = cm.xdif + (x1 - cm.xini) * cm.ts.tilews - cm.tx + (cm.ts.tilews\2)
			y1 = cm.ydif + (y1 - cm.yini) * cm.ts.tilehs - cm.ty + (cm.ts.tilehs\2)

			uglCircle dst, x1, y1, 4, clr&

			cs2dFontPrint dst, x1 + 6, y1 - 4, 255, 255, 255, ltrim$( str$( pTB(p).id ) )

			'' destine
			t = pathTB(idx + 0)
			x = t mod cm.xsize
			y = t \ cm.xsize

			x = cm.xdif + (x - cm.xini) * cm.ts.tilews - cm.tx + (cm.ts.tilews\2)
			y = cm.ydif + (y - cm.yini) * cm.ts.tilehs - cm.ty + (cm.ts.tilehs\2)
			uglCircleF dst, x, y, 4, clr&

			cs2dFontPrint dst, x + 6, y - 4, 255, 255, 255, ltrim$( str$( pTB(p).id ) )

			'' path
			for i = pTB(p).b.nodes-2 to 0 step -1

				t = pathTB(idx + i)
				x2 = t mod cm.xsize
				y2 = t \ cm.xsize

				x2 = cm.xdif + (x2 - cm.xini) * cm.ts.tilews - cm.tx + (cm.ts.tilews\2)
				y2 = cm.ydif + (y2 - cm.yini) * cm.ts.tilehs - cm.ty + (cm.ts.tilehs\2)

				uglLine dst, x1, y1, x2, y2, clr&

				x1 = x2
				y1 = y2
			next i
		end if
	next p

end sub

'':::::
sub cs2dDraw( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, ti() as integer, _
			  byval p as integer, byval mode as integer )

	cs2dClearScreen dst, cm

	cs2dDrawTiles dst, cm, sm()

	if( mode and CS2D.DRAW.WAYPOINTS ) then
		cs2dDrawWaypoints dst, cm
	end if

	if( mode and CS2D.DRAW.STATPARTICLES ) then
		cs2dDrawStatParticles dst, cm, sm()
	end if

	if( mode and CS2D.DRAW.ITEMS ) then
		cs2dDrawItems dst, cm, sm()
	end if

	if( mode and CS2D.DRAW.SHADOWS ) then
		cs2dDrawShadows dst, cm, sm(), ti()
	end if

	if( mode and CS2D.DRAW.PLAYERS ) then
		cs2dDrawPlayers dst, cm, sm(), p
    end if

	if( mode and CS2D.DRAW.BULLETS ) then
		cs2dDrawBullets dst, cm, sm()
	end if

	if( mode and CS2D.DRAW.ENTITIES ) then
		cs2dDrawEntities dst, cm
	end if

	if( mode and CS2D.DRAW.BOTPATHS ) then
		cs2dDrawBotPath dst, cm
	end if

	if( mode and CS2D.DRAW.HUD ) then
		cs2dHudDraw dst, cm, p
	end if

	if( mode and CS2D.DRAW.MSGS ) then
		cs2dMsgDraw dst
	end if

end sub
