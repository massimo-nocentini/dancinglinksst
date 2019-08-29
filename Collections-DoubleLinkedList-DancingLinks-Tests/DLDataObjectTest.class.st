Class {
	#name : #DLDataObjectTest,
	#superclass : #TestCase,
	#category : #'Collections-DoubleLinkedList-DancingLinks-Tests'
}

{ #category : #tests }
DLDataObjectTest >> NQueensIndicators: n [
	| ones  |
	ones := LinkedList new.
	0 to: n - 1 do: [ :row | 
		0 to: n - 1 do: [ :column | 
			|rowIndex rowConstraint columnConstraint diagonalConstraint antiDiagonalConstraint model |
			model := Dictionary new
				at: #x put: row;
				at: #y put: column;
				yourself.
			rowIndex := n * row + column.
			rowConstraint := rowIndex @ row.
			columnConstraint := rowIndex @ (n + column).
			diagonalConstraint := rowIndex @ (2 * n + (row + column)).
			antiDiagonalConstraint := rowIndex
				@ (2 * n + (2 * n) - 1 + (n - 1 - row + column)).
			ones
				add: ((rowConstraint + 1) asDLPoint primary: true) -> model;
				add: ((columnConstraint + 1) asDLPoint primary: true) -> model;
				add: ((diagonalConstraint + 1) asDLPoint primary: false) -> model;
				add: ((antiDiagonalConstraint + 1) asDLPoint primary: false) -> model.] ].
	^ ones
]

{ #category : #tests }
DLDataObjectTest >> ZDDIndicators [
	^ {(1 @ 1).
	(1 @ 2).
	(1 @ 3).
	(1 @ 5).
	(2 @ 1).
	(2 @ 2).
	(3 @ 4).
	(3 @ 6).
	(4 @ 3).
	(4 @ 4).
(4 @ 6).
	(5 @ 3).
	(5 @ 5).}
		collect: [ :each | (each asDLPoint primary: true) -> each x ]
]

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
					add: ((cellConstraint + 1) asDLPoint primary: true) -> model;
					add: ((rowConstraint + 1)asDLPoint primary: true) -> model;
					add: ((columnConstraint + 1)asDLPoint primary: true) -> model;
					add: ((boxConstraint + 1)asDLPoint primary: true) -> model ] ] ].
	matrix := Array2D
		rows: 9 ** 3
		columns: 81 * 4
		onesAt: (ones collect: #key).
	^ ones
]

