"
I represent a graphql position for the json response

Example

{
	""line"" : 4
	""column"" : 5
}
"
Class {
	#name : #GQLPosition,
	#superclass : #GraphQLObject,
	#instVars : [
		'line',
		'column'
	],
	#category : #'GraphQLBeta-Validation'
}

{ #category : #comparing }
GQLPosition >> = other [
	^ self class = other class and: [ line = other line and: [ column = other column ] ]
]

{ #category : #accessing }
GQLPosition >> column [
	^ column
]

{ #category : #accessing }
GQLPosition >> column: anInteger [
	column := anInteger
]

{ #category : #comparing }
GQLPosition >> hash [
	^ (line *10) + column 
]

{ #category : #accessing }
GQLPosition >> line [
	^ line
]

{ #category : #accessing }
GQLPosition >> line: anInteger [
	line := anInteger
]
