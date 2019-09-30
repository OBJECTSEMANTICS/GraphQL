"
I am an utility class for tests in validation and with the GQLQueryRoot schema
"
Class {
	#name : #GQLDog,
	#superclass : #GraphQLObject,
	#instVars : [
		'name',
		'nickname',
		'barkVolume',
		'owner'
	],
	#category : #'GraphQLBeta-Test-Utils'
}

{ #category : #accessing }
GQLDog >> barkVolume [
	^ barkVolume
]

{ #category : #accessing }
GQLDog >> barkVolume: integer [
	barkVolume  := integer
]

{ #category : #accessing }
GQLDog >> complex [
	^ nil
]

{ #category : #'accessing-computed' }
GQLDog >> doesKnowCommandDogCommand: command [
	^ #('SIT') includes: command
]

{ #category : #'accessing-computed' }
GQLDog >> isHousetrainedAtOtherHomes: bool [
	^ false
]

{ #category : #accessing }
GQLDog >> name [
	^ name
]

{ #category : #accessing }
GQLDog >> name: string [
	name := string
]

{ #category : #accessing }
GQLDog >> nickname [
	^ nickname 
]

{ #category : #accessing }
GQLDog >> nickname: string [
	nickname := string
]

{ #category : #accessing }
GQLDog >> owner [
	^ owner
]

{ #category : #accessing }
GQLDog >> owner: human [
	owner := human
]
