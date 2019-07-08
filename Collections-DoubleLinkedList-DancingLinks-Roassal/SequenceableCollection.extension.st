Extension { #name : #SequenceableCollection }

{ #category : #'*Collections-DoubleLinkedList-DancingLinks-Roassal' }
SequenceableCollection >> lastButOne [
	"Answer the last element of the receiver"

	^ self at: self size - 1
]
