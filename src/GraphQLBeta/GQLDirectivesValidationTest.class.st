"
https://facebook.github.io/graphql/draft/#sec-Validation.Directives
"
Class {
	#name : #GQLDirectivesValidationTest,
	#superclass : #GQLTestValidation,
	#category : #'GraphQLBeta-Tests-Validation'
}

{ #category : #tests }
GQLDirectivesValidationTest >> testDirectivesAreDefined [
	"GraphQL servers define what directives they support. For each usage of a directive, the directive must be available on that server."
	self assert: (schema getDirective: 'skip') notNil.
	self assert: (schema getDirective: 'include') notNil.
	
]

{ #category : #tests }
GQLDirectivesValidationTest >> testDirectivesAreInValidLocations [
	"GraphQL servers define what directives they support and where they support them. For each usage of a directive, the directive must be used in a location that the server has declared support for."
	| result |
	result := self 
		operation: 'foo'
		jsonRequest: '
query foo @skip(if: $foo) {
	dog{
		nickname
	}
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Directive \"skip\" may not be used on QUERY.",
			"locations" : [
				{
					"line" : 2,
					"column" : 12
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLDirectivesValidationTest >> testDirectivesAreUniquePerLocation01 [
	"Directives are used to describe some metadata or behavioral change on the definition they apply to. When more than one directive of the same name is used, the expected metadata or behavior becomes ambiguous, therefore only one of each directive is allowed per location."
	| result |
	result := self 
		operation: 'foo'
		jsonRequest: '
query foo($foo: Boolean=true, $bar: Boolean = false) {
	dog @skip(if: $foo) @skip(if: $bar) {
		nickname
	}
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "The directive \"skip\" can only be used once at this location.",
			"locations" : [
				{
					"line" : 3,
					"column" : 7
				},
				{
					"line" : 3,
					"column" : 23
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLDirectivesValidationTest >> testDirectivesAreUniquePerLocation02 [
	"Directives are used to describe some metadata or behavioral change on the definition they apply to. When more than one directive of the same name is used, the expected metadata or behavior becomes ambiguous, therefore only one of each directive is allowed per location."
	| result |
	result := self 
		operation: 'foo'
		jsonRequest: '
query foo($foo: Boolean = true, $bar: Boolean = false) {
  dog @skip(if: $foo) {
    nickname
  }
  dog @skip(if: $bar) {
    barkVolume
  }
}'.
	self assertJSONEquals: result and: '{
	"data" : {
			"dog" : {
				"barkVolume" : 10
			}
		}
	}'
]

{ #category : #tests }
GQLDirectivesValidationTest >> testInvalidDirectives [
	| result |
	result := self 
		jsonRequest: '
{
	dog @invalid { 
		name
	 }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Unknown directive \"invalid\".",
			"locations" : [
				{
					"line" : 3,
					"column" : 7
				}
			]
		}
	]
}'
]
