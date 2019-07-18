Class {
	#name : #DLSolution,
	#superclass : #Object,
	#instVars : [
		'substitution',
		'updates'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-dancing objects'
}

{ #category : #copying }
DLSolution >> copy [
	^ self class new 
		substitution: substitution copy;
		updates: updates;
		yourself
]

{ #category : #accessing }
DLSolution >> substitution [
	^ substitution
]

{ #category : #accessing }
DLSolution >> substitution: anObject [
	substitution := anObject
]

{ #category : #accessing }
DLSolution >> updates [
	^ updates
]

{ #category : #accessing }
DLSolution >> updates: anObject [
	updates := anObject
]

{ #category : #accessing }
DLSolution >> updatesWith: aBlock [
	updates := aBlock value: updates
]
