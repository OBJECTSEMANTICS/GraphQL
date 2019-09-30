"
I represent a document. The principal node of the request.

Public API and Key Messages

- definitions
- executeOn:with:using:

    Instance Variables
	definitions:		<Array>


    Implementation Points
"
Class {
	#name : #GQLDocumentNode,
	#superclass : #GQLNode,
	#instVars : [
		'operations',
		'fragments'
	],
	#category : #'GraphQLBeta-Nodes'
}

{ #category : #visiting }
GQLDocumentNode >> accept: aVisitor [
	aVisitor visitDocumentNode: self
]

{ #category : #accessing }
GQLDocumentNode >> definitions: aList [
"Set operations or fragments"	
	operations := aList select: [ :def | def isOperation ].
	fragments := aList reject: [ :def | def isOperation ].
]

{ #category : #'public access' }
GQLDocumentNode >> evaluate [
"Validate the fragments"

	| fragmentsNames spreads |
	fragmentsNames := fragments collect: #name.
	spreads := self spreads.
	
	fragmentsNames size = fragmentsNames asSet size 
		ifFalse: [ ^ GQLException new messageText: 'Duplicated name fragment'; 
											raise ].
													
	fragments detect: [ :fragment | self hasCycle: fragment with: Set new ]
				ifFound: [ :fragment | ^ GQLException new node: fragment;
											messageText: 'Cycles on fragment'; raise ].
				
	fragments size = spreads size ifFalse: [ ^ GQLException new
											messageText: 'Unused fragments'; raise ].
										
	spreads detect: [ :spread | (fragmentsNames includes: spread name) not ]
		ifFound: [ :spread | ^ GQLException new node: spread; 
													messageText: 'Undefined fragment'; raise ]
]

{ #category : #action }
GQLDocumentNode >> executeOn: root with: context using: schema [
"Given a root, a context and the schema, execute this document"
	| result |
	(context operationName isNil or: [context operationName size = 0])
	ifTrue: [ result := self executeShorthandOn: root with: context using: schema ]
	ifFalse: [ | validVariables | 
		validVariables := self validVariablesDocument: context.
		(validVariables isMemberOf: GQLException) 
		ifTrue: [ result := validVariables ]
		ifFalse: [  result := self executeOperationOn: root with: context using: schema ]
	].
	"The result is added a dictionary according the specification of GraphQL 
	found in: http://facebook.github.io/graphql/draft/#ExecuteQuery()
	"
	result class = GQLException 
	ifTrue: [ ^ result ]
	ifFalse: [ ^ Dictionary new at: 'data' put: result; yourself ]
]

{ #category : #action }
GQLDocumentNode >> executeOperationOn: root with: context using: schema [
"Execute the operation of name defined on the context, if there isnt an operation with the name raise an exception"
	operations detect: [ :op | op name = context operationName ] 
		ifFound: [ :op | ^ op executeOn: root with: context using: schema ] 
		ifNone: [ ^ GQLException new messageText: 'Operation with name ', 
						context operationName, ' not defined'; 
											raise ] 
]

{ #category : #action }
GQLDocumentNode >> executeShorthandOn: root with: context using: schema [
"Execute the shorthand operation only if is the only one, if not raise an exception that must be require operationName"
	operations size = 1 
		ifTrue: [ ^ operations first executeOn: root with: context using: schema ]
		ifFalse: [ ^ GQLException new messageText: 'Query error, require operationName'; 
											raise ]
]

{ #category : #accessing }
GQLDocumentNode >> fragments [
"Return the fragments"	
	^ fragments
]

{ #category : #accessing }
GQLDocumentNode >> fragments: aArray [
"Set the fragments"
	fragments := aArray
]

{ #category : #'public access' }
GQLDocumentNode >> getFragment: aName [
	"Return the fragment with aName"
	^ fragments 
		detect: [ :fragment | fragment name = aName ]
		ifFound: [ :fragment | fragment ]
		ifNone: [ nil ]
]

{ #category : #'public access' }
GQLDocumentNode >> hasCycle: aFragment with: visited [
	^ aFragment targetSpreads asArray anySatisfy: [ :spread | 
		| frag nextVisited res |
		(visited includes: spread)
			ifTrue: [ ^ true ].
		frag := self getFragment: spread name.
		frag ifNil: [ ^ false ].
		nextVisited := Set new.
		nextVisited add: spread.
		nextVisited addAll: visited.
		res := self hasCycle: frag with: nextVisited.
		res ifTrue: [ visited add: spread ].
		res ]
]

{ #category : #initialization }
GQLDocumentNode >> initialize [

	super initialize.
	fragments := OrderedCollection new.
	operations := OrderedCollection new.
]

{ #category : #accessing }
GQLDocumentNode >> operations [
"Return the operations"	
	^ operations
]

{ #category : #accessing }
GQLDocumentNode >> operations: aArray [
"Set the operations"
	operations := aArray
]

{ #category : #accessing }
GQLDocumentNode >> spreads [
"Return all the fragment spreads on the operations and the fragments"
	| spreads |
	spreads := Set new.
	operations do: [ :operation | 
		spreads addAll: (operation targetSpreads) ].
	fragments do: [ :fragment | 
		spreads addAll: (fragment targetSpreads) ].
	^ spreads
]

{ #category : #action }
GQLDocumentNode >> validVariablesDocument: context [
	| variables |
	variables := self variablesOn: context.
	(variables isMemberOf: GQLException) 
	ifTrue: [ ^ variables ]
	ifFalse: [ context variables: variables.
		context variables values 
			detect: [ :var | var type isNil or: 
				[(var type class = GQLSNonNullTypeNode) and: [ var defaultValue isNotNil ] ] ]
			ifFound: [ ^ GQLException new node: self; 
					messageText: 'All variables must be defined on operations'; raise] 
		].
]

{ #category : #action }
GQLDocumentNode >> variablesOn: context [
	| collectedVariables |
	collectedVariables := OrderedCollection new.
	operations do: [ :op | 
		| varDefinitions colVar |
		colVar := op collectVariables: context.
		(colVar isMemberOf: GQLException) 
		ifTrue: [ ^ colVar ]
		ifFalse: [ 
			varDefinitions := op validVariables.
			 collectedVariables addAll: varDefinitions.
			"colVar asSet = (varDefinitions  collect: [ :var | var name value ]) asSet
			ifTrue: [ collectedVariables addAll: varDefinitions ]
			ifFalse: [ self halt.^ GQLException new node: self; 
					messageText: 'Error with variables'; raise ]"
		]
	].
	^ collectedVariables
]
