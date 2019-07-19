Class {
	#name : #AlgorithmX,
	#superclass : #Object,
	#instVars : [
		'collector',
		'sol',
		'memo',
		'zDDTree',
		'bottom',
		'top'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-exact cover'
}

{ #category : #searching }
AlgorithmX >> resetWithGenerator: generator withBlock: aBlock [
	zDDTree := Dictionary new.
	memo := Dictionary new.
	sol := DLSolution new
		substitution: Dictionary new;
		updates: 0;
		yourself.
		bottom := ZDDNode bottom.
		top := ZDDNode top.
	collector := [ :aSolution | self yieldSolution: aSolution onGenerator: generator withBlock: aBlock ]
]

{ #category : #searching }
AlgorithmX >> searchDepth: k forDLColumnObject: c [
	| x |
	x := bottom.
	c cover.
	c
		untilFixPointOf: [ :co | co down ]
		do: [ :r | 
			| y |
			y := self searchDepth: k forDLDataObject: r.
			y == bottom
				ifFalse: [ x := self uniqueNodeWithDLDataObject: r withLowerNode: x withHigherNode: y] ].
	c uncover.
	^ x
]

{ #category : #searching }
AlgorithmX >> searchDepth: k forDLDataObject: r [
	| tree |
	r untilFixPointOf: [ :ro | ro right ] do: [ :j | j column cover ].
	tree := self searchDepth: k + 1 forDLRootObject: r column root.
	r untilFixPointOf: [ :ro | ro left ] do: [ :j | j column uncover ].
	^ tree
]

{ #category : #searching }
AlgorithmX >> searchDepth: k forDLRootObject: h [
	^ (h isFixPointOf: [ :ro | ro right ])
		ifTrue: [ top ]
		ifFalse: [ memo
				at: h columns asSet
				ifAbsentPut: [ self searchDepth: k forDLColumnObject: h chooseColumn ] ]
]

{ #category : #searching }
AlgorithmX >> solutionsFor: h [
	^ self solutionsFor: h withPost: [ :aDLDataObject | aDLDataObject model ]
]

{ #category : #searching }
AlgorithmX >> solutionsFor: h withPost: aBlock [
	^ self
		solutionsFor: h
		withPost: aBlock
		treeHandler: [ :zdd |  ]
]

{ #category : #searching }
AlgorithmX >> solutionsFor: h withPost: aBlock treeHandler: recvBlock [
			| tree |
			self resetWithGenerator: nil withBlock: aBlock.
			tree := self searchDepth: 0 forDLRootObject: h.
			self halt.
			^ top root
]

{ #category : #searching }
AlgorithmX >> uniqueNodeWithDLDataObject: r withLowerNode: x withHigherNode: y [

| key |
					key := Array with: r with: x with: y.
					^ zDDTree
						at: key
						ifAbsentPut: [ ZDDNode new
								model: r;
								lower: x;
								higher: y;
								yourself ]
]

{ #category : #searching }
AlgorithmX >> yieldSolution [
self halt.
	^ collector value: sol copy
]

{ #category : #searching }
AlgorithmX >> yieldSolution: aSolution onGenerator: generator withBlock: aBlock [
	| subjects |
	subjects := aSolution substitution values collect: aBlock.
	^generator yield: (Set withAll: subjects) -> aSolution updates.
	
]
