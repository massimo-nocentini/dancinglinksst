Class {
	#name : #RTRoundedMultiLine,
	#superclass : #RTMultiLine,
	#instVars : [
		'radius'
	],
	#category : #'Collections-DoubleLinkedList-DancingLinks-Roassal'
}

{ #category : #public }
RTRoundedMultiLine >> bezierShape: shape points: points withColor: c withWidth: w [
	^ shape
		color: c;
		width: w;
		points: points;
		yourself
]

{ #category : #public }
RTRoundedMultiLine >> composeShapeForPath: path
				withRadius: r
				withColor: c
				withWidth: w [
				| shapes |
			shapes := (2 to: path size - 1)
				flatCollect: [ :i | 
					| prev current next |
					prev := path at: i - 1.
					current := path at: i.
					next := path at: i + 1.
					prev
						through: current
						to: next
						ifAligned: [  ]
						ifCuspid: [  ]
						ifNorthEast: [ self
								handleNorthEastFrom: prev
								to: current
								withRadius: r
								withColor: c
								withWidth: w ]
						ifNorthWest: [  ]
						ifSouthWest: [ self
								handleSouthWestFrom: prev
								to: current
								withRadius: r
								withColor: c
								withWidth: w ]
						ifSouthEast: [  ] ].
	^		self
				composeShapes: shapes
				ofPath: path
				withRadius: r
				withColor: c
				withWidth: w 
]

{ #category : #public }
RTRoundedMultiLine >> composeShapes: shapes ofPath: path withRadius: r withColor: c withWidth: w [
	| multiShape lastButOnePoint |
	multiShape := TRCompositeShape new.
	shapes do: [ :shape | multiShape addShape: shape ].
	lastButOnePoint := path lastButOne y = path last y
		ifTrue: [ r @ 0 ]
		ifFalse: [ 0 @ r ].
	multiShape
		addShape:
			(self
				lineShape: TRLineShape new from: path lastButOne + lastButOnePoint
				to: path last
				withColor: c
				withWidth: w).
	^ multiShape
]

{ #category : #public }
RTRoundedMultiLine >> handleNorthEastFrom: prev to: current withRadius: r withColor: c withWidth: w [
	| mid1 mid2 points |
	mid1 := current x @ (current y - r).
	mid2 := (current x + r) @ current y.
	points := Array with: mid1 with: current with: mid2.
	^ Array
		with:
			(self
				lineShape: TRLineShape new
				from: prev + (0 @ r)
				to: mid1
				withColor: c
				withWidth: w)
		with: (self bezierShape: TRBezierShape new points: points withColor: c withWidth: w)
]

{ #category : #public }
RTRoundedMultiLine >> handleSouthWestFrom: prev to: current withRadius: r withColor: c withWidth: w [
	| mid1 mid2 points |
	mid1 := (current x - r) @ current y.
	mid2 := current x @ (current y + r).
	points := Array with: mid1 with: current with: mid2.
	^ Array
		with:
			(self
				lineShape: TRLineShape new
				from: prev + (r @ 0)
				to: mid1
				withColor: c
				withWidth: w)
		with: (self bezierShape: TRBezierShape new points: points withColor: c withWidth: w)
]

{ #category : #public }
RTRoundedMultiLine >> initialize [
	super initialize.
	radius := 0
]

{ #category : #public }
RTRoundedMultiLine >> lineShape: shape from: fromPoint to: toPoint withColor: col withWidth: w [
	^ shape
		from: fromPoint to: toPoint;
		color: col;
		width: w;
		yourself
]

{ #category : #accessing }
RTRoundedMultiLine >> radius [
	^ radius
]

{ #category : #accessing }
RTRoundedMultiLine >> radius: anObject [
	radius := anObject
]

{ #category : #public }
RTRoundedMultiLine >> trachelShapeFor: anEdge [
	| fromPoint toPoint path c w r |
	c := self colorFor: anEdge.
	w := self widthFor: anEdge.
	r := radius + w.
	fromPoint := attachPoint startingPointOf: anEdge.
	toPoint := attachPoint endingPointOf: anEdge.
	path := blockProducingPath value: fromPoint value: toPoint.
	^ path size = 2
		ifTrue: [ self
				lineShape: TRLineShape new from: path first
				to: path last
				withColor: c
				withWidth: w ]
		ifFalse: [ self
				composeShapeForPath: path
				withRadius: r
				withColor: c
				withWidth: w ]
]

{ #category : #public }
RTRoundedMultiLine >> updateFor: anEdge trachelShape: trachelShape [
]
