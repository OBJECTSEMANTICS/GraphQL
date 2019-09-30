"
I represent the grammar of the schema.

Public API and Key Messages

-  booleanType
- field
- fieldName
- fieldSet
- fieldType
- floatType
- idType
- inputType
- listInputType
- listType
- nonNull
- objectType
- obectTypeName
- parameter
- parameterName
- parameters
- scalarType
- schema
- singleInputType
- singleType
- start
- stringType
- type
"
Class {
	#name : #GQLSchemaGrammar,
	#superclass : #GQLAbstractGrammar,
	#instVars : [
		'type',
		'listType',
		'nonNull',
		'objectType',
		'objectTypeName',
		'fieldSet',
		'fieldType',
		'field',
		'fieldName',
		'schema',
		'schemaType',
		'parameterName',
		'parameters',
		'parameter',
		'inputType',
		'ignoredSpaces',
		'listInputType',
		'enumType',
		'interfaceType',
		'unionType',
		'inputObjectType',
		'enumTypeName',
		'enumValueList',
		'interfaceTypeName',
		'unionTypeName',
		'unionValuesList',
		'fieldInputObjectSet',
		'fieldInputObject',
		'inputObjectTypeName',
		'nullValue',
		'namedType',
		'nonNullType',
		'nonNullListType',
		'nonNullNamedType',
		'baseType',
		'nonNullInputType',
		'nonNullBaseType',
		'nonNullListInputType',
		'namedInputType',
		'interfaceList',
		'blockStringCharacter',
		'blockStringDelimiter',
		'description',
		'enumValue',
		'commentsInterface',
		'schemaDefinition',
		'rootOperationTypes',
		'query',
		'mutation',
		'subscription',
		'rootOperationType',
		'extension',
		'ignoreDescriptionAndComments',
		'ignoredInExtensions',
		'typeSystemToExtend',
		'typeSystemExtension',
		'objectExtension',
		'enumTypeExtension',
		'interfaceTypeExtension',
		'unionTypeExtension',
		'inputObjectTypeExtension',
		'objectTypeExtension',
		'objectTypeExtWithInterface',
		'scalarIntrospectionType'
	],
	#category : #'GraphQLBeta-Parser'
}