{ #category : #tests }
DLDataObjectTest >> knuthFirstExampleIndicators [
	^ {(1 @ 3).
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
	(6 @ 7)} collect: [ :each | (each asDLPoint primary: true) -> each x ]
]

{ #category : #tests }
DLDataObjectTest >> runDLXonNQueens: n next: nel [
	| grid sols matrices |
	grid := DLDataObject gridOn: (self NQueensIndicators: n).
	sols := nel
		ifNil: [| tree |
	tree := AlgorithmX new searchDLRootObject: (grid at: #root) onSolutionDo: #yourself.	
	
	tree sets collect: [ :aSet | aSet collect: #model ]    ]
		ifNotNil: [ | gen |
			gen := Generator
				on: [ :g | 
					AlgorithmX new
						searchDLRootObject: (grid at: #root)
						onSolutionDo: [ :sel | g yield: sel ] ].
			gen next: nel ].
	matrices := sols
		collect: [ :sol | 
			| matrix |
			matrix := Array2D rows: n columns: n element: 0.
			sol
				do:
					[ :model | matrix at: (model at: #x) + 1 at: (model at: #y) + 1 put: 1 ].
			matrix ].
	^ matrices
]

{ #category : #tests }
DLDataObjectTest >> testDLXonSudoku [
	| grid sols chain matrices |
	grid := DLDataObject
		gridOn: DLDataObjectTest new emptySudokuIndicators.
	chain :=Generator
		on:
			[ :g |  AlgorithmX new searchDLRootObject:  (grid at: #root) onSolutionDo: [ :sel | g yield: sel ] ] .
	self assert: chain atEnd equals: false.
	sols := (chain next: 2) contents.
	matrices := sols
		collect: [ :sol | 
			| matrix |
			matrix := Array2D rows: 9 columns: 9.
			sol
				do: [ :model | 
					matrix
						at: (model at: #x) + 1
						at: (model at: #y) + 1
						put: (model at: #v) + 1 ].
			matrix ].
	self
		assert: matrices first printString
		equals:
			'(9 8 7 6 5 4 3 2 1
2 3 1 9 7 8 4 5 6
6 4 5 2 3 1 9 7 8
7 5 2 8 9 3 1 6 4
1 6 3 7 4 5 8 9 2
4 9 8 1 6 2 7 3 5
5 7 6 4 8 9 2 1 3
3 1 4 5 2 7 6 8 9
8 2 9 3 1 6 5 4 7 )'.
	self
		assert: matrices second printString
		equals:
			'(9 8 7 6 5 4 3 2 1
2 1 3 9 7 8 4 5 6
6 4 5 2 3 1 9 7 8
7 5 2 8 9 3 1 6 4
3 6 1 7 4 5 8 9 2
4 9 8 1 6 2 7 3 5
5 7 6 4 8 9 2 1 3
1 3 4 5 2 7 6 8 9
8 2 9 3 1 6 5 4 7 )'
]

{ #category : #tests }
DLDataObjectTest >> testDLXon_32Queens [
	| matrices |
	matrices := self runDLXonNQueens: 32 next: 2.
	self
		assert: matrices first printString
		equals: '(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0
0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0
0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 )'.
	self
		assert: matrices second printString
		equals:
			'(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0
0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0
1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0
0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 )'.
	matrices
		do:
			[ :matrix | 1 to: matrix rowCount do: [ :row | self assert: (matrix atRow: row) sum equals: 1 ] ].
	matrices
		do:
			[ :matrix | 1 to: matrix columnCount do: [ :column | self assert: (matrix atColumn: column) sum equals: 1 ] ]
]

{ #category : #tests }
DLDataObjectTest >> testDLXon_8Queens [
	| matrices |
	matrices := self runDLXonNQueens: 8 next: 2.
	self assert: matrices size equals: 2.
	self
		assert: matrices first printString
		equals:
			'(0 0 0 0 0 0 0 1
0 0 0 1 0 0 0 0
1 0 0 0 0 0 0 0
0 0 1 0 0 0 0 0
0 0 0 0 0 1 0 0
0 1 0 0 0 0 0 0
0 0 0 0 0 0 1 0
0 0 0 0 1 0 0 0 )'.
	self
		assert: matrices second printString
		equals:
			'(0 0 0 0 0 0 0 1
0 0 1 0 0 0 0 0
1 0 0 0 0 0 0 0
0 0 0 0 0 1 0 0
0 1 0 0 0 0 0 0
0 0 0 0 1 0 0 0
0 0 0 0 0 0 1 0
0 0 0 1 0 0 0 0 )'
]

{ #category : #tests }
DLDataObjectTest >> testDLXon_8Queens_all [
	| gen grid byGen byTree |
	grid := DLDataObject gridOn: (self NQueensIndicators: 8).
	gen := Generator
		on: [ :g | 
			| tree |
			tree := AlgorithmX new
				searchDLRootObject: (grid at: #root)
				onSolutionDo: [ :sel | g yield: sel ].
			byTree := tree sets collect: [ :aSet | aSet collect: #model ] ].
	byGen := gen contents asSet.
	self assert: byGen size equals: 92.
	self assert: byGen equals: byTree
]

{ #category : #tests }
DLDataObjectTest >> testDLXon_NQueens_sequence [
	| seq elapsedTime |
	elapsedTime := [ seq := (1 to: 10)
		collect: [ :i | (self runDLXonNQueens: i next: nil) size ] ]
		timeToRun.
	self assert: elapsedTime < 2 asSeconds .
	self
		assert: seq
		equals: {1 . 0 . 0 . 2 . 10 . 4 . 40 . 92 . 352 . 724}	" the eleventh number should be 2680"
]

{ #category : #tests }
DLDataObjectTest >> testGridCreationOnFirstKnuthMatrix [
	| grid setOfSets zDD |
	grid := DLDataObject gridOn: self knuthFirstExampleIndicators.
	zDD := AlgorithmX new
		searchDLRootObject: (grid at: #root)
		onSolutionDo: #yourself.
	setOfSets := zDD sets collect: [ :aSet | aSet collect: #model ].
	self assert: setOfSets equals: (Set with: {1 . 4 . 5} asSet).
	setOfSets := zDD sets
		collect:
			[ :aSet | aSet collect: [ :aDLDataObject | aDLDataObject asColumnsSet ] ].
	self
		assert: setOfSets
		equals:
			(Set
				with:
					{({(5 @ 7).
					(5 @ 2)} collect: #asDLPoint) asSet.
					({(4 @ 4).
					(4 @ 1)} collect: #asDLPoint) asSet.
					({(1 @ 6).
					(1 @ 3).
					(1 @ 5)} collect: #asDLPoint) asSet} asSet).
	self assert: setOfSets size equals: 1.
	self
		assert:
			(setOfSets atRandom 
				flatCollectAsSet: [ :aSet | (aSet collect: #x) asSet ])
		equals: {1 . 4 . 5} asSet.
	self
		assert:
			(setOfSets atRandom  flatCollectAsSet: [ :aSet | aSet collect: #y ])
		equals: (1 to: 7) asSet
]

{ #category : #tests }
DLDataObjectTest >> testGridCreationOnZDDMatrix [
	| grid setOfSets chain zDD |
	grid := DLDataObject gridOn: self ZDDIndicators.
	chain := Generator
		on:
			[ :g | AlgorithmX new searchDLRootObject: (grid at: #root) onSolutionDo: g ].
	setOfSets := chain contents asSet.
	self assert: setOfSets equals: (Set with: {1 . 3} asSet with: {2 . 3 . 5} asSet).
	zDD := AlgorithmX new
		searchDLRootObject: (grid at: #root)
		onSolutionDo: #yourself.
	setOfSets :=zDD sets
		collect:
			[ :aSet | aSet collect: [ :aDLDataObject | aDLDataObject asColumnsSet ] ].
	
	self
		assert: setOfSets
		equals:
			(Set
				with:
					{({(3 @ 4).
					(3 @ 6)} collect: #asDLPoint) asSet.
					({(2 @ 2).
					(2 @ 1)} collect: #asDLPoint) asSet.
					({(5 @ 5).
					(5 @ 3)} collect: #asDLPoint) asSet.
					} asSet
					with:
					{({(3 @ 4).
					(3 @ 6)} collect: #asDLPoint) asSet.
					({(1 @ 1).
					(1 @ 5).
					(1 @ 2).
					(1 @ 3)} collect: #asDLPoint) asSet.
					} asSet).
	self assert: setOfSets size equals: 2.
	"self
		assert:
			(setOfSets atRandom 
				flatCollectAsSet: [ :aSet | (aSet collect: #x) asSet ])
		equals: {1 . 3} asSet.
	self
		assert:
			(setOfSets atRandom  flatCollectAsSet: [ :aSet | aSet collect: #y ])
		equals: (1 to: 6) asSet"
]

{ #category : #tests }
DLDataObjectTest >> testNQueensIndicators [
	| n ones matrix  |
	n := 4.
	ones := self NQueensIndicators: n.
	matrix := Array2D
		rows: n ** 2
		columns: (ones collect: [ :each | each key y ]) max
		onesAt: (ones collect: #key).
	self
		assert: matrix printString
		equals:
			'(1 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0 0
1 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0 0
1 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 1 0
1 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0 0 0 0 1
0 1 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0 0
0 1 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0 0
0 1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 1 0 0
0 1 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 1 0
0 0 1 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0
0 0 1 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0
0 0 1 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0
0 0 1 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 1 0 0
0 0 0 1 1 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0 0
0 0 0 1 0 1 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0 0
0 0 0 1 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 0 0 0
0 0 0 1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 1 0 0 0 )'
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
