''
'' CS2D menu module - buy/team/etc menus
''
'' aug/2004 - written [v1ctor]
''

option explicit

defint a-z
'$include: 'inc\ugl.bi'
'$include: 'inc\dos.bi'
'$include: 'inc\cs2d.bi'
'$include: 'inc\cs2dint.bi'

type CS2DBUYMENU
	name 			as string * 32
	items			as integer
	itemlist(0 to 7) as integer
end type

type CS2DSUBTEAMMENU
	name			as string * 24
	id				as integer
end type

type CS2DTEAMMENU
	name			as string * 24
	id				as integer
	teams			as integer
	teamlist(0 to 3) as CS2DSUBTEAMMENU
end type

buymenucatsdata:
data "Handgun", 6, 1,2,3,4,5,6
data "Shotgun", 2, 10,11
data "Sub Machine Gun", 5, 20,21,22,23,24
data "Rifle", 8, 30,31,32,33,34,35,36,37
data "Machine Gun", 1, 40
data "Ammo", 2, 61,62
data "Equipament", 8, 57,58,52,51,53,56,59,54

teammenudata:
data "Terrorist",1, 4, "Phoenix Connection",0, "L337 Crew",1, "Arctic Avengers",2, "Guerilla Warfare", 3
data "Counter-terrorist",2, 4, "Seal Team 6",0, "German GS-9",1, "UK SAS",2, "French GIGN",3




'' globals
redim shared catTB( 0 ) as CS2DBUYMENU

redim shared teamTB( 0 ) as CS2DTEAMMENU


'':::::
sub buyMenuInit
	dim i as integer, j as integer, items as integer

	redim catTB( 0 to CS2D.BUYMENU.CATS-1 ) as CS2DBUYMENU

	restore buymenucatsdata
	for i = 0 to CS2D.BUYMENU.CATS-1
		read catTB(i).name
		read catTB(i).items
		for j = 0 to catTB(i).items-1
			read catTB(i).itemlist(j)
		next j
	next i

end sub

'':::::
sub teamMenuInit
	dim i as integer, j as integer, items as integer

	redim teamTB( 0 to CS2D.TEAMMENU.TEAMS-1 ) as CS2DTEAMMENU

	restore teammenudata
	for i = 0 to CS2D.TEAMMENU.TEAMS-1
		read teamTB(i).name
		read teamTB(i).id
		read teamTB(i).teams
		for j = 0 to teamTB(i).teams-1
			read teamTB(i).teamlist(j).name
			read teamTB(i).teamlist(j).id
		next j
	next i

end sub

'':::::
sub cs2dMenuInit

	buyMenuInit

	teamMenuInit

end sub

'':::::
sub buyMenuEnd

	erase catTB

end sub

'':::::
sub teamMenuEnd

	erase teamTB

end sub

'':::::
sub cs2dMenuEnd

	buyMenuEnd

	teamMenuEnd

end sub


'':::::
sub cs2dDrawBuyMenu( byval dst as long, byval cat as integer, byval x as integer, byval y as integer, _
					 byval p as integer )
    dim i as integer, j as integer, items as integer, w as integer
    dim clr as long
    dim price as string
    dim cw as integer, ch as integer

    w = CS2D.FONT.CHARW*12

	cw = CS2D.FONT.CHARW * env.scale
	ch = CS2D.FONT.CHARH * env.scale


	if( cat = 0 ) then
		cs2dFontPrint dst, x, y, 255,255,64, "[Buy Menu]"
		y = y + ch+2

		for i = 0 to CS2D.BUYMENU.CATS-1
			cs2dFontPrint dst, x, y, 255,255,255, str$( i+1 ) + ". " + catTB(i).name
			y = y + ch+2
		next i

		y = y + ch+2
		cs2dFontPrint dst, x, y, 255,255,255, str$( 0 ) + ". Cancel"
		y = y + ch+2

	else

		items = catTB(cat-1).items

		cs2dFontPrint dst, x, y, 255,255,64, "[" + rtrim$( catTB(cat-1).name ) + "]"
		y = y + ch+2

		for i = 0 to items-1
			j = catTB(cat-1).itemlist(i)
			cs2dFontPrint dst, x, y, 255,255,255, str$( i+1 ) + ". " + rtrim$( itemTB(j).name )
			price = "$" + ltrim$( str$( itemTB(j).price ) )
			cs2dFontPrint dst, x+w-cs2dFontWidth( price ), y, 255,255,255, price
			if( (itemTB(j).buyer and pTB(p).typ) = 0 ) then
				uglHLine dst, x, y+(ch\2)-1, x+w, -1
			end if
			y = y + ch+2
		next i

		y = y + ch+2
		cs2dFontPrint dst, x, y, 255,255,255, str$( 0 ) + ". Back"
		y = y + ch+2

	end if

end sub

'':::::
function cs2dBuyMenuGetItem%( byval cat as integer, byval prod as integer, byval p as integer )
    dim i as integer, items as integer

	cs2dBuyMenuGetItem = -1

	items = catTB(cat-1).items

	if( prod < 1 or prod > items ) then
		exit function
	end if

	i = catTB(cat-1).itemlist(prod-1)
	if( (itemTB(i).buyer and pTB(p).typ) = 0 ) then
		exit function
	end if

	cs2dBuyMenuGetItem = i

end function

'':::::
sub cs2dDrawTeamMenu( byval dst as long, byval typ as integer, byval x as integer, byval y as integer )
    dim i as integer, j as integer, teams as integer, w as integer
    dim cw as integer, ch as integer

    w = CS2D.FONT.CHARW*12

	cw = CS2D.FONT.CHARW * env.scale
	ch = CS2D.FONT.CHARH * env.scale


	if( typ = 0 ) then
		cs2dFontPrint dst, x, y, 255,255,64, "[Team Menu]"
		y = y + ch+2

		for i = 0 to CS2D.TEAMMENU.TEAMS-1
			cs2dFontPrint dst, x, y, 255,255,255, str$( i+1 ) + ". " + teamTB(i).name
			y = y + ch+2
		next i

		y = y + ch+2
		cs2dFontPrint dst, x, y, 255,255,255, str$( 0 ) + ". Cancel"
		y = y + ch+2

	else

		teams = teamTB(typ-1).teams

		cs2dFontPrint dst, x, y, 255,255,64, "[" + rtrim$( teamTB(typ-1).name ) + "]"
		y = y + ch+2

		for i = 0 to teams-1
			cs2dFontPrint dst, x, y, 255,255,255, str$( i+1 ) + ". " + rtrim$( teamTB(typ-1).teamlist(i).name )
			y = y + ch+2
		next i

		y = y + ch+2
		cs2dFontPrint dst, x, y, 255,255,255, str$( 0 ) + ". Back"
		y = y + ch+2

	end if

end sub

'':::::
function cs2dTeamMenuSel%( byval typ as integer, byval team as integer )
    dim i as integer, teams as integer

	cs2dTeamMenuSel = -1

	teams = teamTB(typ-1).teams

	if( team < 1 or team > teams ) then
		exit function
	end if

	i = teamTB(typ-1).teamlist(team-1).id

	cs2dTeamMenuSel = i

end function

