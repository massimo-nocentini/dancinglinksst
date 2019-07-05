Extension { #name : #DoubleLinkedList }

{ #category : #'*Collections-DoubleLinkedList-DancingLinks' }
DoubleLinkedList class >> circular: aBlock [
	| dll |
	dll := self new.
	aBlock value: dll.
	^ dll makeCircular
]

{ #category : #'*Collections-DoubleLinkedList-DancingLinks' }
DoubleLinkedList >> makeCircular [
	head previousLink: tail.
	tail nextLink: head
]
