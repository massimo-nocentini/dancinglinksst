Class {
	#name : #ZDDTerminalNode,
	#superclass : #ZDDNode,
	#category : #'Collections-DoubleLinkedList-DancingLinks-ZDD'
}

{ #category : #accessing }
ZDDTerminalNode >> additionalParents [ 
^ self parent
]

{ #category : #accessing }
ZDDTerminalNode >> depth [
	^ (parent collect: [ :p | p depth ]) max + 1
]

{ #category : #accessing }
ZDDTerminalNode >> initialize [
super initialize.
	parent := Set new
]

{ #category : #accessing }
ZDDTerminalNode >> isZDDBottom [
	^ model = #ZDDBottom
]

{ #category : #accessing }
ZDDTerminalNode >> isZDDTop [
	^ model = #ZDDTop
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
