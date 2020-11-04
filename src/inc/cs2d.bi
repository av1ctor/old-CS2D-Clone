
''
const CS2D.MAXPLAYERS%				= 16%

const CS2D.BASE.FPS%				= 50%				'' base FPS to calc speeds, etc

const CS2D.MAXTIME%					= 5%*60%
const CS2D.RESTARTTIME%				= 5%

const CS2D.DEFAULT.HEALTH%			= 100%
const CS2D.DEFAULT.POINTS% 			= 2500%
const CS2D.DEFAULT.ENERGY%			= 0%

const CS2D.POINTS.MAX%				= 16000%
const CS2D.POINTS.WINNER%			= 600%
const CS2D.POINTS.DEATH%			= 300%


''
const CS2D.TILEWIDTH% 				= 32%
const CS2D.TILEHEIGHT%				= 32%

''
'' paths
''
const CS2D.MAPPATH$ 				= "maps\"
const CS2D.GFXPATH$ 				= "gfx\"
const CS2D.SPRITESPATH$				= "sprites\"
const CS2D.TILESPATH$ 				= "tiles\"
const CS2D.TILE24BITPATH$			= "24-bit\"
const CS2D.TILESCALEDPATH$			= "scaled\"
const CS2D.BOTSPATH$				= "bots\"
const CS2D.WAYPOINTSPATH$			= "bots\waypoints\"


''
'' entity types
''
const CS2D.ENT.INFOT%				= &h00
const CS2D.ENT.INFOCT%				= &h01
const CS2D.ENT.INFOVIP%				= &h02
const CS2D.ENT.INFOHOSTAGE%			= &h03
const CS2D.ENT.INFORESCUEPOINT%		= &h04
const CS2D.ENT.INFOBOMBSPOT%		= &h05
const CS2D.ENT.INFOESCAPEPOINT%		= &h06

const CS2D.ENT.ENVITEM%				= &h15
const CS2D.ENT.ENVSPRITE%			= &h16
const CS2D.ENT.ENVIMAGE%			= &h1C


''
''
''
const CS2D.MAXWAYCONNECTIONS%		= 7%

const CS2D.MAXBODYPARTS%			= 8%

''
'' tileset types
''
const CS2D.TILE.NORMAL% 			= 0%
const CS2D.TILE.WALL% 				= 1%
const CS2D.TILE.OBSTACLE%			= 2%
const CS2D.TILE.BLOCK%				= 3%

const CS2D.TILE.FLOORDIRT%			= 10%
const CS2D.TILE.FLOORSNOW% 			= 11%
const CS2D.TILE.FLOORSTEP%			= 12%
const CS2D.TILE.FLOORTILE%			= 13%
const CS2D.TILE.FLOORWADE%			= 14%
const CS2D.TILE.FLOORMETAL%			= 15%

const CS2D.TILE.DEADLYNORMAL%		= 50%
const CS2D.TILE.DEADLYEXPLOSION%	= 51%
const CS2D.TILE.DEADLYTOXIC%		= 52%
const CS2D.TILE.DEADLYABYSS%		= 53%

type CS2DTSET
	dc			as long							'' far ptr

	tiles		as integer
	xtiles		as integer
	ytiles		as integer

    tilew		as integer						'' width  (non-scaled)
    tileh		as integer						'' height /

    tilews		as integer						'' width
    tilehs		as integer						'' height
end type


''
'' player types
''
const CS2D.MAXTEAMS%				= 3%

const CS2D.PLAYER.TERRORIST%		= 1%
const CS2D.PLAYER.CTERRORIST%		= 2%

const CS2D.PLAYER.BASET%			= 0%
const CS2D.PLAYER.PHOENIXCON%		= 0%
const CS2D.PLAYER.L337CREW%			= 1%
const CS2D.PLAYER.ARCTICAVENGERS%	= 2%
const CS2D.PLAYER.GUERILLAWARFARE%	= 3%

