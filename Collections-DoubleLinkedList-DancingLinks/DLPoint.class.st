Class {
	#name : #DLPoint,
	#superclass : #Point,
	#instVars : [
		'primary',
		'secondary'
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
	secondary := primary not
]

{ #category : #accessing }
DLPoint >> secondary [
	^ secondary
]

{ #category : #accessing }
DLPoint >> secondary: anObject [
	secondary := anObject.
	primary := secondary not
]
