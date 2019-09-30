"
I represent a variable definition on the request.

Public API and Key Messages

- defaultValue
- name
- type


    Instance Variables
	defaultValue:		<GQLValueNode>
	name:		<String>
	type:		<GQLSTypeNode>


    Implementation Points
"
Class {
	#name : #GQLVariableDefinitionNode,
	#superclass : #GQLNode,
	#instVars : [
		'name',
		'type',
		'defaultValue',
		'value'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #accessing }
GQLVariableDefinitionNode >> currentValue [
	value isNil 
	ifTrue: [ ^ defaultValue ]
	ifFalse: [ ^ value ]
]

{ #category : #accessing }
GQLVariableDefinitionNode >> defaultValue [
"Return the defaultValue"
	^ defaultValue
]

{ #category : #accessing }
GQLVariableDefinitionNode >> defaultValue: anObject [
"Set the default value"
	defaultValue := anObject
]

{ #category : #accessing }
GQLVariableDefinitionNode >> name [
"Return the name"
	^ name
]

{ #category : #accessing }
GQLVariableDefinitionNode >> name: anObject [
"Set the name"
	name := anObject
]

{ #category : #accessing }
GQLVariableDefinitionNode >> type [
"Return the type"
	^ type
]

{ #category : #accessing }
GQLVariableDefinitionNode >> type: anObject [
"Set the type"
	type := anObject
]

{ #category : #accessing }
GQLVariableDefinitionNode >> value [
	^ value
]

{ #category : #accessing }
GQLVariableDefinitionNode >> value: anObject [
	value := anObject
]
