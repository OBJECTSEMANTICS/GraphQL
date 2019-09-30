"
A GQLRequestTest is a test class for testing the behavior of request validator.

According the specification of http://facebook.github.io/graphql/draft/#sec-Execution: 
	- if validation errors are known, they should be reported in the list of 'errors' in the response
"
Class {
	#name : #GQLSRequestTest,
	#superclass : #GQLAbstactTypeSystemTest,
	#category : #'GraphQLBeta-Tests-TypeValidation'
}

{ #category : #'tests-fragments' }
GQLSRequestTest >> testFragment [
	| request result expectedResult |
	schema := self getSchema: 'inputBooleanType' withRoot: GQLTestSchema new.
	request := '{
		hello
	}
	fragment fragment1 on GQLTestFilm{
		name
	}
	'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Fragment \"fragment1\" is never used.",
			"locations" : [
				{
					"line" : 4,
					"column" : 11
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		hello
	}
	fragment fragment1 on GQLTestFilm{
		name
	}
	fragment fragment1 on GQLTestFilm{
		name
	}
	'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Fragment \"fragment1\" is never used.",
			"locations" : [
				{
					"line" : 4,
					"column" : 11
				},
				{
					"line" : 7,
					"column" : 11
				}
			]
		},
		{
			"message" : "There can be only one fragment named \"fragment1\".",
			"locations" : [
				{
					"line" : 4,
					"column" : 11
				},
				{
					"line" : 7,
					"column" : 11
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		hello
	}
	fragment fragment1 on GQLTes{
		name
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Fragment \"fragment1\" is never used.",
			"locations" : [
				{
					"line" : 4,
					"column" : 11
				}
			]
		},
		{
			"message" : "Unkwown type \"GQLTes\".",
			"locations" : [
				{
					"line" : 4,
					"column" : 24
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
	films(sortedByName: true) {
			...gqlTest
		}
	}
	fragment gqlTest on GQLTestFilm{
		name
		...otherGQLTest
	}
	fragment otherGQLTest on GQLTestFilm{
	   ...gqlTest
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Cannot spread fragment \"gqlTest\" with itself via otherGQLTest",
			"locations" : [
				{
					"line" : 8,
					"column" : 6
				}
			]
		},
		{
			"message" : "Cannot spread fragment \"otherGQLTest\" with itself via gqlTest",
			"locations" : [
				{
					"line" : 11,
					"column" : 8
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
]

{ #category : #tests }
GQLSRequestTest >> testRequest [
	| request result expectedResult |
	schema := self getSchema: 'inputStringType' withRoot: GQLTestSchema new.
	compareJson := true.
	request := '{
		helloTo(name: "Alex")
	'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Syntax Error: blank expected",
			"locations" : [
				{
					"line" : 3,
					"column" : 1
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		helloTo(nameOf: "Alex")
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Unknown argument \"nameOf\" on field \"helloTo\" on type \"GQLTestSchema\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 11
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
	}'.
	result := self attendRequest: request using: '' with: ''.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Syntax Error: $# expected",
			"locations" : [
				{
					"line" : 2,
					"column" : 1
				}
			]
		}
	]
}'.
	self assert: (result includesKey: 'errors').
	
	request := '{
		hel
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Cannot query field \"hel\" on type \"GQLTestSchema\"",
			"locations" : [
				{
					"line" : 2,
					"column" : 3
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
]
