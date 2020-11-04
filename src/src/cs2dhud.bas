''
'' CS2D hud module - stats and font drawing
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

declare sub 		fontCalcWidth	( byval fontdc as long )


'' globals
redim shared fontTB( 0 ) as CS2DFONT

'':::::
sub iniFont
    dim path as string

    path = CS2D.GFXPATH

   	if( env.scale8 < 256 ) then
   		path = path + CS2D.TILESCALEDPATH
   	end if

	''
	redim fontTB( 0 to CS2D.FONT.CHARS-1 ) as CS2DFONT

	'' load fonts sprite, if not loaded yet
	if( env.font = 0 ) then
		env.font = uglNewBMPEx( UGL.XMS, UGL.8BIT, path + "font.bmp", BMPOPT.NO332 )
		if( env.font = 0 ) then
			exit sub
	 	end if

		fontCalcWidth env.font
	end if

end sub

'':::::
sub endFont
	'' ...
end sub

'':::::
sub fontCalcWidth( byval fontdc as long )
    dim dci as TDC
    dim x as integer, y as integer, c as integer
    dim p as long
    dim cw as integer, ch as integer

	uglDCGet dc, dci

	cw = CS2D.FONT.CHARW * env.scale
	ch = CS2D.FONT.CHARH * env.scale

	for c = 0 to CS2D.FONT.CHARS-1

		u = (c mod CS2D.FONT.CHARSPROW) * cw
		v = (c \ CS2D.FONT.CHARSPROW) * ch

		lgap = cw
		rgap = -1
		for y = 0 to ch-1
			for x = 0 to cw-1
				p = uglPGet( fontdc, u+x, v+y )

				if( p <> UGL.BPINK8 ) then
					if( x < lgap ) then
						lgap = x
					end if
					if( x > rgap ) then
						rgap = x
					end if
				end if
		    next x
		next y

		if( lgap = cw ) then
			fontTB(c).lgap = 0
			fontTB(c).wdt  = cw
		else
			fontTB(c).lgap = lgap
			fontTB(c).wdt  = cw - (lgap + ((cw-1)-rgap))
		end if
	next c

end sub

'':::::
sub cs2dHudInit
    dim path as string

    path = CS2D.GFXPATH

	iniFont

   	if( env.scale8 < 256 ) then
   		path = path + CS2D.TILESCALEDPATH
   	end if

	'' load hud sprite, if not loaded yet
	if( env.hudsymbols = 0 ) then
		env.hudsymbols = uglNewBMPEx( UGL.XMS, UGL.8BIT, path + "hud_symbols.bmp", BMPOPT.NO332 )
		if( env.hudsymbols = 0 ) then
			exit sub
	 	end if
	end if

	if( env.hudnums = 0 ) then
		env.hudnums = uglNewBMPEx( UGL.XMS, UGL.8BIT, path + "hud_nums.bmp", BMPOPT.NO332 )
		if( env.hudnums = 0 ) then
			exit sub
	 	end if
	end if

	if( env.hudradar = 0 ) then
		env.hudradar = uglNewBMPEx( UGL.XMS, UGL.8BIT, path + "hud_radar.bmp", BMPOPT.NO332 )
		if( env.hudradar = 0 ) then
			exit sub
	 	end if
	end if

	'' load mouse pointers, if ...
	if( env.pointers = 0 ) then
		env.pointers = uglNewBMPEx( UGL.XMS, env.cfmt, path + "pointers.bmp", BMPOPT.NO332 or BMPOPT.MASK or UGL.BPINK8 )
		if( env.pointers = 0 ) then
			exit sub
		end if
	end if

end sub

'':::::
sub cs2dHudEnd

	endFont

end sub

'':::::
sub drawNum( byval dst as long, byval x as integer, byval y as integer, byval mask as integer, _
			 byval num as integer )

    dim i as integer, c as integer
    dim numb as string

    nw = CS2D.HUD.NUMW * env.scale
    nh = CS2D.HUD.NUMH * env.scale

    numb = ltrim$( str$( num ) )

    for i = 1 to len( numb )

    	c = asc( mid$( numb, i, 1 ) ) - 48

    	tfxBlitBlit dst, x, y, env.hudnums, c*nw, 0, nw, nh, mask

    	x = x + nw
    next i


end sub

'':::::
sub drawTime( byval dst as long, byval x as integer, byval y as integer, byval mask as integer, _
			  byval t as integer )

	nw = CS2D.HUD.NUMW * env.scale
	nh = CS2D.HUD.NUMH * env.scale

	m = t \ 60
	s = t mod 60

	drawNum dst, x, y, mask, m

	tfxBlitBlit dst, x+nw+2, y, env.hudnums, 10*nw, 0, 5, nh, mask

	if( s < 10 ) then
		drawNum dst, x+nw+2+5+2, y, mask, 0
		x = x + nw
	end if

	drawNum dst, x+nw+2+5+2, y, mask, s

