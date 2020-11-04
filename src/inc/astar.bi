
declare sub 		astarInit		( byval nodes as integer )

declare sub 		astarEnd		( )

declare sub 		astarClear		( )

declare function 	astarFindPath%	( byval src as integer, byval dst as integer, _
									  path() as integer, byval idx as integer )
