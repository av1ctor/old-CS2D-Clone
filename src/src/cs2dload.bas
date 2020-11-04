''
'' CS2D loading module - maps, tiles, etc loading
''
'' aug/2004 - written [v1ctor]
''


defint a-z
'$include: 'inc\ugl.bi'
'$include: 'inc\dos.bi'
'$include: 'inc\cs2d.bi'
'$include: 'inc\cs2dint.bi'

declare sub 		col2row				( byval map as long, byval cols as integer, byval rows as integer )

declare function 	cs2dGetMissionType%	( cm as CS2DMAP )

''            signature               string+CRLF
''            unknown0                byte[3*16+2] (0's)
''            unknown1                string+CRLF[10]
''            desc					  string+CRLF (as decimal: mapsize + 'x' sizeof_unkown2 + '$' + unknown_number + '%' + unknown_number)
''            tileset                 string+CRLF
''            tileinfs    	  		  byte  (less 1)
''            x_size_less1            dword
''            y_size_less1            dword
''            background              string+CRLF
''            scroll_x                dword
''            scroll_y                dword
''            color_r                 byte
''            color_g                 byte
''            color_b                 byte
''            signature2              string+CRLF
''
''            tile_inf                byte[tileinfs+1]
''
''            map                     byte[(x_size_less1+1)*(y_size_less1+1)] (in column order!)
''
''            entities				  dword
''
''            entitiesTB			  entity[entities]


'' globals
redim shared wp( 0 ) as CS2DWAYPOINT
redim shared wpc( 0 ) as CS2DWAYCONNECTION


'':::::
function cs2dLoadMap%( mapName as string, cm as CS2DMAP, ti() as integer, byval dofov as integer )
    dim bf as BFILE
    dim temp as string
    dim tsize as integer

	cs2dLoadMap = 0

    if( not bfileOpen( bf, CS2D.MAPPATH + mapName + ".map", F4READ, 4096 ) ) then
    	exit function
    end if

    cm.name 		= mapName

    cm.dofov		= dofov

    '' signature
    temp 			= getCRLFString( bf, 32 )

    '' unknown0
    res& = bfileSeek( bf, FSCURRENT, 3*16+2 )

    '' unknown1
    for i = 0 to 9
    	temp		= getCRLFString( bf, 0 )
    next i

    '' desc
    temp			= getCRLFString( bf, 0 )

    '' tileset
    cm.tileset 		= getCRLFString( bf, 13 )

    '' tileinfs
    cm.tinfs 		= bfileRead1( bf ) + 1

    cm.xsize        = bfileRead4( bf ) + 1
    cm.ysize        = bfileRead4( bf ) + 1
    tsize = cm.xsize * cm.ysize

    '' background
    cm.background   = getCRLFString( bf, 13 )

    cm.xscroll		= bfileRead4( bf )
    cm.yscroll		= bfileRead4( bf )

    cm.rcolor		= bfileRead1( bf )
	cm.gcolor		= bfileRead1( bf )
	cm.bcolor		= bfileRead1( bf )

    '' signature2
    temp			= getCRLFString( bf, 0 )

    '' tile info
    redim ti( 0 to cm.tinfs-1 ) as integer

    for i = 0 to cm.tinfs-1
    	ti(i) = bfileRead1( bf )
    next i


    '' map
    cm.map			= memCAlloc( tsize )
    if( cm.map = 0 ) then
    	bfileClose bf
    	exit function
    end if

    if( bfileRead( bf, cm.map, tsize ) <> tsize ) then
    	memFree cm.map
    	bfileClose bf
    	exit function
    end if

    '' entities
    cm.entities		= bfileRead4( bf )
    if( cm.entities = -1 ) then
    	cm.entities = 0
    else
    	'' load entities
    	cs2dEntityLoadAll bf, cm.entities
    end if


    bfileClose bf


    '' convert map from column to row order
    col2row cm.map, cm.xsize, cm.ysize


	''
	cm.players 		= 0
	cm.waypoints 	= 0
	cm.waypntconns	= 0

	cm.xmax 		= ((cm.xsize+1) * CS2D.TILEWIDTH)
	cm.ymax 		= ((cm.ysize+1) * CS2D.TILEHEIGHT)


	'' check game type
	cm.missions 	= cs2dGetMissionType( cm )


	cs2dLoadMap = -1
end function

'':::::
function cs2dGetMissionType%( cm as CS2DMAP )
	dim e as integer, i as integer
	dim typ as integer

	typ = CS2D.MISSIONTYPE.DEATHMATCH
	for e = 0 to cm.entities-1

		i = entTB(e).idx

		if( i <> -1 ) then
			select case entTB(e).typ
			case CS2D.ENT.INFOVIP, CS2D.ENT.INFOESCAPEPOINT
				typ = typ or CS2D.MISSIONTYPE.ASSAULT
			case CS2D.ENT.INFOHOSTAGE, CS2D.ENT.INFORESCUEPOINT
                typ = typ or CS2D.MISSIONTYPE.HOSTAGERESCUE
            case CS2D.ENT.INFOBOMBSPOT
            	typ = typ or CS2D.MISSIONTYPE.BOMBDEFUSE
            end select
        end if
	next e

	cs2dGetMissionType = typ

end function

'':::::
function cs2dLoadResources%
    dim path as string
    dim path2 as string

	cs2dLoadResources = 0

    path = CS2D.GFXPATH
    path2 = CS2D.GFXPATH

    if( env.cfmt <> UGL.8BIT ) then
    	path = path + CS2D.TILE24BITPATH
    end if

    if( env.scale8 < 256 ) then
    	path2 = path2 + CS2D.TILESCALEDPATH
    end if

	'' load wall shadow map, if ...
	if( env.shadmap = 0 ) then
		env.shadmap = uglNewBMPEx( UGL.XMS, UGL.8BIT, path2 + "shadowmap.bmp", BMPOPT.NO332 )
		if( env.shadmap = 0 ) then
			exit function
		end if
	end if

	'' load player sprites, if ... (can't be allocated on XMS or EMS, due the 16K limit of uglRot)
	if( env.players = 0 ) then
		env.players = uglNewBMPEx( UGL.MEM, env.cfmt, path + "players.bmp", BMPOPT.NO332 or BMPOPT.MASK or UGL.BPINK8 )
		if( env.players = 0 ) then
			exit function
		end if
	end if

	'' load player legs sprites, if ...
	if( env.legs = 0 ) then
		env.legs = uglNewBMPEx( UGL.MEM, env.cfmt, path + "legs.bmp", BMPOPT.NO332 or BMPOPT.MASK or UGL.BPINK8 )
		if( env.legs = 0 ) then
			exit function
		end if
	end if

	'' load weapons sprites, if ... (can't be allocated on XMS or EMS, due the 16K limit of uglRot)
	if( env.weapons = 0 ) then
		env.weapons = uglNewBMPEx( UGL.MEM, env.cfmt, path + "weapons.bmp", BMPOPT.NO332 or BMPOPT.MASK or UGL.BPINK8 )
		if( env.weapons = 0 ) then
			exit function
		end if
	end if

	'' load weapons item sprites, if ...
	if( env.weaponsd = 0 ) then
		env.weaponsd = uglNewBMPEx( UGL.XMS, env.cfmt, path + "weaponsd.bmp", BMPOPT.NO332 or BMPOPT.MASK or UGL.BPINK8 )
		if( env.weaponsd = 0 ) then
			exit function
		end if
	end if

	'' load item sprites, if ...
	if( env.items = 0 ) then
		env.items = uglNewBMPEx( UGL.XMS, env.cfmt, path + "items.bmp", BMPOPT.NO332 or BMPOPT.MASK or UGL.BPINK8 )
		if( env.items = 0 ) then
			exit function
		end if
	end if


	'' load fragments sprites, if ...
	if( env.fragments = 0 ) then
		env.fragments = uglNewBMPEx( UGL.XMS, UGL.8BIT, path2 + "fragments.bmp", BMPOPT.NO332 )
		if( env.fragments = 0 ) then
			exit function
		end if
	end if

	'' load blood sprite, if ...
	if( env.blood = 0 ) then
		env.blood = uglNewBMPEx( UGL.XMS, UGL.8BIT, path2 + "blood.bmp", BMPOPT.NO332 )
		if( env.blood = 0 ) then
			exit function
		end if
	end if

	'' load smoke sprite, if ...
	if( env.smoke = 0 ) then
		env.smoke = uglNewBMPEx( UGL.XMS, UGL.8BIT, path2 + "smoke.bmp", BMPOPT.NO332 )
		if( env.smoke = 0 ) then
			exit function
		end if
	end if

	cs2dLoadResources = -1

end function

'':::::
function cs2dLoadTileset%( cm as CS2DMAP, sm() as CS2DSCRMAP )
	dim dc as TDC
	dim path as string
	dim tilefile as string
	dim scale as single

	cs2dLoadTileset = 0

	scale = 1

	tilefile = rtrim$( cm.tileset )

    path = CS2D.GFXPATH + CS2D.TILESPATH

    '' load high-color tiles if they exist
    if( env.cfmt <> UGL.8BIT ) then
    	if( fileExists( path + CS2D.TILE24BITPATH + tilefile ) ) then
    		path = path + CS2D.TILE24BITPATH
    	end if
    end if

   	'' load pre-scaled low-color tiles if they exist
   	if( env.scale8 < 256 ) then
   		if( fileExists( path + CS2D.TILESCALEDPATH + tilefile ) ) then
   			env.scaletiles = 0
   			scale = env.scale
   			path = path + CS2D.TILESCALEDPATH
  		end if
   	end if


    cm.ts.dc = uglNewBMPEx( UGL.XMS, env.cfmt, path + tilefile, BMPOPT.NO332 )
    if( cm.ts.dc = 0 ) then
		exit function
    end if

    uglDCGet cm.ts.dc, dc

    cm.ts.xtiles = (dc.xRes \ (CS2D.TILEWIDTH * scale) )
    cm.ts.ytiles = (dc.yRes \ (CS2D.TILEHEIGHT * scale) )
    cm.ts.tiles = cm.ts.xtiles * cm.ts.ytiles

    cm.ts.tilew = CS2D.TILEWIDTH  * scale
    cm.ts.tileh = CS2D.TILEHEIGHT * scale

    cm.ts.tilews = CS2D.TILEWIDTH * env.scale
    cm.ts.tilehs = CS2D.TILEHEIGHT * env.scale


	'' realoc screen map
	redim sm(0 to (((env.xres\cm.ts.tilews)+12) * _
				   ((env.yres\cm.ts.tilehs)+12))-1) as CS2DSCRMAP


	cs2dLoadTileset = -1

end function

'':::::
function cs2dLoadWaypoints%( cm as CS2DMAP )
	dim bf as BFILE
	dim filename as string
	dim c as integer, i as integer, id as integer

	cs2dLoadWaypoints = 0

	filename = rtrim$( cm.name ) + ".wps"

    if( not bfileOpen( bf, CS2D.WAYPOINTSPATH + filename, F4READ, 4096 ) ) then
    	exit function
    end if


	'' waypoints
	c = bfileRead4( bf )

	redim wp( 0 to CS2D.MAXWAYPOINTS-1 ) as CS2DWAYPOINT

	for i = 0 to c-1
		id = bfileRead4( bf )
		wp(id).xpos = bfileRead4( bf )
		wp(id).ypos = bfileRead4( bf )
	next i

	cm.waypoints = c

	'' waypoints connections
	c = bfileRead4( bf )

	redim wpc( 0 to c-1 ) as CS2DWAYCONNECTION

	for i = 0 to c-1
		wpc(i).inip	= bfileRead4( bf )
		wpc(i).endp	= bfileRead4( bf )
	next i

	cm.waypntconns = c


	bfileClose bf


	cs2dLoadWaypoints = -1

end function

'':::::
sub col2row( byval map as long, byval cols as integer, byval rows as integer )
    dim b1 as integer, b2 as integer
    dim c as integer, r as integer
    dim mapseg as integer, mapofs as long
    dim ofs1 as long, ofs2 as long
    dim tmap as long

	mapseg = map \ 65536&
	mapofs = map and &h0000FFFF&

	def seg = mapseg

	if( rows = cols ) then						'' square map?
		for r = 0 to (rows - 1)
			ofs2 = mapofs + (r * rows) + r
			ofs1 = mapofs + (r * rows) + r
			for c = 0 to (cols - 1) - r
				b1 = peek( ofs1 )
				b2 = peek( ofs2 )
				poke ofs1, b2
				poke ofs2, b1
				ofs1 = ofs1 + 1
				ofs2 = ofs2 + rows
			next c
		next r

	else
		tmap = memAlloc( rows * cols )
		if( tmap = 0 ) then exit sub

		dim tmapseg as integer, tmapofs as long
		tmapseg = tmap \ 65536&
		tmapofs = tmap and &h0000FFFF&

		ofs1 = mapofs
		for c = 0 to cols - 1
			ofs2 = tmapofs + c
			for r = 0 to rows - 1
				def seg = mapseg
				b1 = peek( ofs1 )
				ofs1 = ofs1 + 1
				def seg = tmapseg
				poke ofs2, b1
				ofs2 = ofs2 + cols
			next r
		next c

        memCopy map, tmap, rows * cols

		memFree tmap
	end if

end sub

