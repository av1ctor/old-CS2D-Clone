''
'' internal declarations, not used in user code
''

const CR% = 13%
const LF% = 10%


const CS2D.FONT.CHARW% 		= 12%
const CS2D.FONT.CHARH% 		= 12%
const CS2D.FONT.CHARSPROW% 	= 10%
const CS2D.FONT.FIRSTCHAR%	= 33%
const CS2D.FONT.LASTCHAR%	= 127%
const CS2D.FONT.CHARS%		= (CS2D.FONT.LASTCHAR-CS2D.FONT.FIRSTCHAR)+1
const CS2D.FONT.CHARSPC%	= 1

type CS2DFONT
	lgap		as integer
	wdt			as integer
end type


declare sub 		cs2dRotateVector	( byval angle as integer, x as single, y as single, byval scale as single )


declare function 	cs2dCheckCollision%	( byval x1 as single, byval y1 as single, byval r1 as single, _
							  			  byval x2 as single, byval y2 as single, byval r2 as single )

declare function	cs2dCalcStep& 		( byval x1 as integer, byval y1 as integer, _
										  byval x2 as integer, byval y2 as integer, _
				   						  xinc as single, yinc as single )

declare function 	cs2dPointInsideTriangle% ( byval x as integer, byval y as integer, _
					  		    		  byval x1 as integer, byval y1 as integer, _
					  					  byval x2 as integer, byval y2 as integer, _
					  					  byval x3 as integer, byval y3 as integer )

declare sub 		cs2dCalcFovTriangle	( byval fov as integer, byval dist as integer, _
										  byval px as integer, byval py as integer, _
										  byval angle as integer, _
						 				  x1 as integer, y1 as integer, x2 as integer, y2 as integer, _
						 				  x3 as integer, y3 as integer )

declare function 	getCRLFString$		( bf as BFILE, byval maxsize as integer )

declare function 	removePath$			( filename as string )


declare sub 		cs2dEntityLoadAll	( bf as BFILE, byval entities as integer )


''
'' global variables
''
common shared env as CS2ENV

common shared pTB() as CS2DPLAYER, weaponTB() as CS2DWEAPON, itemTB() as CS2DITEM, dynitemTB() as CS2DDYNITEM

common shared entTB() as CS2DENTITY, entINFOT() as CD2DINFOT
common shared entENVIMAGE() as CD2DENVIMAGE, entENVSPRITE() as CD2DENVSPRITE, entENVITEM() as CD2DENVITEM

common shared fontTB() as CS2DFONT

common shared wp() as CS2DWAYPOINT, wpc() as CS2DWAYCONNECTION

common shared pathTB() as integer
