"
I am a class just for test arguments
"
Class {
	#name : #GQLArguments,
	#superclass : #GraphQLObject,
	#category : #'GraphQLBeta-Test-Utils'
}

{ #category : #public }
GQLArguments >> booleanArgField [
	^ true
]

{ #category : #public }
GQLArguments >> booleanArgFieldBooleanArg: bool [
	bool ifNil: [ ^ true ].
	^ bool not.
]

{ #category : #public }
GQLArguments >> booleanListArgFieldBooleanListArg: list [
	^ list
]

{ #category : #public }
GQLArguments >> floatArgFieldFloatArg: float [
	^ float 
]

{ #category : #public }
GQLArguments >> intArgFieldIntArg: int [
	^ int * int
]

{ #category : #public }
GQLArguments >> multipleReqsX: x y: y [
	^ (x * x) + y
]

{ #category : #public }
GQLArguments >> nonNullBooleanArgFieldNonNullBooleanArg: bool [
	^ bool not
]

{ #category : #public }
GQLArguments >> nonNullBooleanListFieldNonNullBooleanListArg: bools [
	^ bools
]

{ #category : #public }
GQLArguments >> optionalNonNullBooleanArgFieldOptionalBooleanArg: bool [
	^ bool
]

{ #category : #public }
GQLArguments >> singleIDId: id [
	^ id
]

{ #category : #public }
GQLArguments >> singleStringString: string [
	^ string
]
