"
I represent the grammar defined for a graphql request.

Public API and Key Messages

- alias
- argument
- arguments
- defaultValue
- definition
- directive
- document
- enumValue
- field
- fragmentDefinition
- fragmentName
- fragmentSpread
- inlineFragment
- listType
- listValue
- namedType
- nonNullType
- nullValue
- objectField
- objectValue
- operationDefinition
- operationType
- selection
- selectionSet
- start
- type
- typeCondition
- value
- variable
- variableDefinition
- variableDefinitions
"
Class {
	#name : #GQLRequestGrammar,
	#superclass : #GQLAbstractGrammar,
	#instVars : [
		'selection',
		'field',
		'fragmentSpread',
		'inlineFragment',
		'alias',
		'arguments',
		'argument',
		'value',
		'fragmentName',
		'typeCondition',
		'namedType',
		'variable',
		'nullValue',
		'enumValue',
		'listValue',
		'objectValue',
		'variableDefinition',
		'type',
		'listType',
		'nonNullType',
		'directive',
		'definition',
		'operationDefinition',
		'fragmentDefinition',
		'operationType',
		'variableDefinitions',
		'directives',
		'selectionSet',
		'document',
		'defaultValue',
		'objectField',
		'operation',
		'nonNullNamedType',
		'nonNullListType',
		'named',
		'scalarField',
		'nonScalarField'
	],
	#category : #'GraphQLBeta-Parser'
}

