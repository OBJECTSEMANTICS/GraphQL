"
I represent a float value.

Public API and Key Messages

- executeOn:with:using:


    Implementation Points
"
Class {
	#name : #GQLFloatNode,
	#superclass : #GQLValueNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #action }
GQLFloatNode >> executeOn: resolver with: context using: schema [
"Execute the input value according to the resolver, the enviroment and the schema"
	^ value asNumber
]

{ #category : #printing }
GQLFloatNode >> printOn: stream [
	value asNumber printOn: stream.
]
