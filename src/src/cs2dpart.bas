''
'' cs2dpart.bas - Particle module for cs2d qb
'' Should only be compiled with vbdos
''
defint a-z
option explicit
'$include: 'inc\ugl.bi'
'$include: 'inc\2dfx.bi'
'$include: 'inc\cs2dpart.bi'

const true      = -1
const false     =  0


declare sub int_LinkListAdd ( indx as integer, _
                              head as integer, _
                              tail as integer )
declare sub int_LinkListDel ( indx as integer, _
                              head as integer, _
                              tail as integer )
                                          
                                          
dim shared hasInit as integer
dim shared freeHead as integer
dim shared freeTail as integer
dim shared usedHead as integer
dim shared usedTail as integer

redim shared cs2dPart( 1 ) as cs2dpart_t





'' :::::::::::::
'' name: cs2dPartInit
'' desc: Inits the particle module
''
'' :::::::::::::
defint a-z
sub cs2dPartInit ( maxparticles as integer )
    dim i as integer
    dim f as integer
    dim l as integer

    if ( hasInit = true ) then
        cs2dPartEnd
    end if
    
    ''
    '' Allocate memory
    ''
    redim cs2dPart( maxparticles-1 ) as cs2dpart_t


    ''
    '' Init state and build free particles list
    ''
    hasInit  = true
    usedHead = cs2d.part.free
    usedTail = cs2d.part.free

    f = lbound( cs2dPart )
    l = ubound( cs2dPart )
    freeHead = f
    freeTail = l

    for  i = f to l
        cs2dPart( i ).prev = i-1
        cs2dPart( i ).next = i+1
    next i

    cs2dPart( f ).prev = cs2d.part.free
    cs2dPart( l ).next = cs2d.part.free

end sub




'' :::::::::::::
'' name: cs2dPartEnd
'' desc: Finalizes the particle module
''
'' :::::::::::::
defint a-z
sub cs2dPartEnd
    
    if ( hasInit = false ) then
        exit sub
    end if
    
    ''
    '' Reset state
    ''
    hasInit     = false
    freeHead    = cs2d.part.free
    freeTail    = cs2d.part.free
    usedHead    = cs2d.part.free
    usedTail    = cs2d.part.free

    ''
    '' Free memory
    ''
    erase cs2dPart

end sub




'' :::::::::::::
'' name: cs2dPartNew
'' desc: Creates a new particle and returns its index, or
''       cs2d.part.error if it failes
''
'' :::::::::::::
defint a-z
function cs2dPartNew% ( posx as single, _
                        posy as single, _
                        dirx as single, _
                        diry as single, _
                        maxage as integer, _
                        mode as integer, _
                        hDC as long )
    dim pindx as integer
    
    if ( hasInit = false ) then
        cs2dPartNew% = cs2d.part.error
        exit function
    end if

    ''
    '' Check for a free particle slot
    ''
    if ( freeTail = cs2d.part.free ) then
        cs2dPartNew% = cs2d.part.error
        exit function
    end if


    ''
    '' Update linked lists
    ''
    pindx = freeTail
    int_LinkListDel pindx, freeHead, freeTail
    int_LinkListAdd pindx, usedHead, usedTail
    

    ''
    '' Set particle properties
    ''
    cs2dPart( pindx ).used   = true
    cs2dPart( pindx ).pos.x  = posx
    cs2dPart( pindx ).pos.y  = posy
    cs2dPart( pindx ).dir.x  = dirx
    cs2dPart( pindx ).dir.y  = diry
    cs2dPart( pindx ).age    = 0
    cs2dPart( pindx ).maxage = maxage

    cs2dPart( pindx ).hDC    = hDC
    cs2dPart( pindx ).alpha  = 0.0
    cs2dPart( pindx ).mode   = mode

    cs2dPartNew% = pindx

end function




'' :::::::::::::
'' name: cs2dPartDel
'' desc: Deletes a particle
''
'' :::::::::::::
defint a-z
sub cs2dPartDel ( pindx as integer )
    
    if ( hasInit = false ) then
        exit sub
    end if
    
    ''
    '' Update linked lists
    ''
    cs2dPart(pindx).used = false
    int_LinkListDel pindx, usedHead, usedTail
    int_LinkListAdd pindx, freeHead, freeTail

