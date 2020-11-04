''
'' CS2D bots module - bots control
''
'' aug/2004 - written [v1ctor]
''


defint a-z
'$include: 'inc\dos.bi'
'$include: 'inc\cs2d.bi'
'$include: 'inc\cs2dint.bi'
'$include: 'inc\astar.bi'

type BOTPATH
	idx		as integer
	nodes	as integer
end type

declare sub 		cs2dBotFindPoint 	( cm as CS2DMAP, x as integer, y as integer, _
										  byval typ as integer, byval findSource as integer )

declare function 	cs2dBotFindWaypoint%( cm as CS2DMAP, byval px as integer, byval py as integer )

declare sub 		cs2dBotNearestPath	( cm as CS2DMAP, bot as CS2DPLAYER, _
										  xpos as integer, ypos as integer )


''globals
dim shared i_xsize as integer, i_waypntconns as integer, i_rndlevel as integer

dim shared botPaths as integer

redim shared pathTB( 0 ) as integer

redim shared botpathTB( 0 ) as BOTPATH

'':::::
sub cs2dBotStart ( cm as CS2DMAP ) static
    dim i as integer, s as integer, d as integer, j as integer, k as integer
    dim x as integer, y as integer
    dim idx as integer
    dim v as single

	v = (1 * env.scale) * (CS2D.BASE.FPS / env.fps)

	i_xsize 		= cm.xsize
	i_waypntconns 	= cm.waypntconns
	i_rndlevel		= cm.botskills				'' 0=max precision

	redim pathTB( 0 to (CS2D.MAXWAYPOINTS*CS2D.MAXPLAYERS)-1 ) as integer

	redim botpathTB( 0 to CS2D.MAXPLAYERS-1 ) as BOTPATH

    ''
    aStarInit CS2D.MAXWAYPOINTS+(CS2D.MAXWAYPOINTS\2)

	''
	'' create many paths as possible
	''
	idx = 0
	k = 0
	for i = 0 to CS2D.MAXPLAYERS-1

		if( i < CS2D.MAXPLAYERS\2 ) then
			t = CS2D.PLAYER.CTERRORIST
		else
			t = CS2D.PLAYER.TERRORIST
		end if

		'' source
		cs2dBotFindPoint cm, x, y, t, -1
		j = cs2dBotFindWaypoint( cm, x, y )
		s = wp(j).ypos * cm.xsize + wp(j).xpos

        '' destine
        cs2dBotFindPoint cm, x, y, t, 0
        j = cs2dBotFindWaypoint( cm, x, y )
        d = wp(j).ypos * cm.xsize + wp(j).xpos

        '' make path from source to destine
        nodes = aStarFindPath( s, d, pathTB(), idx )
        if( nodes > 0 ) then
        	botpathTB(k).idx 	= idx
        	botpathTB(k).nodes 	= nodes
        	k = k + 1

        	idx = idx + nodes
        end if

		''
		aStarClear

	next i

	botPaths = k

	''
    aStarEnd

	''
	'' assign the nearest paths to bots
	''
	for i = 0 to cm.players-1
		if( pTB(i).isbot ) then

			'' calc speed
			pTB(i).speed 	= v + (rnd * v)

        	''
        	cs2dBotNearestPath cm, pTB(i), x, y

        	''
        	pTB(i).b.action = CS2D.BOTACTION.BUYWEAPON
        	pTB(i).state 	= 0

		end if
	next i

	''
	'' waypoints are not needed anymore
	''
	erase wpc
	cm.waypntconns = 0

	erase wp
	cm.waypoints = 0

end sub

'':::::
sub cs2dBotRestart( cm as CS2DMAP )
	''
	'' assign the nearest paths to bots
	''
	for i = 0 to cm.players-1
		if( pTB(i).isbot ) then

        	''
        	cs2dBotNearestPath cm, pTB(i), x, y

			''
			pTB(i).b.ix		= 0
			pTB(i).b.iy     = 0
			pTB(i).b.ex 	= 0
			pTB(i).b.ey     = 0

			''
			pTB(i).b.action = CS2D.BOTACTION.BUYWEAPON
			pTB(i).state 	= 0

		end if
	next i

