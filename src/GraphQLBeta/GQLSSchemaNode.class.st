"
I represent a schema node, I have different types.

Public API and Key Messages

- addTypes:
- getType:
- types
- validate

    Instance Variables
	scalarTypes:		<Dictionary>
	schemaTypes:		<Dictionary>


    Implementation Points
"
Class {
	#name : #GQLSSchemaNode,
	#superclass : #GQLSNode,
	#instVars : [
		'schemaTypes',
		'scalarTypes',
		'defaultDirectives',
		'root',
		'query',
		'schemaDefinitions',
		'schemaExtensions',
		'typeExtensions',
		'dictFieldsWithResolvers',
		'scalarTypesToDefine'
	],
	#classInstVars : [
		'metaSchema',
		'dictNameTypesMetaSchema'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #accessing }
GQLSSchemaNode class >> dictNameTypesMetaSchema [
	^ dictNameTypesMetaSchema ifNil: [ 
		dictNameTypesMetaSchema := Dictionary new
		at: 'Schema' put: 'GQLSSchemaNode';
		at: 'Type' put: #('GQLSTypeNode' 'GQLSEnumTypeNode' 'GQLSInterfaceTypeNode' 'GQLSInputObjectTypeNode' 'GQLSInputObjectFieldNode' 'GQLSObjectTypeNode' 'GQLSStringTypeNode' 'GQLSUnionTypeNode' 'GQLSIntTypeNode' 'GQLSNonNullTypeNode' 'GQLSIDTypeNode' 'GQLSListTypeNode' 'GQLSBooleanTypeNode' 'GQLSFloatTypeNode');
		at: 'Field' put: 'GQLSFieldNode';
		at: 'InputValue' put: 'GQLSInputObjectFieldNode';
		at: 'EnumValue' put: 'GQLSEnumValue';
		at: 'Directive' put: 'GQLSDirectiveNode';
		yourself.
		dictNameTypesMetaSchema keys copy do: [ :k |
			dictNameTypesMetaSchema at: '__', k put: (dictNameTypesMetaSchema at: k). ].
		dictNameTypesMetaSchema	
	].
	
]

