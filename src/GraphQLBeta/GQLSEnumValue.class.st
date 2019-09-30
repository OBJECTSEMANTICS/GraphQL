"
I represent an enum value of a EnumTypeNode, like:
value : String! 

Public API and Key Messages

- value
- value: 


    Instance Variables
	value:		<String>


    Implementation Points
"
Class {
	#name : #GQLSEnumValue,
	#superclass : #GQLSNode,
	#instVars : [
		'value'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #comparing }
GQLSEnumValue >> = otherObject [
	^ otherObject class = self class and: [ otherObject value = value ]
]

{ #category : #'as yet unclassified' }
GQLSEnumValue >> deprecationReason [
	^ nil
]

{ #category : #comparing }
GQLSEnumValue >> hash [
	^ value hash
]

{ #category : #testing }
GQLSEnumValue >> isDeprecated [ 
	^ false
]

{ #category : #accessing }
GQLSEnumValue >> name [ 
	^ value
]

{ #category : #accessing }
GQLSEnumValue >> value [
	^ value
]

{ #category : #accessing }
GQLSEnumValue >> value: anObject [
	value := anObject
]
