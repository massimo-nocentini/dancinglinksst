Class {
	#name : #DLDataObjectTest,
	#superclass : #TestCase,
	#category : #'Collections-DoubleLinkedList-DancingLinks-Tests'
}

{ #category : #tests }
DLDataObjectTest >> knuthFirstExampleIndicators [ ^{(1 @ 3).
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
			(6 @ 7)}
]

{ #category : #tests }
DLDataObjectTest >> testGridCreationOnFirstKnuthMatrix [
	| grid  setOfSets |
	grid := DLDataObject gridOn: self knuthFirstExampleIndicators.

	setOfSets := AlgorithmX new solutionsFor: (grid at: #root).
	self
		assert: setOfSets asSet
		equals:
			{{(5 @ 7).
			(5 @ 2)} asSet.
			{(4 @ 4).
			(4 @ 1)} asSet.
			{(1 @ 6).
			(1 @ 3).
			(1 @ 5)} asSet} asSet.
	self
		assert: (setOfSets flatCollectAsSet: [ :aSet | (aSet collect: #x) asSet ])
		equals: {1 . 4 . 5} asSet.
	self
		assert: (setOfSets flatCollectAsSet: [ :aSet | aSet collect: #y ])
		equals: (1 to: 7) asSet
]

{ #category : #tests }
DLDataObjectTest >> viewGrid: aGrid [
	| b |
	b := RTMondrian new.
	b shape circle.
	b nodes: aGrid values.
	b edges
		connectToAll: [ :aValue | 
			{aValue left.
			aValue right.
			aValue up.
			aValue down} ].
	b layout circle.
	b build.
	^ b view
]
