"
I am a simple class that contains benchmarks for this project
"
Class {
	#name : #GraphQLBenchmark,
	#superclass : #GraphQLObject,
	#classInstVars : [
		'objects',
		'lastSize'
	],
	#category : #'GraphQLBeta-Test-Benchmark'
}

{ #category : #benchmarking }
GraphQLBenchmark class >> benchmark01 [
	<script: 'self benchmark01'>
	"This benchmark print resutl for the excel document
	 Variable or expression expected ->https://goo.gl/kSdX2S"
	Transcript 
		show: Smalltalk version; cr;
		show: (Smalltalk vm wordSize = 4 ifTrue: [ 32 ] ifFalse: [ 64 ] ); show: ' bits'.
		
	#('{queryPoints}'
		'{queryPoints { x y } }' 
		'{queryPoints { x } }'
		'{queryPoints { y } }' ) do: [ :query |
		"Transcript cr; cr; show: 'Query: '; show: query."
		#(5000000 4000000 200000 100000) do: [ :s | 
			"Transcript cr; show: 'Points size: '; show: s."
			self benchmarkTimePoints: s query: query ]
		 displayingProgress: [:s | 'Processing bench01 for: ', s asString, ' points '].
	] displayingProgress: [ :q | 'Processing for: ', q].
]

{ #category : #benchmarking }
GraphQLBenchmark class >> benchmark02 [
	<script: 'self benchmark02'>
	Transcript 
		show: Smalltalk version; cr;
		show: (Smalltalk vm wordSize = 4 ifTrue: [ 32 ] ifFalse: [ 64 ] ); show: ' bits'.
	#('{queryRectangles}'
	 	'{queryRectangles { origin corner } }' 
	 	'{queryRectangles { origin } }'
	 	'{queryRectangles { corner } }'
	 	'{queryRectangles { origin { x y } } } ' ) do: [ :query |
		"Transcript cr; show: 'Query: '; show: query."
		
		#(1000000 800000 600000) do: [ :s | 
			"Transcript cr; cr; show: 'Rectangles size: ', s asString."
			self benchmarkTimeRectangles: s query: query ]
		 displayingProgress: [:s | 'Processing bench02 for: ', s asString, ' rectangles'].
	] displayingProgress: [ :q | 'Processing for: ', q ].
]

{ #category : #benchmarking }
GraphQLBenchmark class >> benchmarkPoints: numberOfPoints query: query [
	| g res result |
	g := GraphQL new.
	g rootInstance: self new.
	g createSchema: self schema.
	result := g handleRequest: query.
	res := result at: 'queryPoints'.
	self
		assert: res size = numberOfPoints.
	result := GraphQLPlatform current toJson: result.
	self assert: result isString.
	
	
]

{ #category : #benchmarking }
GraphQLBenchmark class >> benchmarkRectangles: numberOfRectangles query: query [
	| g res result |
	g := GraphQL new.
	g rootInstance: self new.
	g createSchema: self schema.
	result := g handleRequest: query.
	res := result at: 'queryRectangles'.
	self
		assert: res size = numberOfRectangles.
	result := GraphQLPlatform current toJson: result.
	self assert: result isString.
	
	
]

{ #category : #benchmarking }
GraphQLBenchmark class >> benchmarkTimePoints: numberOfPoints query: query [
	"for an array with numberOfPoints instances of points"

	"self benchmarkTimePoints: 1000000 query: '{queryPoints}' "
	self lastSize = numberOfPoints 
		ifFalse: [ self initializePoints: numberOfPoints ].
	self cleanMemory.
	Transcript
		cr;
		"show: 'Bench01 for: ';
		show: numberOfPoints;
		show: ' points';
		cr;
		show: 'Time: ';"
		show: [ self benchmarkPoints: numberOfPoints query: query ] timeToRun asSeconds
]

{ #category : #benchmarking }
GraphQLBenchmark class >> benchmarkTimeRectangles: numberOfRectangles query: query [
	"for an array with numberOfRectangles instances of points"

	"self benchmarkTimePoints: 1000000 query: '{queryPoints}' "
	self lastSize = numberOfRectangles 
		ifFalse: [ self initializeRectangles: numberOfRectangles ].
	self cleanMemory.
	Transcript
		cr;
		"show: 'Bench02 for: ';
		show: numberOfRectangles;
		show: ' rectangles';
		cr;
		show: 'Time: ';"
		show: [ self benchmarkRectangles: numberOfRectangles query: query ] timeToRun asSeconds
]

{ #category : #initialization }
GraphQLBenchmark class >> cleanMemory [
	<script: 'self cleanMemory'>
	3 timesRepeat:[ Smalltalk garbageCollect].
	Object new; new; new.
	3 timesRepeat: [Smalltalk garbageCollect].
]

{ #category : #initialization }
GraphQLBenchmark class >> initializePoints: size [
	<script: 'self initializePoints: 10'>
	objects := OrderedCollection new: size.
	1 to: size do: [ :i | 
		objects add: i asPoint].
	lastSize := size
]

{ #category : #initialization }
GraphQLBenchmark class >> initializeRectangles: size [
	<script: 'self initializeRectangles: 10'>
	objects := OrderedCollection new: size.
	
	1 to: size do: [ :i | 
		objects add: (Rectangle origin: i asPoint corner: i asPoint negated) ].
	lastSize := size
]

{ #category : #accessing }
GraphQLBenchmark class >> lastSize [
	^ lastSize ifNil: [ 0 ].
]

{ #category : #accessing }
GraphQLBenchmark class >> objects [
	^ objects
]

{ #category : #initialization }
GraphQLBenchmark class >> reset [
	<script: 'self reset'>
	objects := nil.
	lastSize := nil.
]

{ #category : #accessing }
GraphQLBenchmark class >> schema [
"The text of the schema"
	^ '
	type GraphQLBenchmark{
		queryPoints: [ Point ]
		queryRectangles: [ Rectangle ]
	},
	type Rectangle{
		origin: Point
		corner: Point
	},
	type Point{
		x : Float
		y : Float
	}'
]

{ #category : #accessing }
GraphQLBenchmark >> queryPoints [
	^ self class objects
]

{ #category : #accessing }
GraphQLBenchmark >> queryRectangles [
	^ self class objects
]
