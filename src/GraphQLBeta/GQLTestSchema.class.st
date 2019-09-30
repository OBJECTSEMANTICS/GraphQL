"
I have methods for graphql schema
"
Class {
	#name : #GQLTestSchema,
	#superclass : #GQLTestQueryType,
	#category : #'GraphQLBeta-Test-Utils'
}

{ #category : #converting }
GQLTestSchema >> asTextNumber: aNumber [
	^ aNumber asString 
]

{ #category : #'as yet unclassified' }
GQLTestSchema >> cats [
	^ OrderedCollection new 
	add: (GQLCat new name: 'Misi'; nickname: 'Misifus'; yourself);
	add: (GQLCat new name: 'Figaro'; nickname: 'Figaro'; yourself);
	add: (GQLCat new name: 'Minino'; nickname: 'Mini'; yourself);
	yourself
]

{ #category : #'plugin interface' }
GQLTestSchema >> entities [
	^ OrderedCollection new
	add: (GQLTestFilm new name: 'Rambo'; rating: 5; yourself);
	add: (GQLTestFilm new name: 'Harry Potter'; rating: 7; yourself); 
	add: (GQLCat new name: 'Misi'; nickname: 'Misifus'; yourself);
	add: (GQLCat new name: 'Figaro'; nickname: 'Figaro'; yourself);
	add: (GQLCat new name: 'Minino'; nickname: 'Mini'; yourself);
	yourself
]

{ #category : #accessing }
GQLTestSchema >> entity [
	^ self entities first
]

{ #category : #'as yet unclassified' }
GQLTestSchema >> filmsSortedByName: aBoolean [ 
	aBoolean 
	ifTrue: [ ^ self films sort: [ :film1 :film2 | film1 name < film2 name ] ]
	ifFalse: [ ^ self films ]
]

{ #category : #'as yet unclassified' }
GQLTestSchema >> filmsWithNullRating: aRating [
	^ (self films select: [ :film | film rating = aRating ])
		add: nil; yourself.
]

{ #category : #'as yet unclassified' }
GQLTestSchema >> filteredFilmId: aId [
	^ self films detect: [ :film | film id = aId asNumber ]
	ifNone: [ nil ]
]

{ #category : #accessing }
GQLTestSchema >> firstExtendedSearchObject [
	| collection |
	collection := OrderedCollection new 
	add: (self firstSearchObject);
	add: (GQLCat new name: 'Misi'; nickname: 'misi');
	add: (GQLDog new name: 'Firulais'; nickname: 'firulais');
	yourself. 
	^ collection at: (1 to: collection size) first
]

{ #category : #accessing }
GQLTestSchema >> firstSearchObject [
	| collection |
	collection := OrderedCollection new 
		add: 2.4 @  4.5;
		add: (Rectangle origin: (2.4 @ 5) corner: (4 @ 5)); 
		yourself. 
	^ collection at: (1 to: collection size) first
]

{ #category : #'as yet unclassified' }
GQLTestSchema >> genders [
	^ (self films collect: [ :film | film gender ]) asSet
]

{ #category : #'as yet unclassified' }
GQLTestSchema >> informFilm: aGQLFilm id: aInt [
	| film | 
	film := self filteredFilmId: aInt.
	film isNil ifTrue: [ film := aGQLFilm  ].
	^ film
]

{ #category : #'as yet unclassified' }
GQLTestSchema >> informationInputFilm: aGQLTestFilm [
	| gqlTestQuery |
	gqlTestQuery := aGQLTestFilm.
	aGQLTestFilm filmName 
	ifNil: [ gqlTestQuery := self filteredFilmId: aGQLTestFilm id ].
	^ GQLTestQueryType new description: gqlTestQuery filmName; 
							gender: gqlTestQuery gender.
]

{ #category : #testing }
GQLTestSchema >> isEvenNumber: aInt [
	^ aInt even.
]

{ #category : #'as yet unclassified' }
GQLTestSchema >> listOfArrays: aListOfList [
	^ aListOfList 
]

{ #category : #accessing }
GQLTestSchema >> name [
	^ self className
]

{ #category : #'as yet unclassified' }
GQLTestSchema >> nameGendersListGender: aMovieTypes [
	
	aMovieTypes isNotNil 
	ifTrue: [ 
		(self genders includesAll: aMovieTypes) 
		ifTrue: [ ^ aMovieTypes  ]	
	].
	 ^ nil
]

{ #category : #'as yet unclassified' }
GQLTestSchema >> nameOfItem: aNamedEntity [
	^ aNamedEntity name
]

{ #category : #constants }
GQLTestSchema >> pi [
	^ Float pi round: 4.
]

{ #category : #'as yet unclassified' }
GQLTestSchema >> squareRootOf: aFloat [
	^ aFloat sqrt round: 2.
]

{ #category : #accessing }
GQLTestSchema >> totalFilms [
	^ self films size 
]
