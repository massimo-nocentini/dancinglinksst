Extension { #name : #ZDDNode }

{ #category : #'*Collections-DoubleLinkedList-DancingLinks-Roassal' }
ZDDNode >> asView [
	| v classes edges objs |
	objs := self subtree.
	v := RTView new.
	classes := (RTEllipse new size: 10) elementsOn: objs.	"
	(classes elementFromModel: Collection) trachelShape color: Color red."
	classes @ RTDraggable.
	v addAll: classes.
	edges := OrderedCollection new
		addAll:
			(RTEdgeBuilder new
				view: v;
				objects: objs;
				shape: RTStyledMultiLine new dashedLine;
				connectToAll:
						[ :node | node lower ifNil: [ {} ] ifNotNil: [ :l | l isZDDBottom
								ifTrue: [ {} ]
								ifFalse: [ {l} ] ] ]);
		addAll:
			(RTEdgeBuilder new
				view: v;
				objects: objs;
				shape:
					(RTStyledMultiLine new
						solidLine;
						color: (Color black alpha: 0.3);
						yourself);
				connectToAll: [ :node | node higher ifNil: [ {} ] ifNotNil: [ :h | {h} ] ]);
		yourself.
	edges do: [ :e | e trachelShape pushBack ].
	RTSugiyamaLayout on: v elements edges: v edges.
	"	v addAnimation: (RTSpringLayoutStepping new view: v)."
	v @ RTDraggableView.
	^ v
]