end sub

'':::::
sub drawRadar( byval dst as long, byval ox as integer, byval oy as integer, _
			   cm as CS2DMAP, byval p as integer ) static
    dim i as integer, typ as integer
	dim px as integer, py as integer
	dim x as integer, y as integer
	dim dist as long, maxdist as long, dx as long, dy as long
	dim radx as single, rady as single
	dim wh as integer, hh as integer

	radx = (CS2D.RADAR.WDT*env.scale) / (cm.xsize * cm.ts.tilews)
	rady = (CS2D.RADAR.HGT*env.scale) / (cm.ysize * cm.ts.tilehs)

	wh = (CS2D.RADAR.WDT*env.scale) \ 2
	hh = (CS2D.RADAR.HGT*env.scale) \ 2

	maxdist = clng( ((wh/radx)*(wh/radx) + (hh/rady)*(hh/rady)) * .5 )

	px  = cint( pTB(p).x )
	py  = cint( pTB(p).y )
	typ = pTB(p).typ

	tfxSetFactor 32, 96, 32
	tfxBlit dst, ox, oy, env.hudradar, TFX.MONO or TFX.FACTMUL or TFX.SATADD

	for i = 0 to cm.players-1
    	if( pTB(i).typ = typ ) then
    		if( not (pTB(i).state and CS2D.PSTAT.DEAD) ) then

    	    	x = cint( pTB(i).x )
    	    	y = cint( pTB(i).y )
    			dx = px - x
    			dy = py - y

    			dist = ( dx*dx + dy*dy )
    			if( dist < maxdist ) then

    				x = wh - cint( dx * radx )
    				y = hh - cint( dy * rady )

    				uglPSet dst, ox+x, oy+y, -1

    			end if
    		end if
    	end if
    next i

end sub

'':::::
sub cs2dHudDraw( byval dst as long, cm as CS2DMAP, byval p as integer )
	dim x as integer, y as integer, mask as integer, pnts as integer

    sw = CS2D.HUD.SYMBOLW * env.scale
    sh = CS2D.HUD.SYMBOLH * env.scale
    nw = CS2D.HUD.NUMW * env.scale
    nh = CS2D.HUD.NUMH * env.scale

    if( (pTB(p).state and CS2D.PSTAT.DEAD) ) then
    	exit sub
	end if

    y = env.yres - (34 * env.scale)

    tfxSetFactor 192, 192, 64

    mask = TFX.MONO or TFX.FACTMUL or TFX.SATADD

    '' health
    x = 0
    tfxBlitBlit dst, x, y, env.hudsymbols, CS2D.HUD.HEALTH*sw, 0, sw, sh, mask
    drawNum dst, x+sw+4, y, mask, pTB(p).health
    x = x + (sw+4) + (3*nw) + sw\2

    '' shield?
    tfxBlitBlit dst, x, y, env.hudsymbols, CS2D.HUD.SHIELD*sw, 0, sw, sh, mask
    drawNum dst, x+sw+4, y, mask, pTB(p).energy
    x = x + (sw+4) + (3*nw) + sw\2

    '' clock
    tfxBlitBlit dst, x, y, env.hudsymbols, CS2D.HUD.CLOCK*sw, 0, sw, sh, mask
    drawTime dst, x+sw+4, y, mask, cm.timecnt
    x = x + (sw+4) + (4*nw+9) + sw\2

    '' ammo
	if( pTB(p).weapon = CS2D.WEAPON.PRIMARY ) then
		a = pTB(p).priammo
		r = pTB(p).prirefill
	else
		a = pTB(p).secammo
		r = pTB(p).secrefill
	end if

    m = (1 + -(a>=10) + -(a>=100)) + (1 + -(r>=10) + -(r>=100))
	x = env.xres - (m*nw + 9)
    drawNum dst, x, y, mask, a

    m = (1 + -(a>=10) + -(a>=100))
    x = x + (nw*m)
    tfxBlitBlit dst, x+2, y, env.hudnums, 11*nw, 0, 5, nh, mask

    drawNum dst, x+2+5+2, y, mask, r

    '' points
    pnts = pTB(p).points
    m = (1 + -(pnts>=10) + -(pnts>=100) + -(pnts>=1000))
    x = env.xres - (m*nw)
    tfxBlitBlit dst, x-32, y-(sh+4), env.hudsymbols, CS2D.HUD.POINTS*sw, 0, sw, sh, mask
    drawNum dst, x, y-(sh+4), mask, pnts
    x = x + (sw+4) + (4*nw+9) + sw\2

    '' buy menu indication

    if( cs2dPlayerCanBuy( cm, p ) ) then
    	tfxBlitBlit dst, 2, (env.yres\2)-(sh\2), env.hudsymbols, CS2D.HUD.BUYZONE*sw, 0, sw, sh, mask
    end if

    '' radar
	drawRadar dst, 0, 0, cm, p

