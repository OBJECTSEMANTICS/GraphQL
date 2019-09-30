"
I am a utility class for testing
"
Class {
	#name : #GQLCat,
	#superclass : #GraphQLObject,
	#instVars : [
		'name',
		'nickname',
		'meowVolume'
	],
	#category : #'GraphQLBeta-Test-Utils'
}

{ #category : #accessing }
GQLCat >> doesKnowCommandCatCommand: command [
	^ false
]

{ #category : #accessing }
GQLCat >> meowVolume [
	^ meowVolume 
]

{ #category : #accessing }
GQLCat >> meowVolume: integer [
	meowVolume := integer
]

{ #category : #accessing }
GQLCat >> name [
	^ name
]

{ #category : #accessing }
GQLCat >> name: string [
	name := string
]

{ #category : #accessing }
GQLCat >> nickname [
	^ nickname 
]

{ #category : #accessing }
GQLCat >> nickname: string [
	nickname := string
]
