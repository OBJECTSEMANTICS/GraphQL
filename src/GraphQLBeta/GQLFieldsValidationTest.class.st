"
https://facebook.github.io/graphql/draft/#sec-Validation.Fields
"
Class {
	#name : #GQLFieldsValidationTest,
	#superclass : #GQLTestValidation,
	#category : #'GraphQLBeta-Tests-Validation'
}

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsMergin01 [
	"
If multiple field selections with the same response names are encountered during execution, the field and arguments to execute and the resulting value should be unambiguous. Therefore any two field selections which might both be encountered for the same object are only valid if they are equivalent.

For simple hand‐written GraphQL, this rule is obviously a clear developer error, however nested fragments can make this difficult to detect manually."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{ 
	dog { 
		...mergeIdenticalFields
		...mergeIdenticalAliasesAndFields
	}
}
fragment mergeIdenticalFields on GQLDog {
  name
  name
}

fragment mergeIdenticalAliasesAndFields on GQLDog {
  otherName: name
  otherName: name
}
'.
	self assertJSONEquals: result and: '{
	"data": { 
		"dog" : {
			"name" : "lobo",
			"otherName" : "lobo"
		}
	}
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsMergin02 [
	"
If multiple field selections with the same response names are encountered during execution, the field and arguments to execute and the resulting value should be unambiguous. Therefore any two field selections which might both be encountered for the same object are only valid if they are equivalent.

For simple hand‐written GraphQL, this rule is obviously a clear developer error, however nested fragments can make this difficult to detect manually."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{ 
	dog { 
		...conflictingBecauseAlias
	}
}
fragment conflictingBecauseAlias on GQLDog {
  name: nickname
  name
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Fields \"name\" conflict because \"nickname\" and \"name\" are different fields. Use different aliases on the fields to fetch both if this was intentional.",
			"locations" : [
				{
					"line" : 8,
					"column" : 9
				},
				{
					"line" : 9,
					"column" : 3
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsMergin03 [
	"
If multiple field selections with the same response names are encountered during execution, the field and arguments to execute and the resulting value should be unambiguous. Therefore any two field selections which might both be encountered for the same object are only valid if they are equivalent.

For simple hand‐written GraphQL, this rule is obviously a clear developer error, however nested fragments can make this difficult to detect manually."
	| result |
	"This document is valid"
	result := self 
		operation: 'foo' 
		variables: '{"dogCommand": SIT}' 
		jsonRequest: '
query foo{ 
	dog { 
		...mergeIdenticalFieldsWithIdenticalArgs
	}
}
query bar($dogCommand: DogCommand!){
	dog { 
		...mergeIdenticalFieldsWithIdenticalValues
	}
}
fragment mergeIdenticalFieldsWithIdenticalArgs on GQLDog {
  doesKnowCommand(dogCommand: SIT)
  doesKnowCommand(dogCommand: SIT)
}

fragment mergeIdenticalFieldsWithIdenticalValues on GQLDog {
  doesKnowCommand(dogCommand: $dogCommand)
  doesKnowCommand(dogCommand: $dogCommand)
}
'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"doesKnowCommand" : true
		}
	}
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsMergin04 [
	"
If multiple field selections with the same response names are encountered during execution, the field and arguments to execute and the resulting value should be unambiguous. Therefore any two field selections which might both be encountered for the same object are only valid if they are equivalent.

For simple hand‐written GraphQL, this rule is obviously a clear developer error, however nested fragments can make this difficult to detect manually."
	| result |
	"This document is invalid"
	result := self 
		operation: 'foo'
		variables: '{"dogCommand": HEEL, "varOne": SIT, "varTwo": SIT}'
		jsonRequest: '
query foo($dogCommand: DogCommand!, $varOne: DogCommand!, $varTwo: DogCommand!) { 
	dog { 
		...conflictingArgsOnValues
		...conflictingArgsValueAndVar
		...conflictingArgsWithVars
		...differingArgs
	}
}
fragment conflictingArgsOnValues on GQLDog {
  doesKnowCommand(dogCommand: SIT)
  doesKnowCommand(dogCommand: HEEL)
}

fragment conflictingArgsValueAndVar on GQLDog {
  doesKnowCommand(dogCommand: SIT)
  doesKnowCommand(dogCommand: $dogCommand)
}

fragment conflictingArgsWithVars on GQLDog {
  doesKnowCommand(dogCommand: $varOne)
  doesKnowCommand(dogCommand: $varTwo)
}

fragment differingArgs on GQLDog {
  doesKnowCommand(dogCommand: SIT)
  doesKnowCommand
}
'.
	self assert: result equals:'{
	"errors" : [
		{
			"message" : "Fields \"doesKnowCommand\" conflict because they have differing arguments. Use different aliases on the fields to fetch both if this was intentional.",
			"locations" : [
				{
					"line" : 11,
					"column" : 3
				},
				{
					"line" : 12,
					"column" : 3
				},
				{
					"line" : 16,
					"column" : 3
				},
				{
					"line" : 17,
					"column" : 3
				},
				{
					"line" : 21,
					"column" : 3
				},
				{
					"line" : 22,
					"column" : 3
				},
				{
					"line" : 26,
					"column" : 3
				},
				{
					"line" : 27,
					"column" : 3
				}
			]
		},
		{
			"message" : "Field \"doesKnowCommand\" argument \"dogCommand\" of type \"DogCommand!\" is required but not provided.",
			"locations" : [
				{
					"line" : 27,
					"column" : 3
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsMergin05 [
	"
If multiple field selections with the same response names are encountered during execution, the field and arguments to execute and the resulting value should be unambiguous. Therefore any two field selections which might both be encountered for the same object are only valid if they are equivalent.

For simple hand‐written GraphQL, this rule is obviously a clear developer error, however nested fragments can make this difficult to detect manually."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{ 
	dog { 
		...safeDifferingFields
		...safeDifferingArgs
	}
}
fragment safeDifferingFields on GQLPet {
  ... on GQLDog {
    volume: barkVolume
  }
  ... on GQLCat {
    volume: meowVolume
  }
}

fragment safeDifferingArgs on GQLPet {
  ... on GQLDog {
    doesKnowCommand(dogCommand: SIT)
  }
  ... on GQLCat {
    doesKnowCommand(catCommand: JUMP)
  }
}
'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"volume" : 10,
			"doesKnowCommand" : true
		}
	}
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsMergin06 [
	"
If multiple field selections with the same response names are encountered during execution, the field and arguments to execute and the resulting value should be unambiguous. Therefore any two field selections which might both be encountered for the same object are only valid if they are equivalent.

For simple hand‐written GraphQL, this rule is obviously a clear developer error, however nested fragments can make this difficult to detect manually."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{ 
	dog { 
		...conflictingDifferingResponses
	}
}
fragment conflictingDifferingResponses on GQLPet {
  ... on GQLDog {
    someValue: nickname
  }
  ... on GQLCat {
    someValue: meowVolume
  }
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Fields \"someValue\" conflict because \"nickname\" and \"meowVolume\" are different fields. Use different aliases on the fields to fetch both if this was intentional.",
			"locations" : [
				{
					"line" : 9,
					"column" : 16
				},
				{
					"line" : 12,
					"column" : 16
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsMergin07 [
	"
If multiple field selections with the same response names are encountered during execution, the field and arguments to execute and the resulting value should be unambiguous. Therefore any two field selections which might both be encountered for the same object are only valid if they are equivalent.

For simple hand‐written GraphQL, this rule is obviously a clear developer error, however nested fragments can make this difficult to detect manually."
	| result |
	"This document is invalid"
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
  multipleReqs(y: 1, x: 2)
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Fields \"multipleReqs\" conflict because they have differing arguments. Use different aliases on the fields to fetch both if this was intentional.",
			"locations" : [
				{
					"line" : 13,
					"column" : 3
				},
				{
					"line" : 9,
					"column" : 3
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsMergin08 [
	"
If multiple field selections with the same response names are encountered during execution, the field and arguments to execute and the resulting value should be unambiguous. Therefore any two field selections which might both be encountered for the same object are only valid if they are equivalent.

For simple hand‐written GraphQL, this rule is obviously a clear developer error, however nested fragments can make this difficult to detect manually."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	__type(name: "GQLSentient"){
		name
	}
	__type(name: "GQLPet"){
		name
	}
}'.
	self assertJSONEquals: result and: '{
  "errors": [
    {
      "message": "Fields \"__type\" conflict because they have differing arguments. Use different aliases on the fields to fetch both if this was intentional.",
      "locations": [
        {
          "line": 3,
          "column": 2
        },
        {
          "line": 6,
          "column": 2
        }
      ]
    }
  ]
}'.
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsMergin09 [
	"
If multiple field selections with the same response names are encountered during execution, the field and arguments to execute and the resulting value should be unambiguous. Therefore any two field selections which might both be encountered for the same object are only valid if they are equivalent.

For simple hand‐written GraphQL, this rule is obviously a clear developer error, however nested fragments can make this difficult to detect manually."
	| result |
	"This document is invalid"
	result := self jsonRequest: '{
	__type(name: "GQLDog"){
		name
	}
	...fragmentIntrospection
}
fragment fragmentIntrospection on GQLQueryRoot{
	__type(name: "GQLCat"){
		name
	}
}
'.
	self assert: result equals: '{
  "errors": [
    {
      "message": "Fields \"__type\" conflict because they have differing arguments. Use different aliases on the fields to fetch both if this was intentional.",
      "locations": [
        {
          "line": 2,
          "column": 2
        },
        {
          "line": 8,
          "column": 2
        }
      ]
    }
  ]
}'.
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsMergin10 [
	"
If multiple field selections with the same response names are encountered during execution, the field and arguments to execute and the resulting value should be unambiguous. Therefore any two field selections which might both be encountered for the same object are only valid if they are equivalent.

For simple hand‐written GraphQL, this rule is obviously a clear developer error, however nested fragments can make this difficult to detect manually."
	| result |
	"This document is invalid"
	result := self jsonRequest: '{
  		__type(name: "Point") {
    		name
    		fields {
      			name
      			type {
        			name
      			}
    		}
  		}
		__type(name: "GQLMutation"){
    		name
  		}
	}'.
	self assert: result equals: '{
  "errors": [
    {
      "message": "Fields \"__type\" conflict because they have differing arguments. Use different aliases on the fields to fetch both if this was intentional.",
      "locations": [
        {
          "line": 2,
          "column": 5
        },
        {
          "line": 11,
          "column": 3
        }
      ]
    }
  ]
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsOIU01 [
	"OIU = Object, Interfaces and Union Types
	* For each selection in the document.
	* Let fieldName be the target field of selection
	* fieldName must be defined on type in scope
	"
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{ 
	dog { 
		...fieldNotDefined
		...aliasedLyingFieldTargetNotDefined
	}
}
fragment fieldNotDefined on GQLDog {
  meowVolume
}

fragment aliasedLyingFieldTargetNotDefined on GQLDog {
  barkVolume: kawVolume
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Cannot query field \"meowVolume\" on type \"GQLDog\"",
			"locations" : [
				{
					"line" : 9,
					"column" : 3
				}
			]
		},
		{
			"message" : "Cannot query field \"kawVolume\" on type \"GQLDog\"",
			"locations" : [
				{
					"line" : 13,
					"column" : 15
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsOIU02 [
	"OIU = Object, Interfaces and Union Types
	* For each selection in the document.
	* Let fieldName be the target field of selection
	* fieldName must be defined on type in scope
	"
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	dog{
		name
		...interfaceFieldSelection
	} 
}
fragment interfaceFieldSelection on GQLPet {
  name
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"name" : "lobo"
		}
	}
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsOIU03 [
	"OIU = Object, Interfaces and Union Types
	* For each selection in the document.
	* Let fieldName be the target field of selection
	* fieldName must be defined on type in scope
	"
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	dog{
		name
		...definedOnImplementorsButNotInterface
	} 
}
fragment definedOnImplementorsButNotInterface on GQLPet {
  nickname
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Cannot query field \"nickname\" on type \"GQLPet\"",
			"locations" : [
				{
					"line" : 9,
					"column" : 3
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsOIU04 [
	"OIU = Object, Interfaces and Union Types
	* For each selection in the document.
	* Let fieldName be the target field of selection
	* fieldName must be defined on type in scope
	"
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	dog{
		...inDirectFieldSelectionOnUnion
	} 
}
fragment inDirectFieldSelectionOnUnion on CatOrDog {
	__typename
  ... on GQLPet {
    name
  }
  ... on GQLDog {
    barkVolume
  }
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"__typename" : "GQLDog",
			"name": "lobo",
			"barkVolume" : 10
		}
	}
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testFieldsSelectionsOIU05 [
	"OIU = Object, Interfaces and Union Types
	* For each selection in the document.
	* Let fieldName be the target field of selection
	* fieldName must be defined on type in scope
	"
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	dog{
		...directFieldSelectionOnUnion
	} 
}
fragment directFieldSelectionOnUnion on CatOrDog {
  name
  barkVolume
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Cannot query field \"name\" on type \"CatOrDog\"",
			"locations" : [
				{
					"line" : 8,
					"column" : 3
				}
			]
		},
		{
			"message" : "Cannot query field \"barkVolume\" on type \"CatOrDog\"",
			"locations" : [
				{
					"line" : 9,
					"column" : 3
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testLeafFieldSelections01 [
	"
	Field selections on scalars are never allowed: scalars are the leaf nodes of any GraphQL query"
	| result |
	"This document is valid"
	result := self jsonRequest: '
{ 
	dog { 
		...scalarSelection
	}
}
fragment scalarSelection on GQLDog {
  barkVolume
}
'.
	self assertJSONEquals: result and: '{
	"data" : { 
		"dog" : {
			"barkVolume" : 10
		}
	}
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testLeafFieldSelections02 [
	"
	Field selections on scalars are never allowed: scalars are the leaf nodes of any GraphQL query"
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{ 
	dog { 
		...scalarSelectionsNotAllowedOnBoolean
	}
}
fragment scalarSelectionsNotAllowedOnBoolean on GQLDog {
  barkVolume {
    sinceWhen
  }
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Field \"barkVolume\" must not have selection since type \"Int\" has no subfields.",
			"locations" : [
				{
					"line" : 8,
					"column" : 14
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testLeafFieldSelections03 [
	| result |
	"This is document is valid"
	result := self 
		operation: 'directQueryOnUnionWithoutSubFields'
		jsonRequest: '
query directQueryOnUnionWithoutSubFields {
  	catOrDog{
		__typename
		... on GQLCat {
			nickname
		}
	}
}
'.
	self assert: result equals: '{
	"data" : {
		"catOrDog" : {
			"__typename" : "GQLCat",
			"nickname" : "Gatencio"
		}
	}
}'
]

{ #category : #tests }
GQLFieldsValidationTest >> testLeafFieldSelections04 [
	"Conversely the leaf field selections of GraphQL queries must be scalars. Leaf selections on objects, interfaces, and unions without subfields are disallowed."
	| result |
	"This is document is invalid"
	result := self 
		operation: 'directQueryOnUnionWithoutSubFields'
		jsonRequest: '
query directQueryOnObjectWithoutSubFields {
  human
}

query directQueryOnInterfaceWithoutSubFields {
  pet
}

query directQueryOnUnionWithoutSubFields {
  catOrDog
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Field \"human\" on type \"GQLHuman\" must have selection of subfields. Did you mean \"human { ... }\"?",
			"locations" : [
				{
					"line" : 3,
					"column" : 3
				}
			]
		},
		{
			"message" : "Field \"pet\" on type \"GQLPet\" must have selection of subfields. Did you mean \"pet { ... }\"?",
			"locations" : [
				{
					"line" : 7,
					"column" : 3
				}
			]
		},
		{
			"message" : "Field \"catOrDog\" on type \"CatOrDog\" must have selection of subfields. Did you mean \"catOrDog { ... }\"?",
			"locations" : [
				{
					"line" : 11,
					"column" : 3
				}
			]
		}
	]
}'
]
