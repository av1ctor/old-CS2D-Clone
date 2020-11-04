''
'' CS2D messages module - msg and alerts stuff
''
'' aug/2004 - written [v1ctor]
''
'' obs: needs PDS or VBDOS to compile, 'cause the BYVAL's used
''

option explicit

defint a-z
'$include: 'inc\ugl.bi'
'$include: 'inc\dos.bi'
'$include: 'inc\cs2d.bi'
'$include: 'inc\cs2dint.bi'

type FMSG
	o		as long
	l		as integer
end type

type AMSG
	text	as string * CS2D.MSG.MAXLEN
	lgt		as integer
	frame	as integer
end type

type PMSG
	text	as string * CS2D.MSG.MAXLEN
	lgt		as integer
	frame	as integer
	fromp	as integer
	top		as integer
end type


''globals
dim shared fmsg as FILE
redim shared fmsgTB( 0 ) as FMSG
redim shared amsgTB( 0 ) as AMSG
redim shared pmsgTB( 0 ) as PMSG


'':::::
sub readMsgs
    dim f as BFILE
    dim i as integer, l as integer, c as integer
    dim ofs as long

    ''
    '' as there's no enough mem to load all msgs, they will stay on msgs file
    '' and will be read only when needed, we will build an offset/length table
    '' to look up the right msg
    ''
    if( not bfileOpen( f, CS2D.MSG.FILE, F4READ, 4096 ) ) then
    	exit sub
   	end if

   	i = 0
   	ofs = 0
   	do while( not bfileEOF( f ) )

		fmsgTB(i).o = ofs

		l = 0
		do
			c = bfileRead1( f )
			if( c = CR ) then
				c = bfileRead1( f )
				exit do
			end if
			l = l + 1
		loop while( c <> -1 )

		ofs = ofs + l + 2

		if( l > CS2D.MSG.MAXLEN ) then
			l = CS2D.MSG.MAXLEN
		end if
		fmsgTB(i).l = l

		i = i + 1
		if( i => CS2D.MAXFMSGS ) then
			exit do
		end if
   	loop

	bfileClose f

end sub

'':::::
sub cs2dMsgInit
    dim i as integer

	''
	redim fmsgTB( 0 to CS2D.MAXFMSGS-1 ) as FMSG

	readMsgs

	''
	redim amsgTB( 0 to CS2D.MAXAMSGS-1 ) as AMSG

	for i = 0 to CS2D.MAXAMSGS-1
    	amsgTB(i).lgt = 0
    	amsgTB(i).frame = 0
    next i

	''
	redim pmsgTB( 0 to CS2D.MAXPMSGS-1 ) as PMSG

	for i = 0 to CS2D.MAXPMSGS-1
    	pmsgTB(i).lgt = 0
    	pmsgTB(i).frame = 0
    next i

	''
	if( not fileOpen( fmsg, CS2D.MSG.FILE, F4READ ) ) then
		exit sub
	end if

end sub

'':::::
sub cs2dMsgEnd

	erase fmsgTB

	erase amsgTB

	erase pmsgTB

	fileClose fmsg

end sub

'':::::
function newAMsg%
	static c as integer

	newAMsg = c

	c = (c + 1) mod CS2D.MAXAMSGS

end function

'':::::
sub cs2dMsgAddAlert( byval msg as integer )
	dim i as integer, l as integer
	dim res as long
	dim addr as long

	l = fmsgTB(msg).l
	if( l = 0 ) then
		exit sub
	end if

	i = newAMsg

	amsgTB(i).lgt = l
	amsgTB(i).frame = (clng(CS2D.MSG.MAXTIME) * env.fps) \ 1000

	res = fileSeek( fmsg, FSSTART, fmsgTB(msg).o )
	addr = (varseg( amsgTB(i).text ) * 65536&) + varptr( amsgTB(i).text )
	res = fileRead( fmsg, addr, l )

end sub

'':::::
function newPMsg%
	static c as integer

	newPMsg = c

	c = (c + 1) mod CS2D.MAXPMSGS

end function

'':::::
sub cs2dMsgAddPublic( byval msg as integer, byval fromp as integer, byval top as integer )
	dim i as integer, l as integer
	dim res as long
	dim addr as long

	l = fmsgTB(msg).l
	if( l = 0 ) then
		exit sub
	end if

	i = newPMsg

	pmsgTB(i).fromp = fromp
	pmsgTB(i).top = top
	pmsgTB(i).lgt = l
	pmsgTB(i).frame = (clng(CS2D.MSG.MAXTIME) * env.fps) \ 1000

	res = fileSeek( fmsg, FSSTART, fmsgTB(msg).o )
	addr = (varseg( pmsgTB(i).text ) * 65536&) + varptr( pmsgTB(i).text )
	res = fileRead( fmsg, addr, l )

end sub

'':::::
sub cs2dMsgUpdate
    dim i as integer

	for i = 0 to CS2D.MAXAMSGS-1
		if( amsgTB(i).frame > 0 ) then
			amsgTB(i).frame = amsgTB(i).frame - 1
			if( amsgTB(i).frame = 0 ) then
				amsgTB(i).lgt = 0
			end if
		end if
	next i

	for i = 0 to CS2D.MAXPMSGS-1
		if( pmsgTB(i).frame > 0 ) then
			pmsgTB(i).frame = pmsgTB(i).frame - 1
			if( pmsgTB(i).frame = 0 ) then
				pmsgTB(i).lgt = 0
			end if
		end if
	next i

end sub

'':::::
sub cs2dMsgDraw( byval dst as long )
    dim i as integer, l as integer
    dim msg as string, fromname as string, toname as string
    dim x as integer, y as integer, ch as integer

    ch = CS2D.FONT.CHARH * env.scale

	'' alerts
	y = (env.yres\2) - (ch\2)

	for i = 0 to CS2D.MAXAMSGS-1
    	l = amsgTB(i).lgt
    	if( l > 0 ) then
    		msg = left$( amsgTB(i).text, l )
    		x = (env.xres\2) - (cs2dFontWidth( msg )\2)
    		cs2dFontPrint dst, x, y, 33,255,66, msg
    		y = y + ch+2
    	end if
	next i

	'' public
	y = 2

	for i = 0 to CS2D.MAXPMSGS-1
    	l = pmsgTB(i).lgt
    	if( l > 0 ) then
    		fromname = rtrim$( pTB( pmsgTB(i).fromp ).name )
    		toname = rtrim$( pTB( pmsgTB(i).top ).name )
    		msg = toname + " " + left$( pmsgTB(i).text, l ) + " " + fromname
    		x = env.xres - cs2dFontWidth( msg )
    		cs2dFontPrint dst, x, y, 33,255,66, msg
    		y = y + ch+2
    	end if
	next i

end sub

