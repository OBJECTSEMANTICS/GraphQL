"
I represent a int value.

Public API and Key Messages

- executeOn:with:using:

    Implementation Points
"
Class {
	#name : #GQLIntNode,
	#superclass : #GQLValueNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #action }
GQLIntNode >> executeOn: resolver with: context using: schema [
"Execute the input value according to the resolver, the enviroment and the schema"
	^ value asInteger
]

{ #category : #accessing }
GQLIntNode >> nodeName [
	^ 'Int'
]

{ #category : #printing }
GQLIntNode >> printOn: stream [
	value asInteger printOn: stream
]
