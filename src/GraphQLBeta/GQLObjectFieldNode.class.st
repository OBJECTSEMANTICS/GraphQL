"
I represent a field of an object value.

Public API and Key Messages

- name
- value

    Instance Variables
	name:		<String>
	value:		<GQLValueNode>


    Implementation Points
"
Class {
	#name : #GQLObjectFieldNode,
	#superclass : #GQLNode,
	#instVars : [
		'name',
		'value'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #action }
GQLObjectFieldNode >> executeOn: resolver with: context using: schema [
	
	^ value executeOn: resolver with: context using: schema 
]

{ #category : #accessing }
GQLObjectFieldNode >> name [
"Return the name"
	^ name
]

{ #category : #accessing }
GQLObjectFieldNode >> name: anObject [
"Set the name"
	name := anObject
]

{ #category : #printing }
GQLObjectFieldNode >> printOn: stream [
	stream
		nextPutAll: name;
		nextPutAll: ': '.
	value printOn: stream
]

{ #category : #accessing }
GQLObjectFieldNode >> value [
"Return the value"
	^ value
]

{ #category : #accessing }
GQLObjectFieldNode >> value: anObject [
"Set the value"
	value := anObject
]
