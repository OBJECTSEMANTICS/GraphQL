"
I am a class for compatibility between different types of smalltalk, like VisualWorks
"
Class {
	#name : #GraphQLPlatform,
	#superclass : #Object,
	#classInstVars : [
		'instance'
	],
	#category : #'GraphQLBeta-Core'
}

{ #category : #accessing }
GraphQLPlatform class >> current [
	^ instance ifNil: [ instance := (self subclasses select: [ :cls | cls isActive ]) first new ].
]

{ #category : #'accessing - classes' }
GraphQLPlatform >> classAt: symbol [
	self subclassResponsibility 
]

{ #category : #'accessing - classes' }
GraphQLPlatform >> jsonFromString: string [
	self subclassResponsibility 
]

{ #category : #'accessing - classes' }
GraphQLPlatform >> jsonWriter [
	self subclassResponsibility
]

{ #category : #server }
GraphQLPlatform >> okResponse: string [
	self subclassResponsibility
]

{ #category : #'printing format' }
GraphQLPlatform >> printError: ex [
	| s |
	s := String new writeStream.
	[s 
		nextPutAll: ex asString;cr;
		nextPutAll: (String streamContents: [:stream | 
			ex signalerContext ifNotNil: [ :context |
				context debugStackOn: stream ] ] ) ] ensure: [ s close ].
	^ s contents
]

{ #category : #server }
GraphQLPlatform >> registerDemoServer: demo [
	self subclassResponsibility
]

{ #category : #server }
GraphQLPlatform >> request: aRequest at: nameQuery [
	self subclassResponsibility
]

{ #category : #server }
GraphQLPlatform >> serverErrorResponse: string [
	self subclassResponsibility 
]

{ #category : #server }
GraphQLPlatform >> serverStop [
	self subclassResponsibility
]

{ #category : #'accessing - classes' }
GraphQLPlatform >> toJson: object [
	self subclassResponsibility
]
