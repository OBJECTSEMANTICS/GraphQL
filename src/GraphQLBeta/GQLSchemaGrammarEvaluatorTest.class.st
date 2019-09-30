"
A GQLSchemaGrammarEvaluatorTest is a test class for testing the behavior of GQLSchemaGrammarEvaluator
"
Class {
	#name : #GQLSchemaGrammarEvaluatorTest,
	#superclass : #GQLTest,
	#category : #'GraphQLBeta-Tests-Grammar'
}

{ #category : #'test-schemaDescription' }
GQLSchemaGrammarEvaluatorTest >> testDescriptionEnum [
	| text enum enumValues |
	text := '
		"""description of enum""" 
		enum Shapes { 
		"Rectangle" RECTANGLE
		"Circle" CIRCLE
		 }
	'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	enum := schema getType: 'Shapes'.
	self assert: enum class equals: GQLSEnumTypeNode.
	self assert: enum description value = '"""description of enum"""'.
	enumValues := enum values.
	self assert: enumValues first value = 'RECTANGLE'.
	self assert: enumValues first description value = '"Rectangle"'.
	self assert: enumValues second value = 'CIRCLE'.
	self assert: enumValues second description value = '"Circle"'.
]

{ #category : #'test-schemaDescription' }
GQLSchemaGrammarEvaluatorTest >> testDescriptionFieldArguments [
	| text  node |
	text := '
		type Query { 
			hello("especify the name of argument" to: String): String
		}
	'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	node := schema getType: 'Query'.
	self assert: node class equals: GQLSObjectTypeNode.
	node := (node getField: 'hello') getArgument: 'to'.
	self assert: node description value = '"especify the name of argument"'.
	

]

{ #category : #'test-schemaDescription' }
GQLSchemaGrammarEvaluatorTest >> testDescriptionInType [
	| text query description |
	text := '
		"Query is the root operation type of schema by default"
		type Query { 
			"""
			block comment
			with many lines
			"""
			hello: String
		}
	'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	query := schema getType: 'Query'.
	self assert: query class equals: GQLSObjectTypeNode.
	description := query description.
	self assert: description value = '"Query is the root operation type of schema by default"'.
	description := (query getField: 'hello') description.
	self assert: description value = 
			'"""
			block comment
			with many lines
			"""'.
	

]

{ #category : #'test-schemaDescription' }
GQLSchemaGrammarEvaluatorTest >> testDescriptionInputObjects [
	| text inputObject |
	text := '
		"description of input object" input ObjectInput{
			name: String
			value: Int
		 }
	'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	inputObject := schema getType: 'ObjectInput'.
	self assert: inputObject class equals: GQLSInputObjectTypeNode.
	self assert: inputObject description value = '"description of input object"'.

]

{ #category : #'test-schemaDescription' }
GQLSchemaGrammarEvaluatorTest >> testDescriptionInterface [
	| text interface |
	text := '
		""""description of interface""" 
		interface NamedEntity { 
			name: String
		}
	'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	interface := schema getType: 'NamedEntity'.
	self assert: interface class equals: GQLSInterfaceTypeNode.
	self assert: interface description value = '""""description of interface"""'.
]

{ #category : #'test-schemaDescription' }
GQLSchemaGrammarEvaluatorTest >> testDescriptionUnion [
	| text  union |
	text := '
		""""description of 
		union""" 
		union Shapes = Rectangle | Circle
	'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	union := schema getType: 'Shapes'.
	self assert: union class equals: GQLSUnionTypeNode.
	self assert: union description =
	'""""description of 
		union"""'.
	

]

{ #category : #'test-schemaDefinition' }
GQLSchemaGrammarEvaluatorTest >> testIncompleteSchemaDefinition [
	| text |
	"Error: Specified query type \'Query\' not found in document."
	text := 'schema{
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'schema{
						query: 
					}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'schema{
						query: Query
						mutation: 
					}
					type Query{
						hello: String
					}
					'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
]

{ #category : #'test-schemaEnumType' }
GQLSchemaGrammarEvaluatorTest >> testIncompleteSchemaEnumType [
	| text |
	text := 'enum CatCommand {}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'enum { JUMP }'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'enum CatCommand { JUMP'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure
]

{ #category : #'test-schemaInputObjectType' }
GQLSchemaGrammarEvaluatorTest >> testIncompleteSchemaInputObjectType [
	| text |
	text := 'input ExampleInputObject {
 			 	a: String
  				b: !
				c: OtherInputObject
			}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'input ExampleInputObject {
 			 	a: String
  				b: Int!
				c: OtherInputObject
			'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'input ExampleInputObject {
 			 	a: String
  				b: Int!
				c: OtherInputObject!!
			}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure
]

{ #category : #'test-schemaInterfaceType' }
GQLSchemaGrammarEvaluatorTest >> testIncompleteSchemaInterfaceType [
	| text |
	text := 'interface NamedEntity {
				  name: String
			  '.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'interface NamedEntity {
				  name: 
			  }'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'interface NamedEntity {
				  name: String : Int
			  }'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure
]

{ #category : #'tests-schemaObjectTypes' }
GQLSchemaGrammarEvaluatorTest >> testIncompleteSchemaObjectType [
	| text |
	text := 'type Query{
              name : 
            }'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'type Query{
              name : String
            }
				{}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'type Query{
              name : String
            }
				type Class{
 				  name :
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure
]

{ #category : #'tests-schemaObjectTypes' }
GQLSchemaGrammarEvaluatorTest >> testIncompleteSchemaObjectTypeParameters [
	| text |
	text := 'type Query{
              name (id: Int : String
            }'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'type Query{
              name (id: Int, ) : String
            }
				{}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'type Query{
              name (id:Int) : String
            }
				type Class{
 				  name :
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure
]

{ #category : #'test-schemaUnionType' }
GQLSchemaGrammarEvaluatorTest >> testIncompleteSchemaUnionType [
	| text |
	text := 'union CatOrDog = Cat |'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'union CatOrDog  Cat | Dog'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'union CatOrDog = Cat | |'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure
]

{ #category : #'test-schemaDefinition' }
GQLSchemaGrammarEvaluatorTest >> testSchemaDefinition [
	| text query mutation rootOperationTypes |
	text := 'schema{
					query: Query
				}
				type Query{
					hello: String
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	self assert: schema schemaDefinitions first class equals: GQLSSchemaDefinitionNode.
	rootOperationTypes := schema schemaDefinitions first rootOperationTypes.
	self assert: (rootOperationTypes at: 'query') first  class equals: GQLSRootOperationTypeNode.
	self assert: (rootOperationTypes at: 'query') first name equals: 'Query'.
	query := schema getType: 'Query'.
	self assert: (query fields at: 'hello') class equals: GQLSFieldNode.
	
	text := '
		schema{
			query: Query
			mutation: Mutation	
		}
		type Query { 
			hello: String
		}
		type Mutation{
			setNumber(to: Int): Int
		}
		'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	self assert: schema schemaDefinitions first class equals: GQLSSchemaDefinitionNode.
	rootOperationTypes := schema schemaDefinitions first rootOperationTypes.
	self assert: (rootOperationTypes at: 'query') first class equals: GQLSRootOperationTypeNode.
	self assert: (rootOperationTypes at: 'query') first name equals: 'Query'.
	self assert: (rootOperationTypes at: 'mutation') first class equals: GQLSRootOperationTypeNode.
	self assert: (rootOperationTypes at: 'mutation')first  name equals: 'Mutation'.
	query := schema getType: 'Query'.
	self assert: (query fields at: 'hello') type class equals: GQLSStringTypeNode.
	mutation := schema getType: 'Mutation'.
	self assert: (mutation fields at: 'setNumber') type class equals: GQLSIntTypeNode.
	
	text := '
		schema{
			query: GQLTestQueryType
			mutation: GQLTestMutationType
		}
		type GQLTestQueryType { 
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
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	self assert: schema schemaDefinitions first class equals: GQLSSchemaDefinitionNode.
	rootOperationTypes := schema schemaDefinitions first rootOperationTypes.
	self assert: (rootOperationTypes at: 'query') first class equals: GQLSRootOperationTypeNode.
	self assert: (rootOperationTypes at: 'query') first name equals: 'GQLTestQueryType'.
	self assert: (rootOperationTypes at: 'mutation') first class equals: GQLSRootOperationTypeNode.
	self assert: (rootOperationTypes at: 'mutation') first name equals: 'GQLTestMutationType'.
	query := schema getType: 'GQLTestQueryType'.
	self assert: (query fields at: 'hello') type class equals: GQLSStringTypeNode.
	mutation := schema getType: 'GQLTestMutationType'.
	self assert: (mutation fields at: 'createPoint') type name equals: 'Point'.

	"es valido porque Query esta definido y eso es por defecto"
		text := '
		type Query { 
			hello: String
		}
		type GQLTestQueryType {
			helloTo(name: String): String
		}
		'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	self assert: schema schemaDefinitions first class equals: GQLSSchemaDefinitionNode.
	rootOperationTypes := schema schemaDefinitions first rootOperationTypes.
	self assert: (rootOperationTypes at: 'query') size equals: 1.
	self assert: (rootOperationTypes at: 'query') first class: GQLSRootOperationTypeNode.
	
	"It is valid because Mutation is declared as query"
	text := '
		schema { 
			query: Mutation
		}
		type Mutation { 
			setNumber(to: Int): Int
		}
		'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	self assert: schema schemaDefinitions first class equals: GQLSSchemaDefinitionNode.
	rootOperationTypes := schema schemaDefinitions first rootOperationTypes.
	self assert: (rootOperationTypes at: 'query') first class equals: GQLSRootOperationTypeNode.
	self assert: (rootOperationTypes at: 'query') first name equals: 'Mutation'.
	
	
]

{ #category : #'test-schemaDefinition' }
GQLSchemaGrammarEvaluatorTest >> testSchemaDefinitionWithDefaultRootOperTypes [
	| text rootOperationTypes |
	text := '
		type Query{
			hello: String
		}
		type GQLTestQueryType{
			helloTo(name:String): String
		}
		type Mutation{
			setNumber(to:Int): Int
		}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	self assert: schema schemaDefinitions first class equals: GQLSSchemaDefinitionNode. 
	rootOperationTypes := schema schemaDefinitions first rootOperationTypes.
	self assert: (rootOperationTypes at: 'query') first name equals: 'GQLQuery'.
	self assert: rootOperationTypes keys size equals: 1.
	
	text := '
		type GQLQuery { 
			hello: String
		}
		type GQLMutation{
			setNumber(to: Int): Int
		}
		'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	self assert: schema schemaDefinitions first class equals: GQLSSchemaDefinitionNode.
	rootOperationTypes := schema schemaDefinitions first rootOperationTypes.
	self assert: (rootOperationTypes at: 'query') first name equals: 'GQLQuery'.
	self assert: rootOperationTypes keys size equals: 1.
]

{ #category : #'test-schemaEnumType' }
GQLSchemaGrammarEvaluatorTest >> testSchemaEnumType [
	| text dog cat stringValues |
	text := 'enum DogCommand { SIT, DOWN, HEEL }
			  enum CatCommand { JUMP }'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	dog := schema getType: 'DogCommand'.
	cat := schema getType: 'CatCommand'.
	self assert: dog class equals: GQLSEnumTypeNode.
	self assert: cat class equals: GQLSEnumTypeNode.
	self assert: dog values size equals: 3.
	self assert: cat values size equals: 1.
	stringValues := dog stringValues.
	self assert: stringValues first equals: 'SIT'.
	self assert: stringValues second equals: 'DOWN'.
	self assert: stringValues third equals: 'HEEL'.
	stringValues := cat stringValues.
	self assert: stringValues first equals: 'JUMP'.
]

{ #category : #'test-schemaTypeSystemExtension' }
GQLSchemaGrammarEvaluatorTest >> testSchemaEnumTypeExtension [
	| text enumType stringValues |
	text := 'extend enum DogCommand {YAP}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	enumType := schema getTypeExtension: 'DogCommand'.
	self assert: enumType class equals: GQLSEnumTypeNode.
	self assert: enumType values size equals: 1.
	stringValues := enumType stringValues.
	self assert: stringValues first equals: 'YAP'.

	text := 'extend enum CatCommand { JUMP MEOW}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	enumType := schema getTypeExtension: 'CatCommand'.
	self assert: enumType class equals: GQLSEnumTypeNode.
	self assert: enumType values size equals: 2.
	stringValues := enumType stringValues.
	self assert: stringValues first equals: 'JUMP'.
	self assert: stringValues second equals: 'MEOW'.
]

{ #category : #'test-schemaTypeSystemExtension' }
GQLSchemaGrammarEvaluatorTest >> testSchemaEnumTypeExtensionIncorrect [
	| text |
	text := 'extend enum {YAP}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.

	text := 'extend enum CatCommand { }'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure
]

{ #category : #'test-schemaWithComment' }
GQLSchemaGrammarEvaluatorTest >> testSchemaEnumTypeWithComment [
	| text node enumValues |
	text := 'enum #Dog command 
				DogCommand #the values are:
				{ 
				#sit
				SIT, 
				#down
				DOWN, 
				#heel
				HEEL }
			  	enum CatCommand { 
				#jump
				JUMP }'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	node := schema schemaTypes at: 'DogCommand'.
	enumValues := node values.
	self assertCommentsFields: enumValues equals: #('#sit' '#down' '#heel').
	enumValues := (schema schemaTypes at: 'CatCommand') values.
	self assertCommentsFields: enumValues equals: #('#jump').
	
]

{ #category : #tests }
GQLSchemaGrammarEvaluatorTest >> testSchemaExtension [
	| text mutation schemaExtension rootOperationTypes |
	text := 'schema { 
					query: Query
				}
				extend schema{
					mutation: Mutation
				}
				type Query{
					hello: String
				}
				type Mutation{
					incrementNumber: Int
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	schemaExtension := schema schemaExtensions first.
	rootOperationTypes := schemaExtension rootOperationTypes.
	self assert: (rootOperationTypes at: 'mutation') first class equals: GQLSRootOperationTypeNode.
	self assert: (rootOperationTypes at: 'mutation') first name equals: 'Mutation'.
	mutation := schema getType: 'Mutation'.
	self assert: (mutation fields at: 'incrementNumber') class equals: GQLSFieldNode.
	
	text := 'extend schema{
					mutation: Mutation
				}
				type Mutation{
					incrementNumber: Int
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	schemaExtension := schema schemaExtensions first.
	rootOperationTypes := schemaExtension rootOperationTypes.
	self assert: (rootOperationTypes at: 'mutation') first class equals: GQLSRootOperationTypeNode.
	self assert: (rootOperationTypes at: 'mutation') first name equals: 'Mutation'.
	mutation := schema getType: 'Mutation'.
	self assert: (mutation fields at: 'incrementNumber') class equals: GQLSFieldNode.
	
	text := '
		extend schema{
			mutation: GQLTestMutationType
		}
		type GQLTestMutationType {
			createPoint(x: Int, y: Int): Point
		}
		type Point { 
			x: Int
			y: Int
		}
		'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	schemaExtension := schema schemaExtensions first.
	rootOperationTypes := schemaExtension rootOperationTypes.
	self assert: (rootOperationTypes at: 'mutation') first class equals: GQLSRootOperationTypeNode.
	self assert: (rootOperationTypes at: 'mutation') first name equals: 'GQLTestMutationType'.
	mutation := schema getType: 'GQLTestMutationType'.
	self assert: (mutation fields at: 'createPoint') type name equals: 'Point'.
	
	
]

{ #category : #'test-schemaTypeSystemExtension' }
GQLSchemaGrammarEvaluatorTest >> testSchemaExtensionIncorrect [
	| text |
	text := 'extend {
					mutation: Mutation
				}
				type Mutation{
					incrementNumber: Int
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	
	text := '
		extend schema{
		}
		'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure .
	
	
]

{ #category : #'test-schemaInputObjectType' }
GQLSchemaGrammarEvaluatorTest >> testSchemaInputObjectType [
	| text inputObject |
	text := 'input ExampleInputObject {
 			 	a: String
  				b: Int!
				c: OtherInputObject
			}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	inputObject := schema getType: 'ExampleInputObject'.
	self assert: inputObject class equals: GQLSInputObjectTypeNode.
	self assert: inputObject name equals: 'ExampleInputObject'.
	self assert: (inputObject getField: 'a') class equals: GQLSInputObjectFieldNode.
	self assert: (inputObject getField: 'a') type class equals: GQLSStringTypeNode.
	self assert: (inputObject getField: 'b') type wrappedType class equals: GQLSIntTypeNode.
	self assert: (inputObject getField: 'c') type class equals: GQLSNamedTypeNode.
]

{ #category : #'test-schemaTypeSystemExtension' }
GQLSchemaGrammarEvaluatorTest >> testSchemaInputObjectTypeExtension [
	| text inputObject |
	text := 'extend input ExampleInputObject {
 			 	d: String
				e: OtherInputObject
			}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	inputObject := schema getTypeExtension: 'ExampleInputObject'.
	self assert: inputObject class equals: GQLSInputObjectTypeNode.
	self assert: inputObject name equals: 'ExampleInputObject'.
	self assert: (inputObject getField: 'd') class equals: GQLSInputObjectFieldNode.
	self assert: (inputObject getField: 'd') type class equals: GQLSStringTypeNode.
	self assert: (inputObject getField: 'e') type class equals: GQLSNamedTypeNode.
]

{ #category : #'test-schemaTypeSystemExtension' }
GQLSchemaGrammarEvaluatorTest >> testSchemaInputObjectTypeExtensionIncorrect [
	| text |
	text := 'extend input {
 			 	d: String
				e: OtherInputObject
			}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	
	text := 'extend input SomeObjectInput{
			}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
]

{ #category : #'test-schemaWithComment' }
GQLSchemaGrammarEvaluatorTest >> testSchemaInputObjectTypeWithComment [
	| text inputObject |
	text := 'input #comment of inputObject 
				ExampleInputObject {
				#field a
 			 	a: String
				#field b
  				b: Int!
				#field c
				c: OtherInputObject
			}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	inputObject := schema getType: 'ExampleInputObject'.
	self assert: inputObject comments isEmpty.
	self assertCommentsFields: inputObject fields equals: #('#field a' '#field b'  '#field c')
]

{ #category : #'test-schemaInterfaceType' }
GQLSchemaGrammarEvaluatorTest >> testSchemaInterfaceType [
	| text interface |
	text := 'interface NamedEntity {
				  field(id: Int) : [Int]
				  otherVariable(param: String, param2: [Int]!) : String 
				  a (param: [Int]!) : A
			  }'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	interface := schema getType: 'NamedEntity'.
	self assert: interface class equals: GQLSInterfaceTypeNode.
	self assert: interface name equals: 'NamedEntity'.
	self assert: (interface getField: 'field') class equals: GQLSFieldNode.
	self assert: (interface getField: 'field') type class equals: GQLSListTypeNode.
	self assert: (interface getField: 'field') type wrappedType class equals: GQLSIntTypeNode.
	self assert: (interface getField: 'otherVariable') type class equals: GQLSStringTypeNode.
	self assert: ((interface getField: 'otherVariable') getArgument: 'param2') type class equals: GQLSNonNullTypeNode.
	self assert: (interface getField: 'a') type class equals: GQLSNamedTypeNode.
]

{ #category : #'test-schemaTypeSystemExtension' }
GQLSchemaGrammarEvaluatorTest >> testSchemaInterfaceTypeExtension [
	| text interface field |
	text := 'extend interface Some {
					someOtherField: String
				}
				extend interface SomeOtherInterface { 
					someNumber: Int
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	interface := schema getTypeExtension: 'Some'.
	self assert: interface class equals: GQLSInterfaceTypeNode.
	field := interface getField: 'someOtherField'.
	self assert: field class equals: GQLSFieldNode.
	self assert: field type class equals: GQLSStringTypeNode.
	interface := schema getTypeExtension: 'SomeOtherInterface'.
	self assert: interface class equals: GQLSInterfaceTypeNode.
	field := interface getField: 'someNumber'.
	self assert: field class equals: GQLSFieldNode.
	self assert: field type class equals: GQLSIntTypeNode.
]

{ #category : #'test-schemaTypeSystemExtension' }
GQLSchemaGrammarEvaluatorTest >> testSchemaInterfaceTypeExtensionIncorrect [
	| text |
	text := 'extend interface {
					someOtherField: String
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	
	text := 'extend SomeOtherInterface { 
					someNumber: Int
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
]

{ #category : #'test-schemaWithComment' }
GQLSchemaGrammarEvaluatorTest >> testSchemaInterfaceWithComment [
	| text node |
	text := 'interface #namedEntity 
				NamedEntity {
				  #field receives an Int and returns [ Int ]
				  field(id: Int) : [Int]
				  #otherVariable returns an String
				  otherVariable(param: String, param2: [Int]!) : String 
				  #a returns an instance of A
				  a (param: [Int]!) : A
			  }'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	node := schema schemaTypes at: 'NamedEntity'.
	self assert: node comments isEmpty.
	self assertCommentsFields: node fields equals: #('#field receives an Int and returns [ Int ]' '#otherVariable returns an String' '#a returns an instance of A' )
]

{ #category : #'tests-schemaObjectTypes' }
GQLSchemaGrammarEvaluatorTest >> testSchemaObjectType [
	| text someType someOtherType var |
	text := 'type SomeType {
					someName : [Int]
					otherVariable 	:String
				},
				type SomeOtherTypeName {
					someName 	: [String ! ]
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	someType := schema schemaTypes at: 'SomeType'.
	someOtherType := schema schemaTypes at: 'SomeOtherTypeName'.
	self assert: someType class equals: GQLSObjectTypeNode.
	self assert: someType name equals: 'SomeType'.
	var := someType fields at: 'someName'.
	self assert: var class equals: GQLSFieldNode.
	self assert: var name equals: 'someName'.
	self assert: var type class equals: GQLSListTypeNode.
	
	self assert: someOtherType fields values first type class equals: GQLSListTypeNode.
	self assert: var type wrappedType name equals: 'Int'.
	var := someType fields at: 'otherVariable'.
	self assert: var name equals: 'otherVariable'.
	self assert: var type name equals: 'String'
]

{ #category : #'tests-schemaObjectTypes' }
GQLSchemaGrammarEvaluatorTest >> testSchemaObjectTypeAndEnumType [
	| text someType enumType var stringValues |
	text := 'type SomeType {
					someName(arg: EnumArg): String
					otherVariable 	:String
				},
				enum EnumArg{
				   ARG_1
				   ARG_2
					ARG_3
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	someType := schema schemaTypes at: 'SomeType'.
	self assert: someType class equals: GQLSObjectTypeNode.
	self assert: someType name equals: 'SomeType'.
	var := someType fields at: 'someName'.
	self assert: var class equals: GQLSFieldNode.
	self assert: var name equals: 'someName'.
	self assert: var arguments size equals: 1.
	self assert: (var arguments at: 'arg') type class equals: GQLSNamedTypeNode.
	
	enumType := schema schemaTypes at: 'EnumArg'.
	self assert: enumType class equals: GQLSEnumTypeNode.
	self assert: enumType values size equals: 3.
	stringValues := enumType stringValues.
	self assert: (stringValues at: 1) equals: 'ARG_1'.
	self assert: (stringValues at: 2) equals: 'ARG_2'.
	self assert: (stringValues at: 3) equals: 'ARG_3'.
]

{ #category : #'test-schemaTypeSystemExtension' }
GQLSchemaGrammarEvaluatorTest >> testSchemaObjectTypeExtension [
	| text objectType field |
	text := 'extend type SomeType {
					someOtherField: String
				}
				extend type SomeOtherType { 
					someNumber: Int
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	objectType := schema getTypeExtension: 'SomeType'.
	self assert: objectType class equals: GQLSObjectTypeNode.
	field := objectType fields at: 'someOtherField'.
	self assert: field class equals: GQLSFieldNode.
	self assert: field type class equals: GQLSStringTypeNode.
	
	objectType := schema getTypeExtension: 'SomeOtherType'.
	self assert: objectType fields values first type class equals: GQLSIntTypeNode.
	field := objectType fields at: 'someNumber'.
	self assert: field type name equals: 'Int'.
]

{ #category : #'test-schemaTypeSystemExtension' }
GQLSchemaGrammarEvaluatorTest >> testSchemaObjectTypeExtensionIncorrect [
	| text |
	text := 'extend type {
					someOtherField: String
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	
	text := 'extend SomeOtherType { 
					someNumber: Int
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
]

{ #category : #'tests-schemaObjectTypes' }
GQLSchemaGrammarEvaluatorTest >> testSchemaObjectTypeParameters [
	| text someType var |
	text := 'type SomeType {
					field(id: Int) : [Int]
					otherVariable(param: String, param2: [Int]!):String 
					a (param: [Int]!):Int
				},
				type SomeOtherTypeName {
					someName (a:String!): [String ! ]
					someName2 :String 
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	someType := schema schemaTypes at: 'SomeType'.
	self assert: someType class equals: GQLSObjectTypeNode.
	self assert: someType name equals: 'SomeType'.
	self assert: someType fields values third name equals: 'a'.
	var := someType fields at: 'a'.
	self
		assert: var arguments values first class
		equals: GQLSInputObjectFieldNode.
	self
		assert: var arguments values first class
		equals: GQLSInputObjectFieldNode.
	self
		assert: var arguments values first type class
		equals: GQLSNonNullTypeNode.
	self
		assert: var arguments values first type wrappedType class
		equals: GQLSListTypeNode
]

{ #category : #'tests-schemaObjectTypes' }
GQLSchemaGrammarEvaluatorTest >> testSchemaObjectTypeWithInterface [
	| text someType someOtherType |
	text := 'type SomeType implements Type{
					someName : [Int]
				},
				type SomeOtherTypeName implements Type & Other {
					someName 	: String !
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	someType := schema schemaTypes at: 'SomeType'.
	someOtherType := schema schemaTypes at: 'SomeOtherTypeName'.
	self assert: someType class equals: GQLSObjectTypeNode.
	self assert: someType name equals: 'SomeType'.
	self assert: someType interfaces size equals: 1.
	self assert: someType interfaces first equals: 'Type'.
	self assert: someOtherType class equals: GQLSObjectTypeNode.
	self assert: someOtherType name equals: 'SomeOtherTypeName'.
	self assert: someOtherType interfaces size equals: 2.
	self assert: someOtherType interfaces first equals: 'Type'.
	self assert: someOtherType interfaces second equals: 'Other'.
]

{ #category : #'test-schemaUnionType' }
GQLSchemaGrammarEvaluatorTest >> testSchemaUnionType [
	| text dog cat |
	text := 'union CatOrDog = Cat | Dog
				union DogOrHuman = Dog | Human | Alien'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	cat := schema getType: 'CatOrDog'.
	dog := schema getType: 'DogOrHuman'.
	self assert: dog class equals: GQLSUnionTypeNode.
	self assert: cat class equals: GQLSUnionTypeNode.
	self assert: dog namedTypes size equals: 3.
	self assert: cat namedTypes size equals: 2.
	self assert: dog namedTypes first equals: 'Dog'.
	self assert: dog namedTypes second equals: 'Human'.
	self assert: dog namedTypes third equals: 'Alien'.
	self assert: cat namedTypes first equals: 'Cat'.
	self assert: cat namedTypes second equals: 'Dog'.
]

{ #category : #'test-schemaTypeSystemExtension' }
GQLSchemaGrammarEvaluatorTest >> testSchemaUnionTypeExtension [
	| text unionType |
	text := 'extend union Animals = Monkey | Elephant | Wolf
				extend union Shapes = Trapezoid | Triangle'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	unionType := schema getTypeExtension: 'Animals'.
	self assert: unionType class equals: GQLSUnionTypeNode.
	self assert: unionType namedTypes size equals: 3.
	self assert: unionType namedTypes first equals: 'Monkey'.
	self assert: unionType namedTypes second equals: 'Elephant'.
	self assert: unionType namedTypes third equals: 'Wolf'.
	unionType := schema getTypeExtension: 'Shapes'.
	self assert: unionType class equals: GQLSUnionTypeNode.
	self assert: unionType namedTypes size equals: 2.
	self assert: unionType namedTypes first equals: 'Trapezoid'.
	self assert: unionType namedTypes second equals: 'Triangle'.
]

{ #category : #'test-schemaTypeSystemExtension' }
GQLSchemaGrammarEvaluatorTest >> testSchemaUnionTypeExtensionIncorrect [
	| text |
	text := 'extend Animals = Monkey | Elephant | Wolf '.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	
	text := 'extend union = Trapezoid | Triangle'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	
	
]

{ #category : #'test-schemaWithComment' }
GQLSchemaGrammarEvaluatorTest >> testSchemaUnionTypeWithComment [
	| text node |
	text := '#comment 1
				union #catOrDog
				CatOrDog = 
				#cat
				Cat | 
				#dog
				Dog
				#comment 2
				union DogOrHuman = 
				#dog
				Dog | 
				#human
				Human | 
				#alien
				Alien
				#comment 3'
				.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	node := schema getType: 'CatOrDog'.
	self assertComments:  node comments equals: #( '#comment 1' '#comment 2' ).
	node := schema getType: 'DogOrHuman'.
	self assertComments: node comments equals: #( '#comment 3' ).
]

{ #category : #'test-schemaWithComment' }
GQLSchemaGrammarEvaluatorTest >> testSchemaWithComment [
	| text node |
	text := '#type Query by default
				type Query{
					hello: String
				}
				'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	node := schema getType: 'Query'.
	self assertComments: node comments equals: #('#type Query by default').
	
	text := '#type Query by default
				type #allowed comment
				Query #comment before the field
				{
					#comment in the field
					hello: #field hello returns an String
					String
				}
				'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	self assert: schema comments isEmpty.
	node := schema getType: 'Query'.
	self assertComments: node comments equals: #('#type Query by default').
	node := node getField: 'hello'.
	self assertComments: node comments equals: #('#comment in the field').
	
	text := 'type SomeType #comment before the interface
		 		implements Type{
					someName : [Int]
				}'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: GQLSSchemaNode.
	node := schema getType: 'SomeType'.
	self assert: node comments isEmpty.
]

{ #category : #'test-schemaDefinition' }
GQLSchemaGrammarEvaluatorTest >> testWithDoubleRootOperTypeSchemaDefinition [
	| text |
	"Error: Must provide only one query type in schema."
	text := 'schema{
					query: Query
					query: Query2
				}
				type Query{
					hello
				}
				type GQLTestQueryType {
					helloTo(name:String): String
				}
				'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
	text := 'schema{
						query: Query
						mutation: Mutation
						mutation: GQLTestMutationType
					}
					type Query{
						hello
					}
					mutation Mutation{
						setNumer(to:Int): Int
					}
					mutation GQLTestMutationType {
						createPoint(x: Int, y: Int): Point
					}
					type Point { 
						x: Int
						y: Int
					}
					'.
	schema := GQLSchemaGrammarEvaluator parse: text.
	self assert: schema class equals: PPFailure.
]
