Class {
	#name : #BaselineOfDancingLinks,
	#superclass : #BaselineOf,
	#category : #BaselineOfDancingLinks
}

{ #category : #baselines }
BaselineOfDancingLinks >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				package: 'Collections-DoubleLinkedList-DancingLinks'
					;
				package: 'Collections-DoubleLinkedList-DancingLinks-Tests'
					with: [ spec requires: 'Collections-DoubleLinkedList-DancingLinks' ];
				
				yourself ]
]
