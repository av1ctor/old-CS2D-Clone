''
'' CS2D entities module - entities loading and creation
''
'' aug/2004 - written [v1ctor]
''

defint a-z
'$include: 'inc\ugl.bi'
'$include: 'inc\dos.bi'
'$include: 'inc\cs2d.bi'
'$include: 'inc\cs2dint.bi'

option explicit

type IMGCACHE
	filename		as string * 32
	dc				as long
end type


declare function 	readEntityBody%		( bf as BFILE, typ as integer )

declare sub 		skipEntityBody		( bf as BFILE )

declare function 	newENVITEM%			( bf as BFILE )

declare function 	newENVIMAGE%		( bf as BFILE )

declare function 	newENVSPRITE%		( bf as BFILE )

declare function 	newINFOT%			( bf as BFILE )

declare function 	newINFOBOMBSPOT%	( bf as BFILE )

declare function 	newINFOHOSTAGE%		( bf as BFILE )


'' globals
redim shared entTB( 0 ) as CS2DENTITY

redim shared entENVIMAGE( 0 ) as CD2DENVIMAGE

redim shared entENVSPRITE( 0 ) as CD2DENVSPRITE

redim shared entINFOT( 0 ) as CD2DINFOT

redim shared entINFOHOSTAGE( 0 ) as CD2DINFOHOSTAGE

redim shared entINFOBOMBSPOT( 0 ) as CD2DINFOBOMBSPOT

redim shared entENVITEM( 0 ) as CD2DENVITEM

''
redim shared spriteCacheTB( 0 ) as IMGCACHE

redim shared imageCacheTB( 0 ) as IMGCACHE


''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
'' initialization
''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

'':::::
sub cs2dEntityInit

	redim entTB( 0 to CS2D.MAXENTITIES-1 ) as CS2DENTITY

	redim entENVIMAGE( 0 to CS2D.MAXENVIMAGES-1 ) as CD2DENVIMAGE

	redim entENVSPRITE( 0 to CS2D.MAXENVSPRITES-1 ) as CD2DENVSPRITE

	redim entINFOT( 0 to CS2D.MAXINFOTS-1 ) as CD2DINFOT

	redim entINFOHOSTAGE( 0 to CS2D.MAXINFOHOSTAGES-1 ) as CD2DINFOHOSTAGE

	redim entINFOBOMBSPOT( 0 to CS2D.MAXINFOBOMBSPOTS-1 ) as CD2DINFOBOMBSPOT

	redim entENVITEM( 0 to CS2D.MAXENVITEMS-1 ) as CD2DENVITEM

    ''
	redim spriteCacheTB( 0 to CS2D.MAXENVSPRITES-1 ) as IMGCACHE

	redim imageCacheTB( 0 to CS2D.MAXENVSPRITES-1 ) as IMGCACHE

end sub

sub cs2dEntityEnd

	redim entTB( 0 ) as CS2DENTITY

	redim entENVIMAGE( 0 ) as CD2DENVIMAGE

	redim entENVIMAGE( 0 ) as CD2DENVIMAGE

	redim entENVSPRITE( 0 ) as CD2DENVSPRITE

	redim entINFOT( 0 ) as CD2DINFOT

	redim entINFOBOMBSPOT( 0 ) as CD2DINFOBOMBSPOT

	redim entENVITEM( 0 ) as CD2DENVITEM

    ''
	redim spriteCacheTB( 0 ) as IMGCACHE

	redim imageCacheTB( 0 ) as IMGCACHE

end sub

''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
'' loading
''::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

'':::::
sub skipEntityBody( bf as BFILE )
	dim temp as string
	dim i as integer

	for i = 0 to 9
		temp = getCRLFString( bf, 0 )
	next i
end sub

'':::::
function newENVITEM( bf as BFILE )
	static c as integer
	dim res as integer

	newENVITEM = -1

	if( c >= CS2D.MAXENVITEMS ) then
		skipEntityBody bf
		exit function
	end if

	'' id             	   	   dword
    ''                         CRLF
    '' unused                  dword+CRLF[9]

    entENVITEM(c).id 		= bfileRead4( bf )
    res						= bfileRead2( bf )							'' CRLF
	res						= bfileSeek( bf, FSCURRENT, (4+2)*9 )       '' unused

	newENVITEM = c

	c = c + 1
end function

'':::::
function newINFOBOMBSPOT( bf as BFILE )
	static c as integer
	dim res as integer

	newINFOBOMBSPOT = -1

	if( c >= CS2D.MAXINFOBOMBSPOTS ) then
		skipEntityBody bf
		exit function
	end if

	'' range             	   dword
    ''                         CRLF
    '' unused                  dword+CRLF[9]

    entINFOBOMBSPOT(c).range= bfileRead4( bf )
    res						= bfileRead2( bf )							'' CRLF
	res						= bfileSeek( bf, FSCURRENT, (4+2)*9 )       '' unused

	newINFOBOMBSPOT = c

	c = c + 1
