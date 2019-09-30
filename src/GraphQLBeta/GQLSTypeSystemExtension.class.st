Class {
	#name : #GQLSTypeSystemExtension,
	#superclass : #GQLSNode,
	#instVars : [
		'name',
		'value'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #testing }
GQLSTypeSystemExtension >> isTypeExtensionNode [
	^ true
]

{ #category : #accessing }
GQLSTypeSystemExtension >> name [
	^ name
]

{ #category : #accessing }
GQLSTypeSystemExtension >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GQLSTypeSystemExtension >> value [
	^ value
]

{ #category : #accessing }
GQLSTypeSystemExtension >> value: anObject [
	value := anObject
]
