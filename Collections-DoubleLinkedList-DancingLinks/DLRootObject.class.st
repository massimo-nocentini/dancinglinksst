Class {
	#name : #DLRootObject,
	#superclass : #DLColumnObject,
	#instVars : [
		'columns'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-dancing objects'
}

{ #category : #accessing }
DLRootObject >> chooseColumn [
	^ self chooseColumnWithWeight: #size withOpt: #<
]

{ #category : #accessing }
DLRootObject >> chooseColumnWithWeight: weightBlock withOpt: optBlock [
	^ self
		untilFixPointOf: [ :ro | ro left ]
		foldr: [ :j :r | 
			(optBlock value: (weightBlock value: j) value: (weightBlock value: r))
				ifTrue: [ j ]
				ifFalse: [ r ] ]
		init: self right
]

{ #category : #accessing }
DLRootObject >> column [
	self shouldNotImplement
]

{ #category : #'as yet unclassified' }
DLRootObject >> columnHasBeenCovered: aDLColumnObject [
	columns clearBit: aDLColumnObject name
]

{ #category : #'as yet unclassified' }
DLRootObject >> columnHasBeenUncovered: aDLColumnObject [
	columns setBit: aDLColumnObject name
]

{ #category : #accessing }
DLRootObject >> columns [
	^ String streamContents: [ :s | columns bits printHexOn: s ]
]

{ #category : #accessing }
DLRootObject >> down [
	^ nil
]

{ #category : #accessing }
DLRootObject >> gridHasBeenCreatedOverColumns: aDictionary [
	columns := BitArray new: aDictionary size withAll: true
]

{ #category : #accessing }
DLRootObject >> size [
	self shouldNotImplement 
]

{ #category : #accessing }
DLRootObject >> up [
	^ nil
]
