Extension { #name : #DoubleLinkedListTests }

{ #category : #'*Collections-DoubleLinkedList-DancingLinks-Tests' }
DoubleLinkedListTests >> testRemoveUsingPreviousAndNextLinks [
	| list link |
	list := DoubleLinkedList new.
	list add: 1.
	link := list add: 2.
	list add: 3.
	link remove.
	self assert: list first equals: 1.
	self assert: list last equals: 3.
	self assert: list asArray equals: #(1 3)
]

{ #category : #'*Collections-DoubleLinkedList-DancingLinks-Tests' }
DoubleLinkedListTests >> testRestoreUsingPreviousAndNextLinks [
	| list link |
	list := DoubleLinkedList new.
	list add: 1.
	link := list add: 2.
	list add: 3.
	link remove restore.
	self
		assert: list asArray
		equals: #(1 2 3). link restore restore restore.
	self assert: list asArray equals: #(1 2 3)
]