const CS2D.PLAYER.BASECT%			= 4%
const CS2D.PLAYER.SEALTEAM6%		= 0%
const CS2D.PLAYER.GERMANGS9% 		= 1%
const CS2D.PLAYER.UKSAS% 			= 2%
const CS2D.PLAYER.FRENCHGIGN% 		= 3%

''
const CS2D.PLAYER.FOV% = 90%

''
'' player states
''
const CS2D.PSTAT.WALKING% 		= &h0001%
const CS2D.PSTAT.SPECTATING%	= &h0002%
const CS2D.PSTAT.SHOOTING%		= &h0004%
const CS2D.PSTAT.DEAD%	  		= &h8000%

'' bot stuff
const CS2D.BOTACTION.WALK%		= 0%
const CS2D.BOTACTION.BUYWEAPON%	= 1%
const CS2D.BOTACTION.PLANTBOMB%	= 2%


type CS2DBOT
	action		as integer

	idx			as integer
	pnt			as integer
	nodes		as integer

	maxwalk		as integer
	maxstop		as integer

	pdir		as integer						'' waypoint dir (0=forward)
	ix			as integer						'' ini waypoint x coord
	iy			as integer                      '' /   /        y /
	ex			as integer                      '' end waypoint x coord
	ey			as integer                      '' /   /        y /
end type

type CS2DPLAYER
	name		as string * 16
	id			as long
	state		as integer

	typ			as integer
	team		as integer
	isBot		as integer

	x			as single
	y			as single
	angle		as integer

	xinc		as single
	yinc		as single
	speed		as single

	step		as integer

	onscreen	as integer					'' true or false

	priweapon	as integer
	priammo		as integer
	prirefill	as integer

	secweapon	as integer
	secammo		as integer
	secrefill	as integer

	weapon		as integer					'' current weapon being used
	lastshoot	as long

	reload		as integer

	energy		as integer
	health		as integer
	points		as integer

	ox			as integer					'' origin
	oy			as integer					'' /

	b			as CS2DBOT					'' due no ptrs/unions, all players have to carry bot info
end type

''
'' items list (in a very stupid order)
''
const CS2D.ITEM.USP%				= 1%
const CS2D.ITEM.Glock%				= 2%
const CS2D.ITEM.Deagle%				= 3%
const CS2D.ITEM.P228%				= 4%
const CS2D.ITEM.Elite%				= 5%
const CS2D.ITEM.Fiveseven%			= 6%
const CS2D.ITEM.M3%					= 10%
const CS2D.ITEM.XM1014%				= 11%
const CS2D.ITEM.MP5%				= 20%
const CS2D.ITEM.TMP%				= 21%
const CS2D.ITEM.P90%				= 22%
const CS2D.ITEM.MAC10%				= 23%
const CS2D.ITEM.UMP45%				= 24%
const CS2D.ITEM.AK47%				= 30%
const CS2D.ITEM.SG552%				= 31%
const CS2D.ITEM.M4A1%				= 32%
const CS2D.ITEM.Aug%				= 33%
const CS2D.ITEM.Scout%				= 34%
const CS2D.ITEM.AWP%				= 35%
const CS2D.ITEM.G3SG1%				= 36%
const CS2D.ITEM.SG550%				= 37%
const CS2D.ITEM.M249%				= 40%
const CS2D.ITEM.Laser%				= 45%
const CS2D.ITEM.Flamethrower%		= 46%
const CS2D.ITEM.Knife%				= 50%
const CS2D.ITEM.HE%					= 51%
const CS2D.ITEM.Flash%				= 52%
const CS2D.ITEM.Smoke%				= 53%
const CS2D.ITEM.Flare%				= 54%
const CS2D.ITEM.Bomb%				= 55%
const CS2D.ITEM.DefuseKit%			= 56%
const CS2D.ITEM.Kevlar%				= 57%
const CS2D.ITEM.KevlarHelm%			= 58%
const CS2D.ITEM.Nightvision%		= 59%
const CS2D.ITEM.PlantedBomb%		= 60%		'' org is 100, assuming it won't exist on maps :P

