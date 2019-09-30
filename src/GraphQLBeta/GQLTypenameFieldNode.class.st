Class {
	#name : #GQLTypenameFieldNode,
	#superclass : #GQLScalarFieldNode,
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #visiting }
GQLTypenameFieldNode >> accept: visitor [
	visitor visitTypenameFieldNode: self.
]

{ #category : #action }
GQLTypenameFieldNode >> executeOn: resolver with: context using: schema [
"Given a resolver, an context and the schema, execute the request"
	^ resolver className
]

{ #category : #initialization }
GQLTypenameFieldNode >> initialize [ 
	super initialize.
	arguments := #()
]
