"
I am the first basic attempt to test graphql
"
Class {
	#name : #GraphQLBetaTest,
	#superclass : #GQLTest,
	#instVars : [
		'graphQL'
	],
	#category : #'GraphQLBeta-Tests-Nodes'
}

{ #category : #running }
GraphQLBetaTest >> setUp [

	| text |
	text := 'union Queries = GQLIQueryType
			schema { 
				query: GQLIQueryType
			}
			interface GQLQuery{
				hello : String
			}
			input GQLAInput{
				id: ID
			}
			type GQLIQueryType implements GQLQuery{
					helloFor(name:String) : String
					hello : String
					sum(nums:[Int]) : Int
					a : GQLA
					an(gqla: GQLAInput): GQLA
					a(id:ID) : GQLA
				}
				type GQLA {
					hey : String
					heyID : String
					id: ID
				}'.
	graphQL := GraphQL new.
	graphQL rootInstance: GQLIQueryType new.
	graphQL createSchema: text.
	graphQL schema root: GQLIQueryType new.
	withData := false
]

{ #category : #tests }
GraphQLBetaTest >> testDocumentCycledFragments [
	| request result |
	compareJson := true.
	request := '{
		a{
		   ...data
		}
	}
	fragment data on GQLA{
		hey
		...other
	}
	fragment other on GQLA{
		hey
		...data
	}
	'.
	result :=  graphQL jsonRequest: request.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Cannot spread fragment \"data\" with itself via other",
			"locations" : [
				{
					"line" : 8,
					"column" : 6
				}
			]
		},
		{
			"message" : "Cannot spread fragment \"other\" with itself via data",
			"locations" : [
				{
					"line" : 12,
					"column" : 6
				}
			]
		}
	]
}'.
]

{ #category : #tests }
GraphQLBetaTest >> testDocumentUniqueFragments [
	| request result |
	compareJson := true.
	request := '{
		a{
		   ...data
		}
	}
	fragment data on GQLA{
		hey
		...other
	}
	fragment data on GQLA{
		hey
	}
	'.
	result := graphQL jsonRequest: request.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "There can be only one fragment named \"data\".",
			"locations" : [
				{
					"line" : 6,
					"column" : 11
				},
				{
					"line" : 10,
					"column" : 11
				}
			]
		},
		{
			"message" : "Unknown fragment \"other\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 6
				}
			]
		}
	]
}'
]

{ #category : #tests }
GraphQLBetaTest >> testDocumentUnusedFragments [
	| request result |
	compareJson := true.
	request := '{
		a{
		   ...data
		}
	}
	fragment data on GQLA{
		hey
		heyID
	}
	fragment unused on GQLA{
		hey
	}
	'.
	result := graphQL jsonRequest: request.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Fragment \"unused\" is never used.",
			"locations" : [
				{
					"line" : 10,
					"column" : 11
				}
			]
		}
	]
}'
]

{ #category : #tests }
GraphQLBetaTest >> testQuerySimple [
	| request response |
	request := '{
		hello
		a { hey }
	}'.
	response := (graphQL handleRequest: request) at: 'data'.
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'hello') asString equals: 'helloWorld'.
	self assert: (response at: 'hello') ~= 'hello World'.
	self assert: (response at: 'a') class: OrderedDictionary.
	self assert: ((response at: 'a') at: 'hey') asString equals: 'heyhey'
]

{ #category : #tests }
GraphQLBetaTest >> testQueryWithFragments [
	| request response subResponse |
	request := '{
		a{
		   ...data
		}
	}
	fragment data on GQLA{
		hey
		heyID
	}'.
	response := (graphQL handleRequest: request) at: 'data'.
	self assert: response class: OrderedDictionary.
	subResponse := response at: 'a'.
	self assert: subResponse class: OrderedDictionary.
	self assert: (subResponse at: 'hey') equals: #'heyhey'.
	self assert: (subResponse at: 'heyID') equals: 'id: nil'.
]

{ #category : #tests }
GraphQLBetaTest >> testQueryWithFragmentsDirectives [
	| request response subResponse |
	request := '{
		a{
		   ...data
		}
	}
	fragment data on GQLA{
		hey
		heyID @skip(if:true)
	}'.
	response := (graphQL handleRequest: request) at: 'data'.
	self assert: response class: OrderedDictionary.
	subResponse := response at: 'a'.
	self assert: subResponse class: OrderedDictionary.
	self assert: (subResponse at: 'hey') equals: #'heyhey'.
	self deny: (subResponse includes: 'heyID')
]

