"
A GQLSchemaGrammarTest is a test class for testing the behavior of GQLSchemaGrammar
"
Class {
	#name : #GQLSchemaGrammarTest,
	#superclass : #PPCompositeParserTest,
	#category : #'GraphQLBeta-Tests-Grammar'
}

{ #category : #'tests-grammar' }
GQLSchemaGrammarTest >> parserClass [
	^ GQLSchemaGrammar
]

{ #category : #'test-grammar-comment' }
GQLSchemaGrammarTest >> testComment [
	self parse: '#comment of a line' rule: #comment.
	self parse: '#comments dont allow lineTerminator' rule: #comment.
]

{ #category : #'test-grammar-comment' }
GQLSchemaGrammarTest >> testCommentIncorrect [
	self fail: '#comment of a 
	line' rule: #comment.
	self fail: 'comments dont allow lineTerminator' rule: #comment.
]

{ #category : #'test-grammar-description' }
GQLSchemaGrammarTest >> testDescription [
	self parse: '"description of schema"' rule: #description.
	self parse: '"descriptions often occur before the definition"' rule: #description.
	self parse: '"""BlockString contains more than an line 
					generally"""' rule: #description.
]

{ #category : #'test-grammar-description' }
GQLSchemaGrammarTest >> testDescriptionInvalid [
	self fail: '"description of schema" "an second description invalid"' rule: #description.
	self fail: '"""BlockString contains more than an line ', Character cr asString, 
					'generally""" """"an second block String invalid"""' rule: #description.
	self fail: '"descriptions often occur before the definition" """ block String invalid"""' rule: #description.
	self fail: '"""block string description""" "an second description String invalid"' rule: #description.
]

{ #category : #'test-grammar-enumType' }
GQLSchemaGrammarTest >> testEnumType [
	self parse: 'enum DogCommand { SIT, DOWN, HEEL }' rule: #enumType.
	self parse: 'enum CatCommand { JUMP }' rule: #enumType.
]

{ #category : #'test-grammar-typeSystemExtension' }
GQLSchemaGrammarTest >> testEnumTypeExtension [
	self parse: 'extend enum DogCommand { SIT, DOWN, HEEL }' rule: #typeSystemExtension.
	self parse: 'extend enum CatCommand { JUMP }' rule: #typeSystemExtension.
											
]

{ #category : #'test-grammar-typeSystemExtension' }
GQLSchemaGrammarTest >> testEnumTypeExtensionIncorrect [
	self fail: 'extend DogCommand { SIT, DOWN, HEEL }' rule: #typeSystemExtension.
	self fail: 'extend enum { JUMP }' rule: #typeSystemExtension.
	self fail: 'extend enum DogCommand' rule: #typeSystemExtension.
	self fail: 'extend enum CatCommand { }' rule: #typeSystemExtension.
	self fail: 'extend "desription of enum" enum CatCommand { MEOW }' rule: #typeSystemExtension.
											
]

{ #category : #'test-grammar-enumType' }
GQLSchemaGrammarTest >> testFailEnumTypeIncomplete [
	self fail: 'enum { ROSE, LAVANDA}' rule: #enumType.
	self fail: 'enum ROSE, LAVANDA' rule: #enumType.
	self fail: 'enum { }' rule: #enumType.
	self fail: 'enum FLOWER' rule: #enumType.
	self fail: 'enum true { ROSE, LAVANDA}' rule: #enumType.
	self fail: 'enum false { ROSE, LAVANDA}' rule: #enumType.
	self fail: 'enum null { ROSE, LAVANDA}' rule: #enumType.
	self fail: 'FLOWER' rule: #enumType.
	self fail: 'FLOWER { ROSE, LAVANDA}' rule: #enumType.
]

{ #category : #'test-grammar-enumType' }
GQLSchemaGrammarTest >> testFailEnumTypeOther [
	self fail: '{someName 	: 	ID !}' rule: #enumType.
	self fail: 'type {someName 	: 	ID !}' rule: #enumType.
	self fail: 'type {}' rule: #enumType.
	self fail: 'type Some {}' rule: #enumType.
	self fail: 'type implements' rule: #enumType.
	self fail: 'type Some implements {}' rule: #enumType.
	self fail: 'type Some implements {someName : ID}' rule: #enumType.
	self fail: 'type Some Other { someName: ID}' rule: #enumType.
	self fail: 'interface Sentiet { name : String}' rule: #enumType.
	self fail: 'interface { name : String}' rule: #enumType.
	self fail: 'union CatOrDog = Cat | Dog' rule: #enumType
]

{ #category : #'test-grammar-inputObjectType' }
GQLSchemaGrammarTest >> testFailInputObjectTypeIncomplete [
	self fail: '{someName 	: 	ID !}' rule: #inputObjectType.
	self fail: 'input {someName 	: 	ID !}' rule: #inputObjectType.
	self fail: 'input {}' rule: #inputObjectType.
	self fail: 'input Some {}' rule: #inputObjectType.
	self fail: 'input Some {}' rule: #inputObjectType.
	self fail: 'input Some {some : }' rule: #inputObjectType.
	self fail: 'input Some Other { someName: ID}' rule: #inputObjectType.
	self fail: 'input Some { someName(a : ) : ID}' rule: #inputObjectType.
	self fail: 'input Some { someName(a : String, b ) : ID}' rule: #inputObjectType.
]

{ #category : #'test-grammar-inputObjectType' }
GQLSchemaGrammarTest >> testFailInputObjectTypeOther [
	self fail: 'enum Flower { ROSE, LAVANDA}' rule: #inputObjectType.
	self fail: 'interface Sentiet { name : String}' rule: #inputObjectType.
	self fail: 'union CatOrDog = Cat | Dog' rule: #inputObjectType.
	self fail: 'type SomeType {someName : [Int]}' rule: #inputObjectType.
	self fail: 'type SomeType implements Some {someName : [Int]}' rule: #inputObjectType.
]

{ #category : #'test-grammar-interfaceType' }
GQLSchemaGrammarTest >> testFailInterfaceTypeOther [
	self fail: '{someName 	: 	ID !}' rule: #interfaceType.
	self fail: 'type {someName 	: 	ID !}' rule: #interfaceType.
	self fail: 'type {}' rule: #interfaceType.
	self fail: 'type Some {}' rule: #interfaceType.
	self fail: 'type implements' rule: #interfaceType.
	self fail: 'type Some implements {}' rule: #interfaceType.
	self fail: 'type Some implements {someName : ID}' rule: #interfaceType.
	self fail: 'type Some Other { someName: ID}' rule: #interfaceType.
	self fail: 'union CatOrDog = Cat | Dog' rule: #interfaceType.
	self fail: 'enum Some { someName: ID}' rule: #interfaceType.
]

{ #category : #'test-grammar-objectType' }
GQLSchemaGrammarTest >> testFailObjectTypeIncomplete [
	self fail: '{someName 	: 	ID !}' rule: #objectType.
	self fail: 'type {someName 	: 	ID !}' rule: #objectType.
	self fail: 'type {}' rule: #objectType.
	self fail: 'type Some {}' rule: #objectType.
	self fail: 'type implements' rule: #objectType.
	self fail: 'type Some implements {}' rule: #objectType.
	self fail: 'type Some implements {someName : ID}' rule: #objectType.
	self fail: 'type Some Other { someName: ID}' rule: #objectType.
]

{ #category : #'test-grammar-objectType' }
GQLSchemaGrammarTest >> testFailObjectTypeOther [
	self fail: 'enum Flower { ROSE, LAVANDA}' rule: #objectType.
	self fail: 'interface Sentiet { name : String}' rule: #objectType.
	self fail: 'union CatOrDog = Cat | Dog' rule: #objectType
]

{ #category : #'test-grammar-unionType' }
GQLSchemaGrammarTest >> testFailUnionTypeOther [
	self fail: '{someName 	: 	ID !}' rule: #unionType.
	self fail: 'type {someName 	: 	ID !}' rule: #unionType.
	self fail: 'type {}' rule: #unionType.
	self fail: 'type Some {}' rule: #unionType.
	self fail: 'type implements' rule: #unionType.
	self fail: 'type Some implements {}' rule: #unionType.
	self fail: 'type Some implements {someName : ID}' rule: #unionType.
	self fail: 'type Some Other { someName: ID}' rule: #unionType.
	self fail: 'interface Sentiet { name : String}' rule: #unionType.
	self fail: 'enum FLOWER { ROSE, LAVANDA }' rule: #unionType.
]

{ #category : #'test-grammar-field' }
GQLSchemaGrammarTest >> testField [
	self parse: 'someName1 	: Int' rule: #field.
	self parse: 'someName2 	: [String ! ]!' rule: #field.
	self parse: 'someName3 	: 	ID !' rule: #field.
	self parse: 'someName4 	: 	SomeOtherType !' rule: #field.
	self parse: 'withParam1 ( aParam: String): 	SomeOtherType !' rule: #field.
	self parse: 'withParam2( aParam: String, bParam:Int): 	SomeOtherType !' rule: #field.
	self
		parse: 'withParam3( aParam: String, someOtherParam:Int): 	SomeOtherType !'
		rule: #field.
	self parse: '__some: Int' rule: #field.
]

{ #category : #'test-grammar-field' }
GQLSchemaGrammarTest >> testFieldIncorrect [
	self fail: '123:Int !' rule: #field.
	self fail: 'someName : [ String' rule: #field.
	self fail: 'some : !' rule: #field.
	self fail: 'some() : Int' rule: #field.
	self fail: 'some : 123' rule: #field.
	self fail: 'some : [String !' rule: #field
]

{ #category : #'test-grammar-fieldSet' }
GQLSchemaGrammarTest >> testFieldSet [
	self parse: '{someName : [Int]}' rule: #fieldSet.
	self parse: '{someName 	: [String ! ], someName 	:String }' rule: #fieldSet.
	self parse: '{someName 	: [String ! ] someName 	:String }' rule: #fieldSet.
	self parse: '{someName 	: String !, someName 	:String }' rule: #fieldSet.
	self parse: '{someName 	: String ! someName 	:String }' rule: #fieldSet.
	self parse: '{someName 	: [String !] ! someName 	:String }' rule: #fieldSet.
	self parse: '{ __someName: String }' rule: #fieldSet.
]

{ #category : #'test-grammar-fieldSet' }
GQLSchemaGrammarTest >> testFieldSetIncorrect [
	self fail: 'someName 	: 	ID !' rule: #fieldSet.
	self fail: '{}' rule: #fieldSet.
	self fail: '{ someName }' rule: #fieldSet.
	self fail: '{ someName : }' rule: #fieldSet.
	self fail: '{ someName : !}' rule: #fieldSet.
	self fail: '{ someName ID}' rule: #fieldSet.
	self fail: '{ someName ID!}' rule: #fieldSet.
	self fail: '{ someName !}' rule: #fieldSet.
]

{ #category : #'test-grammar-inputObjectType' }
GQLSchemaGrammarTest >> testInputObjectType [
	self parse: 'input SomeType {someName : [Int]}' rule: #inputObjectType.
	self
		parse: 'input SomeOtherTypeName {someName 	: [String ! ], someName 	:String }'
		rule: #inputObjectType.
	self parse: 'input Some {someObject : Some }' rule: #inputObjectType.
	self parse: 'input Some {someObject : Some ! }' rule: #inputObjectType.
	self parse: 'input Some {someObject : [ Some ] ! }' rule: #inputObjectType.
	self parse: 'input Some {someObject : [ Some ! ] }' rule: #inputObjectType.
	self parse: 'input Some {someObject : [ Some ! ] ! }' rule: #inputObjectType.
	self parse: 'input Some { some : Int }' rule: #inputObjectType.
	self parse: 'input Some { some(p : String) : Int }' rule: #inputObjectType.
	self parse: 'input Some { some(p : Some) : Int }' rule: #inputObjectType.
	self parse: 'input Some { some(p : String, a : Some) : Int }' rule: #inputObjectType.
	self parse: 'input Some { __someName: String}' rule: #inputObjectType.
	self parse: 'input Some { some: Int, __name: String }' rule: #inputObjectType.
]

{ #category : #'test-grammar-typeSystemExtension' }
GQLSchemaGrammarTest >> testInputObjectTypeExtension [
	self parse: 'extend input SomeType {someName : [Int]}' rule: #typeSystemExtension.
	self
		parse: 'extend input SomeOtherTypeName {someName 	: [String ! ], someName 	:String }'
		rule: #typeSystemExtension.
	self parse: 'extend input Some {someObject : Some }' rule: #typeSystemExtension.
	self parse: 'extend input Some {someObject : Some ! }' rule: #typeSystemExtension.
	self parse: 'extend input Some {someObject : [ Some ! ] ! }' rule: #typeSystemExtension.
	self parse: 'extend input Some { some : Int }' rule: #typeSystemExtension.
	self parse: 'extend input Some { some(p : String) : Int }' rule: #typeSystemExtension.
	self parse: 'extend input Some { some(p : String, a : Some) : Int }' rule: #typeSystemExtension.
											
]

{ #category : #'test-grammar-typeSystemExtension' }
GQLSchemaGrammarTest >> testInputObjectTypeExtensionIncorrect [
	self fail: 'input SomeType {someName : [Int]}' rule: #typeSystemExtension.
	self fail: 'extend SomeType {someName : [Int]}' rule: #typeSystemExtension.
	self fail: 'extend input  {someName : [Int]}' rule: #typeSystemExtension.
	self fail: 'extend input SomeType' rule: #typeSystemExtension.
	self fail: 'extend input SomeType {}' rule: #typeSystemExtension.
	self fail: 'extend "desription of inputObject" input SomeType { someName: String}' rule: #typeSystemExtension.
											
]

{ #category : #'test-grammar-inputTypes' }
GQLSchemaGrammarTest >> testInputType [
	self parse: '[Int ! ]!' rule: #inputType.
	self parse: '[String ! ]' rule: #inputType.
	self parse: '[ String ]!' rule: #inputType.
	self parse: 'Int !' rule: #inputType.
	self parse: 'String' rule: #inputType.
	self parse: 'Some' rule: #inputType.
]

{ #category : #'test-grammar-inputTypes' }
GQLSchemaGrammarTest >> testInputTypeIncorrect [
	self fail: '[Int' rule: #inputType.
	self fail: '[String !' rule: #inputType.
	self fail: '[ ]!' rule: #inputType.
	self fail: '!' rule: #inputType.
	self fail: '[Some' rule: #inputType.
]

{ #category : #'test-grammar-interfaceType' }
GQLSchemaGrammarTest >> testInterfaceType [
	self parse: 'interface DogCommand { some : Int}' rule: #interfaceType.
	self parse:
			'interface CatCommand { other : [ Int ]
												  name : String !
												  friends : [ Cat ]! }'
		rule: #interfaceType.
	self parse:
			'interface CatCommand { other : [ Int ! ] !
												  name(some : String) : String !
												  friends : [ Cat ]! }'
		rule: #interfaceType.
]

{ #category : #'test-grammar-typeSystemExtension' }
GQLSchemaGrammarTest >> testInterfaceTypeExtension [
	self parse: 'extend interface SomeInterface {someObject : Some }' rule: #typeSystemExtension.
	self parse: 'extend interface Some {some : SomeName !}' rule: #typeSystemExtension.
	self parse: 'extend interface SomeOther {some: Some
											other: Some
											someOther: SomeType}' rule: #typeSystemExtension.
]

{ #category : #'test-grammar-typeSystemExtension' }
GQLSchemaGrammarTest >> testInterfaceTypeExtensionIncorrect [
	self fail: 'extend SomeInterface {someObject : Some }' rule: #typeSystemExtension.
	self fail: 'extend interface {some : SomeName !}' rule: #typeSystemExtension.
	self fail: 'extend interface {some: Some
											other: Some
											someOther: SomeType}' rule: #typeSystemExtension.
	self fail: 'extend Some {some: Some
									 other: Some
									 someOther: SomeType}' rule: #typeSystemExtension.
	self fail: 'extend "desription of interfaceType" interface SomeInterface { 
									someName: String}' rule: #typeSystemExtension.
]

{ #category : #'test-grammar-interfaceType' }
GQLSchemaGrammarTest >> testInterfaceTypeIncorrect [
	self fail: 'interface  { some : Int}' rule: #interfaceType.
	self
		fail:
			'interface CatCommand { other : [ Int 
												  name : String !
												  friends : [ Cat ]! }'
		rule: #interfaceType.
	self
		fail:
			'interface CatCommand { other :
												  name : String !
												  friends : [ Cat ]! }'
		rule: #interfaceType
]

{ #category : #'test-grammar-listInputType' }
GQLSchemaGrammarTest >> testListInputType [
	"Inner types only input type"

	self parse: '[Int]' rule: #listInputType.
	self parse: '[String ! ]' rule: #listInputType.
	self parse: '[Some!]' rule: #listInputType.
	self parse: '[Some ! ] ' rule: #listInputType.
	self parse: '[[Int]]' rule: #listInputType
]

{ #category : #'test-grammar-listInputType' }
GQLSchemaGrammarTest >> testListInputTypeIncorrect [
	self fail: 'Int !' rule: #listInputType.
	self fail: '[Int ! ]!!' rule: #listInputType.
	self fail: '[Int ! ]!' rule: #listInputType.
	self fail: '[String ' rule: #listInputType.
	self fail: '[Some ' rule: #listInputType.
	self fail: '[Some! ' rule: #listInputType.
	self fail: '[Some !!' rule: #listInputType.
	self fail: '[ Some ] !' rule: #listInputType.
]

{ #category : #'test-grammar-listType' }
GQLSchemaGrammarTest >> testListType [
	self parse: '[Int]' rule: #listType.
	self parse: '[SomeObject ]' rule: #listType.
	self parse: '[String! ]' rule: #listType.
	self parse: '[SomeObject ! ] ' rule: #listType.
]

{ #category : #'test-grammar-listType' }
GQLSchemaGrammarTest >> testListTypeIncorrect [
	self fail: 'Int !' rule: #listType.
	self fail: '[Int]!' rule: #listType.
	self fail: '[Int ! ]!!' rule: #listType.
	self fail: '[String ' rule: #listType.
	self fail: '[Some !' rule: #listType
]

{ #category : #'test-grammar-nonNullInputType' }
GQLSchemaGrammarTest >> testNonNullInputType [
	self parse: 'Int!' rule: #nonNullInputType.
	self parse: 'SomeOtherType !' rule: #nonNullInputType.
	self parse: '[ Int ]!' rule: #nonNullInputType.
	self parse: '[ Int! ]!' rule: #nonNullInputType.
	self parse: '[ SomeOtherType ]!' rule: #nonNullInputType.
	self parse: '[ SomeOtherType! ]!' rule: #nonNullInputType
]

{ #category : #'test-grammar-nonNullInputType' }
GQLSchemaGrammarTest >> testNonNullInputTypeIncorrect [
	self fail: 'Int!!' rule: #nonNullInputType.
	self fail: 'Int' rule: #nonNullInputType.
	self fail: 'SomeOtherType' rule: #nonNullInputType.
	self fail: '[ Int! ]' rule: #nonNullInputType.
	self fail: '[ Int ]' rule: #nonNullInputType.
	self fail: '[ SomeOtherType ]' rule: #nonNullInputType.
	self fail: '[ SomeOtherType! ]' rule: #nonNullInputType
]

{ #category : #'test-grammar-nonNullType' }
GQLSchemaGrammarTest >> testNonNullType [
	self parse: 'Int!' rule: #nonNullType.
	self parse: 'SomeOtherType !' rule: #nonNullType.
	self parse: '[ Int ]!' rule: #nonNullType.
	self parse: '[ Int! ]!' rule: #nonNullType.
	self parse: '[ SomeOtherType ]!' rule: #nonNullType.
	self parse: '[ SomeOtherType! ]!' rule: #nonNullType.
]

{ #category : #'test-grammar-nonNullType' }
GQLSchemaGrammarTest >> testNonNullTypeIncorrect [
	self fail: 'Int!!' rule: #nonNullType.
	self fail: 'Int' rule: #nonNullType.
	self fail: 'SomeOtherType' rule: #nonNullType.
	self fail: '[ Int! ]' rule: #nonNullType.
	self fail: '[ Int ]' rule: #nonNullType.
	self fail: '[ SomeOtherType ]' rule: #nonNullType.
	self fail: '[ SomeOtherType! ]' rule: #nonNullType
]

{ #category : #'test-grammar-objectType' }
GQLSchemaGrammarTest >> testObjectType [
	self parse: 'type SomeType {someName : [Int]}' rule: #objectType.
	self
		parse: 'type SomeOtherTypeName {someName 	: [String ! ], someName 	:String }'
		rule: #objectType.
	self parse: 'type Some {someObject : Some }' rule: #objectType.
	self parse: 'type Some {someObject : Some ! }' rule: #objectType.
	self parse: 'type Some {someObject : [ Some ] ! }' rule: #objectType.
	self parse: 'type Some {someObject : [ Some ! ] }' rule: #objectType.
	self parse: 'type Some {someObject : [ Some ! ] ! }' rule: #objectType.
	self parse: 'type Some implements Other { some : Int }' rule: #objectType.
	self
		parse: 'type SomeOtherTypeName implements Other {someName 	: [String ! ], someName 	:String }'
		rule: #objectType.
	self parse: 'type Some implements Other {someObject : Some }' rule: #objectType.
	self parse: 'type Some implements Other {someObject(a : String) : Some }' rule: #objectType.
	self parse: 'type Some implements Other {someObject(a : String, p: Some) : Some }' rule: #objectType.
	self parse: 'type Some implements Other {someObject : Some ! }' rule: #objectType.
	self parse: 'type Some implements Other {someObject : [ Some ] ! }' rule: #objectType.
	self parse: 'type Some implements Other {someObject : [ Some ! ] }' rule: #objectType.
	self parse: 'type Some implements Other {someObject : [ Some ! ] ! }' rule: #objectType.
]

{ #category : #'test-grammar-typeSystemExtension' }
GQLSchemaGrammarTest >> testObjectTypeExtension [
	self parse: 'extend type Some {someObject : Some }' rule: #typeSystemExtension.
	self parse: 'extend type SomeType {some : SomeName !}' rule: #typeSystemExtension.
	self parse: 'extend type Some {some: Some
											other: Some
											someOther: SomeType}' rule: #typeSystemExtension.
	self parse: 'extend type Some implements otherInterface {
						some : Some
						otherSome: Some}' rule: #typeSystemExtension.
	self parse: 'extend type Some implements interfaceOne & interfaceTwo {
						some : Some 
						someName: SomeOther}' rule: #typeSystemExtension.
	self parse: 'extend type Some implements interfaceOne' rule: #typeSystemExtension.
	self parse: 'extend type Some implements interfaceOne & interfaceTwo' rule: #typeSystemExtension.
]

{ #category : #'test-grammar-typeSystemExtension' }
GQLSchemaGrammarTest >> testObjectTypeExtensionIncorrect [
	self fail: 'extend type Some { }' rule: #typeSystemExtension.
	self fail: 'extend type1 Some {someObject: Some }' rule: #typeSystemExtension.
	self fail: 'extend SomeType {some : SomeName !}' rule: #typeSystemExtension.
	self fail: 'extend {some: Some
								other: Some
								someOther: SomeType}' rule: #typeSystemExtension.
	self fail: 'type Some implements otherInterface {
						some : Some
						otherSome: Some}' rule: #typeSystemExtension.
	self fail: 'extend type Some implements {
						some : Some 
						someName: SomeOther}' rule: #typeSystemExtension.
	self fail: 'extend type Some implements ' rule: #typeSystemExtension.
	self fail: 'extend type Some implements interface1 & ' rule: #typeSystemExtension.
	self fail: 'extend "desription of ObjectType" type SomeType { 
						someName: String}' rule: #typeSystemExtension.
]

{ #category : #'test-grammar-parameter' }
GQLSchemaGrammarTest >> testParameter [
	self parse: 'p1:[Int!]!' rule: #parameter.
	self parse: 'p1 : [String ! ]' rule: #parameter.
	self parse: 'p2: String!' rule: #parameter.
	self parse: 'p : Some' rule: #parameter.
	self parse: 'p : Some!' rule: #parameter.
	self parse: 'p : [ Some ] !' rule: #parameter.
	self parse: 'p : [Some!] !' rule: #parameter.
	self parse: '__p1: Int' rule: #parameter.
]

{ #category : #'test-grammar-parameter' }
GQLSchemaGrammarTest >> testParameterIncorrect [
	self fail: 'Int !' rule: #parameter.
	self fail: 'p1:' rule: #parameter.
	self fail: 'p1: !' rule: #parameter.
	self fail: 'p1 Int' rule: #parameter.
	self fail: 'p1 !' rule: #parameter.
]

{ #category : #'test-grammar-parameters' }
GQLSchemaGrammarTest >> testParameters [
	self parse: '(p1:[Int], p2:String)' rule: #parameters.
	self parse: '(p1 : [String ! ])' rule: #parameters.
	self parse: '( p1 :[Int ! ]!, p2: String!)' rule: #parameters.
	self parse: '(p1: Int, __p2: String)' rule: #parameters.
]

{ #category : #'test-grammar-parameters' }
GQLSchemaGrammarTest >> testParametersIncorrect [
	self fail: '(Int !)' rule: #parameters.
	self fail: '(p1, p2)' rule: #parameters.
	self fail: '(p1 : Int' rule: #parameters.
	self fail: '(p1 Int)' rule: #parameters.
	self fail: '(p1 Int!)' rule: #parameters.
	self fail: '(p1 : !)' rule: #parameters.
	self fail: '(p1 : Int, p2)' rule: #parameters.
	self fail: '(p1, p2 : Int)' rule: #parameters.
]

{ #category : #'tests-grammar' }
GQLSchemaGrammarTest >> testSchemaAll [
	| text |
	text := 'enum DogCommand { SIT, DOWN, HEEL }

				type Dog implements Pet {
  					name: String!
  					nickname: String
  					barkVolume: Int
  					doesKnowCommand(dogCommand: DogCommand!): Boolean!
  					isHousetrained(atOtherHomes: Boolean): Boolean!
  					owner: Human
				}

				interface Sentient {
  					name: String!
				}

				interface Pet {
 					 name: String!
				}

				type Alien implements Sentient {
  					name: String!
  					homePlanet: String
				}

				type Human implements Sentient {
  					name: String!
				}

				enum CatCommand { JUMP }

			type Cat implements Pet {
  				name: String!
  				nickname: String
  				doesKnowCommand(catCommand: CatCommand!): Boolean!
  				meowVolume: Int
			}

			union CatOrDog = Cat | Dog
			union DogOrHuman = Dog | Human
			union HumanOrAlien = Human | Alien

			type QueryRoot {
  				dog: Dog
			}'.
	self parse: text rule: #schema
]

{ #category : #'tests-grammar' }
GQLSchemaGrammarTest >> testSchemaDefinition [
	self parse: '
			schema{
					query: Query
				}
				type Query{
					hello: String
				}' rule: #schema.
	self parse: '
		schema{
			query: Query
			mutation: Mutation	
		}
		type Query { 
			hello: String
		}
		type Mutation{
			setNumber(to:Int): Int
		}
		' rule: #schema.
]

{ #category : #'tests-grammar' }
GQLSchemaGrammarTest >> testSchemaDefinitionIncorrect [
	self fail: '
				schema{
					query: Query
					query2: Query2
				}
				type Query{
					hello
				}
				type Query2{
					helloWorld
				}' rule: #schema.
	self fail: 'schema1{
						query: Query
					}
					type Query{
						hello
					}' rule: #schema.
	self fail: 'schema{
						query: Query
						mutation1: Mutation
					}
					type Query{
						hello
					}
					mutation Mutation{
						setNumber(num:Int): Int
					}
					' rule: #schema.
	self fail: 'schema{
						query: __Query
					}
					type __Query{
						hello
					}
					' rule: #schema.
	self fail: 'schema{
					}' rule: #schema.
]

{ #category : #'test-grammar-typeSystemExtension' }
GQLSchemaGrammarTest >> testSchemaExtension [
	self parse: 'extend schema {query : Query}' rule: #typeSystemExtension.
	self parse: 'extend schema {mutation : Mutation}' rule: #typeSystemExtension.
	self parse: 'extend schema {subscription : Subscription}' rule: #typeSystemExtension.
	self parse: 'extend schema {query : SomeName}' rule: #typeSystemExtension.
	self parse: 'extend schema {mutation : SomeMutation}' rule: #typeSystemExtension.
	self parse: 'extend schema {subscription : SubscriptionTwo}' rule: #typeSystemExtension.
	self parse: 'extend schema {query : SomeQuery
									   mutation : OtherMutation}' rule: #typeSystemExtension.
	self parse: 'extend schema {query : SomeName
									   subscription : SomeOther}' rule: #typeSystemExtension.
	self parse: 'extend schema {mutation : OtherMutation
									   subscription : SomeName}' rule: #typeSystemExtension.
	self parse: 'extend schema {query : SomeName
										subscription : SomeOther
									   mutation : SomeOtherToo}' rule: #typeSystemExtension.
]

{ #category : #'test-grammar-typeSystemExtension' }
GQLSchemaGrammarTest >> testSchemaExtensionIncorrect [
	self fail: 'extend schema {some : Query}' rule: #typeSystemExtension.
	self fail: 'extend schema {mutation2 : Mutation}' rule: #typeSystemExtension.
	self fail: 'extend schema {other : Subscription}' rule: #typeSystemExtension.
	self fail: 'extend schema {someName : Query
									   someOther : Mutation}' rule: #typeSystemExtension.
	self fail: 'extend schema {query1 : Query
										subscription1 : Subscription
									   mutation1 : Mutation}' rule: #typeSystemExtension.
]

{ #category : #'tests-grammar' }
GQLSchemaGrammarTest >> testSchemaInputObjectType [
	| text |
	text := 'input MessageInput {
  				content: String
 				author: String
			}

			type Message {
  				id: ID!
  				content: String
  				author: String
			}

			type Query {
  				getMessage(id: ID!): Message
			}'.
	self parse: text rule: #schema.
	self parse: 'input SomeType {
						someName : [Int]
					}' rule: #schema.
	self parse: 'input SomeOtherTypeName {
						someName 	: [String ! ],
						someName 	:String 
					}' rule: #schema
]

{ #category : #'tests-grammar' }
GQLSchemaGrammarTest >> testSchemaObjectType [
	| text |
	text := 'type SomeType {
					someName : [Int]
				},
				type SomeOtherTypeName {
					someName 	: [String ! ]
					someName 	:String 
				}'.
	self parse: text rule: #schema.
	self parse: 'type SomeType {
						someName : [Int]
					}' rule: #schema.
	self parse: 'type SomeOtherTypeName {
						someName 	: [String ! ],
						someName 	:String 
					}' rule: #schema
]

{ #category : #'tests-grammar' }
GQLSchemaGrammarTest >> testSchemaWithEnum [
	| text |
	text := 'enum DogCommand { SIT, DOWN, HEEL }
				type SomeType {
					someName : [Int]
				},
				type SomeOtherTypeName {
					someName 	: [String ! ]
					someName 	:String 
				}'.
	self parse: text rule: #schema.
	self
		parse:
			'type SomeType {
						someName : [Int]
					}
			enum DogCommand { SIT, DOWN, HEEL }'
		rule: #schema.
	self
		parse:
			'enum CatCommand { JUMP }
			type SomeOtherTypeName {
						someName 	: [String ! ],
						someName 	:String 
					}
			enum DogCommand { SIT, DOWN, HEEL }'
		rule: #schema
]

{ #category : #'tests-grammar' }
GQLSchemaGrammarTest >> testSchemaWithInterface [
	| text |
	text := 'type SomeType {
					someName : [Int]
				},
				interface SomeOtherTypeName {
					someName 	: [String ! ]
					someName 	:String 
				}'.
	self parse: text rule: #schema.
	self
		parse:
			'interface SomeType {
						someName : [Int]
					}'
		rule: #schema.
]

{ #category : #'tests-grammar' }
GQLSchemaGrammarTest >> testSchemaWithUnion [
	| text |
	text := 'union DogOrHuman = Dog | Human
				union HumanOrAlien = Human | Alien
				type SomeType {
					someName : [Int]
				},
				type SomeOtherTypeName {
					someName 	: [String ! ]
					someName 	:String 
				}'.
	self parse: text rule: #schema.
	self
		parse:
			'type SomeType {
						someName : [Int]
					}
			union HumanOrAlien = Human | Alien'
		rule: #schema.
	self
		parse:
			'union HumanOrAlien = Human | Alien
			type SomeOtherTypeName {
						someName 	: [String ! ],
						someName 	:String 
					}
			union DogOrHuman = Dog | Human'
		rule: #schema
]

{ #category : #'test-grammar-unionType' }
GQLSchemaGrammarTest >> testUnionType [
	self parse: 'union CatOrDog = Cat | Dog' rule: #unionType.
	self parse: 'union DogOrHuman = Dog | Human' rule: #unionType.
	self parse: 'union DogOrCatOrBird = Dog | Cat | Bird' rule: #unionType.
]

{ #category : #'test-grammar-typeSystemExtension' }
GQLSchemaGrammarTest >> testUnionTypeExtension [
	self parse: 'extend union CatOrDog = Cat | Dog' rule: #typeSystemExtension.
	self parse: 'extend union DogOrHuman = Dog | Human' rule: #typeSystemExtension.
	self parse: 'extend union DogOrCatOrBird = Dog | Cat | Bird' rule: #typeSystemExtension.
											
]

{ #category : #'test-grammar-typeSystemExtension' }
GQLSchemaGrammarTest >> testUnionTypeExtensionIncorrect [
	self fail: 'extend union = Cat | Dog' rule: #typeSystemExtension.
	self fail: 'union DogOrHuman = Dog | Human' rule: #typeSystemExtension.
	self fail: 'extend DogOrCatOrBird = Dog | Cat | Bird' rule: #typeSystemExtension.
	self fail: 'extend "desription of Union" union SomeUnion = Cat | Dog' rule: #typeSystemExtension.
											
]

{ #category : #'test-grammar-unionType' }
GQLSchemaGrammarTest >> testUnionTypeIncorrect [
	self fail: 'union CatOrDog = Cat | ' rule: #unionType.
	self fail: 'union = Cat | Dog' rule: #unionType.
	self fail: 'union CatOrDog Cat | Dog' rule: #unionType.
	self fail: 'union CatOrDog = Cat Dog' rule: #unionType.
]
