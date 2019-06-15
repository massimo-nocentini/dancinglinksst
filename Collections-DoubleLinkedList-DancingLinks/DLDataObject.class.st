Class {
	#name : #DLDataObject,
	#superclass : #Object,
	#instVars : [
		'ns',
		'we',
		'column'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks'
}

{ #category : #'instance creation' }
DLDataObject class >> gridOn: aCollection [
	| rootObj columns rows headers allObjs |
	aCollection sort: [ :v :w | v y <= w y and: [ v x <= w x ] ].
	allObjs := Dictionary new.
	headers := DoubleLinkedList new.
	columns := Dictionary new.
	rows := Dictionary new.
	rootObj := DLRootObject new
		addInDoubleLinkedList: headers direction: #we;
		yourself.
	allObjs at: #root put: rootObj.
	aCollection
		do: [ :aPoint | 
			| columnObj dataObj column row |
			column := columns
				at: aPoint y
				ifAbsentPut: [ | headerObj newColumn |
					headerObj := DLColumnObject new
						name: 'C' , aPoint y asString;
						size: 0;
						yourself.
					newColumn := DoubleLinkedList new.
					headerObj
						addInDoubleLinkedList: newColumn direction: #ns;
						addInDoubleLinkedList: headers direction: #we.
					allObjs at: aPoint y put: headerObj.
					newColumn ].
			columnObj := column first.
			dataObj := DLDataObject new
				column: columnObj;
				yourself.
			row := rows at: aPoint x ifAbsentPut: [ DoubleLinkedList new ].
			dataObj
				addInDoubleLinkedList: column direction: #ns;
				addInDoubleLinkedList: row direction: #we.
			columnObj incrementSize.
			allObjs at: aPoint put: dataObj ].
	headers makeCircular.
	columns valuesDo: #makeCircular.
	rows valuesDo: #makeCircular.
	^ allObjs 
]

{ #category : #accessing }
DLDataObject >> addInDoubleLinkedList: aDoubleLinkedList direction: aSymbol [ 
	|doubleLink|
	doubleLink := aDoubleLinkedList add: self.
	aSymbol = #ns ifTrue:[ ns := doubleLink ] ifFalse: [ we := doubleLink  ]
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
DLDataObject >> down [
	^ ns nextLink value
]

{ #category : #accessing }
DLDataObject >> left [
	^ we previousLink value
]

{ #category : #accessing }
DLDataObject >> right [
	^ we nextLink value
]

{ #category : #accessing }
DLDataObject >> up [
	^ ns previousLink value
]
