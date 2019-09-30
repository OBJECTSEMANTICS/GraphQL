"
I represent a schema definition node, I define the root operation types.

Public API and Key Messages

- addRootOpTypes:with:
- rootOperationTypes

    Instance Variables
	rootOperationTypes:		<Object>


    Implementation Points
"
Class {
	#name : #GQLSSchemaDefinitionNode,
	#superclass : #GQLSNode,
	#instVars : [
		'rootOperationTypes',
		'defaultRootOpTypes'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #adding }
GQLSSchemaDefinitionNode >> addRootOpType: aRootOpType withKey: aKey [
	rootOperationTypes at: aKey 
	ifPresent: [ :value | value add: aRootOpType ]
	ifAbsentPut: [ OrderedCollection new add: aRootOpType; yourself ]
]

{ #category : #'as yet unclassified' }
GQLSSchemaDefinitionNode >> initDefaultRootOpTypes [
	defaultRootOpTypes := Dictionary new
	at: 'query' put: (Array with: (GQLSRootOperationTypeNode new name: 'GQLQuery'; yourself));
	at: 'mutation' put: (Array with: (GQLSRootOperationTypeNode new name: 'GQLMutation'; yourself));
	at: 'subscription' put: (Array with: (GQLSRootOperationTypeNode new name: 'Subscription'; yourself));
	yourself
]

{ #category : #initialization }
GQLSSchemaDefinitionNode >> initialize [
	rootOperationTypes := Dictionary new.
	self initDefaultRootOpTypes 
]

{ #category : #testing }
GQLSSchemaDefinitionNode >> isSchemaDefinitionNode [
	^ true
]

{ #category : #accessing }
GQLSSchemaDefinitionNode >> name [
	^ nil
]

{ #category : #accessing }
GQLSSchemaDefinitionNode >> rootOperationTypes [
	rootOperationTypes isEmpty ifTrue: [ 
		self rootOperationTypes: rootOperationTypes values.
	].
	^ rootOperationTypes
]

{ #category : #accessing }
GQLSSchemaDefinitionNode >> rootOperationTypes: aList [
	aList isEmpty ifTrue: [ 
		rootOperationTypes at: 'query' put: (defaultRootOpTypes at: 'query')
	] 
	ifFalse: [ 
		aList do: [ :rootOpType | 
			rootOpType executeBlock: [:key | self addRootOpType: rootOpType withKey: key]
	]
]
]
