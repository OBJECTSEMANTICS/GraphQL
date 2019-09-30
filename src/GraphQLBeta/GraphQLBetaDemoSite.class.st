"
I am a class that creates a simple demo webapp that responds to requets and create the language of graphql
"
Class {
	#name : #GraphQLBetaDemoSite,
	#superclass : #Object,
	#instVars : [
		'graphql'
	],
	#category : #'GraphQLBeta-Demo'
}

{ #category : #demo }
GraphQLBetaDemoSite class >> demoStart [
	<script: 'self demoStart'>
	| inst |
	inst := self new.
	
	GraphQLPlatform current registerDemoServer: inst.
	inst configure.
	self inform: 'demo start'.
]

{ #category : #demo }
GraphQLBetaDemoSite class >> demoStop [
	<script: 'self demoStop'>
	GraphQLPlatform current serverStop.
	self inform: 'demo stop'
]

{ #category : #server }
GraphQLBetaDemoSite >> answerForTools: aRequest [
	| dict query operation variables shouldValidate |
	[dict := STON fromString: aRequest contents.] on: Error do: [ :ex| 
	dict := ZnResourceMetaUtils parseQueryFrom: aRequest contents readStream ].
	query := (self value: dict ofKey: 'query') trim.
	operation := self value: dict ofKey: 'operationName'.
	variables := self value: dict ofKey: 'variables'.
	shouldValidate := (self value: dict ofKey: 'shouldValidate') = 'true'.
	^ graphql 
		operation: operation;
		variables: variables;
		shouldValidate: shouldValidate;
		handleRequest: query
	
]

{ #category : #server }
GraphQLBetaDemoSite >> answerTo: aRequest [
	^ GraphQLPlatform current okResponse: GraphQLBetaDemoHTML htmlPage.
]

{ #category : #server }
GraphQLBetaDemoSite >> configure [
	graphql := GraphQL new.
	graphql createSchema: GQLQuery schema.
]

{ #category : #accessing }
GraphQLBetaDemoSite >> graphql [
	^ graphql
]

{ #category : #server }
GraphQLBetaDemoSite >> request: aRequest at: nameQuery [
	^ GraphQLPlatform current request: aRequest at: nameQuery.
]

{ #category : #server }
GraphQLBetaDemoSite >> value: aDict ofKey: aString [
	| response |
	response := ''.
	aDict at: aString 
	ifPresent: [:val | 
		val ifNotNil: [ response := val ]. 
	].
	^ response
]
