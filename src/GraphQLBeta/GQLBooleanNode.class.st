"
I represent a boolean value.

Public API and Key Messages

- executeOn:with:using:


    Implementation Points
"
Class {
	#name : #GQLBooleanNode,
	#superclass : #GQLValueNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #action }
GQLBooleanNode >> executeOn: resolver with: context using: schema [
"Execute the input value according to the resolver, the enviroment and the schema"
	^ value = 'true'
]

{ #category : #accessing }
GQLBooleanNode >> nodeName [
	^ 'Boolean'
]

{ #category : #printing }
GQLBooleanNode >> printOn: stream [
	stream nextPutAll: value
]
