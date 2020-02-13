Class {
	#name : #DLDataObject,
	#superclass : #Object,
	#instVars : [
		'verticalLink',
		'horizontalLink',
		'column',
		'point',
		'model'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-dancing objects'
}

{ #category : #'instance creation' }
DLDataObject class >> gridOn: aCollection [
	| rootObj columns rows headers allObjs primaryCount |
	aCollection
		sort: [ :vAssoc :wAssoc | 
			| v w |
			v := vAssoc key.
			w := wAssoc key.
			v y <= w y and: [ v x <= w x ] ].
	primaryCount := 0.
	allObjs := Dictionary new.
	headers := DoubleLinkedList new.
	columns := Dictionary new.
	rows := Dictionary new.
	rootObj := DLRootObject new
		addInDoubleLinkedList: headers then: #horizontalLink:;
		yourself.
	allObjs at: #root put: rootObj.
	aCollection
		do: [ :anAssociation | 
			| aPoint columnObj dataObj column row |
			aPoint := anAssociation key.
			column := columns
				at: aPoint y
				ifAbsentPut: [ | headerObj newColumn |
					primaryCount := primaryCount + 1.
					headerObj := DLColumnObject new
						name: primaryCount;
						primary: aPoint primary;
						size: 0;
						root: rootObj;
						yourself.
					aPoint primary
						ifTrue:
							[ headerObj addInDoubleLinkedList: headers then: #horizontalLink: ]
						ifFalse: [ DoubleLinkedList
								circular: [ :dll | headerObj addInDoubleLinkedList: dll then: #horizontalLink: ] ].
					newColumn := DoubleLinkedList new.
					headerObj addInDoubleLinkedList: newColumn then: #verticalLink:.
					allObjs at: aPoint y put: headerObj.
					newColumn ].
			columnObj := column first.
			dataObj := self new
				column: columnObj;
				point: aPoint;
				model: anAssociation value;
				yourself.
			row := rows at: aPoint x ifAbsentPut: [ DoubleLinkedList new ].
			dataObj
				addInDoubleLinkedList: column then: #verticalLink:;
				addInDoubleLinkedList: row then: #horizontalLink:.
			columnObj updateSize: [ :s | s + 1 ].
			allObjs at: aPoint put: dataObj ].
	headers makeCircular.
	columns valuesDo: #makeCircular.
	rows valuesDo: #makeCircular.
	rootObj gridHasBeenCreatedOverColumns: columns.
	^ allObjs
]

{ #category : #accessing }
DLDataObject >> addInDoubleLinkedList: aDoubleLinkedList then: aSymbol [
	| doubleLink |
	doubleLink := aDoubleLinkedList add: self.
	self perform: aSymbol with: doubleLink.
]

{ #category : #accessing }
DLDataObject >> asColumnsSet [
	| set r getter |
	getter := [ :o | o point ].
	r := self.
	set := Set with: (getter value: r).
	[ r := r right.
	r == self ] whileFalse: [ set add: (getter value: r) ].
	^ set
]

{ #category : #accessing }
DLDataObject >> column [
	^ column
]

{ #category : #accessing }
DLDataObject >> column: aDLColumnObject [ 
	column := aDLColumnObject
]

{ #category : #accessing }
DLDataObject >> columns [
	^ self
		untilFixPointOf: [ :do | do right ]
		collect:
			[ :c | (c untilFixPointOf: [ :do | do down ] collect: #yourself)  ]
]

{ #category : #accessing }
DLDataObject >> down [
	^ self verticalLink nextLink value
]

{ #category : #accessing }
DLDataObject >> horizontalLink [
	^ horizontalLink
]

{ #category : #accessing }
DLDataObject >> horizontalLink: anObject [
	horizontalLink := anObject
]

{ #category : #querying }
DLDataObject >> isFixPointOf: aSelector [
	
	^ self == (aSelector value: self)
]

{ #category : #accessing }
DLDataObject >> left [
	^ self horizontalLink previousLink value
]

{ #category : #accessing }
DLDataObject >> model [
	^ model
]

{ #category : #accessing }
DLDataObject >> model: anObject [
	model := anObject
]

{ #category : #accessing }
DLDataObject >> point [
	^ point
]

{ #category : #accessing }
DLDataObject >> point: anObject [
	point := anObject
]

{ #category : #accessing }
DLDataObject >> right [
	^ self horizontalLink nextLink value
]

{ #category : #iterating }
DLDataObject >> untilFixPointOf: aSelector collect: aBlockClosure [
	| collection |
	collection := OrderedCollection new.
	self untilFixPointOf: aSelector do: [ :v | collection add: v ].
	^ collection
]

{ #category : #iterating }
DLDataObject >> untilFixPointOf: aSelector do: aBlockClosure [
	| j |
	j := aSelector value: self.
	[ j == self ]
		whileFalse: [ aBlockClosure value: j.
			j := aSelector value: j ]
]

{ #category : #iterating }
DLDataObject >> untilFixPointOf: aSelector foldr: aBlockClosure init: v [
	| acc |
	acc := v.
	self
		untilFixPointOf: aSelector
		do: [ :each | acc := aBlockClosure value: each value: acc ].
	^ acc
]

{ #category : #accessing }
DLDataObject >> up [
	^ self verticalLink previousLink value
]

{ #category : #accessing }
DLDataObject >> verticalLink [
	^ verticalLink 
]

{ #category : #accessing }
DLDataObject >> verticalLink: anObject [
	verticalLink := anObject
]
