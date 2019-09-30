"
On my class side is defined the schema text and at my instance side are defined all the methods that are called by the schema.
 
"
Class {
	#name : #GQLQuery,
	#superclass : #Object,
	#category : #'GraphQLBeta-Demo'
}

{ #category : #accessing }
GQLQuery class >> schema [
"The text of the schema"
	^ 'union Queries = GQLQuery
	union Shape = Rectangle | Point
	enum FilmType { ACTION, COMEDY, DRAMA }
	enum ShapeType { RECTANGLE, POINT, ROMBUS, TRAPEZOID }
	
	schema{
		query: GQLQuery
		mutation: GQLMutation
	}
	
	type GQLMutation{
		createRectangle(left: Int, right: Int, top: Int, bottom: Int) : Rectangle
		createPoint(x:Int, y: Int) : Point
	}
	
	type GQLQuery{
			hello: String
			allClasses : [ Class ]
			allClassesStarting(with: String) : [ Class ]
			allRectangles : [ Rectangle ]
			allFilms: [ Film ]
			film(name:String):Film
			filmsDirected(by:PersonInput):[Film]
			filmsDirectors(included:[PersonInput]):[Film]
			filmsOn(gender: FilmType) : [ Film ]
			helloMessage(to:PersonInput):String
			shapeOf(type: ShapeType): [ Shape ]
			firstShapesOf(type: ShapeType): [ Shape ]
			directorsAndFilms: [ namedItem ]
	   },
	
		interface namedItem{
			name : String
		}
		input PersonInput{
			name : String
		}
		type Film implements namedItem{
			name : String
			rating : Int
			director : Person
			gender : FilmType
		},
		type Person implements namedItem{
			name : String
			age : Int
		}
	   type Class implements namedItem{
			name : String
			methods : [ CompiledMethod ]
		},
		type CompiledMethod{
			selector : String
		},
		type Rectangle{
			origin : Point
			corner : Point
		},
		type Point{
			x : Float
			y : Float
		}'
]

{ #category : #accessing }
GQLQuery >> allClasses [

	^ Smalltalk allClasses.
]

{ #category : #accessing }
GQLQuery >> allClassesStartingWith: aName [

	^ self allClasses select: [ :c | c name beginsWith: aName ]
]

{ #category : #accessing }
GQLQuery >> allFilms [
	^ OrderedCollection new 
		add: (Film
			name: 'terminator'
			rating: 5
			director: (Person name: 'James Cameron' age: 35)
			gender: 'ACTION');
		add: (Film
			name: 'Star wars: New Hope'
			rating: 9
			director: (Person name: 'George Lucas' age: 35)
			gender: 'SCIENCE_FICTION');
		add: (Film
			name: 'Star wars: The Clone Wars'
			rating: 6
			director: (Person name: 'George Lucas' age: 35)
			gender: 'SCIENCE_FICTION');
		add: (Film
			name: 'Star wars: The Empire Strikes Back'
			rating: 8
			director: (Person name: 'Irvin Kershner' age: 35)
			gender: 'SCIENCE_FICTION');
		add: (Film
			name: 'Star wars: Return of Jedi'
			rating: 7
			director: (Person name: 'Richard Marquand' age: 35)
			gender: 'SCIENCE_FICTION');
		add: (Film
			name: 'Star wars: The Phantom Menace'
			rating: 6
			director: (Person name: 'George Lucas' age: 35)
			gender: 'SCIENCE_FICTION');
		add: (Film
			name: 'Star wars: Attack of the Clones'
			rating: 6
			director: (Person name: 'George Lucas' age: 35)
			gender: 'SCIENCE_FICTION');
		yourself
]

{ #category : #accessing }
GQLQuery >> allRectangles [

	^ Rectangle allInstances.
]

{ #category : #accessing }
GQLQuery >> allTypeFilms [
	^ Array with: 'ACTION' with: 'SCIENCE_FICTION'
]

{ #category : #accessing }
GQLQuery >> directorsAndFilms [
	| collect |
	collect := OrderedCollection new.
	collect addAll: self allFilms.
	collect addAll: (self allFilms collect: [:film | film director]) asSet.
	^ collect.
]

{ #category : #accessing }
GQLQuery >> filmName: aName [

	^ self allFilms detect: [ :f | f name = aName ]
					  ifNone: [ nil ]
]

{ #category : #accessing }
GQLQuery >> filmNamesOfType: aString [
	(self allTypeFilms includes: aString ) 
	ifTrue: [ ^ (self filmsOnGender: aString) collect: [ :film | film name ] ].
	^ self allTypeFilms 
]

{ #category : #accessing }
GQLQuery >> filmsDirectedBy: aPerson [

	^ self allFilms select: [ :f | f director name = aPerson name ]
]

{ #category : #accessing }
GQLQuery >> filmsDirectorsIncluded: aCollection [
	| names |
	names := aCollection collect: #name.
	^ self allFilms select: [ :f | names includes: (f director name) ]
]

{ #category : #accessing }
GQLQuery >> filmsOnGender: aGender [

	^ self allFilms select: [ :f | f gender = aGender ]
]

{ #category : #accessing }
GQLQuery >> firstShapesOfType: aType [
	aType = 'RECTANGLE'
	ifTrue: [ ^ self allRectangles copyFrom: 1 to: 100  ]
	ifFalse: [ aType = 'POINT' 
		ifTrue: [ ^ Point allInstances copyFrom: 1 to: 100 ]
		ifFalse: [^ #() ]
	]
]

{ #category : #accessing }
GQLQuery >> hello [
	^ 'hello'
]

{ #category : #accessing }
GQLQuery >> helloMessageTo: aPerson [
	^ 'hello ', aPerson name
]

{ #category : #accessing }
GQLQuery >> shapeOfType: aType [
	aType = 'RECTANGLE'
	ifTrue: [ ^ self allRectangles  ]
	ifFalse: [ aType = 'POINT' 
		ifTrue: [ ^ Point allInstances]
		ifFalse: [^ #() ]
	]
]