end sub

'':::::
function cs2dBotAdd%( cm as CS2DMAP, byval typ as integer, byval team as integer )
	dim x as single, y as single, angle as integer
	dim p as integer
	dim bname as string

    cs2dBotAdd = -1

    bname = "[b]" + ltrim$( str$( cint(rnd * 100) ) )
    if( typ = CS2D.PLAYER.TERRORIST ) then
    	bname = bname + "-t"
    else
    	bname = bname + "-ct"
    end if

    p = cs2dPlayerNew( cm, bname, typ, team, -1 )
	pTB(p).state 	 = 0

	pTB(p).b.maxwalk = 200 + rnd * 400
	pTB(p).b.maxstop = 10 + rnd * 20

	cs2dBotAdd = p

end function

'':::::
sub cs2dBotFindPoint ( cm as CS2DMAP, x as integer, y as integer, byval typ as integer, _
					   byval findSource as integer ) static
    dim i as integer, e as integer
    dim entity as integer
    dim eTB(0 to 31) as integer

	'' check the mission type here..

	if( typ = CS2D.PLAYER.TERRORIST ) then
		if( findSource ) then
			entity = CS2D.ENT.INFOT
		else
			select case cm.mission
			case CS2D.MISSIONTYPE.ASSASSINATION
				entity = CS2D.ENT.INFOVIP
			case CS2D.MISSIONTYPE.BOMBDEFUSE
				entity = CS2D.ENT.INFOBOMBSPOT
			case CS2D.MISSIONTYPE.HOSTAGERESCUE
				entity = CS2D.ENT.INFOHOSTAGE
			case else
				entity = CS2D.ENT.INFOCT
			end select
		end if

	else
		if( findSource ) then
			entity = CS2D.ENT.INFOCT
		else
			select case cm.mission
			case CS2D.MISSIONTYPE.ASSASSINATION
				entity = CS2D.ENT.INFOESCAPEPOINT
			case CS2D.MISSIONTYPE.BOMBDEFUSE
				entity = CS2D.ENT.INFOBOMBSPOT
			case CS2D.MISSIONTYPE.HOSTAGERESCUE
				entity = CS2D.ENT.INFOHOSTAGE
			case else
				entity = CS2D.ENT.INFOT
			end select
		end if
	end if

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

		x = entTB(e).xpos * cm.ts.tilews
		y = entTB(e).ypos * cm.ts.tilehs
	end if

end sub

'':::::
function cs2dBotFindWaypoint%( cm as CS2DMAP, byval px as integer, byval py as integer ) static
    dim closest as long, dist as long
    dim dx as long, dy as long

	p = -1
	closest = 2147483647
	for i = 0 to cm.waypoints-1
		x = wp(i).xpos * cm.ts.tilews
		y = wp(i).ypos * cm.ts.tilehs

		dx = (x - px)
		dy = (y - py)

		dist = ( (dx*dx) + (dy*dy) )
		if( dist < closest ) then
			closest = dist
			p = i
		end if
	next i

	cs2dBotFindWaypoint = p

end function

'':::::
function cs2dBotChangePath( bot as CS2DPLAYER ) static

	cs2dBotChangePath = -1

	p = pathTB(bot.b.idx+bot.b.pnt)

	for i = 0 to botPaths-1
		idx 	= botpathTB(i).idx
		nodes 	= botpathTB(i).nodes

		if( idx <> bot.b.idx ) then
			for j = 0 to nodes-1
				if( pathTB(idx+j) = p ) then
					bot.b.idx = idx
					bot.b.pnt = j
					bot.b.nodes = nodes
					exit function
				end if
			next j
		end if

	next i

	cs2dBotChangePath = 0

end function

