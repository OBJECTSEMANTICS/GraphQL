"
A GQLDocumentNodeTest is a test class for testing the behavior of GQLDocumentNode
"
Class {
	#name : #GQLDocumentNodeTest,
	#superclass : #GQLTest,
	#category : #'GraphQLBeta-Tests-Nodes'
}

{ #category : #parsing }
GQLDocumentNodeTest >> requestEvaluator [

	^ GQLSingleAnonimousQueryEvaluator
]

{ #category : #initialization }
GQLDocumentNodeTest >> setUp [
	schema := self parseSchema: GQLTestQueryType schema.
	schema := schema validate.
	rootInstance := GQLTestQueryType new.
	schema root: rootInstance.
	withData := false
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsExcludeWithTwoDirective [
	| response |
	response := self attendRequest: '{
		filmsWith(rating: 5) @skip(if : true) @include(if : true){
			name
		}
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		filmsWith(rating: 5) @skip(if : true) @include(if : false){
			name
		}
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		filmsWith(rating: 5) @include(if : false) @skip(if : true){
			name
		}
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		filmsWith(rating: 5) @skip(if : false) @include(if : false){
			name
		}
	}'.
	
	self assert: response isEmpty.
	
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsIncludeWithTwoDirective [
	| response |
	response := self attendRequest: '{
		filmsWith(rating: 5) @skip(if : false) @include(if : true){
			name
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	
	response := self attendRequest: '{
		filmsWith(rating: 5) @include(if : true) @skip(if : false){
			name
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsWithDirectiveExclude [

	| response |
	response := self attendRequest: '{
		filmsWith(rating: 5) @skip(if : true){
			name
		}
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		filmsWith(rating: 5) @include(if : false){
			name
		}
	}'.
	
	self assert: response isEmpty.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsWithDirectiveInclude [

	| response expectedValues |
	response := self attendRequest: '{
		filmsWith(rating: 5) @skip(if : false){
			name
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	expectedValues := (response at: 'filmsWith') collect: [ :res | res at: 'name' ].
	self assert: expectedValues asArray equals: #('terminator' 'rambo' 'robocop').
	
	response := self attendRequest: '{
		filmsWith(rating: 5) @include(if : true){
			name
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	expectedValues := (response at: 'filmsWith') collect: [ :res | res at: 'name' ].
	self assert: expectedValues asArray equals: #('terminator' 'rambo' 'robocop').
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsWithDuplicateDirective [
	| text |
	text := '{
		filmsWith(rating: 5) @skip(if : false) @skip(if : true){
			name
		}
	}'.
	
	self should: [ self attendRequest: text ] raise: GQLException.
	
	text := '{
		filmsWith(rating: 5) @include(if : true) @include(if : false){
			name
		}
	}'.
	
	self should: [ self attendRequest: text ] raise: GQLException.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsWithEnumType [
	| response |
	response := self attendRequest: '{
		filmsOf(gender: ACTION){
			name
			rating
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	response := response at: 'filmsOf'.
	self assert: response class: OrderedCollection .
	self assert: response size equals: 1.
	self assert: (response first at: 'name') equals: 'rambo'.
	self assert: (response first at: 'rating') equals: 5.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsWithEnumTypeAndAlias [
	| response |
	response := self attendRequest: '{
		filmsOfAction: filmsOf(gender: ACTION){
			name
			rating
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	response := response at: 'filmsOfAction'.
	self assert: response class: OrderedCollection .
	self assert: response size equals: 1.
	self assert: (response first at: 'name') equals: 'rambo'.
	self assert: (response first at: 'rating') equals: 5.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsWithEnumTypeAndDirectivesExclude [
	| response |
	response := self attendRequest: '{
		filmsOf(gender: ACTION) @skip(if: true){
			name
			rating
		}
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		filmsOf(gender: ACTION) @include(if: false){
			name
			rating
		}
	}'.
	
	self assert: response isEmpty.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsWithEnumTypeAndDirectivesInclude [
	| response |
	response := self attendRequest: '{
		filmsOf(gender: ACTION) @skip(if: false){
			name
			rating
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	response := response at: 'filmsOf'.
	self assert: response class: OrderedCollection .
	self assert: response size equals: 1.
	self assert: (response first at: 'name') equals: 'rambo'.
	self assert: (response first at: 'rating') equals: 5.
	
	response := self attendRequest: '{
		filmsOf(gender: ACTION) @include(if: true){
			name
			rating
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	response := response at: 'filmsOf'.
	self assert: response class: OrderedCollection .
	self assert: response size equals: 1.
	self assert: (response first at: 'name') equals: 'rambo'.
	self assert: (response first at: 'rating') equals: 5.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsWithListEnumType [
	| response |
	response := self attendRequest: '{
		filmsOn(genders: [ACTION, SCIENCE_FICTION]){
			name
			rating
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	response := response at: 'filmsOn'.
	self assert: response class: OrderedCollection .
	self assert: response size equals: 6.
	self assert: (response first at: 'name') equals: 'harry potter y la piedra filosofal'.
	self assert: (response second at: 'name') equals: 'el señor de los anillos'.
	self assert: (response third at: 'name') equals: 'terminator'.
	self assert: (response fourth at: 'name') equals: 'rambo'.
	self assert: (response fifth at: 'name') equals: 'robocop'.
	self assert: (response sixth at: 'name') equals: 'alien'.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsWithManyVariable [
	| response text textVariables |
	text := '
	query operationVariables($name: String, $gender: MovieType, $rating: Int, 
							$film: GQLFilmInput, $genders: [ MovieType ]){
		features(film: $film)
		helloTo(name: $name)
		classification(gender: $gender)
		filmsWith(rating: $rating){
			name
		}
		filmsOn(genders: $genders){
			name
			rating
		}
	}
	'.
	textVariables := '{"name":"Alex", "gender": ACTION, "rating": 8, 
							"film": {filmName : "harry potter y la piedra filosofal"}, 
							"genders": [COMEDY, ACTION]}'.
	response := self attendRequest: text using: 'operationVariables' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'features') equals: 'harry potter y la piedra filosofal'.
	self assert: (response at:'helloTo') equals: 'hello Alex'.
	self assert: (response at: 'classification') equals: 'ACTION'.
	self assert: (response at: 'filmsWith') class: OrderedCollection.
	self assert: ((response at: 'filmsWith') first at: 'name') equals: 'el señor de los anillos'.
	self assert: ((response at: 'filmsOn') first at: 'name') equals: 'rambo'.
	self assert: ((response at: 'filmsOn') first at: 'rating') equals: 5.
	self assert: ((response at: 'filmsOn') second at: 'name') equals: 'annie'.
	self assert: ((response at: 'filmsOn') second at: 'rating') equals: 6.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsWithVariableAndDirectiveExclude [
	| text textVariables nameOperation response |
	text := '
	query operationVariables($name: String, $gender: MovieType,
							$film: GQLFilm, $genders: [ MovieType ]){
		features(film: $film) @skip(if: true)
		helloTo(name: $name) @skip(if: true)
		classification(gender: $gender) @skip(if: true)
		filmsOn(genders: $genders) @skip(if: true){
			name
			rating
		}
	}
	'.
	nameOperation := 'operationVariables'.
	textVariables := '{"name":"Alex", "gender": ACTION, 
							"film": {filmName : "harry potter y la piedra filosofal"}, 
							"genders": [COMEDY, ACTION]}'.
	response := self attendRequest: text using: nameOperation with: textVariables.
	self assert: response isEmpty.
	
	text := '
	query operationVariables($name: String, $gender: MovieType,
							$film: GQLFilm, $genders: [ MovieType ]){
		features(film: $film) @include(if: false)
		helloTo(name: $name) @include(if: false)
		classification(gender: $gender) @include(if: false)
		filmsOn(genders: $genders) @include(if: false){
			name
			rating
		}
	}
	'.
	response := self attendRequest: text using: nameOperation with: textVariables.
	self assert: response isEmpty.
	
   
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestArgumentsWithVariableAndDirectiveInclude [
	| response text textVariables |
	text := '
	query operationVariables($name: String, $gender: MovieType, $rating: Int, 
							$film: GQLFilm, $genders: [ MovieType ]){
		features(film: $film) @skip(if:false)
		helloTo(name: $name)  @skip(if:false)
		classification(gender: $gender)  @skip(if:false)
		filmsWith(rating: $rating)  @skip(if:false){
			name
		}
		filmsOn(genders: $genders)  @skip(if:false){
			name
			rating
		}
	}
	'.
	textVariables := '{"name":"Alex", "gender": ACTION, "rating": 8, 
							"film": {filmName : "harry potter y la piedra filosofal"}, 
							"genders": [COMEDY, ACTION]}'.
	response := self attendRequest: text using: 'operationVariables' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'features') equals: 'harry potter y la piedra filosofal'.
	self assert: (response at:'helloTo') equals: 'hello Alex'.
	self assert: (response at: 'classification') equals: 'ACTION'.
	self assert: (response at: 'filmsWith') class: OrderedCollection.
	self assert: ((response at: 'filmsWith') first at: 'name') equals: 'el señor de los anillos'.
	self assert: ((response at: 'filmsOn') first at: 'name') equals: 'rambo'.
	self assert: ((response at: 'filmsOn') first at: 'rating') equals: 5.
	self assert: ((response at: 'filmsOn') second at: 'name') equals: 'annie'.
	self assert: ((response at: 'filmsOn') second at: 'rating') equals: 6.
	
	text := '
	query operationVariables($name: String, $gender: MovieType, $rating: Int, 
							$film: GQLFilm, $genders: [ MovieType ]){
		features(film: $film) @include(if:true)
		helloTo(name: $name)  @include(if:true)
		classification(gender: $gender)  @include(if:true)
		filmsWith(rating: $rating)  @include(if:true){
			name
		}
		filmsOn(genders: $genders)  @include(if:true){
			name
			rating
		}
	}
	'.
	response := self attendRequest: text using: 'operationVariables' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'features') equals: 'harry potter y la piedra filosofal'.
	self assert: (response at:'helloTo') equals: 'hello Alex'.
	self assert: (response at: 'classification') equals: 'ACTION'.
	self assert: (response at: 'filmsWith') class: OrderedCollection.
	self assert: ((response at: 'filmsWith') first at: 'name') equals: 'el señor de los anillos'.
	self assert: ((response at: 'filmsOn') first at: 'name') equals: 'rambo'.
	self assert: ((response at: 'filmsOn') first at: 'rating') equals: 5.
	self assert: ((response at: 'filmsOn') second at: 'name') equals: 'annie'.
	self assert: ((response at: 'filmsOn') second at: 'rating') equals: 6.
	
   
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestExcludeWithTwoDirective [
	| response |
	response := self attendRequest: '{
		films @skip(if : true) @include(if : true){
			name
		}
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		films @skip(if : true) @include(if : false){
			name
		}
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		films @include(if : false) @skip(if : true){
			name
		}
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		films @skip(if : false) @include(if : false){
			name
		}
	}'.
	
	self assert: response isEmpty.
	
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestIncludeWithTwoDirective [
	| response |
	response := self attendRequest: '{
		films @skip(if : false) @include(if : true){
			name
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	
	response := self attendRequest: '{
		films @include(if : true) @skip(if : false){
			name
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestInterpretWithInputObject [
	| response  |
	response := self attendRequest: '{
		hello
		information(film: {
			description : "Fiction science movie",
			gender : "Fiction science"
		}) { 
				description
		 }
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'hello') equals: 'hello world'.
	self assert: (response at:'information') class: OrderedDictionary.
	self assert: ((response at:'information') at: 'description') equals: 'Fiction science movie'
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestInterpretWithInputObjectAndAlias [
	| response  |
	response := self attendRequest: '{
		hello
		aliasInformation: information(film: {
			description : "Fiction science movie",
			gender : "Fiction science"
		}) { 
				description
		 }
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'hello') equals: 'hello world'.
	self assert: (response at:'aliasInformation') class: OrderedDictionary.
	self assert: ((response at:'aliasInformation') at: 'description') equals: 'Fiction science movie'
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestInterpretWithInputObjectOfDifferentTypeFieldsAndArguments [
	| response  |
	response := self attendRequest: '{
		helloTo(name: "Alex")
		detailedInformation(film: {
			rating : 9,
			boxOffice: 12345523.34,
			gender : "Fiction science",
			isBoxOffice : true
		}) { 
				gender
				boxOffice
				rating
				isBoxOffice
		 }
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'helloTo') equals: 'hello Alex'.
	response := response at: 'detailedInformation'.
	self assert: response class: OrderedDictionary.
	self assert: response size equals: 4.
	self assert: (response at: 'gender') equals: 'Fiction science'.
	self assert: (response at: 'boxOffice') equals: 12345523.34.
	self assert: (response at: 'rating') equals: 9.
	self assert: (response at: 'isBoxOffice') equals: true.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestInterpretWithInputObjectOfDifferentTypeFieldsAndDirectiveExclude [
	| response  |
	response := self attendRequest: '{
		detailedInformation(film: {
			rating : 9,
			boxOffice: 12345523.34,
			gender : "Fiction science",
			isBoxOffice : true
		}) @skip(if: true) { 
				gender
				boxOffice
				rating
				isBoxOffice
		 }
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		detailedInformation(film: {
			rating : 9,
			boxOffice: 12345523.34,
			gender : "Fiction science",
			isBoxOffice : true
		}) @include(if: false) { 
				gender
				boxOffice
				rating
				isBoxOffice
		 }
	}'.
	self assert: response isEmpty.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestInterpretWithInputObjectOfDifferentTypeFieldsAndDirectiveInclude [
	| response  |
	response := self attendRequest: '{
		detailedInformation(film: {
			rating : 9,
			boxOffice: 12345523.34,
			gender : "Fiction science",
			isBoxOffice : true
		}) @skip(if: false) { 
				gender
				boxOffice
				rating
				isBoxOffice
		 }
	}'.
	
	self assert: response class: OrderedDictionary.
	response := response at: 'detailedInformation'.
	self assert: response class: OrderedDictionary.
	self assert: response size equals: 4.
	self assert: (response at: 'gender') equals: 'Fiction science'.
	self assert: (response at: 'boxOffice') equals: 12345523.34.
	self assert: (response at: 'rating') equals: 9.
	self assert: (response at: 'isBoxOffice') equals: true.
	
	response := self attendRequest: '{
		detailedInformation(film: {
			rating : 9,
			boxOffice: 12345523.34,
			gender : "Fiction science",
			isBoxOffice : true
		}) @include(if: true) { 
				gender
				boxOffice
				rating
				isBoxOffice
		 }
	}'.
	
	self assert: response class: OrderedDictionary.
	response := response at: 'detailedInformation'.
	self assert: response class: OrderedDictionary.
	self assert: response size equals: 4.
	self assert: (response at: 'gender') equals: 'Fiction science'.
	self assert: (response at: 'boxOffice') equals: 12345523.34.
	self assert: (response at: 'rating') equals: 9.
	self assert: (response at: 'isBoxOffice') equals: true.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestInterpretWithListInputObject [
	| response  |
	response := self attendRequest: '{
		hello
		films { 
			rating
			name
		}
		totalInformation(film: [ 
				{description : "Fiction science movie",
				gender : "Fiction science"}, 
				{description : "Animated cartoon movie"}, 
				{gender : "Animated cartoon"}
				])
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'hello') equals: 'hello world'.
	self assert: (response at: 'films') class: OrderedCollection.
	self assert: ((response at: 'films') first at: 'rating') equals: 9.
	self assert: ((response at: 'films') first at: 'name') equals: 'harry potter y la piedra filosofal'.
	response:= response at: 'totalInformation'.
	self assert: response class: Array.
	self assert: response size equals: 3.
	self assert: response first class: GQLTestQueryType.
	self assert: (response first description) equals:'Fiction science movie'.
	self assert: (response first gender) equals: 'Fiction science'.
	self assert: (response second description) equals: 'Animated cartoon movie'.
	self assert: (response third gender) equals: 'Animated cartoon'.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithDirectiveExclude [
	| response |
	response := self attendRequest: '{
		films @skip(if : true){
			name
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		films @include(if : false){
			name
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: response isEmpty.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithDirectiveInclude [
	| response expectedValues |
	response := self attendRequest: '{
		films @skip(if : false){
			name
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'films') class: OrderedCollection.
	expectedValues := (response at: 'films') collect: [ :res | res at: 'name' ].
	self assert: expectedValues asArray equals: #('harry potter y la piedra filosofal' 'el señor de los anillos' 'terminator' 'rambo' 'robocop' 'alien' 'annie').
	
	response := self attendRequest: '{
		films @include(if : true){
			name
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'films') class: OrderedCollection.
	expectedValues := (response at: 'films') collect: [ :res | res at: 'name' ].
	self assert: expectedValues asArray equals: #('harry potter y la piedra filosofal' 'el señor de los anillos' 'terminator' 'rambo' 'robocop' 'alien' 'annie').
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithDuplicateDirective [
	| text |
	text := '{
		films @skip(if : false) @skip(if : true){
			name
		}
	}'.
	
	self should: [ self attendRequest: text ] raise: GQLException.
	
	text := '{
		films @include(if : true) @include(if : false){
			name
		}
	}'.
	
	self should: [ self attendRequest: text ] raise: GQLException.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithManyOperationMutation [
	| response text |
	text := '
	mutation pointCreation {
		createPoint(x: 1, y: 2){
		x y
	}
}
	query operationFilmsWith {
		filmsWith(rating: 5) {
			name
		}
	}'.
	response := self attendRequest: text using: 'pointCreation' with: '' root: GQLTestMutationType new.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'createPoint') class: OrderedDictionary.
	self assert: ((response at: 'createPoint') at: 'x') equals: 1
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithManyOperationMutationAndWithoutOperationName [
	| text |
	text := '
	mutation pointCreation {
		createPoint(x: 1, y: 2){
		x y
	}
}
	query operationFilmsWith {
		filmsWith(rating: 5) {
			name
		}
	}'.
	
	self should: [ self attendRequest: text using: nil with: ''] raise: GQLException.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithManyOperationQuery [
	| response text |
	text := '
	query operationFilms {
		films {
			name
		}
	}
	query operationFilmsWith {
		filmsWith(rating: 5) {
			name
		}
	}'.
	response := self attendRequest: text using: 'operationFilms' with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'films') class: OrderedCollection.
	self assert: ((response at:'films') first at: 'name') equals: 'harry potter y la piedra filosofal'.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithManyOperationQueryAndUnknownOperationName [
	| text |
	text := '
	query operationFilms {
		films {
			name
		}
	}
	query operationFilmsWith {
		filmsWith(rating: 5) {
			name
		}
	}'.
	
	self should: [ self attendRequest: text using: 'operationUnknown' with: '' ] raise: GQLException.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithManyOperationQueryAndWithoutOperationName [
	| text |
	text := '
	query operationFilms {
		films {
			name
		}
	}
	query operationFilmsWith {
		filmsWith(rating: 5) {
			name
		}
	}'.
	
	self should: [ self attendRequest: text using: nil with: ''] raise: GQLException.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithManyOperationQueryWithDirectiveExclude [
	| text response |
	text := '
	query operationFilms {
		films @skip(if:true) {
			name
		}
	}
	query operationFilmsWith {
		filmsWith(rating: 5) @skip(if: true) {
			name
		}
	}'.
	response := self attendRequest: text using: 'operationFilms' with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: response isEmpty.
	
	text := '
	query operationFilms {
		films @include(if: false) {
			name
		}
	}
	query operationFilmsWith {
		filmsWith(rating: 5) @include(if: false) {
			name
		}
	}'.
	response := self attendRequest: text using: 'operationFilms' with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: response isEmpty.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithManyOperationQueryWithDirectiveInclude [
	| response text |
	text := '
	query operationFilms {
		films @skip(if: false) {
			name
		}
	}
	query operationFilmsWith {
		filmsWith(rating: 5) @skip(if: false) {
			name
		}
	}'.
	response := self attendRequest: text using: 'operationFilms' with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'films') class: OrderedCollection.
	self assert: (response at: 'films') size equals: 7.
	self assert: ((response at:'films') first at: 'name') equals: 'harry potter y la piedra filosofal'.
	
	text := '
	query operationFilms {
		films @include(if: true) {
			name
		}
	}
	query operationFilmsWith {
		filmsWith(rating: 5) @include(if: true) {
			name
		}
	}'.
	response := self attendRequest: text using: 'operationFilmsWith' with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'filmsWith') class: OrderedCollection.
	self assert: (response at:'filmsWith') size equals: 3.
	self assert: ((response at:'filmsWith') first at: 'name') equals: 'terminator'.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithNamedTypeOfOneLevel [
	| response |
	response := self attendRequest: '{
		hello
		films { 
			id
		 }
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'hello') equals: 'hello world'.
	response := response at: 'films'.
	self assert: response class: OrderedCollection.
	self assert: (response first at: 'id') equals: 1.
	self assert: (response last at: 'id') equals: 7.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithNamedTypeOfTwoLevelAndFirstDirectiveExclude [
	| response |
	response := self attendRequest: '{
		films @skip(if: true){ 
			id
			name
			film { 
				film(name: "harry potter y la piedra filosofal")
				id
			}
		 }
	}'.
	
	self assert: response isEmpty .
	
	response := self attendRequest: '{
		films @include(if: false){ 
			id
			name
			film { 
				film(name: "harry potter y la piedra filosofal")
				id
			}
		 }
	}'.
	
	self assert: response isEmpty .
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithNamedTypeOfTwoLevelAndFirstDirectiveInclude [
	| response |
	response := self attendRequest: '{
		films @skip(if: false){ 
			id
			film { 
				get(filmName: "harry potter y la piedra filosofal")
				id
			}
		 }
	}'.
	
	self assert: response class: OrderedDictionary .
	response := response at: 'films'.
	self assert: (response first at: 'id') equals: 1.
	response := response first at: 'film'.
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'get') equals: 'harry potter y la piedra filosofal'.
	self assert: (response at: 'id') equals: 1.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithNamedTypeOfTwoLevelAndParameters [
	| response |
	response := self attendRequest: '{
		helloTo(name : "Alex")
		films { 
			film { 
				get(filmName: "harry potter y la piedra filosofal")
				id
			}
		 }
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'helloTo') equals: 'hello Alex'.
	response := (response at: 'films') first at: 'film'.
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'get') equals: 'harry potter y la piedra filosofal'.
	self assert: (response at: 'id') equals: 1.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithNamedTypeOfTwoLevelAndSecondDirectiveExclude [
	| response |
	response := self attendRequest: '{
		films { 
			id
			film @skip(if: true){ 
				film(name: "harry potter y la piedra filosofal")
				id
			}
		 }
	}'.
	
	self assert: response class: OrderedDictionary.
	response := response at: 'films'.
	self assert: response class: OrderedCollection.
	self assert: (response first includesKey: 'id').
	self assert: (response first at: 'id') equals: 1.
	self deny: (response first includesKey: 'film').
		
	response := self attendRequest: '{
		films { 
			id
			film @include(if: false){ 
				film(name: "harry potter y la piedra filosofal")
				id
			}
		 }
	}'.
	self assert: response class: OrderedDictionary.
	response := response at: 'films'.
	self assert: response class: OrderedCollection.
	self assert: (response first includesKey: 'id').
	self assert: (response first at: 'id') equals: 1.
	self deny: (response first includesKey: 'film').
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithNamedTypeOfTwoLevelAndSecondDirectiveInclude [
	| response |
	response := self attendRequest: '{
		films {
			film @skip(if: false){ 
				id
			}
		 }
	}'.
	
	self assert: response class: OrderedDictionary .
	response := (response at: 'films') first at: 'film'.
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'id') equals: 1.
		
	response := self attendRequest: '{
		films {
			film @include(if: true){ 
				id
			}
		 }
	}'.
	
	self assert: response class: OrderedDictionary .
	response := (response at: 'films') first at: 'film'.
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'id') equals: 1.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithOneOperationMutation [
	| response text |
	text := '
	mutation pointCreation {
		createPoint(x: 1, y: 2){
			x y
		}
	}'.
	response := self attendRequest: text using: 'pointCreation' with: '' root: GQLTestMutationType new.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'createPoint') class: OrderedDictionary.
	self assert: ((response at: 'createPoint') at: 'x') equals: 1
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithOneOperationMutationAndWithoutOperationName [
	| response text |
	text := '
	mutation pointCreation {
		createPoint(x: 1, y: 2){
			x y
		}
	}'.
	response := self attendRequest: text using: nil with: '' root: GQLTestMutationType new.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'createPoint') class: OrderedDictionary.
	self assert: ((response at: 'createPoint') at: 'x') equals: 1
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithOneOperationQuery [
	| response text |
	text := '
	query operationFilms {
		films {
			name
		}
	}'.
	response := self attendRequest: text using: 'operationFilms' with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'films') class: OrderedCollection.
	self assert: ((response at:'films') first at: 'name') equals: 'harry potter y la piedra filosofal'.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposeRequestWithOneOperationQueryAndWithoutOperationName [
	| response text |
	text := '
	query operationFilms {
		films {
			name
		}
	}'.
	response := self attendRequest: text using: nil with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'films') class: OrderedCollection.
	self assert: (response at:'films') size equals: 7.
	self assert: ((response at:'films') first at: 'name') equals: 'harry potter y la piedra filosofal'.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposedRequestInlineFragment [
	| response subResponse |

	response := self attendRequest: '{
		filmsWith(rating:5){
			... {
				name
				rating
			}
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	subResponse := (response at:'filmsWith').
	self assert: subResponse size equals: 3.
	self assert: subResponse first size equals: 2.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposedRequestInlineFragmentDirectives [
	| response subResponse |

	response := self attendRequest: '{
		filmsWith(rating:5){
			... @skip(if: true){
				name
				rating
			}
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	subResponse := (response at:'filmsWith').
	subResponse do: [ :sub | self assert: sub isEmpty ]
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposedRequestInlineFragmentType [
	| response subResponse |

	response := self attendRequest: '{
		filmsWith(rating:5){
			... on GQLTestFilm{
				name
				rating
			}
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	subResponse := (response at:'filmsWith').
	self assert: subResponse size equals: 3.
	self assert: subResponse first size equals: 2.
]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposedRequestInterpret [
	| response subResponse |

	response := self attendRequest: '{
		hello
		hello
		films { 
			rating
			name
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	subResponse := (response at:'hello').
	self assert: subResponse equals: 'hello world'.
	subResponse := (response at:'films').
	self assert: subResponse class: OrderedCollection.
	self assert: (subResponse first at: 'rating') equals: 9.
	self assert: (subResponse first at: 'name') equals: 'harry potter y la piedra filosofal'

]

{ #category : #tests }
GQLDocumentNodeTest >> testComposedRequestInterpretSpreadFragments [
	| response subResponse |

	response := self attendRequest: '{
		films { 
			...filmsData
		}
		filmsWith(rating:5){
			...filmsData
		}
	}
	fragment filmsData on GQLTestFilm{
		name
		rating
	}
	'.
	
	self assert: response class: OrderedDictionary.
	subResponse := (response at:'films').
	self assert: (subResponse first at: 'rating') equals: 9.
	self assert: (subResponse first at: 'name') equals: 'harry potter y la piedra filosofal'.
	subResponse := (response at:'filmsWith').
	self assert: subResponse size equals: 3.

]

{ #category : #tests }
GQLDocumentNodeTest >> testComposedRequestInterpretUnknowFragments [
	| text |

	text:=  '{
		films { 
			...filmsData
		}
		filmsWith(rating:5){
			...filmsData
		}
	}
	fragment filmsDota on GQLTestFilm{
		name
		rating
	}
	'.
	
	self should: [self attendRequest: text] raise: GQLException.

]

{ #category : #tests }
GQLDocumentNodeTest >> testComposedRequestSpreadFragmentsWithDirectives [
	| response subResponse |

	response := self attendRequest: '{
		films { 
			...filmsData @skip(if : true)
		}
		filmsWith(rating:5){
			...filmsData
		}
	}
	fragment filmsData on GQLTestFilm{
		name
		rating @include(if : false)
	}
	'.
	
	self assert: response class: OrderedDictionary.
	subResponse := (response at: 'films').
	subResponse do: [ :res |	self assert: res isEmpty.].
	subResponse := (response at:'filmsWith').
	self assert: subResponse size equals: 3.
	self assert: subResponse first size equals: 1.

]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposedRequestWhitAliasInterpret [
	| response subResponse |

	response := self attendRequest: '{
		hello
		hello
		myFilms : films { 
			rating
			name
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	subResponse := (response at:'hello').
	self assert: subResponse equals: 'hello world'.
	subResponse := (response at:'myFilms').
	self assert: subResponse class: OrderedCollection.
	self assert: (subResponse first at: 'rating') equals: 9.
	self assert: (subResponse first at: 'name') equals: 'harry potter y la piedra filosofal'

]

{ #category : #'test-composeRequest' }
GQLDocumentNodeTest >> testComposedRequestWithArgumentsAndAliasInterpret [
	| response subResponse |

	response := self attendRequest: '{
		hello
		helloWorld: hello
		myFilms : films { 
			rating
			name
		}
		aliasHello: helloTo(name:"terminator") 	
	}'.
	
	self assert: response class: OrderedDictionary.
	subResponse := (response at:'hello').
	self assert: subResponse equals: 'hello world'.
	subResponse := (response at:'helloWorld').
	self assert: subResponse equals: 'hello world'.
	subResponse := (response at:'myFilms').
	self assert: subResponse class: OrderedCollection.
	self assert: (subResponse first at: 'rating') equals: 9.
	self assert: (subResponse first at: 'name') equals: 'harry potter y la piedra filosofal'.
	self assert: (response at: 'aliasHello') equals: 'hello terminator'.

]

{ #category : #'test-fragment' }
GQLDocumentNodeTest >> testCyclesFragment [
	| document |
	document := self parseRequest: '{
		filmsWith(rating: 5) @skip(if : false) @include(if : true){
			...named
		}
	}
	fragment named on Film{
		name
		...other
	}
	fragment other on Film{
		id
	   ...named
	}'.
	
	self should: [ document evaluate ] raise: GQLException.
]

{ #category : #'test-variables' }
GQLDocumentNodeTest >> testDefaultValueVariable [
	| text response |
	text := '
	query operation1($name: String="Alex"){
		helloTo(name: $name)
	}
	'.
	response := self attendRequest: text using: 'operation1' with: ''.
	self assert: (response at: 'helloTo') equals: 'hello Alex'.
	
	text := '
	query operation1($name: String!="Alex"){
		helloTo(name: $name)
	}
	'.
	self should: [ self attendRequest: text using: 'operation1' with: '' ] raise: GQLException.
]

{ #category : #'test-variables' }
GQLDocumentNodeTest >> testDefinedUseVariable [
	| text textVariables |
	text := '
	query operation1{
		...fragHello
	}
	fragment fragHello on GQLTestQueryType{
		helloTo(name:$name)
	}
	'.
	textVariables := '{"name":"Alex"}'.
	self should: [ self attendRequest: text using: 'operation1' with: textVariables ] raise: GQLException.
]

{ #category : #'test-variables' }
GQLDocumentNodeTest >> testDirectiveVariable [
	| text response textVariables |
	text := '
	query operation1($name:String, $bool:Boolean){
		helloTo(name:$name) @skip(if:$bool)
	}
	'.
	textVariables := '{"name":"Alex", "bool":false}'.
	response := self attendRequest: text using: 'operation1' with: textVariables.
	self assert: (response at: 'helloTo') equals: 'hello Alex'.
	
	text := 'query operation1($name : String, $gender : FilmType, $lala : Boolean, $rating:Int){
      film(name:$name, rating:$rating){
        name
        rating @skip(if:$lala)
      }
      filmsOf(gender: $gender){
        name
        rating
      }
   }'.
	
	textVariables := '{
    "name":"terminator", "rating":5, "gender":ACTION, "lala":true
    }'.
	response := self attendRequest: text using: 'operation1' with: textVariables.
	self assert: ((response at: 'film') at: 'name') equals: 'terminator'.
	self assert: ((response at: 'filmsOf') first at: 'name') equals: 'rambo'.
	self assert: ((response at: 'filmsOf') first at: 'rating') equals: 5.
]

{ #category : #'test-variables' }
GQLDocumentNodeTest >> testInputTypeVariable [
	| text response textVariables |
	text := '
	query operation1($gqlFilm: GQLFilmInput){
		informationInput(film: $gqlFilm){
			description
			rating
		}
	}
	'.
	textVariables := '{"gqlFilm":{filmName:"rambo"}}'.
	response := self attendRequest: text using: 'operation1' with: textVariables.
	self assert: ((response at: 'informationInput') at:'description') equals: 'rambo'.
	self assert: ((response at: 'informationInput') at:'rating') equals: nil.
]

{ #category : #'tests-introspection' }
GQLDocumentNodeTest >> testIntrospectionArgsWithFragment [
	| request result field |
	request := '{
  		__type(name: "__Field") {
    		name
    		fields(includeDeprecated: false) {
				name
      			args{
					...InputValue
				}
      			type {
        			...TypeRef
      			}
    		}
  		}
	}
	fragment InputValue on __InputValue { 
		name
		description
		type { 
			...TypeRef
		}
		defaultValue
	}
	fragment TypeRef on __Type{
		kind
		name 
		ofType {
        kind
        name
        ofType {
          kind
          name
          ofType {
            kind
            name
            ofType {
              kind
              name
              ofType {
                kind
                name
                ofType {
                  kind
                  name
                  ofType {
                    kind
                    name
                  }
                }
              }
            }
          }
        }
      }
	}'.
	result := self attendRequest: request using: '' with: ''.
	self assertCollection: (result at: '__type') keys hasSameElements: #('name' 'fields').
	result := (result at: '__type') at: 'fields'.
	self assertCollection: (result collect: [:dict | dict at: 'name']) hasSameElements: #('description' 'isDeprecated' 'args' 'name' 'type' 'deprecationReason').
	field := result detect: [ :item | (item at: 'name') = 'description' ].
	self assertCollection: (field at: 'type') associations hasSameElements: (
		Array with: 'kind' -> 'SCALAR' 
		with: 'name' -> 'String' 
		with: 'ofType' -> nil).
	field := result detect: [ :item | (item at: 'name') = 'isDeprecated' ].
	self assertCollection: (field at: 'type') associations hasSameElements: (
		Array with: 'kind' -> 'NON_NULL'
		with: 'name' -> nil
		with: 'ofType' -> (OrderedDictionary new 
		at: 'kind' put: 'SCALAR';
		at: 'name' put: 'Boolean';
		at: 'ofType' put: nil; yourself)
	).
	field := result detect: [ :item | (item at: 'name') = 'args' ].
	self assertCollection: (field at: 'type') associations hasSameElements: 
	(Array with: 'kind' -> 'NON_NULL'
	with: 'name' -> nil
	with: 'ofType' -> (OrderedDictionary new 
	at: 'kind' put: 'LIST';
	at: 'name' put: nil;
	at: 'ofType' put: (OrderedDictionary new 
	at: 'kind' put: 'NON_NULL';
	at: 'name' put: nil;
	at: 'ofType' put: (OrderedDictionary new 
	at: 'kind' put: 'OBJECT';
	at: 'name' put: '__InputValue';
	at: 'ofType' put: nil; yourself); yourself); yourself)).
	field := result detect: [ :item | (item at: 'name') = 'name' ].
	self assertCollection: (field at: 'type') associations hasSameElements: (
	Array with: 'kind' -> 'NON_NULL'
	with: 'name' -> nil
	with: 'ofType' -> (OrderedDictionary new 
	at: 'kind' put: 'SCALAR';
	at: 'name' put: 'String';
	at: 'ofType' put: nil; yourself)).
	field := result detect: [ :item | (item at: 'name') = 'type' ].
	self assertCollection: (field at: 'type') associations hasSameElements: (
	Array with: 'kind' -> 'NON_NULL'
	with: 'name' -> nil
	with: 'ofType' -> (OrderedDictionary new 
	at: 'kind' put: 'OBJECT';
	at: 'name' put: '__Type';
	at: 'ofType' put: nil; yourself)).
	field := result detect: [ :item | (item at: 'name') = 'deprecationReason' ].
	self assertCollection: (field at: 'type') associations hasSameElements: (
	Array with: 'kind' -> 'SCALAR'
	with: 'name' -> 'String'
	with: 'ofType' -> nil
	).
]

{ #category : #'tests-introspection' }
GQLDocumentNodeTest >> testIntrospectionFieldsWithFragment [
	| request result field |
	request := '{
  		__type(name: "GQLTestFilm") {
    		name
    		fields(includeDeprecated: false) {
      			name
				description
				isDeprecated
				deprecationReason
    		}
  		}
	}'.
	result := self attendRequest: request using: '' with: ''.
	self assertCollection: (result at: '__type') keys hasSameElements: #('name' 'fields').
	self assert: ((result at: '__type') at: 'name') equals: 'GQLTestFilm'.
	result := (result at: '__type') at: 'fields'.
	self assertCollection: (result collect: [:dict | dict at: 'name']) hasSameElements: #('id' 'name' 'film' 'rating' 'description').
	field := result detect: [ :item | (item at: 'name') = 'id' ].
	self assertCollection: field associations hasSameElements: (
		Array with: 'name' -> 'id' 
		with: 'description' -> nil 
		with: 'isDeprecated' -> false
		with: 'deprecationReason' -> nil).
]

{ #category : #'tests-introspection' }
GQLDocumentNodeTest >> testIntrospectionManyTypes [
	| request result expectedResult |
	request := '{
  		__type(name: "Point") {
    		name
    		fields(includeDeprecated: false) {
      			name
      			type {
        			name
      			}
    		}
  		}
		typeMutation: __type(name: "GQLTestMutationType") {
			name
		},
		typeQuery: __type(name: "GQLTestQueryType") { 
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "__type": {
    "name": "Point",
    "fields": [
      {
        "name": "x",
        "type": { "name": "Int" }
      },
      {
        "name": "y",
        "type": { "name": "Int" }
      }
    ]
  },
	"typeMutation": {
    "name": "GQLTestMutationType"
  },
	"typeQuery": {
    "name": "GQLTestQueryType"
  }
}'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #'tests-introspection' }
GQLDocumentNodeTest >> testIntrospectionSchema [
	| request result |
	request := '{
  		__schema {
    		types { 
				name
				kind
		   }
			queryType { 
				name
			}
			mutationType { 
				name
			}
			subscriptionType { 
				name
			}
			directives { 
				name
				description
				locations
				args { 
					name
				}
			}
  		}
	}'.
	result := self attendRequest: request.
	self assert: (result at: '__schema') class: OrderedDictionary.
	result := result at: '__schema'.
	self assertCollection: result keys hasSameElements: #('types' 'queryType' 'mutationType' 'subscriptionType' 'directives').
	self assertCollection: ((result at: 'types') collect: [:dict | dict associations]) hasSameElements: (OrderedCollection new 
	add: (Array with: 'name'-> 'GQLTestMutationType' with: 'kind' -> 'OBJECT');
	add: (Array with: 'name'-> 'Point' with: 'kind'-> 'OBJECT');
	add: (Array with: 'name'-> 'GQLTestFilmInput' with: 'kind'-> 'INPUT_OBJECT');
	add: (Array with: 'name'-> 'GQLTestQueryTypeInput' with: 'kind'-> 'INPUT_OBJECT');
	add: (Array with: 'name'-> 'GQLTestQueryType' with: 'kind'-> 'OBJECT');
	add: (Array with: 'name'-> 'GQLFilm' with: 'kind'-> 'OBJECT');
	add: (Array with: 'name'-> 'GQLTestFilm' with: 'kind'-> 'OBJECT');
	add: (Array with: 'name'-> 'GQLFilmInput' with: 'kind'-> 'INPUT_OBJECT');
	add: (Array with: 'name'-> 'NamedEntity' with: 'kind'-> 'INTERFACE');
	add: (Array with: 'name'-> 'IdentifiedEntity' with: 'kind'-> 'INTERFACE');
	add: (Array with: 'name'-> 'MovieType' with: 'kind'-> 'ENUM');
	add: (Array with: 'name'-> '__Schema' with: 'kind'-> 'OBJECT');
	add: (Array with: 'name'-> '__Type' with: 'kind'-> 'OBJECT');
	add: (Array with: 'name'-> '__Field' with: 'kind'-> 'OBJECT');
	add: (Array with: 'name'-> '__InputValue' with: 'kind'-> 'OBJECT');
	add: (Array with: 'name'-> '__EnumValue' with: 'kind'-> 'OBJECT');
	add: (Array with: 'name'-> '__Directive' with: 'kind'-> 'OBJECT');
	add: (Array with: 'name'-> '__Directive' with: 'kind'-> 'OBJECT');
	add: (Array with: 'name' ->'__TypeKind' with: 'kind' -> 'ENUM');
	add: (Array with: 'name'-> '__DirectiveLocation' with: 'kind'-> 'ENUM');
	add: (Array with: 'name'-> 'String' with: 'kind'-> 'SCALAR');
	add: (Array with: 'name'-> 'Boolean' with: 'kind'-> 'SCALAR');
	add: (Array with: 'name'-> 'Int' with: 'kind'-> 'SCALAR');
	add: (Array with: 'name'-> 'Float' with: 'kind'-> 'SCALAR');
	add: (Array with: 'name'-> 'ID' with: 'kind'-> 'SCALAR');
	yourself).
	self assert: ((result at: 'queryType') at: 'name') equals: 'GQLTestQueryType'.
	self assert: ((result at: 'mutationType') at: 'name') equals: 'GQLTestMutationType'.
	self assert: (result at: 'subscriptionType') isNil.
	self assertCollection: ((result at: 'directives') collect: [ :dict | dict associations ]) hasSameElements: (OrderedCollection new 
	add: (Array with: 'name'-> 'skip' 
	with: 'description' -> nil 
	with: 'locations' -> #('FIELD' 'FRAGMENT_SPREAD' 'INLINE_FRAGMENT') 
	with: 'args' -> (OrderedCollection new add: 
	(OrderedDictionary new at: 'name' put: 'if'; yourself); yourself));
	add: (Array with: 'name' -> 'include' 
	with: 'description' -> nil
	with: 'locations' -> #('FIELD' 'FRAGMENT_SPREAD' 'INLINE_FRAGMENT')
	with: 'args' -> (OrderedCollection new add: 
	(OrderedDictionary new at: 'name' put: 'if'; yourself); yourself)); 
	yourself
	).
]

{ #category : #'tests-introspection' }
GQLDocumentNodeTest >> testIntrospectionType [
	| request result expectedResult |
	request := '{
  		__type(name: "Point") {
    		name
    		fields(includeDeprecated: false) {
      			name
      			type {
        			name
      			}
    		}
  		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "__type": {
    "name": "Point",
    "fields": [
      {
        "name": "x",
        "type": { "name": "Int" }
      },
      {
        "name": "y",
        "type": { "name": "Int" }
      }
    ]
  }
}'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #'tests-introspection' }
GQLDocumentNodeTest >> testIntrospectionTypeName [
	| request result expectedResult |
	request := '{
  		__typename
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  		"__typename": "GQLTestQueryType"
	}'.
	self assertJSONEquals: result and: expectedResult.
	request := '{
		__typename
		filmsWith(rating: 9) {
			__typename
			id
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
		"__typename": "GQLTestQueryType",
		"filmsWith": [
			{ 
			"__typename": "GQLTestFilm",
			"id": 1,
			"name": "harry potter y la piedra filosofal"
			}
		]
	}'.
	self assertJSONEquals: result and: expectedResult. 
]

{ #category : #'tests-introspection' }
GQLDocumentNodeTest >> testIntrospectionWithFragment [
	| request result expectedResult |
	request := '{
  		__schema { 
			types { 
				...FullType
			}
		}
	}
	fragment FullType on __Type { 
		kind 
		name
	}
	'.
	result := self attendRequest: request.
	expectedResult := OrderedCollection new 
		add: (Array with:'ENUM' with: 'MovieType');
		add: (Array with:'OBJECT' with: 'GQLFilm');
		add: (Array with:'SCALAR' with: 'String');
		add: (Array with:'SCALAR' with: 'Int');
		add: (Array with:'SCALAR' with: 'Boolean');
		add: (Array with:'SCALAR' with: 'Float');
		add: (Array with:'SCALAR' with: 'ID');
		add: (Array with:'INTERFACE' with: 'IdentifiedEntity');
		add: (Array with:'OBJECT' with: '__Field');
		add: (Array with:'INPUT_OBJECT' with: 'GQLFilmInput');
		add: (Array with:'OBJECT' with: 'Point');
		add: (Array with:'ENUM' with: '__TypeKind');
		add: (Array with:'INPUT_OBJECT' with: 'GQLTestFilmInput');
		add: (Array with:'OBJECT' with: 'GQLTestMutationType');
		add: (Array with:'OBJECT' with: 'GQLTestFilm');
		add: (Array with:'OBJECT' with: '__Directive');
		add: (Array with:'INPUT_OBJECT' with: 'GQLTestQueryTypeInput');
		add: (Array with:'OBJECT' with: '__Type');
		add: (Array with:'ENUM' with: '__DirectiveLocation');
		add: (Array with:'OBJECT' with: '__Schema');
		add: (Array with:'OBJECT' with: '__EnumValue');
		add: (Array with:'INTERFACE' with: 'NamedEntity');
		add: (Array with:'OBJECT' with: '__InputValue');
		add: (Array with:'OBJECT' with: 'GQLTestQueryType');
		yourself.
	self assertCollection: (((result at: '__schema') at: 'types') 
	collect: [:dict | 
		Array with: (dict at: 'kind') with: (dict at: 'name')]) 
	hasSameElements: expectedResult.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testMutationArgumentsWithOneVariable [
	| response text textVariables |
	text := '
	mutation pointCreation($x : Int) {
		createPoint(x: $x, y: 2){
			x y
		}
	}
	'.
	textVariables := '{"x":1}'.
	response := self attendRequest: text using: 'pointCreation' with: textVariables root: GQLTestMutationType new.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'createPoint') class: OrderedDictionary.
	self assert: ((response at: 'createPoint') at: 'x') equals: 1
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testMutationArgumentsWithOneVariableAndManyAssignment [
	| response text textVariables |
	text := '
	mutation pointCreation($x : Int) {
		createPoint(x: $x, y: 2){
			x y
		}
	}
	'.
	textVariables := '{"x":5, "x":4, "x":1}'.
	response := self attendRequest: text using: 'pointCreation' with: textVariables root: GQLTestMutationType new.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'createPoint') class: OrderedDictionary.
	self assert: ((response at: 'createPoint') at: 'x') equals: 1
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testMutationArgumentsWithVariableAndDefaultValue [
	| response text textVariables |
	text := '
	mutation pointCreation($x : Int = 1) {
		createPoint(x: $x, y: 2){
			x y
		}
	}
	'.
	textVariables := ''.
	response := self attendRequest: text using: 'pointCreation' with: textVariables root: GQLTestMutationType new.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'createPoint') class: OrderedDictionary.
	self assert: ((response at: 'createPoint') at: 'x') equals: 1
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testMutationArgumentsWithVariableAndFragment [
	| response text textVariables |
	text := '
	mutation pointCreation($x : Int) {
		createPoint(x: $x, y: 2){
			...data
		}
	}
	
	fragment data on Point{
	   x y
	}
	'.
	textVariables := '{"x":1}'.
	response := self attendRequest: text using: 'pointCreation' with: textVariables root: GQLTestMutationType new.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'createPoint') class: OrderedDictionary.
	self assert: ((response at: 'createPoint') at: 'x') equals: 1
]

{ #category : #'test-fragment' }
GQLDocumentNodeTest >> testNoCyclesFragment [
	| document |
	document := self parseRequest: '{
		filmsWith(rating: 5) @skip(if : false) @include(if : true){
			...named
		}
	}
	fragment named on Film{
		name
		...other
	}
	fragment other on Film{
		id
	}'.
	
	self assert: document evaluate class: GQLDocumentNode
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsExcludeWithTwoDirective [
	| response |
	response := self attendRequest: '{
		helloTo(name: "Alex") @skip(if : true) @include(if : true)
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		helloTo(name: "Alex") @skip(if : true) @include(if : false)
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		helloTo(name: "Alex") @include(if : false) @skip(if : true)
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		helloTo(name: "Alex") @skip(if : false) @include(if : false)
	}'.
	
	self assert: response isEmpty.
	
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsIncludeWithTwoDirective [
	| response |
	response := self attendRequest: '{
		helloTo(name: "Alex") @skip(if : false) @include(if : true)
	}'.
	
	self assert: response class: OrderedDictionary.
	
	response := self attendRequest: '{
		helloTo(name: "Alex") @include(if : true) @skip(if : false)
	}'.
	
	self assert: response class: OrderedDictionary.
	
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsWithDirectiveExclude [

	| response |
	response := self attendRequest: '{
		helloTo(name : "Alex") @skip(if : true)
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		helloTo(name : "Alex") @include(if : false)
	}'.
	self assert: response class: OrderedDictionary.
	self assert: response isEmpty.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsWithDirectiveInclude [
	| response |
	response := self attendRequest: '{
		helloTo(name : "Alex") @skip(if : false)
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'helloTo') equals: 'hello Alex'.
	
	response := self attendRequest: '{
		helloTo(name : "Alex") @include(if : true)
	}'.
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'helloTo') equals: 'hello Alex'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsWithDuplicateDirective [
	| text |
	text := '{
		helloTo(name:"Alex") @skip(if : true) @skip(if : false)
	}'.
	
	self should: [ self attendRequest: text ] raise: GQLException.
	
	text  := '{
		helloTo(name:"Alex") @include(if : true) @include(if : false)
	}'.
	
	self should: [ self attendRequest: text ] raise: GQLException.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsWithEnumType [
	| response |
	response := self attendRequest: '{
		classification(gender: ACTION)
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'classification') equals: 'ACTION'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsWithOneVariable [
	| response text textVariables |
	text := '
	query operationHello($name: String){
		helloTo(name: $name)
	}
	'.
	textVariables := '{"name":"Alex"}'.
	response := self attendRequest: text using: 'operationHello' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'helloTo') equals: 'hello Alex'.
	
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsWithOneVariableAndManyAssignment [
	| response text textVariables |
	text := '
	query operationHello($name: String){
		helloTo(name: $name)
	}
	'.
	textVariables := '{"name":"Alex", "name":"Mary", "name":"Juan"}'.
	response := self attendRequest: text using: 'operationHello' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'helloTo') equals: 'hello Juan'.
	
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsWithVariableAndDefaultValue [
	| response text textVariables |
	text := '
	query operationHello($name: String="Alex"){
		helloTo(name: $name)
	}
	'.
	textVariables := ''.
	response := self attendRequest: text using: 'operationHello' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'helloTo') equals: 'hello Alex'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsWithVariableAndDirectiveExclude [
	| text textVariables response |
	text := '
	query operationClassification($gender: MovieType){
		classification(gender: $gender) @skip(if: true)
	}
	'.
	textVariables := '{"gender":ACTION}'.
	response := self attendRequest: text using: 'operationClassification' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: response isEmpty.
	
	text := '
	query operationClassification($gender: MovieType){
		classification(gender: $gender) @include(if: false)
	}
	'.
	textVariables := '{"gender":ACTION}'.
	response := self attendRequest: text using: 'operationClassification' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: response isEmpty.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsWithVariableAndDirectiveInclude [
	| response text textVariables |
	text := '
	query operationClassification($gender: MovieType){
		classification(gender: $gender) @skip(if: false)
	}
	'.
	textVariables := '{"gender":ACTION}'.
	response := self attendRequest: text using: 'operationClassification' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'classification') equals: 'ACTION'.
	
   text := '
	query operationClassification($gender: MovieType){
		classification(gender: $gender) @include(if: true)
	}
	'.
	textVariables := '{"gender":ACTION}'.
	response := self attendRequest: text using: 'operationClassification' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'classification') equals: 'ACTION'.
	
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsWithVariableAndFragment [
	| response text textVariables |
	text := '
	query operationHello($name: String){
		...fragmentHello
	}
	
	fragment fragmentHello on GQLTestQueryType{
	   helloTo(name: $name)
	}
	'.
	textVariables := '{"name":"Alex"}'.
	response := self attendRequest: text using: 'operationHello' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'helloTo') equals: 'hello Alex'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestArgumentsWithVariableAssignedAndDefaultValue [
	| response text textVariables |
	text := '
	query operationHello($name: String="Alex"){
		helloTo(name: $name)
	}
	'.
	textVariables := '{"name":"Mary"}'.
	response := self attendRequest: text using: 'operationHello' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'helloTo') equals: 'hello Mary'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestExcludeWithTwoDirective [
	| response |
	response := self attendRequest: '{
		hello @skip(if : true) @include(if : true)
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		hello @skip(if : true) @include(if : false)
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		hello @include(if : false) @skip(if : true)
	}'.
	
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		hello @skip(if : false) @include(if : false)
	}'.
	
	self assert: response isEmpty.
	
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestIncludeWithTwoDirective [
	| response |
	response := self attendRequest: '{
		hello @skip(if : false) @include(if : true)
	}'.
	
	self deny: response isEmpty.
	
	response := self attendRequest: '{
		hello @include(if : true) @skip(if : false)
	}'.
	
	self deny: response isEmpty.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestInterpret [
	| response  |
	response := self attendRequest: '{
		hello
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'hello') equals: 'hello world'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestInterpretInlineFragments [
	| response  |
	response := self attendRequest: '{
		...{
			hello
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'hello') equals: 'hello world'.
	self assert: response size equals: 1.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestInterpretInlineFragmentsDirectives [
	| response  |
	response := self attendRequest: '{
		... on GQLTestQueryType @include(if:true){
			hello
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'hello') equals: 'hello world'.
	self assert: response size equals: 1.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestInterpretInlineFragmentsType [
	| response  |
	response := self attendRequest: '{
		... on GQLTestQueryType{
			hello
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'hello') equals: 'hello world'.
	self assert: response size equals: 1.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestInterpretSpreadFragments [
	| response  |
	response := self attendRequest: '{
		hello
		...helloFragment
	}
	fragment helloFragment on GQLTestQueryType{
		hello
	}
	'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'hello') equals: 'hello world'.
	self assert: response size equals: 1.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestInterpretWithAlias [
	| response  |
	response := self attendRequest: '{
		myMessage : hello
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'myMessage') equals: 'hello world'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestInterpretWithInputObject [
	| response  |
	response := self attendRequest: '{
		information(film: {
			description : "Fiction science movie",
			gender : "Fiction science"
		}) { 
				description
		 }
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'information') class: OrderedDictionary.
	self assert: ((response at:'information') at: 'description') equals: 'Fiction science movie'
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestInterpretWithInputObjectModified [
	| response  |
	response := self attendRequest: '{
		informationInput(film: {
			filmName : "Fiction science movie"
		}) { 
				description
		 }
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'informationInput') class: OrderedDictionary.
	self assert: ((response at:'informationInput') at: 'description') equals: 'Fiction science movie'
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestInterpretWithInputObjectOfDifferentTypeFields [
	| response  |
	response := self attendRequest: '{
		detailedInformation(film: {
			rating : 9,
			boxOffice: 12345523.34,
			gender : "Fiction science",
			isBoxOffice : true
		}) { 
				gender
				boxOffice
				rating
				isBoxOffice
		 }
	}'.
	
	self assert: response class: OrderedDictionary.
	response := response at: 'detailedInformation'.
	self assert: response class: OrderedDictionary.
	self assert: response size equals: 4.
	self assert: (response at: 'gender') equals: 'Fiction science'.
	self assert: (response at: 'boxOffice') equals: 12345523.34.
	self assert: (response at: 'rating') equals: 9.
	self assert: (response at: 'isBoxOffice') equals: true.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestInterpretWithInputObjectOfScalarType [
	| response  |
	response := self attendRequest: '{
		features(film: {filmName: "Pirates of the Caribbean"})
	}'.
	self assert: response class: OrderedDictionary.
	self assert: (response at:'features') equals: 'Pirates of the Caribbean'
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestInterpretWithListInputObject [
	| response  |
	response := self attendRequest: '{
		totalInformation(film: [ 
				{description : "Fiction science movie",
				gender : "Fiction science"}, 
				{description : "Animated cartoon movie"}, 
				{gender : "Animated cartoon"}
		]){
			description
			gender
		}
	}'.
	
	self assert: response class: OrderedDictionary.
	response := response at: 'totalInformation'.
	self assert: response class: OrderedCollection.
	self assert: response size equals: 3.
	self assert: response first class: OrderedDictionary.
	self assert: (response first at: 'description') equals: 'Fiction science movie'.
	self assert: (response first at: 'gender') equals: 'Fiction science'.
	self assert: (response second at: 'description') equals: 'Animated cartoon movie'.
	self assert: (response second at: 'gender') isNil.
	self assert: (response third at: 'description') isNil.
	self assert: (response third at: 'gender') equals: 'Animated cartoon'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestSameFieldAlias [
	| response  |
	response := self attendRequest: '{
		hello
		myMessage : hello
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'hello') equals: 'hello world'.
	self assert: (response at:'myMessage') equals: 'hello world'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestSpreadFragmentsWithDirectives [
	| response  |
	response := self attendRequest: '{
		films{
			name
		}
		...helloFragment @skip(if : true)
	}
	fragment helloFragment on GQLTestQueryType{
		hello
	}'.
	
	self assert: response class: OrderedDictionary.
	self deny: (response keys includes: 'hello').
	self assert: (response keys includes: 'films').
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestUnknowSpreadFragments [
	| text  |
	text := '{
		hello
		...helloFragment
	}
	fragment fragmentHello on GQLTestQueryType{
		hello
	}
	'.
	
	self should: [self attendRequest: text] raise: GQLException.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestWithDirectiveExclude [
	| response  |
	response := self attendRequest: '{
		hello @skip(if : true)
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: response isEmpty.
	
	response := self attendRequest: '{
		hello @include(if : false)
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: response isEmpty.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestWithDirectiveInclude [
	| response  |
	response := self attendRequest: '{
		hello @skip(if : false)
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'hello') equals: 'hello world'.
	
	response := self attendRequest: '{
		hello @include(if : true)
	}'.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'hello') equals: 'hello world'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestWithDuplicateDirective [
	| text |
	text := '{
		hello @skip(if : true) @skip(if : false)
	}'.
	
	self should: [ self attendRequest: text ] raise: GQLException.
	
	text := '{
		hello @include(if : true) @include(if : false)
	}'.
	
	self should: [ self attendRequest: text ] raise: GQLException.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestWithManyOperationQuery [
	| response text |
	text := 'query operationHello {
		hello
	}
	query operationHelloTo {
		helloTo(name: "Alex")
	}'.
	response := self attendRequest: text using: 'operationHello' with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'hello') equals: 'hello world'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestWithManyOperationQueryAndUnknownOperationName [
	| text |
	text := '
	query operationHello {
		hello
	}
	query operationHelloTo {
		helloTo(name: "Alex")
	}'.
	
	self should: [ self attendRequest: text using: 'operationUnknown' with: '' ] raise: GQLException.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestWithManyOperationQueryAndWithoutOperationName [
	| text |
	text := '
	query operationHello {
		hello
	}
	query operationHelloTo {
		helloTo(name: "Alex")
	}'.
	
	self should: [ self attendRequest: text using: nil with: '' ] raise: GQLException.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestWithManyOperationQueryWithDirectiveExclude [
	| response text |
	text := 'query operationHello {
		hello @skip(if: true)
	}
	query operationHelloTo {
		helloTo(name: "Alex") @skip(if: true)
	}'.
	response := self attendRequest: text using: 'operationHello' with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: response isEmpty.
	
	text := '
	query operationHello {
		hello @include(if: false)
	}
	query operationHelloTo {
		helloTo(name: "Alex") @include(if: false)
	}'.
	response := self attendRequest: text using: 'operationHello' with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: response isEmpty.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestWithManyOperationQueryWithDirectiveInclude [
	| response text |
	text := '
	query operationHello {
		hello @skip(if: false)
	}
	query operationHelloTo {
		helloTo(name: "Alex") @skip(if: false)
	}'.
	response := self attendRequest: text using: 'operationHelloTo' with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'helloTo') equals: 'hello Alex'.
	
	text := '
	query operationHello {
		hello @include(if: true)
	}
	query operationHelloTo {
		helloTo(name: "Alex") @include(if: true)
	}'.
	response :=  self attendRequest: text using: 'operationHelloTo' with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'helloTo') equals: 'hello Alex'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestWithOneOperationQuery [
	| response text |
	text := '
	query operationHello {
		hello
	}'.
	response := self attendRequest: text using: 'operationHello' with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'hello') equals: 'hello world'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestWithOneOperationQueryAndWithoutOperationName [
	| response text |
	text := '
	query operationHello {
		hello
	}'.
	response := self attendRequest: text using: nil with: ''.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'hello') equals: 'hello world'.
]

{ #category : #'test-simpleRequest' }
GQLDocumentNodeTest >> testSimpleRequestWithUnknownDirective [
	| text |
	text := '{
		hello @unknownDirective
	}'.
	
	self should: [ self attendRequest: text ] raise: GQLException.
	
	text := '{
		hello @unknownDirective(if : false)
	}'.
	
	self should: [ self attendRequest: text ] raise: GQLException.
	
]

{ #category : #'test-fragment' }
GQLDocumentNodeTest >> testUniquenessFragment [
	| document |
	document := self parseRequest: '{
		filmsWith(rating: 5) @skip(if : false) @include(if : true){
			...named
		}
	}
	fragment named on Film{
		name
	}
	fragment named on Film{
	   name
	}'.
	
	self should: [ document evaluate ] raise: GQLException.
]

{ #category : #'test-variables' }
GQLDocumentNodeTest >> testUniquenessVariableInvalid [
	| text textVariables |
	text := '
	query operation1($name: String, $name: String){
		helloTo(name: $name)
	}
	'.
	textVariables := '{"name":"Alex"}'.
	self should: [ self attendRequest: text using: 'operation1' with: textVariables ] raise: GQLException.
]

{ #category : #'test-variables' }
GQLDocumentNodeTest >> testUniquenessVariableValid [
	| response text textVariables |
	text := '
	query operation1($name: String){
		...fragHello
	}
	query operation2($name: String){
		...fragHello
	}
	fragment fragHello on GQLTestQueryType{
		helloTo(name: $name)
	}
	'.
	textVariables := '{"name":"Alex"}'.
	response := self attendRequest: text using: 'operation1' with: textVariables.
	
	self assert: response class: OrderedDictionary.
	self assert: (response at:'helloTo') equals: 'hello Alex'.
]

{ #category : #'test-fragment' }
GQLDocumentNodeTest >> testUsedFragments [

	| document  |
	document := self parseRequest: '{
		hello
	}
	fragment fragmentHello on GQLTestQueryType{
		hello
	}'.
	
	self should: [document evaluate] raise: GQLException.
]

{ #category : #'test-fragment' }
GQLDocumentNodeTest >> testUsedInlineFragments [

	| document  |
	document := self parseRequest: '{
		...fragmentHello
	}
	fragment fragmentHello on GQLTestQueryType{
		hello
		... { 
			...fragmentOther
		 }
	}
	fragment fragmentOther on GQLTestQueryType{
		hello
	}'.
	
	self assert: document evaluate class: GQLDocumentNode.
]

{ #category : #'test-variables' }
GQLDocumentNodeTest >> testUsedVariable [
	| text textVariables response |
	text := '
	query operation1($name:String){
		...fragHello
	}
	fragment fragHello on GQLTestQueryType{
		hello
	}
	'.
	textVariables := '{"name":"Alex"}'.
	self shouldnt: [ self attendRequest: text using: 'operation1' with: textVariables ] raise: GQLException.
	
	text := '
	query operation1($name:String){
		...fragHello
	}
	fragment fragHello on GQLTestQueryType{
		helloTo(name:$name)
	}
	'.
	response := self attendRequest: text using: 'operation1' with: textVariables.
	self assert: (response at: 'helloTo') equals: 'hello Alex'.

]

{ #category : #'test-variables' }
GQLDocumentNodeTest >> testValidationVariablesDocument [
	| text response textVariables |
	text := '
	query operation1($name:String, $bool:Boolean){
		helloTo(name:$name) @skip(if:$bool)
	}
	query operation2{
		hello
	}
	'.
	textVariables := '{"name":"Alex", "bool":false}'.
	response := self attendRequest: text using: 'operation2' with: textVariables.
	self assert: (response at: 'hello') equals: 'hello world'.
]
