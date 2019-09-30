"
I represent a node of a graphql request 

Public API and Key Messages

- acceptVisitor:  
- executeOn:with:using:

To see more information go to the subclasses
"
Class {
	#name : #GQLNode,
	#superclass : #GQLAbstractNode,
	#instVars : [
		'comments'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #accessing }
GQLNode class >> nodeName [
	^ self class name
]

{ #category : #visiting }
GQLNode >> accept: visitor [
	visitor visitSelectionSetNode: self
]

{ #category : #adding }
GQLNode >> addComments: aArray [
	aArray do: [ :aArr | 
		aArr isNotNil ifTrue: [ comments addAll: aArr ]
	]
]

{ #category : #accessing }
GQLNode >> comments [
	^ comments
]

{ #category : #accessing }
GQLNode >> comments: anObject [
	comments := anObject
]

{ #category : #action }
GQLNode >> executeOn: resolver with: context using: schema [
"This is responsability of the subclass"
	self shouldBeImplemented
]

{ #category : #initialization }
GQLNode >> initialize [
	comments := OrderedCollection new.
]
