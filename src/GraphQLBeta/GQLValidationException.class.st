"
I represent an exception of validation on graphql, I'm only called if the GQLSchema has a problem validating the parts of the schema vs the image of Smalltalk.

Public API and Key Messages

- messageClassText
- messageMethodText:  aClass

Instance Variables
	node:		<Object>

GQLValidationException new 
			node: field; 
			messageMethodText: Object
"
Class {
	#name : #GQLValidationException,
	#superclass : #GQLException,
	#category : #'GraphQLBeta-Core'
}

{ #category : #message }
GQLValidationException >> messageClassText [
"Message for class that doesn't exist on the image of Smalltalk"
	| writer |
	writer := WriteStream on: String new.
	writer
		nextPutAll: 'No exist the class ';
		nextPutAll: node name.
	self messageText: writer contents
]

{ #category : #message }
GQLValidationException >> messageMethodText: aClass [
"Message for the method that doesn't exist on the Class"
	| writer |
	writer := WriteStream on: String new.
	writer
		nextPutAll: 'No exist the method ';
		nextPutAll: node fullName;
		nextPutAll: ' on the class ';
		nextPutAll: aClass name.
	self messageText: writer contents
]
