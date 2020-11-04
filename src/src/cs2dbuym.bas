''
'' CS2D buy menu module - buy menu stuff
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

buymenucatsdata:
data "Handgun", 6, 1,2,3,4,5,6
data "Shotgun", 2, 10,11
data "Sub Machine Gun", 5, 20,21,22,23,24
data "Rifle", 8, 30,31,32,33,34,35,36,37
data "Machine Gun", 1, 40
data "Ammo", 2, 61,62
data "Equipament", 8, 57,58,52,51,53,56,59,54


'' globals
redim shared catTB( 0 ) as CS2DBUYMENU


'':::::
sub cs2dBuyMenuInit
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
sub cs2dBuyMenuEnd

	'' ...

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
		'clr = uglColor( env.cfmt, 96, 96, 96 )
		'uglRectF dst, x, y, x+2+2+w, y+2+2+2+(ch+2)*(CS2D.BUYMENU.CATS+3), clr
		y = y + 2
		x = x + 2

		cs2dFontPrint dst, x, y, 255,255,64, "[Buy Menu]"
		y = y + ch+2

		'clr = uglColor( env.cfmt, 255, 0, 0 )
		'uglHline dst, x, y, x+w, clr
		'y = y + 2

		for i = 0 to CS2D.BUYMENU.CATS-1
			cs2dFontPrint dst, x, y, 255,255,255, str$( i+1 ) + ". " + catTB(i).name
			y = y + ch+2
		next i

		y = y + ch+2
		cs2dFontPrint dst, x, y, 255,255,255, str$( 0 ) + ". Cancel"
		y = y + ch+2

	else

		items = catTB(cat-1).items

		'clr = uglColor( env.cfmt, 96, 96, 96 )
		'uglRectF dst, x, y, x+2+2+w, y+2+2+2+(ch+2)*(items+3), clr
		y = y + 2
		x = x + 2

		cs2dFontPrint dst, x, y, 255,255,64, "[" + rtrim$( catTB(cat-1).name ) + "]"
		y = y + ch+2

		'clr = uglColor( env.cfmt, 255, 0, 0 )
		'uglHline dst, x, y, x+w, clr
		'y = y + 2

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