end sub

'':::::
sub cs2dFontPrint( byval dst as long, byval x as integer, y as integer, _
				   byval r as integer, byval g as integer, byval b as integer, _
				   text as string ) static

	dim i as integer, c as integer
	dim cw as integer, ch as integer, cs as integer

	if( env.font = 0 ) then
		exit sub
	end if

	cw = CS2D.FONT.CHARW * env.scale
	ch = CS2D.FONT.CHARH * env.scale
	cs = CS2D.FONT.CHARSPC '* env.scale

	tfxSetSolid r, g, b

	for i = 1 to len( text )
		c = asc( mid$( text, i, 1 ) )

		if( c >= CS2D.FONT.FIRSTCHAR and c <= CS2D.FONT.LASTCHAR ) then
			c = c - CS2D.FONT.FIRSTCHAR

			if( fontTB(c).wdt > 0 ) then
				u = (c mod CS2D.FONT.CHARSPROW) * cw
				v = (c \ CS2D.FONT.CHARSPROW) * ch

				tfxBlitBlit dst, x, y, env.font, u+fontTB(c).lgap, v, fontTB(c).wdt, ch, TFX.SOLID or TFX.MASK

				x = x + fontTB(c).wdt + cs
        	end if

		else
			x = x + (cw\4)
		end if

	next i

end sub


'':::::
function cs2dFontWidth%( text as string ) static
    dim i as integer, c as integer
    dim cw as integer, cs as integer

	cs2dFontWidth = 0

	if( env.font = 0 ) then
		exit function
	end if

	cw = CS2D.FONT.CHARW * env.scale
	cs = CS2D.FONT.CHARSPC '* env.scale

	x = 0
	for i = 1 to len( text )
		c = asc( mid$( text, i, 1 ) )
		if( c >= CS2D.FONT.FIRSTCHAR and c <= CS2D.FONT.LASTCHAR ) then
			c = c - CS2D.FONT.FIRSTCHAR

			if( fontTB(c).wdt > 0 ) then
				x = x + fontTB(c).wdt + cs
        	end if

		else
			x = x + (cw\4)
		end if

	next i

	cs2dFontWidth = x - cs

end function

'':::::
sub drawMouseOver( byval dst as long, byval mx as integer, byval my as integer, cm as CS2DMAP, byval p as integer )
    dim i as integer, id as integer
    dim x as integer, y as integer
    dim tstr as string, w as integer

    '' check players
	i = cs2dPlayerIsOverOnScreen( cm, mx, my )
    if( (i <> -1) and (i <> p) ) then
		x = (cm.xdif + (cint(pTB(i).x) - (cm.xini * cm.ts.tilews)) - cm.tx)
		y = (cm.ydif + (cint(pTB(i).y) - (cm.yini * cm.ts.tilehs)) - cm.ty)

    	if( pTB(i).typ = pTB(p).typ ) then
    		tstr = "Friend: "
    	else
    		tstr = "Enemy: "
    	end if

    	tstr = tstr + rtrim$( pTB(i).name ) + " [" + ltrim$( str$( pTB(i).health ) ) + "]"

    	w = cs2dFontWidth( tstr )
    	cs2dFontPrint dst, x - (w\2), y - ((CS2D.HUD.NUMH\2) * env.scale) - 2, 255,255,63, tstr

    	exit sub
    end if

	'' check items
	i = cs2dItemIsOverOnScreen( cm, mx, my )
    if( i <> -1 ) then
    	id = dynitemTB(i).id

		x = (cm.xdif + (dynitemTB(i).x - (cm.xini * cm.ts.tilews)) - cm.tx)
		y = (cm.ydif + (dynitemTB(i).y - (cm.yini * cm.ts.tilehs)) - cm.ty)

    	tstr = ""
    	select case itemTB(id).typ
    	case CS2D.ITEMTYPE.WEAPON
    		tstr = rtrim$( itemTB(id).name ) + ": " + _
    		       ltrim$( str$( dynitemTB(i).w.ammo ) ) + "|" + ltrim$( str$( dynitemTB(i).w.refill ) )
    	end select

    	if( len( tstr ) > 0 ) then
    		w = cs2dFontWidth( tstr )
    		cs2dFontPrint dst, x - (w\2), y - ((CS2D.HUD.NUMH\2) * env.scale) - 2, 255,255,63, tstr
    	end if

    	exit sub
    end if

end sub


'':::::
sub cs2dMouseShow( byval dst as long, byval x as integer, byval y as integer, byval pointer as integer, _
				   cm as CS2DMAP, byval p as integer  )
    dim u as integer, v as integer

	u = pointer mod 2
	v = pointer \ 2
	w = 24 * env.scale

	uglBlitMsk dst, x, y, env.pointers, u*w,v*w, w,w

	drawMouseOver dst, x, y, cm, p

end sub
