"
I represent a  part of the grammar for the graphql request.
Only the assignments of variables. 

Public API and Key Messages

- variableSet
- variableValue
- tokenValue
"
Class {
	#name : #GQLVariableGrammar,
	#superclass : #GQLRequestGrammar,
	#instVars : [
		'variableSet',
		'tokenValue',
		'variableValue'
	],
	#category : #'GraphQLBeta-Parser'
}

{ #category : #accessing }
GQLVariableGrammar >> start [
	"Return a parser accepting the variableSet and success at the end of the input"

	^ variableSet end
]

{ #category : #accessing }
GQLVariableGrammar >> tokenValue [
	"[~Const] IntValue FloatValue StringValue BooleanValue 
	 NullValue EnumValue ListValue[~Const] ObjectValue[~Const]"
	
	^ floatValue / intValue / stringValue / booleanValue / nullValue / enumValue / listValue /  objectValue
]

{ #category : #grammar }
GQLVariableGrammar >> variableSet [
	"Return a parser accepting: 
 { Variable+ }"

	^ (${ asParser trim: ignored)
		, (variableValue trim: ignored) plus
		, ($} asParser trim: ignored)
]

{ #category : #grammar }
GQLVariableGrammar >> variableValue [
	"Return a parser accepting:
	stringValue : tokenValue"

	^ (stringValue trimRight: insignificantToken)
		, ($: asParser trimRight: insignificantToken)
		, (tokenValue trimRight: insignificantToken)
]