const CS2D.ITEM.PrimaryAmmo%		= 61%
const CS2D.ITEM.SecundaryAmmo%		= 62%

const CS2D.MAXITEMS%				= 63%

const CS2D.ITEM.MAXTIME%			= 60%		'' in seconds

const CS2D.ITEMTYPE.WEAPON%			= 1%
const CS2D.ITEMTYPE.EQUIPAMENT%		= 2%
const CS2D.ITEMTYPE.AMMO%			= 4%

type CS2DITEM
	name		as string * 16
	u			as integer
	price		as integer
	buyer		as integer						'' 0=nobody,1=terr,2=cterr=3=terr/cterr
	typ			as integer						'' 1=weapon, 2=equipament
end type

type CS2DDIWEAPON
	ammo		as integer
	refill		as integer
end type

type CS2DDYNITEM
	id			as integer
	x			as integer
	y			as integer
	a			as integer
	frame		as integer

	onscreen	as integer						'' true or false

	w			as CS2DDIWEAPON

	ln			as integer						'' linked-list node
end type

''
''
''
const CS2D.DEFAULT.PRIWEAPON%		= CS2D.ITEM.USP
const CS2D.DEFAULT.SECWEAPON%		= 0

const CS2D.WEAPON.PRIMARY%			= 1%
const CS2D.WEAPON.SECUNDARY%		= 2%

const CS2D.WEAPON.PRIINI%			= CS2D.ITEM.USP
const CS2D.WEAPON.PRIEND%			= CS2D.ITEM.Fiveseven

const CS2D.WEAPON.SECINI%			= CS2D.ITEM.M3
const CS2D.WEAPON.SECEND%			= CS2D.ITEM.M249

type CS2DWEAPON
	maxdist		as integer						'' max reach distance
	maxframes	as integer						'' max frames to animate
	rad			as integer						'' collision radius
	power		as integer						'' 0=no damage

	maxammo		as integer                      '' maximum ammo
	frmspershoot as integer						'' frames between shoots (0=no delay)
	precision	as single                       '' 0=maximum

	dx			as integer						'' x distance
	dy			as integer                      '' y /
	u			as integer						'' texture col
	ud			as integer						'' weaponsd texture col
end type

''
''
''
type CS2ENV
	xres		as integer
	yres		as integer
	cfmt		as integer
	scale 		as single
	scale8		as integer						'' scale * 256
	scaletiles	as integer						'' TRUE or FALSE
	dist		as integer

	fps			as integer
	frmcnt		as long							'' incrased every frame

	shadmap		as long							'' far ptr
	players		as long							'' /
	legs		as long							'' /
	weapons		as long                         '' /
	fragments	as long							'' /
	smoke		as long							'' /
	blood		as long							'' /
	weaponsd	as long                         '' /
	items		as long                         '' /

	font		as long							'' /
	pointers	as long							'' /
	hudsymbols	as long							'' /
	hudnums		as long							'' /
	hudradar	as long							'' /
end type


''
const CS2D.MISSIONTYPE.DEATHMATCH%		= 1%
const CS2D.MISSIONTYPE.ASSASSINATION% 	= 2%
const CS2D.MISSIONTYPE.HOSTAGERESCUE% 	= 4%
const CS2D.MISSIONTYPE.BOMBDEFUSE% 		= 8%

const CS2D.BOTSKILLS.CHEATER%			= 0%
const CS2D.BOTSKILLS.PROGAMER%			= 2%
const CS2D.BOTSKILLS.NORMAL%			= 4%
const CS2D.BOTSKILLS.NEWBIE%			= 8%

