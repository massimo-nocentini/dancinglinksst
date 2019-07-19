Class {
	#name : #ZDDTerminalNode,
	#superclass : #ZDDNode,
	#category : #'Collections-DoubleLinkedList-DancingLinks-ZDD'
}

{ #category : #accessing }
ZDDTerminalNode >> initialize [ 
parent := Set new.
]

{ #category : #accessing }
ZDDTerminalNode >> isZDDBottom [ 
^ model not
]

{ #category : #accessing }
ZDDTerminalNode >> parent: anObject [

	parent add: anObject
]

{ #category : #accessing }
ZDDTerminalNode >> root [ 
|s|
	s := (parent collect: [:p | p root]) asSet.
	self assert: s size =1.
	^ s atRandom
]

{ #category : #accessing }
ZDDTerminalNode >> sets [
	^ self isZDDBottom
		ifTrue: [ Set new ]
		ifFalse: [ Set with: Set new ]
]

{ #category : #accessing }
ZDDTerminalNode >> subtree [
	^ Set with: self
]