'':::::
sub cs2dBotNearestPath( cm as CS2DMAP, bot as CS2DPLAYER, xpos as integer, ypos as integer ) static
    dim closest as long, dist as long
    dim dx as long, dy as long
    dim x as integer, y as integer
    dim px as integer, py as integer

	px = int(bot.x) \ cm.ts.tilews
	py = int(bot.y) \ cm.ts.tilehs

	p = -1
	closest = 2147483647

	for i = 0 to botPaths-1
		idx 	= botpathTB(i).idx
		nodes 	= botpathTB(i).nodes

		for j = 0 to nodes-1
			t = pathTB(idx+j)

			x = t mod cm.xsize
			y = t \ cm.xsize

			dx = (x - px)
			dy = (y - py)

			dist = ( (dx*dx) + (dy*dy) )
			if( dist < closest ) then
				closest = dist
				bot.b.idx = idx
				bot.b.pnt = j
				bot.b.nodes = nodes
				xpos = x
				ypos = y
			end if
		next j
    next i

end sub

'':::::
function cs2dBotNextPath%( cm as CS2DMAP, byval pdir as integer, bot as CS2DPLAYER, _
						   xpos as integer, ypos as integer ) static

	dim i as integer, p as integer

	res = -1

	i = bot.b.idx
	p = bot.b.pnt
	if( pdir = 0 ) then
		p = p - 1
		if( p < 0 ) then
			p = 1
			res = 0
		end if
	else
		p = p + 1
		if( p >= bot.b.nodes ) then
			p = bot.b.nodes-2
			res = 0
		end if
	end if
	bot.b.pnt = p

	n = pathTB(i + p)

	xpos = n mod cm.xsize
	ypos = n \ cm.xsize

	cs2dBotNextPath = res

end function

'':::::
sub recalcStep ( player as CS2DPLAYER, _
			     byval ix as integer, byval iy as integer, byval ex as integer, byval ey as integer )

    dim delta as long

	delta = cs2dCalcStep( ix, iy, ex, ey, player.xinc, player.yinc )

	if( (player.state and CS2D.PSTAT.SHOOTING) = 0 ) then
		player.angle = (cs2dGetAngle( ix, iy, ex, ey ) + 90) mod 360
	end if

end sub


'':::::
function cs2dBotColliding% ( cm as CS2DMAP, byval p as integer, _
				 		     byval px as single, byval py as single )
	dim prad as single

	cs2dBotColliding = 0

	prad = ((cm.ts.tilew+8)/2) * env.scale

	for i = 0 to cm.players-1
		if( i <> p ) then
			if( cs2dCheckCollision( px, py, prad, pTB(i).x, pTB(i).y, prad ) ) then
				cs2dBotColliding = -1
				exit function
			end if
		end if
	next i

end function

'':::::
sub cs2dBotReverse( player as CS2DPLAYER, ix as integer, iy as integer, ex as integer, ey as integer )

	swap ix, ex
	swap iy, ey
	player.b.pdir = player.b.pdir xor 1
	player.xinc = -player.xinc
	player.yinc = -player.yinc

	if( (player.state and CS2D.PSTAT.SHOOTING) = 0 ) then
		player.angle = (player.angle + 180) mod 360
	end if

end sub