''
''
''
type CS2DMAP
    name		as string * 32

    dofov		as integer						'' true or false

    missions	as integer                      '' all possible missions on this map
    mission		as integer						'' mission selected

    botskills	as integer						'' pro, normal, newbie

    timecnt		as integer
    restartcnt 	as integer
    winner		as integer

    tileset     as string * 32
    xsize       as integer
    ysize       as integer
    background  as string * 32
    xscroll     as integer
    yscroll     as integer
    rcolor		as integer
    gcolor		as integer
    bcolor		as integer
    map         as long							'' far ptr
    entities	as integer

    tinfs		as integer

    ts			as CS2DTSET

	''
	xmax		as integer
	ymax		as integer
	players		as integer
	waypoints	as integer
	waypntconns	as integer

    '' dynamic fields
    xini		as integer
    yini        as integer
    xend		as integer
    yend		as integer
    xdif		as integer
    ydif		as integer
    tx			as integer
    ty        	as integer
end type

''
''
''
const CS2D.MAXENTITIES%				= 192%

const CS2D.MAXENVITEMS%				= CS2D.MAXENTITIES\2
const CS2D.MAXENVSPRITES% 			= CS2D.MAXENTITIES\4
const CS2D.MAXENVIMAGES% 			= CS2D.MAXENTITIES\4
const CS2D.MAXINFOTS%				= CS2D.MAXENTITIES\2
const CS2D.MAXINFOHOSTAGES%			= 6%
const CS2D.MAXINFOBOMBSPOTS%		= 6%

type CS2DENTITY
	title		as string * 4
	typ			as integer
	xpos		as integer
    ypos		as integer

    idx			as integer
end type

'' info_t & info_ct
type CD2DINFOT
	startangle	as integer
end type

'' info_hostage
type CD2DINFOHOSTAGE
	startangle	as integer
	look		as integer
end type

'' info_bombspot
type CD2DINFOBOMBSPOT
	range		as integer
end type

'' env_item
type CD2DENVITEM
	id			as integer
end type

'' env_image
type CD2DENVIMAGE
	xoffset		as integer
	yoffset		as integer
	dc			as long
end type

'' env_sprite
type CD2DENVSPRITE
	xoffset		as integer
	yoffset		as integer
	xsize		as integer
	ysize		as integer
	alpha		as integer
	mode		as integer
	rotspeed	as integer
	rotangle	as integer
	r			as integer
	g			as integer
	b			as integer
	FX			as integer
	blendmode   as integer

	dc			as long
	wdt			as integer
	hgt			as integer
end type

''
''
''
type CS2DSCRMAP
	t			as integer
	a			as integer
end type

''
''
''
const CS2D.MAXWAYPOINTS%		= 256%

type CS2DWAYPOINT
	xpos		as integer
	ypos		as integer
end type

type CS2DWAYCONNECTION
	inip		as integer
	endp		as integer
end type


''
''
''
const CS2D.DRAW.WAYPOINTS%		= 1%
const CS2D.DRAW.STATPARTICLES%	= 2%
const CS2D.DRAW.SHADOWS%		= 4%
const CS2D.DRAW.PLAYERS%		= 8%
const CS2D.DRAW.BULLETS%		= 16%
const CS2D.DRAW.ENTITIES%		= 32%
const CS2D.DRAW.BOTPATHS%		= 64%
const CS2D.DRAW.HUD%			= 128%
const CS2D.DRAW.ITEMS%			= 256%
const CS2D.DRAW.MSGS%			= 512%

''
''
''
const CS2D.MOUSE.GREENPOINTER%	= 0%
const CS2D.MOUSE.REDPOINTER%	= 1%
const CS2D.MOUSE.YELLOWPOINTER%	= 2%
const CS2D.MOUSE.WORKPOINTER%	= 3%

