defint a-z
'$include: 'inc\ugl.bi'
'$include: 'inc\kbd.bi'
'$include: 'inc\tmr.bi'
'$include: 'inc\2dfx.bi'
'$include: 'inc\uglu.bi'
'$include: 'inc\mouse.bi'
'$include: 'inc\cs2d.bi'

const XRES  = 320*2
const YRES  = 200*2
const PAGES = 1
const SCALE! = 1!								'' <-- only use 1 or .5
const CFMT  = UGL.8BIT
const VSYNC = 0
const DOFOV = 0

const FPS% 	= 50
const PINC%	= 4


const PTYPE 		= CS2D.PLAYER.CTERRORIST
const PTEAM 		= CS2D.PLAYER.ARCTICAVENGERS
const PNAME$		= "H3x0r"

const MISSIONTYPE   = CS2D.MISSIONTYPE.ASSASSINATION
const BOTKILLS		= CS2D.BOTSKILLS.NEWBIE

const XMENU% 		= 2
const YMENU% 		= (CS2D.RADAR.HGT*SCALE)+8


type GAMEENV
	video		as long
	backbuff	as long
	page		as integer
	kbd			as TKBD
	mouse       as MOUSEINF

	buying		as integer
	buycat		as integer

	teamsel		as integer
	teamtyp		as integer
end type

declare sub 		main	( cmd as string )

declare function 	gamestart%	( map as string )
declare sub 		gamefinish	( )
declare sub 		gameloop	( )

declare sub 		showusage	( )
declare sub 		showerror	( msg as string )

declare sub 		updatePlayer( byval p as integer )

'':::::
dim shared cm as CS2DMAP
dim shared env as GAMEENV

redim shared sm(0) as CS2DSCRMAP
redim shared ti(0) as integer


	main command$



'':::::
sub showusage
	print "demo mapfile [w/o .ext]"
end sub

'':::::
sub showerror( msg as string )
	print "ERROR: "; msg
end sub


'':::::
sub main( cmd as string )
	dim map as string
	dim video as long

	map = cmd
	if( map = "" ) then
		showusage
		exit sub
	end if

	if( not gamestart( map ) ) then
		exit sub
	end if

    gameloop

	gamefinish

end sub

'':::::
function gamestart( map as string )

    gamestart = 0

    randomize timer

    '' start ugl
    print  "starting uGL..."
    if( not uglInit ) then
    	showerror "can't init uGL"
    	exit function
    end if

    '' start cs2d
    print  "starting cs2d..."
    if( not cs2dInit( XRES, YRES, CFMT, SCALE, FPS ) ) then
    	showerror "can't init cs2d"
    	exit function
    end if

    '' load map
    print  "loading map..."
    if( not cs2dLoadMap( map, cm, ti(), DOFOV ) ) then
    	showerror "can't load map"
    	exit function
    end if

    '' load resources
    print  "loading resources..."
    if( not cs2dLoadResources ) then
    	showerror "can't load resources"
    	exit function
    end if

    '' load tile set
    print  "loading tile set..."
    if( not cs2dLoadTileset( cm, sm() ) ) then
    	showerror "can't load tileset"
    	exit function
    end if

    '' load waypoints
    print  "loading waypoints..."
    if( not cs2dLoadWaypoints( cm ) ) then
    	showerror "can't load waypoints"
    	exit function
    end if

	'' create backbuffer
	print  "creating back buffer..."
	if( PAGES = 1 ) then
		env.backbuff = 0
		'if( clng(XRES) * YRES <= 65536 ) then
		'	env.backbuff = uglNew( UGL.MEM, CFMT, XRES, YRES )
		'end if
		if( env.backbuff = 0 ) then
			env.backbuff = uglNew( UGL.EMS, CFMT, XRES, YRES )
			if( env.backbuff = 0 ) then
				showerror "can't alloc back buffer"
				exit function
			end if
		end if
	end if


	print
	print  "press any key to begin... "
	'do
	'	k$ = inkey$
	'loop while( k$ = "" )


	'' set DC
	env.video = uglSetVideoDC( CFMT, XRES, YRES, PAGES )
	if( env.video = 0 ) then
		showerror "can't change video mode"
		exit function
	end if

	if( PAGES > 1 ) then
		env.backbuff = env.video
		uglSetVisPage 0
        env.page = 1
        uglSetWrkPage 1
	end if

	'dim rc as CLIPRECT
	'rc.xmin = 32
	'rc.ymin = 32
	'rc.xmax = xres-32
	'rc.ymax = yres-32
	'uglSetClipRect env.backbuff, rc
	'uglSetClipRect env.video, rc


	'' start keyboard
	kbdInit env.kbd

	''
	tmrInit

	nres = mouseInit( env.video, env.mouse )
	mouseHide


	gamestart = -1

