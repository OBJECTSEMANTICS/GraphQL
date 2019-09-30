"
I represent a test query to test graphql request

Public API and Key Messages

- films
- hello

"
Class {
	#name : #GQLTestQueryType,
	#superclass : #Object,
	#instVars : [
		'description',
		'gender',
		'rating',
		'boxOffice',
		'isBoxOffice'
	],
	#category : #'GraphQLBeta-Test-Utils'
}

{ #category : #'instance creation' }
GQLTestQueryType class >> new: aGQLTestQueryType [
	| instance |
	instance := GQLTestQueryType new.
	instance rating: aGQLTestQueryType rating.
	instance boxOffice: aGQLTestQueryType boxOffice.
	instance gender: aGQLTestQueryType gender.
	instance isBoxOffice: aGQLTestQueryType isBoxOffice.
	instance description: aGQLTestQueryType description.
	instance gender: aGQLTestQueryType gender.
	^ instance
	
	
]

{ #category : #accessing }
GQLTestQueryType class >> schema [
	^'
	schema { 
		query: GQLTestQueryType
		mutation: GQLTestMutationType
	}
type GQLTestMutationType{
	createPoint(x:Int, y:Int) : Point
}
type Point{
	x : Int
	y : Int
}
input GQLTestFilmInput{
	id: Int
	filmName: String
}
input GQLTestQueryTypeInput{
	description: String
	gender: String
}
type GQLTestQueryType{
	hello : String
	helloTo(name:String) : String
	films : [ GQLTestFilm ]
	filmsWith(rating : Int) : [ GQLTestFilm ]
	information(film: GQLTestFilmInput) : GQLTestFilm
	detailedInformation(film: GQLTestQueryTypeInput): GQLTestQueryType
	totalInformation(film: [GQLTestQueryTypeInput]): [ GQLTestQueryType]
	informationInput(film: GQLFilmInput): GQLTestQueryType
	features(film: GQLFilmInput): String
	classification(gender: MovieType): String
	filmsOf(gender: MovieType): [ GQLTestFilm ]
	filmsOn(genders: [MovieType]): [ GQLTestFilm ]
	film(name:String, rating: Int): GQLFilm
	listOfInts(ints: [Int]): [ Int ]
	gender: String
	boxOffice: Float
	rating: Int
	isBoxOffice: Bool
	description: String
},
type GQLFilm implements NamedEntity & IdentifiedEntity{
	filmName : String
	id : Int
	get(filmName: String): String
},
type GQLTestFilm{
	id : String
	name : String
	film: GQLFilm
	rating : Int
	description: String
},
input GQLFilmInput {
	filmName: String
	id: Int
}
interface NamedEntity{
	filmName: String
}
interface IdentifiedEntity{
	id: Int
}
enum MovieType{COMEDY, SCIENCE_FICTION, DRAMA, ACTION}'
]

{ #category : #accessing }
GQLTestQueryType >> boxOffice [
	^ boxOffice
]

{ #category : #accessing }
GQLTestQueryType >> boxOffice: anObject [
	boxOffice := anObject
]

{ #category : #'as yet unclassified' }
GQLTestQueryType >> classificationGender: aClassification [
	(self classifications includes: aClassification) 
	ifTrue: [ ^ aClassification  ] 
	ifFalse: [ ^ nil ]
]

{ #category : #'as yet unclassified' }
GQLTestQueryType >> classifications [
	^ #('COMEDY' 'SCIENCE_FICTION' 'ACTION')
]

{ #category : #accessing }
GQLTestQueryType >> description [
	^ description
]

{ #category : #accessing }
GQLTestQueryType >> description: anObject [
	description := anObject
]

{ #category : #'as yet unclassified' }
GQLTestQueryType >> detailedInformationFilm: aGQLTestQueryType [
	^ GQLTestQueryType new: aGQLTestQueryType. 
]

{ #category : #accessing }
GQLTestQueryType >> featuresFilm: aGQLFilm [
	^ aGQLFilm filmName
]

{ #category : #accessing }
GQLTestQueryType >> filmName: aName rating: aRating [
	^ self films detect: [ :film | ((film name = aName) & (film rating = aRating))  ]
]

{ #category : #accessing }
GQLTestQueryType >> films [
	| data |
	data := OrderedCollection new.
	data add: (GQLTestFilm new: 1 name: 'harry potter y la piedra filosofal' rating: 9 gender: 'SCIENCE_FICTION'). 
	data addLast: (GQLTestFilm new: 2 name: 'el señor de los anillos' rating: 8 gender: 'SCIENCE_FICTION'). 
	data addLast: (GQLTestFilm new: 3 name: 'terminator' rating: 5 gender: 'SCIENCE_FICTION'). 
	data addLast: (GQLTestFilm new: 4 name: 'rambo' rating: 5 gender: 'ACTION'). 
	data addLast: (GQLTestFilm new: 5 name: 'robocop' rating: 5 gender: 'SCIENCE_FICTION'). 
	data addLast: (GQLTestFilm new: 6 name: 'alien' rating: 7 gender: 'SCIENCE_FICTION'). 
	data addLast: (GQLTestFilm new: 7 name: 'annie' rating: 6 gender: 'COMEDY'). 
	^ data
]

{ #category : #'as yet unclassified' }
GQLTestQueryType >> filmsOfGender: aGender [
	^ self films select: [ :f | f gender = aGender ]
]

{ #category : #'as yet unclassified' }
GQLTestQueryType >> filmsOnGenders: listGender [
	^ self films select: [ :f | listGender includes: f gender ]
]

{ #category : #accessing }
GQLTestQueryType >> filmsWithRating: aRating [
	aRating < 0 ifTrue: [ ^ nil ].
	^ self films select: [ :film | film rating = aRating ]
]

{ #category : #accessing }
GQLTestQueryType >> gender [
	^ gender
]

{ #category : #accessing }
GQLTestQueryType >> gender: anObject [
	gender := anObject
]

{ #category : #accessing }
GQLTestQueryType >> hello [
	^ 'hello world'
]

{ #category : #accessing }
GQLTestQueryType >> helloToName: aName [ 
	aName ifNil: [ ^ nil ].
	^ 'hello ' , aName
]

{ #category : #'as yet unclassified' }
GQLTestQueryType >> informationFilm: aGQLTestFilm [
	self description: aGQLTestFilm description.
	^ GQLTestFilm new: aGQLTestFilm id name: aGQLTestFilm description  rating: aGQLTestFilm rating gender: aGQLTestFilm gender. 
]

{ #category : #'as yet unclassified' }
GQLTestQueryType >> informationInputFilm: aGQLFilm [
	^ GQLTestQueryType new description: aGQLFilm filmName; 
							gender: 'gender'. 
]

{ #category : #accessing }
GQLTestQueryType >> isBoxOffice [
	^ isBoxOffice
]

{ #category : #accessing }
GQLTestQueryType >> isBoxOffice: anObject [
	isBoxOffice := anObject
]

{ #category : #accessing }
GQLTestQueryType >> listOfIntsInts: list [
	^ list
]

{ #category : #accessing }
GQLTestQueryType >> pointX: x y: y [ 
	x ifNil: [ ^ nil ].
	^ x @ y
]

{ #category : #accessing }
GQLTestQueryType >> rating [
	^ rating
]

{ #category : #accessing }
GQLTestQueryType >> rating: anObject [
	rating := anObject
]

{ #category : #accessing }
GQLTestQueryType >> totalInformationFilm: aArrayGQLTestQueryType [
	^ aArrayGQLTestQueryType.
]
