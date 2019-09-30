"
I represent a directive on a request.

Public API and Key Messages

- arguments
- name


    Instance Variables
	arguments:		<Array>
	name:		<String>


    Implementation Points
"
Class {
	#name : #GQLDirectiveNode,
	#superclass : #GQLNode,
	#instVars : [
		'name',
		'arguments'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #'instance creation' }
GQLDirectiveNode class >> new: aName [

	| inst |
	self allSubclasses detect: [ :subclass | subclass directiveName = aName ]
						ifFound: [ :subclass | inst := subclass new ]
						ifNone: [ inst := self new ].
						
	^ inst
]

{ #category : #visiting }
GQLDirectiveNode >> accept: visitor [
	visitor visitDirectiveNode: self
]

{ #category : #accessing }
GQLDirectiveNode >> arguments [
"Return the arguments"
	^ arguments ifNil: [ #() ]
]

{ #category : #accessing }
GQLDirectiveNode >> arguments: anObject [
"Set the arguments"
	arguments := anObject
]

{ #category : #execute }
GQLDirectiveNode >> evaluateOn: schema using: context [
"Evaluate if the directive exist on schema, as it's defined"
	| directive |
	directive := schema getDirective: self name.
	^ directive isNotNil and: [self partialEquals: directive using: context].

	

	
]

{ #category : #running }
GQLDirectiveNode >> execute: context [
	^ self subclassResponsibility 
]

{ #category : #accessing }
GQLDirectiveNode >> isInclude [

	^ false
]

{ #category : #accessing }
GQLDirectiveNode >> isSkip [

	^ false
]

{ #category : #accessing }
GQLDirectiveNode >> name [
"Return the name"
	^ name
]

{ #category : #accessing }
GQLDirectiveNode >> name: anObject [
"Set the name"
	name := anObject
]

{ #category : #comparing }
GQLDirectiveNode >> partialEquals: other using: context [
"Given other directive, verify if has the same name and arguments"
	^ ((self arguments size = other arguments size) 
		and: [self name = other name]) 
	   and: [ self arguments allSatisfy: [ :arg | 
			other arguments anySatisfy: [ :o | 
				arg partialEquals: o using: context] ]]
]
