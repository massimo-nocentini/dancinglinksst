Class {
	#name : #ZDDNode,
	#superclass : #Object,
	#instVars : [
		'model',
		'lower',
		'higher',
		'parent',
		'additionalParents'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-ZDD'
}

{ #category : #accessing }
ZDDNode class >> bottom [
	^ ZDDTerminalNode new
		model: #ZDDBottom;
		yourself
]

{ #category : #accessing }
ZDDNode class >> top [
	^ ZDDTerminalNode new
		model: #ZDDTop;
		yourself
]

{ #category : #accessing }
ZDDNode >> additionalParents [
^ additionalParents
]

{ #category : #visiting }
ZDDNode >> depth [
	^ self isRoot
		ifTrue: [ 0 ]
		ifFalse: [ self parent depth + 1 ]
]

{ #category : #accessing }
ZDDNode >> higher [
	^ higher
]

{ #category : #accessing }
ZDDNode >> higher: anObject [
	higher := anObject.
]

{ #category : #accessing }
ZDDNode >> initialize [
	additionalParents := Set new
]

{ #category : #accessing }
ZDDNode >> isRoot [
	^ self parent isNil 
]

{ #category : #accessing }
ZDDNode >> isZDDBottom [
	^ false
]

{ #category : #accessing }
ZDDNode >> isZDDTop [
^ false
]

{ #category : #accessing }
ZDDNode >> lower [
	^ lower
]

{ #category : #accessing }
ZDDNode >> lower: anObject [
	lower := anObject.
]

{ #category : #accessing }
ZDDNode >> model [
	^ model
]

{ #category : #accessing }
ZDDNode >> model: anObject [
	model := anObject
]

{ #category : #accessing }
ZDDNode >> parent [
	^ parent
]

{ #category : #accessing }
ZDDNode >> parent: anObject [
	parent ifNil:[
	parent := anObject] ifNotNil: [ additionalParents add: anObject ]
]

{ #category : #accessing }
ZDDNode >> root [
 ^ parent ifNil: [ self ] ifNotNil: [ parent root ]
]

{ #category : #accessing }
ZDDNode >> sets [
	| hi |
	hi := self higher sets copy
		collect: [ :l | 
			l copy
				add: self model;
				yourself ].
	^ self lower sets copy
		addAll: hi;
		yourself
]

{ #category : #accessing }
ZDDNode >> subtree [
	^ Set new
		addAll: lower subtree;
		add: self;
		addAll: higher subtree;
		yourself
]
