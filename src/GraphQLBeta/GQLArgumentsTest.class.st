"
https://facebook.github.io/graphql/draft/#sec-Validation.Arguments
"
Class {
	#name : #GQLArgumentsTest,
	#superclass : #GQLTestValidation,
	#category : #'GraphQLBeta-Tests-Validation'
}

{ #category : #tests }
GQLArgumentsTest >> testArgumentCompatibleValues01 [
	"Literal values must be compatible with the type defined by the argument they are being provided to, as per the coercion rules defined in the Type System"
	"This document is valid"
	| result | 
	result := self jsonRequest: '
{
	arguments { 
		... goodBooleanArg
		... coercedIntIntoFloatArg
	} 
}
fragment goodBooleanArg on GQLArguments {
  booleanArgField(booleanArg: true)
}

fragment coercedIntIntoFloatArg on GQLArguments {
  floatArgField(floatArg: 1)
}
'.
	self assertJSONEquals: result and: '{
	"data": { 
		"arguments" : {
			"booleanArgField" : false,
			"floatArgField" : 1
		}
	}
}'.
]

{ #category : #tests }
GQLArgumentsTest >> testArgumentCompatibleValues02 [
	"Literal values must be compatible with the type defined by the argument they are being provided to, as per the coercion rules defined in the Type System"
	"This document is invalid"
	| result |
	result := self jsonRequest: '
{
	arguments { 
		... stringIntoInt
	} 
}
fragment stringIntoInt on GQLArguments {
  intArgField(intArg: "3")
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Argument \"intArg\" has invalid value \"3\". Expected type \"Int\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 23
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLArgumentsTest >> testArgumentCompatibleValues03 [
	"Literal values must be compatible with the type defined by the argument they are being provided to, as per the coercion rules defined in the Type System"
	"This document is invalid"
	| result |
	result := self jsonRequest: '
{
	arguments { 
		... stringIntoBool
	} 
}
fragment stringIntoBool on GQLArguments {
  booleanArgField(booleanArg: "true")
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Argument \"booleanArg\" has invalid value \"true\". Expected type \"Boolean\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 31
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLArgumentsTest >> testArgumentCompatibleValues04 [
	"Literal values must be compatible with the type defined by the argument they are being provided to, as per the coercion rules defined in the Type System"
	"This document is invalid"
	| result |
	result := self jsonRequest: '
{
	arguments { 
		... numberIntoString
	} 
}
fragment numberIntoString on GQLArguments {
  singleString(string: 3.1416)
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Argument \"string\" has invalid value 3.1416. Expected type \"String\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 24
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLArgumentsTest >> testArgumentCompatibleValues05 [
	"Literal values must be compatible with the type defined by the argument they are being provided to, as per the coercion rules defined in the Type System"
	"This document is invalid"
	| result |
	result := self jsonRequest: '
{
	arguments { 
		... booleanToId
	} 
}
fragment booleanToId on GQLArguments {
  singleID(id: true)
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Argument \"id\" has invalid value true. Expected type \"ID\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 16
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLArgumentsTest >> testArgumentCompatibleValues06 [
	"Literal values must be compatible with the type defined by the argument they are being provided to, as per the coercion rules defined in the Type System"
	"This document is invalid"
	| result |
	result := self jsonRequest: '
{
	arguments { 
		... floatToId
	} 
}
fragment floatToId on GQLArguments {
  singleID(id: 3.1416)
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Argument \"id\" has invalid value 3.1416. Expected type \"ID\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 16
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLArgumentsTest >> testArgumentCompatibleValues07 [
	"Literal values must be compatible with the type defined by the argument they are being provided to, as per the coercion rules defined in the Type System"
	"This document is invalid"
	| result |
	result := self jsonRequest: '
{
	dog { 
		... nonExistingEnumValue
	} 
}
fragment nonExistingEnumValue on GQLDog {
	doesKnowCommand(dogCommand: RUN_FAST)
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Argument \"dogCommand\" has invalid value RUN_FAST. Expected type \"DogCommand!\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 30
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLArgumentsTest >> testArgumentNames01 [
	"Every argument provided to a field or directive must be defined in the set of possible arguments of that field or directive."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	dog { 
		...argOnRequiredArg
		...argOnOptional
	} 
}
fragment argOnRequiredArg on GQLDog {
	doesKnowCommand(dogCommand: SIT)
}

fragment argOnOptional on GQLDog {
	isHousetrained(atOtherHomes: true) @include(if: true)
}'.
	self assertJSONEquals: result and: '{
	"data": { 
		"dog" : {
			"doesKnowCommand" : true,
			"isHousetrained" : false
		}
	}
}'
]

{ #category : #tests }
GQLArgumentsTest >> testArgumentNames02 [
	"Every argument provided to a field or directive must be defined in the set of possible arguments of that field or directive."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	dog { 
		...invalidArgName
	} 
}
fragment invalidArgName on GQLDog {
	doesKnowCommand(command: CLEAN_UP_HOUSE)
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Field \"doesKnowCommand\" argument \"dogCommand\" of type \"DogCommand!\" is required but not provided.",
			"locations" : [
				{
					"line" : 8,
					"column" : 2
				}
			]
		},
		{
			"message" : "Unknown argument \"command\" on field \"doesKnowCommand\" on type \"GQLDog\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 18
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLArgumentsTest >> testArgumentNames03 [
	"Every argument provided to a field or directive must be defined in the set of possible arguments of that field or directive."
	"This document is invalid"
	| result |
	result := self jsonRequest: '
{
	dog { 
		...invalidArgName
	} 
}
fragment invalidArgName on GQLDog {
  isHousetrained(atOtherHomes: true) @include(unless: false)
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Directive \"@include\" argument \"if\" of type \"Boolean!\" is required but not provided.",
			"locations" : [
				{
					"line" : 8,
					"column" : 39
				}
			]
		},
		{
			"message" : "Unknown argument \"unless\" on directive \"@include\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 47
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLArgumentsTest >> testArgumentNames04 [
	"Every argument provided to a field or directive must be defined in the set of possible arguments of that field or directive."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	arguments { 
		...multipleArgsReverseOrder
		...multipleArgs
	} 
}
fragment multipleArgs on GQLArguments {
  multipleReqs(x: 1, y: 2)
}

fragment multipleArgsReverseOrder on GQLArguments {
  multipleReqs(y: 2, x: 1)
}'.
	self assert: result equals: '{
	"data" : {
		"arguments" : {
			"multipleReqs" : 3
		}
	}
}'
]

{ #category : #tests }
GQLArgumentsTest >> testArgumentUniqueness01 [
	"Fields and directives treat arguments as a mapping of argument name to value. More than one argument with the same name in an argument set is ambiguous and invalid."
	"This document is invalid"
	| result |
	result := self jsonRequest: '
{
	arguments { 
		multipleReqs(x: 1, x: 2)
	} 
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Field \"multipleReqs\" argument \"y\" of type \"Int!\" is required but not provided.",
			"locations" : [
				{
					"line" : 4,
					"column" : 3
				}
			]
		},
		{
			"message" : "There can be only one argument named \"x\".",
			"locations" : [
				{
					"line" : 4,
					"column" : 16
				},
				{
					"line" : 4,
					"column" : 22
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLArgumentsTest >> testArgumentUniqueness02 [
	"Fields and directives treat arguments as a mapping of argument name to value. More than one argument with the same name in an argument set is ambiguous and invalid."
	"This document is invalid"
	| result |
	result := self jsonRequest: '
{
	arguments { 
		multipleReqs(x: 1, y: 2) @include(if:true, if: false)
	} 
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "There can be only one argument named \"if\".",
			"locations" : [
				{
					"line" : 4,
					"column" : 37
				},
				{
					"line" : 4,
					"column" : 46
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLArgumentsTest >> testRequiredNonNullArguments01 [
	"Arguments can be required. Arguments are required if the type of the argument is non‐null. If it is not non‐null, the argument is optional. When an argument type is non‐null, and is required, the explicit value null may also not be provided."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	arguments { 
		... goodBooleanArg
		... goodNonNullArg
	} 
}
fragment goodBooleanArg on GQLArguments {
  booleanArgField(booleanArg: true)
}

fragment goodNonNullArg on GQLArguments {
  nonNullBooleanArgField(nonNullBooleanArg: true)
}
'.
	self assertJSONEquals: result and: '{
	"data": {
		"arguments" : {
			"booleanArgField" : false,
			"nonNullBooleanArgField" : false
		}
	}
}'
]

{ #category : #tests }
GQLArgumentsTest >> testRequiredNonNullArguments02 [
	"Arguments can be required. Arguments are required if the type of the argument is non‐null. If it is not non‐null, the argument is optional. When an argument type is non‐null, and is required, the explicit value null may also not be provided."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	arguments { 
		... goodBooleanArgDefault
	} 
}
fragment goodBooleanArgDefault on GQLArguments {
  booleanArgField
}
'.
	self assertJSONEquals: result and: '{
	"data" : { 
		"arguments" : {
			"booleanArgField" : true
		}
	}
}'
]

{ #category : #tests }
GQLArgumentsTest >> testRequiredNonNullArguments03 [
	"Arguments can be required. Arguments are required if the type of the argument is non‐null. If it is not non‐null, the argument is optional. When an argument type is non‐null, and is required, the explicit value null may also not be provided."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	arguments { 
		... missingRequiredArg
	} 
}
fragment missingRequiredArg on GQLArguments {
  nonNullBooleanArgField @include
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Field \"nonNullBooleanArgField\" argument \"nonNullBooleanArg\" of type \"Boolean!\" is required but not provided.",
			"locations" : [
				{
					"line" : 8,
					"column" : 3
				}
			]
		},
		{
			"message" : "Directive \"@include\" argument \"if\" of type \"Boolean!\" is required but not provided.",
			"locations" : [
				{
					"line" : 8,
					"column" : 27
				}
			]
		}
	]
}'
]
