"
I represent a object type, i have fields and maybe some interfaces.

Public API and Key Messages

- addFields:
- fields
- getField:
- implements:
- interfaces


    Instance Variables
	fieldSet:		<Dictionary>
	interfaces:		<Array>


    Implementation Points
"
Class {
	#name : #GQLSObjectTypeNode,
	#superclass : #GQLSNamedTypeNode,
	#instVars : [
		'fieldSet',
		'interfaces'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #adding }
GQLSObjectTypeNode >> addFields: aArray [
"Given a collection puts the values on a dictionary for improve the search"
	aArray do: [ :field | fieldSet at: field name put: field ]
]

{ #category : #accessing }
GQLSObjectTypeNode >> fields [
"Return the fields"
	^ fieldSet
]

{ #category : #'as yet unclassified' }
GQLSObjectTypeNode >> fieldsIncludeDeprecated: aBoolean [
	^ self fields values
]

{ #category : #'as yet unclassified' }
GQLSObjectTypeNode >> fieldsRelated: fields to: resolvers [
	(name asClass selectors includesAll: (fields collect: [:field | field fullName asSymbol])) 
	ifFalse: [ 
	| dictFieldWithResolver |
	dictFieldWithResolver := Dictionary new.
	resolvers do: [ :resolver |
		fields
		select: [ :fieldNode | resolver selectors includes: fieldNode fullName asSymbol ]
		thenDo: [:fieldNode | 
			dictFieldWithResolver at: fieldNode fullName asSymbol ifAbsentPut: [ resolver ]
		]
	].
	dictFieldWithResolver size = fields size
	ifTrue: [ ^ dictFieldWithResolver ]
	ifFalse: [ ^ GQLValidationException new node: self;
						messageText: 'The resolvers dont find some fields defined in the schema'; 
						raise ]
	]
]

{ #category : #accessing }
GQLSObjectTypeNode >> getField: aFieldName [
	"Return the field given his name"
	^ fieldSet at: aFieldName ifAbsent: [ nil ].
]

{ #category : #accessing }
GQLSObjectTypeNode >> getFieldType: aFieldName [
	"Return the type of a field"

	| res |
	res := (fieldSet includesKey: aFieldName)
		ifTrue: [ (fieldSet at: aFieldName) type ]
		ifFalse: [ nil ].
	^ res
]

{ #category : #accessing }
GQLSObjectTypeNode >> implements: aArray [
"Set the interfaces that implements"
	aArray ifNotNil: [ interfaces := aArray collect: [ :item | item value ] ]
]

{ #category : #testing }
GQLSObjectTypeNode >> implementsFields: aCollection [
"Check if has all the fields on interface with the same arguments
HERE MUST CHECK THE TYPE OF FIELD AND ARGUMENT ACCORD: 3.1.2.3 SPEC GRAPHQL"
	^ aCollection allSatisfy: 
	[ :field | (self fields includesKey: field name) 
				and: [ (self getField: field name) arguments = field arguments ] ]
]

{ #category : #initialization }
GQLSObjectTypeNode >> initialize [
	super initialize.
	fieldSet := OrderedDictionary new.
	interfaces := Set new. 
]

{ #category : #accessing }
GQLSObjectTypeNode >> interfaces [
"Return the interfaces"
	^ interfaces
]

{ #category : #accessing }
GQLSObjectTypeNode >> interfaces: anObject [
	interfaces := anObject.
	^ interfaces
]

{ #category : #testing }
GQLSObjectTypeNode >> isObjectType [
"Return if is a object type"
	^ true
]

{ #category : #testing }
GQLSObjectTypeNode >> isValidateClass [
"Respondes if a type needs to be searched on the image of Pharo"

	^ true
]

{ #category : #accessing }
GQLSObjectTypeNode >> kind [
	^ 'OBJECT'
]

{ #category : #accessing }
GQLSObjectTypeNode >> nameOfClass: aName [
	^ aName
]

{ #category : #printing }
GQLSObjectTypeNode >> printFullOn: stream [
	stream
		nextPutAll: 'type ';
		nextPutAll: self name.
	self interfaces ifNotEmpty: [
		stream nextPutAll:  ' implements '.
		self interfaces 
			do: [ :i | 
				(i isKindOf: GQLSInterfaceTypeNode)
				ifTrue: [ stream nextPutAll: i name ]
				ifFalse: [ stream nextPutAll: i ] ]
			separatedBy: [ ":i |" stream nextPutAll: ' & ' ]  ].
	stream nextPutAll: '{'; cr.
	self fields 
		do: [ :field | 
			stream tab.
			field printFullOn: stream ] 
		separatedBy: [ stream cr ].
	stream cr; nextPutAll: '}'.
]

{ #category : #'as yet unclassified' }
GQLSObjectTypeNode >> verifyAndInclude: otherNamedType  with: resolvers [
	((otherNamedType class = self class and: 
	[ (fieldSet keys includesAny: otherNamedType fields keys) not ])
	and: [(interfaces includesAny: otherNamedType interfaces) not])
	ifTrue: [ 
		fieldSet addAll: otherNamedType fields.
		interfaces := (interfaces asOrderedCollection addAll: otherNamedType interfaces; yourself) asArray.
		^ self fieldsRelated: otherNamedType fields values to: resolvers.
	]
	ifFalse: [ ^ GQLValidationException new node: otherNamedType;
						messageText: 'The namedType is not Object type or its fields already have been defined'; 
						raise  ]
]
