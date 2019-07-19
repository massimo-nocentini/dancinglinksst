Class {
	#name : #ZDDNode,
	#superclass : #Object,
	#instVars : [
		'model',
		'lower',
		'higher',
		'parent'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-ZDD'
}

{ #category : #accessing }
ZDDNode class >> bottom [
	^  ZDDTerminalNode new
		model: false;
		yourself.
]

{ #category : #accessing }
ZDDNode class >> top [
	^  ZDDTerminalNode new
		model: true;
		yourself.
]

{ #category : #accessing }
ZDDNode >> higher [
	^ higher
]

{ #category : #accessing }
ZDDNode >> higher: anObject [
	higher := anObject.
	anObject parent: self.
]

{ #category : #accessing }
ZDDNode >> isZDDBottom [
	^ false
]

{ #category : #accessing }
ZDDNode >> lower [
	^ lower
]

{ #category : #accessing }
ZDDNode >> lower: anObject [
	lower := anObject.
	
	anObject parent: self
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
	parent := anObject
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
