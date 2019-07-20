Extension { #name : #Object }

{ #category : #'*Collections-DoubleLinkedList-DancingLinks' }
Object >> onEnter: eBlock do: dBlock onExit: xBlock [
	| e r |
	e := eBlock cull: self.
	r := dBlock cull: e cull: self .
	xBlock cull: e cull: r cull: self.
	^ r
]
