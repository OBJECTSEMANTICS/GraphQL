"
Example class query  for tests

Public API and Key Messages

- a
- aId:
- hello
- helloName:
- sumNums:


"
Class {
	#name : #GQLIQueryType,
	#superclass : #Object,
	#category : #'GraphQLBeta-Test-Trash'
}

{ #category : #accessing }
GQLIQueryType >> a [

	^ GQLA new id: 1.
]

{ #category : #accessing }
GQLIQueryType >> aId: aID [

	^ GQLA new id: aID
]

{ #category : #accessing }
GQLIQueryType >> anGqla: aGQLA [

	^ aGQLA.
]

{ #category : #accessing }
GQLIQueryType >> hello [
 ^ #helloWorld
]

{ #category : #accessing }
GQLIQueryType >> helloForName: aString [

	^ #hello , aString.
]

{ #category : #accessing }
GQLIQueryType >> sumNums: aCollection [

	^ aCollection reduce: [ :a :b | a + b ].
]
