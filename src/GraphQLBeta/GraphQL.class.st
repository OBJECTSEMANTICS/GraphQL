"
I handle a request given a schema and an entry point. For default the schema will be always in the class side of the class Query.

Public API and Key Messages

- createSchema: 
- handleRequest:
- schema
- schema:

Internal Representation and Key Implementation Points.

    Instance Variables
	rootInstance:		<Query>
	schema:		<GQLSchema>
	validator:		<GQLTypeValidator>


    Implementation Points
"
Class {
	#name : #GraphQL,
	#superclass : #GraphQLObject,
	#instVars : [
		'rootInstance',
		'schema',
		'context',
		'shouldValidate',
		'variables',
		'operation'
	],
	#category : #'GraphQLBeta-Core'
}

{ #category : #accessing }
GraphQL class >> blockJsonBuilder [
	^ [ :object |
	ZnEntity
		with: ((String streamContents: [ :stream |
			(NeoJSONWriter on: stream)
				mapInstVarsFor: GQLPosition;
				mapInstVarsFor: GQLError;
				nextPut: object.
			stream cr ]) replaceAll: Character cr with: Character lf)
		type: ZnMimeType applicationJson ].
]

{ #category : #accessing }
GraphQL class >> mapper [
	^ {
   [ :request |
      request uri isSlash and: [ request method = #GET ] ]
   ->
   [ :request :demo |
      demo answerTo: request ].
"----------------------------------------------------------------"
   [ :request |
      (request uri isSlash
         and: [ request method = #POST ])
         and: [ request contentType sub = ZnMimeType applicationJson sub ] ]
   ->
   [ :request :demo |
	 	| response |
		response := demo answerForTools: request.
      ZnResponse ok: (GraphQL blockJsonBuilder value: response). ].
"----------------------------------------------------------------"
   [ :request |
      (request uri pathSegments size = 1
         and: [ request method = #PUT ])
         and: [ request contentType = ZnMimeType applicationJson ]]
   ->
   [ :request | 
      ZnResponse ok: (GraphQL blockJsonBuilder value: Dictionary new) ].
"----------------------------------------------------------------"
   [ :request |
      request uri pathSegments size = 1
         and: [ request method = #DELETE ] ]
   ->
   [ :request |
      ZnResponse ok: (GraphQL blockJsonBuilder value: Dictionary new) ].
}.
]

{ #category : #initialization }
GraphQL >> createSchema: aTextSchema [
"Given a text schema, parses this text if everything is ok then evaluate this nodes and the schema is validated"

	schema := GQLSchemaGrammarEvaluator
		parse: aTextSchema.
	(schema isKindOf: PPFailure)
		ifTrue: [ ^ GQLEvaluationException new messageText: 'Fail parsing on schema'; raise. ]
		ifFalse: [ 
	schema := schema validate.
	(schema isKindOf: GQLValidationException)
		ifTrue: [ ^ schema ]	
		 ]
	
]

{ #category : #accessing }
GraphQL >> evaluateVariables: aObject [
	| variables |
	variables := nil.
	(aObject isString and: [ aObject isNotEmpty ]) ifTrue: [ 
		^ GQLVariableGrammarEvaluator parse: aObject	
	]. 
	(aObject isKindOf: Dictionary) ifTrue: [ 
		^ self evaluateVariables: (GraphQL blockJsonBuilder value: aObject) string.
	].
	^ variables 
]

{ #category : #accessing }
GraphQL >> handleRequest: aTextRequest [
	| document vars  |
	schema root: (rootInstance class = Dictionary 
		ifTrue: [ rootInstance at: 'query' ]
		ifFalse: [ rootInstance ])."This hack for tests, need to review this"
	document := GQLSingleAnonimousQueryEvaluator parse: aTextRequest.
	(document isKindOf: PPFailure) ifTrue: [ ^ document asJsonDictionary ].
	vars := self evaluateVariables: variables.
	^ GQLValidator new
		variables: vars;
		operationName: operation;
		rootInstance: rootInstance;
		document: document;
		text: aTextRequest;
		schema: schema;
		shouldValidate: shouldValidate;
		execute.
	
]

{ #category : #initialization }
GraphQL >> initialize [
"Initialize the validator and the entry point with the default schema"
	rootInstance := Dictionary new.
	rootInstance at: 'query' put: GQLQuery new;
					at: 'mutation' put: GQLMutation new.
	self createSchema: GQLQuery schema.
	shouldValidate := true.
]

{ #category : #accessing }
GraphQL >> jsonRequest: aTextRequest [

	^ GraphQLPlatform current toJson: (self handleRequest: aTextRequest).
]

{ #category : #accessing }
GraphQL >> operation: string [
	operation := string
]

{ #category : #initialization }
GraphQL >> rootInstance: aRoot [
"Set the root instance of graphql server"
	rootInstance := aRoot
]

{ #category : #accessing }
GraphQL >> schema [
"Return the schema"
	^ schema
]

{ #category : #accessing }
GraphQL >> schema: aGQLSchema [
"Set the schema"
	schema := aGQLSchema
]

{ #category : #accessing }
GraphQL >> shouldValidate: bool [
	shouldValidate := bool
]

{ #category : #accessing }
GraphQL >> variables: string [
	variables := string
]
