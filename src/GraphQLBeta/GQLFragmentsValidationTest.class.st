"
https://facebook.github.io/graphql/draft/#sec-Validation.Fragments
"
Class {
	#name : #GQLFragmentsValidationTest,
	#superclass : #GQLTestValidation,
	#category : #'GraphQLBeta-Tests-Validation'
}

{ #category : #tests }
GQLFragmentsValidationTest >> testAbstractSpreadsInAbstractScope01 [
	"Fragments are declared on a type and will only apply when the runtime object type matches the type condition. They also are spread within the context of a parent type. A fragment spread is only valid if its type condition could ever apply within the parent type.
	
	Union or interfaces fragments can be used within each other. As long as there exists at least one object type that exists in the intersection of the possible types of the scope and the spread, the spread is considered valid."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	dog { 
		...unionWithInterface
		...dogOrHumanFragment
	}
}
fragment unionWithInterface on GQLPet {
  ...dogOrHumanFragment
}

fragment dogOrHumanFragment on DogOrHuman {
  ... on GQLDog {
    barkVolume
  }
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"barkVolume" : 10
		}
	}
}'
]

{ #category : #tests }
GQLFragmentsValidationTest >> testAbstractSpreadsInAbstractScope02 [
	"Fragments are declared on a type and will only apply when the runtime object type matches the type condition. They also are spread within the context of a parent type. A fragment spread is only valid if its type condition could ever apply within the parent type.
	
	Union or interfaces fragments can be used within each other. As long as there exists at least one object type that exists in the intersection of the possible types of the scope and the spread, the spread is considered valid."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	dog { 
		...nonIntersectingInterfaces
	}
}
fragment nonIntersectingInterfaces on GQLPet {
  ...sentientFragment
}

fragment sentientFragment on GQLSentient {
  name
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Fragment \"sentientFragment\" cannot be spread here as objects of type \"GQLSentient\" can never be of type \"GQLPet\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 6
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFragmentsValidationTest >> testAbstractSpreadsInObjectScope01 [
	"Fragments are declared on a type and will only apply when the runtime object type matches the type condition. They also are spread within the context of a parent type. A fragment spread is only valid if its type condition could ever apply within the parent type.
	
	In scope of an object type, unions or interface spreads can be used if the object type implements the interface or is a member of the union."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	dog { 
		...interfaceWithinObjectFragment
	}
}
fragment petNameFragment on GQLPet {
	name
}

fragment interfaceWithinObjectFragment on GQLDog {
	...petNameFragment
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
GQLFragmentsValidationTest >> testAbstractSpreadsInObjectScope02 [
	"Fragments are declared on a type and will only apply when the runtime object type matches the type condition. They also are spread within the context of a parent type. A fragment spread is only valid if its type condition could ever apply within the parent type.
	
	In scope of an object type, unions or interface spreads can be used if the object type implements the interface or is a member of the union."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	dog { 
		...unionWithObjectFragment
	}
}
fragment catOrDogNameFragment on CatOrDog {
	... on GQLCat {
		meowVolume
	}
}

fragment unionWithObjectFragment on GQLDog {
	...catOrDogNameFragment
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : { }
	}
}'
]

{ #category : #tests }
GQLFragmentsValidationTest >> testFragmentNameUniquess01 [
	"Fragment definitions are referenced in fragment spreads by name. To avoid ambiguity, each fragment’s name must be unique within a document.

Inline fragments are not considered fragment definitions, and are unaffected by this validation rule."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
  dog {
    ...fragmentOne
    ...fragmentTwo
  }
}

fragment fragmentOne on GQLDog {
  name
}

fragment fragmentTwo on GQLDog {
  owner {
    name
  }
}
'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"name" : "lobo",
			"owner" : {
				"name" : "Akevalion"
			}
		}
	}
}'.
]

{ #category : #tests }
GQLFragmentsValidationTest >> testFragmentNameUniquess02 [
	"Fragment definitions are referenced in fragment spreads by name. To avoid ambiguity, each fragment’s name must be unique within a document.

Inline fragments are not considered fragment definitions, and are unaffected by this validation rule."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	dog {
		...fragmentOne
	}
}

fragment fragmentOne on GQLDog {
	name
}

fragment fragmentOne on GQLDog {
	owner {
		name
	}
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "There can be only one fragment named \"fragmentOne\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 10
				},
				{
					"line" : 12,
					"column" : 10
				}
			]
		}
	]
}'.
]

