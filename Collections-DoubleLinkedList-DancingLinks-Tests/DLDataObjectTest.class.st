Class {
	#name : #DLDataObjectTest,
	#superclass : #TestCase,
	#category : #'Collections-DoubleLinkedList-DancingLinks-Tests'
}

{ #category : #tests }
DLDataObjectTest >> emptySudokuIndicators [
	| ones start end matrix |
	start := 0.
	end := 8.
	ones := LinkedList new.
	start to: end do: [ :row | 
		start to: end do: [ :column | 
			start to: end do: [ :value | 
				| rowIndex cellConstraint rowConstraint columnConstraint boxConstraint model |
				model := {(#x -> row).
				(#y -> column).
				(#v -> value)} asDictionary.
				rowIndex := 81 * row + (9 * column) + value.
				cellConstraint := rowIndex @ ((end + 1) * row + column).
				rowConstraint := rowIndex @ (9 * row + value + 81).
				columnConstraint := rowIndex @ (9 * column + value + (81 * 2)).
				boxConstraint := rowIndex
					@ (27 * (row // 3) + (9 * (column // 3)) + value + (81 * 3)).
				ones
					add: cellConstraint + 1;
					add: rowConstraint + 1;
					add: columnConstraint + 1;
					add: boxConstraint + 1 ] ] ].
	ones.
	matrix := Array2D rows: 9 ** 3 columns: 81 * 4 onesAt: ones.
	^ ones
]

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
DLDataObjectTest >> testDLXonSudoku [
	| grid setOfSets |
	grid := DLDataObject gridOn: DLDataObjectTest new emptySudokuIndicators.
	setOfSets := AlgorithmX new solutionsFor: (grid at: #root).
	self halt
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

{ #category : #tests }
DLDataObjectTest >> writeArray2D: matrix intoFileReference: aFileReference [
|stream|
stream := aFileReference writeStream.
matrix printOn:stream.
stream close.
]
