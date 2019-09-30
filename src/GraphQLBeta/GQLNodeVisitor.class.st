"
I represent the validator to evaluate the document with the schema.

Public API and Key Messages

- initalize
- schema""
- visitArgumentNode:
- visitDocumentNode:
- visitInputValueNode:
- visitObjectNode:
- visitScalarNode:
- visitSelectionSetNode:

    Instance Variables
	schema:		<GQLSchema>
	schemaContextStack:		<Stack>

For more information see the class GQLTypeValidator
"
Class {
	#name : #GQLNodeVisitor,
	#superclass : #GraphQLObject,
	#instVars : [
		'schema',
		'errors',
		'text',
		'context',
		'document',
		'schemaContextStack'
	],
	#category : #'GraphQLBeta-Visitors'
}

{ #category : #error }
GQLNodeVisitor >> addError: newError [
	errors add: newError.
]

{ #category : #error }
GQLNodeVisitor >> addErrorMessage: string node: node [
	self addError: (GQLError new
		message: string;
		locationFor: node on: text)
]

{ #category : #error }
GQLNodeVisitor >> addErrorMessage: string nodes: nodes [
	self addError: (GQLError new
		message: string;
		locationFor: nodes on: text)
]

{ #category : #accessing }
GQLNodeVisitor >> context: anObject [
	context := anObject
	
]

{ #category : #accessing }
GQLNodeVisitor >> document [
	^ document
]

{ #category : #accessing }
GQLNodeVisitor >> errors [
	^ errors ifNil: [ #() ]
]

{ #category : #accessing }
GQLNodeVisitor >> errors: aCollection [
	errors := aCollection
]

{ #category : #'accessing - computed' }
GQLNodeVisitor >> getFragmentTypeOf: ref [
	| type |
	ref isNullType ifTrue: [ ^ ref ].
	type := schema getType: ref name.
	type 
		ifNil: [ type := GQLSNullTypeNode instance ]
		ifNotNil: [ (type isObjectType | type isUnionType | type isInterfaceType) ifFalse: [ 
			type := GQLSNullTypeNode instance ] ].
	^ type
]

{ #category : #accessing }
GQLNodeVisitor >> schema [
	^ schema
]

{ #category : #accessing }
GQLNodeVisitor >> schema: aSchema [
	schema := aSchema
]

{ #category : #utilities }
GQLNodeVisitor >> stackedOn: node do: block [
	document := node.
	schemaContextStack := Stack new.
	schemaContextStack push: schema query.
	block value.
	schemaContextStack pop
]

{ #category : #utilities }
GQLNodeVisitor >> stackedType: node do: block [
	| type isNil|
	type := schema perform: (node type, #Type) asSymbol.
	isNil := false.
	type ifNil: [ 
		type := GQLSNullTypeNode instance.
		isNil := true. ].
	schemaContextStack push: type.
	block value.
	schemaContextStack pop.
	^ isNil
	
]

{ #category : #accessing }
GQLNodeVisitor >> text [
	^ text
]

{ #category : #accessing }
GQLNodeVisitor >> text: string [
	"the original string"
	text := string
]

{ #category : #visiting }
GQLNodeVisitor >> visitArgumentNode: node [
	
]

{ #category : #visiting }
GQLNodeVisitor >> visitDirectiveNode: node [
]

{ #category : #visiting }
GQLNodeVisitor >> visitDocumentNode: node [
	
]

{ #category : #visiting }
GQLNodeVisitor >> visitFragmentNode: node [
	
]

{ #category : #visiting }
GQLNodeVisitor >> visitFragmentSpreadNode: node [
	
]

{ #category : #visiting }
GQLNodeVisitor >> visitInlineFragmentNode: node [
	
]

{ #category : #visiting }
GQLNodeVisitor >> visitNonScalarFieldNode: node [
	
]

{ #category : #visiting }
GQLNodeVisitor >> visitOperationNode: node [
	
]

{ #category : #visiting }
GQLNodeVisitor >> visitScalarFieldNode: node [
	
]

{ #category : #visiting }
GQLNodeVisitor >> visitSchemaFieldNode: node [
	
]

{ #category : #visiting }
GQLNodeVisitor >> visitSelectionSetNode: node [
	
]

{ #category : #visiting }
GQLNodeVisitor >> visitTypeFieldNode: node [
	
]

{ #category : #visiting }
GQLNodeVisitor >> visitTypenameFieldNode: node [
	
]
