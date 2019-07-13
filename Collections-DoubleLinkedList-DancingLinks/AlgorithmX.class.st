Class {
	#name : #AlgorithmX,
	#superclass : #Object,
	#category : #'Collections-DoubleLinkedList-DancingLinks-exact cover'
}

{ #category : #searching }
AlgorithmX >> searchDepth: k partialSolution: sol collector: aBlock forDLColumnObject: c [
	c coverWith: [ :cus | sol updatesWith: [ :us | us + cus ] ].
	c
		untilFixPointOf: [ :co | co down ]
		do: [ :r | 
			self
				searchDepth: k
				partialSolution: sol
				collector: aBlock
				forDLDataObject: r ].
	c uncoverWith:  [ :uus | sol updatesWith: [ :us | us - uus ] ].
]

{ #category : #searching }
AlgorithmX >> searchDepth: k partialSolution: sol collector: aBlock forDLDataObject: r [
	sol substitution
		with: k -> r
		enter: [ r
				untilFixPointOf: [ :ro | ro right ]
				do:
					[ :j | j column coverWith: [ :cus | sol updatesWith: [ :us | us + cus ] ] ] ]
		do: [ self
				searchDepth: k + 1
				partialSolution: sol
				collector: aBlock
				forDLRootObject: r column root ]
		exit: [ r
				untilFixPointOf: [ :ro | ro left ]
				do:
					[ :j | j column uncoverWith: [ :uus | sol updatesWith: [ :us | us - uus ] ] ] ]
]

{ #category : #searching }
AlgorithmX >> searchDepth: k partialSolution: sol collector: aBlock forDLRootObject: h [
	^ (h isFixPointOf: [ :ro | ro right ])
		ifTrue: [ aBlock value: sol copy ]
		ifFalse: [ self
				searchDepth: k
				partialSolution: sol
				collector: aBlock
				forDLColumnObject: h chooseColumn ]
]

{ #category : #searching }
AlgorithmX >> solutionsFor: h [
	^ self solutionsFor: h withPost: [ :aDLDataObject | aDLDataObject model ]
]

{ #category : #searching }
AlgorithmX >> solutionsFor: h withPost: aBlock [
	^ Generator
		on: [ :generator | 
			self
				searchDepth: 0
				partialSolution:
					(DLSolution new
						substitution: Dictionary new;
						updates: 0;
						yourself)
				collector: [ :aSolution | 
					| subjects |
					subjects := aSolution substitution values collect: aBlock.
					generator yield: (Set withAll: subjects) -> aSolution updates ]
				forDLRootObject: h ]
]
