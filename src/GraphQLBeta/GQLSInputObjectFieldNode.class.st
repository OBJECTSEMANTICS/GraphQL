"
I represent a field of a input object type. My type only could be: scalar, enum or an input object.
"
Class {
	#name : #GQLSInputObjectFieldNode,
	#superclass : #GQLSFieldNode,
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #defaults }
GQLSInputObjectFieldNode >> defaultValue [
	^ nil
]

{ #category : #printing }
GQLSInputObjectFieldNode >> printFullOn: stream [
	stream 
		nextPutAll: self name;
		nextPutAll: ': '.
		
	self type printOn: stream
]
