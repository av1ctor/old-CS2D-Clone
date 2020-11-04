''
'' CS2D items module - items (weapon etc) control
''
'' aug/2004 - written [v1ctor]
''

option explicit

defint a-z
'$include: 'inc\ugl.bi'
'$include: 'inc\dos.bi'
'$include: 'inc\cs2d.bi'
'$include: 'inc\cs2dint.bi'
'$include: 'inc\queue.bi'

const CS2D.MAXDYNITEMS%		= CS2D.MAXPLAYERS%*3


declare sub 		drawItem	( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, it as CS2DDYNITEM )


'' globals
dim shared itemslist as TLIST
dim shared ibase as integer

redim shared dynitemTB( 0 ) as CS2DDYNITEM

redim shared lTB( 0 ) as LNODE

redim shared itemTB( 0 ) as CS2DITEM

'' id, u, price, buyer (0=nobody,1=terr,2=cterr=3=terr/cterr), name, type(1=weapon, 2=item)
itemsdata:
'' USP
data  1,  1, 500, 3, "USP", 1
'' Glock
data  2,  1, 400, 3, "Glock", 1
'' Deagle
data  3,  2, 650, 3, "Deagle", 1
'' P228
data  4,  1, 600, 3, "P228", 1
'' Elite
data 5, 1, 1000, 3, "Elite", 1
'' Fiveseven
data 6, 1, 750, 3, "5seven", 1
'' M3
data 10, 6, 1700, 3, "M3", 1
'' XM1014
data 11, 6, 3000, 3, "XM1014", 1
'' MP5
data 20, 4, 1500, 3, "MP5", 1
'' TMP
data 21, 3, 1250, 2, "TMP", 1
'' P90
data 22, 5, 2350, 3, "P90", 1
'' MAC10
data 23, 3, 1400, 1, "MAC10", 1
'' UMP45
data 24, 4, 1700, 3, "UMP45", 1
'' AK47
data 30, 8, 2500, 1, "AK47", 1
'' SG552
data 31, 9, 3500, 1, "SG552", 1
'' M4A1
data 32, 7, 3100, 2, "M4A1", 1
'' Aug
data 33, 10, 3500, 2, "Aug", 1
'' Scout
data 34, 10, 2750, 3, "Scout", 1
'' AWP
data 35, 12, 4750, 3, "AWP", 1
'' G3SG1
data 36, 11, 5000, 3, "G3SG1", 1
'' SG550
data 37, 11, 4200, 3, "SG550", 1
'' M249
data 40, 13, 5750, 3, "M249", 1
'' Laser
data 45, 19, 0, 0, "Laser", 1

'' HE
data 51, 14, 300, 3, "HE", 3
'' Flash
data 52, 15, 200, 3, "Flashbang", 3
'' Smoke
data 53, 16, 300, 3, "Smoke Grenade", 3
'' Flare
data 54, 17, 300, 3, "Flare Grenade", 3
'' Bomb
data 55, 0, 0, 0, "", 0
'' DefuseKit
data 56, 2, 200, 2, "DefuseKit", 2
'' Kevlar
data 57, 3, 650, 3, "Kevlar", 2
'' KevlarHelm
data 58, 3, 1000, 3, "Kevlar+Helm", 2
'' Nightvision
data 59, 0, 1250, 3, "Nightvision", 2
'' PlantedBomb
data 60, 18, 0, 0, "", 3

'' PrimaryAmmo
data 61,  0, 100, 3, "Primary Ammo", 4
'' SecundaryAmmo
data 62,  0, 200, 3, "Secundary Ammo", 4

'' EOL
data -1

''::::
sub readItems
	dim i as integer

	restore itemsdata
	do
		read i
		if( i = -1 ) then
			exit do
		end if

		read itemTB(i).u
		read itemTB(i).price, itemTB(i).buyer
		read itemTB(i).name
		read itemTB(i).typ

		itemTB(i).u  = itemTB(i).u * 32
	loop

end sub


''::::
sub cs2dItemInit
    dim i as integer

    ''
    '' list items
    ''
    redim itemTB( 0 to CS2D.MAXITEMS-1 ) as CS2DITEM

    readItems


    ''
    '' on map items
    ''
    redim dynitemTB( 0 to CS2D.MAXDYNITEMS-1 ) as CS2DDYNITEM

    listInit itemslist, lTB(), CS2D.MAXDYNITEMS

    for i = 0 to CS2D.MAXDYNITEMS-1
    	dynitemTB(i).ln = -1
    next i

