Class {
	#name : #DLRootObject,
	#superclass : #DLColumnObject,
	#category : #'Collections-DoubleLinkedList-DancingLinks-dancing objects'
}

{ #category : #accessing }
DLRootObject >> chooseColumn [
	^ self chooseColumnWithWeight: #size withOpt: [ :x :y | x < y ]
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

{ #category : #accessing }
DLRootObject >> down [
	^ nil
]

{ #category : #accessing }
DLRootObject >> size [
	self shouldNotImplement 
]

{ #category : #accessing }
DLRootObject >> up [
	^ nil
]
