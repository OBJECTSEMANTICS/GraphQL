"
The tests in this class refer to validation in Input variables, not in the document itself
"
Class {
	#name : #GQLSVariableInputTest,
	#superclass : #GQLAbstactTypeSystemTest,
	#category : #'GraphQLBeta-Tests-TypeValidation'
}

{ #category : #tests }
GQLSVariableInputTest >> testVariablesNotNull [
	| result |
	self skip; flag: 'We need validation in the variables GQLVariableGrammarEvaluator'.
	schema := self getSchema: 'inputNotNullValue' withRoot: GQLTestSchema new.
	result := self 
		operation: 'operation1'
		variables: '{"x": null, "y": 2.4}'
		jsonRequest: '
query operation1($x: Float!, $y: Float){
	point(x: $x, y: $y){
		x
		y
	}
}'.
	self assert: result equals: '{
  "errors": [
    {
      "message": "Variable \"$x\" got invalid value null; Expected non-nullable type Float! not to be null.",
      "locations": [
        {
          "line": 2,
          "column": 12
        }
      ]
    }
  ]
}'.
]

{ #category : #tests }
GQLSVariableInputTest >> testVariablesSameCoerce [
	| result |
	self skip; flag: 'We need validation in the variables GQLVariableGrammarEvaluator'.
	schema := self getSchema: 'inputNotNullValue' withRoot: GQLTestSchema new.
	result := self 
		operation: 'operation1' 
		variables: '{"name": false}' 
		jsonRequest: 'query operation1($name: String!){
		helloTo(name: $name)
	}'.
	self assert: result equals: '{
  "errors": [
    {
      "message": "Variable \"$name\" got invalid value false; Expected non-nullable type String!.",
      "locations": [
        {
          "line": 2,
          "column": 12
        }
      ]
    }
  ]
}'.
]

{ #category : #tests }
GQLSVariableInputTest >> testVariablesSameCoerce02 [
	| result |
	self skip; flag: 'We need validation in the variables GQLVariableGrammarEvaluator'.
	schema := self getSchema: 'inputNotNullValue' withRoot: GQLTestSchema new.
	result := self 
		operation: 'operation1' 
		variables: '{"num": 2.3}'
		jsonRequest: 'query operation1($num: Int){
		isEven(number: $num)
	}'.
	self assert: result equals: '{
  "errors": [
    {
      "message": "Variable \"$num\" got invalid value 2.3; Expected type Int; Int cannot represent non-integer value: 2.3",
      "locations": [
        {
          "line": 1,
          "column": 17
        }
      ]
    }
  ]
}'.
]

{ #category : #tests }
GQLSVariableInputTest >> testVariablesSameCoerce03 [
	| result |
	self skip; flag: 'We need validation in the variables GQLVariableGrammarEvaluator'.
	schema := self getSchema: 'inputVariable' withRoot: GQLTestSchema new.
	result := self 
		operation: 'operation1' 
		variables: '{"film": {id: null, filmName: "Rambo"}}'
		jsonRequest: 'query operation1($film: GQLTestFilmInput!){
	}'.
	self assert: result equals:  '{
  "errors": [
    {
      "message": "Variable \"$film\" got invalid value {\"id\":null}; Expected non-nullable type Int! not to be null at value.id.",
      "locations": [
        {
          "line": 1,
          "column": 17
        }
      ]
    }
  ]
}'.
]

{ #category : #tests }
GQLSVariableInputTest >> testVariablesSameCoerce04 [
	| result |
	self skip; flag: 'We need validation in the variables GQLVariableGrammarEvaluator'.
	schema := self getSchema: 'inputVariable' withRoot: GQLTestSchema new.
	result := self 
		operation: 'operation1' 
		variables: '{"film": {id: 2.4, filmName: "Rambo"}}'
		jsonRequest: 'query operation1($film: GQLTestFilmInput!){
	}'.
	self assert: result equals: '{
  "errors": [
    {
      "message": "Variable \"$film\" got invalid value {\"id\":2.4}; Expected type Int!.",
      "locations": [
        {
          "line": 1,
          "column": 17
        }
      ]
    }
  ]
}'.
]