''
''
''
const CS2D.HUD.HEALTH%			= 0%
const CS2D.HUD.SHIELD%			= 1%
const CS2D.HUD.CLOCK%			= 2%
const CS2D.HUD.DEFUSEKIT%		= 3%
const CS2D.HUD.BUYZONE%			= 4%
const CS2D.HUD.TARGET%			= 5%
const CS2D.HUD.UNKNOWN%			= 6%
const CS2D.HUD.POINTS%			= 7%
const CS2D.HUD.EXCLAMATION%		= 8%

const CS2D.HUD.NUMW% 			= 24%
const CS2D.HUD.NUMH% 			= 33%
const CS2D.HUD.SYMBOLW% 		= 32%
const CS2D.HUD.SYMBOLH% 		= 32%

const CS2D.RADAR.MAXDIST% 		= 30%			'' in tiles
const CS2D.RADAR.WDT%			= 100%
const CS2D.RADAR.HGT%			= 100%


''
''
''
const CS2D.BYUMENUCAT.HANDGUN%		= 0%
const CS2D.BYUMENUCAT.SHOTGUN%		= 1%
const CS2D.BYUMENUCAT.SUBMACHINEGUN%= 2%
const CS2D.BYUMENUCAT.RIFLE%		= 3%
const CS2D.BYUMENUCAT.MACHINEGUN%	= 4%
const CS2D.BYUMENUCAT.AMMO%	 		= 5%
const CS2D.BYUMENUCAT.EQUIPAMENT%	= 6%

const CS2D.BUYMENU.CATS%			= 7%

const CS2D.TEAMMENU.TEAMS% 			= 2%

''
''
''
const CS2D.MSG.FILE$				= "msgs.dat"

const CS2D.MSG.MAXLEN%	            = 64%
const CS2D.MSG.MAXTIME%				= 3000%		'' in ms

const CS2D.MSG.KILLEDBY%			= 0%
const CS2D.MSG.TWIN%				= 1%
const CS2D.MSG.CTWIN%				= 2%
const CS2D.MSG.DRAW%				= 3%
const CS2D.MSG.VIPASSASSINATED%		= 4%
const CS2D.MSG.VIPESCAPED%			= 5%
const CS2D.MSG.NOTINBUYZONE%		= 6%

const CS2D.MAXFMSGS% 				= 32%
const CS2D.MAXAMSGS%				= 3%
const CS2D.MAXPMSGS%				= 8%


''
'' prototypes
''

'' load
declare function 	cs2dLoadMap% 		( mapName as string, cm as CS2DMAP, ti() as integer, _
										  byval dofov as integer )

declare function 	cs2dLoadResources%	( )

declare function 	cs2dLoadTileset%	( cm as CS2DMAP, sm() as CS2DSCRMAP )

declare function 	cs2dLoadWaypoints%	( cm as CS2DMAP )


'' init
declare function 	cs2dInit%			( byval xres as integer, byval yres as integer, _
										  byval cfmt as integer, byval scale as single, _
										  byval fps as integer )

declare sub 		cs2dPlayerInit		( )

declare sub 		cs2dItemInit		( )

declare sub 		cs2dHudInit			( )

declare sub 		cs2dStatParticleInit( )

declare sub 		cs2dBulletInit		( )

declare sub 		cs2dEntityInit		( )

declare sub 		cs2dMenuInit		( )

declare sub 		cs2dMsgInit			( )


'' end
declare sub 		cs2dEnd				( )

declare sub 		cs2dPlayerEnd		( )

declare sub 		cs2dItemEnd			( )

declare sub 		cs2dHudEnd			( )

declare sub 		cs2dStatParticleEnd	( )

declare sub 		cs2dBulletEnd		( )

declare sub 		cs2dEntityEnd		( )

declare sub 		cs2dMenuEnd			( )

declare sub 		cs2dMsgEnd			( )


'' start
declare sub 		cs2dStart			( cm as CS2DMAP )

declare sub 		cs2dItemStart 		( cm as CS2DMAP )

