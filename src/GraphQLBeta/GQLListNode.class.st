"
I represent a list value. My value is an array of other values

Public API and Key Messages

- executeOn:with:using:


    Implementation Points
"
Class {
	#name : #GQLListNode,
	#superclass : #GQLValueNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #action }
GQLListNode >> executeOn: resolver with: context using: schema [
"Execute the input value according to the resolver, the enviroment and the schema"
	^ value collect: [ :e | 
					e
						executeOn: resolver
						with: context
						using: schema ]
]

{ #category : #accessing }
GQLListNode >> name: aName using: schema [
	value isEmpty
	ifTrue: [ ^ aName ]
	ifFalse: [ ^ value first name: aName using: schema ]
]

{ #category : #printing }
GQLListNode >> printOn: stream [
	stream nextPutAll: '['.
	self value 
		do: [ :v | v printOn: stream ] 
		separatedBy: [ stream nextPutAll: ', ' ].
	stream nextPutAll: ']'.
]