end sub




'' :::::::::::::
'' name: cs2dPartUpdate
'' desc: Updates particles state
''
'' :::::::::::::
defint a-z
sub cs2dPartUpdate
    dim pindx as integer
    dim pnext as integer
    
    if ( hasInit = false ) then
        exit sub
    end if

    ''
    '' Walk through the active particles list
    ''    
    pindx = usedHead
    while ( pindx <> cs2d.part.free )
        pnext = cs2dPart( pindx ).next

        ''
        '' Update properies
        ''
        cs2dPart( pindx ).pos.x  = cs2dPart( pindx ).pos.x + _
                                   cs2dPart( pindx ).dir.x
        cs2dPart( pindx ).pos.y  = cs2dPart( pindx ).pos.y + _
                                   cs2dPart( pindx ).dir.y

        if ( cs2dPart( pindx ).mode and cs2d.part.ages ) then
            cs2dPart( pindx ).age = cs2dPart( pindx ).age + 1

            if ( cs2dPart( pindx ).age >= cs2dPart( pindx ).maxage ) then
                cs2dPartDel pindx
            end if
        end if

        if ( cs2dPart( pindx ).mode and cs2d.part.blendt ) then
            cs2dPart( pindx ).alpha = cs2dPart( pindx ).alpha + _
                                      (255.0 / cs2dPart( pindx ).maxage)

            if ( cs2dPart( pindx ).alpha >= 255.0 ) then
                cs2dPartDel pindx
            end if
        end if

        pindx = pnext
    wend
    
end sub




'' :::::::::::::
'' name: cs2dPartDraw
'' desc: Draw particles
''
'' :::::::::::::
defint a-z
sub cs2dPartDraw ( hDstDC as long )
    dim pindx as integer

    if ( hasInit = false ) then
        exit sub
    end if
    
    ''
    '' Walk through the active particles
    ''    
    pindx = usedHead
    while ( pindx <> cs2d.part.free )

        if ( (cs2dPart( pindx ).mode and cs2d.part.blend ) or _
             (cs2dPart( pindx ).mode and cs2d.part.blendt) ) then

            tfxSetAlpha cint( cs2dPart( pindx ).alpha )

            tfxBlit hDstDC, _
                    cint( cs2dPart( pindx ).pos.x ), _
                    cint( cs2dPart( pindx ).pos.y ), _
                    cs2dPart( pindx ).hDC, _
                    tfx.mask or tfx.alpha

        else
            uglPutMsk hDstDC, _
                      cint( cs2dPart( pindx ).pos.x ), _
                      cint( cs2dPart( pindx ).pos.y ), _
                      cs2dPart( pindx ).hDC
        end if
    
        pindx = cs2dPart( pindx ).next
    wend

end sub




'' :::::::::::::
'' name: cs2dPartGetMode
'' desc: Get particle mode
''
'' :::::::::::::
defint a-z
function cs2dPartGetMode% ( pindx as integer )
    cs2dPartGetMode% = cs2dPart( pindx ).mode
end function



'' :::::::::::::
'' name: cs2dPartSetMode
'' desc: Set particle mode
''
'' :::::::::::::
defint a-z
sub cs2dPartSetMode ( pindx as integer, _
                      mode as integer )
    cs2dPart( pindx ).mode = mode
end sub




'' :::::::::::::
'' name: cs2dPartGetAge
'' desc: Get particle age
''
'' :::::::::::::
defint a-z
function cs2dPartGetAge% ( pindx as integer )
    cs2dPartGetAge% = cs2dPart( pindx ).age
end function




'' :::::::::::::
'' name: cs2dPartSetAge
'' desc: Set particle age
''
'' :::::::::::::
defint a-z
sub cs2dPartSetAge ( pindx as integer, _
                     age as integer )
    cs2dPart( pindx ).age = age
end sub




'' :::::::::::::
'' name: cs2dPartGetMaxAge
'' desc: Get particle maxage
''
'' :::::::::::::
defint a-z
function cs2dPartGetMaxAge% ( pindx as integer )
    cs2dPartGetMaxAge% = cs2dPart( pindx ).maxage
end function




