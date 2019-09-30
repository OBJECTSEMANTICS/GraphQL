"
I represent a null value on a request.

"
Class {
	#name : #GQLNullNode,
	#superclass : #GQLValueNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #action }
GQLNullNode >> executeOn: resolver with: context using: schema [
"Execute the input value according to the resolver, the enviroment and the schema"
	^ nil
]

{ #category : #printing }
GQLNullNode >> printOn: stream [
	stream nextPutAll: 'null'.
]
