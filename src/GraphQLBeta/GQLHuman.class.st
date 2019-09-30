"
I am a utility class for test validation
"
Class {
	#name : #GQLHuman,
	#superclass : #GraphQLObject,
	#instVars : [
		'name'
	],
	#category : #'GraphQLBeta-Test-Utils'
}

{ #category : #accessing }
GQLHuman >> name [
	^ name
]

{ #category : #accessing }
GQLHuman >> name: string [
	name := string
]
