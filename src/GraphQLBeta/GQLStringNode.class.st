"
I represent a string value.

Public API and Key Messages

- executeOn:with:using:



    Implementation Points
"
Class {
	#name : #GQLStringNode,
	#superclass : #GQLValueNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #action }
GQLStringNode >> executeOn: resolver with: context using: schema [
"Execute the input value according to the resolver, the enviroment and the schema"
	 ^ value
				copyFrom: 2
				to: value size - 1
]

{ #category : #printing }
GQLStringNode >> printOn: stream [
	stream nextPutAll: value
]
