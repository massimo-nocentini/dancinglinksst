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
	head
		ifNotNil: [ head previousLink: tail.
			tail nextLink: head ]
]

{ #category : #'*Collections-DoubleLinkedList-DancingLinks' }
DoubleLinkedList >> size [
	| size h |
	size := 0.
	h := head.
	[ h isNotNil and: [ h nextLink ~~ head ] ]
		whileTrue: [ size := size + 1.
			h := h nextLink ].
	^ size
]
