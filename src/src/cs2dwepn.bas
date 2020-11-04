''
'' CS2D weapon module - weapon/bullets control
''
'' aug/2004 - written [v1ctor]
''

option explicit

defint a-z
'$include: 'inc\ugl.bi'
'$include: 'inc\2dfx.bi'
'$include: 'inc\dos.bi'
'$include: 'inc\cs2d.bi'
'$include: 'inc\cs2dint.bi'
'$include: 'inc\queue.bi'

const CS2D.MAXBULLETS%				= CS2D.MAXPLAYERS * 2%

type CS2DBULLET
	weapon		as integer						'' shooter weapon
	from 		as long							'' shooter id
	fx			as single						'' shooter pos
	fy			as single						'' /
	ox			as single						'' origin pos
	oy			as single						'' /
	x	    	as single						'' end pos
	y	    	as single                       '' /
	frame		as integer						'' anim frame

	ln			as integer						'' linked-list node
end type

declare sub 		drawBullet			( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, byval b as integer )


'' globals
dim shared bulletslist as TLIST

redim shared weaponTB( 0 ) as CS2DWEAPON

redim shared bulletTB( 0 ) as CS2DBULLET

redim shared lTB( 0 ) as LNODE


'' item, ud, dx,dy, radius,power,precision, max ammo, ms p/ shoots
weapondata:
'' USP
data  1,  0, 0,18, 2,2,.05, 20, .3
'' Glock
data  2,  1, 0,18, 2,2,.05, 20, .3
'' Deagle
data  3,  2, 0,18, 2,3,.05, 7, .3
'' P228
data  4,  3, 0,18, 2,2,.05, 13, .3
'' Elite
data 5, 4, 0,18, 2,2,.05, 15, .3
'' Fiveseven
data 6, 5, 0,18, 2,3,.05, 20, .3
'' M3
data 10, 6, 3,24, 4,5,.1, 8, .75
'' XM1014
data 11, 7, 3,24, 4,6,.1, 7, .5
'' MP5
data 20, 8, 1,20, 4,6,.05, 30, .2
'' TMP
data 21, 9, 0,24, 4,6,.05, 30, .2
'' P90
data 22, 10, 0,32, 4,6,.05, 50, .1
'' MAC10
data 23, 11, 0,32, 4,6,.05, 30, .1
'' UMP45
data 24, 12, 0,24, 4,6,.05, 25, .15
'' AK47
data 30, 13, 0,32, 4,6,.05, 30, .15
'' SG552
data 31, 14, 0,32, 4,6,.05, 30, .25
'' M4A1
data 32, 15, 0,32, 4,6,.05, 30, .2
'' Aug
data 33, 16, 0,32, 4,6,.05, 30, .4
'' Scout
data 34, 17, 0,32, 4,6,.05, 10, .75
'' AWP
data 35, 18, 0,32, 4,6,.05, 10, 2
'' G3SG1
data 36, 19, 0,32, 4,6,.05, 30, .2
'' SG550
data 37, 20, 0,32, 4,6,.05, 30, .2
'' M249
data 40, 20, 0,32, 6,8,.2, 100, .1
'' Laser
data 45, 21, 0,32, 8,50,.05, 10, 2
'' EOL
data -1

''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
'' initialization
''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

''::::
sub readWeapons
	dim i as integer
	dim scrdist as integer
	dim t as single

	scrdist = cint( sqr( (csng(env.xres)*env.xres)+(csng(env.yres)*env.yres) ) )

	restore weapondata
	do
		read i
		if( i = -1 ) then
			exit do
		end if

		read weaponTB(i).ud
		read weaponTB(i).dx , weaponTB(i).dy
		read weaponTB(i).rad, weaponTB(i).power, weaponTB(i).precision
		read weaponTB(i).maxammo
		read t

		weaponTB(i).u 			= itemTB(i).u
		weaponTB(i).frmspershoot= env.fps * t
		weaponTB(i).maxframes	= env.fps \ 4
		weaponTB(i).maxdist		= scrdist
		weaponTB(i).ud			= weaponTB(i).ud * 32
	loop

end sub

''::::
sub cs2dBulletInit
    dim i as integer

    redim weaponTB( 0 to CS2D.MAXITEMS-1 ) as CS2DWEAPON

    readWeapons

    ''
    redim bulletTB( 0 to CS2D.MAXBULLETS-1 ) as CS2DBULLET

    listInit bulletslist, lTB(), CS2D.MAXBULLETS

    for i = 0 to CS2D.MAXBULLETS-1
    	bulletTB(i).ln = -1
    next i

