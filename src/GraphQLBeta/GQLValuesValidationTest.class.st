"
https://facebook.github.io/graphql/draft/#sec-Values
"
Class {
	#name : #GQLValuesValidationTest,
	#superclass : #GQLTestValidation,
	#category : #'GraphQLBeta-Tests-Validation'
}

{ #category : #tests }
GQLValuesValidationTest >> testInputObjectFieldNames01 [
	"Every input field provided in an input object value must be defined in the set of possible fields of that input object’s expected type."
	| result |
	"This document is the valid"
	result := self 
		jsonRequest: '
{
	findDog(complex: { name: "Fido" })
	{ 
		barkVolume
	}
}'.
	self assert: result equals: '{
	"data" : {
		"findDog" : {
			"barkVolume" : 10
		}
	}
}'
]

{ #category : #tests }
GQLValuesValidationTest >> testInputObjectFieldNames02 [
	"Every input field provided in an input object value must be defined in the set of possible fields of that input object’s expected type."
	| result |
	"This document is the invalid"
	result := self 
		jsonRequest: '
{
	findDog(complex: { favoriteCookieFlavor: "Bacon" })
	{ 
		barkVolume
	}
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Field \"favoriteCookieFlavor\" is not defined by type GQLDogInput",
			"locations" : [
				{
					"line" : 3,
					"column" : 21
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLValuesValidationTest >> testInputObjectFieldNames03 [
	"Every input field provided in an input object value must be defined in the set of possible fields of that input object’s expected type."
	| result |
	"This document is the valid"
	result := self 
		jsonRequest: '
{
	findDogNotNull(complex: { name: "Fido"})
	{ 
		name,
		barkVolume
	}
}'.
	self assert: result equals: '{
	"data" : {
		"findDogNotNull" : {
			"name": "Fido",
			"barkVolume" : null
		}
	}
}'
]

{ #category : #tests }
GQLValuesValidationTest >> testInputObjectFieldUniqueness [
	"Input objects must not contain more than one field of the same name, otherwise an ambiguity would exist which includes an ignored portion of syntax."
	| result |
	"This document is the invalid"
	self flag: 'update this to work on all input objects of the document. Ej
	{
	args(arg: {fo: 123, fo:123}) #this has an error that we can detect
	}'.
	result := self 
		jsonRequest: '
{
	findDog(complex: { name: "fido", name: "lobo" }){
		barkVolume
	}
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "There can be only one input field named \"name\".",
			"locations" : [
				{
					"line" : 3,
					"column" : 21
				},
				{
					"line" : 3,
					"column" : 35
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLValuesValidationTest >> testInputObjectRequiredFields [
	"Input object fields may be required. Much like a field may have required arguments, an input object may have required fields. An input field is required if it has a non‐null type and does not have a default value. Otherwise, the input object field is optional."
	self flag: 'TODO, since we do not support default values in input definition'
]

{ #category : #tests }
GQLValuesValidationTest >> testValuesOfCorrectType01 [
	"Literal values must be compatible with the type expected in the position they are found as per the coercion rules defined in the Type System chapter.

The type expected in a position include the type defined by the argument a value is provided for, the type defined by an input object field a value is provided for, and the type of a variable definition a default value is provided for."
	| result |
	"This document is the valid"
	self flag: 'Future work, try to execute this wihtout variables, only with the default value'.
	result := self 
		operation: 'goodComplexDefaultValue'
		variables: '{"search" : { name: "Fido" }}'
		jsonRequest: '
fragment goodBooleanArg on GQLArguments {
  booleanArgField(booleanArg: true)
}

fragment coercedIntIntoFloatArg on GQLArguments {
  # Note: The input coercion rules for Float allow Int literals.
  floatArgField(floatArg: 123)
}
query foo{
	arguments{
		...coercedIntIntoFloatArg
		...goodBooleanArg
	}
}
query goodComplexDefaultValue($search: GQLDogInput = { name: "Fido" }) {
	findDog(complex: $search){
		owner { name }
	}
}'.
	self assert: result equals: '{
	"data" : {
		"findDog" : {
			"owner" : {
				"name" : "Akevalion"
			}
		}
	}
}'
]

{ #category : #tests }
GQLValuesValidationTest >> testValuesOfCorrectType02 [
	"Literal values must be compatible with the type expected in the position they are found as per the coercion rules defined in the Type System chapter.

The type expected in a position include the type defined by the argument a value is provided for, the type defined by an input object field a value is provided for, and the type of a variable definition a default value is provided for."
	| result |
	"This document is the invalid"
	result := self 
		operation: 'badComplexValue'
		variables: ''
		jsonRequest: '
fragment stringIntoInt on GQLArguments {
  intArgField(intArg: "123")
}
query foo{
	arguments{
		...stringIntoInt
	}
}
query badComplexValue {
	findDog(complex: { name: 123 }){barkVolume}
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Argument \"intArg\" has invalid value \"123\". Expected type \"Int\".",
			"locations" : [
				{
					"line" : 3,
					"column" : 23
				}
			]
		},
		{
			"message" : "Expected type String, found 123.",
			"locations" : [
				{
					"line" : 11,
					"column" : 21
				}
			]
		}
	]
}'
]