end function

'':::::
sub gamefinish

	kbdEnd

	'' finish cs2d
	cs2dEnd

    '' finish
    uglRestore
    uglEnd
end sub

'':::::
sub flipBackbuffer

	if( PAGES = 1 ) then
		If( VSYNC ) Then
			Wait &h3DA, 8
		end if
		uglPut env.video, 0, 0, env.backbuff

	else
		uglSetVisPage env.page
        env.page = (env.page+1) mod PAGES

		If( VSYNC ) Then
        	Wait &h3DA, 8
    	End If

        uglSetWrkPage env.page
	end if

end sub

'':::::
sub saveScreenShot
	static c as integer

	ugluSaveTGA env.backbuff, "screenshots\" + rtrim$( cm.name ) + date$ + "_" + hex$(c) + ".tga"

	c = c + 1
end sub

'':::::
sub toggleBuyMenu( byval p as integer )

	if( env.buying ) then
		env.buying = 0
	else
		env.buying = -1
	end if

	env.buycat = 0

end sub

'':::::
sub toggleTeamMenu

	if( env.teamsel ) then
		env.teamsel = 0
	else
		env.teamsel = -1
	end if

	env.teamtyp = 0

end sub

'':::::
sub selectBuyCat( byval p as integer )

	'' get key code
	k = env.kbd.lastkey - 1
	env.kbd.lastkey = 0

	'' not a number?
	if( k < 1 or k > 10 ) then
		exit sub
	end if

	'' sel catalog
	if( env.buycat = 0 ) then
		'' cancel?
		if( k = 10 ) then
			env.buying = 0
			env.buycat = 0

		'' set cat
		elseif( k <= CS2D.BUYMENU.CATS ) then
		 	env.buycat = k
		end if

	'' sel item
	else
		'' back?
		if( k = 10 ) then
			env.buycat = 0

		'get corresponding item
		else

			if( cs2dPlayerCanBuy( cm, p ) ) then
				i = cs2dBuyMenuGetItem( env.buycat, k, p )
				'' item ok?
				if( i <> -1 ) then
					cs2dPlayerBuyItem cm, p, i
					env.buycat = 0
				end if
			else
				cs2dMsgAddAlert CS2D.MSG.NOTINBUYZONE
			end if
		end if
	end if


end sub

'':::::
sub selectTeam( p as integer )

	'' get key code
	k = env.kbd.lastkey - 1
	env.kbd.lastkey = 0

	'' not a number?
	if( k < 1 or k > 10 ) then
		exit sub
	end if

	'' sel team typ
	if( env.teamtyp = 0 ) then
		'' cancel?
		if( k = 10 ) then
			env.teamsel = 0
			env.teamtyp = 0

		'' set typ
		elseif( k <= CS2D.TEAMMENU.TEAMS ) then
		 	env.teamtyp = k
		end if

	'' sel team
	else
		'' back?
		if( k = 10 ) then
			env.teamtyp = 0

		'' sel corresponding team
		else

			id = cs2dTeamMenuSel( env.teamtyp, k )
			'' team ok?
			if( id <> -1 ) then
				cs2dPlayerSelTeam cm, p, env.teamtyp, id
				env.teamsel = 0
				env.teamtyp = 0
			end if
		end if
	end if


end sub

