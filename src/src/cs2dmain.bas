''
'' CS2D main module - initialization, updates and misc
''
'' aug/2004 - written [v1ctor]
''
'' obs: needs PDS or VBDOS to compile, 'cause the BYVAL's used
''


defint a-z
'$include: 'inc\dos.bi'
'$include: 'inc\cs2d.bi'
'$include: 'inc\cs2dint.bi'


''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
'' initialization
''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

''::::
function cs2dInit%( byval xres as integer, byval yres as integer, byval cfmt as integer, byval scale as single, byval fps as integer )

	cs2dInit = 0

	''
	env.xres 	= xres
	env.yres 	= yres
	env.dist	= cint( sqr( (csng(xres)*xres) + (csng(yres)*yres) ) )
	env.cfmt 	= cfmt
	env.scale 	= scale
	env.scale8 	= scale*256
	if( env.scale8 <> 256 ) then
		env.scaletiles = -1
	else
		env.scaletiles = 0
	end if
	env.fps		= fps
	env.frmcnt	= 0

    ''
    cs2dMsgInit

    ''
    cs2dPlayerInit

    ''
    cs2dItemInit

    ''
    cs2dBulletInit

    ''
    cs2dMenuInit

    ''
    cs2dEntityInit

    ''
    cs2dStatParticleInit

    ''
    cs2dHudInit


	cs2dInit = -1

end function

''::::
sub cs2dEnd

	''
	cs2dHudEnd

	''
	cs2dStatParticleEnd

	''
	cs2dEntityEnd

	''
	cs2dMenuEnd

	''
	cs2dBulletEnd

	''
	cs2dItemEnd

    ''
    cs2dPlayerEnd

    ''
    cs2dMsgEnd

end sub

'':::::
sub cs2dStart( cm as CS2DMAP )

    ''
    cm.timecnt    = CS2D.MAXTIME
    cm.restartcnt = -1
    cm.winner 	  = -1

    ''
    cs2dPlayerStart cm

    ''
    cs2dItemStart cm

    '' init all bots (pathfinding and stuff)
    cs2dBotStart cm

end sub

'':::::
sub cs2dRestart( cm as CS2DMAP, byval winner as integer )

	''
	cm.timecnt    = CS2D.MAXTIME
	cm.restartcnt = -1
	cm.winner	  = -1

	''
	cs2dPlayerRestart cm, winner

	''
	cs2dBotRestart cm

end sub

'':::::
sub cs2dCheck( cm as CS2DMAP )
    dim t as integer, ct as integer
    dim winner as integer

	if( cm.restartcnt > -1 ) then
		exit sub
	end if

	''
	'' check teams
	''
	t = 0
	ct = 0
	for i = 0 to cm.players-1
		if( not (pTB(i).state and CS2D.PSTAT.DEAD) ) then
			if( pTB(i).typ = CS2D.PLAYER.TERRORIST ) then
				t = t + 1
			else
				ct = ct + 1
			end if
		end if
	next i

	''
	if( (t = 0) or (ct = 0) ) then
		cm.restartcnt = CS2D.RESTARTTIME * env.fps
		if ( t = 0 ) then
    		cm.winner = CS2D.PLAYER.CTERRORIST
    		msg = CS2D.MSG.CTWIN
		elseif( ct = 0 ) then
			cm.winner = CS2D.PLAYER.TERRORIST
			msg = CS2D.MSG.TWIN
		end if

		cs2dMsgAddAlert msg
		exit sub
	end if

	''
	'' check time
	''
	if( cm.timecnt <= 0 ) then
		cm.restartcnt = CS2D.RESTARTTIME * env.fps
		cm.winner 	  = -1
		msg = CS2D.MSG.DRAW
		if( ct > t ) then
			cm.winner = CS2D.PLAYER.CTERRORIST
			msg = CS2D.MSG.CTWIN
		elseif( ct < t ) then
			cm.winner = CS2D.PLAYER.TERRORIST
			msg = CS2D.MSG.TWIN
		end if

		cs2dMsgAddAlert msg
		exit sub
	end if


