Class {
	#name : #AlgorithmX,
	#superclass : #Object,
	#instVars : [
		'h',
		'sol'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks'
}

{ #category : #creating }
AlgorithmX class >> onDLRootObject: aDLRootObject [ 
	^ self new h: aDLRootObject ; yourself.
]

{ #category : #searching }
AlgorithmX >> addSolutionsTo: aCollection [

	self search: 0 addInto: aCollection
]

{ #category : #accessing }
AlgorithmX >> h: aDLRootObject [ 
	h := aDLRootObject
]

{ #category : #searching }
AlgorithmX >> initialize [ 
	sol := Dictionary new.
]

{ #category : #searching }
AlgorithmX >> search: k addInto: aCollection [
	(h isFixPointForDirection: #right)
		ifTrue: [ aCollection add: sol copy ]
		ifFalse: [ | c |
			c := h chooseColumn.
			c cover.
			c
				untilFixPointForDirection: #down
				do: [ :r | 
					sol at: k put: r.
					r untilFixPointForDirection: #right do: [ :j | j column cover ].
					self search: k + 1 addInto: aCollection.
					(sol at: k)
						untilFixPointForDirection: #left
						do: [ :j | j column uncover ].
					 ].
				c uncover ]
]