end sub

''::::
sub cs2ditemEnd

	erase dynitemTB

	listEnd itemslist, lTB()

end sub

'':::::
sub cs2dItemStart( cm as CS2DMAP )
    dim e as integer, i as integer
    dim x as integer, y as integer, a as integer
    dim id as integer, item as integer

	'' clear list
	listClear itemslist, lTB()

    for i = 0 to CS2D.MAXDYNITEMS-1
    	dynitemTB(i).ln = -1
    next i

	''
	ibase = 0

	'' add any ENVITEM entity to list
	item = 0
	for e = 0 to cm.entities-1
		i = entTB(e).idx
		if( i <> -1 ) then
			if( entTB(e).typ = CS2D.ENT.ENVITEM ) then
                x = (entTB(e).xpos * cm.ts.tilews) + (cm.ts.tilews\2)
                y = (entTB(e).ypos * cm.ts.tilehs) + (cm.ts.tilehs\2)
                a = cint( rnd * 359 )
                id = entENVITEM(i).id

                item = cs2dItemAdd( x, y, a, id )
                dynitemTB(item).frame = -1		'' won't be removed

				select case itemTB(id).typ
				case CS2D.ITEMTYPE.WEAPON
					dynitemTB(item).w.ammo   = weaponTB(id).maxammo
					dynitemTB(item).w.refill = 0
                end select
			end if
		end if
	next e

	''
	ibase = item								'' assuming envitem's won't be >= maxdynitems

end sub

'':::::
function newItem% static
	static i as integer
	dim ln as integer

	if( i = 0 ) then i = ibase

	if( dynitemTB(i).ln <> -1 ) then
		listDel itemslist, lTB(), dynitemTB(i).ln
		dynitemTB(i).ln = -1
	end if

	'' find free slot
	ln = listAdd( itemslist, lTB(), i, 0 )
	if( ln = -1 ) then
		newItem = -1
		exit function
	end if

	dynitemTB(i).ln = ln

	newItem = i

	''
	i = (i + 1) mod CS2D.MAXDYNITEMS
	if( i = 0 ) then i = ibase


end function

'':::::
function cs2dItemAdd%( byval x as integer, byval y as integer, byval angle as integer, byval id as integer )
	dim i as integer

	cs2dItemAdd = -1

	i = newItem
	if( i = -1 ) then exit function

	'' save
	dynitemTB(i).id			= id
	dynitemTB(i).x	    	= x
	dynitemTB(i).y	    	= y
	dynitemTB(i).a	    	= angle
	dynitemTB(i).frame		= CS2D.ITEM.MAXTIME * env.fps

	dynitemTB(i).onscreen 	= 0

	cs2dItemAdd = i

end function

'':::::
sub cs2dItemDel( byval i as integer )

	if( i = -1 ) then exit sub

	if( dynitemTB(i).ln <> -1 ) then
		listDel itemslist, lTB(), dynitemTB(i).ln

		dynitemTB(i).ln = -1
	end if

end sub

'':::::
sub cs2dItemUpdateAll( cm as CS2DMAP ) static
    dim i as integer, n as integer, f as integer
    dim x as integer, y as integer
    dim xini as integer, yini as integer
    dim w as integer, h as integer, hw as integer, hh as integer

	xini = (cm.xini * cm.ts.tilews)
	yini = (cm.yini * cm.ts.tilehs)
	w = cm.ts.tilews
	h = cm.ts.tilehs
	hw = cm.ts.tilews\2
	hh = cm.ts.tilehs\2

	i = listGetFirst( itemslist, lTB() )
	do until( i = -1 )
		n = listGetNext( itemslist, lTB() )

		'' check if item is on screen
		x = (cm.xdif + (dynitemTB(i).x - xini) - cm.tx) - hw
		y = (cm.ydif + (dynitemTB(i).y - yini) - cm.ty) - hh

        if( ((x >= -w) and (x < env.xres+w)) and ((y >= -h) and (y < env.yres+h)) ) then
            dynitemTB(i).onscreen = -1
        else
        	dynitemTB(i).onscreen = 0
        end if

        '' del item if it's too old
        if( dynitemTB(i).frame > 0 ) then
        	dynitemTB(i).frame = dynitemTB(i).frame - 1
        	if( dynitemTB(i).frame = 0 ) then
            	cs2dItemDel i
        	end if
        end if

        i = n
	loop

