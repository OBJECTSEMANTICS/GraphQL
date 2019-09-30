"
https://facebook.github.io/graphql/draft/#sec-Validation.Variables
"
Class {
	#name : #GQLVariablesValidationTest,
	#superclass : #GQLTestValidation,
	#category : #'GraphQLBeta-Tests-Validation'
}

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsagesAreAllowed01 [
	"Variable usages must be compatible with the arguments they are passed to.

Validation failures occur when variables are used in the context of types that are complete mismatches, or if a nullable type in a variable is passed to a non‐null argument type."
	| result |
	result := self 
		operation: 'intCannotGoIntoBoolean'
		variables: '{"intArg": 1}'
		jsonRequest: '
query intCannotGoIntoBoolean($intArg: Int) {
  arguments {
    booleanArgField(booleanArg: $intArg)
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"intArg\" of type \"Int\" used in position expecting type \"Boolean\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 30
				},
				{
					"line" : 4,
					"column" : 33
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsagesAreAllowed02 [
	"Variable usages must be compatible with the arguments they are passed to.

Validation failures occur when variables are used in the context of types that are complete mismatches, or if a nullable type in a variable is passed to a non‐null argument type."
	| result |
	result := self 
		operation: 'booleanListCannotGoIntoBoolean'
		variables: '{"booleanListArg": []}'
		jsonRequest: '
query booleanListCannotGoIntoBoolean($booleanListArg: [Boolean]) {
  arguments {
    booleanArgField(booleanArg: $booleanListArg)
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"booleanListArg\" of type \"[Boolean]\" used in position expecting type \"Boolean\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 38
				},
				{
					"line" : 4,
					"column" : 33
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsagesAreAllowed03 [
	"Variable usages must be compatible with the arguments they are passed to.

Validation failures occur when variables are used in the context of types that are complete mismatches, or if a nullable type in a variable is passed to a non‐null argument type."
	| result |
	result := self 
		operation: 'booleanArgQuery'
		variables: '{"booleanArg": []}'
		jsonRequest: '
query booleanArgQuery($booleanArg: Boolean) {
  arguments {
    nonNullBooleanArgField(nonNullBooleanArg: $booleanArg)
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"$booleanArg\" got invalid value []. Expected type \"Boolean\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 23
				}
			]
		},
		{
			"message" : "Variable \"booleanArg\" of type \"Boolean\" used in position expecting type \"Boolean!\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 23
				},
				{
					"line" : 4,
					"column" : 47
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsagesAreAllowed04 [
	"Variable usages must be compatible with the arguments they are passed to.

Validation failures occur when variables are used in the context of types that are complete mismatches, or if a nullable type in a variable is passed to a non‐null argument type."
	| result |
	result := self 
		operation: 'nonNullListToList'
		variables: '{"nonNullBooleanList": [true]}'
		jsonRequest: '
query nonNullListToList($nonNullBooleanList: [Boolean]!) {
  arguments {
    booleanListArgField(booleanListArg: $nonNullBooleanList)
  }
}'.
	self assert: result equals: '{
	"data" : {
		"arguments" : {
			"booleanListArgField" : [
				true
			]
		}
	}
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsagesAreAllowed05 [
	"Variable usages must be compatible with the arguments they are passed to.

Validation failures occur when variables are used in the context of types that are complete mismatches, or if a nullable type in a variable is passed to a non‐null argument type."
	| result |
	result := self 
		operation: 'listToNonNullList'
		variables: '{"booleanList": [true]}'
		jsonRequest: '
query listToNonNullList($booleanList: [Boolean]) {
  arguments {
    nonNullBooleanListField(nonNullBooleanListArg: $booleanList)
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"booleanList\" of type \"[Boolean]\" used in position expecting type \"[Boolean]!\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 25
				},
				{
					"line" : 4,
					"column" : 52
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsagesAreAllowed06 [
	"Variable usages must be compatible with the arguments they are passed to.

Validation failures occur when variables are used in the context of types that are complete mismatches, or if a nullable type in a variable is passed to a non‐null argument type."
	| result |
	result := self 
		operation: 'booleanArgQueryWithDefault'
		variables: '{"booleanArg": [true]}'
		jsonRequest: '
query booleanArgQueryWithDefault($booleanArg: Boolean) {
  arguments {
    optionalNonNullBooleanArgField(optionalBooleanArg: $booleanArg)
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"$booleanArg\" got invalid value [true]. Expected type \"Boolean\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 34
				}
			]
		},
		{
			"message" : "Variable \"booleanArg\" of type \"Boolean\" used in position expecting type \"Boolean!\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 34
				},
				{
					"line" : 4,
					"column" : 56
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsagesAreAllowed07 [
	"Variable usages must be compatible with the arguments they are passed to.

Validation failures occur when variables are used in the context of types that are complete mismatches, or if a nullable type in a variable is passed to a non‐null argument type."
	| result |
	self flag: 'TODO, schema needs to use default values in order to compleate this rule'.
	"Allowing optional variables when default values exist

A notable exception to typical variable type compatibility is allowing a variable definition with a nullable type to be provided to a non‐null location as long as either that variable or that location provides a default value."
	true ifTrue: [ ^ self ].
	result := self 
		operation: 'booleanArgQueryWithDefault'
		variables: '{"booleanArg": [true]}'
		jsonRequest: '
query booleanArgQueryWithDefault($booleanArg: Boolean = true) {
  arguments {
    nonNullBooleanArgField(nonNullBooleanArg: $booleanArg)
  }
}'.
	self assert: result equals: ''
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsagesAreAllowed08 [
	"Variable usages must be compatible with the arguments they are passed to.

Validation failures occur when variables are used in the context of types that are complete mismatches, or if a nullable type in a variable is passed to a non‐null argument type."
	| result |
	"Allowing optional variables when default values exist

A notable exception to typical variable type compatibility is allowing a variable definition with a nullable type to be provided to a non‐null location as long as either that variable or that location provides a default value."
	result := self 
		operation: 'intArgQuery'
		jsonRequest: '
query intArgQuery($x: Int = 2.3) {
  arguments {
    intArgField(intArg: $x)
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Expected type Int, found 2.3.",
			"locations" : [
				{
					"line" : 2,
					"column" : 29
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsesDefined01 [
	"Variables are scoped on a per‐operation basis. That means that any variable used within the context of an operation must be defined at the top level of that operation"
	| result |
	result := self 
		operation: 'variableIsDefined'
		variables: '{"atOtherHomes": true}'
		jsonRequest: '
query variableIsDefined($atOtherHomes: Boolean) {
  dog {
    isHousetrained(atOtherHomes: $atOtherHomes)
  }
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"isHousetrained" : false
		}
	}
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsesDefined02 [
	"Variables are scoped on a per‐operation basis. That means that any variable used within the context of an operation must be defined at the top level of that operation"
	| result |
	result := self 
		operation: 'variableIsNotDefined'
		jsonRequest: '
query variableIsNotDefined {
  dog {
    isHousetrained(atOtherHomes: $atOtherHomes)
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"atOtherHomes\" is not defined by operation \"variableIsNotDefined\".",
			"locations" : [
				{
					"line" : 4,
					"column" : 34
				},
				{
					"line" : 2,
					"column" : 7
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsesDefined03 [
	"Variables are scoped on a per‐operation basis. That means that any variable used within the context of an operation must be defined at the top level of that operation"
	| result |
	result := self 
		jsonRequest: '
{
  dog {
    isHousetrained(atOtherHomes: $atOtherHomes)
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"atOtherHomes\" is not defined.",
			"locations" : [
				{
					"line" : 4,
					"column" : 34
				},
				{
					"line" : 2,
					"column" : 1
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsesDefined04 [
	"Variables are scoped on a per‐operation basis. That means that any variable used within the context of an operation must be defined at the top level of that operation"
	| result |
	result := self 
		operation: 'variableIsDefinedUsedInSingleFragment'
		variables: '{"atOtherHomes": true}'
		jsonRequest: '
query variableIsDefinedUsedInSingleFragment($atOtherHomes: Boolean) {
  dog {
    ...isHousetrainedFragment
  }
}

fragment isHousetrainedFragment on GQLDog {
  isHousetrained(atOtherHomes: $atOtherHomes)
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"isHousetrained" : false
		}
	}
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsesDefined05 [
	"Variables are scoped on a per‐operation basis. That means that any variable used within the context of an operation must be defined at the top level of that operation"
	| result |
	result := self 
		operation: 'variableIsNotDefinedUsedInSingleFragment'
		jsonRequest: '
query variableIsNotDefinedUsedInSingleFragment {
  dog {
    ...isHousetrainedFragment
  }
}

fragment isHousetrainedFragment on GQLDog {
  isHousetrained(atOtherHomes: $atOtherHomes)
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"atOtherHomes\" is not defined by operation \"variableIsNotDefinedUsedInSingleFragment\".",
			"locations" : [
				{
					"line" : 9,
					"column" : 32
				},
				{
					"line" : 2,
					"column" : 7
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsesDefined06 [
	"Variables are scoped on a per‐operation basis. That means that any variable used within the context of an operation must be defined at the top level of that operation"
	| result |
	result := self 
		operation: 'variableIsNotDefinedUsedInNestedFragment'
		jsonRequest: '
query variableIsNotDefinedUsedInNestedFragment {
  dog {
    ...outerHousetrainedFragment
  }
}

fragment outerHousetrainedFragment on GQLDog {
  ...isHousetrainedFragment
}

fragment isHousetrainedFragment on GQLDog {
  isHousetrained(atOtherHomes: $atOtherHomes)
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"atOtherHomes\" is not defined by operation \"variableIsNotDefinedUsedInNestedFragment\".",
			"locations" : [
				{
					"line" : 13,
					"column" : 32
				},
				{
					"line" : 2,
					"column" : 7
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsesDefined07 [
	"Variables are scoped on a per‐operation basis. That means that any variable used within the context of an operation must be defined at the top level of that operation"
	| result |
	result := self 
		operation: 'housetrainedQueryOne'
		variables: '{"atOtherHomes": true}'
		jsonRequest: '
query housetrainedQueryOne($atOtherHomes: Boolean) {
  dog {
    ...isHousetrainedFragment
  }
}

query housetrainedQueryTwo($atOtherHomes: Boolean) {
  dog {
    ...isHousetrainedFragment
  }
}

fragment isHousetrainedFragment on GQLDog {
  isHousetrained(atOtherHomes: $atOtherHomes)
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"isHousetrained" : false
		}
	}
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariableUsesDefined08 [
	"Variables are scoped on a per‐operation basis. That means that any variable used within the context of an operation must be defined at the top level of that operation"
	| result |
	result := self 
		operation: 'housetrainedQueryOne'
		variables: '{"atOtherHomes": true}'
		jsonRequest: '
query housetrainedQueryOne($atOtherHomes: Boolean) {
  dog {
    ...isHousetrainedFragment
  }
}

query housetrainedQueryTwoNotDefined {
  dog {
    ...isHousetrainedFragment
  }
}

fragment isHousetrainedFragment on GQLDog {
  isHousetrained(atOtherHomes: $atOtherHomes)
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"atOtherHomes\" is not defined by operation \"housetrainedQueryTwoNotDefined\".",
			"locations" : [
				{
					"line" : 15,
					"column" : 32
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
GQLVariablesValidationTest >> testAllVariablesUsed01 [
	"All variables defined by an operation must be used in that operation or a fragment transitively included by that operation. Unused variables cause a validation error."
	| result |
	result := self 
		operation: 'variableUnused'
		variables: '{"atOtherHomes": true}'
		jsonRequest: '
query variableUnused($atOtherHomes: Boolean) {
  dog {
    isHousetrained
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"$atOtherHomes\" is never used in operation \"variableUnused\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 22
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariablesUsed02 [
	"All variables defined by an operation must be used in that operation or a fragment transitively included by that operation. Unused variables cause a validation error."
	| result |
	result := self 
		operation: 'variableUsedInFragment'
		variables: '{"atOtherHomes": true}'
		jsonRequest: '
query variableUsedInFragment($atOtherHomes: Boolean) {
  dog {
    ...isHousetrainedFragment
  }
}

fragment isHousetrainedFragment on GQLDog {
  isHousetrained(atOtherHomes: $atOtherHomes)
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"isHousetrained" : false
		}
	}
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariablesUsed03 [
	"All variables defined by an operation must be used in that operation or a fragment transitively included by that operation. Unused variables cause a validation error."
	| result |
	result := self 
		operation: 'variableNotUsedWithinFragment'
		variables: '{"atOtherHomes": true}'
		jsonRequest: '
query variableNotUsedWithinFragment($atOtherHomes: Boolean) {
  dog {
    ...isHousetrainedWithoutVariableFragment
  }
}

fragment isHousetrainedWithoutVariableFragment on GQLDog {
  isHousetrained
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"$atOtherHomes\" is never used in operation \"variableNotUsedWithinFragment\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 37
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariablesUsed04 [
	"All variables defined by an operation must be used in that operation or a fragment transitively included by that operation. Unused variables cause a validation error."
	| result |
	result := self 
		operation: 'queryWithUsedVar'
		variables: '{"atOtherHomes": true, "extra": 10}'
		jsonRequest: '
query queryWithUsedVar($atOtherHomes: Boolean) {
  dog {
    ...isHousetrainedFragment
  }
}

query queryWithExtraVar($atOtherHomes: Boolean, $extra: Int) {
  dog {
    ...isHousetrainedFragment
  }
}

fragment isHousetrainedFragment on GQLDog {
  isHousetrained(atOtherHomes: $atOtherHomes)
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"$extra\" is never used in operation \"queryWithExtraVar\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 49
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testAllVariablesUsed05 [
	"All variables defined by an operation must be used in that operation or a fragment transitively included by that operation. Unused variables cause a validation error."
	| result |
	result := self 
		operation: 'queryWithUsedVar'
		variables: '{"foo": true}'
		jsonRequest: '
query queryWithUsedVar($foo: Boolean!) {
  dog {
    ...isHousetrainedFragment @skip(if: $foo)
  }
}

fragment isHousetrainedFragment on GQLDog {
  isHousetrained 
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : { }
	}
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testVariableUniqueness01 [
	"If any operation defines more than one variable with the same name, it is ambiguous and invalid. It is invalid even if the type of the duplicate variable is the same."
	| result |
	result := self 
		operation: 'houseTrainedQuery'
		variables: '{"atOtherHomes": true}'
		jsonRequest: '
query houseTrainedQuery($atOtherHomes: Boolean, $atOtherHomes: Boolean) {
  dog {
    isHousetrained(atOtherHomes: $atOtherHomes)
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "There can be only one variable named \"atOtherHomes\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 25
				},
				{
					"line" : 2,
					"column" : 49
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testVariableUniqueness02 [
	"If any operation defines more than one variable with the same name, it is ambiguous and invalid. It is invalid even if the type of the duplicate variable is the same."
	| result |
	result := self 
		operation: 'A'
		variables: '{"atOtherHomes": true}'
		jsonRequest: '
query A($atOtherHomes: Boolean) {
  ...HouseTrainedFragment
}

query B($atOtherHomes: Boolean) {
  ...HouseTrainedFragment
}

fragment HouseTrainedFragment on GQLQueryRoot{
  dog {
    isHousetrained(atOtherHomes: $atOtherHomes)
  }
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"isHousetrained" : false
		}
	}
}'
	
]

{ #category : #tests }
GQLVariablesValidationTest >> testVariablesAreInputTypes01 [
	"Variables can only be input types. Objects, unions, and interfaces cannot be used as inputs."
	| result |
	result := self 
		operation: 'takesComplexInput'
		variables: '{"complexInput": {name: "lobo"}, "atOtherHomes": true, "booleans": [true] }'
		jsonRequest: '
query takesBoolean($atOtherHomes: Boolean) {
  dog {
    isHousetrained(atOtherHomes: $atOtherHomes)
  }
}

query takesComplexInput($complexInput: GQLDogInput) {
  findDog(complex: $complexInput) {
    name
  }
}

query TakesListOfBooleanBang($booleans: [Boolean!]) {
  booleanList(booleanListArg: $booleans)
}'.
	self assert: result equals: '{
	"data" : {
		"findDog" : {
			"name" : "lobo"
		}
	}
}'
]

{ #category : #tests }
GQLVariablesValidationTest >> testVariablesAreInputTypes02 [
	"Variables can only be input types. Objects, unions, and interfaces cannot be used as inputs."
	| result |
	result := self 
		operation: 'takesComplexInput'
		jsonRequest: '
query takesCat($cat: GQLCat) {
	dog { name }
}

query takesDogBang($dog: GQLDog!) {
	dog { name }
}

query takesListOfPet($pets: [GQLPet]) {
	dog { name }
}

query takesCatOrDog($catOrDog: CatOrDog) {
	dog { name }
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Variable \"$cat\" is never used in operation \"takesCat\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 16
				}
			]
		},
		{
			"message" : "Variable \"$cat\" cannot be non-input type \"GQLCat\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 16
				}
			]
		},
		{
			"message" : "Variable \"$dog\" is never used in operation \"takesDogBang\".",
			"locations" : [
				{
					"line" : 6,
					"column" : 20
				}
			]
		},
		{
			"message" : "Variable \"$dog\" of required type \"GQLDog!\" was not provided.",
			"locations" : [
				{
					"line" : 6,
					"column" : 20
				}
			]
		},
		{
			"message" : "Variable \"$dog\" cannot be non-input type \"GQLDog!\".",
			"locations" : [
				{
					"line" : 6,
					"column" : 20
				}
			]
		},
		{
			"message" : "Variable \"$pets\" is never used in operation \"takesListOfPet\".",
			"locations" : [
				{
					"line" : 10,
					"column" : 22
				}
			]
		},
		{
			"message" : "Variable \"$pets\" cannot be non-input type \"[GQLPet]\".",
			"locations" : [
				{
					"line" : 10,
					"column" : 22
				}
			]
		},
		{
			"message" : "Variable \"$catOrDog\" is never used in operation \"takesCatOrDog\".",
			"locations" : [
				{
					"line" : 14,
					"column" : 21
				}
			]
		},
		{
			"message" : "Variable \"$catOrDog\" cannot be non-input type \"CatOrDog\".",
			"locations" : [
				{
					"line" : 14,
					"column" : 21
				}
			]
		}
	]
}'
]
