Class {
	#name : #DLPoint,
	#superclass : #Point,
	#instVars : [
		'primary'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-dancing objects'
}

{ #category : #accessing }
DLPoint >> primary [
	^ primary
]

{ #category : #accessing }
DLPoint >> primary: anObject [
	primary := anObject.
]