end sub

''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
'' per frame updates
''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

'':::::
sub cs2dUpdate( cm as CS2DMAP, ti() as integer )
    static fpscnt as integer

	''
	if( cm.restartcnt > -1 ) then
		cm.restartcnt = cm.restartcnt - 1
		if( cm.restartcnt = 0 ) then
			cs2dRestart cm, cm.winner
		end if
	end if

	''
	fpscnt = fpscnt + 1
	if( fpscnt >= env.fps ) then
		fpscnt = 0
		if( cm.timecnt > 0 ) then
			cm.timecnt = cm.timecnt - 1
		end if
	end if

	'' incrase counter
	env.frmcnt = env.frmcnt + 1

	''
	cs2dMsgUpdate

	'' items
	cs2dItemUpdateAll cm

	'' players
	cs2dPlayerUpdateAll cm, ti()

	'' bots
	cs2dBotUpdateAll cm, ti()

	'' bullets
	cs2dBulletUpdateAll cm, ti()

	'' particles
	''...

	'' static particles
	cs2dStatParticleUpdateAll cm

	''
	''
	''
	cs2dCheck cm

end sub

''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
'' selections
''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

'':::::
sub cs2dSelectMission( cm as CS2DMAP, byval mission as integer )

	if( (cm.missions and mission) > 0 ) then
		cm.mission = mission
	else
		i = 1
		do while( i <= 256 )
			if( (cm.missions and i ) > 0 ) then
				cm.mission = cm.missions and i
				exit do
			end if
			i = i * 2
		loop
    end if

end sub

'':::::
sub cs2dSelectBotSkills( cm as CS2DMAP, byval skills as integer )

	if( skills < CS2D.BOTSKILLS.CHEATER ) then
		skills = CS2D.BOTSKILLS.CHEATER
	elseif( skills > CS2D.BOTSKILLS.NEWBIE ) then
		skills = CS2D.BOTSKILLS.NEWBIE
	end if

	cm.botskills = skills

end sub

''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
'' misc
''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

'':::::
function getCRLFString$( bf as BFILE, byval maxsize as integer ) static
	dim temp as string
	dim b as integer, c as integer, k as integer

	temp = ""
	c = 0
	k = -1
	do while( not bfileEOF( bf ) )
		if( k = -1 ) then
			b = bfileRead1( bf )
		else
			b = k
			k = -1
		end if

		if( b = CR ) then
			k = bfileRead1( bf )
			if( k = LF ) then
				exit do
			end if
		end if

		if( c < maxsize ) then
			temp = temp + chr$( b )
			c = c + 1
		end if
	loop

	do while( c < maxsize )
		temp = temp + chr$( 32 )
		c = c + 1
	loop


	getCRLFString = temp
end function

'':::
sub cs2dRotateVector ( byval angle as integer, x as single, y as single, byval scale as single ) static
  	dim s as single, c as single
  	dim t as single

const PI! = 3.141593!
const D2R! = PI / 180!

  	s = sin( angle * D2R ) * scale
  	c = cos( angle * D2R ) * scale

  	t = ((x * c) - (y * s))
  	y = ((y * c) + (x * s))
  	x = t
end sub

'':::::
function cs2dGetAngle% ( byval ix as integer, byval iy as integer, byval ex as integer, byval ey as integer ) static
	dim angle as integer

const PI! = 3.141593!
const R2D! = 180 / PI!

	if( ix = ex ) then
		if( iy < ey ) then
			angle = 90
		elseif( iy > ey ) then
			angle = 270
		else
			angle = 0
		end if

	else
		dx = ex - ix
		dy = ey - iy

		angle = 90 + atn(dy / dx) * R2D!

		if( ix > ex ) then
			angle = angle + 180
		end if

		angle = angle - 90
		if( angle < 0 ) then angle = angle + 360
	end if

	cs2dGetAngle = angle

