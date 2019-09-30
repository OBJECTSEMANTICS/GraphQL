"
A GQLSNodeEvaluatorTest is a test class for testing the behavior of GQLSNodeEvaluator
"
Class {
	#name : #GQLSSchemaNodeTest,
	#superclass : #GQLTest,
	#instVars : [
		'dictSchema'
	],
	#category : #'GraphQLBeta-Tests-Nodes'
}

{ #category : #initialization }
GQLSSchemaNodeTest >> initDictSchema [
	^ Dictionary new
	at: 'wrongDefinedObjExtensionManySchemas' put: (
	"Array of schemas"
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		type GQLTestQueryType {
			helloTo(name: String): String
		}'
		with: '
		extend type GQLTestQueryType { 
			cats: [ GQLCat ]
		}
		type GQLCat{ 
			name: String
		}')
	"Array of resolvers"
	with: (Array with: GQLTestQueryType)
	); 
	at: 'wrongDefinedObjExtensionOneSchema' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		type GQLTestQueryType {
			helloTo(name: String): String
		}
		extend type GQLTestQueryType {
			cats: [ GQLCat ]
		}
		type GQLCat {
			name : String
		}')
	with: (Array with: GQLTestQueryType)
	);
	at: 'wrongDefinedObjExtensWithInterface' put: (
	Array with:
		(Array with: '
		interface NamedEntity { 
			name: String
		}
		schema{
			query: GQLTestSchema
		}
		type GQLTestSchema {
			filmsSortedBy(name: Boolean): [ GQLTestFilm ]
		}
		type GQLTestFilm {
			rating : Int
		}'
		with: '
		extend interface NamedEntity{
			id: String
		}
		extend type GQLTestFilm implements NamedEntity {
			name: String
		}')
	with: (Array with: GQLTestSchema)
	);
	at: 'wrongDefinedObjectExtensWithResolvers' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		type GQLTestQueryType {
			hello: String
		}'
		with: '
		extend type GQLTestQueryType {
			asText(number: Int): String
		}')
	with: (Array with: GQLTestQueryType with: GQLFilm)
	);
	at: 'wrongInterfaceExtensManySchemas' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		interface DataEntity{
			name: String
		}
		type GQLTestQueryType {
			films: [ GQLTestFilm ]
		}
		type GQLTestFilm implements DataEntity{ 
			name: String
		}'
		with: '
		extend interface DataEntity {
			name: String
		}')
	with: (Array with: GQLTestQueryType)
	);
	at: 'wrongInterfaceExtensOneSchema' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		interface DataEntity{
			id: String
		}
		type GQLTestQueryType {
			films: [ GQLTestFilm ]
		}
		type GQLTestFilm implements DataEntity{ 
			name: String
			id: String
		}
		extend interface DataEntity { 
			id: String
		}
		')
	with: (Array with: GQLTestQueryType)
	);
	at: 'wrongUnionExtensionManySchemas' put: (
	Array with:
		(Array with: '
		schema { 
			query: GQLTestSchema
		}
	   union SearchObject = Point | Rectangle
		type GQLTestSchema {
			firstExtendedSearchObject: SearchObject
		}
		type Point{
			x: Float
			y: Float
		}
		type Rectangle{
			origin: Point
			corner: Point
		}
		'
		with: 'extend union SearchObject = Point | GQLDog
		type GQLDog { 
			name: String
		}
		')
	with: (Array with: GQLTestSchema)
	);
		at: 'wrongUnionExtensionOneSchema' put: (
	Array with:
		(Array with: '
		schema {
			query: GQLTestSchema
		}
		union SearchObject = Point | Rectangle
		type GQLTestSchema{
			firstExtendedSearchObject: SearchObject
		}
		type Point{
			x: Float
			y: Float
		}
		type Rectangle{
			origin: Point
			corner: Point
		}
		type GQLDog { 
			name: String
		}
		extend union SearchObject = Rectangle | GQLDog
		')
	with: (Array with: GQLTestSchema)
	);	
	at: 'wrongEnumExtensionManySchemas' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		enum MovieType{COMEDY, SCIENCE_FICTION}
		type GQLTestQueryType{
			classification(gender: MovieType): String
		}'
		with: 'extend enum MovieType { COMEDY }')
	with: (Array with: GQLTestQueryType));
	at: 'wrongEnumExtensionOneSchema' put: (
	Array with:
		(Array with: '
		schema{
			query: GQLTestQueryType
		}
		enum MovieType{COMEDY,  DRAMA}
		type GQLTestQueryType{
			classification(gender: MovieType): String
		}
		extend enum MovieType { DRAMA }')
	with: (Array with: GQLTestQueryType)
	);
	at: 'wrongInputObjectExtensManySchemas' put: (
	Array with:
		(Array with: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema { 
			inform(film: GQLFilmInput, id: Int): GQLFilm
		}
		type GQLFilm{
			id: Int
			filmName: String
		}
		input GQLFilmInput {
			id: Int!
		}'
		with: '
		extend input GQLFilmInput {
			id: Int!
		}')
	with: (Array with: GQLTestSchema)
	);
	at: 'wrongInputObjectExtensionOneSchema' put: (
	Array with:
		(Array with: '
		schema { 
			query: GQLTestSchema
		}
		type GQLTestSchema { 
			inform(film: GQLFilmInput, id: Int): GQLFilm
		}
		type GQLFilm{
			id: Int
			filmName: String
		}
		input GQLFilmInput {
			filmName: String
		}
		extend input GQLFilmInput {
			filmName : String
		}')
	with: (Array with: GQLTestSchema)
	);
	yourself
]

{ #category : #initialization }
GQLSSchemaNodeTest >> setUp [
	dictSchema := self initDictSchema 
]

{ #category : #'tests-visiting' }
GQLSSchemaNodeTest >> testDescription [
	| typeA argument |
	schema := self parseSchema: '
							schema { 
								query: A
							}
							"type A contains three fields"
							type A {
								b (id: Int): B
								c (p1: [Int], p2:String): [Int]
								d (param:String)	:String 
							},
							"the last field is validated"
							type B {
								someName 	: [String ! ]
								someName 	:String 
							}'.
	typeA := schema getType: 'A'.
	argument := (typeA getField: 'd') getArgument: 'param'.
	self assert: typeA class: GQLSObjectTypeNode.
	self assert: argument class: GQLSInputObjectFieldNode.
	self assert: argument type class: GQLSStringTypeNode.
	self assert: (typeA getField: 'b') type class: GQLSNamedTypeNode .
	
	argument := (typeA getField: 'c') getArgument: 'p1'.
	self assert: argument type class: GQLSListTypeNode
]

{ #category : #'tests-visiting' }
GQLSSchemaNodeTest >> testEvaluate [
	| typeA argument |
	schema := self parseSchema: 'type A {
								b (id: Int): B
								c (p1: [Int], p2:String): [Int]
								d (param:String)	:String 
							},
							type B {
								someName 	: [String ! ]
								someName 	:String 
							}'.
	typeA := schema getType: 'A'.
	argument := (typeA getField: 'd') getArgument: 'param'.
	self assert: typeA class: GQLSObjectTypeNode.
	self assert: argument class: GQLSInputObjectFieldNode.
	self assert: argument type class: GQLSStringTypeNode.
	self assert: (typeA getField: 'b') type class: GQLSNamedTypeNode .
	
	argument := (typeA getField: 'c') getArgument: 'p1'.
	self assert: argument type class: GQLSListTypeNode
]

{ #category : #'tests-extension' }
GQLSSchemaNodeTest >> testFailValidateEnumTypeExtension [
	schema := self parseSchema: '
	schema { 
		query: GQLTestQueryType
	}
	enum MovieType{COMEDY, SCIENCE_FICTION}
	type GQLTestQueryType{
		classification(gender: MovieType): String
	}
	extend enum MovieTypeOther { DRAMA }'.
	self should: [ schema validate ] raise: GQLValidationException.
	
	schema := self parseSchema: '
	schema { 
		query: GQLTestQueryType
	}
	enum MovieType{COMEDY, SCIENCE_FICTION}
	type GQLTestQueryType{
		classification(gender: MovieType): String
	}
	extend enum MovieType { COMEDY }
	'.
	self should: [ schema validate ] raise: GQLValidationException.
]

{ #category : #'tests-extension' }
GQLSSchemaNodeTest >> testFailValidateInputObjectTypeExtension [

	schema := self parseSchema: '
							schema { 
								query: GQLTestQueryTypeInput
							}
							type GQLTestQueryType { 
								description: String
							}
							input GQLTestQueryTypeInput{ 
            					description : String
         					}
							extend input GQLTestQueryTypeInputOther{
								gender: String!
							}'.
	
	self should: [ schema validate ] raise: GQLValidationException.
	
	schema := self parseSchema: '
							schema { 
								query: GQLTestQueryType
							}
							type GQLTestQueryType { 
								description: String
							}
							input GQLTestQueryTypeInput{ 
            					description : String
         					}
							extend input GQLTestQueryTypeInput{
								gender: String!
								description: String
							}'.
	
	self should: [ schema validate ] raise: GQLValidationException.
]

{ #category : #'tests-extension' }
GQLSSchemaNodeTest >> testFailValidateInterfaceTypeExtension [
	| valid |
	schema := self parseSchema: '
						schema { 
							query: Query
						}
						type GQLFilm implements RelevantData { 
							name: String
						}
						interface RelevantData{
							name : String
						}
						extend interface OtherInterface{
							id: String
						}'.
	self should: [ schema validate ] raise: GQLValidationException.
	
	schema := self parseSchema: '
						schema { 
							query: Query
						}
						type GQLFilm implements RelevantData { 
							name: String
						}
						interface RelevantData{
							name : String
						}
						extend interface RelevantData{
							name: String
							id: String
						}'.
	self should: [ schema validate ] raise: GQLValidationException.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						interface NamedEntity{
							name: String
						}
						extend interface NamedEntity{
							id: String
						}
						type GQLTestFilm implements NamedEntity{
							name: String
						}'.
	self should: [ schema validate ] raise: GQLValidationException.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						interface NamedEntity{
							name: String
						}
						extend interface NamedEntity{
							id: String
						}
						type GQLTestFilm{
							filmName: String
						}
						extend type GQLTestFilm implements NamedEntity{
							id: String
						}'.
	valid := schema validate.
	self should: [ schema validate ] raise: GQLValidationException.
	
]

{ #category : #'tests-extension' }
GQLSSchemaNodeTest >> testFailValidateObjectTypeExtension [
	| valid |
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						type GQLTestFilm{
							id: String
						}
						extend type GQLTestQueryType{
							name: String
						}'.
	self should: [ schema validate ] raise: GQLValidationException.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						type GQLTestFilm{
							id: String
						}
						input GQLTestQueryTypeInput{ 
            					description : String
         				}
						extend type GQLTestQueryTypeInput{
							gender: String
						}'.
	self should: [ schema validate ] raise: GQLValidationException.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						type GQLTestFilm{
							id: String
						}
						extend type GQLTestFilm{
							id: String
							filmName: String
						}'.
	self should: [ schema validate ] raise: GQLValidationException.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						interface NamedEntity{
							name: String
						}
						type GQLTestFilm implements NamedEntity{
							id: String
							name: String
						}
						extend type GQLTestFilm implements NamedEntity{
							filmName: String
						}'.
	valid := schema validate.
	self should: [ schema validate ] raise: GQLValidationException.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						interface NamedEntity{
							name: String
						}
						type GQLTestFilm implements NamedEntity{
							id: String
						}
						extend type GQLTestFilm {
							filmName: String
						}'.
	self should: [ schema validate ] raise: GQLValidationException.
	
]

{ #category : #tests }
GQLSSchemaNodeTest >> testFailValidateObjectTypesInterface [

	schema := self parseSchema: '
						interface GQLTest{
							name : String
							rating : Int
						}
						type GQLTestFilm implements GQLTest{ 
            					id : String
            					name : String
         					}'.
	self should: [ schema validateObjectTypes ] raise: GQLValidationException
]

{ #category : #tests }
GQLSSchemaNodeTest >> testFailValidateObjectTypesInterfaceMultiple [

	schema := self parseSchema: '
						interface NamedEntity{
							name : String
						}
						interface ClassName{
							nameMethod: String
						}
						type GQLTestFilm implements NamedEntity & ClassName{ 
            					id : String
            					name : String
								className: String
         				}'.
	self should: [ schema validateObjectTypes ] raise: GQLValidationException
]

{ #category : #tests }
GQLSSchemaNodeTest >> testFailValidateObjectTypesInterfaceWithArguments [

	schema := self parseSchema: '
						interface GQLTest{
							name(arg1 : Int, arg2 : String) : String
						}
						type GQLTestFilm implements GQLTest{ 
            					id : String
            					name(arg1 : Int) : String
         					}'.
	self should: [ schema validateObjectTypes ] raise: GQLValidationException
]

{ #category : #tests }
GQLSSchemaNodeTest >> testFailValidateSchemaDefinition [

	schema := self parseSchema: '
						schema{
							query: Query
							query: GQLTestQueryType
						}
						type GQLTestFilm { 
            					id : String
            					name: String
         				}'.
	self should: [ schema validateSchemaDefinition ] raise: GQLValidationException.
	
	schema := self parseSchema: '
						schema { 
							query: Query
						}
						type GQLTestFilm { 
							id: String
							name: String
						}'.
	self should: [ schema validateSchemaDefinition ] raise: GQLValidationException.
	
	schema := self parseSchema: '
						schema { 
							mutation: GQLTestFilm
						}
						type GQLTestFilm { 
							id: String
							name: String
						}'.
	self should: [ schema validateSchemaDefinition ] raise: GQLValidationException.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
							mutation: GQLTestQueryType
						}
						type GQLTestFilm { 
							id: String
							name: String
						}'.
	self should: [ schema validateSchemaDefinition ] raise: GQLValidationException.
]

{ #category : #'tests-extension' }
GQLSSchemaNodeTest >> testFailValidateSchemaExtension [
	schema := self parseSchema: '
	extend schema { 
		query: Query
	}
	extend schema{
		mutation: GQLTestMutationType
		mutation: Query
	}
	type Query{
		hello: String
	}
	type GQLTestMutationType{
		createPoint(x: Int, y: Int): Point
	}
	type Point{
		x: Int
		y: Int
	}
	'.
	self should: [ schema validate] raise: GQLValidationException.
	
	schema := self parseSchema: '
	extend schema { 
		query: GQLTestQueryType
		query: Query
	}
	type GQLTestQueryType { 
		helloTo(name: String): String
	}
	type Query{
		hello: String
	}
	'.
	self should: [ schema validateSchemaExtensions ] raise: GQLValidationException.
	
	schema := self parseSchema: '
	extend schema { 
		mutation: GQLTestMutationType
		mutation: Query
	}
	type Query{
		hello: String
	}
	type GQLTestMutationType { 
		createPoint(x: Int, y: Int): Point
	}
	type Point { 
		x: Int
		y: Int
	}
	'.
	self should: [ schema validateSchemaExtensions ] raise: GQLValidationException.

]

{ #category : #'tests-extension' }
GQLSSchemaNodeTest >> testFailValidateUnionTypeExtension [

	schema := self parseSchema: '
							schema { 
								query: GQLTestQueryType
							}
							union Filmed = GQLTestFilm | Film
							type GQLTestQueryType{
								description: String
							}
							type GQLTestFilm { 
            					id : String
            					name : String
         					}
							type Film { 
            					name : String
								rating : Int
         					}
							extend union OtherUnion = GQLTestQueryType'.
	self should: [ schema validate ] raise: GQLValidationException.
	
	schema := self parseSchema: '
							schema { 
								query: GQLTestQueryType
							}
							union Filmed = GQLTestFilm | Film
							type GQLTestQueryType{
								description: String
							}
							type GQLTestFilm { 
            					id : String
            					name : String
         					}
							type Film { 
            					name : String
								rating : Int
         					}
							extend union Filmed = GQLTestQueryType | GQLTestFilm'.
	self should: [ schema validate ] raise: GQLValidationException.
]

{ #category : #tests }
GQLSSchemaNodeTest >> testFullName [

	| objectType field|
	schema := self parseSchema: 'type GQLTestFilm{ 
            id : String
            name : String
         }'.
	objectType := schema getType: 'GQLTestFilm'.
	self assert: objectType name: 'GQLTestFilm'.
	field := objectType getField: 'name'.
	self assert: field fullName: 'name'.
	field := objectType getField: 'id'.
	self assert: field fullName: 'id'
]

{ #category : #tests }
GQLSSchemaNodeTest >> testFullNameWithParameters [
	|  objectType field |
	schema := self parseSchema: 'type GQLIBType{ 
            					some (name : String, parameters : String) : String
         					}'.
	objectType := schema getType: 'GQLIBType'.
	self assert: objectType name: 'GQLIBType'.
	field := objectType getField: 'some'.
	self assert: field fullName: 'someName:parameters:'
]

{ #category : #tests }
GQLSSchemaNodeTest >> testInvalidateSimpleClass [
	schema := self parseSchema: 'type GQLTestFilm{ 
            					actors : String
         					}'.
	self assert: schema validate class: GQLValidationException
]

{ #category : #tests }
GQLSSchemaNodeTest >> testInvalidateSimpleClassWithParameters [
	schema := self parseSchema: 'type GQLIBType{ 
            					some (name : String) : String
         					}'.
	self assert: schema validate class: GQLValidationException
]

{ #category : #tests }
GQLSSchemaNodeTest >> testNodesParametersPosition [
	| type field parameter |
	schema := self parseSchema: 'type GQLTestFilm{ 
            id : String
            name (id : String) : String
         }'.
	type := schema getType: 'GQLTestFilm'.
	field := type getField: 'id'.
	self assert: type position: 6.
	self assert: field position: 32.
	field := type getField: 'name'.
	self assert: field position: 56.
	parameter := field getArgument: 'id'.
	self assert: parameter position: 62
]

{ #category : #tests }
GQLSSchemaNodeTest >> testNodesPosition [
	| type field |
	schema := self parseSchema: 'type GQLTestFilm{ 
            					id : String
            					name : String
         					}'.
	type := schema getType: 'GQLTestFilm'.
	field := type getField: 'name'.
	self assert: type position: 6.
	self assert: field position: 66.
	field := type getField: 'id'.
	self assert: field position: 37
]

{ #category : #'tests-extension' }
GQLSSchemaNodeTest >> testValidateEnumTypeExtension [
	schema := self parseSchema: '
	schema { 
		query: GQLTestQueryType
	}
	enum MovieType{COMEDY, SCIENCE_FICTION}
	type GQLTestQueryType{
		classification(gender: MovieType): String
	}
	extend enum MovieType { DRAMA }
	'.
	self assert: schema validate class: GQLSSchemaNode
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateInputObject [

	schema := self parseSchema: '
							schema{
								query: GQLTestQueryType
							}
							type GQLTestQueryType{
								information(film: GQLTestQueryTypeInput): GQLTestQueryType
							}
							input GQLTestQueryTypeInput{ 
            					description : String
            					gender : String!
         					}'.
	self assert: schema validate class: GQLSSchemaNode
]

{ #category : #'tests-extension' }
GQLSSchemaNodeTest >> testValidateInputObjectTypeExtension [

	schema := self parseSchema: '
							schema { 
								query: GQLTestQueryType
							}
							type GQLTestQueryType { 
								hello: String
							}
							input GQLTestQueryTypeInput{ 
            					description : String
         					}
							extend input GQLTestQueryTypeInput{
								gender: String!
							}'.
	
	self assert: schema validate class: GQLSSchemaNode
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateInterface [

	schema := self parseSchema: '
							schema{
								query: GQLTestFilm
							}
							interface MyObject{
								name : String
							}
							type GQLTestFilm implements MyObject{ 
            					id : String
            					name : String
         					}'.
	self assert: schema validate class: GQLSSchemaNode
]

{ #category : #'tests-extension' }
GQLSSchemaNodeTest >> testValidateInterfaceTypeExtension [

	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						type GQLTestFilm { 
							name: String
						}
						interface RelevantData{
							name : String
						}
						extend interface RelevantData{
							id: String
						}'.
	self assert: schema validate class: GQLSSchemaNode.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						interface RelevantData{
							name: String
						}
						extend interface RelevantData{
							id: String
						}
						type GQLTestFilm implements RelevantData{
							name: String
						}
						extend type GQLTestFilm { 
							id: String
						}
						'. 
	self assert: schema validate class: GQLSSchemaNode.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						interface RelevantData{
							name : String
						}
						extend interface RelevantData{
							id: String
						}
						type GQLTestFilm {
							name: String
							filmName: String
						}
						extend type GQLTestFilm implements RelevantData{ 
							id: String
						}'.
	self assert: schema validate class: GQLSSchemaNode.
]

{ #category : #'tests-introspection' }
GQLSSchemaNodeTest >> testValidateIntrospectionEnum [

	schema := self parseSchema: '
	enum __TypeKind {
  		SCALAR
  		OBJECT
  		INTERFACE
  		UNION
  		ENUM
  		INPUT_OBJECT
  		LIST
  		NON_NULL
	}'.
	self assert: schema validateObjectTypes class: GQLSSchemaNode.
	
	schema := self parseSchema: 'enum __DirectiveLocation {
  		QUERY
  		MUTATION
  		SUBSCRIPTION
  		FIELD
  		FRAGMENT_DEFINITION
  		FRAGMENT_SPREAD
  		INLINE_FRAGMENT
  		SCHEMA
  		SCALAR
  		OBJECT
  		FIELD_DEFINITION
  		ARGUMENT_DEFINITION
  		INTERFACE
  		UNION
  		ENUM
  		ENUM_VALUE
  		INPUT_OBJECT
  		INPUT_FIELD_DEFINITION
	}'.
	self assert: schema validateObjectTypes class: GQLSSchemaNode.
]

{ #category : #'tests-introspection' }
GQLSSchemaNodeTest >> testValidateIntrospectionType [

	schema := self parseSchema: '
		type __Schema { 
			types: [ __Type! ]!
			queryType: __Type!
			mmutationType: __Type
			subscriptionType: __Type
			directives: [ __Directives! ]!
		}'.
	self assert: schema validateObjectTypes class: GQLSSchemaNode.
	
	schema := self parseSchema: '
		type __Type { 
			kind: __TypeKind!
			name: String
			description: String
  			fields(includeDeprecated: Boolean): [__Field!]
  			interfaces: [__Type!]
  			possibleTypes: [__Type!]
  			enumValues(includeDeprecated: Boolean): [__EnumValue!]
  			inputFields: [__InputValue!]
  			ofType: __Type
		}'.
	self assert: schema validateObjectTypes class: GQLSSchemaNode.
	
	schema := self parseSchema: '
	type __Field {
  name: String!
  description: String
  args: [__InputValue!]!
  type: __Type!
  isDeprecated: Boolean!
  deprecationReason: String
}'.
	self assert: schema validateObjectTypes class: GQLSSchemaNode.
	
	schema := self parseSchema: '
	type __InputValue {
  name: String!
  description: String
  type: __Type!
  defaultValue: String
}'.
	self assert: schema validateObjectTypes class: GQLSSchemaNode.
	
	schema := self parseSchema: '
	type __EnumValue {
  name: String!
  description: String
  isDeprecated: Boolean!
  deprecationReason: String
}'.
	self assert: schema validateObjectTypes class: GQLSSchemaNode.
	
	schema := self parseSchema: '
	type __Directive {
  name: String!
  description: String
  locations: [__DirectiveLocation!]!
  args: [__InputValue!]!
}'.
	self assert: schema validateObjectTypes class: GQLSSchemaNode.
	
	
]

{ #category : #'tests-extension' }
GQLSSchemaNodeTest >> testValidateObjectTypeExtension [

	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						type GQLTestFilm{
							id: String
						}
						extend type GQLTestFilm{
							name: String
						}'.
	self assert: schema validate class: GQLSSchemaNode.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						interface NamedEntity { 
							name: String
						}
						type GQLTestFilm implements NamedEntity{
							id: String
						}
						extend type GQLTestFilm{
							name: String
						}'.
	self assert: schema validate class: GQLSSchemaNode.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						interface NamedEntity { 
							name: String
						}
						type GQLTestFilm{
							id: String
							name: String
						}
						extend type GQLTestFilm implements NamedEntity'.
	self assert: schema validate class: GQLSSchemaNode.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						interface NamedEntity { 
							name: String
						}
						interface Identifier{
							id: String
						}
						type GQLTestFilm implements NamedEntity & Identifier{
							description: String
							id: String
						}
						extend type GQLTestFilm{
							name: String
						}'.
	self assert: schema validate class: GQLSSchemaNode.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						interface NamedEntity { 
							name: String
						}
						interface Identifier{
							id: String
						}
						type GQLTestFilm implements NamedEntity {
							description: String
							id: String
						}
						extend type GQLTestFilm implements Identifier{
							name: String
						}'.
	self assert: schema validate class: GQLSSchemaNode.
	
	schema := self parseSchema: '
						schema { 
							query: GQLTestFilm
						}
						interface NamedEntity { 
							name: String
						}
						interface Identifier{
							id: String
						}
						type GQLTestFilm implements NamedEntity {
							description: String
						}
						extend type GQLTestFilm implements Identifier{
							name: String
							id: String
						}'.
	self assert: schema validate class: GQLSSchemaNode
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateObjectTypesInterface [

	schema := self parseSchema: '
						interface GQLTest{
							name : String
						}
						type GQLTestFilm implements GQLTest{ 
            					id : String
            					name : String
         					}'.
	self assert: schema validateObjectTypes class: GQLSSchemaNode
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateObjectTypesInterfaceMultiple [

	schema := self parseSchema: '
						interface NamedEntity{
							name : String
						}
						interface ClassName{
							className: String
						}
						type GQLTestFilm implements NamedEntity & ClassName{ 
            					id : String
            					name : String
								className: String
         				}'.
	self assert: schema validateObjectTypes class: GQLSSchemaNode
]

{ #category : #'tests-extension' }
GQLSSchemaNodeTest >> testValidateSchemaExtension [
	schema := self parseSchema: '
	schema {
		query: GQLTestQueryType
	} 
	extend schema { 
		mutation: GQLTestMutationType
	}
	type GQLTestQueryType { 
		hello: String
	}
	type GQLTestMutationType { 
		createPoint(x:Int, y:Int) : Point
	}
	type Point { 
		x: Float
		y: Float
	}
	'.
	self assert: schema validateSchemaExtensions class: GQLSSchemaNode.
	
	schema := self parseSchema: '
	schema {
		query: GQLTestQueryType
	} 
	extend schema { 
		query: Query
		mutation: GQLTestMutationType
	}
	type Query { 
		hello: String
	}
	type GQLTestQueryType { 
		hello: String
	}
	type GQLTestMutationType { 
		createPoint(x:Int, y:Int) : Point
	}
	type Point { 
		x: Float
		y: Float
	}
	'.
	self assert: schema validateSchemaExtensions class: GQLSSchemaNode
]

{ #category : #'tests-introspection' }
GQLSSchemaNodeTest >> testValidateSchemaIntrospection [
	| schemaNode type |
	schema := self parseSchema: '
					schema { 
						query: GQLTestFilm
					}
					type GQLTestFilm{ 
            				id : String
            				name : String
							film : GQLFilm
         			}
					type GQLFilm { 
							id : String 
					}	
					'.
	schemaNode := schema validate.
	self assert: schemaNode class: GQLSSchemaNode.
	self assert: schemaNode types size equals: 15.
	type := schemaNode getType: '__Schema'.
	self assert: type name equals: 'GQLSSchemaNode'.
	self assert: type fields size equals: 5.
	self assertCollection: type fields keys 
	hasSameElements: #('types' 'queryType' 'directives' 'mutationType' 'subscriptionType').
	type := schemaNode getType: '__Type'.
	self assert: type name equals: 'GQLSTypeNode'.
	self assertCollection: type fields keys hasSameElements: #('kind' 'name' 'description' 'fields' 'interfaces' 'possibleTypes' 'enumValues' 'inputFields' 'ofType').
	type := schemaNode getType: '__Field'.
	self assert: type name equals: 'GQLSFieldNode'.
	self assertCollection: type fields keys hasSameElements: #('name' 'description' 'args' 'type' 'isDeprecated' 'deprecationReason').
	type := schemaNode getType: '__InputValue'.
	self assert: type name equals: 'GQLSInputObjectFieldNode'.
	self assertCollection: type fields keys hasSameElements: #('name' 'description' 'type' 'defaultValue').
	type := schemaNode getType: '__EnumValue'.
	self assert: type name equals: 'GQLSEnumValue'.
	self assertCollection: type fields keys hasSameElements: #('name' 'description' 'isDeprecated' 'deprecationReason').
	type := schemaNode getType: '__Directive'.
	self assert: type name equals: 'GQLSDirectiveNode'.
	self assertCollection: type fields keys hasSameElements: #('name' 'description' 'locations' 'args').
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateSchemaWithListNamedType [

	schema := self parseSchema: '
					schema { 
						query: GQLTestQueryType
					}
					type GQLTestQueryType { 
						films : [ GQLTestfilm] !
					 }
					type GQLTestFilm{ 
            				id : String
            				name : String
							film : GQLFilm
         			}
					type GQLFilm { 
							id : String 
					}	
					'.
	self assert: schema validate class: GQLSSchemaNode
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateSimpleClass [

	schema := self parseSchema: '
							schema { 
								query: GQLTestFilm
							}
							type GQLTestFilm{ 
            					id : String
            					name : String
         					}'.
	self assert: schema validate class: GQLSSchemaNode
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateSimpleClassWithInputObject [

	schema := self parseSchema: '
					schema{
						query: GQLTestQueryType
					}
					type GQLTestQueryType { 
						films : [ GQLTestfilm] !
						information(film: GQLTestQueryTypeInput): GQLTestQueryType
					 }
					type GQLTestFilm{ 
            				id : String
            				name : String
         			}
					input GQLTestQueryTypeInput { 
							description : String
					}'.
	self assert: schema validate class: GQLSSchemaNode
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateSimpleClassWithListInputObject [

	schema := self parseSchema: '
					schema { 
						query: GQLTestQueryType
					}
					type GQLTestQueryType { 
						films : [ GQLTestfilm ] !
						totalInformation(film: [GQLInputFilm]): [GQLFilm]
					 }
					type GQLTestFilm{ 
            				id : String
            				name : String
							film : GQLFilm
         			}
					type GQLFilm { 
							id : String 
					}	
					'.
	self assert: schema validate class: GQLSSchemaNode
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateSimpleClassWithManyNamedType [

	schema := self parseSchema: '
					schema { 
						query: GQLTestQueryType
					}
					type GQLTestQueryType { 
						films : [ GQLTestfilm ] !
					 }
					type GQLTestFilm{ 
            				id : String
            				name : String
							film : GQLFilm
         			}
					type GQLFilm { 
							id : String 
					}	
					'.
	self assert: schema validate class: GQLSSchemaNode
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateSimpleClassWithNamedType [

	schema := self parseSchema: 'type A {
					id: InternalCount
					isB: BooleanType
					size: Int
					idA: ID_A
					values: [ Int ! ]
					params (name: StringName, prom: FloatingPoint, key: String): [Int]
				}'.
	self assert: (schema schemaTypes at: 'A') class equals: GQLSObjectTypeNode;
		assert: ((schema schemaTypes at: 'A') getField: 'id') type class
			equals: GQLSNamedTypeNode;
		assert: ((schema schemaTypes at: 'A') getField: 'id') type name
			equals: 'InternalCount';
		assert: ((schema schemaTypes at: 'A') getField: 'isB') type class
			equals: GQLSNamedTypeNode;
		assert: ((schema schemaTypes at: 'A') getField: 'isB') type name
			equals: 'BooleanType';
		assert: ((schema schemaTypes at: 'A') getField: 'size') type class
			equals: GQLSIntTypeNode;
		assert: ((schema schemaTypes at: 'A') getField: 'idA') type class
			equals: GQLSNamedTypeNode;
		assert: ((schema schemaTypes at: 'A') getField: 'values') type class
			equals: GQLSListTypeNode;
		assert: ((schema schemaTypes at: 'A') getField: 'values') type wrappedType class
			equals: GQLSNonNullTypeNode;
		assert: ((schema schemaTypes at: 'A') getField: 'params') type class
			equals: GQLSListTypeNode;
		assert:
			(((schema schemaTypes at: 'A') getField: 'params') arguments at: 'name') type
				class
			equals: GQLSNamedTypeNode;
		assert:
			(((schema schemaTypes at: 'A') getField: 'params') arguments at: 'prom') type
				class
			equals: GQLSNamedTypeNode;
		assert:
			(((schema schemaTypes at: 'A') getField: 'params') arguments at: 'key') type
				class
			equals: GQLSStringTypeNode
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateSimpleClassWithParameters [

	schema := self parseSchema: '
							schema { 
								query: GQLIQueryType
							}
							type GQLIQueryType{ 
            					sum (nums: [Int]) : Int
         					}'.
	self assert: schema validate class: GQLSSchemaNode
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateSimpleClassWithParametersAndInputObject [

	schema := self parseSchema: '
					schema { 
						query: GQLTestFilm
					}
					type GQLTestFilm{ 
            				id : String
            				name : String
							film : GQLFilm
         			}
					type GQLFilm { 
							id : String 
					}	
					'.
	self assert: schema validate class: GQLSSchemaNode
]

{ #category : #tests }
GQLSSchemaNodeTest >> testValidateUnion [

	schema := self parseSchema: '
							union Filmed = GQLTestFilm | Film
							interface MyObject{
								name : String
							}
							type GQLTestFilm implements MyObject{ 
            					id : String
            					name : String
         					}
							type Film implements MyObject{ 
            					name : String
								rating : Int
         					}'.
	self assert: schema validateUnionTypes class: GQLSSchemaNode
]

{ #category : #'tests-extension' }
GQLSSchemaNodeTest >> testValidateUnionTypeExtension [

	schema := self parseSchema: '
							schema { 
								query: GQLTestQueryType
							}
							union Filmed = GQLTestFilm | Film
							type GQLTestQueryType{
								description: String
							}
							type GQLTestFilm { 
            					id : String
            					name : String
         					}
							type Film { 
            					name : String
								rating : Int
         					}
							extend union Filmed = GQLTestQueryType'.
	self assert: schema validate class: GQLSSchemaNode.
]