'':::::
sub updatePlayer( byval p as integer )
    dim angle as integer
    dim xinc as single, yinc as single

	''
	'' move
	''
	xinc = 0
	if( env.kbd.a ) then
		xinc = -PINC
	elseif( env.kbd.d ) then
		xinc = PINC
	end if

	yinc = 0
	if( env.kbd.w ) then
		yinc = -PINC
	elseif( env.kbd.s ) then
		yinc = PINC
	end if


    'if( yinc < 0 ) then
    '	angle = 0
    '	if( xinc < 0 ) then
    '		angle = 359 - 45
    '	elseif( xinc > 0 ) then
    '		angle = 0 + 45
    '	end if
    'elseif( yinc > 0 ) then
    '	angle = 180
    '	if( xinc < 0 ) then
    '		angle = 180 + 45
    '	elseif( xinc > 0 ) then
    '		angle = 180 - 45
    '	end if
    'else
    '	if( xinc < 0 ) then
    '		angle = 270
    '	elseif( xinc > 0 ) then
    '		angle = 90
    '	end if
    'end if

    ''
    '' angle
    ''
	angle = cs2dGetAngle( xres\2, yres\2, env.mouse.x, env.mouse.y ) + 90

    'if( (xinc <> 0) or (yinc <> 0) ) then
        if( not cs2dPlayerUpdate( cm, ti(), p, xinc, yinc, angle ) ) then
        end if
    'end if

    ''
    '' shoot
    ''
    if( env.mouse.left ) then
       	cs2dPlayerShoot cm, ti(), p
    end if

    ''
    '' take a screen shot
    ''
    if( env.kbd.f5 ) then
    	env.kbd.f5 = 0
        saveScreenShot
	end if

    ''
    '' drop the current weapon
    ''
    if( env.kbd.g ) then
		env.kbd.g = 0
        cs2dPlayerDropWeapon cm, p
	end if

	''
	'' buy
	''
	if( env.kbd.b ) then
		env.kbd.b = 0
		toggleBuyMenu p

	''
	'' select team
	''
	elseif( env.kbd.m ) then
		env.kbd.m = 0
		toggleTeamMenu
	end if

	''
	''
	''
	if( env.buying ) then
        selectBuyCat p

	elseif( env.teamsel ) then
        selectTeam p

    else

		''
		'' exchange weapons
		''
		if( env.kbd.one ) then
			env.kbd.one = 0
			cs2dPlayerSelWeapon p, CS2D.WEAPON.PRIMARY

		elseif( env.kbd.two ) then
			env.kbd.two = 0
			cs2dPlayerSelWeapon p, CS2D.WEAPON.SECUNDARY
		end if

	end if

end sub

'':::::
sub gameloop static
    dim fpst as TMR, sect as TMR
    dim player as integer

    ''
    ''
    ''
    cs2dSelectMission cm, MISSIONTYPE

    cs2dSelectBotSkills cm, BOTSKILLS

    ''
    '' add local player
    ''
    player = cs2dPlayerAdd( cm, PNAME, PTYPE, PTEAM )

    ''
    '' add bots
    ''
    totbots = CS2D.MAXPLAYERS-2

    for i = 1 to totbots

    	if( i <= totbots\2 ) then
    		typ = CS2D.PLAYER.TERRORIST
    	else
    		typ = CS2D.PLAYER.CTERRORIST
    	end if

		team = rnd * CS2D.MAXTEAMS

    	p = cs2dBotAdd( cm, typ, team )
    next i

    ''
    ''
    ''
    cs2dStart cm

	''
    ''
    ''
	tmrNew fpst, TMR.AUTOINIT, 1192755.2 / FPS

	tmrNew sect, TMR.AUTOINIT, 1192755.2


    ''
    '' game loop
    ''
    fpsc = 0
    realfps = FPS
    do until( env.kbd.esc )

		''
		'' update local player
		''
		updatePlayer player

		''
		'' calc screen map
		''
		cs2dMakeScreenMap cm, sm(), player

		''
		'' calc fov
		''
		if( DOFOV ) then
			cs2dMakeFovMap cm, sm(), ti(), player
		end if

		''
		'' do per frame updates
		''
		cs2dUpdate cm, ti()

		''
		'' wait until one frame elapsed
		''
		do while( fpst.counter = 0 ): loop

        ''
        '' if any time left, render the scene
        ''
        if( fpst.counter = 1 ) then

        	cs2dDraw env.backbuff, cm, sm(), ti(), player, CS2D.DRAW.STATPARTICLES or _
														   CS2D.DRAW.SHADOWS or _
														   CS2D.DRAW.PLAYERS or _
														   CS2D.DRAW.BULLETS or _
														   CS2D.DRAW.ENTITIES or _
														   CS2D.DRAW.HUD or _
														   CS2D.DRAW.ITEMS or _
														   CS2D.DRAW.MSGS

			if( env.buying ) then
				cs2dDrawBuyMenu	env.backbuff, env.buycat, XMENU, YMENU, player
			elseif( env.teamsel ) then
				cs2dDrawTeamMenu env.backbuff, env.teamtyp, XMENU, YMENU
			else
				cs2dFontPrint env.backbuff, 2, 2, 255,255,255,  "FPS:" + str$( realfps )
				cs2dFontPrint env.backbuff, 2, 2+16, 255,255,255,  "FRE:" + str$( fre( -1 ) )
			end if

	    	''
	    	'' draw mouse
	    	''
			cs2dMouseShow env.backbuff, env.mouse.x, env.mouse.y, CS2D.MOUSE.GREENPOINTER, cm, player


        	''
        	'' flip the back buffer
        	''
			flipBackbuffer

			fpsc = fpsc + 1
		end if

        ''
        '' decrase frame counter
        ''
		if( fpst.counter > 0 ) then fpst.counter = fpst.counter - 1

		if( sect.counter >= 1 ) then
			sect.counter = 0
			realfps = fpsc
			fpsc = 0
		end if

    loop

end sub
