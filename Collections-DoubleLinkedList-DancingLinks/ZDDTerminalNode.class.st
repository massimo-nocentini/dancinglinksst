Class {
	#name : #ZDDTerminalNode,
	#superclass : #ZDDNode,
	#category : #'Collections-DoubleLinkedList-DancingLinks-ZDD'
}

{ #category : #accessing }
ZDDTerminalNode >> isZDDBottom [
	^ self model not
]

{ #category : #accessing }
ZDDTerminalNode >> sets [
	^ self isZDDBottom
		ifTrue: [ Set new ]
		ifFalse: [ Set with: Set new ]
]
