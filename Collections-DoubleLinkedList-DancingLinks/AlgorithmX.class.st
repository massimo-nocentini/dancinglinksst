Class {
	#name : #AlgorithmX,
	#superclass : #Object,
	#instVars : [
		'memo',
		'zDDTree',
		'bottom',
		'top'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-exact cover'
}

{ #category : #initalize }
AlgorithmX >> initialize [
	zDDTree := Dictionary new.
	memo := Dictionary new.
	bottom := ZDDNode bottom.
	top := ZDDNode top.

]

{ #category : #'searching API' }
AlgorithmX >> searchDLRootObject: h onSolutionDo: aBlock [
	^ self
		searchDepth: 0
		forDLRootObject: h
		partialSelection: [ :selLink | 
			aBlock
				value:
					(LinkedList new
						add: selLink;
						asSet) ]
]

{ #category : #searching }
AlgorithmX >> searchDepth: k forDLColumnObject: c partialSelection: sel [
	^ [ c
		untilFixPointOf: [ :co | co up ]
		foldr: [ :r :x | 
			| y |
			y := self searchDepth: k forDLDataObject: r partialSelection: sel.
			y isZDDBottom
				ifTrue: [ x ]
				ifFalse: [ self
						uniqueNodeWithDLDataObject: r
						withLowerNode: x
						withHigherNode: y ] ]
		init: bottom ] onEnter: [ c cover ] onExit: [ c uncover ]
]

{ #category : #searching }
AlgorithmX >> searchDepth: k forDLDataObject: r partialSelection: cont [
	^ [ self
		searchDepth: k + 1
		forDLRootObject: r column root
		partialSelection: [ :sel | 
			cont
				value:
					(ValueLink new
						value: r model;
						nextLink: sel;
						yourself) ] ]
		onEnter: [ r untilFixPointOf: [ :ro | ro right ] do: [ :j | j column cover ] ]
		onExit: [ r untilFixPointOf: [ :ro | ro left ] do: [ :j | j column uncover ] ]
]

{ #category : #searching }
AlgorithmX >> searchDepth: k forDLRootObject: h partialSelection: cont [
	^ (h isFixPointOf: [ :ro | ro right ])
		ifTrue: [ self yieldNode: top onBlock: cont ]
		ifFalse: [ memo
				at: h columns
				ifPresent: [ :tree | self yieldNode: tree onBlock: cont ]
				ifAbsentPut: [ self
						searchDepth: k
						forDLColumnObject: h chooseColumn
						partialSelection: cont ] ]
]

{ #category : #private }
AlgorithmX >> uniqueNodeWithDLDataObject: r withLowerNode: x withHigherNode: y [
	| key |
	key := Array with: r with: x with: y.
	^ zDDTree
		at: key
		ifAbsentPut: [ | z |
			z := ZDDNode new
				model: r;
				lower: x;
				higher: y;
				yourself.
			 x parent: z .
			 y parent: z .
			z ]
]

{ #category : #private }
AlgorithmX >> yieldNode: tree onBlock: cont [
	tree sets
		collect: [ :each | (each collect: #model) as: LinkedList ]
		thenDo: [ :sel | 
			| link |
			link := (sel isEmpty
				ifTrue: [ nil ]
				ifFalse: [ sel firstLink ]) .cont value: link ].
	^ tree
]
