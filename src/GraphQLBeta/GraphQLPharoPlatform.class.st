"
I am the current pharo platform
"
Class {
	#name : #GraphQLPharoPlatform,
	#superclass : #GraphQLPlatform,
	#category : #'GraphQLBeta-Pharo'
}

{ #category : #testing }
GraphQLPharoPlatform class >> isActive [
	^ true
]

{ #category : #'accessing - classes' }
GraphQLPharoPlatform >> classAt: symbol [
	^ Smalltalk at: symbol
]

{ #category : #'accessing - classes' }
GraphQLPharoPlatform >> jsonFromString: string [
	^ NeoJSONReader fromString: string
]

{ #category : #'accessing - classes' }
GraphQLPharoPlatform >> jsonWriter [
	^ NeoJSONWriter
]

{ #category : #server }
GraphQLPharoPlatform >> okResponse: string [
	^ ZnResponse ok: (ZnEntity html: string)
]

{ #category : #server }
GraphQLPharoPlatform >> registerDemoServer: demo [
	| mapper |
	mapper := GraphQL mapper.
	(ZnServer startDefaultOn: 8888)
		onRequestRespond: [ :request |
			(mapper detect: [ :each | each key value: request ]
            ifNone: [ nil ])
         ifNil: [ ZnResponse badRequest: request ]
         ifNotNil: [ :handler | 
			[handler value valueWithArguments: (Array with: request with: demo)] 
				on: Error 
				do: [ :ex | self serverErrorResponse: ex ] ] 
		].
]

{ #category : #server }
GraphQLPharoPlatform >> request: aRequest at: nameQuery [
	^ (aRequest requestLine uri query at: nameQuery ifAbsent: ['']) trimBoth
]

{ #category : #server }
GraphQLPharoPlatform >> serverErrorResponse: error [
	^ ZnResponse serverError: (self printError: error)
]

{ #category : #server }
GraphQLPharoPlatform >> serverStop [
	ZnServer stopDefault
]

{ #category : #'accessing - classes' }
GraphQLPharoPlatform >> toJson: anObject [
	^ String streamContents: [ :out |
		(NeoJSONWriter on: out)
			prettyPrint: true;
			mapInstVarsFor: GQLPosition;
			mapInstVarsFor: GQLError;
			nextPut: anObject ].
]
