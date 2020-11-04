const cs2d.part.ages        =  1%
const cs2d.part.blend       =  2%
const cs2d.part.blendt      =  4%

const cs2d.part.free        = -1%
const cs2d.part.error       = -1%


type cs2dvec_t
    x       as single
    y       as single
end type


type cs2dpart_t
    used    as integer

    pos     as cs2dvec_t
    dir     as cs2dvec_t

    age     as integer
    maxage  as integer

    hDC     as long
    alpha   as single
    mode    as integer

    next    as integer
    prev    as integer
end type


'' :::::::::::::::::::::::
''  Public routines
'' :::::::::::::::::::::::

declare sub         cs2dPartInit        ( maxparticles as integer )
declare sub         cs2dPartEnd         ( )

declare function    cs2dPartNew%        ( posx as single, _
                                          posy as single, _
                                          dirx as single, _
                                          diry as single, _
                                          maxage as integer, _
                                          mode as integer, _
                                          hDC as long )
declare sub         cs2dPartDel         ( pindx as integer )

declare sub         cs2dPartUpdate      ( )
declare sub         cs2dPartDraw        ( hDstDC as long )

declare function    cs2dPartGetMode%    ( pindx as integer )
declare sub         cs2dPartSetMode     ( pindx as integer, _
                                          mode as integer )                                          
declare function    cs2dPartGetAge%     ( pindx as integer )
declare sub         cs2dPartSetAge      ( pindx as integer, _
                                          age as integer )
declare function    cs2dPartGetMaxAge%  ( pindx as integer )
declare sub         cs2dPartSetMaxAge   ( pindx as integer, _
                                          maxage as integer )
declare function    cs2dPartGetAlpha%   ( pindx as integer )
declare sub         cs2dPartSetAlpha    ( pindx as integer, _
                                          alpha as integer )
declare sub         cs2dPartGetPos      ( posx as integer, _
                                          posy as integer, _
                                          pindx as integer )
declare sub         cs2dPartSetPos      ( pindx as integer, _
                                          posx as integer, _
                                          posy as integer )
declare sub         cs2dPartGetDir      ( dirx as integer, _
                                          diry as integer, _
                                          pindx as integer )
declare sub         cs2dPartSetDir      ( pindx as integer, _
                                          dirx as integer, _
                                          diry as integer )
declare function    cs2dPartGetDC&      ( pindx as integer )
declare sub         cs2dPartSetDC       ( pindx as integer, _
                                          hDC as long )