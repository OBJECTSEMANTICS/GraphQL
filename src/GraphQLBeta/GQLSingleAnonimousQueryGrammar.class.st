"
I represent a  part of the grammar for the graphql request.
Only fields with arguments. No fragments, no alias.

Public API and Key Messages

- document
- field
- selection
- selectionSet
- start
"
Class {
	#name : #GQLSingleAnonimousQueryGrammar,
	#superclass : #GQLRequestGrammar,
	#instVars : [
		'schemaField',
		'typeField',
		'typenameField'
	],
	#category : #'GraphQLBeta-Parser'
}

{ #category : #grammar }
GQLSingleAnonimousQueryGrammar >> document [
"Return a definition"
	^  (definition trim: insignificantTokenNoComment) plus
]

{ #category : #accessing }
GQLSingleAnonimousQueryGrammar >> field [
	^ schemaField / typeField / typenameField / nonScalarField / scalarField 
]

{ #category : #grammar }
GQLSingleAnonimousQueryGrammar >> schemaField [
	"Return a parser accepting:
- aliasOptional tokenName argumentsOptional directivesOptional selectionSet"
	^ comments, alias optional, 
		('__schema' asParser flatten token trimRight: insignificantToken),
		(directives optional
			trimRight: insignificantToken),
		(selectionSet trimRight: insignificantTokenNoComment), comments
]

{ #category : #accessing }
GQLSingleAnonimousQueryGrammar >> selection [
"Return a field or fragmentSpread"
	^ field / fragmentSpread / inlineFragment
]

{ #category : #grammar }
GQLSingleAnonimousQueryGrammar >> selectionSet [
"Return a parser accepting:
{ selection+ }"
	^ comments, ${ asParser token
		, (selection trim: ignoredNoComment) plus
		, $} asParser, comments
]

{ #category : #accessing }
GQLSingleAnonimousQueryGrammar >> start [
"Return a parser accepting a document and then the end of the input"
	^ document end
]

{ #category : #grammar }
GQLSingleAnonimousQueryGrammar >> typeField [
	"Return a parser accepting:
- aliasOptional tokenName argumentsOptional directivesOptional selectionSet"
	^ comments, alias optional
		, ('__type' asParser flatten token trimRight: insignificantToken)
		,
			(arguments trimRight: insignificantToken)
		, 
			(directives optional
				trimRight: insignificantToken),
			(selectionSet trimRight: insignificantTokenNoComment), comments
]

{ #category : #accessing }
GQLSingleAnonimousQueryGrammar >> typenameField [
	"Return a parser accepting:
- aliasOptional tokenName argumentsOptional directivesOptional selectionSet"
	^ comments, alias optional,
		('__typename' asParser flatten token trimRight: insignificantTokenNoComment),
		(directives optional
			trimRight: insignificantTokenNoComment), 
		comments
]
