Class {
	#name : #DLDataObjectTest,
	#superclass : #TestCase,
	#category : #'Collections-DoubleLinkedList-DancingLinks-Tests'
}

{ #category : #tests }
DLDataObjectTest >> testGridCreationOnFirstKnuthMatrix [
	| grid |
	grid := DLDataObject
		gridOn:
			{(1 @ 3).
			(1 @ 5).
			(1 @ 6).
			(2 @ 1).
			(2 @ 4).
			(2 @ 7).
			(3 @ 2).
			(3 @ 3).
			(3 @ 6).
			(4 @ 1).
			(4 @ 4).
			(5 @ 2).
			(5 @ 7).
			(6 @ 4).
			(6 @ 5).
			(6 @ 7)}.
	(self viewGrid: grid) inspect
]

{ #category : #tests }
DLDataObjectTest >> viewGrid: aGrid [
	| v es |
	v := RTView new.
	v @ RTDraggableView.
	es := RTBox elementsOn: aGrid values.
	v addAll: es.
	RTEdgeBuilder new
		view: v;
		elements: es;
		connectToAll: [ :aValue | 
			{aValue left.
			aValue right.
			aValue up.
			aValue down} ].
	RTGridLayout on: es.
	es @ RTDraggableChildren.
	^ v
]
