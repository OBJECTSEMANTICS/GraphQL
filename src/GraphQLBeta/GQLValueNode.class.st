"
I represent a value on a request.

Public API and Key Messages

- value

    Instance Variables
	value:		<String>


    Implementation Points
"
Class {
	#name : #GQLValueNode,
	#superclass : #GQLNode,
	#instVars : [
		'value'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #comparing }
GQLValueNode >> = other [

	^ self value = other value
]

{ #category : #action }
GQLValueNode >> executeOn: resolver with: context using: schema [

	self subclassResponsibility 
]

{ #category : #testing }
GQLValueNode >> isObjectNode [
	^ false
]

{ #category : #testing }
GQLValueNode >> isVariableNode [
	^ false
]

{ #category : #accessing }
GQLValueNode >> name: aName using: schema [
	^ nil
]

{ #category : #accessing }
GQLValueNode >> nodeName [
	self subclassResponsibility 
]

{ #category : #printing }
GQLValueNode >> printOn: stream [
	value printOn: stream
]

{ #category : #accessing }
GQLValueNode >> value [
"Return the value"
	^ value
]

{ #category : #accessing }
GQLValueNode >> value: anObject [
"Set the value"
	value := anObject
]

{ #category : #'as yet unclassified' }
GQLValueNode >> valueVariables [
	^ Dictionary new.
]

{ #category : #accessing }
GQLValueNode >> valueWith: context [
"Set the value"
	^ value
]