{ #category : #'class initialization' }
GQLSSchemaNode class >> initialize [
	dictNameTypesMetaSchema := nil.
	metaSchema := nil
]

{ #category : #accessing }
GQLSSchemaNode class >> metaSchema [
	metaSchema ifNil: [ 
		metaSchema := 
		GQLSchemaGrammarEvaluator parse: '
 	type GQLSSchemaNode {
  		types: [GQLSTypeNode!]!
  		queryType: GQLSTypeNode!
  		mutationType: GQLSTypeNode
  		subscriptionType:  GQLSTypeNode
  		directives: [GQLSDirectiveNode!]!
	}

	type GQLSTypeNode {
  		kind: __TypeKind!
  		name: String
  		description: String

	  	# OBJECT and INTERFACE only
  	  	fields(includeDeprecated: Boolean): [GQLSFieldNode!]

  		# OBJECT only
	  	interfaces: [GQLSTypeNode!]

		# INTERFACE and UNION only
  		possibleTypes: [GQLSTypeNode!]

  		# ENUM only
  		enumValues(includeDeprecated: Boolean): [GQLSEnumValue!]

  		# INPUT_OBJECT only
  		inputFields: [GQLSInputObjectFieldNode!]

  		# NON_NULL and LIST only
  		ofType: GQLSTypeNode
	}

	type GQLSFieldNode {
  		name: String!
  		description: String
  		args: [GQLSInputObjectFieldNode!]!
  		type: GQLSTypeNode!
  		isDeprecated: Boolean!
  		deprecationReason: String
	}

	type GQLSInputObjectFieldNode {
  		name: String!
  		description: String
  		type: GQLSTypeNode!
  		defaultValue: String
	}

	type GQLSEnumValue {
  		name: String!
  		description: String
  		isDeprecated: Boolean!
  		deprecationReason: String
	}

	enum __TypeKind {
  		SCALAR
  		OBJECT
  		INTERFACE
  		UNION
  		ENUM
  		INPUT_OBJECT
  		LIST
  		NON_NULL
	}

	type GQLSDirectiveNode {
  		name: String!
  		description: String
  		locations: [__DirectiveLocation!]!
  		args: [GQLSInputObjectFieldNode!]!
	}

	enum __DirectiveLocation {
  		QUERY
  		MUTATION
  		SUBSCRIPTION
  		FIELD
  		FRAGMENT_DEFINITION
  		FRAGMENT_SPREAD
  		INLINE_FRAGMENT
  		SCHEMA
  		SCALAR
  		OBJECT
  		FIELD_DEFINITION
  		ARGUMENT_DEFINITION
  		INTERFACE
  		UNION
  		ENUM
  		ENUM_VALUE
  		INPUT_OBJECT
  		INPUT_FIELD_DEFINITION
	}'].
	^ metaSchema 
]

{ #category : #accessing }
GQLSSchemaNode class >> typeOfName: aString [
	self dictNameTypesMetaSchema 
		at: aString
		ifPresent: [ :val | 
			^ val isArray 
				ifTrue: [ val first ]
				ifFalse: [ val ].
		] ifAbsent: [ 
			dictNameTypesMetaSchema valuesDo: [ :val |
				val isArray ifTrue: [ 
					val detect: [ :aName | aName = aString ]
					ifFound: [ ^ 'GQLSTypeNode'. ].
				]
			].
		].
	^ nil.
	
]

{ #category : #adding }
GQLSSchemaNode >> addImplementors [
	schemaTypes 
		select: #isInterfaceType 
		thenDo: [:type | type implementors: OrderedCollection new ].
	schemaTypes
		select: #isObjectType
		thenDo: [ :type | 
			type interfaces do: [ :s |
				| interface |
				interface := schemaTypes at: s.
				interface ifNil: [ ^ GQLValidationException new
				node: type;
				messageText: 'Error: Invalid schema'; raise ].
				interface implementors add: type ] ].
]

{ #category : #adding }
GQLSSchemaNode >> addScalarsInSchema [
	scalarTypes keys do: [ :scalarTypeName |
		schemaTypes at: scalarTypeName put: (scalarTypes at: scalarTypeName)
	]
]

{ #category : #adding }
GQLSSchemaNode >> addSchemaExtensions: aSchemaExtensions [
	(aSchemaExtensions isNotNil and: [ aSchemaExtensions isNotEmpty ]) 
	ifTrue: [ 
		schemaExtensions isNotEmpty ifTrue: [ 
			aSchemaExtensions do: [ :aSchemaExt | 
				schemaExtensions first rootOperationTypes addAll: aSchemaExt rootOperationTypes
			]
		] ifFalse: [ 
			schemaExtensions := aSchemaExtensions 
		]	
	] 
	
]

{ #category : #adding }
GQLSSchemaNode >> addTypeExtensions: aCollection [
"Given a collection puts the values on a dictionary for improve the search"
	| conditionBlock |
	conditionBlock := [ :item | item value class = GQLSSchemaDefinitionNode ].
	self schemaExtensions: (aCollection 
	select: conditionBlock 
	thenCollect: [:item | item value]).
	aCollection reject:conditionBlock  
	thenDo: [ :item |
		typeExtensions at: item name put: item value ].
]

{ #category : #adding }
GQLSSchemaNode >> addTypeExtensions: dictTypeExtension with: resolvers [
	| keysSchemaTypes |
	keysSchemaTypes := schemaTypes keys.
	dictTypeExtension associations do: [ :assoc |
		(keysSchemaTypes includes: assoc key)
		ifTrue: [ 
			| res  |
			res := ((schemaTypes at: assoc key) verifyAndInclude: assoc value with: resolvers ).
			(res isKindOf: GQLValidationException) 
			ifTrue: [ ^ res ] 
			ifFalse: [ 
				( res isKindOf: Dictionary ) ifTrue: [ 
				dictFieldsWithResolvers addAll: res ]
			].
		] ifFalse: [ 
			^ GQLValidationException new node: assoc value;
					messageText: 'The namedType has not been defined'; raise
		]
	]
	
]

{ #category : #adding }
GQLSSchemaNode >> addTypeSystemExtension: schemaNode with: resolvers [
	| blockCondition |
	blockCondition := [ :value | (value isKindOf: GQLValidationException) 
		ifTrue: [ ^ value ]].
	blockCondition value: ( self addSchemaExtensions: schemaNode schemaExtensions).
	blockCondition value: ( self addTypes: schemaNode schemaTypes with: resolvers).
	blockCondition value: (  self addTypeExtensions: schemaNode typeExtensions with: resolvers ).
]

{ #category : #adding }
GQLSSchemaNode >> addTypes: aCollection [
"Given a collection puts the values on a dictionary for improve the search"
	self schemaDefinitions: (aCollection select: [ :item | item class = GQLSSchemaDefinitionNode ]).
	aCollection reject: [ :type | type class = GQLSSchemaDefinitionNode ] 
	thenDo: [ :type | schemaTypes at: type name put: type ]
]

{ #category : #adding }
GQLSSchemaNode >> addTypes: dictTypes with: resolvers [
	dictTypes ifNotNil: [ 
	dictTypes associations do: [ :assoc |
		(schemaTypes includesKey: assoc key)
		ifTrue: [ 
			| res  |
			res := ((schemaTypes at: assoc key) verifyAndInclude: assoc value with: resolvers ).
			(res isKindOf: GQLValidationException) 
			ifTrue: [ ^ res ] 
			ifFalse: [ dictFieldsWithResolvers addAll: res ].
		] ifFalse: [ 
			schemaTypes add: assoc.
		]
	]
]
	
]

{ #category : #'as yet unclassified' }
GQLSSchemaNode >> dictFieldsResolvers [
	^ dictFieldsWithResolvers 
]

{ #category : #accessing }
GQLSSchemaNode >> directives [ 
	^ defaultDirectives values
]

{ #category : #accessing }
GQLSSchemaNode >> getDirective: aDirectiveName [
	"Return the directive corresponding to the given directive name"

	(defaultDirectives includesKey: aDirectiveName asString)
		ifTrue: [ ^ defaultDirectives at: aDirectiveName asString].
	^ nil
		
	

]

{ #category : #accessing }
GQLSSchemaNode >> getInterface: anInterfaceName [
	"Return the interface corresponding to the given name"

	((schemaTypes includesKey: anInterfaceName asString)
		and: [ (schemaTypes at: anInterfaceName asString) isInterfaceType ])
		ifTrue: [ ^ schemaTypes at: anInterfaceName asString].
]

{ #category : #adding }
GQLSSchemaNode >> getNameType: aString [
	| typeName |
	typeName := GQLSSchemaNode typeOfName: aString.
	typeName ifNotNil: [ ^ self getType: typeName ] 
	ifNil: [ 
		typeName := (aString , 'Input').
		schemaTypes at: typeName ifPresent: 
		[ :value | value class = GQLSInputObjectTypeNode 
				ifTrue: [ ^ schemaTypes at: typeName ] ].
	^ scalarTypes 
		at: aString
		ifAbsent: [ nil ]	
	].
]

{ #category : #accessing }
GQLSSchemaNode >> getType: aTypeName [
	"Return the type corresponding to the given type name"
	| typeNameString |
	typeNameString := aTypeName asString.
	(schemaTypes includesKey: typeNameString)
		ifTrue: [ ^ schemaTypes at: typeNameString ].
		^ self getNameType:typeNameString
]

{ #category : #accessing }
GQLSSchemaNode >> getTypeExtension: aTypeExtensionName [
	"Return the extension type corresponding to the given type extension name"
	^ typeExtensions at: aTypeExtensionName	
]

{ #category : #inspector }
GQLSSchemaNode >> gtTextIn: composite [
	<gtInspectorPresentationOrder: -10>
	
	composite text
		title: 'Schema';
		display: [ 
			| s |
			s := String new writeStream.
			self printOn: s.
			s contents ]
]

{ #category : #initialization }
GQLSSchemaNode >> initialize [
	super initialize.
	self initializeScalarTypes.
	self initializeDefaultDirectives.
	schemaDefinitions := (OrderedCollection new add: GQLSSchemaDefinitionNode new; yourself).
	schemaTypes := Dictionary new.
	schemaExtensions := OrderedCollection new.
	typeExtensions := Dictionary new.
	dictFieldsWithResolvers := Dictionary new.
]

{ #category : #initialization }
GQLSSchemaNode >> initializeDefaultDirectives [
	| args locations |
	defaultDirectives := Dictionary new.
	locations := Array 
		with: GQLNonScalarFieldNode 
		with: GQLScalarFieldNode 
		with: GQLFragmentSpreadNode 
		with: GQLInlineFragmentNode.
	args := Array with: (GQLSInputObjectFieldNode new
		name: 'if';
		type: (GQLSNonNullTypeNode new 
			wrappedType: GQLSBooleanTypeNode new) ).

	defaultDirectives at: 'skip' put: (GQLSDirectiveNode new
		name: 'skip';
		arguments: args;
		directiveLocations: locations).
	defaultDirectives at: 'include' put: (GQLSDirectiveNode new
		name: 'include';
		arguments: args;
		directiveLocations: locations)
	
]

{ #category : #initialization }
GQLSSchemaNode >> initializeScalarTypes [
	"Creates a dictionary with the default scalar types"

	scalarTypes := Dictionary new.
	scalarTypes at: 'Int' put: GQLSIntTypeNode new.
	scalarTypes at: 'String' put: GQLSStringTypeNode new.
	scalarTypes at: 'ID' put: GQLSIDTypeNode new.
	scalarTypes at: 'Boolean' put: GQLSBooleanTypeNode new.
	scalarTypes at: 'Float' put: GQLSFloatTypeNode new
]

{ #category : #'as yet unclassified' }
GQLSSchemaNode >> mutationType [
	^ schemaDefinitions first rootOperationTypes 
	at: 'mutation'
	ifPresent: [ :val | schemaTypes at: val first name ]
	ifAbsent: [ nil ]
]

{ #category : #printing }
GQLSSchemaNode >> printOn: stream [
	stream 
		nextPutAll: 'schema{'; cr; tab; 
		nextPutAll: 'query: '.
	self query printOn: stream.
	stream cr; nextPutAll: '}'; cr.
	
	self schemaTypes do: [ :t | 
		t printFullOn: stream.
		stream cr. ].
]

{ #category : #accessing }
GQLSSchemaNode >> query [
	^ query
]

{ #category : #'as yet unclassified' }
GQLSSchemaNode >> queryType [
	^ schemaTypes at: (schemaDefinitions first rootOperationTypes at: 'query') first name
]

{ #category : #accessing }
GQLSSchemaNode >> root: anInstance [
"Set an instance as root and his class as the query"
	root := anInstance.
	query := self
		getType: anInstance class name
]

{ #category : #accessing }
GQLSSchemaNode >> schemaDefinitions [
	^ schemaDefinitions
]

{ #category : #accessing }
GQLSSchemaNode >> schemaDefinitions: aSchemaDefinitions [
	aSchemaDefinitions isNotEmpty ifTrue: [ 
		schemaDefinitions := aSchemaDefinitions 
	]
]

{ #category : #accessing }
GQLSSchemaNode >> schemaExtensions [
	^ schemaExtensions
]

{ #category : #accessing }
GQLSSchemaNode >> schemaExtensions: anObject [
	schemaExtensions := anObject
]

{ #category : #accessing }
GQLSSchemaNode >> schemaTypes [
"Return the types"

	^ schemaTypes
]

{ #category : #'as yet unclassified' }
GQLSSchemaNode >> subscriptionType [
	^ schemaDefinitions first rootOperationTypes 
	at: 'subscription'
	ifPresent: [ :val | schemaTypes at: val first name ]
	ifAbsent: [ nil ]
]

{ #category : #accessing }
GQLSSchemaNode >> typeExtensions [
	^ typeExtensions 
]

{ #category : #accessing }
GQLSSchemaNode >> types [
"Return the types"
	^ schemaTypes values
]

{ #category : #'development support' }
GQLSSchemaNode >> validate [
	"Verify that all the input types and types exist on smalltalk, interfaces has uniqueness field names and all types implemented interfaces satisfy the object type validation."
	^ self validate: nil with: (Array new: 0)
	
]

{ #category : #'as yet unclassified' }
GQLSSchemaNode >> validate: schemaNodes with: resolvers [
	"Verify that all the input types and types exist on smalltalk, interfaces has uniqueness field names and all types implemented interfaces satisfy the object type validation."
	| validators blockCondition |
	blockCondition := [ :value | (value isKindOf: GQLValidationException) 
		ifTrue: [ ^ value ]].
	blockCondition value: (self addTypeSystemExtension: GQLSSchemaNode metaSchema with: (Array new: 0)).
	(schemaNodes isNil or: [ schemaNodes isEmpty ]) ifTrue: [ 
		blockCondition value: (self addSchemaExtensions: schemaExtensions).
		blockCondition value: (self addTypeExtensions: typeExtensions with: resolvers).
		blockCondition value: (self addScalarsInSchema) ] 
	ifFalse: [ 
	schemaNodes do: [ :schemaNode | 
		blockCondition value: (self addTypeSystemExtension: schemaNode with: resolvers)
	] ].
	blockCondition value: (self addImplementors).
	validators := Array with: #validateSchemaDefinition
							with: #validateSchemaExtensions
							with: #validateWithImage 
							with: #validateObjectTypes
							with: #validateUnionTypes.
	validators do: [ :validator | blockCondition value: (self perform: validator ) ]
]

{ #category : #'development support' }
GQLSSchemaNode >> validateObjectTypes [
"Return self if all the object types that implemented interfaces are consistent, if not raise a GQLValidationException"	
	| objectTypes interfaces |
	objectTypes := self types select: #isObjectType.
	objectTypes detect: [ :objectType | | fields |
		fields := Set new.
		interfaces := Set new.
		objectType interfaces do: [ :nameInterface | 
				| interface |
				interface := self getInterface: nameInterface.
				fields addAll: interface fields values.
				interfaces add: interface.
		].
		objectType interfaces: interfaces.
		(objectType implementsFields: fields) not ]
				ifFound: [ :objectType | 
					^ GQLValidationException new node: objectType;
													messageText: 'Missing fields on object type 
													for implementing interface'; raise ].
]

{ #category : #'development support' }
GQLSSchemaNode >> validateRootOpTypes: aAssociations [
"Return the object types or input objects"
	| keyValidTypes includesQuery |
	includesQuery := false.
	keyValidTypes := self validatedTypes keys.
	aAssociations do: [ :assoc | 
		(keyValidTypes includes: assoc value) 
		ifFalse: [ "self halt." ^ GQLValidationException new node: GQLSSchemaDefinitionNode; messageText: 'Error: Specified ', assoc key, ' type \"', assoc value, '\" not found in document'; raise ].
		includesQuery := includesQuery or: [assoc key = 'query'].
	].
	includesQuery ifFalse: [ ^ GQLValidationException new node: GQLSSchemaDefinitionNode; messageText: 'Must provide a query root'; raise ]
]

{ #category : #'as yet unclassified' }
GQLSSchemaNode >> validateRootSchemaDefinition: aRootOpTypes [
	aRootOpTypes associations detect: [ :assoc | 
		assoc value size > 1  ]
	ifFound: [ :assoc | 
		^ GQLValidationException new node: assoc value;
						messageText: 'Must provide only one ', assoc key,' type in schema'; raise ]
	ifNone: [  
		^ self validateRootOpTypes: (aRootOpTypes associations 
		select: [ :assoc | assoc value isNotEmpty ] 
		thenCollect: [:assoc | assoc key -> assoc value first name])
	]
]

{ #category : #'development support' }
GQLSSchemaNode >> validateSchemaDefinition [
	"Return self if all the object types that implemented interfaces are consistent, if not raise a GQLValidationException"	
	| rootOpTypes |
	self schemaDefinitions size ~= 1 ifTrue: [ 
		^ GQLValidationException new node: GQLSSchemaDefinitionNode;
						messageText: 'Error: Must provide only one schema definition.'; raise 
	].
	rootOpTypes := self schemaDefinitions first rootOperationTypes.
	^ self validateRootSchemaDefinition: rootOpTypes.
]

{ #category : #'as yet unclassified' }
GQLSSchemaNode >> validateSchemaExtensions [
	"Return self if the schemaExtension is only, if not raise a GQLValidationException"	
	schemaExtensions ifNotEmpty: [ 
	^ self validateRootSchemaDefinition: (schemaDefinitions first rootOperationTypes addAll: schemaExtensions first rootOperationTypes; yourself).
	]
]

{ #category : #'development support' }
GQLSSchemaNode >> validateUnionTypes [
"Return self if all the union types has values as object types, if not raise a GQLValidationException"
	| unions |
	unions := self types select: #isUnionType.
	unions detect: [ :union | (union namedTypes allSatisfy: 
												[ :name | (self getType: name) isObjectType ]) not ]
			ifFound: [ :union | ^ GQLValidationException new
									node: union;
									messageText: 'The values of union are not object type';
									raise ].
	unions do: [ :union | 
		union namedTypes collect: [ :name | (self getType: name) ] 
		thenDo: [ :types | union addPossibleType: types ]
	].
	^ self
	
]

{ #category : #'development support' }
GQLSSchemaNode >> validateWithImage [
"Return self if all the types exist on the smalltalk image and also the fields, if not raise a GQLValidationException"
	| allClasses |
	allClasses := Smalltalk globals allClasses.
	self validatedTypes do: [ :assoc | 
		| class fields nameAssoc |
		nameAssoc := assoc name.
		(nameAssoc endsWith: 'Input') 
		ifTrue: [ nameAssoc := nameAssoc copyFrom: 1 to: nameAssoc size - 5].
		nameAssoc := nameAssoc asSymbol.
		
		class := allClasses 
			detect: [ :c | c name = nameAssoc ]
			ifNone: [ ^ GQLValidationException new
				node: assoc value;
				messageClassText ].
		fields := assoc value fields values.
		fields do: [ :field | 
			class allMethods
				detect: [ :method | method selector = field fullName asSymbol ]
				ifNone: [ 
					dictFieldsWithResolvers at: field fullName asSymbol
					ifAbsent: [ ^ GQLValidationException new
					node: field;
					messageMethodText: assoc ] ] ]
		].
]

{ #category : #accessing }
GQLSSchemaNode >> validatedTypes [
"Return the object types or input objects"

	^ schemaTypes select: #isValidateClass
]