end function

'':::::
function newINFOHOSTAGE( bf as BFILE )
	static c as integer
	dim res as integer

	newINFOHOSTAGE = -1

	if( c >= CS2D.MAXINFOHOSTAGES ) then
		skipEntityBody bf
		exit function
	end if

	'' start angle             dword
    ''                         CRLF
    '' look             	   dword		(0 to num of hostage sprites-1)
    ''                         CRLF
    '' unused                  dword+CRLF[8]

    entINFOHOSTAGE(c).startangle = bfileRead4( bf )
    res						= bfileRead2( bf )							'' CRLF
	entINFOHOSTAGE(c).look 	= bfileRead4( bf )
	res						= bfileRead2( bf )							'' CRLF
	res						= bfileSeek( bf, FSCURRENT, (4+2)*8 )       '' unused

	newINFOHOSTAGE = c

	c = c + 1
end function

'':::::
function newINFOT( bf as BFILE )
	static c as integer
	dim res as integer

	newINFOT = -1

	if( c >= CS2D.MAXINFOTS ) then
		skipEntityBody bf
		exit function
	end if

	'' start angle			dword
    ''     					CRLF
	'' unused				dword+CRLF[9]
    entINFOT(c).startangle	= bfileRead4( bf )
    res						= bfileRead2( bf )							'' CRLF
	res						= bfileSeek( bf, FSCURRENT, (4+2)*9 )       '' unused

	newINFOT = c

	c = c + 1
end function

'':::::
function imageCache&( filename as string ) static
    static c as integer
    dim dc as long
    dim i as integer, res as integer
    dim path as string

	dc = 0
	for i = 0 to c-1
		if( rtrim$( imageCacheTB(i).filename ) = filename ) then
			dc = imageCacheTB(i).dc
			exit for
		end if
	next i

	path = CS2D.GFXPATH + CS2D.SPRITESPATH

	if( dc = 0 ) then
		if( env.cfmt <> UGL.8BIT ) then
			if( fileExists( path + CS2D.TILE24BITPATH + filename ) ) then
				path = path + CS2D.TILE24BITPATH
			end if
		end if

		imageCacheTB(c).filename = filename
		dc = uglNewBMPEx( UGL.XMS, env.cfmt, path + filename, BMPOPT.NO332 )
		imageCacheTB(c).dc = dc
		c = c + 1
	end if

	imageCache = dc

end function

'':::::
function newENVIMAGE%( bf as BFILE )
	static c as integer
	dim filename as string
	dim res as integer

	newENVIMAGE = -1

	if( c >= CS2D.MAXENVIMAGES ) then
		skipEntityBody bf
		exit function
	end if

	'' x offset				dword
    '' bfile name			string+CRLF
    '' y offset				dword
    ''     					CRLF
	'' unused				dword+CRLF[8]
	entENVIMAGE(c).xoffset	= bfileRead4( bf )
    filename				= removePath(rtrim$( getCRLFString( bf, 128 ) ) )
    entENVIMAGE(c).yoffset	= bfileRead4( bf )
    res						= bfileRead2( bf )							'' CRLF
	res						= bfileSeek( bf, FSCURRENT, (4+2)*8 )       '' unused

	'' load image
	entENVIMAGE(c).dc 		= imageCache( filename )
    if( entENVIMAGE(c).dc = 0 ) then
    	print "ERROR: "; filename
    end if

	newENVIMAGE = c

	c = c + 1
end function

'':::::
function spriteCache&( filename as string ) static
    static c as integer
    dim dc as long
    dim i as integer
    dim path as string

'const cfmt = UGL.8BIT							'' <-- 2dfx has always to be used with sprites!

	dc = 0
	for i = 0 to c-1
		if( rtrim$( spriteCacheTB(i).filename ) = filename ) then
			dc = spriteCacheTB(i).dc
			exit for
		end if
	next i

	path = CS2D.GFXPATH + CS2D.SPRITESPATH

	if( dc = 0 ) then
		if( env.cfmt <> UGL.8BIT ) then
			if( fileExists( path + CS2D.TILE24BITPATH + filename ) ) then
				path = path + CS2D.TILE24BITPATH
			end if
		end if

		spriteCacheTB(c).filename = filename
		dc = uglNewBMPEx( UGL.XMS, env.cfmt, path + filename, BMPOPT.NO332 or BMPOPT.MASK or UGL.BPINK8 )
		spriteCacheTB(c).dc = dc
		c = c + 1
	end if

	spriteCache = dc