{ #category : #grammar }
GQLRequestGrammar >> alias [
"Return a parser accepting:
 tokenName :"
	^ (tokenName trimRight: insignificantToken)
		, ($: asParser trim: insignificantToken)
]

{ #category : #accessing }
GQLRequestGrammar >> argument [
"Return a parser accepting:
tokenName : Value"
	^ tokenName
		, ($: asParser trim: insignificantToken)
		, value
]

{ #category : #accessing }
GQLRequestGrammar >> arguments [
	"Return a parser accepting:
( Argument+ )"

	^ ($( asParser trimRight: ignored)
		, (argument trimRight: ignored) plus
		, $) asParser
]

{ #category : #accessing }
GQLRequestGrammar >> defaultValue [
"Return a parser accepting:
= value"
	^ ($= asParser trimRight: insignificantToken) , value
]

{ #category : #accessing }
GQLRequestGrammar >> definition [
	"Return a parser accepting operationDefinition or fragmentDefinition"

	^ operationDefinition / fragmentDefinition
]

{ #category : #grammar }
GQLRequestGrammar >> directive [
"Return a parser accepting:
@ tokenName ArgumentsOptional"
	^ $@ asParser
		, (tokenName trimRight: insignificantTokenNoComment)
		, arguments optional, comments
]

{ #category : #grammar }
GQLRequestGrammar >> directives [
	"Return a parser accepting:
	Directive+"

	^ (directive trim: ignored) plus
]

{ #category : #grammar }
GQLRequestGrammar >> document [
	"Return a parser accepting one or more definitions"

	^ (definition trim: insignificantTokenNoComment) plus
]

{ #category : #accessing }
GQLRequestGrammar >> enumValue [
"Return a parser accepting a tokenName but not a booleanValue or null"
	^ (booleanValue not , nullValue not
		, tokenName) flatten token
]

{ #category : #grammar }
GQLRequestGrammar >> field [
	"Return a parser accepting:
	nonScalarField
	scalarField"

	^ nonScalarField / scalarField 
]

{ #category : #grammar }
GQLRequestGrammar >> fragmentDefinition [
"Return a parser accepting:
fragment fragmentName typeCondition directiveOptional selectionSet"
	^ comments, 'fragment' asParser , whiteSpace plus,
		 (fragmentName trim: insignificantToken),
		 (typeCondition trimRight: insignificantToken),
		 (directives optional
				trimRight: insignificantToken),
		 (selectionSet trimRight: insignificantTokenNoComment), comments
]

{ #category : #accessing }
GQLRequestGrammar >> fragmentName [
"Return a parser accepting a token name but not on"
	^ ('on' asParser not) , tokenName
]

{ #category : #grammar }
GQLRequestGrammar >> fragmentSpread [
"Return a parser accepting:
 ... FragmentName DirectivesOptional"
	^ comments, '...' asParser , (fragmentName trim: ignored)
		, directives optional, comments
]

{ #category : #accessing }
GQLRequestGrammar >> inlineFragment [
"Return a parser accepting:
... typeConditionOptional directivesOptional selectionSet"
	^ comments, ('...' asParser token trimRight: insignificantToken)
		, (typeCondition optional trimRight: insignificantToken)
		, (directives optional trimRight: insignificantToken), selectionSet, comments
]

{ #category : #grammar }
GQLRequestGrammar >> listType [
"Return a parser accepting:
[ type ]"
	^ ($[ asParser trimRight: ignored) , (type trimRight: ignored) , ($] asParser trimRight: insignificantToken)
]

{ #category : #accessing }
GQLRequestGrammar >> listValue [
	"Return a parser accepting:
	[]
	[ Value* ]"

	^ ($[ asParser trimRight: ignored) token
		, (value trimRight: ignored) star
		, $] asParser token
]

{ #category : #grammar }
GQLRequestGrammar >> named [
"Return a name"
	^ tokenName 
]

{ #category : #grammar }
GQLRequestGrammar >> namedType [
"Return a parser accepting:
	-scalarType
	-named"
	^ scalarType / named
]

{ #category : #grammar }
GQLRequestGrammar >> nonNullListType [
"Return a parser accepting:
- listType !"
	^ listType, $! asParser
]

{ #category : #grammar }
GQLRequestGrammar >> nonNullNamedType [
"Return a parser accepting:
- namedType !"
	^ (namedType trim: ignored) , ($! asParser)
]

{ #category : #grammar }
GQLRequestGrammar >> nonNullType [
"Return a parser accepting:
- nonNullNamedType
- nonNullListType"
	^ (nonNullNamedType / nonNullListType) trim: insignificantToken 
]

{ #category : #grammar }
GQLRequestGrammar >> nonScalarField [
"Return a parser accepting:
- aliasOptional tokenName argumentsOptional directivesOptional selectionSet"
	^ comments, alias optional
		, (tokenName trimRight: insignificantToken)
		,
			(arguments optional
				trimRight: insignificantToken)
		, 
			(directives optional
				trimRight: insignificantToken),
			(selectionSet trimRight: insignificantTokenNoComment), comments
]

{ #category : #grammar }
GQLRequestGrammar >> objectField [
"Return a parser accepting:
 tokenName : value"
	^ tokenName
		, ($: asParser trim: insignificantToken)
		, value
]

{ #category : #accessing }
GQLRequestGrammar >> objectValue [
	"Return a parser accepting:
 - { }
 - { ObjectField* }"

	^ (${ asParser trimRight: ignored)
		, (objectField trimRight: ignored) star
		, $} asParser token
]

{ #category : #grammar }
GQLRequestGrammar >> operation [
"Return a parser accepting:
- operationType tokenName variableDefinitionsOptional directivesOptional selectionSet"
	^ comments, operationType , whiteSpace plus
				, (tokenName optional trim: insignificantToken)
				,
					(variableDefinitions optional
						trim: insignificantToken)
				, 
					(directives optional
						trimRight: insignificantToken)
				, (selectionSet trimRight: insignificantTokenNoComment), comments
]

{ #category : #grammar }
GQLRequestGrammar >> operationDefinition [
"Return a parser accepting:
- selection set
- operation"
	^ selectionSet / operation
]

{ #category : #accessing }
GQLRequestGrammar >> operationType [
"Return a parser accepting:
- query
- mutation"
	^ 'query' asParser / 'mutation' asParser
]

{ #category : #grammar }
GQLRequestGrammar >> scalarField [
"Return a parser accepting:
aliasOptional tokenName argumentsOptional directivesOptional"

	^ comments, alias optional
		, (tokenName trimRight: insignificantTokenNoComment)
		,
			(arguments optional
				trimRight: insignificantTokenNoComment)
		,
			(directives optional
				trimRight: insignificantTokenNoComment), comments
]

{ #category : #accessing }
GQLRequestGrammar >> selection [
"Return a token for a field or fragmentSpread or inlineFragment"
	^ (field / fragmentSpread / inlineFragment)
]

{ #category : #grammar }
GQLRequestGrammar >> selectionSet [
	"Return a parser accepting: 
 { Selection+ }"

	^ comments, ${ asParser
		, (selection trim: ignoredNoComment) plus
		, $} asParser, comments
]

{ #category : #accessing }
GQLRequestGrammar >> start [
	"Return a parser accepting a document, transform this to a token and then end the input"

	^ document end
]

{ #category : #accessing }
GQLRequestGrammar >> type [
"Return a parser accepting:
- nonNullType
- namedType
- listType"
	^ nonNullType / namedType / listType
]

{ #category : #grammar }
GQLRequestGrammar >> typeCondition [
"Return a parser accepting:
on namedType"
	^ 'on' asParser , whiteSpace plus , (namedType trim: insignificantToken)
]

{ #category : #accessing }
GQLRequestGrammar >> value [
	"[~Const]Variable IntValue FloatValue StringValue BooleanValue 
	 NullValue EnumValue ListValue[~Const] ObjectValue[~Const]"
	
	^ variable / floatValue / intValue / stringValue / booleanValue / nullValue / enumValue / listValue /  objectValue

]

{ #category : #accessing }
GQLRequestGrammar >> variable [
"Return a token input from parse:
$ tokenName"
	^ ($$ asParser , tokenName) flatten token
]

{ #category : #accessing }
GQLRequestGrammar >> variableDefinition [
"Return a parser accepting:
variable : type defaultValueOptional"
	^ variable, ($: asParser trim: insignificantToken) , (type trimRight: insignificantToken)
		, defaultValue optional
]

{ #category : #grammar }
GQLRequestGrammar >> variableDefinitions [
"Return a parser accepting:
( variableDefinition+ )"
	^ $( asParser , (((variableDefinition trim: insignificantToken)  separatedBy: comma))
		, $) asParser
]
