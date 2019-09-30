"
I represent a list type.
"
Class {
	#name : #GQLSListTypeNode,
	#superclass : #GQLSWrapTypeNode,
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #testing }
GQLSListTypeNode >> basicCoerce: value on: schema [
	(wrappedType canCoerce: value on: schema) ifTrue: [ ^ true ].
	
	^ value class = GQLListNode and: [
		value value allSatisfy: [ :v | wrappedType canCoerce: v on: schema ] ].
	
]

{ #category : #coercion }
GQLSListTypeNode >> coerceValue: value on: schema [
	value isVariableNode ifTrue: [ ^ value ].
	value class = GQLNullNode ifTrue: [ ^ value ].
	
	(self canCoerce: value on: schema) ifFalse: [ 
		value class = GQLListNode ifFalse: [ self error: 'invalid input' ] ].
	value class = GQLListNode ifTrue: [
		^ GQLListNode new
			value: (value value collect: [ :v | self wrappedType coerceValue: v on: schema ]);
			position: value position ].
	^ GQLListNode new 
		value: (Array with: (self wrappedType coerceValue: value on: schema));
		position: value position.
	
]

{ #category : #accessing }
GQLSListTypeNode >> kind [
	^ 'LIST'
]

{ #category : #accessing }
GQLSListTypeNode >> name [ 
	^ nil
]

{ #category : #printing }
GQLSListTypeNode >> printOn: stream [
	stream nextPutAll: '['.
	self wrappedType printOn: stream.
	stream nextPutAll: ']'.
]
