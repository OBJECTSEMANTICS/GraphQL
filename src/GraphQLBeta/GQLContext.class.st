"
I represent a context on a request.

Public API and Key Messages

- fragments
- operationName
- variables

 
Internal Representation and Key Implementation Points.

    Instance Variables
	fragments:		<Dictionary>
	variables:		<Dictionary>

"
Class {
	#name : #GQLContext,
	#superclass : #GraphQLObject,
	#instVars : [
		'fragments',
		'variables',
		'operationName'
	],
	#category : #'GraphQLBeta-Core'
}

{ #category : #accessing }
GQLContext >> addFragments: aCollection [
"Given a collection, recollect on a dictionary each fragment name and the fragment"
	fragments := Dictionary new.
	aCollection do: [ :fr | fragments at: fr name put: fr ].
]

{ #category : #accessing }
GQLContext >> fragments [
	^ fragments
]

{ #category : #accessing }
GQLContext >> fragments: anObject [
	fragments := anObject
]

{ #category : #initialization }
GQLContext >> initialize [

		fragments := Dictionary new.
		variables := Dictionary new.
]

{ #category : #testing }
GQLContext >> isValid [
"Verify if all the variables are defined in operation"
	variables values detect: [ :var | var type isNil ]
							ifFound: [ :var | ^ GQLException new node: self; 
					messageText: 'All variables must be defined on operation'; raise ]
]

{ #category : #accessing }
GQLContext >> operationName [
	^ operationName
]

{ #category : #accessing }
GQLContext >> operationName: string [
	operationName := string.
]

{ #category : #action }
GQLContext >> reset [

	fragments removeAll.
	variables removeAll.
	operationName := nil.
]

{ #category : #accessing }
GQLContext >> variables [
	^ variables
]

{ #category : #accessing }
GQLContext >> variables: aCollection [
	aCollection isNotNil 
	ifTrue: [ 
		| nameVar |
		aCollection do: [ :var | 
			nameVar := var name value.
			variables 
				at: nameVar 
				ifPresent: [ :v |
					var type isNotNil 
						ifTrue: [ (variables at: nameVar) type: var type ].
					var defaultValue isNotNil 
						ifTrue: [ (variables at: nameVar) defaultValue: var defaultValue ].
					var value isNotNil
						ifTrue: [ (variables at: nameVar) value: var value ] . 
				] ifAbsent: [ variables at: nameVar put: var ] 
		]
	].
]
