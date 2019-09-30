"
A GQLSchemaGrammarTest is a test class for testing the behavior of GQLSchemaGrammar
"
Class {
	#name : #GQLRequestGrammarTest,
	#superclass : #PPCompositeParserTest,
	#instVars : [
		'parserVariable'
	],
	#category : #'GraphQLBeta-Tests-Grammar'
}

{ #category : #initialization }
GQLRequestGrammarTest >> parserClass [
	^ GQLRequestGrammar
]

{ #category : #initialization }
GQLRequestGrammarTest >> setUp [
	parserVariable := GQLVariableGrammar
]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testAlias [
	|text|
	text := 'smallPic:'.
	self parse: text rule: #alias.
	text := 'smallPic :'.
	self parse: text rule: #alias.
	
	
]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testArgument [
	|text|
	text := 'id:4'.
	self parse: text rule: #argument.

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testArguments [
	|text|
	text := '(id: 4)'.
	self parse: text rule: #arguments.

	text := '(id: 4, pass: 1233, pass2: 12312)'.
	self parse: text rule: #arguments.

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testComment [
	|text|
	text := '#Comment of an line'.
	self parse: text rule: #comment.

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testDirectives [
	self parse: '@skip' rule: #directives.
	self parse: '@skip(if: true)' rule: #directives.
	self parse: '@skip(if: false)' rule: #directives.
	self fail: 'missing@(if: true)' rule: #directives.

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testDocument [
	| text |
	text := 'fragment friendFields on User {
  		id
  		name
 	 	profilePic(size: 50)
	}'.
	self parse: text rule: #document.
	
	text := 'fragment friendFields on User {
 	 	id
  		name
  		...standardProfilePic
	}'.
	self parse: text rule: #document.
	
	text := '{
	  likeStory {
			story {
  	  	  		likeCount
  	 		}
 	 	}
	}'.
	self parse: text rule: #document.

	text := 'mutation fetchLikeStory($var:Int){
	  likeStory(storyID: Int) {
			story {
  	  	  		likeCount
  	 		}
 	 	}
	}'.
	self parse: text rule: #document.
	
	text := '{
	  likeStory($storyID: Int=12) {
			story {
  	  	  		likeCount
  	 		}
 	 	}
	}'.
	self fail: text rule: #document.
	

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testEnumValue [

	self parse: 'ENUM_VALUE' rule: #enumValue.
	self parse: 'any_other_name_value_noSpaces' rule: #enumValue.
	self fail: 'true' rule: #enumValue.
	self fail: 'false' rule: #enumValue.
	self fail: 'null' rule: #enumValue.

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testField [
	|text|
	text := 'me'.
	self parse: text rule: #field.
	
	text := 'user(id: 4) {
    name
  }'.
	self parse: text rule: #field.
	
	text := '__name'.
	self parse: text rule: #field. 

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testFragmentDefinition [
	|text|
	text := 'fragment friendFields on User {
  id
  name
  profilePic(size: 50)
}'.
	self parse: text rule: #fragmentDefinition.
	
	text := 'fragment friendFields on User {
  id
  name
  ...standardProfilePic
}'.
	self parse: text rule: #fragmentDefinition.
	
]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testFragmentSpread [
	|text|
	text := '...friendFields'.
	self parse: text rule: #fragmentSpread.
]

{ #category : #'tests-grammar-comment' }
GQLRequestGrammarTest >> testGrammarDocumentWithComment [
	| text |
	text := 'fragment #comment 1
	friendFields on #comment 2
	User {
		#id
  		id
		#name
  		name
		#profilePic
 	 	profilePic(size: 50)
	}'.
	self parse: text rule: #document.
	
	text := '{
	  #comment 1
	  likeStory {
	  #comment 2
			story {
			#comment 3
  	  	  		likeCount
  	 		}
 	 	}
	}'.
	self parse: text rule: #document.
	
	
	
]

{ #category : #'tests-grammar-comment' }
GQLRequestGrammarTest >> testGrammarNodeWithComment [
	self parse: '#comment 
	@skip(if: false) #comment 1' rule: #directives.
	
	self parse: 'user(id: 4) { 
	#comment 1
	name 
	#comment 2
	}' rule: #field.
	
	self parse: 'fragment #comment 1
		friendFields on User 
		#comment 2
		{
		#id
  		id
		#name
  		name
		#name
  		profilePic(size: 50)
	}' rule: #fragmentDefinition.
	
	self parse: '... on #comment 1
		User {
		#comment 2
      friends {
		  #comment 3
        count
      }
    }' rule: #inlineFragment.
	
]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testInlineFragment [
	|text|
	text := '... on User {
      friends {
        count
      }
    }'.
	self parse: text rule: #inlineFragment.
	
	text := '... @include(if: $expandedInfo) {
      firstName
      lastName
      birthday
    }'.
	self parse: text rule: #inlineFragment.
]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testInlineFragments [
	|text|
	text := '... on User {
      friends {
        count
      }
    }'.
	self parse: text rule: #inlineFragment.
	
	text := '... @include(if: $expandedInfo) {
      firstName
      lastName
      birthday
    }'.
	self parse: text rule: #inlineFragment.
]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testIntrospection [
	|text|
	text := '{ 
		__type(name: "User") { 
			name
			fields { 
				name
				type { 
					name
				}
			}
		}
	}'.
	self parse: text rule: #operationDefinition.
]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testListValue [
	self parse: '[1, 2, 3]' rule: #listValue.
	self parse: '["a"]' rule: #listValue.
	self parse: '[]' rule: #listValue.
	self parse: '[[], "a", 1]' rule: #listValue.
	self fail: 'null' rule: #listValue.
	self fail: '123.123e12' rule: #listValue.

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testNamedType [
	self parse: 'NamedType' rule: #namedType.
	self parse: '__NamedType' rule: #namedType.
	self fail: 'NonNullType!' rule: #namedType.
]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testNonNullType [
	self parse: 'NonNullType!' rule: #nonNullType.
	self fail: 'NonNullType' rule: #nonNullType.
]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testNullValue [
	self parse: 'null' rule: #nullValue.
	self fail: '123.123' rule: #nullValue.
	self fail: 'asdf' rule: #nullValue.

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testObjectField [
	|text|
	
	text := '_4__ : null'.
	self parse: text rule: #objectField.
	text := 'age : 12'.
	self parse: text rule: #objectField.
	

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testObjectValue [
	|text|
	
	text := '{ }'.
	self parse: text rule: #objectValue.
	
	text := '{name: "12.43", age: 53 }'.
	self parse: text rule: #objectValue.
	

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testOperationDefinition [
	|text|
	
	text := '{
	  likeStory {
			story {
  	  	  		likeCount
  	 		}
 	 	}
	}'.
	self parse: text rule: #operationDefinition.

	text := 'mutation fetchLikeStory($var:Int){
	  likeStory(storyID: Int) {
			story {
  	  	  		likeCount
  	 		}
 	 	}
	}'.
	self parse: text rule: #operationDefinition.
	
	text := '{
	  likeStory($storyID: Int=12) {
			story {
  	  	  		likeCount
  	 		}
 	 	}
	}'.
	self fail: text rule: #operationDefinition.

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testSelectionSet [
	|text|
	
	text := '{
		films {
			id #comment
			name 
			rating 
		}
	}'.
	self parse: text rule: #selectionSet.

	text := '{
			parents { 
				firstName
			}
  			firstName
  			lastName
			friends { 
				nickname
				lastname
			}
		}'.
	self parse: text rule: #selectionSet.

	text := '{
  			friends(id:4) { 
				nickname
			}
  			firstName
  			lastName
		}'.
	self parse: text rule: #selectionSet.

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testType [

	self parse: 'NonNullType' rule: #type.
	self parse: 'NonNullType!' rule: #type.
	self parse: '[Named]' rule: #type.
	self parse: '[Named!]' rule: #type.
	self parse: '[Named]!' rule: #type.
	self parse: '[Named!]!' rule: #type.
	self parse: 'Boolean' rule: #type.
	self parse: 'Int!' rule: #type.
	self parse: '[Float]' rule: #type.
	self parse: '[String!]' rule: #type.
	self parse: '[ID]!' rule: #type.
	self parse: '[Int!]!' rule: #type
	
]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testTypeCondition [
	|text|
	text := 'on User'.
	self parse: text rule: #typeCondition.
]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testValue [
	"implement tests with test contained in intValue floatValue, StringValue,
	BooleanValue, NullValue, EnumValue, ListValue, ObjectValue"
	
	"int value"
	self parse: '2312' rule: #value.
	self parse: '-123' rule: #value.
	self parse: '+444' rule: #value.

	"float value"
	self parse: '2312.12' rule: #value.
	self parse: '-123.23e12' rule: #value.
	self parse: '-123.23E12' rule: #value.
	self parse: '12' rule: #value.

	"boolean value"
	self parse: 'true' rule: #value.
	self parse: 'false' rule: #value.

	"string value"
	self parse: '""' rule: #value.
	self parse: '"any other kind of text +_)(*&^%$#@ |}{:?><][/;.,"' rule: #value.
	self parse: '"\u00f3 \\ \/ \b \f \n \r \t"' rule: #value.

	"list value"
	self parse: '[1, 2, 3]' rule: #value.
	self parse: '["a"]' rule: #value.
	self parse: '[]' rule: #value.
	self parse: '[[], "a", 1]' rule: #value.

	"null value"
	self parse: 'null' rule: #value.
	
	"enum value"	
	self parse: 'ENUM_VALUE' rule: #value.
	self parse: 'any_other_name_value_noSpaces' rule: #value.

	self parse: '{ }' rule: #value.
	self parse: '{name: "12.43", age: 53 }' rule: #value.
	
]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testVariable [
	self parse: '$someVariableName' rule: #variable.
	self fail: 'missing$atthebegining' rule: #variable.

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testVariableDefinition [
	self parse: '$devicePicSize: Int' rule: #variableDefinition.
	self parse: '$devicePicSize: Int = 12' rule: #variableDefinition.

]

{ #category : #'tests-grammar' }
GQLRequestGrammarTest >> testVariableDefinitions [
	self parse: '($devicePicSize: Int)' rule: #variableDefinitions.
	self parse: '($devicePicSize: Int = 12)' rule: #variableDefinitions.
	self parse: '($devicePicSize: Int = 12, $devicePicSize: Int = 2)' rule: #variableDefinitions.
	self fail: '($devicePicSize: Int = 12,)' rule: #variableDefinitions.
	self fail: '$devicePicSize: Int = 12' rule: #variableDefinitions.

]
