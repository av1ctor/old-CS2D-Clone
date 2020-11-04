''
'' generic double-linked-list and priority-queue routines
''
'' aug/04 written [v1ctor]
''

Option Explicit

DefInt a-z
'$include: 'inc\queue.bi'


'':::::
Sub listInit( l as TLIST, lTB() as LNODE, byval maxnodes as integer )
	Dim i as integer

	ReDim lTB( 0 to maxnodes-1 ) as LNODE

	'' put all into the free list
	For i = 0 to maxnodes-1
		lTB(i).prv = i-1
		lTB(i).nxt = i+1
	Next i
	lTB(maxnodes-1).nxt = -1

    l.fhead	= 0
	l.head 	= -1
	l.tail 	= -1
	l.nodes	= maxnodes

End Sub

'':::::
Sub listEnd( l as TLIST, lTB() as LNODE )

	erase lTB

	l.head 	= -1
	l.tail 	= -1
	l.nodes	= 0

End Sub

'':::::
Sub listClear( l as TLIST, lTB() as LNODE )
	Dim i as integer

	For i = 0 to l.nodes-1
		lTB(i).prv = i-1
		lTB(i).nxt = i+1
	Next i
	lTB(l.nodes-1).nxt = -1

    l.fhead = 0
	l.head 	= -1
	l.tail 	= -1

End Sub

'':::::
Function listAdd%( l as TLIST, lTB() as LNODE, byval idx as integer, byval id as integer ) Static
	Dim n as integer, nn as integer, i as integer

	''
	listAdd = -1

	'' take from free list
	if( l.fhead = -1 ) then
		exit function
	end if

	n = l.fhead
	nn = lTB(n).nxt
	l.fhead = nn
	if( nn <> -1 ) then
		lTB(nn).prv = -1
	end if

	'' add to used list
	lTB(n).idx 	= idx
	lTB(n).id 	= id
	lTB(n).prv	= l.tail
	lTB(n).nxt	= -1

	If( l.tail <> -1 ) Then
		lTB(l.tail).nxt = n
	else
		l.head = n
	End if

	l.tail = n

	''
	listAdd = n

End Function

'':::::
Sub listDel( l as TLIST, lTB() as LNODE, byval n as integer ) Static
	Dim pn as integer, nn as integer

	'' delete from used list
	pn = lTB(n).prv
	nn = lTB(n).nxt
	If( pn <> -1 ) Then
		lTB(pn).nxt = nn
	Else
		l.head = nn
	End if

	If( nn <> -1 ) Then
		lTB(nn).prv = pn
	Else
		l.tail = pn
	End if

	'' add to free list
	nn = l.fhead
	lTB(n).prv = -1
	lTB(n).nxt = nn
	if( nn <> -1 ) then
		lTB(nn).prv = n
	end if
	l.fhead = n

End Sub

'':::::
Function listGetFirst%( l as TLIST, lTB() as LNODE ) static

	listGetFirst = -1

	l.curr = l.head
	if( l.curr = -1 ) then Exit Function

	listGetFirst = lTB(l.curr).idx

end function

'':::::
Function listGetNext%( l as TLIST, lTB() as LNODE ) static

	listGetNext = -1

	if( l.curr = -1 ) then Exit Function

	l.curr = lTB(l.curr).nxt
	if( l.curr = -1 ) then Exit Function

	listGetNext = lTB(l.curr).idx

end function


'':::::
Function listIsIn%( l as TLIST, lTB() as LNODE, byval id as integer ) Static
	Dim n as integer, i as integer

	listIsIn = -1

	If( l.head = -1 ) Then
		Exit Function
	End If

	n = l.head
	i = -1
	Do
		If( lTB(n).id = id ) Then
			i = lTB(n).idx
			Exit Do
		End If

		n = lTB(n).nxt
	loop until( n = -1 )

	listIsIn = i

End Function

'':::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

'':::::
Sub pqueueInit( l as TLIST, lTB() as PQNODE, byval maxnodes as integer )
	Dim i as integer

	ReDim lTB( 0 to maxnodes-1) as PQNODE

	'' put all into the free list
	For i = 0 to maxnodes-1
		lTB(i).prv = i-1
		lTB(i).nxt = i+1
	Next i
	lTB(maxnodes-1).nxt = -1

    l.fhead = 0
	l.head 	= -1
	l.tail 	= -1
	l.nodes	= maxnodes

