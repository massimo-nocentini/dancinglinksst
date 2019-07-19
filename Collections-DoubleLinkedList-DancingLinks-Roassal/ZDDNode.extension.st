Extension { #name : #ZDDNode }

{ #category : #'*Collections-DoubleLinkedList-DancingLinks-Roassal' }
ZDDNode >> asView [
	| v classes edges objs |
	objs := self subtree.
	v := RTView new.
	classes := (RTEllipse new
		color: (Color purple alpha: 0.3);
		size: 10) elementsOn: objs.	"
	(classes elementFromModel: Collection) trachelShape color: Color red."
	classes @ RTDraggable.
	v addAll: classes.
	edges := RTEdgeBuilder new
		view: v;
		shape: (RTLine new color: (Color purple alpha: 0.2));
		connectToAll: [ :node | Array with: node lower with: node higher ].
	edges do: [ :e | e trachelShape pushBack ].
	RTSugiyamaLayout on: v elements edges: v edges.
	"	v addAnimation: (RTSpringLayoutStepping new view: v)."
	v @ RTDraggableView.
	^ v
]