'':::::
sub cs2dBotWalk( cm as CS2DMAP, ti() as integer, byval p as integer )
    dim e as integer
    dim dx as long, dy as long
    dim xpos as integer, ypos as integer

	'' dead?
	if( pTB(p).state and CS2D.PSTAT.DEAD ) then
		exit sub
	end if

	'' stopped?
	if( not (pTB(p).state and CS2D.PSTAT.WALKING) ) then
		exit sub
	end if

	'' get ini point, if not set yet, start from bot's current position
	ix = pTB(p).b.ix
	iy = pTB(p).b.iy
	if( (ix = 0) and (iy = 0) ) then
		ix = int(pTB(p).x)
		iy = int(pTB(p).y)
	end if

	'' get end point, if not set yet, get the first path point
	ex = pTB(p).b.ex
	ey = pTB(p).b.ey
	if( (ex = 0) and (ey = 0) ) then
		t = pathTB( pTB(p).b.idx+pTB(p).b.pnt )
		xpos = t mod cm.xsize
		ypos = t \ cm.xsize
		ex = (xpos * cm.ts.tilews) + (cm.ts.tilews\2)
		ey = (ypos * cm.ts.tilehs) + (cm.ts.tilehs\2)

		recalcStep pTB(p), ix, iy, ex, ey
	end if

	'' check if bot is close enough to end point
	dx = (ex - int(pTB(p).x))
	dy = (ey - int(pTB(p).y))
	if( ((dx*dx)+(dy*dy)) < 4 ) then

        '' change to other bot's path if any crossing?
		if( pTB(p).b.pdir = 0 ) then
			d = pTB(p).b.nodes - pTB(p).b.pnt
		else
			d = pTB(p).b.pnt + 1
		end if
		prob = pTB(p).b.nodes \ d

        if( cint( rnd*prob ) = 1 ) then
			if( cs2dBotChangePath( pTB(p) ) ) then
			end if
		end if

		'' get next waypoint
		res = cs2dBotNextPath( cm, pTB(p).b.pdir, pTB(p), xpos, ypos )

		ix = int(pTB(p).x)
		iy = int(pTB(p).y)

		ex = (xpos * cm.ts.tilews) + (cm.ts.tilews\2)
		ey = (ypos * cm.ts.tilehs) + (cm.ts.tilehs\2)

        recalcStep pTB(p), ix, iy, ex, ey

        '' need to change the direction?
        if( not res ) then
        	pTB(p).b.pdir = pTB(p).b.pdir xor 1
        end if
	end if

	'' check player collisions against other players
	'''px = pTB(p).x + (pTB(p).xinc * pTB(p).speed)
	'''py = pTB(p).y + (pTB(p).yinc * pTB(p).speed)


	'''if( cs2dBotColliding( cm, p, pTB(), px, py ) ) then
	'''	cs2dBotReverse pTB(p), ip, ep, ix, iy, ex, ey
	'''	pTB(p).state = pTB(p).state and not CS2D.PSTAT.WALKING
    '''
    '''else

    	'' check player collisions against the map
    	res = cs2dPlayerMove( cm, ti(), p )

    	select case res
    	'' pos changed? recalc step
    	case 1
			ix = int(pTB(p).x)
			iy = int(pTB(p).y)

    		recalcStep pTB(p), ix, iy, ex, ey

    	'' didn't move? bad waypoints :P
    	case -1
			ix = int(pTB(p).x)
			iy = int(pTB(p).y)
			cs2dBotNearestPath cm, pTB(p), xpos, ypos
			ex = (xpos * cm.ts.tilews) + (cm.ts.tilews\2)
			ey = (ypos * cm.ts.tilehs) + (cm.ts.tilehs\2)

			recalcStep pTB(p), ix, iy, ex, ey

    	end select
    '''end if

	'' save ini end end points
	pTB(p).b.ix = ix
	pTB(p).b.iy = iy
	pTB(p).b.ex = ex
	pTB(p).b.ey = ey
end sub

'':::::
function cs2dPlayerVisible%( cm as CS2DMAP, ti() as integer, _
							 byval x1 as integer, byval y1 as integer, _
							 byval x2 as integer, byval y2 as integer ) static

	dim x as single, y as single
	dim xinc as single, yinc as single
	dim px as integer, py as integer
	dim cmapofs as long
	dim delta as long
	dim i as integer

	cs2dPlayerVisible = 0

	def seg = cm.map \ 65536&
	cmapofs = cm.map and &h0000FFFF&

	delta = cs2dCalcStep( x1, y1, x2, y2, xinc, yinc )

	'' too far?
	if( delta > env.dist\2 ) then
		exit function
	end if

	x = x1
	y = y1
	visible = -1
	for i = 1 to cint(delta)
		px = cint( x ) \ cm.ts.tilews
		py = cint( y ) \ cm.ts.tilehs

		tofs = (py * cm.xsize) + px
    	t = peek( cmapofs + tofs )

    	select case ti(t)
    	'' ray intersecting an wall or block?
    	case CS2D.TILE.WALL, CS2D.TILE.BLOCK
			visible = 0
			exit for
		end select

		x = x + xinc
		y = y + yinc
	next i

	cs2dPlayerVisible = visible

end function

