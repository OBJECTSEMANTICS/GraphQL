"
A GQLSchemaTest is a test class for testing the behavior of schema validator.
"
Class {
	#name : #GQLSchemaTest,
	#superclass : #GQLAbstactTypeSystemTest,
	#category : #'GraphQLBeta-Tests-TypeValidation'
}

{ #category : #tests }
GQLSchemaTest >> testInterfaceInputValue [
	| request result expectedResult |
	self flag: 'This is an error in the schema and not in the request'; skip.
	schema := self getSchema: 'inputInterfaceType' withRoot: GQLTestSchema new.
	request := '{
		nameOf(item:{name: "Query"})
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "The type of GQLTestSchema.nameOf(item:) must be Input Type but got: NamedEntity."
    }
  ]
}'.
	self assert: result equals: expectedResult.
]

{ #category : #tests }
GQLSchemaTest >> testInvalidDescription [
	| result expectedResult |
	self skip.
	result := self evalSchemaWithKey: 'invalidDescriptionInType' withRoot: GQLQuery new.
	expectedResult := '{ 
		"code": 400,
  		"error": "Script returned an error.",
  		"details": "Syntax Error: Unexpected String \"\"\n\nGraphQL request (3:1)\n2:  \" description 1 \"\n3: \" description 2\"\n   ^\n4: \ttype Query {\n",
  		"name": "GraphQLError",
  		"message": "Syntax Error: Unexpected String \" description 2\""
	}'.
	self assertJSONEquals: result and: expectedResult.
	
	result := self evalSchemaWithKey: 'invalidDescriptionInField'  withRoot: GQLQuery new.
	expectedResult := '{ 
		"code": 400,
  		"error": "Script returned an error.",
  		"details": "Syntax Error: Unexpected String \"\"\n\nGraphQL request (3:1)\n2:  \" description 1 \"\n3: \" description 2\"\n   ^\n4: \ttype Query {\n",
  		"name": "GraphQLError",
  		"message": "Syntax Error: Unexpected String \" description 2\""
	}'.
	self assertJSONEquals: result and: expectedResult.
	
	
]

{ #category : #tests }
GQLSchemaTest >> testInvalidDescriptionBlockString [
	| result expectedResult |
	self skip.
	result := self evalSchemaWithKey: 'invalidBlockStringDescription' withRoot: GQLQuery new.
	expectedResult := '{ 
		"code": 400,
  		"error": "Script returned an error.",
  		"details": "Syntax Error: Expected Name, found BlockString \" ho \"\n\nGraphQL request (7:3)\n6: \t\t\"\"\"\n7: \t\t\"\"\" ho \"\"\" \n     ^\n8: \t\thello: String\n",
  		"name": "GraphQLError",
  		"message": "Syntax Error: Expected Name, found BlockString \" second description \""
	}'.
	self assertJSONEquals: result and: expectedResult.
	
]

{ #category : #tests }
GQLSchemaTest >> testInvalidDescriptionString [
	| result expectedResult |
	self skip.
	result := self evalSchemaWithKey: 'invalidStringDescription' withRoot: GQLQuery new.
	expectedResult := '{ 
		"code": 400,
  		"error": "Script returned an error.",
  		"details": "Syntax Error: Unexpected String \" description 2\"\n\nGraphQL request (3:1)\n2:  \" description 1 \"\n3: \" description 2\"\n   ^\n4: \ttype Query {\n",
  		"name": "GraphQLError",
  		"message": "Syntax Error: Unexpected String \" description 2\""
	}'.
	self assertJSONEquals: result and: expectedResult.
	
]

{ #category : #tests }
GQLSchemaTest >> testObjectTypeInputValue [
	| request result expectedResult |
	self skip. self flag: 'Invalid test to remove'.
	schema := self getSchema: 'inputObjectType' withRoot: GQLTestQueryType new.
	request := '{
		features(film: {id: 11, filmName: "Rambo"})
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "features": "Rambo"
  }
}'.
	self assertJSONEquals: result and: expectedResult.
	
	schema := self getSchema: 'inputObjectTypeInvalid' withRoot: GQLTestQueryType new.
	
	request := '{
		information(film: { id:1, name: "terminator" }){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
   "errors": [
     {
       "message": "The type of GQLTestQueryType.information(film:) must be Input Type but got: GQLTestFilm."
    }
  ]
}
	'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		features(film:"terminator")
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Expected type GQLFilmInput, found \"terminator\".",
      "locations": [
        {
          "line": 2,
          "column": 20
        }
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		features(film:{id:"Rambo", filmName: 1})
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  	"errors": [
    {
      "message": "Expected type Int, found \"Rambo\".",
      "locations": [
        {
          "line": 2,
          "column": 24
        }
      ]
    },
    {
      "message": "Expected type String, found 1.",
      "locations": [
        {
          "line": 2,
          "column": 43
        }
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #tests }
GQLSchemaTest >> testSchemaUndefinedAndWithManyTypes [
	| result expectedResult |
	self skip.
	result := self evalSchemaWithKey: 'schemaUndefinedAndWithManyTypes' withRoot: GQLTestQueryType new.
	expectedResult := '{ 
  	"code": 400,
  	"error": "Script returned an error.",
  	"details": "Error: Undefined \"schema\".",
  	"name": "GraphQLError",
  	"message": "Syntax Error: Expected schema. }"
	}'.
	self assertJSONEquals: result and: expectedResult.
	
	result := self evalSchemaWithKey: 'schemaNoRootOperationType' withRoot: GQLQuery new.
	expectedResult := '{ 
  	"code": 400,
  	"error": "Script returned an error.",
  	"details": "Syntax Error: Expected Name, found }\n\nGraphQL request (4:1)\n3: \n4: }\n   ^\n5: \ttype Query1 {\n",
  	"name": "GraphQLError",
  	"message": "Syntax Error: Expected Name, found }"
	}'.
	self assertJSONEquals: result and: expectedResult.
	
	schema := self evalSchemaWithKey: 'schemaNoRootOperationTypeQuery' withRoot: GQLMutation new.
	result := schema validate.
	expectedResult := '{ 
  	"code": 400,
  	"error": "Script returned an error.",
  	"details": "Syntax Error: Expected query, found mutation\n\nGraphQL request (4:1)\n3: \t\t\n4: }\n   ^\n5:   schema { \n",
  	"name": "GraphQLError",
  	"message": "Syntax Error: Expected query, found mutation}",
	}'.
	self assertJSONEquals: result and: expectedResult.
	
	result := self evalSchemaWithKey: 'schemaUndefined' withRoot: GQLTestQueryType new.
	expectedResult := '{ 
  	"code": 400,
  	"error": "Script returned an error.",
  	"details": "Error: Undefined \"schema\".",
  	"name": "GraphQLError",
  	"message": "Error: Undefined \"schema\".",
	}'.
	self assertJSONEquals: result and: expectedResult.
	
]