{ #category : #tests }
GraphQLBetaTest >> testQueryWithIncompletelyDefinedVariable [
	| request result |
	compareJson := true.
	request := '
	query operation1($name: String){
	    hello(name:$name)
       sum(nums:$nums)
		 an(gqla:$gqla){
		     id
		 }
		 a(id:$id){
		    id
		 }
   }
   query operation2{
     hello
   }'.
	result := graphQL
		operation: 'operation1';
		variables: '{"name":"Alex", "nums":[1, 3, 4, 5], "gqla":{id:1}, "id":2}';
		jsonRequest: request.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Unknown argument \"name\" on field \"hello\" on type \"GQLIQueryType\".",
			"locations" : [
				{
					"line" : 3,
					"column" : 12
				}
			]
		},
		{
			"message" : "Variable \"nums\" is not defined by operation \"operation1\".",
			"locations" : [
				{
					"line" : 4,
					"column" : 17
				},
				{
					"line" : 2,
					"column" : 8
				}
			]
		},
		{
			"message" : "Variable \"gqla\" is not defined by operation \"operation1\".",
			"locations" : [
				{
					"line" : 5,
					"column" : 12
				},
				{
					"line" : 2,
					"column" : 8
				}
			]
		},
		{
			"message" : "Variable \"id\" is not defined by operation \"operation1\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 9
				},
				{
					"line" : 2,
					"column" : 8
				}
			]
		}
	]
}'
]

{ #category : #tests }
GraphQLBetaTest >> testQueryWithInlineFragment [
	| request response subResponse |
	request := '{
		a{
		   ...{
				hey
				heyID
			}
		}
	}'.
	response := (graphQL handleRequest: request) at: 'data'.
	self assert: response class: OrderedDictionary.
	subResponse := response at: 'a'.
	self assert: subResponse class: OrderedDictionary.
	self assert: (subResponse at: 'hey') equals: #'heyhey'.
	self assert: (subResponse at: 'heyID') equals: 'id: nil'.
]

{ #category : #tests }
GraphQLBetaTest >> testQueryWithInlineFragmentDirectives [
	| request response subResponse |
	request := '{
		a{
		   ... @include(if:false){
				hey
				heyID
			}
		}
	}'.
	response := (graphQL handleRequest: request) at: 'data'.
	self assert: response class: OrderedDictionary.
	subResponse := response at: 'a'.
	self assert: subResponse isEmpty
]

{ #category : #tests }
GraphQLBetaTest >> testQueryWithInlineFragmentType [
	| request response subResponse |
	request := '{
		a{
		   ... on GQLA @include(if:false){
				hey
				heyID
			}
		}
	}'.
	response := (graphQL handleRequest: request) at: 'data'.
	self assert: response class: OrderedDictionary.
	subResponse := response at: 'a'.
	self assert: subResponse isEmpty
]

{ #category : #tests }
GraphQLBetaTest >> testQueryWithParamameters [
	| request response |
	request := '{
		helloFor(name:"Luke Skywalker")
		hello
		sum(nums:[1,2,3,4])
		a { hey }
	}'.
	response := (graphQL handleRequest: request) at: 'data'.
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'helloFor') equals: 'helloLuke Skywalker'.
	self assert: (response at: 'hello') ~= 'hello World'.
	self assert: (response at: 'a') class: OrderedDictionary.
	self assert: ((response at: 'a') at: 'hey') asString equals: 'heyhey'.
	self assert: (response at: 'sum') equals: 10
]

{ #category : #tests }
GraphQLBetaTest >> testQueryWithParamametersOnObjects [
	| request response |
	request := '{
		helloFor(name:"Luke Skywalker")
		hello
		sum(nums:[1,2,3,4])
		a(id:"asdf1231asdf") { heyID }
	}'.
	response := (graphQL handleRequest: request) at: 'data'.
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'helloFor') equals: 'helloLuke Skywalker'.
	self assert: (response at: 'hello') ~= 'hello World'.
	self assert: (response at: 'a') class: OrderedDictionary.
	self assert: ((response at: 'a') at: 'heyID') asString
		  equals: 'id: asdf1231asdf'.
	self assert: (response at: 'sum') equals: 10
]