'':::::
function cs2dBotFindClosestEnemy% ( cm as CS2DMAP, ti() as integer, byval p as integer ) static

	dim px as integer, py as integer
	dim x as integer, y as integer
	dim i as integer, fov as integer
	dim dx as long, dy as long, dist as long, closest as long, maxdist as long

	typ 	= pTB(p).typ
	px      = int(pTB(p).x)
	py		= int(pTB(p).y)

	select case cm.botskills
	case CS2D.BOTSKILLS.NORMAL, CS2D.BOTSKILLS.PROGAMER
		fov = CS2D.PLAYER.FOV
	case CS2D.BOTSKILLS.NEWBIE
		fov = CS2D.PLAYER.FOV\2
	end select


	maxdist = (clng(env.dist)*env.dist)\2

	n = -1
	closest = 2147483647
	for i = 0 to cm.players-1
		if( not pTB(i).state and CS2D.PSTAT.DEAD ) then
			if( i <> p ) then
				if( pTB(i).typ <> typ ) then

					'' 1st: check if enemy is near enough and find the nearest
					x = int(pTB(i).x)
					y = int(pTB(i).y)
					dx = px - x
					dy = py - y
					dist = (dx*dx) + (dy*dy)
					if( dist < maxdist ) then
						if( dist < closest ) then

							'' cheater bots can see players anywhere
							if( cm.botskills <> CS2D.BOTSKILLS.CHEATER ) then

								'' 2nd: check if enemy is inside the bot's field-of-view
								cs2dCalcFovTriangle fov, env.dist\2, px, py, pTB(p).angle, x1, y1, x2, y2, x3, y3
								if( cs2dPointInsideTriangle( x, y, x1, y1, x2, y2, x3, y3 ) ) then

									'' 3rd: check if there isn't any wall/obstacle between the bots
									if( cs2dPlayerVisible( cm, ti(), px, py, x, y ) ) then
										n = i
										closest = dist
									end if

								end if

							else
								if( cs2dPlayerVisible( cm, ti(), px, py, x, y ) ) then
									n = i
									closest = dist
								end if
							end if

						end if
					end if
				end if
			end if
		end if
	next i

	cs2dBotFindClosestEnemy = n

end function

'':::::
sub cs2dBotBuy( cm as CS2DMAP, byval p as integer )
    dim item as integer, i as integer, j as integer
    dim iTB(0 to 15) as integer

    typ 	= pTB(p).typ
    points 	= pTB(p).points

    '' buy a secondary weapon (primary is always avaliable)
    j = 0
    for i = CS2D.WEAPON.SECINI to CS2D.WEAPON.SECEND
    	if( (itemTB(i).buyer and typ) <> 0 ) then
        	if( pTB(p).secweapon <> i ) then
        		if( points >= itemTB(i).price ) then
        			iTB(j) = i
        			j = j + 1
        			if( j >= 16 ) then exit for
            	end if
            end if
    	end if
    next i

    '' randomically choose it
    item = -1
    if( j > 0 ) then
    	i = cint( rnd*(j-1) )
    	if( i > j-1 ) then i = j-1
    	item = iTB( i )
    end if

    if( item <> -1 ) then
    	cs2dPlayerBuyItem cm, p, item
    end if

	'' buy ammo if needed
    if( pTB(p).priweapon <> 0 ) then
    	if( (pTB(p).priammo < 20) and (pTB(p).prirefill = 0) ) then
    		cs2dPlayerBuyItem cm, p, CS2D.ITEM.PrimaryAmmo
    	end if
    end if

    if( pTB(p).secweapon <> 0 ) then
    	if( (pTB(p).secammo < 10) and (pTB(p).secrefill = 0) ) then
    		cs2dPlayerBuyItem cm, p, CS2D.ITEM.SecundaryAmmo
    	end if
    end if

end sub

