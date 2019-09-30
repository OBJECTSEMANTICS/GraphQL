"
I am a basic object person for this demo of graphql
"
Class {
	#name : #Person,
	#superclass : #Object,
	#instVars : [
		'name',
		'age'
	],
	#category : #'GraphQLBeta-Demo'
}

{ #category : #'instance creation' }
Person class >> name: aName age: aAge [

	| inst |
	inst := self new.
	inst name: aName;
		age: aAge.
	^ inst
]

{ #category : #comparing }
Person >> = anObject [
	^ anObject class = self class 
	ifTrue: [ self name = anObject name and: [ self age = anObject age ] ]
	ifFalse: [ false ]
	
]

{ #category : #accessing }
Person >> age [
	^ age
]

{ #category : #accessing }
Person >> age: anObject [
	age := anObject
]

{ #category : #comparing }
Person >> hash [
	^ name hash + age hash
]

{ #category : #accessing }
Person >> name [
	^ name
]

{ #category : #accessing }
Person >> name: anObject [
	name := anObject
]
