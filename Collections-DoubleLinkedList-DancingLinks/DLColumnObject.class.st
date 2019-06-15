Class {
	#name : #DLColumnObject,
	#superclass : #DLDataObject,
	#instVars : [
		'size',
		'name'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks'
}

{ #category : #'modifier state' }
DLColumnObject >> incrementSize [
	size := size + 1
]

{ #category : #accessing }
DLColumnObject >> name [
	^ name
]

{ #category : #accessing }
DLColumnObject >> name: aString [ 
	name := aString
]

{ #category : #accessing }
DLColumnObject >> size [
^ size
]

{ #category : #accessing }
DLColumnObject >> size: anInteger [ 
	size := anInteger
]
