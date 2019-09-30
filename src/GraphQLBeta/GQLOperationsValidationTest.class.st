"
https://facebook.github.io/graphql/draft/#sec-Validation.Operations
"
Class {
	#name : #GQLOperationsValidationTest,
	#superclass : #GQLTestValidation,
	#category : #'GraphQLBeta-Tests-Validation'
}

{ #category : #tests }
GQLOperationsValidationTest >> testLoneAnonymousOperation01 [
	| result |
	"This document is the valid"
	result := self jsonRequest: '
{
  dog {
    name
  }
}'.
	self assertJSONEquals: result and: '{
	"data" : { 
		"dog" : {
			"name" : "lobo"
		}
	}
}'
]

{ #category : #tests }
GQLOperationsValidationTest >> testLoneAnonymousOperation02 [
	| result |
	"This document is the invalid"
	result := self jsonRequest: '

{
  dog {
    name
  }
}

query getName {
  dog {
    owner {
      name
    }
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "GraphQL allows a short‐hand form for defining query operations when only that one operation exists in the document.",
			"locations" : [
				{
					"line" : 3,
					"column" : 1
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLOperationsValidationTest >> testOperationUniqueName01 [
	| result |
	"This document is the valid"
	result := self 
		operation: 'getDogName'
		jsonRequest: '
query getDogName {
  dog {
    name
  }
}

query getOwnerName {
  dog {
    owner {
      name
    }
  }
}'.
	self assertJSONEquals: result and: '{
	"data" : { 
		"dog" : {
			"name" : "lobo"
		}
	}
}'
]

{ #category : #tests }
GQLOperationsValidationTest >> testOperationUniqueName02 [
	| result |
	"This is document is invalid"
	result := self 
		operation: 'getName'
		jsonRequest: '
query getName {
  dog {
    name
  }
}

query getName {
  dog {
    owner {
      name
    }
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Each named operation definition must be unique: \"getName\"",
			"locations" : [
				{
					"line" : 2,
					"column" : 7
				},
				{
					"line" : 8,
					"column" : 7
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLOperationsValidationTest >> testOperationUniqueName03 [
	| result |
	"This is document is invalid even if the type of each operation is different"
	result := self 
		operation: 'getName'
		jsonRequest: '
query dogOperation {
  dog {
    name
  }
}

mutation dogOperation {
  mutateDog {
    id
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Each named operation definition must be unique: \"dogOperation\"",
			"locations" : [
				{
					"line" : 2,
					"column" : 7
				},
				{
					"line" : 8,
					"column" : 10
				}
			]
		},
		{
			"message" : "mutation not supported, review schema definition.",
			"locations" : [
				{
					"line" : 8,
					"column" : 10
				}
			]
		}
	]
}'
]
