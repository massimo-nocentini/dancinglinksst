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
	| grid alg sols setOfSets |
	grid := DLDataObject gridOn: self knuthFirstExampleIndicators.
	alg := AlgorithmX onDLRootObject: (grid at: #root).
	sols := LinkedList new.
	alg addSolutionsTo: sols.
	setOfSets := Set new.
	sols
		do: [ :aDict | 
			aDict
				valuesDo: [ :aDLDataObject | setOfSets add: aDLDataObject asColumnsSet ] ].
	self
		assert: setOfSets
		equals:
			{{'C7' . 'C2'} asSet.
			{'C4' . 'C1'} asSet.
			{'C6' . 'C3' . 'C5'} asSet} asSet
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