{ #category : #tests }
GQLSchemaTest >> testSchemaWithDoubleRootTypeDefined [
	| result expectedResult |
	self skip.
	result := self evalSchemaWithKey: 'schemaDefinedQueryTwice' withRoot: GQLQuery new.
	expectedResult := '{ 
  	"code": 400,
  	"error": "Script returned an error.",
  	"details": "Error: Type \"Query\" was defined more than once.",
  	"name": "Error",
  	"message": "Type \"Query\" was defined more than once."
	}'.
	self assertJSONEquals: result and: expectedResult.
	
	result := self evalSchemaWithKey: 'schemaDefinedTypeTwice' withRoot: GQLTestQueryType new.
	expectedResult := '{ 
  	"code": 400,
  	"error": "Script returned an error.",
  	"details": "Error: Type \"GQLTestQueryType\" was defined more than once.",
  	"name": "Error",
  	"message": "Type \"GQLTestQueryType\" was defined more than once."
	}'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #tests }
GQLSchemaTest >> testSchemaWithMultipleInterface [
	| result expectedResult request |
	self skip.
	schema := self getSchema: 'schemaWithMultipleInterface' withRoot: GQLTestQueryType new.
	request := '{
		filmsWith(rating: 5){
			id
			name
			className
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
    "data": {
      "filmsWith": [ 
			{ 
				"id": 3,
				"name": "terminator",
				"className": "GQLTestFilm"
			 },
			{ 
				"id": 4,
				"name": "rambo",
				"className": "GQLTestFilm"
			},
			{ 
				"id": 5,
				"name": "robocop",
				"className": "GQLTestFilm"
			}
	    ]
    }
   }'.
	
	result := self evalSchemaWithKey: 'schemaWithUndefinedFieldInterface' withRoot: GQLTestFilm new.
	expectedResult := '{ 
  	"code": 400,
  	"error": "Script returned an error.",
  	"details": "Error: Missing fields on object type.",
  	"name": "GraphQLError",
  	"message": Error: The object type must define all fields defined by the interfaces."
	}'.
	self assertJSONEquals: result and: expectedResult.
	
	
	
]

{ #category : #tests }
GQLSchemaTest >> testSchemaWithUnknownFieldName [
	| result expectedResult |
	self skip.
	"ene estos ejemplos no se muestra error en GraphiQL"
	result := self evalSchemaWithKey: 'schemaWithUnknownFieldName' withRoot: GQLQuery new.
	expectedResult := '{ 
  "code": 400,
  "error": "Script returned an error.",
  "details": "Error: Query field \"helloName\" not found.",
  "name": "GraphQLError",
  "message": "Error: Query field \"helloName\" not found."
	}'.
	self assertJSONEquals: result and: expectedResult.
	
	schema := self evalSchemaWithKey: 'schemaWithUnknownFieldNameMutation' withRoot: GQLMutation new.
	expectedResult := '{ 
  	"code": 400,
  	"error": "Script returned an error.",
  	"details": "Error: Query field \"addNumber2\" not found.",
  	"name": "GraphQLError",
  	"message": "Error: Query field \"addNumber2\" not found.",
	}'.
	self assertJSONEquals: result and: expectedResult.
	
	
]

{ #category : #tests }
GQLSchemaTest >> testUnionInputValue [
	| request result expectedResult |
	self skip. self flag: 'bad schema'.
	schema := self getSchema: 'inputUnionType' withRoot: GQLTestSchema new.
	request := '{
		nameOf(item:{name: "Misi"})
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "The type of GQLTestSchema.nameOf(item:) must be Input Type but got: NamedObject."
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.
]