end sub

''::::
sub cs2dBulletEnd

	redim weaponTB( 0 ) as CS2DWEAPON

	''
	redim bulletTB( 0 ) as CS2DBULLET

	listEnd bulletslist, lTB()

end sub

''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
'' control
''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

'':::::
function cs2dBulletCheckHit%( cm as CS2DMAP, byval from as long, _
							  byval bx as single, byval by as single, byval brad as integer ) static
	dim i as integer
	dim prad as single

	cs2dBulletCheckHit = -1

	prad = ((cm.ts.tilew+8)/2) * env.scale

	for i = 0 to cm.players-1
		if( pTB(i).id <> from ) then
			if( (pTB(i).state and CS2D.PSTAT.DEAD) = 0 ) then
				if( cs2dCheckCollision( bx, by, brad, pTB(i).x, pTB(i).y, prad ) ) then
					cs2dBulletCheckHit = i
					exit function
				end if
			end if
		end if
	next i

end function

'':::::
sub cs2dBulletCalcTragect( cm as CS2DMAP, ti() as integer, byval b as integer, _
						   byval xinc as single, byval yinc as single, byval angle as integer ) static
	dim i as integer, j as integer, h as integer
	dim t as integer, p as integer
	dim x as single, y as single
	dim cmapofs as integer, tofs as integer
	dim px as integer, py as integer
	dim from as long
	dim w as integer, rad as integer, power as integer, delta as integer
	dim hitTB(0 to 7) as integer, dblhit as integer

	def seg = cm.map \ 65536&
	cmapofs = cm.map and &h0000FFFF&

	x 		= bulletTB(b).ox
	y 		= bulletTB(b).oy
	xinc	= xinc*2
	yinc	= yinc*2
	from 	= bulletTB(b).from

	w 		= bulletTB(b).weapon
	delta 	= weaponTB(w).maxdist\2
	rad		= weaponTB(w).rad
	power	= weaponTB(w).power

	for i = 0 to 7
		hitTB(i) = -1
	next i

	h = 0
	p = -1
	for i = 1 to delta
		px = cint( x ) \ cm.ts.tilews
		py = cint( y ) \ cm.ts.tilehs

		tofs = (py * cm.xsize) + px
    	t = peek( cmapofs + tofs )

    	select case ti(t)
    	case CS2D.TILE.WALL, CS2D.TILE.BLOCK
			'' add debris...
			exit for
		end select

		if( power > 0 ) then
			p = cs2dBulletCheckHit( cm, from, x, y, rad )
			if( p <> -1 ) then

				dblhit = 0
				for j = 0 to h-1
					if( hitTB(j) = p ) then
						dblhit = -1
						exit for
					end if
				next j

				if( not dblhit ) then
					hitTB(h) = p
					h = h + 1
					cs2dPlayerHit cm, p, power, from, xinc\2, yinc\2
					power = power \ 2
					if( power = 0 ) then
						exit for
					end if
				end if
			end if
		end if

		x = x + xinc
		y = y + yinc
	next i

	bulletTB(b).x = x
	bulletTB(b).y = y

end sub

'':::::
sub cs2dBulletAdd( cm as CS2DMAP, ti() as integer,  _
				   byval weapon as integer, byval x as single, byval y as single, _
				   byval xinc as single, byval yinc as single, byval angle as integer, byval pid as long )

	static b as integer
	dim ln as integer

	if( bulletTB(b).ln <> -1 ) then
		listDel bulletslist, lTB(), bulletTB(b).ln
		bulletTB(b).ln = -1
	end if

	'' find free slot
	ln = listAdd( bulletslist, lTB(), b, 0 )
	if( ln = -1 ) then
		exit sub
	end if

	'' save
	bulletTB(b).ln		= ln
	bulletTB(b).from 	= pid
	bulletTB(b).weapon 	= weapon
	bulletTB(b).fx	    = x
	bulletTB(b).fy	    = y
	bulletTB(b).ox	    = x
	bulletTB(b).oy	    = y
	bulletTB(b).frame   = weaponTB(weapon).maxframes

	'' calc tragectory
	cs2dBulletCalcTragect cm, ti(), b, xinc, yinc, angle

	''
	b = (b + 1) mod CS2D.MAXBULLETS

end sub

