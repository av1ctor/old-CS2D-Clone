

type TLIST
	head	as integer
	tail	as integer
	fhead	as integer
	nodes	as integer

	curr	as integer
end type


Type LNODE
	idx		as integer
	prv		as integer
	nxt		as integer
	id		as integer
End Type


declare Sub 		listInit		( l as TLIST, lTB() as LNODE, byval maxnodes as integer )

declare Sub 		listEnd			( l as TLIST, lTB() as LNODE )

declare Sub 		listClear		( l as TLIST, lTB() as LNODE )

declare Function 	listAdd%		( l as TLIST, lTB() as LNODE, byval idx as integer, _
									  byval id as integer )

declare Sub 		listDel			( l as TLIST, lTB() as LNODE, byval n as integer )

declare Function 	listGetFirst%	( l as TLIST, lTB() as LNODE )

declare Function 	listGetNext%	( l as TLIST, lTB() as LNODE )

declare Function 	listIsIn%		( l as TLIST, lTB() as LNODE, byval id as integer )



Type PQNODE
	pri		as integer
	idx		as integer
	prv		as integer
	nxt		as integer
	id		as integer
End Type

declare Sub 		pqueueInit		( l as TLIST, lTB() as PQNODE, byval maxnodes as integer )

declare Sub 		pqueueEnd		( l as TLIST, lTB() as PQNODE )

declare Sub 		pqueueClear		( l as TLIST, lTB() as PQNODE )

declare Function 	pqueueAdd%		( l as TLIST, lTB() as PQNODE, byval idx as integer, _
									  byval id as integer, byval priority as integer )

declare Sub 		pqueueDel		( l as TLIST, lTB() as PQNODE, byval n as integer )

declare Function 	pqueueIsIn%		( l as TLIST, lTB() as PQNODE, byval id as integer )

declare Function 	pqueueEmpty%	( l as TLIST )

declare Function 	pqueuePop%		( l as TLIST, lTB() as PQNODE )