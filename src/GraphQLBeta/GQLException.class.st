"
I represent an exception of graphql, I know the node that raise some kind of exception on the parsing or the validation or the type checking of the schema.

Public API and Key Messages

- node      
- node: 
- signal

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	node:		<Object>


    Implementation Points
"
Class {
	#name : #GQLException,
	#superclass : #Exception,
	#instVars : [
		'node'
	],
	#category : #'GraphQLBeta-Core'
}

{ #category : #accessing }
GQLException >> defaultAction [
	"No one has handled this error, but now give them a chance to decide how to debug it.  If none handle this either then open debugger (see UnhandedError-defaultAction)"

	^ self
]

{ #category : #'as yet unclassified' }
GQLException >> node [
"Return the element that causes a exception"
	^ node
]

{ #category : #'as yet unclassified' }
GQLException >> node: aNode [
"Recive a node element that causes a exception"
	node := aNode
]

{ #category : #signaling }
GQLException >> raise [
	"for visualworks"
	self signal
]
