Class {
	#name : #AlgorithmX,
	#superclass : #Object,
	#instVars : [
		'collector',
		'sol',
		'memo',
		'zDDTree'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-exact cover'
}

{ #category : #searching }
AlgorithmX >> resetWithGenerator: generator withBlock: aBlock [
	sol := DLSolution new
		substitution: Dictionary new;
		updates: 0;
		yourself.
		zDDTree := Dictionary new.
			memo := Dictionary new.
	collector := [ :aSolution | self yieldSolution: aSolution onGenerator: generator withBlock: aBlock ]
]

{ #category : #searching }
AlgorithmX >> searchDepth: k forDLColumnObject: c [
	| x |
	x := ZDDNode bottom.
	c coverWith: [ :cus | sol updatesWith: [ :us | us + cus ] ].
	c
		untilFixPointOf: [ :co | co down ]
		do: [ :r | 
			| y |
			y := self searchDepth: k forDLDataObject: r.
			y isZDDBottom
				ifFalse: [ | key |
					key := Array with: r with: x model with: y model.
					x := zDDTree
						at: key
						ifAbsentPut: [ ZDDNode new
								model: r;
								lower: x;
								higher: y;
								yourself ] ] ].
	c uncoverWith: [ :uus | sol updatesWith: [ :us | us - uus ] ].
	^ x
]

{ #category : #searching }
AlgorithmX >> searchDepth: k forDLDataObject: r [
^	sol substitution
		with: k -> r
		enter: [ r
				untilFixPointOf: [ :ro | ro right ]
				do:
					[ :j | j column coverWith: [ :cus | sol updatesWith: [ :us | us + cus ] ] ] ]
		do: [ self searchDepth: k + 1 forDLRootObject: r column root ]
		exit: [ r
				untilFixPointOf: [ :ro | ro left ]
				do:
					[ :j | j column uncoverWith: [ :uus | sol updatesWith: [ :us | us - uus ] ] ] ]
]

{ #category : #searching }
AlgorithmX >> searchDepth: k forDLRootObject: h [
	^ (h isFixPointOf: [ :ro | ro right ])
		ifTrue: [ self yieldSolution ]
		ifFalse: [
			
			memo at: h columns  ifAbsentPut: [  
			
			 self searchDepth: k forDLColumnObject: h chooseColumn ]]
]

{ #category : #searching }
AlgorithmX >> solutionsFor: h [
	^ self solutionsFor: h withPost: [ :aDLDataObject | aDLDataObject model ]
]

{ #category : #searching }
AlgorithmX >> solutionsFor: h withPost: aBlock [
	^ self solutionsFor: h withPost: aBlock treeHandler: [ :_| ]
]

{ #category : #searching }
AlgorithmX >> solutionsFor: h withPost: aBlock treeHandler: recvBlock [
	^ Generator
		on: [ :generator | 
			| tree |
			self resetWithGenerator: generator withBlock: aBlock.
			tree := self searchDepth: 0 forDLRootObject: h.
			recvBlock  value: tree ]
]

{ #category : #searching }
AlgorithmX >> yieldSolution [
	^ collector value: sol copy
]

{ #category : #searching }
AlgorithmX >> yieldSolution: aSolution onGenerator: generator withBlock: aBlock [
	| subjects |
	subjects := aSolution substitution values collect: aBlock.
	generator yield: (Set withAll: subjects) -> aSolution updates.
	^ ZDDNode top
]