End Sub

'':::::
Sub pqueueEnd( l as TLIST, lTB() as PQNODE )

	erase lTB

	l.head 	= -1
	l.tail 	= -1
	l.nodes	= 0

End Sub

'':::::
Sub pqueueClear( l as TLIST, lTB() as PQNODE )
	Dim i as integer

	For i = 0 to l.nodes-1
		lTB(i).prv = i-1
		lTB(i).nxt = i+1
	Next i
	lTB(l.nodes-1).nxt = -1

    l.fhead = 0
	l.head 	= -1
	l.tail 	= -1

End Sub

'':::::
Function pqueueEmpty%( l as TLIST )

	If( l.head = -1 ) Then
		pqueueEmpty = -1
	Else
		pqueueEmpty = 0
	End If
End Function

'':::::
Function pqueueAdd%( l as TLIST, lTB() as PQNODE, byval idx as integer, byval id as integer, _
			   		 byval priority as integer ) Static
	Dim n as integer, i as integer, p as integer, nn as integer

	'' take from free list
	if( l.fhead = -1 ) then
		pqueueAdd = -1
		exit function
	end if

	n = l.fhead
	nn = lTB(n).nxt
	l.fhead = nn
	if( nn <> -1 ) then
		lTB(nn).prv = -1
	end if

	''
	pqueueAdd = n

	'' add to used list, sorted
	lTB(n).idx = idx
	lTB(n).id 	= id
	lTB(n).pri = priority

	''
	If( l.head = -1 ) Then
		l.head = n
		l.tail = n
		lTB(n).prv = -1
		lTB(n).nxt = -1
		Exit function
	End If

	'' sort
	i = l.head
	Do
		If( lTB(i).pri > priority ) Then
			Exit Do
		End If

		i = lTB(i).nxt
	loop until( i = -1 )

	''
	If( i = -1 ) Then
		i = l.tail
		lTB(i).nxt = n

		lTB(n).prv = i
		lTB(n).nxt = -1

		l.tail = n
		Exit function
	End If

	If( i = l.head ) Then
		lTB(i).prv = n

		lTB(n).prv = -1
		lTB(n).nxt = i

		l.head = n
		Exit Function
	End If

	''
	p = lTB(i).prv

	lTB(n).prv = p
	lTB(n).nxt	= i

	lTB(p).nxt = n
	lTB(i).prv = n

End Function

'':::::
Function pqueuePop%( l as TLIST, lTB() as PQNODE )
	Dim n as integer, nn as integer

	If( l.head = -1 ) Then
		pqueuePop = -1
		Exit Function
	End if

	n = l.head
	pqueuePop = lTB(n).idx

	'' del from used list
	nn = lTB(n).nxt
	l.head = nn
	If( nn <> -1 ) Then
		lTB(nn).prv = -1
	Else
		l.tail = -1
	End If

	'' add to free list
	nn = l.fhead
	lTB(n).prv = -1
	lTB(n).nxt = nn
	if( nn <> -1 ) then
		lTB(nn).prv = n
	end if
	l.fhead = n

End Function

'':::::
Sub pqueueDel( l as TLIST, lTB() as PQNODE, byval n as integer ) Static
	Dim pn as integer, nn as integer

	'' del from used list
	pn = lTB(n).prv
	nn = lTB(n).nxt
	If( pn <> -1 ) Then
		lTB(pn).nxt = nn
	Else
		l.head = nn
	End if

	If( nn <> -1 ) Then
		lTB(nn).prv = pn
	Else
		l.tail = pn
	End if

	'' add to free list
	nn = l.fhead
	lTB(n).prv = -1
	lTB(n).nxt = nn
	if( nn <> -1 ) then
		lTB(nn).prv = n
	end if
	l.fhead = n

End Sub

'':::::
Function pqueueIsIn%( l as TLIST, lTB() as PQNODE, byval id as integer ) Static
	Dim n as integer, i as integer

	pqueueIsIn = -1

	If( l.head = -1 ) Then
		Exit Function
	End If

	n = l.head
	i = -1
	Do
		If( lTB(n).id = id ) Then
			i = lTB(n).idx
			Exit Do
		End If

		n = lTB(n).nxt
	loop until( n = -1 )

	pqueueIsIn = i

End Function


