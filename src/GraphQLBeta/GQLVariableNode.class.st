"
I represent a variable value.

Public API and Key Messages

- executeOn:with:using:


    Implementation Points
"
Class {
	#name : #GQLVariableNode,
	#superclass : #GQLValueNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #action }
GQLVariableNode >> executeOn: resolver with: context using: schema [
	context variables isNil 
	ifTrue: [ ^ GQLException new node: self; messageText: 'Error on variables'; raise ]
	ifFalse: [ context variables detect: 
	[ :var | var name value = self value ]
	ifFound: [ :var | ^ self value: var executeOn: resolver with: context  using: schema ]
	ifNone: [ ^ GQLException new node: self; 
					messageText: 'Error on variables'; raise ]. 
	]
]

{ #category : #testing }
GQLVariableNode >> isVariableNode [
	^ true
]

{ #category : #accessing }
GQLVariableNode >> name: aName using: schema [
	(schema schemaTypes includesKey: aName)
	ifTrue: [ ^ (schema schemaTypes at: aName) nameOfClass: aName]
	ifFalse: [ ^ aName ]
]

{ #category : #printing }
GQLVariableNode >> printOn: stream [
	stream nextPutAll: '$'; nextPutAll: value.
]

{ #category : #accessing }
GQLVariableNode >> value: aVarDefinition executeOn: resolver with: context using: schema [
	| varValue |
	varValue := aVarDefinition currentValue.
	varValue isObjectNode 
		ifTrue: [ varValue objectFields do:
			[ :objField | resolver perform: (objField name, ':') asSymbol 
									with: (objField value executeOn: resolver with: context using: schema)]
			].
		^ varValue executeOn: resolver with: context using: schema
]

{ #category : #accessing }
GQLVariableNode >> valueVariables [ 
	^ Dictionary new at: value put: self; yourself
]

{ #category : #accessing }
GQLVariableNode >> valueWith: context [
	^ context variables at: value
		ifPresent: [ :var | var currentValue value ] 
		ifAbsent: [ value ]
]
