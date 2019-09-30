"
I am a utility class for mutation test
"
Class {
	#name : #GQLMutation,
	#superclass : #Object,
	#category : #'GraphQLBeta-Test-Utils'
}

{ #category : #'as yet unclassified' }
GQLMutation >> createPointX: x y: y [

	^ x @ y
]

{ #category : #'as yet unclassified' }
GQLMutation >> createRectangleLeft: left right: right top: top bottom: bottom [

	^ Rectangle left: left right: right top: top bottom: bottom
]

{ #category : #initialization }
GQLMutation >> setNumberTo: aInt [
	^ aInt
]
