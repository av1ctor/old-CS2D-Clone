''
'' generic A* pathfind algorithm
'' (user must implement the u_findSuccessors, u_calcDistance and u_calcCost functions)
'' (routines can be used by just one client at time)
''
'' aug/04 written [v1ctor]
''

Option Explicit

DefInt a-z
'$include: 'inc\queue.bi'
'$include: 'inc\astar.bi'


declare function u_findSuccessors%( byval src as integer, tTB() as integer )
declare function u_calcDistance%  ( byval src as integer, byval dst as integer )
declare function u_calcCost%	  ( byval src as integer, byval dst as integer )


Type ASTARNODE
	g			as integer						'' cost (parent cost + random)
	h			as integer						'' heuristic (distance + random)
	p			as integer						'' parent node
	t			as integer						'' tile (x= tile mod mapwidth, y= tile \ mapwidth)
	n			as integer						'' linked-list node (for fast deletion)
End Type

'' globals
dim shared maxnodes as integer
dim shared openlist as TLIST, closedlist as TLIST
dim shared tTB( 0 to 15 ) as integer

	ReDim shared nTB( 0 ) as ASTARNODE

	ReDim shared lTB( 0 ) as LNODE
	ReDim shared pqTB( 0 ) as PQNODE


'':::::
sub aStarInit( byval nodes as integer )

	ReDim nTB( 0 to nodes-1 ) as ASTARNODE

	pqueueInit openlist, pqTB(), nodes

	listInit closedlist, lTB(), nodes

	maxnodes = nodes

end sub

'':::::
sub aStarEnd

	erase nTB

	listEnd closedlist, lTB()

	pqueueEnd openlist, pqTB()

	maxnodes = 0

end sub

'':::::
sub aStarClear

	pqueueClear openlist, pqTB()

	listClear closedlist, lTB()

end sub


'':::::
Function fillPath% ( byval s as integer, path() as integer, byval idx as integer )
	Dim i as integer

	i = idx
	Do
		path(i) = nTB(s).t
		i = i + 1
		s = nTB(s).p
	loop While( s <> -1 )

	fillPath = i - idx

End Function

'':::::
Function aStarFindPath%( byval src as integer, byval dst as integer, _
						 path() as integer, byval idx as integer ) static

	Dim n as integer, i as integer, j as integer, k as integer, s as integer, t as integer
	Dim nodes as integer, pn as integer, ln as integer, newg as integer

    aStarFindPath = 0

    ''
    '' add first node (src)
    ''
	n = 0
	nTB(n).t = src
	nTB(n).g = 0
	nTB(n).h = u_calcDistance( src, dst )
	nTB(n).p = -1
	nTB(n).n = pqueueAdd( openlist, pqTB(), n, src, nTB(n).g+nTB(n).h )
	n = n + 1

	''
	'' loop while there's any node to be opened
	''
	nodes = 0
	Do until( pqueueEmpty( openlist ) )

		''
		'' get top node (closest)
		''
		i = pqueuePop( openlist, pqTB() )
		If( nTB(i).t = dst ) Then
			nodes = fillPath( i, path(), idx )
			Exit Do
		End If

		''
		'' find all successors for top node
		''
		s = u_findSuccessors( nTB(i).t, tTB() )

		''
		'' loop through all successors
		''
		For j = 0 to s-1
			t = tTB(j)
			newg = nTB(i).g + u_calcCost( nTB(i).t, t )

			''
			'' add or update successor
			''
			pn = pqueueIsIn( openlist, pqTB(), t )
			ln = listIsIn( closedlist, lTB(), t )
			If( (pn <> -1) or (ln <> -1) ) Then

				If( pn <> -1 ) Then
					If( nTB(pn).g <= newg ) Then GoTo skip
					k = pn
				end if

				If( ln <> -1 ) Then
					If( nTB(ln).g <= newg ) Then GoTo skip
					k = ln
				End If

			Else
				k = n
				n = n + 1
				if( n >= maxnodes ) then exit function
			End If

			nTB(k).t = t
			nTB(k).p = i
			nTB(k).g = newg
			nTB(k).h = u_calcDistance( t, dst )

			If( ln <> -1 ) Then
				listDel closedlist, lTB(), nTB(ln).n
			End If
			If( pn <> -1 ) Then
				pqueueDel openlist, pqTB(), nTB(pn).n
			End If

            nTB(k).n = pqueueAdd( openlist, pqTB(), k, t, nTB(k).g+nTB(k).h )

skip:
		Next j

		''
		'' top node can go to closed list now
		''
		nTB(i).n = listAdd( closedlist, lTB(), i, nTB(i).t )

	Loop

	aStarFindPath = nodes

End Function


'' priorityqueue	Open
'' list		Closed
''
'' AStarSearch
'' 	s.g = 0		// s is the start node
'' 	s.h = GoalDistEstimate( s )
'' 	s.f = s.g + s.h
'' 	s.parent = null
'' 	push s on Open
''
'' 	while Open is not empty {
''
'' 		pop node n from Open  // n has the lowest f
''
'' 		if n is a goal node
'' 		{
'' 			construct path
'' 			return success
'' 		}
''
'' 		for each successor n' of n
'' 		{
'' 			newg = n.g + cost(n,n')
'' 			if n' is in Open or Closed,
'' 			 and n'.g <= newg
'' 				skip
'' 			n'.parent = n
'' 			n'.g = newg
'' 			n'.h = GoalDistEstimate( n' )
'' 			n'.f = n'.g + n'.h
'' 			if n' is in Closed
'' 				remove it from Closed
'' 			if n' is not yet in Open
'' 				push n' on Open
''
'' 		}
'' 		push n onto Closed
'' 	}
'' 	return failure  // if no path found