'':::::
sub cs2dBotUpdateAll( cm as CS2DMAP, ti() as integer )

	for i = 0 to cm.players-1
		if( pTB(i).isbot ) then
			if( not pTB(i).state and CS2D.PSTAT.DEAD ) then

				''
				'' check weapons
				''
				if( pTB(i).weapon = CS2D.WEAPON.PRIMARY ) then
					a = pTB(i).priammo
					r = pTB(i).prirefill
				else
					a = pTB(i).secammo
					r = pTB(i).secrefill
				end if

				if( (a = 0) and (r = 0) ) then
					cs2dPlayerDropWeapon cm, i
				end if

				if( pTB(i).weapon = CS2D.WEAPON.PRIMARY ) then
					if( pTB(i).secweapon <> 0 ) then
						pTB(i).weapon = CS2D.WEAPON.SECUNDARY
						w = pTB(i).secweapon
					else
						w = pTB(i).priweapon
					end if
				else
					w = pTB(i).secweapon
				end if

				if( w = 0 ) then
					if( pTB(i).weapon = CS2D.WEAPON.PRIMARY ) then
						pTB(i).weapon = CS2D.WEAPON.SECUNDARY
					else
						pTB(i).weapon = CS2D.WEAPON.PRIMARY
					end if
				end if

				select case pTB(i).b.action

				'' move bot
				case CS2D.BOTACTION.WALK
					if( (pTB(i).state and CS2D.PSTAT.WALKING) ) then

						cs2dBotWalk cm, ti(), i

						if( cint(rnd * pTB(i).b.maxwalk) = 1 ) then
							pTB(i).state = pTB(i).state and not CS2D.PSTAT.WALKING
						end if
					else
						if( cint(rnd * pTB(i).b.maxstop) = 1 ) then
							pTB(i).state = pTB(i).state or CS2D.PSTAT.WALKING
						end if
					end if

				'' buy
				case CS2D.BOTACTION.BUYWEAPON
					cs2dBotBuy cm, i
					pTB(i).b.action = CS2D.BOTACTION.WALK
				end select


				''
				'' search for enemies
				''
				e = cs2dBotFindClosestEnemy( cm, ti(), i )
				if( e <> -1 ) then

					pTB(i).angle = (cs2dGetAngle( int(pTB(i).x), int(pTB(i).y), _
											      int(pTB(e).x), int(pTB(e).y) ) + 90) mod 360
                    pTB(i).state = pTB(i).state or CS2D.PSTAT.SHOOTING

					cs2dPlayerShoot cm, ti(), i

            	else
            		pTB(i).state = pTB(i).state and not CS2D.PSTAT.SHOOTING
            	end if
			end if
		end if
	next i

end sub


''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
'' pathfinding
''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

'':::::
Function u_calcDistance%( byval src as integer, byval dst as integer ) Static
	Dim ix as integer, iy as integer
	Dim ex as integer, ey as integer
	Dim dx as integer, dy as integer

	ix = src mod i_xsize
	iy = src \ i_xsize

	ex = dst mod i_xsize
	ey = dst \ i_xsize

	dx = abs( ex - ix )
	dy = abs( ey - iy )
	if( i_rndlevel > 0 ) then
		dx = cint( dx * rnd*i_rndlevel )
		dy = cint( dy * rnd*i_rndlevel )
	end if

	If( dx <= dy ) Then
		u_calcDistance = dx
	Else
		u_calcDistance = dy
	End If

End Function

'':::::
function u_calcCost%( byval src as integer, byval dst as integer ) static

	if( i_rndlevel > 0 ) then
		u_calcCost = 1 + int( rnd*i_rndlevel )
	else
		u_calcCost = 1
	end if

End Function

'':::::
Function u_findSuccessors( byval src as integer, tTB() as integer ) static

	Dim i as integer, j as integer, k as integer, l as integer
	Dim ip as integer, ep as integer

	j = 0
	for i = 0 to i_waypntconns-1
		ip = wpc(i).inip
		ep = wpc(i).endp

		k = (wp(ip).ypos * i_xsize) + wp(ip).xpos
		l = (wp(ep).ypos * i_xsize) + wp(ep).xpos

		if( k = src ) then
			tTB(j) = l
			j = j + 1
		end if

		if( l = src ) then
			tTB(j) = k
			j = j + 1
		end if
    next i

	u_findSuccessors = j

End Function