{ #category : #grammar }
GQLSchemaGrammar >> baseType [
"Return a parser accepting object filed base types"

	^ scalarType / namedType
	
	"enumTypeName / objectTypeName / interfaceTypeName / unionTypeName "
]

{ #category : #grammar }
GQLSchemaGrammar >> blockStringCharacter [
	"Return a parser accepting:
	- SourceCharacter but not blockStringDelimiter or  (\,blockStringDelimiter)
	- (\,blockStringDelimiter)"

	^ (blockStringDelimiter not , ($\ asParser, blockStringDelimiter ) not
		, sourceCharacter)
		/ ($\ asParser, blockStringDelimiter ) flatten token
]

{ #category : #accessing }
GQLSchemaGrammar >> blockStringDelimiter [
	"Return a parser accepting the triple quotation symbol"

	^ ($" asParser times: 3) flatten token
]

{ #category : #grammar }
GQLSchemaGrammar >> commentsInterface [
	"Return a parser accepting the comment ignoring the ignoredSpaces"
	^ (comment trim: ignoredSpaces) star
]

{ #category : #grammar }
GQLSchemaGrammar >> description [
	"Return the description of a GraphQL service"

	^ (stringValue trim: ignoredNoComment)
]

{ #category : #grammar }
GQLSchemaGrammar >> enumType [
	"Return a parser accepting:
description enum enumTypeName enumValueList, join with the comments"

	^ comments, description optional, comments, ('enum' asParser trim: ignored),
	(enumTypeName trim: ignored), (enumValueList trim: ignoredNoComment), comments
]

{ #category : #grammar }
GQLSchemaGrammar >> enumTypeExtension [
	"Return a parser accepting:
	enum enumTypeName enumValueList, join with the comments"

	^ ('enum' asParser trim: ignored), (enumTypeName trim: ignored), (enumValueList trim: ignoredNoComment), comments
]

{ #category : #grammar }
GQLSchemaGrammar >> enumTypeName [
	"Return a token name that is not a true, false or null"

	^ (booleanValue not , nullValue not , tokenName) flatten token
]

{ #category : #grammar }
GQLSchemaGrammar >> enumValue [
	"Return a parser accepting: description tokenName, with the comments "
	^ comments, description optional, comments, (tokenName trim: ignoredNoComment), comments
]

{ #category : #grammar }
GQLSchemaGrammar >> enumValueList [
	"Return a parser accepting:
{ enumValue+ }"

	^ ${ asParser , enumValue plus , $} asParser
]

{ #category : #grammar }
GQLSchemaGrammar >> extension [
	"Return a parser accepting:
extend"

	^ 'extend' asParser trim: ignored
]

{ #category : #grammar }
GQLSchemaGrammar >> field [
"Return a parser accepting:
description fieldName parametersOptional : fieldType, with the comments"
	^ comments, description optional, comments, fieldName , (parameters trim: ignored) optional , ($: asParser trim: ignored)
		, fieldType, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> fieldInputObject [
	"Return a parser accepting:
description fieldName parametersOptional : fieldInputObjectType, with the comments"

	^ comments, description optional, comments, (fieldName trim: ignored) ,  (parameters trim: ignored) optional, ($: asParser trim: ignored) , inputType, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> fieldInputObjectSet [
	"Return a parser accepting:
{ fieldInputObject+ }"

	^ ${ asParser , (fieldInputObject trim: ignoredNoComment) plus , $} asParser
]

{ #category : #grammar }
GQLSchemaGrammar >> fieldName [
	^ tokenName 
]

{ #category : #grammar }
GQLSchemaGrammar >> fieldSet [
"Return a parser accepting:
{ field+ }"
	^ ${ asParser , (field trim: ignoredNoComment) plus , $} asParser
]

{ #category : #grammar }
GQLSchemaGrammar >> fieldType [
"Return a parser accepting baseType or wrappedType"


	^ nonNullType / baseType / listType 
]

{ #category : #grammar }
GQLSchemaGrammar >> ignoreDescriptionAndComments [
	"Return the description of a GraphQL service"

	^ ignoredInExtensions plus
]

{ #category : #grammar }
GQLSchemaGrammar >> ignoredInExtensions [
	"Return the description of a GraphQL service"

	^ description / ignored
]

{ #category : #grammar }
GQLSchemaGrammar >> ignoredSpaces [
	"Return the parsers accepting the list of things we want to ignore"

	^ comment / lineTerminator / unicodeBOM
		/ whiteSpace
]

{ #category : #grammar }
GQLSchemaGrammar >> inputObjectType [
	"Return a parser accepting:
description input inputObjectTypeName fieldSet, with the comments"

	^ comments, description optional, comments, 'input' asParser , (inputObjectTypeName trim: ignored), fieldInputObjectSet, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> inputObjectTypeExtension [
	"Return a parser accepting:
	input inputObjectTypeName fieldSet, with the comments"

	^ 'input' asParser , (inputObjectTypeName trim: ignored), fieldInputObjectSet, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> inputObjectTypeName [
"Return a token name"

	^ tokenName
	
]

{ #category : #grammar }
GQLSchemaGrammar >> inputType [

	^ nonNullInputType / namedInputType / listInputType
]

{ #category : #grammar }
GQLSchemaGrammar >> interfaceList [

	^ ('implements' asParser trim: ignored), 
	((interfaceTypeName trim: ignoredSpaces) separatedBy: ($& asParser))
]

{ #category : #grammar }
GQLSchemaGrammar >> interfaceType [
	"Return a parser accepting:
description interface interfaceTypeName fieldSet, with the comments"

	^ comments, description optional, comments, 'interface' asParser , (interfaceTypeName trim: ignored), fieldSet, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> interfaceTypeExtension [
	"Return a parser accepting:
	interface interfaceTypeName fieldSet, with the comments"

	^ 'interface' asParser , (interfaceTypeName trim: ignored), fieldSet, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> interfaceTypeName [
	"Return a token name"

	^ tokenName
]

{ #category : #grammar }
GQLSchemaGrammar >> listInputType [
"Return a parser accepting:
[ inputType ] "
	^ $[ asParser , (inputType trim: ignored) , ($] asParser trimRight: ignored)
]

{ #category : #grammar }
GQLSchemaGrammar >> listType [
	"Return a parser accepting: 
[ fieldType ]"

	^ $[ asParser , (fieldType trim: ignored) , ($] asParser trimRight: ignoredNoComment)
]

{ #category : #accessing }
GQLSchemaGrammar >> mutation [
"Return a parser accepting:
 mutation: tokenName"
	^ comments, ('mutation' asParser trim: ignored) flatten token, (':' asParser trim: ignored), (tokenName trim: ignoredNoComment), comments
	
]

{ #category : #grammar }
GQLSchemaGrammar >> namedInputType [
	"Return a token name"

	^ scalarType / namedType
]

{ #category : #grammar }
GQLSchemaGrammar >> namedType [
"Return a token name"

	^ tokenName
]

{ #category : #grammar }
GQLSchemaGrammar >> nonNull [
"Return a parser accepting !"
	^ $! asParser
]

{ #category : #grammar }
GQLSchemaGrammar >> nonNullBaseType [
	"Return a parser accepting: 
type nonNull"

	^ (baseType trim: ignored) , nonNull 
]

{ #category : #grammar }
GQLSchemaGrammar >> nonNullInputType [
	"Return a parser accepting: 
namedType nonNull"

	^ nonNullBaseType / nonNullNamedType / nonNullListInputType
]

{ #category : #grammar }
GQLSchemaGrammar >> nonNullListInputType [
	"Return a parser accepting: 
listInputType!"

	^ listInputType, nonNull
]

{ #category : #grammar }
GQLSchemaGrammar >> nonNullListType [
	"Return a parser accepting: 
listType!"

	^ listType, nonNull
]

{ #category : #grammar }
GQLSchemaGrammar >> nonNullNamedType [
	"Return a parser accepting: 
nametype nonNull"

	^ (namedType trim: ignored) , nonNull 
]

{ #category : #grammar }
GQLSchemaGrammar >> nonNullType [
	"Return a parser accepting: 
type nonNull"

	^ nonNullBaseType / nonNullListType
]

{ #category : #grammar }
GQLSchemaGrammar >> objectExtension [
	"Return a parser accepting:
objectType / interfaceList"

	^ objectTypeExtension / objectTypeExtWithInterface
]

{ #category : #accessing }
GQLSchemaGrammar >> objectType [
	"Return a parser accepting:
description type objectTypeName implementsOptional fieldSet, with the comments"

	^ comments, description optional, comments, 'type' asParser, (objectTypeName trim: ignored), interfaceList optional , fieldSet, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> objectTypeExtWithInterface [
	^ 'type' asParser, (objectTypeName trim: ignored), interfaceList, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> objectTypeExtension [
	"Return a parser accepting:
	type objectTypeName implementsOptional fieldSet, with the comments"

	^ 'type' asParser, (objectTypeName trim: ignored), interfaceList optional , fieldSet, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> objectTypeName [
"Return a token name"
	^ tokenName
]

{ #category : #grammar }
GQLSchemaGrammar >> parameter [
"Return a parser accepting: 
description parameterName : inputType, with the comments"
	^ (description trim: ignored) optional, parameterName , ($: asParser trim: ignored), inputType
]

{ #category : #grammar }
GQLSchemaGrammar >> parameterName [
"Return a token name"
	^ tokenName
]

{ #category : #grammar }
GQLSchemaGrammar >> parameters [
"Return a parser accepting: 
 ( parameter+ )"
	^ ($( asParser trimRight: ignored) , (parameter trimRight: ignored) plus , $) asParser
]

{ #category : #accessing }
GQLSchemaGrammar >> query [
"Return a parser accepting:
 query: nameOfQuery"
	^ comments, ('query' asParser trimRight: ignored) flatten token, (':' asParser trim: ignored), (tokenName trim: ignoredNoComment), comments
	
]

{ #category : #grammar }
GQLSchemaGrammar >> rootOperationType [
"Return a parser accepting:
 query, mutation, subscription "
	^ query / mutation / subscription
]

{ #category : #grammar }
GQLSchemaGrammar >> rootOperationTypes [
"Return a parser accepting:
{ query, mutation, subscription }"
	^ (${ asParser trim: ignoredNoComment), rootOperationType plus, ($} asParser trim: ignoredNoComment)
]

{ #category : #accessing }
GQLSchemaGrammar >> scalarIntrospectionType [
	"Return a parser accepting:
description type objectTypeName implementsOptional fieldSet, with the comments"

	^ comments, description optional, comments, 'scalar' asParser, (objectTypeName trim: ignored), interfaceList optional , fieldSet, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> schema [
"Return a parser accepting one or more type"
	^ (schemaType trim: ignoredNoComment) plus
]

{ #category : #grammar }
GQLSchemaGrammar >> schemaDefinition [
	"Return a parser accepting:
schema rootOperationTypes fieldSet, with the comments"

	^ comments, ('schema' asParser trim: ignored) flatten token, rootOperationTypes, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> schemaType [
	"Return a parser accepting:
- objectType
- enumType
- interfaceType
- unionType
- inputObjectType
"

	^ objectType / scalarIntrospectionType / enumType / interfaceType / unionType / inputObjectType / schemaDefinition / typeSystemExtension 
]

{ #category : #grammar }
GQLSchemaGrammar >> start [
"Return a parser accepting a schema and then the end of the input"
	^ schema end
]

{ #category : #accessing }
GQLSchemaGrammar >> stringValue [
	^ (blockStringDelimiter , blockStringCharacter star
		, blockStringDelimiter) flatten token /
	(stringDelimiter , stringCharacter star
		, stringDelimiter) flatten token
]

{ #category : #accessing }
GQLSchemaGrammar >> subscription [
"Return a parser accepting:
 subscription: nameOfSubscription"
	^ comments, ('subscription' asParser trim: ignored) flatten token, (':' asParser trim: ignored), (tokenName trim: ignoredNoComment ), comments
	
]

{ #category : #grammar }
GQLSchemaGrammar >> type [
"Return a parser accepting:
- scalarType
- objectTypeName
- enumTypeName
- interfaceTypeName
- unionTypeName"
	^ scalarType / objectTypeName / enumTypeName / interfaceTypeName / unionTypeName 
]

{ #category : #grammar }
GQLSchemaGrammar >> typeSystemExtension [
	^ comments, extension, typeSystemToExtend 
]

{ #category : #grammar }
GQLSchemaGrammar >> typeSystemToExtend [
"Return a parser accepting:
- objectType
- enumType
- interfaceType
- unionType
- inputObjectType"
	^ objectExtension / enumTypeExtension / interfaceTypeExtension / unionTypeExtension / inputObjectTypeExtension / schemaDefinition 
]

{ #category : #grammar }
GQLSchemaGrammar >> unionType [
	"Return a parser accepting:
description union unionTypeName = unionValuesList, with the comments"

	^ comments, description optional , comments, 'union' asParser, (unionTypeName trim: ignored), ($= asParser trim: ignored), unionValuesList, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> unionTypeExtension [
	"Return a parser accepting:
	union unionTypeName = unionValuesList, with the comments"

	^ 'union' asParser, (unionTypeName trim: ignored), ($= asParser trim: ignored), unionValuesList, comments
]

{ #category : #grammar }
GQLSchemaGrammar >> unionTypeName [
	"Return a token name"

	^ tokenName
]

{ #category : #grammar }
GQLSchemaGrammar >> unionValuesList [
	"Return a parser accepting: 
 objectTypeName | unionValue "

	^ (unionTypeName trimRight: ignoredNoComment) separatedBy: ($| asParser trim: ignored)
]