{ #category : #tests }
GQLFragmentsValidationTest >> testFragmentSpreadTargetDefined [
	"Named fragment spreads must refer to fragments defined within the document. It is a validation error if the target of a spread is not defined."
	| result |
	"This document is invalid"
	result := self jsonRequest: '{
	dog {
		...undefinedFragment
	}
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Unknown fragment \"undefinedFragment\".",
			"locations" : [
				{
					"line" : 3,
					"column" : 6
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFragmentsValidationTest >> testFragmentSpreadTypeExistence01 [
	"Fragments must be specified on types that exist in the schema. This applies for both named and inline fragments. If they are not defined in the schema, the query does not validate."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	dog { 
		...correctType
		...inlineFragment
		...inlineFragment2
	}
}
fragment correctType on GQLDog {
	name
}

fragment inlineFragment on GQLDog {
	... on GQLDog {
		name
	}
}

fragment inlineFragment2 on GQLDog {
	... @include(if: true) {
		name
	}
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"name" : "lobo"
		}
	}
}'.
]

{ #category : #tests }
GQLFragmentsValidationTest >> testFragmentSpreadTypeExistence02 [
	"Fragments must be specified on types that exist in the schema. This applies for both named and inline fragments. If they are not defined in the schema, the query does not validate."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	dog { 
		...notOnExistingType
		...inlineNotExistingType
	}
}
fragment notOnExistingType on NotInSchema {
	name
}

fragment inlineNotExistingType on GQLDog {
	... on NotInSchema {
		name
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Unkwown type \"NotInSchema\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 31
				},
				{
					"line" : 13,
					"column" : 9
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFragmentsValidationTest >> testFragmentSpreadsMustNotFormCycles01 [
	"The graph of fragment spreads must not form any cycles including spreading itself. Otherwise an operation could infinitely spread or infinitely execute on cycles in the underlying data."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	dog {
		...nameFragment
	}
}

fragment nameFragment on GQLDog {
	name
	...barkVolumeFragment
}

fragment barkVolumeFragment on GQLDog {
	barkVolume
	...nameFragment
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Cannot spread fragment \"nameFragment\" with itself via barkVolumeFragment",
			"locations" : [
				{
					"line" : 10,
					"column" : 5
				}
			]
		},
		{
			"message" : "Cannot spread fragment \"barkVolumeFragment\" with itself via nameFragment",
			"locations" : [
				{
					"line" : 15,
					"column" : 5
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFragmentsValidationTest >> testFragmentSpreadsMustNotFormCycles02 [
	"The graph of fragment spreads must not form any cycles including spreading itself. Otherwise an operation could infinitely spread or infinitely execute on cycles in the underlying data."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	dog {
		...dogFragment
	}
}

fragment dogFragment on GQLDog {
	name
	owner {
		...ownerFragment
	}
}

fragment ownerFragment on GQLDog {
	name
	pets {
		...dogFragment
	}
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Cannot spread fragment \"dogFragment\" with itself via ownerFragment",
			"locations" : [
				{
					"line" : 11,
					"column" : 6
				}
			]
		},
		{
			"message" : "Fragment \"ownerFragment\" cannot be spread here as objects of type \"GQLDog\" can never be of type \"GQLHuman\".",
			"locations" : [
				{
					"line" : 11,
					"column" : 6
				}
			]
		},
		{
			"message" : "Cannot query field \"pets\" on type \"GQLDog\"",
			"locations" : [
				{
					"line" : 17,
					"column" : 2
				}
			]
		},
		{
			"message" : "Cannot spread fragment \"ownerFragment\" with itself via dogFragment",
			"locations" : [
				{
					"line" : 18,
					"column" : 6
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFragmentsValidationTest >> testFragmentsMustBeUsed [
	"efined fragments must be used within a document."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
fragment nameFragment on GQLDog { # unused
	name
}
{
	dog {
		name
	}
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Fragment \"nameFragment\" is never used.",
			"locations" : [
				{
					"line" : 2,
					"column" : 10
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFragmentsValidationTest >> testFragmentsOnCompositeTypes01 [
	"Fragments can only be declared on unions, interfaces, and objects. They are invalid on scalars. They can only be applied on non‐leaf fields. This rule applies to both inline and named fragments."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	dog { 
		...fragOnObject
		...fragOnInterface
		...fragOnUnion
	}
}
fragment fragOnObject on GQLDog {
	name
}

fragment fragOnInterface on GQLPet {
	name
}

fragment fragOnUnion on CatOrDog {
	... on GQLDog {
		name
	}
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
GQLFragmentsValidationTest >> testFragmentsOnCompositeTypes02 [
	"Fragments can only be declared on unions, interfaces, and objects. They are invalid on scalars. They can only be applied on non‐leaf fields. This rule applies to both inline and named fragments."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	dog { 
		...fragOnScalar
		...inlineFragOnScalar
	}
}
fragment fragOnScalar on Int {
	something
}

fragment inlineFragOnScalar on GQLDog {
	... on Boolean {
		somethingElse
	}
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Fragment \"fragOnScalar\" cannot condition on non composite type \"Int\"",
			"locations" : [
				{
					"line" : 8,
					"column" : 26
				}
			]
		},
		{
			"message" : "Fragment cannot condition on non composite type \"Boolean\"",
			"locations" : [
				{
					"line" : 13,
					"column" : 9
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFragmentsValidationTest >> testObjectSpreadsInAbstractScope01 [
	"Fragments are declared on a type and will only apply when the runtime object type matches the type condition. They also are spread within the context of a parent type. A fragment spread is only valid if its type condition could ever apply within the parent type.
	
	Union or interface spreads can be used within the context of an object type fragment, but only if the object type is one of the possible types of that interface or union."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	dog { 
		...petFragment
		...catOrDogFragment
	}
}
fragment petFragment on GQLPet {
	name
	... on GQLDog {
		barkVolume
	}
}

fragment catOrDogFragment on CatOrDog {
	... on GQLCat {
		meowVolume
	}
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"name" : "lobo",
			"barkVolume" : 10
		}
	}
}'
]

{ #category : #tests }
GQLFragmentsValidationTest >> testObjectSpreadsInAbstractScope02 [
	"Fragments are declared on a type and will only apply when the runtime object type matches the type condition. They also are spread within the context of a parent type. A fragment spread is only valid if its type condition could ever apply within the parent type.
	
	Union or interface spreads can be used within the context of an object type fragment, but only if the object type is one of the possible types of that interface or union."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	dog { 
		...sentientFragment
		...humanOrAlienFragment
	}
}
fragment sentientFragment on GQLSentient {
	... on GQLDog {
		barkVolume
	}
}

fragment humanOrAlienFragment on HumanOrAlien {
	... on GQLCat {
		meowVolume
	}
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Fragment \"sentientFragment\" cannot be spread here as objects of type \"GQLSentient\" can never be of type \"GQLDog\".",
			"locations" : [
				{
					"line" : 4,
					"column" : 6
				}
			]
		},
		{
			"message" : "Fragment \"humanOrAlienFragment\" cannot be spread here as objects of type \"HumanOrAlien\" can never be of type \"GQLDog\".",
			"locations" : [
				{
					"line" : 5,
					"column" : 6
				}
			]
		},
		{
			"message" : "Fragment cannot be spread here as objects of type \"GQLSentient\" can never be of type \"GQLDog\".",
			"locations" : [
				{
					"line" : 9,
					"column" : 2
				}
			]
		},
		{
			"message" : "Fragment cannot be spread here as objects of type \"HumanOrAlien\" can never be of type \"GQLCat\".",
			"locations" : [
				{
					"line" : 15,
					"column" : 2
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLFragmentsValidationTest >> testObjectSpreadsInObjectScope01 [
	"Fragments are declared on a type and will only apply when the runtime object type matches the type condition. They also are spread within the context of a parent type. A fragment spread is only valid if its type condition could ever apply within the parent type.
	
	In the scope of an object type, the only valid object type fragment spread is one that applies to the same type that is in scope."
	| result |
	"This document is valid"
	result := self jsonRequest: '
{
	dog { 
		...dogFragment
	}
}
fragment dogFragment on GQLDog {
 	... on GQLDog {
		barkVolume
	}
}'.
	self assert: result equals: '{
	"data" : {
		"dog" : {
			"barkVolume" : 10
		}
	}
}'
]

{ #category : #tests }
GQLFragmentsValidationTest >> testObjectSpreadsInObjectScope02 [
	"Fragments are declared on a type and will only apply when the runtime object type matches the type condition. They also are spread within the context of a parent type. A fragment spread is only valid if its type condition could ever apply within the parent type.
	
	In the scope of an object type, the only valid object type fragment spread is one that applies to the same type that is in scope."
	| result |
	"This document is invalid"
	result := self jsonRequest: '
{
	dog { 
		...catInDogFragmentInvalid
	}
}
fragment catInDogFragmentInvalid on GQLDog {
  ... on GQLCat {
    meowVolume
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Fragment cannot be spread here as objects of type \"GQLDog\" can never be of type \"GQLCat\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 3
				}
			]
		}
	]
}'
]