declare sub 		cs2dPlayerStart 	( cm as CS2DMAP )

declare sub 		cs2dBotStart 		( cm as CS2DMAP )


'' restart
declare sub 		cs2dRestart			( cm as CS2DMAP, byval winner as integer )

declare sub 		cs2dItemRestart		( cm as CS2DMAP )

declare sub 		cs2dPlayerRestart 	( cm as CS2DMAP, byval winner as integer )

declare sub 		cs2dBotRestart 		( cm as CS2DMAP )


'' update
declare sub 		cs2dUpdate			( cm as CS2DMAP, ti() as integer )

declare sub 		cs2dMsgUpdate		( )

declare sub 		cs2dItemUpdateAll	( cm as CS2DMAP )

declare sub 		cs2dStatParticleUpdateAll( cm as CS2DMAP )

declare sub 		cs2dBulletUpdateAll	( cm as CS2DMAP, ti() as integer )

declare sub 		cs2dPlayerUpdateAll	( cm as CS2DMAP, ti() as integer )

declare sub 		cs2dBotUpdateAll	( cm as CS2DMAP, ti() as integer )


'' draw
declare sub 		cs2dDraw			( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, _
										  ti() as integer, byval p as integer, _
										  byval mode as integer )

declare sub 		cs2dMsgDraw			( byval dst as long )

declare sub 		cs2dDrawTiles		( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP )

declare sub 		cs2dDrawItems		( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP )

declare sub 		cs2dDrawPlayers		( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, byval p as integer )

declare sub 		cs2dDrawEntities	( byval dst as long, cm as CS2DMAP )

declare sub 		cs2dDrawShadows		( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, _
										  ti() as integer )

declare sub 		cs2dDrawBullets		( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP )

declare sub 		cs2dDrawWaypoints	( byval dst as long, cm as CS2DMAP)

declare sub 		cs2dDrawBotPath		( byval dst as long, cm as CS2DMAP )

declare sub 		cs2dDrawStatParticles( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP )

declare sub 		cs2dHudDraw			( byval dst as long, cm as CS2DMAP, byval p as integer )

declare sub 		cs2dMakeScreenMap	( cm as CS2DMAP, sm() as CS2DSCRMAP, byval p as integer )

declare sub 		cs2dMakeFOVMap		( cm as CS2DMAP, sm() as CS2DSCRMAP, ti() as integer, byval p as integer )

declare sub 		cs2dClearScreen		( byval dst as long, cm as CS2DMAP )


'' select
declare sub 		cs2dSelectMission	( cm as CS2DMAP, byval mission as integer )

declare sub 		cs2dSelectBotSkills	( cm as CS2DMAP, byval skills as integer )



'' bot
declare sub 		cs2dBotWalk			( cm as CS2DMAP, ti() as integer, byval p as integer )

declare function	cs2dBotAdd%			( cm as CS2DMAP, byval typ as integer, byval team as integer )


'' player
declare function 	cs2dPlayerFindStart%( cm as CS2DMAP, byval typ as integer, _
										  sx as single, sy as single, angle as integer )

declare function	cs2dPlayerAdd%		( cm as CS2DMAP, pname as string, _
										  byval typ as integer, byval team as integer )

declare function	cs2dPlayerNew%		( cm as CS2DMAP, pname as string, _
					 					  byval typ as integer, byval team as integer, _
					 					  byval isbot as integer )

declare function	cs2dPlayerUpdate%	( cm as CS2DMAP, ti() as integer, byval p as integer, _
										  byval xinc as single, byval yinc as single, byval angle as integer )

declare function	cs2dPlayerMove%		( cm as CS2DMAP, ti() as integer, byval p as integer )

declare sub 		cs2dPlayerShoot 	( cm as CS2DMAP, ti() as integer, byval p as integer )

