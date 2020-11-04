# MED tags file V1.2,C:\prg\code\BAS\cd2d\src\demo.mpj
aStarInit	C:\prg\code\BAS\cd2d\src\src\astar.bas	41	sub aStarInit( byval nodes as integer )
aStarEnd	C:\prg\code\BAS\cd2d\src\src\astar.bas	54	sub aStarEnd
aStarClear	C:\prg\code\BAS\cd2d\src\src\astar.bas	67	sub aStarClear
fillPath%	C:\prg\code\BAS\cd2d\src\src\astar.bas	77	Function fillPath% ( byval s as integer, path() as integer, byval idx as integer )
aStarFindPath%	C:\prg\code\BAS\cd2d\src\src\astar.bas	92	Function aStarFindPath%( byval src as integer, byval dst as integer, _
cs2dBotStart	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	38	sub cs2dBotStart ( cm as CS2DMAP ) static
cs2dBotRestart	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	130	sub cs2dBotRestart( cm as CS2DMAP )
cs2dBotAdd%	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	155	function cs2dBotAdd%( cm as CS2DMAP, byval typ as integer, byval team as integer )
cs2dBotFindPoint	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	179	sub cs2dBotFindPoint ( cm as CS2DMAP, x as integer, y as integer, byval typ as integer, _
cs2dBotFindWaypoint%	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	245	function cs2dBotFindWaypoint%( cm as CS2DMAP, byval px as integer, byval py as integer ) static
cs2dBotChangePath	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	270	function cs2dBotChangePath( bot as CS2DPLAYER ) static
cs2dBotNearestPath	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	298	sub cs2dBotNearestPath( cm as CS2DMAP, bot as CS2DPLAYER, xpos as integer, ypos as integer ) static
cs2dBotNextPath%	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	338	function cs2dBotNextPath%( cm as CS2DMAP, byval pdir as integer, bot as CS2DPLAYER, _
recalcStep	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	372	sub recalcStep ( player as CS2DPLAYER, _
cs2dBotColliding%	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	387	function cs2dBotColliding% ( cm as CS2DMAP, byval p as integer, _
cs2dBotReverse	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	407	sub cs2dBotReverse( player as CS2DPLAYER, ix as integer, iy as integer, ex as integer, ey as integer )
cs2dBotWalk	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	422	sub cs2dBotWalk( cm as CS2DMAP, ti() as integer, byval p as integer )
cs2dPlayerVisible%	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	536	function cs2dPlayerVisible%( cm as CS2DMAP, ti() as integer, _
cs2dBotFindClosestEnemy%	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	585	function cs2dBotFindClosestEnemy% ( cm as CS2DMAP, ti() as integer, byval p as integer ) static
cs2dBotBuy	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	656	sub cs2dBotBuy( cm as CS2DMAP, byval p as integer )
cs2dBotUpdateAll	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	705	sub cs2dBotUpdateAll( cm as CS2DMAP, ti() as integer )
u_calcDistance%	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	796	Function u_calcDistance%( byval src as integer, byval dst as integer ) Static
u_calcCost%	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	823	function u_calcCost%( byval src as integer, byval dst as integer ) static
u_findSuccessors	C:\prg\code\BAS\cd2d\src\src\cs2dbots.bas	834	Function u_findSuccessors( byval src as integer, tTB() as integer ) static
cs2dClearScreen	C:\prg\code\BAS\cd2d\src\src\cs2ddraw.bas	22	sub cs2dClearScreen( byval dst as long, cm as CS2DMAP )
cs2dMakeScreenMap	C:\prg\code\BAS\cd2d\src\src\cs2ddraw.bas	45	sub cs2dMakeScreenMap( cm as CS2DMAP, sm() as CS2DSCRMAP, byval p as integer )
cs2dMakeFOVMap	C:\prg\code\BAS\cd2d\src\src\cs2ddraw.bas	139	sub cs2dMakeFOVMap( cm as CS2DMAP, sm() as CS2DSCRMAP, ti() as integer, byval p as integer ) static
cs2dDrawTiles	C:\prg\code\BAS\cd2d\src\src\cs2ddraw.bas	190	sub cs2dDrawTiles( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP ) static
cs2dDrawShadows	C:\prg\code\BAS\cd2d\src\src\cs2ddraw.bas	255	sub cs2dDrawShadows( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, ti() as integer )
cs2dDrawPlayers	C:\prg\code\BAS\cd2d\src\src\cs2ddraw.bas	346	sub cs2dDrawPlayers( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, byval p as integer ) static
drawENVSPRITE	C:\prg\code\BAS\cd2d\src\src\cs2ddraw.bas	436	sub drawENVSPRITE( byval dst as long, byval x as integer, byval y as integer, byval e as integer ) static
cs2dDrawEntities	C:\prg\code\BAS\cd2d\src\src\cs2ddraw.bas	531	sub cs2dDrawEntities( byval dst as long, cm as CS2DMAP )
cs2dDrawWaypoints	C:\prg\code\BAS\cd2d\src\src\cs2ddraw.bas	567	sub cs2dDrawWaypoints( byval dst as long, cm as CS2DMAP )
cs2dDrawBotPath	C:\prg\code\BAS\cd2d\src\src\cs2ddraw.bas	603	sub cs2dDrawBotPath( byval dst as long, cm as CS2DMAP )
cs2dDraw	C:\prg\code\BAS\cd2d\src\src\cs2ddraw.bas	660	sub cs2dDraw( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, ti() as integer, _
cs2dEntityInit	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	64	sub cs2dEntityInit
cs2dEntityEnd	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	87	sub cs2dEntityEnd
skipEntityBody	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	115	sub skipEntityBody( bf as BFILE )
newENVITEM	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	125	function newENVITEM( bf as BFILE )
newINFOBOMBSPOT	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	150	function newINFOBOMBSPOT( bf as BFILE )
newINFOHOSTAGE	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	175	function newINFOHOSTAGE( bf as BFILE )
newINFOT	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	204	function newINFOT( bf as BFILE )
imageCache&	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	228	function imageCache&( filename as string ) static
newENVIMAGE%	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	262	function newENVIMAGE%( bf as BFILE )
spriteCache&	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	297	function spriteCache&( filename as string ) static
newENVSPRITE%	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	333	function newENVSPRITE%( bf as BFILE )
readEntityBody%	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	405	function readEntityBody%( bf as BFILE, typ as integer )
cs2dEntityLoadAll	C:\prg\code\BAS\cd2d\src\src\cs2dents.bas	429	sub cs2dEntityLoadAll( bf as BFILE, byval entities as integer )
iniFont	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	24	sub iniFont
endFont	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	49	sub endFont
fontCalcWidth	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	54	sub fontCalcWidth( byval fontdc as long )
cs2dHudInit	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	99	sub cs2dHudInit
cs2dHudEnd	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	143	sub cs2dHudEnd
drawNum	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	150	sub drawNum( byval dst as long, byval x as integer, byval y as integer, byval mask as integer, _
drawTime	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	174	sub drawTime( byval dst as long, byval x as integer, byval y as integer, byval mask as integer, _
drawRadar	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	197	sub drawRadar( byval dst as long, byval ox as integer, byval oy as integer, _
cs2dHudDraw	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	246	sub cs2dHudDraw( byval dst as long, cm as CS2DMAP, byval p as integer )
cs2dFontPrint	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	319	sub cs2dFontPrint( byval dst as long, byval x as integer, y as integer, _
cs2dFontWidth%	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	361	function cs2dFontWidth%( text as string ) static
drawMouseOver	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	395	sub drawMouseOver( byval dst as long, byval mx as integer, byval my as integer, cm as CS2DMAP, byval p as integer )
cs2dMouseShow	C:\prg\code\BAS\cd2d\src\src\cs2dhud.bas	447	sub cs2dMouseShow( byval dst as long, byval x as integer, byval y as integer, byval pointer as integer, _
readItems	C:\prg\code\BAS\cd2d\src\src\cs2ditem.bas	111	sub readItems
cs2dItemInit	C:\prg\code\BAS\cd2d\src\src\cs2ditem.bas	133	sub cs2dItemInit
cs2ditemEnd	C:\prg\code\BAS\cd2d\src\src\cs2ditem.bas	158	sub cs2ditemEnd
cs2dItemStart	C:\prg\code\BAS\cd2d\src\src\cs2ditem.bas	167	sub cs2dItemStart( cm as CS2DMAP )
newItem%	C:\prg\code\BAS\cd2d\src\src\cs2ditem.bas	211	function newItem% static
cs2dItemAdd%	C:\prg\code\BAS\cd2d\src\src\cs2ditem.bas	241	function cs2dItemAdd%( byval x as integer, byval y as integer, byval angle as integer, byval id as integer )
cs2dItemDel	C:\prg\code\BAS\cd2d\src\src\cs2ditem.bas	263	sub cs2dItemDel( byval i as integer )
cs2dItemUpdateAll	C:\prg\code\BAS\cd2d\src\src\cs2ditem.bas	276	sub cs2dItemUpdateAll( cm as CS2DMAP ) static
cs2dItemIsOver%	C:\prg\code\BAS\cd2d\src\src\cs2ditem.bas	317	function cs2dItemIsOver%( cm as CS2DMAP, byval x as integer, byval y as integer )
cs2dItemIsOverOnScreen%	C:\prg\code\BAS\cd2d\src\src\cs2ditem.bas	342	function cs2dItemIsOverOnScreen%( cm as CS2DMAP, byval x as integer, byval y as integer )
cs2dDrawItems	C:\prg\code\BAS\cd2d\src\src\cs2ditem.bas	373	sub cs2dDrawItems( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP ) static
drawItem	C:\prg\code\BAS\cd2d\src\src\cs2ditem.bas	389	sub drawItem( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, it as CS2DDYNITEM ) static
cs2dLoadMap%	C:\prg\code\BAS\cd2d\src\src\cs2dload.bas	49	function cs2dLoadMap%( mapName as string, cm as CS2DMAP, ti() as integer, byval dofov as integer )
cs2dGetMissionType%	C:\prg\code\BAS\cd2d\src\src\cs2dload.bas	156	function cs2dGetMissionType%( cm as CS2DMAP )
cs2dLoadResources%	C:\prg\code\BAS\cd2d\src\src\cs2dload.bas	182	function cs2dLoadResources%
cs2dLoadTileset%	C:\prg\code\BAS\cd2d\src\src\cs2dload.bas	277	function cs2dLoadTileset%( cm as CS2DMAP, sm() as CS2DSCRMAP )
cs2dLoadWaypoints%	C:\prg\code\BAS\cd2d\src\src\cs2dload.bas	336	function cs2dLoadWaypoints%( cm as CS2DMAP )
col2row	C:\prg\code\BAS\cd2d\src\src\cs2dload.bas	384	sub col2row( byval map as long, byval cols as integer, byval rows as integer )
cs2dInit%	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	21	function cs2dInit%( byval xres as integer, byval yres as integer, byval cfmt as integer, byval scale as single, byval fps as integer )
cs2dEnd	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	70	sub cs2dEnd
cs2dStart	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	99	sub cs2dStart( cm as CS2DMAP )
cs2dRestart	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	118	sub cs2dRestart( cm as CS2DMAP, byval winner as integer )
cs2dCheck	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	134	sub cs2dCheck( cm as CS2DMAP )
cs2dUpdate	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	199	sub cs2dUpdate( cm as CS2DMAP, ti() as integer )
cs2dSelectMission	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	255	sub cs2dSelectMission( cm as CS2DMAP, byval mission as integer )
cs2dSelectBotSkills	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	273	sub cs2dSelectBotSkills( cm as CS2DMAP, byval skills as integer )
getCRLFString$	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	290	function getCRLFString$( bf as BFILE, byval maxsize as integer ) static
cs2dRotateVector	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	328	sub cs2dRotateVector ( byval angle as integer, x as single, y as single, byval scale as single ) static
cs2dGetAngle%	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	344	function cs2dGetAngle% ( byval ix as integer, byval iy as integer, byval ex as integer, byval ey as integer ) static
cs2dCheckCollision%	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	378	function cs2dCheckCollision%( byval x1 as single, byval y1 as single, byval r1 as single, _
cs2dCalcStep&	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	398	function cs2dCalcStep& ( byval x1 as integer, byval y1 as integer, _
cs2dPointInsideTriangle%	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	439	function cs2dPointInsideTriangle%( byval x as integer, byval y as integer, _
cs2dCalcFovTriangle	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	461	sub cs2dCalcFovTriangle( byval fov as integer, byval dist as integer, _
removePath$	C:\prg\code\BAS\cd2d\src\src\cs2dmain.bas	496	function removePath$( filename as string )
buyMenuInit	C:\prg\code\BAS\cd2d\src\src\cs2dmenu.bas	56	sub buyMenuInit
teamMenuInit	C:\prg\code\BAS\cd2d\src\src\cs2dmenu.bas	73	sub teamMenuInit
cs2dMenuInit	C:\prg\code\BAS\cd2d\src\src\cs2dmenu.bas	92	sub cs2dMenuInit
buyMenuEnd	C:\prg\code\BAS\cd2d\src\src\cs2dmenu.bas	101	sub buyMenuEnd
teamMenuEnd	C:\prg\code\BAS\cd2d\src\src\cs2dmenu.bas	108	sub teamMenuEnd
cs2dMenuEnd	C:\prg\code\BAS\cd2d\src\src\cs2dmenu.bas	115	sub cs2dMenuEnd
cs2dDrawBuyMenu	C:\prg\code\BAS\cd2d\src\src\cs2dmenu.bas	125	sub cs2dDrawBuyMenu( byval dst as long, byval cat as integer, byval x as integer, byval y as integer, _
cs2dBuyMenuGetItem%	C:\prg\code\BAS\cd2d\src\src\cs2dmenu.bas	178	function cs2dBuyMenuGetItem%( byval cat as integer, byval prod as integer, byval p as integer )
cs2dDrawTeamMenu	C:\prg\code\BAS\cd2d\src\src\cs2dmenu.bas	199	sub cs2dDrawTeamMenu( byval dst as long, byval typ as integer, byval x as integer, byval y as integer )
cs2dTeamMenuSel%	C:\prg\code\BAS\cd2d\src\src\cs2dmenu.bas	243	function cs2dTeamMenuSel%( byval typ as integer, byval team as integer )
readMsgs	C:\prg\code\BAS\cd2d\src\src\cs2dmsgs.bas	45	sub readMsgs
cs2dMsgInit	C:\prg\code\BAS\cd2d\src\src\cs2dmsgs.bas	93	sub cs2dMsgInit
cs2dMsgEnd	C:\prg\code\BAS\cd2d\src\src\cs2dmsgs.bas	125	sub cs2dMsgEnd
newAMsg%	C:\prg\code\BAS\cd2d\src\src\cs2dmsgs.bas	138	function newAMsg%
cs2dMsgAddAlert	C:\prg\code\BAS\cd2d\src\src\cs2dmsgs.bas	148	sub cs2dMsgAddAlert( byval msg as integer )
newPMsg%	C:\prg\code\BAS\cd2d\src\src\cs2dmsgs.bas	170	function newPMsg%
cs2dMsgAddPublic	C:\prg\code\BAS\cd2d\src\src\cs2dmsgs.bas	180	sub cs2dMsgAddPublic( byval msg as integer, byval fromp as integer, byval top as integer )
cs2dMsgUpdate	C:\prg\code\BAS\cd2d\src\src\cs2dmsgs.bas	204	sub cs2dMsgUpdate
cs2dMsgDraw	C:\prg\code\BAS\cd2d\src\src\cs2dmsgs.bas	228	sub cs2dMsgDraw( byval dst as long )
cs2dPartInit	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	41	sub cs2dPartInit ( maxparticles as integer )
cs2dPartEnd	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	87	sub cs2dPartEnd
cs2dPartNew%	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	119	function cs2dPartNew% ( posx as single, _
cs2dPartDel	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	178	sub cs2dPartDel ( pindx as integer )
cs2dPartUpdate	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	202	sub cs2dPartUpdate
cs2dPartDraw	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	256	sub cs2dPartDraw ( hDstDC as long )
cs2dPartGetMode%	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	301	function cs2dPartGetMode% ( pindx as integer )
cs2dPartSetMode	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	313	sub cs2dPartSetMode ( pindx as integer, _
cs2dPartGetAge%	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	327	function cs2dPartGetAge% ( pindx as integer )
cs2dPartSetAge	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	340	sub cs2dPartSetAge ( pindx as integer, _
cs2dPartGetMaxAge%	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	354	function cs2dPartGetMaxAge% ( pindx as integer )
cs2dPartSetMaxAge	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	367	sub cs2dPartSetMaxAge ( pindx as integer, _
cs2dPartGetAlpha%	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	380	function cs2dPartGetAlpha% ( pindx as integer )
cs2dPartSetAlpha	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	393	sub cs2dPartSetAlpha ( pindx as integer, _
cs2dPartGetPos	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	407	sub cs2dPartGetPos ( posx as integer, _
cs2dPartSetPos	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	423	sub cs2dPartSetPos ( pindx as integer, _
cs2dPartGetDir	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	439	sub cs2dPartGetDir ( dirx as integer, _
cs2dPartSetDir	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	455	sub cs2dPartSetDir ( pindx as integer, _ 
cs2dPartGetDC&	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	471	function cs2dPartGetDC& ( pindx as integer )
cs2dPartSetDC	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	484	sub cs2dPartSetDC ( pindx as integer, _
int_LinkListAdd	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	504	sub int_LinkListAdd ( indx as integer, _
int_LinkListDel	C:\prg\code\BAS\cd2d\src\src\cs2dpart.bas	529	sub int_LinkListDel ( indx as integer, _
cs2dPlayerInit	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	28	sub cs2dPlayerInit
cs2dPlayerEnd	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	35	sub cs2dPlayerEnd
cs2dPlayerFindStart%	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	42	function cs2dPlayerFindStart% ( cm as CS2DMAP, byval typ as integer, _
setupWeapons	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	84	sub setupWeapons( player as CS2DPLAYER )
cs2dPlayerStart	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	122	sub cs2dPlayerStart ( cm as CS2DMAP )
cs2dPlayerRestart	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	161	sub cs2dPlayerRestart ( cm as CS2DMAP, byval winner as integer )
cs2dPlayerNew%	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	179	function cs2dPlayerNew%( cm as CS2DMAP, pname as string, _
cs2dPlayerAdd%	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	220	function cs2dPlayerAdd% ( cm as CS2DMAP, pname as string, byval typ as integer, byval team as integer )
cs2dPlayerMoveHorz%	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	233	function cs2dPlayerMoveHorz%( cm as CS2DMAP, ti() as integer, byval px as single, byval py as single, _
cs2dPlayerMoveVert%	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	270	function cs2dPlayerMoveVert%( cm as CS2DMAP, ti() as integer, byval px as single, byval py as single, _
cs2dPlayerMove%	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	308	function cs2dPlayerMove%( cm as CS2DMAP, ti() as integer, byval p as integer ) static
cs2dPlayerUpdate%	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	366	function cs2dPlayerUpdate%( cm as CS2DMAP, ti() as integer, byval p as integer, _
cs2dGetPlayerByID%	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	395	function cs2dGetPlayerByID% ( cm as CS2DMAP, byval id as long ) static
cs2dPlayerKill	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	409	sub cs2dPlayerKill( cm as CS2DMAP, byval p as integer )
cs2dPlayerHit	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	440	sub cs2dPlayerHit( cm as CS2DMAP, byval p as integer, _
cs2dPlayerDropWeapon	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	504	sub cs2dPlayerDropWeapon( cm as CS2DMAP, byval p as integer )
cs2dPlayerShoot	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	542	sub cs2dPlayerShoot ( cm as CS2DMAP, ti() as integer, byval p as integer )
cs2dPlayerPickup	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	612	sub cs2dPlayerPickup( cm as CS2DMAP, byval p as integer, byval item as integer )
cs2dPlayerUpdateAll	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	655	sub cs2dPlayerUpdateAll( cm as CS2DMAP, ti() as integer ) static
cs2dPlayerCanBuy%	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	728	function cs2dPlayerCanBuy%( cm as CS2DMAP, byval p as integer )
cs2dPlayerBuyItem	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	750	sub cs2dPlayerBuyItem( cm as CS2DMAP, byval p as integer, byval i as integer )
cs2dPlayerSelWeapon	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	820	sub cs2dPlayerSelWeapon( byval p as integer, byval w as integer )
cs2dPlayerSelTeam	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	827	sub cs2dPlayerSelTeam( cm as CS2DMAP, p as integer, byval typ as integer, byval team as integer )
cs2dPlayerIsOverOnScreen%	C:\prg\code\BAS\cd2d\src\src\cs2dplay.bas	864	function cs2dPlayerIsOverOnScreen%( cm as CS2DMAP, byval x as integer, byval y as integer )
cs2dStatParticleInit	C:\prg\code\BAS\cd2d\src\src\cs2dsttp.bas	57	sub cs2dStatParticleInit
cs2dStatParticleEnd	C:\prg\code\BAS\cd2d\src\src\cs2dsttp.bas	71	sub cs2dStatParticleEnd
newStatParticle%	C:\prg\code\BAS\cd2d\src\src\cs2dsttp.bas	80	function newStatParticle% static
cs2dStatParticleAdd	C:\prg\code\BAS\cd2d\src\src\cs2dsttp.bas	106	sub cs2dStatParticleAdd( byval dc as long, _
cs2dStatParticleAddEx	C:\prg\code\BAS\cd2d\src\src\cs2dsttp.bas	136	sub cs2dStatParticleAddEx( byval dc as long, byval u as integer, byval v as integer, _
cs2dStatParticleUpdateAll	C:\prg\code\BAS\cd2d\src\src\cs2dsttp.bas	171	sub cs2dStatParticleUpdateAll( cm as CS2DMAP ) static
cs2dDrawStatParticles	C:\prg\code\BAS\cd2d\src\src\cs2dsttp.bas	211	sub cs2dDrawStatParticles( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP ) static
drawStatParticle	C:\prg\code\BAS\cd2d\src\src\cs2dsttp.bas	225	sub drawStatParticle( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, sp as CS2DSTATPARTICLE ) static
readWeapons	C:\prg\code\BAS\cd2d\src\src\cs2dwepn.bas	102	sub readWeapons
cs2dBulletInit	C:\prg\code\BAS\cd2d\src\src\cs2dwepn.bas	132	sub cs2dBulletInit
cs2dBulletEnd	C:\prg\code\BAS\cd2d\src\src\cs2dwepn.bas	151	sub cs2dBulletEnd
cs2dBulletCheckHit%	C:\prg\code\BAS\cd2d\src\src\cs2dwepn.bas	167	function cs2dBulletCheckHit%( cm as CS2DMAP, byval from as long, _
cs2dBulletCalcTragect	C:\prg\code\BAS\cd2d\src\src\cs2dwepn.bas	190	sub cs2dBulletCalcTragect( cm as CS2DMAP, ti() as integer, byval b as integer, _
cs2dBulletAdd	C:\prg\code\BAS\cd2d\src\src\cs2dwepn.bas	268	sub cs2dBulletAdd( cm as CS2DMAP, ti() as integer,  _
cs2dBulletUpdateAll	C:\prg\code\BAS\cd2d\src\src\cs2dwepn.bas	305	sub cs2dBulletUpdateAll( cm as CS2DMAP, ti() as integer ) static
cs2dDrawBullets	C:\prg\code\BAS\cd2d\src\src\cs2dwepn.bas	326	sub cs2dDrawBullets( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP )
drawBullet	C:\prg\code\BAS\cd2d\src\src\cs2dwepn.bas	338	sub drawBullet( byval dst as long, cm as CS2DMAP, sm() as CS2DSCRMAP, byval b as integer ) static
showusage	C:\prg\code\BAS\cd2d\src\src\demo.bas	71	sub showusage
showerror	C:\prg\code\BAS\cd2d\src\src\demo.bas	76	sub showerror( msg as string )
main	C:\prg\code\BAS\cd2d\src\src\demo.bas	82	sub main( cmd as string )
gamestart	C:\prg\code\BAS\cd2d\src\src\demo.bas	103	function gamestart( map as string )
gamefinish	C:\prg\code\BAS\cd2d\src\src\demo.bas	213	sub gamefinish
flipBackbuffer	C:\prg\code\BAS\cd2d\src\src\demo.bas	226	sub flipBackbuffer
saveScreenShot	C:\prg\code\BAS\cd2d\src\src\demo.bas	248	sub saveScreenShot
toggleBuyMenu	C:\prg\code\BAS\cd2d\src\src\demo.bas	257	sub toggleBuyMenu( byval p as integer )
toggleTeamMenu	C:\prg\code\BAS\cd2d\src\src\demo.bas	270	sub toggleTeamMenu
selectBuyCat	C:\prg\code\BAS\cd2d\src\src\demo.bas	283	sub selectBuyCat( byval p as integer )
selectTeam	C:\prg\code\BAS\cd2d\src\src\demo.bas	332	sub selectTeam( p as integer )
updatePlayer	C:\prg\code\BAS\cd2d\src\src\demo.bas	378	sub updatePlayer( byval p as integer )
gameloop	C:\prg\code\BAS\cd2d\src\src\demo.bas	498	sub gameloop static
listInit	C:\prg\code\BAS\cd2d\src\src\queue.bas	14	Sub listInit( l as TLIST, lTB() as LNODE, byval maxnodes as integer )
listEnd	C:\prg\code\BAS\cd2d\src\src\queue.bas	34	Sub listEnd( l as TLIST, lTB() as LNODE )
listClear	C:\prg\code\BAS\cd2d\src\src\queue.bas	45	Sub listClear( l as TLIST, lTB() as LNODE )
listAdd%	C:\prg\code\BAS\cd2d\src\src\queue.bas	61	Function listAdd%( l as TLIST, lTB() as LNODE, byval idx as integer, byval id as integer ) Static
listDel	C:\prg\code\BAS\cd2d\src\src\queue.bas	99	Sub listDel( l as TLIST, lTB() as LNODE, byval n as integer ) Static
listGetFirst%	C:\prg\code\BAS\cd2d\src\src\queue.bas	129	Function listGetFirst%( l as TLIST, lTB() as LNODE ) static
listGetNext%	C:\prg\code\BAS\cd2d\src\src\queue.bas	141	Function listGetNext%( l as TLIST, lTB() as LNODE ) static
listIsIn%	C:\prg\code\BAS\cd2d\src\src\queue.bas	156	Function listIsIn%( l as TLIST, lTB() as LNODE, byval id as integer ) Static
pqueueInit	C:\prg\code\BAS\cd2d\src\src\queue.bas	183	Sub pqueueInit( l as TLIST, lTB() as PQNODE, byval maxnodes as integer )
pqueueEnd	C:\prg\code\BAS\cd2d\src\src\queue.bas	203	Sub pqueueEnd( l as TLIST, lTB() as PQNODE )
pqueueClear	C:\prg\code\BAS\cd2d\src\src\queue.bas	214	Sub pqueueClear( l as TLIST, lTB() as PQNODE )
pqueueEmpty%	C:\prg\code\BAS\cd2d\src\src\queue.bas	230	Function pqueueEmpty%( l as TLIST )
pqueueAdd%	C:\prg\code\BAS\cd2d\src\src\queue.bas	240	Function pqueueAdd%( l as TLIST, lTB() as PQNODE, byval idx as integer, byval id as integer, _
pqueuePop%	C:\prg\code\BAS\cd2d\src\src\queue.bas	318	Function pqueuePop%( l as TLIST, lTB() as PQNODE )
pqueueDel	C:\prg\code\BAS\cd2d\src\src\queue.bas	350	Sub pqueueDel( l as TLIST, lTB() as PQNODE, byval n as integer ) Static
pqueueIsIn%	C:\prg\code\BAS\cd2d\src\src\queue.bas	380	Function pqueueIsIn%( l as TLIST, lTB() as PQNODE, byval id as integer ) Static
fontDel	C:\prg\code\BAS\cd2d\src\inc\font.bi	43	        
fontGetSize%	C:\prg\code\BAS\cd2d\src\inc\font.bi	89	        
mouseEnd	C:\prg\code\BAS\cd2d\src\inc\mouse.bi	19	        
tmrDel	C:\prg\code\BAS\cd2d\src\inc\tmr.bi	38	        