{ #category : #tests }
GraphQLBetaTest >> testQueryWithUndefinedVariable [
	| request result |
	compareJson := true.
	request := '
	query operation1{
	    hello(name:$name)
       sum(nums:$nums)
		 an(gqla:$gqla){
		     id
		 }
		 a(id:$id){
		    id
		 }
   }
   query operation2{
     hello
   }'.
	result := graphQL 
		variables: '{"name":"Alex", "nums":[1, 3, 4, 5], "gqla":{id:1}, "id":2}';
		operation: 'operation1';
		jsonRequest: request.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Unknown argument \"name\" on field \"hello\" on type \"GQLIQueryType\".",
			"locations" : [
				{
					"line" : 3,
					"column" : 12
				}
			]
		},
		{
			"message" : "Variable \"name\" is not defined by operation \"operation1\".",
			"locations" : [
				{
					"line" : 3,
					"column" : 17
				},
				{
					"line" : 2,
					"column" : 8
				}
			]
		},
		{
			"message" : "Variable \"nums\" is not defined by operation \"operation1\".",
			"locations" : [
				{
					"line" : 4,
					"column" : 17
				},
				{
					"line" : 2,
					"column" : 8
				}
			]
		},
		{
			"message" : "Variable \"gqla\" is not defined by operation \"operation1\".",
			"locations" : [
				{
					"line" : 5,
					"column" : 12
				},
				{
					"line" : 2,
					"column" : 8
				}
			]
		},
		{
			"message" : "Variable \"id\" is not defined by operation \"operation1\".",
			"locations" : [
				{
					"line" : 8,
					"column" : 9
				},
				{
					"line" : 2,
					"column" : 8
				}
			]
		}
	]
}'
]

{ #category : #tests }
GraphQLBetaTest >> testQueryWithVariables [
	| request response |
	request := '
	query operation1($name:String, $nums:[Int], $gqla:GQLAInput, $id:ID){
	    helloFor(name:$name)
       sum(nums:$nums)
		 an(gqla:$gqla){
		     id
		 }
		 a(id:$id){
		    id
		 }
   }
   query operation2{
     hello
   }'.
	response := (graphQL
		operation: 'operation1';
		variables: '{"name":"Alex", "nums":[1, 3, 4, 5], "gqla":{id:1}, "id":null}';
		handleRequest: request) at: 'data'.
	self assert: response class: OrderedDictionary.
	self assert: (response at:'helloFor') equals: 'helloAlex'.
	self assert: (response at:'sum') equals: 13.
	self assert: (response at: 'an') class: OrderedDictionary.
	self assert: ((response at: 'an') at: 'id') equals: 1.
	self assert: ((response at: 'a') at: 'id') equals: nil.
]

{ #category : #tests }
GraphQLBetaTest >> testRequestUnableToParse [
	| text request result |
	compareJson := true.
	text := '
				schema { 
					query: GQLIQueryType
				}
				type GQLIQueryType {
					hello : String
					a : GQLA
				}
				type GQLA {
					hey : String
				}'.
	graphQL createSchema: text.
	request := '{
		hello
		a {  }
	}'.
	result := graphQL handleRequest: request.
	self assert: (result includesKey: 'errors')
]

{ #category : #tests }
GraphQLBetaTest >> testSchemaInvalid [
	| text |
	text := 'type GQLIQueryType {
					hello : String
					a : GQLA
				}
				type A {
					hey : String
				}'.
	graphQL createSchema: text.
	self assert: graphQL schema class: GQLValidationException.
]

{ #category : #tests }
GraphQLBetaTest >> testSchemaProbeInterfaces [
	| request response |
	request := '{
		helloFor(name:"Luke Skywalker")
		hello
		sum(nums:[1,2,3,4])
		a { hey }
	}'.
	response := (graphQL handleRequest: request) at: 'data'.
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'helloFor') equals: 'helloLuke Skywalker'.
	self assert: (response at: 'hello') ~= 'hello World'.
	self assert: (response at: 'a') class: OrderedDictionary.
	self assert: ((response at: 'a') at: 'hey') asString equals: 'heyhey'.
	self assert: (response at: 'sum') equals: 10
]

{ #category : #tests }
GraphQLBetaTest >> testSchemaProbeUnions [
	| request response |
	request := '{
		...fragmentQuery
	}
	fragment fragmentQuery on Queries{
		... on GQLIQueryType { 
			helloFor(name:"Luke Skywalker")
			hello
			sum(nums:[1,2,3,4])
			a { hey }
		}
	}'.
	response := (graphQL handleRequest: request) at: 'data'.
	self assert: response class: OrderedDictionary.
	self assert: (response at: 'helloFor') equals: 'helloLuke Skywalker'.
	self assert: (response at: 'hello') ~= 'hello World'.
	self assert: (response at: 'a') class: OrderedDictionary.
	self assert: ((response at: 'a') at: 'hey') asString equals: 'heyhey'.
	self assert: (response at: 'sum') equals: 10
]

{ #category : #tests }
GraphQLBetaTest >> testSchemaUnableToParse [
	| text |
	text := 'type GQLIQueryType {
					hello : String
					a : 
				}
				type GQLA {
					hey : String
				}'.
	self assert: (graphQL createSchema: text) class: GQLEvaluationException.
]
