"
Example class for tests

Public API and Key Messages

- hey
- heyID
- id:

   One simple example is simply gorgeous.

	| anObject |
	anObject := A new id: 1000.
	anObject heyID.
 
    Instance Variables
	id:		Int

"
Class {
	#name : #GQLA,
	#superclass : #Object,
	#instVars : [
		'id'
	],
	#category : #'GraphQLBeta-Test-Trash'
}

{ #category : #accessing }
GQLA >> hey [
"Return heyhey"
	^ #heyhey
]

{ #category : #accessing }
GQLA >> heyID [
"Return id and his value"
	^ 'id: ', id asString
]

{ #category : #accessing }
GQLA >> id [
	^ id
]

{ #category : #accessing }
GQLA >> id: aID [
"Set the id"
	id := aID
]
