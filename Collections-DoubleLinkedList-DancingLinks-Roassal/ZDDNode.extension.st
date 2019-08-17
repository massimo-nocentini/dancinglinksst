Extension { #name : #ZDDNode }

{ #category : #'*Collections-DoubleLinkedList-DancingLinks-Roassal' }
ZDDNode >> asView [
	^ self asView: #yourself
]

{ #category : #'*Collections-DoubleLinkedList-DancingLinks-Roassal' }
ZDDNode >> asView: modelBlock [
	| nodeShape v classes edges objs |
	objs := self subtree.
	v := RTView new.
	nodeShape := RTLabel new
		text: [ :node | 
			node isZDDBottom
				ifTrue: [ '◊' ]
				ifFalse: [ node isZDDTop
						ifTrue: [ '•' ]
						ifFalse: [ (modelBlock value: node model model) asString ] ] ];
		yourself.
	classes := nodeShape elementsOn: objs.
	classes @ RTDraggable @ RTDraggableChildren.
	v addAll: classes.
	edges := OrderedCollection new
		addAll:
			(RTEdgeBuilder new
				view: v;
				objects: objs;
				shape: RTStyledMultiLine new orthoVertical dashedLine yourself;
				connectToAll: [ :node | 
					node lower
						ifNil: [ {} ]
						ifNotNil: [ :l | 
							l isZDDBottom
								ifTrue: [ {} ]
								ifFalse: [ {l} ] ] ]);
		addAll:
			(RTEdgeBuilder new
				view: v;
				objects: objs;
				shape:
					(RTStyledMultiLine new orthoVertical solidLine
						color: Color black;
						yourself);
				connectToAll: [ :node | 
					node higher
						ifNil: [ {} ]
						ifNotNil: [ :h | 
							(h isZDDTop not and: [ node depth + 1 = h depth ])
								ifTrue: [ {h} ]
								ifFalse: [ {} ] ] ]);
		addAll:
			(RTEdgeBuilder new
				view: v;
				objects: objs;
				shape: RTBezier3Line new yourself;
				connectFromAll: [ :node | 
					node isZDDBottom | node isZDDTop
						ifTrue: [ {} ]
						ifFalse: [ node additionalParents ] ]);
		yourself.	
	edges do: [ :e | e trachelShape pushBack ].
	RTTreeLayout on: v elements edges: v edges.
	
	v @ RTDraggableView.
	^ v
]
