"
I represent the error of graphql in the validation system, in order to build a json
"
Class {
	#name : #GQLError,
	#superclass : #GraphQLObject,
	#instVars : [
		'message',
		'locations'
	],
	#category : #'GraphQLBeta-Validation'
}

{ #category : #accessing }
GQLError >> addLocations: list [
	locations addAll: list.
]

{ #category : #accessing }
GQLError >> locationFor: arr on: string [
	| line column list positions |
	list := arr isCollection
		ifTrue: [ arr ]
		ifFalse: [ Array with: arr ].
	positions := OrderedCollection new: list size.
	list do: [ :node |
		line := 1.
		column := 1.
		1 to: node position - 1 do: [ :index | | char|
			char := string at: index.
			(char = Character cr or: [char = Character lf]) ifTrue: [ 
				line := line + 1. 
				column := 0 ].
			column := column + 1
		].
		positions add: (GQLPosition new 
			line: line;
			column: column).
	].
	self locations: positions
]

{ #category : #accessing }
GQLError >> locations [
	^ locations
]

{ #category : #accessing }
GQLError >> locations: list [
	locations := list
]

{ #category : #accessing }
GQLError >> message [
	^ message
]

{ #category : #accessing }
GQLError >> message: string [
	message := string
]
