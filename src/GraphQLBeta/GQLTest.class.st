Class {
	#name : #GQLTest,
	#superclass : #TestCase,
	#instVars : [
		'schema',
		'rootInstance',
		'withData',
		'compareJson'
	],
	#category : #'GraphQLBeta-Tests-Nodes'
}

{ #category : #converting }
GQLTest >> assert: anObject class: aClass [

	self assert: anObject class equals: aClass
]

{ #category : #asserting }
GQLTest >> assert: a equals: b [
	compareJson = true 
		ifTrue: [ self assertJSONEquals: a and: b  ]
		ifFalse: [ super assert: a equals: b ]
]

{ #category : #converting }
GQLTest >> assert: anObject fullName: aName [

	self assert: anObject fullName equals: aName
]

{ #category : #converting }
GQLTest >> assert: anObject name: aName [

	self assert: anObject name equals: aName
]

{ #category : #converting }
GQLTest >> assert: anObject position: aInt [

	self assert: anObject position equals: aInt
]

{ #category : #converting }
GQLTest >> assert: anObject type: aType [

	self assert: anObject type equals: aType
]

{ #category : #parsing }
GQLTest >> assertArguments: aField ofClasses: aCollection [

	| valuesClasses |
	valuesClasses := (aField arguments collect: #value) collect: #class.
	
	self assert: (valuesClasses collect: [ :cls | cls name asString ] ) equals: aCollection.
	
]

{ #category : #parsing }
GQLTest >> assertArguments: aField withNames: aCollection [

	self assert: (aField arguments collect: #name) equals: aCollection.
	
]

{ #category : #parsing }
GQLTest >> assertArguments: aField withValues: aCollection [

	| values |
	values := (aField arguments collect: #value) collect: #value.
	self assert: values equals: aCollection.
	
]

{ #category : #asserting }
GQLTest >> assertComments: aComments equals: aArray [
	| valueComments |
	valueComments := aComments collect: [ :comment | comment value ].
	self assertCollection: valueComments hasSameElements: aArray.
]

{ #category : #asserting }
GQLTest >> assertCommentsFields: fields equals: aArray [
	| aComments |
	aComments := OrderedCollection new.
	fields do: [ :field | aComments addAll: field comments ].
	self assertComments: aComments equals: aArray.
]

{ #category : #asserting }
GQLTest >> assertJSONEquals: aJsonString1 and: aJsonString2 [
	self 
		assert: (GraphQLPlatform current jsonFromString: aJsonString1) = (GraphQLPlatform current jsonFromString: aJsonString2)
]

{ #category : #converting }
GQLTest >> assertList: aList class: aClass [
	aList do: [ :element | self assert: element class: aClass. ].
]

{ #category : #parsing }
GQLTest >> assertList: aList withValues: aCollection [

	self assert: (aList collect: #value) equals: aCollection 
]

{ #category : #parsing }
GQLTest >> assertObjectField: anObject withNames: aCollection [

	self assert: (anObject objectFields collect: #name) equals: aCollection.
	
]

{ #category : #parsing }
GQLTest >> assertObjectField: anObject withValues: aCollection [

	self assert: ((anObject objectFields collect: #value) collect: #value) equals: aCollection.
]

{ #category : #parsing }
GQLTest >> assertSelections: aField withNames: aCollection [

	| values |
	values := aField selectionSet selections collect: #name.
	self assert: values equals: aCollection.
	
]

{ #category : #parsing }
GQLTest >> attendRequest: text [

	^ self attendRequest: text using: nil with: ''.
]

{ #category : #parsing }
GQLTest >> attendRequest: text using: operationName with: textVariables [

	^ self attendRequest: text using: operationName  with: textVariables  root: rootInstance
]

{ #category : #parsing }
GQLTest >> attendRequest: text using: operationName with: textVariables root: root [
	"The result is added a dictionary with the key 'data' according the specification found in: http://facebook.github.io/graphql/draft/#ExecuteQuery()"
	| document context variables result |
	document := self parseRequest: text.
	textVariables isEmpty 
	ifFalse:[ variables := self parseVariables: textVariables ]
	ifTrue: [ variables := nil ].
	context := GQLContext new addFragments: document fragments; 
					operationName: operationName; 
					variables: variables.
	result := document executeOn: root with: context using: schema.
	withData 
		ifTrue: [ ^ result ].
	^ result at: 'data'
]

{ #category : #parsing }
GQLTest >> jsonRequest: aRequest [
	^ self operation: nil jsonRequest: aRequest
]

{ #category : #parsing }
GQLTest >> operation: operation jsonRequest: aRequest [
	^ self operation: operation variables: '' jsonRequest: aRequest
]

{ #category : #parsing }
GQLTest >> operation: operation variables: variables jsonRequest: aRequest [
	| result |
	result := self attendRequest: aRequest using: operation with: variables.
	^ GraphQLPlatform current toJson: result.
]

{ #category : #parsing }
GQLTest >> parseRequest: text [
	
	^ self requestEvaluator parse: text.
]

{ #category : #parsing }
GQLTest >> parseSchema: text [

	^ self schemaEvaluator parse: text.
]

{ #category : #parsing }
GQLTest >> parseVariables: text [
	
	^ self variableEvaluator parse: text.
]

{ #category : #parsing }
GQLTest >> requestEvaluator [
	^ GQLRequestGrammarEvaluator
]

{ #category : #parsing }
GQLTest >> schemaEvaluator [

	^ GQLSchemaGrammarEvaluator
]

{ #category : #'as yet unclassified' }
GQLTest >> validateSchemaOf: dictionary withKey: keySchema [ 
	| aSchema |
	dictionary at: keySchema 
	ifPresent: [ :value |
		| schemas resolvers |
		schemas := value first.
		resolvers := value second.
		aSchema := self validatedSchemaExtension: schemas with: resolvers.
		(aSchema isKindOf: GQLSSchemaNode)
		ifTrue: [ 
			aSchema root: value third.
			rootInstance := value third
		]
	] 
	ifAbsent: [ aSchema := nil ].
	^ aSchema.
]

{ #category : #'as yet unclassified' }
GQLTest >> validatedSchemaExtension: arraySchema with: resolvers [
	| schemaNodes |
	schemaNodes := OrderedCollection new.
	arraySchema do: [ :aTextSchema | 
		| schemaNode |
		schemaNode := self schemaEvaluator parse: aTextSchema.
		(schemaNode isKindOf: PPFailure)
		ifTrue: [ ^ schemaNode  ]
		ifFalse: [ schemaNodes add: schemaNode ]
	].
	^ schemaNodes first validate: schemaNodes allButFirst with: resolvers.
]

{ #category : #parsing }
GQLTest >> variableEvaluator [
	^ GQLVariableGrammarEvaluator 
]
