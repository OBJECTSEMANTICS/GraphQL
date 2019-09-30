"
I am a utility class for testing
"
Class {
	#name : #GQLAlien,
	#superclass : #GraphQLObject,
	#instVars : [
		'name',
		'homePlanet'
	],
	#category : #'GraphQLBeta-Test-Utils'
}

{ #category : #accessing }
GQLAlien >> homePlanet [
	^ homePlanet
]

{ #category : #accessing }
GQLAlien >> name [
	^ name
]
