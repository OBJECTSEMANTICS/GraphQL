"
I am  common class to create a schema for the next tests
"
Class {
	#name : #GQLTestValidation,
	#superclass : #GQLTest,
	#category : #'GraphQLBeta-Tests-Validation'
}

{ #category : #parsing }
GQLTestValidation >> attendRequest: text using: operationName with: textVariables root: root [

	| document variables |
	document := self parseRequest: text.
	textVariables isEmpty 
	ifFalse:[ variables := self parseVariables: textVariables ]
	ifTrue: [ variables := nil ].
	^ GQLValidator new
		variables: variables;
		operationName: operationName;
		rootInstance: root;
		document: document;
		text: text;
		schema: schema;
		execute.
	
]

{ #category : #parsing }
GQLTestValidation >> requestEvaluator [

	^ GQLSingleAnonimousQueryEvaluator
]

{ #category : #initialization }
GQLTestValidation >> setUp [
	schema := self parseSchema: GQLQueryRoot schema.
	schema := schema validate.
	rootInstance := GQLQueryRoot new.
	schema root: rootInstance.
	compareJson := true.
]