end sub

'':::::
function cs2dItemIsOver%( cm as CS2DMAP, byval x as integer, byval y as integer )
	dim i as integer
	dim dist as long, dx as long, dy as long, mindist as integer

	cs2dItemIsOver = -1

	mindist = (cm.ts.tilews*cm.ts.tilews) \ 2

	i = listGetFirst( itemslist, lTB() )
	do until( i = -1 )

		dx = dynitemTB(i).x - x
		dy = dynitemTB(i).y - y
		dist = dx*dx + dy*dy
		if( dist <= mindist ) then
			cs2dItemIsOver = i
			exit function
		end if

        i = listGetNext( itemslist, lTB() )
	loop

end function

'':::::
function cs2dItemIsOverOnScreen%( cm as CS2DMAP, byval x as integer, byval y as integer )
	dim i as integer
	dim ix as integer, iy as integer
	dim dist as long, dx as long, dy as long, mindist as integer

	cs2dItemIsOverOnScreen = -1

	mindist = (cm.ts.tilews*cm.ts.tilews) \ 4

	i = listGetFirst( itemslist, lTB() )
	do until( i = -1 )

		if( dynitemTB(i).onscreen ) then
			ix = (cm.xdif + (dynitemTB(i).x - (cm.xini * cm.ts.tilews)) - cm.tx) - (cm.ts.tilews\2)
			iy = (cm.ydif + (dynitemTB(i).y - (cm.yini * cm.ts.tilehs)) - cm.ty) - (cm.ts.tilehs\2)

			dx = ix - x
			dy = iy - y
			dist = dx*dx + dy*dy
			if( dist <= mindist ) then
				cs2dItemIsOverOnScreen = i
				exit function
			end if
		end if

        i = listGetNext( itemslist, lTB() )
	loop

end function

'':::::
sub cs2dDrawItems( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP ) static
    dim i as integer

	i = listGetFirst( itemslist, lTB() )
	do until( i = -1 )

		if( dynitemTB(i).onscreen ) then
			drawItem dst, cm, sm(), dynitemTB(i)
		end if

        i = listGetNext( itemslist, lTB() )
	loop

end sub

'':::::
sub drawItem( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, it as CS2DDYNITEM ) static
	dim x as integer, y as integer
	dim px as integer, py as integer
	dim i as integer
	dim dc as long
	dim u as integer, v as integer, flip as integer

	x = cm.xdif + (it.x - (cm.xini * cm.ts.tilews)) - cm.tx
	y = cm.ydif + (it.y - (cm.yini * cm.ts.tilehs)) - cm.ty

	if( cm.dofov ) then
		py = (y+cm.ts.tilehs-1) \ cm.ts.tilehs
		px = (x+cm.ts.tilews-1) \ cm.ts.tilews
		i = (py * (cm.xend-cm.xini+1)) + px
		if( not sm(i).a ) then exit sub
	end if

	x = x - (cm.ts.tilews\2)
	y = y - (cm.ts.tilehs\2)
	i = it.id

	dc = env.weaponsd
	v = 0
	if( itemTB(i).typ = CS2D.ITEMTYPE.WEAPON ) then
		u = weaponTB(i).ud
	else
		if( itemTB(i).typ = CS2D.ITEMTYPE.EQUIPAMENT ) then
			dc = env.items
		end if
        u = itemTB(i).u
	end if

	'' fake rotation with flipping
	flip = 0
	select case it.a
	case 15 to 90
		flip = UGL.VFLIP
	case 90 to 180
		flip = UGL.VHFLIP
	case 180 to 270
		flip = UGL.HFLIP
	end select

	if( flip = 0 ) then
		if( env.scale8 <> 256 ) then
			uglBlitMskScl dst, x, y, env.scale, env.scale, dc, u, v, 32, 32
		else
			uglBlitMsk dst, x, y, dc, u, v, 32, 32
		end if
	else
		uglBlitMskFlipScl dst, x, y, env.scale, env.scale, flip, dc, u, v, 32, 32
	end if

end sub