declare sub 		cs2dPlayerHit		( cm as CS2DMAP, byval p as integer, byval damage as integer, _
										  byval sid as long, byval xinc as single, byval yinc as single )

declare sub 		cs2dPlayerDropWeapon( cm as CS2DMAP, byval p as integer )

declare sub 		cs2dPlayerKill		( cm as CS2DMAP, byval p as integer )

declare function 	cs2dPlayerCanBuy%	( cm as CS2DMAP, byval p as integer )

declare sub 		cs2dPlayerBuyItem	( cm as CS2DMAP, byval p as integer, byval i as integer )

declare sub 		cs2dPlayerSelWeapon	( byval p as integer, byval w as integer )

declare sub 		cs2dPlayerSelTeam	( cm as CS2DMAP, p as integer, byval typ as integer, byval team as integer )

declare function 	cs2dPlayerIsOverOnScreen%( cm as CS2DMAP, byval x as integer, byval y as integer )

'' bullet
declare sub 		cs2dBulletDel		( byval b as integer )

declare sub 		cs2dBulletAdd		( cm as CS2DMAP, ti() as integer, _
				   						  byval weapon as integer, byval x as single, byval y as single, _
				   						  byval xinc as single, byval yinc as single, _
				   						  byval angle as integer, byval pid as long )


'' static particle
declare sub 		cs2dStatParticleAdd	( byval dc as long, _
						 				  byval x as integer, byval y as integer, byval scale as integer, _
				   		 				  byval r as integer, byval g as integer, byval b as integer, _
				   		 				  byval a as integer, _
				   		 				  byval frames as integer, _
				   		 				  byval mode as integer )

declare sub 		cs2dStatParticleAddEx( byval dc as long, byval u as integer, byval v as integer, _
						   				  byval w as integer, byval h as integer, _
						   				  byval x as integer, byval y as integer, byval scale as integer, _
				   		   				  byval r as integer, byval g as integer, byval b as integer, _
				   		   				  byval a as integer, _
				   		   				  byval frames as integer, _
				   		   				  byval mode as integer )

'' item
declare sub 		cs2dItemDel			( byval i as integer )

declare function	cs2dItemAdd%		( byval x as integer, byval y as integer, byval angle as integer, _
										  byval id as integer )

declare function	cs2dItemAddEx%		( byval x as integer, byval y as integer, byval angle as integer, _
										  byval id as integer, byval droppedby as integer )

declare function 	cs2dItemIsOver%		( cm as CS2DMAP, byval x as integer, byval y as integer )

declare function 	cs2dItemIsOverOnScreen%( cm as CS2DMAP, byval x as integer, byval y as integer )

'' msgs
declare sub 		cs2dMsgAddAlert		( byval msg as integer )

declare sub 		cs2dMsgAddPublic	( byval msg as integer, byval fromp as integer, byval top as integer )


'' misc
declare sub 		cs2dFontPrint		( byval dst as long, byval x as integer, y as integer, _
				   						  byval r as integer, byval g as integer, byval b as integer, _
				   						  text as string )

declare function 	cs2dFontWidth%		( text as string )

declare sub 		cs2dMouseShow		( byval dst as long, byval x as integer, byval y as integer, _
										  byval pointer as integer, cm as CS2DMAP, byval p as integer )

declare function 	cs2dGetAngle% 		( byval ix as integer, byval iy as integer, _
										  byval ex as integer, byval ey as integer )

declare sub 		cs2dDrawBuyMenu		( byval dst as long, byval cat as integer, _
										  byval x as integer, byval y as integer, _
										  byval p as integer )

declare function 	cs2dBuyMenuGetItem%	( byval cat as integer, byval prod as integer, _
										  byval p as integer )

declare sub 		cs2dDrawTeamMenu	( byval dst as long, byval typ as integer, _
										  byval x as integer, byval y as integer )

declare function 	cs2dTeamMenuSel%	( byval typ as integer, byval team as integer )
