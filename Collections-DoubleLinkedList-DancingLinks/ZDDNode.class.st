Class {
	#name : #ZDDNode,
	#superclass : #Object,
	#instVars : [
		'model',
		'lower',
		'higher'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-ZDD'
}

{ #category : #accessing }
ZDDNode class >> bottom [ 
^ ZDDTerminalNode new model: false; yourself
]

{ #category : #accessing }
ZDDNode class >> top [
	^ ZDDTerminalNode new
		model: true;
		yourself
]

{ #category : #accessing }
ZDDNode >> higher [
	^ higher
]

{ #category : #accessing }
ZDDNode >> higher: anObject [
	higher := anObject
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
	lower := anObject
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
ZDDNode >> sets [
	| hi |
	hi := self higher sets
		collect: [ :l | 
			l 
				add: self model;
				yourself ].
	^ self lower sets
		addAll: hi;
		yourself
]
