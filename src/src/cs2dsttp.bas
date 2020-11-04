''
'' CS2D static particle module - blood and another non-moving crap
''
'' aug/2004 - written [v1ctor]
''

option explicit

defint a-z
'$include: 'inc\ugl.bi'
'$include: 'inc\2dfx.bi'
'$include: 'inc\dos.bi'
'$include: 'inc\cs2d.bi'
'$include: 'inc\cs2dint.bi'
'$include: 'inc\queue.bi'

const CS2D.MAXSTATPARTICLES%	= CS2D.MAXPLAYERS%*2

type CS2DSTATPARTICLE
	dc			as long
	mode		as integer

	onscreen	as integer

	w			as integer
	h			as integer
	u			as integer
	v			as integer

	x			as integer
	y			as integer
	scl			as integer						'' scale

	r			as integer
	g			as integer
	b			as integer
	a			as integer

	frame		as integer						'' anim frame
	frames		as integer

	ln			as integer						'' linked-list node
end type

declare sub 		drawStatParticle	( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, sp as CS2DSTATPARTICLE )


'' globals
dim shared particleslist as TLIST

redim shared particleTB( 0 ) as CS2DSTATPARTICLE

redim shared lTB( 0 ) as LNODE


''::::
sub cs2dStatParticleInit
    dim i as integer

    redim particleTB( 0 to CS2D.MAXSTATPARTICLES-1 ) as CS2DSTATPARTICLE

    listInit particleslist, lTB(), CS2D.MAXSTATPARTICLES

    for i = 0 to CS2D.MAXSTATPARTICLES-1
    	particleTB(i).ln = -1
    next i

end sub

''::::
sub cs2dStatParticleEnd

	redim particleTB( 0 ) as CS2DSTATPARTICLE

	listEnd particleslist, lTB()

end sub

'':::::
function newStatParticle% static
	static p as integer
	dim ln as integer

	if( particleTB(p).ln <> -1 ) then
		listDel particleslist, lTB(), particleTB(p).ln
		particleTB(p).ln = -1
	end if

	'' find free slot
	ln = listAdd( particleslist, lTB(), p, 0 )
	if( ln = -1 ) then
		newStatParticle = -1
		exit function
	end if

	particleTB(p).ln = ln

	newStatParticle = p

	''
	p = (p + 1) mod CS2D.MAXSTATPARTICLES

end function

'':::::
sub cs2dStatParticleAdd( byval dc as long, _
						 byval x as integer, byval y as integer, byval scale as integer, _
				   		 byval r as integer, byval g as integer, byval b as integer, _
				   		 byval a as integer, _
				   		 byval frames as integer, _
				   		 byval mode as integer )
	dim p as integer


	p = newStatParticle
	if( p = -1 ) then exit sub

	'' save
	particleTB(p).dc	= dc
	particleTB(p).w		= 0

	particleTB(p).x	    = x
	particleTB(p).y	    = y
	particleTB(p).scl	= scale
	particleTB(p).r		= r
	particleTB(p).g		= g
	particleTB(p).b		= b
	particleTB(p).a		= a
	particleTB(p).mode 	= mode
	particleTB(p).frame	= 0
	particleTB(p).frames= frames

end sub

'':::::
sub cs2dStatParticleAddEx( byval dc as long, byval u as integer, byval v as integer, _
						   byval w as integer, byval h as integer, _
						   byval x as integer, byval y as integer, byval scale as integer, _
				   		   byval r as integer, byval g as integer, byval b as integer, _
				   		   byval a as integer, _
				   		   byval frames as integer, _
				   		   byval mode as integer )
	dim p as integer


	p = newStatParticle
	if( p = -1 ) then exit sub

	'' save
	particleTB(p).dc	= dc
	particleTB(p).u	    = u
	particleTB(p).v	    = v
	particleTB(p).w	    = w
	particleTB(p).h	    = h

	particleTB(p).x	    = x
	particleTB(p).y	    = y
	particleTB(p).scl	= scale
	particleTB(p).r		= r
	particleTB(p).g		= g
	particleTB(p).b		= b
	particleTB(p).a		= a
	particleTB(p).mode 	= mode
	particleTB(p).frame	= 0
	particleTB(p).frames= frames

end sub


'':::::
sub cs2dStatParticleUpdateAll( cm as CS2DMAP ) static
    dim i as integer, n as integer, f as integer
    dim x as integer, y as integer
    dim xini as integer, yini as integer
    dim w as integer, h as integer

	xini = (cm.xini * cm.ts.tilews)
	yini = (cm.yini * cm.ts.tilehs)

	i = listGetFirst( particleslist, lTB() )
	do until( i = -1 )
        n = listGetNext( particleslist, lTB() )

		w = particleTB(i).w
		h = particleTB(i).h

		x = (cm.xdif + (particleTB(i).x - xini) - cm.tx) - (w\2)
		y = (cm.ydif + (particleTB(i).y - yini) - cm.ty) - (h\2)

        if( ((x >= -w) and (x < env.xres+w)) and ((y >= -h) and (y < env.yres+h)) ) then
            particleTB(i).onscreen = -1
        else
        	particleTB(i).onscreen = 0
        end if

		'' check if particle can be deleted
		f = particleTB(i).frame + 1
        if( f > particleTB(i).frames ) then
            listDel particleslist, lTB(), particleTB(i).ln
            particleTB(i).ln = -1
        else
        	particleTB(i).frame = f
        end if

        i = n
	loop

end sub

'':::::
sub cs2dDrawStatParticles( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP ) static
    dim i as integer

	i = listGetFirst( particleslist, lTB() )
	do until( i = -1 )
		if( particleTB(i).onscreen ) then
			drawStatParticle dst, cm, sm(), particleTB(i)
		end if
        i = listGetNext( particleslist, lTB() )
	loop

end sub

'':::::
sub drawStatParticle( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, sp as CS2DSTATPARTICLE ) static
	dim x as integer, y as integer
	dim i as integer, px as integer, py as integer
	dim f as single

	x = (cm.xdif + (sp.x - (cm.xini * cm.ts.tilews)) - cm.tx)
	y = (cm.ydif + (sp.y - (cm.yini * cm.ts.tilehs)) - cm.ty)

	if( cm.dofov ) then
		py = (y + cm.ts.tilehs-1) \ cm.ts.tilehs
		px = (x + cm.ts.tilews-1) \ cm.ts.tilews
		i = (py * (cm.xend-cm.xini+1)) + px
		if( not sm(i).a ) then exit sub
	end if

	f = sp.frame / sp.frames

	if( sp.mode and TFX.FACTMUL ) then
		tfxSetFactor sp.r, sp.g, sp.b
	end if

	if( sp.mode and TFX.SATADDALPHA ) then
		tfxSetAlpha sp.a-int( sp.a * f )
	end if

	if( sp.w > 0 ) then
		if( sp.scl <> 256 ) then
			tfxBlitBlitScl dst, x, y, sp.dc, sp.u, sp.v, sp.w, sp.h, sp.scl, sp.scl, sp.mode
		else
			tfxBlitBlit dst, x, y, sp.dc, sp.u, sp.v, sp.w, sp.h, sp.mode
		end if
	else
		if( sp.scl <> 256 ) then
			tfxBlitScl dst, x, y, sp.dc, sp.scl, sp.scl, sp.mode
		else
			tfxBlit dst, x, y, sp.dc, sp.mode
		end if
	end if

end sub