'' :::::::::::::
'' name: cs2dPartSetMaxAge
'' desc: Set particle maxage
''
'' :::::::::::::
defint a-z
sub cs2dPartSetMaxAge ( pindx as integer, _
                        maxage as integer )
    cs2dPart( pindx ).maxage = maxage
end sub



'' :::::::::::::
'' name: cs2dPartGetAlpha
'' desc: Get particle alpha
''
'' :::::::::::::
defint a-z
function cs2dPartGetAlpha% ( pindx as integer )
    cs2dPartGetAlpha% = cs2dPart( pindx ).alpha
end function




'' :::::::::::::
'' name: cs2dPartSetAlpha
'' desc: Set particle age
''
'' :::::::::::::
defint a-z
sub cs2dPartSetAlpha ( pindx as integer, _
                       alpha as integer )
    cs2dPart( pindx ).alpha = alpha
end sub




'' :::::::::::::
'' name: cs2dPartGetPos
'' desc: Get particle position
''
'' :::::::::::::
defint a-z
sub cs2dPartGetPos ( posx as integer, _
                     posy as integer, _
                     pindx as integer )
    posx = cs2dPart( pindx ).pos.x
    posy = cs2dPart( pindx ).pos.y
end sub




'' :::::::::::::
'' name: cs2dPartSetPos
'' desc: Set particle position
''
'' :::::::::::::
defint a-z
sub cs2dPartSetPos ( pindx as integer, _
                     posx as integer, _
                     posy as integer )
    cs2dPart( pindx ).pos.x = posx
    cs2dPart( pindx ).pos.y = posy
end sub




'' :::::::::::::
'' name: cs2dPartGetDir
'' desc: Get particle direction
''
'' :::::::::::::
defint a-z
sub cs2dPartGetDir ( dirx as integer, _
                     diry as integer, _
                     pindx as integer )
    dirx = cs2dPart( pindx ).dir.x
    diry = cs2dPart( pindx ).dir.y
end sub




'' :::::::::::::
'' name: cs2dPartSetDir
'' desc: Set particle direction
''
'' :::::::::::::
defint a-z
sub cs2dPartSetDir ( pindx as integer, _ 
                     dirx as integer, _
                     diry as integer )
    cs2dPart( pindx ).dir.x = dirx
    cs2dPart( pindx ).dir.y = diry
end sub




'' :::::::::::::
'' name: cs2dPartGetDC
'' desc: Get particle image
''
'' :::::::::::::
defint a-z
function cs2dPartGetDC& ( pindx as integer )
    cs2dPartGetDC& = cs2dPart( pindx ).hDC
end function




'' :::::::::::::
'' name: cs2dPartSetDC
'' desc: Set particle image
''
'' :::::::::::::
defint a-z
sub cs2dPartSetDC ( pindx as integer, _
                    hDC as long )
    cs2dPart( pindx ).hDC = hDC
end sub










'' :::::::::::::
'' name: int_LinkListAdd
'' desc: Add particle to linked list
''
'' :::::::::::::
defint a-z
sub int_LinkListAdd ( indx as integer, _
                      head as integer, _
                      tail as integer )
    if ( head = cs2d.part.free ) then
        head = indx        
        cs2dPart( indx ).prev = cs2d.part.free    
    else
        cs2dPart( indx ).prev = tail
        cs2dPart( tail ).next = indx        
    end if
    
    tail = indx
    cs2dPart( indx ).next = cs2d.part.free
        
end sub




'' :::::::::::::
'' name: int_LinkListDel
'' desc: Remove particle from linked list
''
'' :::::::::::::
defint a-z
sub int_LinkListDel ( indx as integer, _
                      head as integer, _
                      tail as integer )

    cs2dPart( indx ).used = false
                          
    if ( cs2dPart( indx ).prev = cs2d.part.free ) then
        head = cs2dPart( indx ).next
    else
        cs2dPart( cs2dPart( indx ).prev ).next = cs2dPart( indx ).next
    end if
    
    if ( cs2dPart( indx ).next = cs2d.part.free ) then
        tail = cs2dPart( indx ).prev
    else
        cs2dPart( cs2dPart( indx ).next ).prev = cs2dPart( indx ).prev
    end if
    
end sub