end function

'':::::
function newENVSPRITE%( bf as BFILE )
	static c as integer
	dim filename as string
	dim dci as TDC
	dim res as integer

	newENVSPRITE = -1

	if( c >= CS2D.MAXENVSPRITES ) then
		skipEntityBody bf
		exit function
	end if

    '' x size					dword
	'' file name				string+CRLF
	'' y size					dword
	'' alpha					string+CRLF		(0.0= invisible, 1.0= visible)
	'' x offset					dword
	'' mode						string+CRLF		(1=normal, 2=alphamap, 4=masked, ...)
	'' y offset					dword
	'' rot speed				string+CRLF		(0=none, >0 clockwise, <0 ccw)
	'' rotation angle			dword
	''             				CRLF
	'' r						dword
	''             				CRLF
	'' g						dword
	''             				CRLF
	'' b						dword
	''             				CRLF
	'' FX						dword
	''             				CRLF
	'' blend mode				dword
	''             				CRLF

	entENVSPRITE(c).xsize	= bfileRead4( bf )
    filename				= removePath( rtrim$( getCRLFString( bf, 128 ) ) )
    entENVSPRITE(c).ysize	= bfileRead4( bf )
    entENVSPRITE(c).alpha	= cint(val( rtrim$( getCRLFString( bf, 8 ) ) ) * 256)
    entENVSPRITE(c).xoffset	= bfileRead4( bf )
    entENVSPRITE(c).mode	= val( rtrim$( getCRLFString( bf, 4 ) ) )
	entENVSPRITE(c).yoffset	= bfileRead4( bf )
    entENVSPRITE(c).rotspeed= val( rtrim$( getCRLFString( bf, 8 ) ) )
    entENVSPRITE(c).rotangle= bfileRead4( bf )
    res						= bfileRead2( bf )							'' CRLF
    entENVSPRITE(c).r		= bfileRead4( bf )
    res						= bfileRead2( bf )							'' CRLF
    entENVSPRITE(c).g		= bfileRead4( bf )
    res						= bfileRead2( bf )							'' CRLF
    entENVSPRITE(c).b		= bfileRead4( bf )
    res						= bfileRead2( bf )							'' CRLF
    entENVSPRITE(c).FX		= bfileRead4( bf )
    res						= bfileRead2( bf )							'' CRLF
    entENVSPRITE(c).blendmode= bfileRead4( bf )
    res						= bfileRead2( bf )							'' CRLF

	'' load image
	entENVSPRITE(c).dc 		= spriteCache( filename )
    if( entENVSPRITE(c).dc = 0 ) then
    	print "ERROR: "; filename
    else
    	uglDCGet entENVSPRITE(c).dc, dci
    	entENVSPRITE(c).wdt = dci.xRes
    	entENVSPRITE(c).hgt = dci.yRes
    end if

	newENVSPRITE = c

	c = c + 1
end function


'':::::
function readEntityBody%( bf as BFILE, typ as integer )

	readEntityBody = -1

	select case typ
	case CS2D.ENT.ENVITEM
		readEntityBody = newENVITEM( bf )
	case CS2D.ENT.ENVIMAGE
		readEntityBody = newENVIMAGE( bf )
	case CS2D.ENT.ENVSPRITE
		readEntityBody = newENVSPRITE( bf )
	case CS2D.ENT.INFOT, CS2D.ENT.INFOCT, CS2D.ENT.INFOVIP
		readEntityBody = newINFOT( bf )
	case CS2D.ENT.INFOHOSTAGE
		readEntityBody = newINFOHOSTAGE( bf )
	case CS2D.ENT.INFOBOMBSPOT
		readEntityBody = newINFOBOMBSPOT( bf )
	case else
		skipEntityBody bf
	end select

end function

'':::::
sub cs2dEntityLoadAll( bf as BFILE, byval entities as integer )
	dim i as integer
	dim res as integer

    for i = 0 to entities-1
   		if( i >= CS2D.MAXENTITIES ) then
   			exit for
   		end if

   		'' name				string+CRLF
        '' type				byte
        '' xpos				dword
        '' ypos				dword
        ''    				CRLF
    	entTB(i).title 		= getCRLFString( bf, 8 )
    	entTB(i).typ      	= bfileRead1( bf )
    	entTB(i).xpos		= bfileRead4( bf )
    	entTB(i).ypos		= bfileRead4( bf )
    	res	 				= bfileRead2( bf )		'' CRLF

		entTB(i).idx 		= readEntityBody( bf, entTB(i).typ )
    next i

end sub


