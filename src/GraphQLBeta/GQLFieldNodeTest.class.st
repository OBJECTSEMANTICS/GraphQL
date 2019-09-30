Class {
	#name : #GQLFieldNodeTest,
	#superclass : #TestCase,
	#instVars : [
		'schema',
		'scalarField',
		'nonScalarField',
		'context'
	],
	#category : #'GraphQLBeta-Tests-Nodes'
}

{ #category : #utils }
GQLFieldNodeTest >> doubleIncludeDirective: aValue [

	| directive |
	directive := (self includeDirective: aValue) first.
	^ Array with: directive with: directive
]

{ #category : #utils }
GQLFieldNodeTest >> doubleSkipDirective: aValue [
	| directive |
	directive := (self skipDirective: aValue) first.
	^ Array with: directive with: directive
]

{ #category : #utils }
GQLFieldNodeTest >> includeDirective: aValue [

	| directive |
	directive := GQLIncludeDirectiveNode new.
	directive arguments first value value: aValue asString.
	^ Array with: directive
]

{ #category : #utils }
GQLFieldNodeTest >> includeDirective: firstValue skipDirective: secondValue [

	| directiveI directiveS |
	directiveI := (self includeDirective: firstValue) first.
	directiveS := (self skipDirective: secondValue) first.
	^ Array with: directiveI with: directiveS
]

{ #category : #utils }
GQLFieldNodeTest >> negatedIncludeDirectives [

	^ Array with: (self includeDirective: true) first with: (self includeDirective: false) first
]

{ #category : #utils }
GQLFieldNodeTest >> negatedSkipDirectives [

	^ Array with: (self skipDirective: false) first with: (self skipDirective: true) first
]

{ #category : #running }
GQLFieldNodeTest >> setUp [

	schema := GQLSSchemaNode new.
	scalarField := GQLScalarFieldNode new name: 'name'.
	nonScalarField := GQLNonScalarFieldNode new name: 'allFilms'.
	context := nil.
	
]

{ #category : #utils }
GQLFieldNodeTest >> skipDirective: aValue [

	| directive |
	directive := GQLSkipDirectiveNode new.
	directive arguments first value value: aValue asString.
	^ Array with: directive
]

{ #category : #utils }
GQLFieldNodeTest >> skipDirective: secondValue includeDirective: firstValue [

	| directiveI directiveS |
	directiveI := (self includeDirective: firstValue) first.
	directiveS := (self skipDirective: secondValue) first.
	^ Array with: directiveS with: directiveI
]

{ #category : #'test-nonScalarFields' }
GQLFieldNodeTest >> testNonScalarEvaluateDirectivesTrue [
	"Evaluate return true if:
	- directives are empty
	- include is true and skip is false"

	self assert: (nonScalarField evaluateDirectives: schema using: context).
	nonScalarField directives: (self includeDirective: true).
	self assert: (nonScalarField evaluateDirectives: schema using: context).
	nonScalarField directives: (self skipDirective: false).
	self assert: (nonScalarField evaluateDirectives: schema using: context).
	nonScalarField directives: (self includeDirective: true skipDirective: false).
	self assert: (nonScalarField evaluateDirectives: schema using: context).
	nonScalarField directives: (self skipDirective: false includeDirective: true).
	self assert: (nonScalarField evaluateDirectives: schema using: context).
]

{ #category : #'test-nonScalarFields' }
GQLFieldNodeTest >> testNonScalarFieldsEvaluateDirectivesFalse [
	"Evaluate return false if:
	- duplicated directives
	- any directive is not defined by default directives on schema"

	nonScalarField directives: (self doubleIncludeDirective: true).
	self deny: (nonScalarField evaluateDirectives: schema using: context).
	nonScalarField directives: (self doubleSkipDirective: false).
	self deny: (nonScalarField evaluateDirectives: schema using: context).
	nonScalarField directives: (self negatedIncludeDirectives).
	self deny: (nonScalarField evaluateDirectives: schema using: context).
	scalarField directives: (self negatedSkipDirectives).
	self deny: (nonScalarField evaluateDirectives: schema using: context).
	nonScalarField directives: (Array with: (GQLDirectiveNode new name: 'other')).
	self deny: (nonScalarField evaluateDirectives: schema using: context).
]

{ #category : #'tests-scalarFields' }
GQLFieldNodeTest >> testScalarEvaluateDirectivesTrue [
	"Evaluate return true if:
	- directives are empty
	- include is true and skip is false"

	self assert: (scalarField evaluateDirectives: schema using: context).
	scalarField directives: (self includeDirective: true).
	self assert: (scalarField evaluateDirectives: schema using: context).
	scalarField directives: (self skipDirective: false).
	self assert: (scalarField evaluateDirectives: schema using: context).
	scalarField directives: (self includeDirective: true skipDirective: false).
	self assert: (scalarField evaluateDirectives: schema using: context).
	scalarField directives: (self skipDirective: false includeDirective: true).
	self assert: (scalarField evaluateDirectives: schema using: context).
]

{ #category : #'tests-scalarFields' }
GQLFieldNodeTest >> testScalarFieldsEvaluateDirectivesFalse [
	"Evaluate return false if:
	- duplicated directives
	- any directive is not defined by default directives on schema"

	scalarField directives: (self doubleIncludeDirective: true).
	self deny: (scalarField evaluateDirectives: schema using: context).
	scalarField directives: (self doubleSkipDirective: false).
	self deny: (scalarField evaluateDirectives: schema using: context).
	scalarField directives: (self negatedIncludeDirectives).
	self deny: (scalarField evaluateDirectives: schema using: context).
	scalarField directives: (self negatedSkipDirectives).
	self deny: (scalarField evaluateDirectives: schema using: context).
	scalarField directives: (Array with: (GQLDirectiveNode new name: 'other')).
	self deny: (scalarField evaluateDirectives: schema using: context).
]
