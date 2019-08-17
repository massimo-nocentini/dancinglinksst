Class {
	#name : #DLColumnObject,
	#superclass : #DLDataObject,
	#instVars : [
		'size',
		'name',
		'root'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-dancing objects'
}

{ #category : #modifying }
DLColumnObject >> cover [
	self coverWith: #yourself
]

{ #category : #modifying }
DLColumnObject >> coverWith: aBlock [
	| n |
	self horizontalLink remove.
	n := 1.	"One update happened in the line above"
	self
		untilFixPointOf: [ :co | co down ]
		do: [ :i | 
			i
				untilFixPointOf: [ :do | do right ]
				do: [ :j | 
					j verticalLink remove.
					n := n + 1.
					j column updateSize: [ :s | s - 1 ] ] ].
	^ aBlock value: n
]

{ #category : #accessing }
DLColumnObject >> root [
	^ root
]

{ #category : #accessing }
DLColumnObject >> root: anObject [
	root := anObject
]

{ #category : #accessing }
DLColumnObject >> size [
^ size
]

{ #category : #accessing }
DLColumnObject >> size: anInteger [ 
	size := anInteger
]

{ #category : #modifying }
DLColumnObject >> uncover [
	self uncoverWith: #yourself
]

{ #category : #modifying }
DLColumnObject >> uncoverWith: aBlock [
	| n |
	n := 0.
	self
		untilFixPointOf: [ :co | co up ]
		do: [ :i | 
			i
				untilFixPointOf: [ :do | do left ]
				do: [ :j | 
					j verticalLink restore.
					n := n + 1.
					j column updateSize: [ :s | s + 1 ] ] ].
	self horizontalLink restore.
	^ aBlock value: n + 1
]

{ #category : #'modifier state' }
DLColumnObject >> updateSize: aBlock [
	size := aBlock value: size
]
