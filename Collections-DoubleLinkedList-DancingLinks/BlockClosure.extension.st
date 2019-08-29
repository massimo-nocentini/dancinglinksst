Extension { #name : #BlockClosure }

{ #category : #'*Collections-DoubleLinkedList-DancingLinks' }
BlockClosure >> onEnter: enterBlock onExit: exitBlock [
	^ self onEnter: enterBlock onExit: exitBlock in: [ :result :o | result ]
]

{ #category : #'*Collections-DoubleLinkedList-DancingLinks' }
BlockClosure >> onEnter: enterBlock onExit: exitBlock in: recvBlock [
	| e r o|
	e := enterBlock value.
	r := self cull: e.
	o := exitBlock cull: e cull: r.
	^ recvBlock cull: r cull: o
]