'':::::
sub cs2dBulletUpdateAll( cm as CS2DMAP, ti() as integer ) static
    dim i as integer, n as integer

	i = listGetFirst( bulletslist, lTB() )
	do until( i = -1 )
        n = listGetNext( bulletslist, lTB() )

		'' check if bullet can be deleted
        bulletTB(i).frame = bulletTB(i).frame - 1
        if( bulletTB(i).frame <= 0 ) then
            listDel bulletslist, lTB(), bulletTB(i).ln
            bulletTB(i).ln = -1
        end if

        i = n
	loop

end sub


'':::::
sub cs2dDrawBullets( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP )
    dim i as integer

	i = listGetFirst( bulletslist, lTB() )
	do until( i = -1 )
		drawBullet dst, cm, sm(), i
        i = listGetNext( bulletslist, lTB() )
	loop

end sub

'':::::
sub drawBullet( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, byval b as integer ) static
	dim i as integer, w as integer, t as integer
	dim dx as integer, dy as integer, delta as integer
	dim x as single, y as single, pstep as integer
	dim xinc as single, yinc as single
	dim fx as integer, fy as integer, dw as integer
	dim px as integer, py as integer, drawsmoke as integer, xsize as integer, ysize as integer
	dim clr as long
	dim f as single

	w = bulletTB(b).weapon

	f = (weaponTB(w).maxframes - bulletTB(b).frame) / weaponTB(w).maxframes

	x = bulletTB(b).ox
	y = bulletTB(b).oy

	dx = bulletTB(b).x - x
	dy = bulletTB(b).y - y

	xinc = 0
	yinc = 0
	if( abs(dx) >= abs(dy) ) then
		delta = abs( dx )
		if( dx > 0 ) then
			xinc = 1
		elseif( dx < 0 ) then
			xinc = -1
		end if
		if( dx <> 0 ) then yinc = dy / abs(dx)
	else
		delta = abs( dy )
		if( dy <> 0 ) then xinc = dx / abs(dy)
		if( dy > 0 ) then
			yinc = 1
		elseif( dy < 0 ) then
			yinc = -1
		end if
	end if

	if( f > 0 ) then
		pstep = cint( (24 / env.scale) * f )
	else
		pstep = 2 / env.scale
	end if

	xinc = xinc * pstep
	yinc = yinc * pstep
	delta = delta \ pstep

	'' draw tragect
	clr = uglColor( env.cfmt, 255, 255, 84 )

	x = (cm.xdif + (x - (cm.xini * cm.ts.tilews)) - cm.tx)
	y = (cm.ydif + (y - (cm.yini * cm.ts.tilehs)) - cm.ty)

	for i = 1 to delta
		uglPset dst, cint( x + rnd*1 ), cint( y + rnd*1 ), clr
		x = x + xinc
		y = y + yinc
	next i

	'' gun smoke
	t = 8 * env.scale
	fx = cint(cm.xdif + (bulletTB(b).fx - (cm.xini * cm.ts.tilews)) - cm.tx + rnd*t)
	fy = cint(cm.ydif + (bulletTB(b).fy - (cm.yini * cm.ts.tilehs)) - cm.ty + rnd*t)

	drawsmoke = -1
	if( cm.dofov ) then
		py = (fy + cm.ts.tilehs-1) \ cm.ts.tilehs
		px = (fx + cm.ts.tilews-1) \ cm.ts.tilews

    	xsize = (cm.xend - cm.xini) + 1
    	ysize = (cm.yend - cm.yini) + 1
    	i = (py * xsize) + px
    	if( (i >= 0) and (i < xsize*ysize) ) then
			if( not sm(i).a ) then drawsmoke = 0
		else
			drawsmoke = 0
		end if
	end if

    if( drawsmoke ) then
		tfxSetAlpha 64-cint(63 * f)
		t = 16 * env.scale
		tfxBlit dst, fx-t, fy-t, env.smoke, TFX.MONO or TFX.SATADDALPHA
	end if

    '' wall debris
	if( not cm.dofov ) then
		t = 16 * env.scale
		dw = 32 * env.scale
		tfxBlitBlit dst, x-t, y-t, env.fragments, cint(rnd*2)*dw, 1*dw, dw, dw, TFX.MONO or TFX.SATADDALPHA
	end if


	bulletTB(b).ox = bulletTB(b).ox + xinc
    bulletTB(b).oy = bulletTB(b).oy + yinc

end sub


