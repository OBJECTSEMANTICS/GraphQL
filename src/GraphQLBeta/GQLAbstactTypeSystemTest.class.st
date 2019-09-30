"
I have the schemas definitions for my subclasses
"
Class {
	#name : #GQLAbstactTypeSystemTest,
	#superclass : #GQLTest,
	#instVars : [
		'dictSchema'
	],
	#category : #'GraphQLBeta-Tests-TypeValidation'
}

{ #category : #parsing }
GQLAbstactTypeSystemTest >> attendRequest: text using: operationName with: textVariables root: root [
	"The result is added a dictionary with the key 'data' according the specification found in: http://facebook.github.io/graphql/draft/#ExecuteQuery()"

	| document variables |
	document := self parseRequest: text.
	(document isKindOf: PPFailure) ifTrue: [ ^ document asJsonDictionary ].
	variables := textVariables isEmpty
		ifFalse: [ self parseVariables: textVariables ]
		ifTrue: [ nil ].
	^ GQLValidator new
		variables: variables;
		operationName: operationName;
		rootInstance: root;
		document: document;
		text: text;
		schema: schema;
		execute.
	
]

{ #category : #evaluation }
GQLAbstactTypeSystemTest >> evalSchemaWithKey: keySchema withRoot: aRoot [ 
	"Evaluate the schema accord the specification"
	| aSchema result |
	dictSchema at: keySchema 
	ifPresent: [ 
		aSchema := self parseSchema: (dictSchema at: keySchema).
		aSchema validate;
		root: aRoot.	
		result := self jsonSchema: aSchema.
	] 
	ifAbsent: [ result := nil ].
	^ result.
]

{ #category : #initialization }
GQLAbstactTypeSystemTest >> getSchema: keySchema withRoot: aRoot [ 
	| aSchema |
	dictSchema at: keySchema 
	ifPresent: [ :value |
		aSchema := self parseSchema: value.
		rootInstance := aRoot.
		aSchema := aSchema validate.
		aSchema root: rootInstance.	
	] 
	ifAbsent: [ aSchema := nil ].
	^ aSchema.
]

{ #category : #initialization }
GQLAbstactTypeSystemTest >> initDictSchema [
	^ Dictionary new 
	at: 'schemaWithMultipleInterface' put: '
		schema{
			query: GQLTestQueryType
		}
		interface NamedEntity{
			name : String
		}
		interface ClassName{
			className: String
		}
		type GQLTestQueryType{
			filmsWith(rating: Int): [GQLTestFilm]
		}
		type GQLTestFilm implements NamedEntity & ClassName{ 
        id : String
        name : String
		  className: String
      }
	';
	at: 'schemaWithUndefinedFieldInterface' put: '
		schema{
			query: GQLTestFilm
		}
		interface NamedEntity{
			name : String
		}
		interface MethodName{
			nameMethod: String
		}
		type GQLTestFilm implements NamedEntity & MethodName{ 
        id : String
        name : String
		  className: String
      }
	';
	at: 'schemaUndefinedAndWithManyTypes' put: '
		type GQLTestQueryType {
			hello: String
		}
		type GQLQueryRoot { 
			dog: GQLDog
		}
		type GQLDog { 
			name: String
			owner: GQLHuman
		}
		type GQLHuman { 
			name: String
		}
	';
	at: 'schemaNoRootOperationType' put: '
		schema { 
		}
		type Query { 
			hello: String
		 }
	';
	at: 'schemaNoRootOperationTypeQuery' put: '
		schema { 
			mutation: GQLMutation
		}
		type GQLMutation { 
			setNumber(to:Int): Int
		 }
	';
	at: 'schemaUndefined' put: (self parseSchema: '
		type GQLTestQueryType {
			hello: String
		}
	');
	at: 'schemaDefinedQueryTwice' put: '
		type Query{
			hello: String
		}
		type Query{
			film(name: String): String
		}
	';
	at: 'schemaDefinedTypeTwice' put: '
		type GQLTestQueryType{
			hello: String
		}
		type GQLTestQueryType{
			helloTo(name:String): String
		}
	';
	at: 'schemaWithUnknownFieldName' put: '
		type Query { 
			helloName: String
		}
	';
	at: 'schemaWithUnknownFieldNameMutation' put: '
		type GQLMutation { 
			setNumber2(to: Int): Int
		}
	';
	at: 'invalidDescriptionInType' put: '
		type "Query is the root operation query by default"
		Query { 
			hello: String
		}
	';
		at: 'invalidDescriptionInField' put: '
		type Query { 
			hello "field hello": String
		}
	';
	at: 'invalidBlockStringDescription' put: '
		type Query {
			"""
				first description with BlockString 
			""" 
			"""
				second description
			""""
			hello: String
		}
	';
	at: 'invalidStringDescription' put: '
		" description 1"
		" description 2"
		type Query { 
			hello: String
		}
	';
	at: 'inputIntType' put: '
	schema { 
		query: GQLTestSchema
	}
	type GQLTestSchema{
		filmsWith(rating: Int): [ GQLTestFilm ]
		isEven(number: Int): Boolean
	}
	type GQLTestFilm{
		name: String
	}
	';
	at: 'outputIntType' put: '
	schema { 
		query: GQLTestSchema
	}
	type GQLTestSchema{
		asText(number: Int): Int #return a number in String
		isEven(number: Int): Int #return a Boolean
		squareRoot(of: Float): Int #return a Float
	}
	';
	at: 'inputFloatType' put: '
	schema { 
		query: GQLTestSchema
	}
	type GQLTestSchema{
		point(x:Float, y:Float): Point
	}
	type Point{
		x: Float
		y: Float
	}';
	at: 'outputFloatType' put: '
	schema { 
		query: GQLTestSchema
	}
	type GQLTestSchema{
		asText(number: Float): Float # return the number as String
		totalFilms: Float #return a Int
		isEven(number: Float): Float #return a Boolean
		hello: Float #return a String
		point(x: Float, y: Float): Float #return a Point
	}
	type Point{
		x: Float
		y: Float
	}
	';
	at: 'inputStringType' put: '
		schema { 
		   query: GQLTestSchema
	   }
		enum MovieType{COMEDY, SCIENCE_FICTION, DRAMA}
		type GQLTestSchema{
			helloTo(name:String) : String
		}
	';
	at: 'outputStringType' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			hello: String
			totalFilms: String #return a Int
			isEven(number: Int): String #return a Boolean
			pi: String #return a Float #return a Float
			point(x: Float, y: Float): String #return a Point
		}
	';
	at: 'inputBooleanType' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			films(sortedByName: Boolean): [ GQLTestFilm ]
			hello: String
		}
		type GQLTestFilm{
			name: String
		}
	';
	at: 'outputBooleanType' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			hello : Boolean
			pi: Boolean
			totalFilms: Boolean
			point(x: Float, y: Float): Boolean
		}
	';
	at: 'inputIDType' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			filteredFilm(id: ID): GQLTestFilm
		}
		type GQLTestFilm{
			id: ID
			name: String
		}
	';
	at: 'outputIDType' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			hello : ID
			totalFilms: ID
			pi: ID
			isEven(number: Int): ID
			point(x: Float, y: Float): ID
		}
	';
	at: 'inputObjectTypeInvalid' put: '
		schema { 
			query: GQLTestQueryType
		}
		type GQLTestQueryType{
			information(film: GQLTestFilm) : GQLTestFilm
		}
		type GQLTestFilm{
			id: ID
			name: String
		}
	';
	at: 'inputObjectType' put: '
		schema { 
			query: GQLTestQueryType
		}
		type GQLTestQueryType{
			features(film: GQLFilmInput) : String
		}
		input GQLFilmInput{
			id: ID
			filmName: String
		}
	';
	at: 'outputObjectType' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			point(x: Float, y: Float): Point
			hello: Point #return a String
			cats: [ GQLCat ]
		}
		type Point{
			x: Float
			y: Float
		}
		type GQLCat{
			name: String
		}
	';
	at: 'inputInterfaceType' put: '
		schema { 
			query: GQLTestSchema
		}
	   interface NamedEntity{
	      name: String 
	   }
		type GQLTestSchema implements NamedEntity{
			name: String
			nameOf(item: NamedEntity): String
		}
		type GQLCat implements NamedEntity{
			name: String
			nickname: String
		}
	';
	at: 'outputInterfaceType' put: '
		schema { 
			query: GQLTestSchema
		}
	   interface NamedEntity{
	      name: String 
	   }
		type GQLTestSchema {
			entity: NamedEntity
			entities: [ NamedEntity ]
		}
		type GQLTestFilm implements NamedEntity { 
			name: String
			rating: Int
		}
		type GQLCat implements NamedEntity{
			name: String
			nickname: String
		}
	';
	at: 'inputUnionType' put: '
		schema { 
			query: GQLTestSchema
		}
	   union NamedObject = GQLCat | GQLTestFilm 
		type GQLTestSchema {
			nameOf(item: NamedObject): String
		}
		type GQLCat{
			name: String
			nickname: String
		}
		type GQLTestFilm{
			name: String
			rating: Int
		}
	';
	at: 'outputUnionType' put: '
		schema { 
			query: GQLTestSchema
		}
	   union SearchObject = Point | Rectangle
		type GQLTestSchema {
			firstSearchObject: SearchObject
		}
		type Point{
			x: Float
			y: Float
		}
		type Rectangle{
			origin: Point
			corner: Point
		}
	';
	at: 'inputEnumType' put: '
		schema { 
			query: GQLTestSchema
		}
		enum MovieType{COMEDY, SCIENCE_FICTION, DRAMA}
		type GQLTestSchema{
			classification(gender: MovieType): String
		}
	';
	at: 'outputEnumType' put: '
		schema { 
			query: GQLTestSchema
		}
		enum MovieType{COMEDY, SCIENCE_FICTION, DRAMA}
		type GQLTestSchema{
			totalFilms: MovieType
			hello: MovieType
			classification(gender: MovieType): MovieType
		}
	';
	at: 'inputInputObject' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema { 
			informationInput(film: GQLTestFilmInput): GQLTestQueryType
			inform(film: GQLFilmInput, id: Int): GQLFilm
		}
		input GQLTestFilmInput{
			id: Int
			filmName: String
		}
		type GQLFilm{
			id: Int
			filmName: String
		}
		input GQLFilmInput {
			id: Int!
			filmName : String
		}
		type GQLTestQueryType{
			description: String
			gender: String
		}
	';
	at: 'outputInputObject' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema { 
			information(film: GQLTestFilmInput) : GQLTestFilmInput
		}
		input GQLTestFilmInput{
			id: Int
			filmName: String
		}
	';
	at: 'inputList' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			filmsOn(genders: [MovieType]): [ GQLTestFilm ]
			nameGenders(listGender: [ MovieType ]): [ MovieType ]
			listOf(arrays: [ [ Int ] ]): [ [ Int ] ]
		}
		type GQLTestFilm { 
			id : ID
			name : String
			rating : Int
		}
		enum MovieType{COMEDY, SCIENCE_FICTION, ACTION}
	';
	at: 'outputList' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			filmsWith(rating : Int) : [ GQLTestFilm ]
			filmsWithNull(rating: Int): [ GQLTestFilm ]
			listOf(arrays: [ [ Int ] ]): [ [ Int ] ]
			hello: [ String ] #return a String
			totalFilms: [ Boolean ] #returns a Int
		}
		type GQLTestFilm{
			id : ID
			name : String
			rating : Int
		}
		enum MovieType{COMEDY, SCIENCE_FICTION, ACTION}
	';
	at: 'invalidOutputListString' put:  '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			listOf(arrays: [ [ Int ] ]): [ [ String ] ] #return a [ [ Int ] ]
		}
	';
	at: 'invalidOutputListBoolean' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			listOf(arrays: [ [ Int ] ]): [ [ Boolean ] ] #return a [ [ Int ] ]
		}
	';
	at: 'invalidOutputListEnum' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			listOf(arrays: [ [ Int ] ]): [ [ MovieType ] ] #return a [ [ Int ] ]
		}
		enum MovieType{COMEDY, SCIENCE_FICTION, ACTION}
	';
	at: 'inputNotNullValue' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			helloTo(name:String!) : String
			isEven(number: Int!): Boolean
			point(x:Float!, y:Float): Point
			listOf(arrays: [ [ Int! ]! ]!): [ [ Int ] ]
			nameGenders(listGender: [MovieType]!): [ MovieType ]
		}
		type Point{
			x: Float
			y: Float
		}
		enum MovieType{COMEDY, SCIENCE_FICTION, ACTION}
	';
	at: 'outputNotNullValue' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			filmsWith(rating : Int) : [ GQLTestFilm ]!
			point(x:Float, y:Float): Point!
			helloTo(name:String) : String!
		}
		type GQLTestFilm{
			id: Int
			filmName: String
		}
	';
	at: 'inputListNotNullValue' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			nameGenders(listGender: [ MovieType! ]): [ MovieType ]
			listOf(arrays: [ [ Int !]! ]!): [ [ Int ] ]
			totalInformation(film: [GQLTestQueryTypeInput]!): [ GQLTestQueryType]
		}
		input GQLTestQueryTypeInput{
			description: String
			gender: String
		}
		type GQLTestQueryType{
			description: String
			gender: String
		}
		enum MovieType{COMEDY, SCIENCE_FICTION, ACTION}
	';
	at: 'outputListNotNullValue' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema{
			listOf(arrays: [ [ Int ] ]): [ [ Int! ]! ]!
		}
	';
	at: 'inputVariable' put: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema { 
			helloTo(name: String!): String
			isEven(number: Int): Boolean
			informationInput(film: GQLTestFilmInput!): GQLTestQueryType
			point(x: Float!, y: Float): Point
		}
		input GQLTestFilmInput{
			id: Int!
			filmName: String
		}
		type GQLTestQueryType{
			description: String
			gender: String
		}
		type Point{
			x: Float!
			y: Float
		}
	';
	yourself.
]

{ #category : #initialization }
GQLAbstactTypeSystemTest >> setUp [
	dictSchema := self initDictSchema.
	compareJson := true.
]