end function

'':::::
function cs2dCheckCollision%( byval x1 as single, byval y1 as single, byval r1 as single, _
							  byval x2 as single, byval y2 as single, byval r2 as single ) static

	dim dx as single, dy as single
	dim dist as single

	cs2dCheckCollision = 0

	dx = x2 - x1
	dy = y2 - y1

	dist = ( (dx*dx) + (dy*dy) )

	if( dist < ((r1*r1) + (r2*r2)) ) then
		cs2dCheckCollision = -1
	end if

end function

'':::::
function cs2dCalcStep& ( byval x1 as integer, byval y1 as integer, _
						 byval x2 as integer, byval y2 as integer, _
				         xinc as single, yinc as single ) static

    dim dx as long, dy as long
    dim adx as long, ady as long
    dim delta as long

	dx = x2 - x1
	dy = y2 - y1
	adx= abs( dx )
	ady= abs( dy )

	xinc = 0
	yinc = 0

	delta = 0
	if( adx >= ady ) then
		delta = adx
		if( dx > 0 ) then
			xinc = 1
		elseif( dx < 0 ) then
			xinc = -1
		end if
		if( adx <> 0 ) then yinc = dy / adx

	else
		delta = ady
		if( ady <> 0 ) then xinc = dx / ady
		if( dy > 0 ) then
			yinc = 1
		elseif( dy < 0 ) then
			yinc = -1
		end if
	end if

	cs2dCalcStep = delta

end function

'':::::
function cs2dPointInsideTriangle%( byval x as integer, byval y as integer, _
					  		       byval x1 as integer, byval y1 as integer, _
					  			   byval x2 as integer, byval y2 as integer, _
					  			   byval x3 as integer, byval y3 as integer ) static

	dim b0 as single, b1 as single, b2 as single, b3 as single

	b0 = csng(x2 - x1) * (y3 - y1) - csng(x3 - x1) * (y2 - y1)
    b1 = (csng(x2 - x) * (y3 - y) - csng(x3 - x) * (y2 - y)) / b0
    b2 = (csng(x3 - x) * (y1 - y) - csng(x1 - x) * (y3 - y)) / b0
    b3 = (csng(x1 - x) * (y2 - y) - csng(x2 - x) * (y1 - y)) / b0

    inside = 0
    if( (b1 > 0) and (b2 > 0) and (b3 > 0) ) then
		inside = -1
	end if

	cs2dPointInsideTriangle = inside

end function

'':::::
sub cs2dCalcFovTriangle( byval fov as integer, byval dist as integer, _
						 byval px as integer, byval py as integer, _
						 byval angle as integer, _
						 x1 as integer, y1 as integer, x2 as integer, y2 as integer, _
						 x3 as integer, y3 as integer ) static

	dim x as single, y as single

    fov  = fov\2

    '' vertex 1
    x1 = px
    y1 = py

    '' vertex 2
    x = 0
    y = dist
    a = angle - fov
    if( a < 0 ) then a = 360 + a
	cs2dRotateVector (a+180) mod 360, x, y, 1
	x2 = px + cint( x )
	y2 = py + cint( y )

    '' vertex 3
    x = 0
    y = dist
    a = (angle + fov) mod 360
	cs2dRotateVector (a+180) mod 360, x, y, 1
	x3 = px + cint( x )
	y3 = py + cint( y )

end sub


'':::::
function removePath$( filename as string )

	i = 1
	do
		f = instr( i, filename, "\" )
		if( f = 0 ) then exit do
		i = f + 1
	loop

	if( i = 1 ) then
		do
			f = instr( i, filename, "/" )
			if( f = 0 ) then exit do
			i = f + 1
		loop
	end if

	removePath = mid$( filename, i )

end function
