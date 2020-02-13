Class {
	#name : #DLColumnObject,
	#superclass : #DLDataObject,
	#instVars : [
		'size',
		'name',
		'root',
		'primary'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-dancing objects'
}

{ #category : #modifying }
DLColumnObject >> cover [
	self horizontalLink remove.
	self
		untilFixPointOf: [ :co | co down ]
		do: [ :i | 
			i
				untilFixPointOf: [ :do | do right ]
				do: [ :j | 
					j verticalLink remove.
					j column updateSize: #decrement ] ].
	self root columnHasBeenCovered: self
]

{ #category : #accessing }
DLColumnObject >> name [
	^ name
]

{ #category : #accessing }
DLColumnObject >> name: anObject [
	name := anObject
]

{ #category : #accessing }
DLColumnObject >> primary [
	^ primary
]

{ #category : #accessing }
DLColumnObject >> primary: anObject [
	primary := anObject
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
	self
		untilFixPointOf: [ :co | co up ]
		do: [ :i | 
			i
				untilFixPointOf: [ :do | do left ]
				do: [ :j | 
					j verticalLink restore.
					j column updateSize: #increment ] ].
	self horizontalLink restore.
	self root columnHasBeenUncovered: self
]

{ #category : #'modifier state' }
DLColumnObject >> updateSize: aBlock [
	size := aBlock value: size
]
