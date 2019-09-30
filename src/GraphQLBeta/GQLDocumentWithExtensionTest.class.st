Class {
	#name : #GQLDocumentWithExtensionTest,
	#superclass : #GQLTestExtension,
	#instVars : [
		'validator',
		'dictSchema'
	],
	#category : #'GraphQLBeta-Tests-Nodes'
}

{ #category : #parsing }
GQLDocumentWithExtensionTest >> requestEvaluator [

	^ GQLSingleAnonimousQueryEvaluator
]

{ #category : #initialization }
GQLDocumentWithExtensionTest >> setUp [
	validator := GQLValidator new.
	dictSchema := self initDictSchema.
	withData := true
]

{ #category : #tests }
GQLDocumentWithExtensionTest >> testEnumTypeExtension [
	| request result expectedResult |
	schema := self validateSchemaOf: dictSchema withKey: 'apartEnumExtension'.
	
	request := '{
		classification(gender: ACTION)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
	"classification": "ACTION"
  }
}'.
	self assertJSONEquals: result and: expectedResult.

	schema := self validateSchemaOf: dictSchema withKey: 'enumExtension'.
	request := '{
		classification(gender: SCIENCE_FICTION)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
	"classification": "SCIENCE_FICTION"
  }
}'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #tests }
GQLDocumentWithExtensionTest >> testFailEnumTypeExtension [
	| request result expectedResult |
	schema := self validateSchemaOf: dictSchema withKey: 'apartEnumExtension'.
	
	request := '{
		classification(gender: ACTION)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
	"classification": "ACTION"
  }
}'.
	self assertJSONEquals: result and: expectedResult.

	schema := self validateSchemaOf: dictSchema withKey: 'enumExtension'.
	request := '{
		classification(gender: SCIENCE_FICTION)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
	"classification": "SCIENCE_FICTION"
  }
}'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #tests }
GQLDocumentWithExtensionTest >> testInputObjectTypeExtension [
	| request result expectedResult |
	schema := self validateSchemaOf: dictSchema withKey: 'apartInputObjectExtension'.
	
	request := '{
		inform(film: { id: 10, filmName: "Iron Man"}, id: 0){
			id
			filmName
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
	"inform": { 
		"id": 10,
		"filmName": "Iron Man"
	 }
  }
}'.
	self assertJSONEquals: result and: expectedResult.

	schema := self validateSchemaOf: dictSchema withKey: 'inputObjectExtension'.
	request := '{
		inform(film: { id: 10, filmName: "Iron Man"}, id: 1){
			id
			filmName
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
	"inform": { 
		"id": 1,
		"filmName": "harry potter y la piedra filosofal"
	 }
  }
}'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #tests }
GQLDocumentWithExtensionTest >> testInterfaceTypeExtension [
	| request result expectedResult |
	schema := self validateSchemaOf: dictSchema withKey: 'apartInterfaceExtension'.
	
	request := '{
		hello 
		films{
			name 
			id
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
  	"hello": "hello world",
	"films" : [
			{
				"name" : "harry potter y la piedra filosofal",
				"id" : 1
			},
			{
				"name" : "el señor de los anillos",
				"id" : 2
			},
			{
				"name" : "terminator",
				"id" : 3
			},
			{
				"name" : "rambo",
				"id" : 4
			},
			{
				"name" : "robocop",
				"id" : 5
			},
			{
				"name" : "alien",
				"id" : 6
			},
			{
				"name" : "annie",
				"id" : 7
			}
		]
  }
}'.
	self assertJSONEquals: result and: expectedResult.

	schema := self validateSchemaOf: dictSchema withKey: 'apartInterfaceExtensionWithObExt'.
	request := '{
		films{
			name
			id
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"films" : [
			{
				"name" : "harry potter y la piedra filosofal",
				"id" : 1
			},
			{
				"name" : "el señor de los anillos",
				"id" : 2
			},
			{
				"name" : "terminator",
				"id" : 3
			},
			{
				"name" : "rambo",
				"id" : 4
			},
			{
				"name" : "robocop",
				"id" : 5
			},
			{
				"name" : "alien",
				"id" : 6
			},
			{
				"name" : "annie",
				"id" : 7
			}
		]
	}
}'.
	self assertJSONEquals: result and: expectedResult.
	
	schema := self validateSchemaOf: dictSchema withKey: 'interfaceExtension'.
	request := '{
		films { 
			name
			id
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"films" : [
			{
				"name" : "harry potter y la piedra filosofal",
				"id" : 1
			},
			{
				"name" : "el señor de los anillos",
				"id" : 2
			},
			{
				"name" : "terminator",
				"id" : 3
			},
			{
				"name" : "rambo",
				"id" : 4
			},
			{
				"name" : "robocop",
				"id" : 5
			},
			{
				"name" : "alien",
				"id" : 6
			},
			{
				"name" : "annie",
				"id" : 7
			}
		]
	}
}'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #tests }
GQLDocumentWithExtensionTest >> testObjectTypeExtension [
	| request result expectedResult |
	schema := self validateSchemaOf: dictSchema withKey: 'apartObjectExtensWithFieldDef'.
	
	request := '{
		helloTo(name: "Alex")
		films {
			id 
			name
		}
		features(film: { filmName: "Rambo" } )
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"helloTo" : "hello Alex",
		"films" : [
			{
				"id" : 1,
				"name" : "harry potter y la piedra filosofal"
			},
			{
				"id" : 2,
				"name" : "el señor de los anillos"
			},
			{
				"id" : 3,
				"name" : "terminator"
			},
			{
				"id" : 4,
				"name" : "rambo"
			},
			{
				"id" : 5,
				"name" : "robocop"
			},
			{
				"id" : 6,
				"name" : "alien"
			},
			{
				"id" : 7,
				"name" : "annie"
			}
		],
		"features" : "Rambo"
	}
}'.
	self assertJSONEquals: result and: expectedResult.

	schema := self validateSchemaOf: dictSchema withKey: 'apartObjectExtensWithFieldDef'.
	request := '{
		helloTo(name: "Maria")
		films{
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"helloTo" : "hello Maria",
		"films" : [
			{
				"name" : "harry potter y la piedra filosofal"
			},
			{
				"name" : "el señor de los anillos"
			},
			{
				"name" : "terminator"
			},
			{
				"name" : "rambo"
			},
			{
				"name" : "robocop"
			},
			{
				"name" : "alien"
			},
			{
				"name" : "annie"
			}
		]
	}
}'.
	self assertJSONEquals: result and: expectedResult.
	
	schema := self validateSchemaOf: dictSchema withKey: 'objectExtensWithInterface'.
	request := '{
		cats { 
			name
		}
		filmsSortedBy(name: true){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"cats" : [
			{
				"name" : "Misi"
			},
			{
				"name" : "Figaro"
			},
			{
				"name" : "Minino"
			}
		],
		"filmsSortedBy" : [
			{
				"name" : "alien"
			},
			{
				"name" : "annie"
			},
			{
				"name" : "el señor de los anillos"
			},
			{
				"name" : "harry potter y la piedra filosofal"
			},
			{
				"name" : "rambo"
			},
			{
				"name" : "robocop"
			},
			{
				"name" : "terminator"
			}
		]
	}
}'.
	self assertJSONEquals: result and: expectedResult.
	
	schema := self validateSchemaOf: dictSchema withKey: 'objectExtensWithExtInterface'.
	request := '{
		filmsSortedBy(name: false){
			name
			id
			rating
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"filmsSortedBy" : [
			{
				"name" : "harry potter y la piedra filosofal",
				"id" : 1,
				"rating" : 9
			},
			{
				"name" : "el señor de los anillos",
				"id" : 2,
				"rating" : 8
			},
			{
				"name" : "terminator",
				"id" : 3,
				"rating" : 5
			},
			{
				"name" : "rambo",
				"id" : 4,
				"rating" : 5
			},
			{
				"name" : "robocop",
				"id" : 5,
				"rating" : 5
			},
			{
				"name" : "alien",
				"id" : 6,
				"rating" : 7
			},
			{
				"name" : "annie",
				"id" : 7,
				"rating" : 6
			}
		]
	}
}'.
	self assertJSONEquals: result and: expectedResult.
	
	schema := self validateSchemaOf: dictSchema withKey: 'objectExtensWithOtherResolver'.
	request := '{
		hello
		asText(number: 53)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": { 
	"hello": "hello world",
	"asText": "53"
 }
}'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #tests }
GQLDocumentWithExtensionTest >> testUnionTypeExtension [
	| request result expectedResult expectedResult2 expectedResult3 expectedResult4 |
	schema := self validateSchemaOf: dictSchema withKey: 'apartUnionExtension'.
	
	request := '{
		firstExtendedSearchObject { 
			...on Point { 
				x 
				y
			}
			...on Rectangle { 
				origin { 
					x
					y
				}
			}
			...on GQLCat { 
				nickname
			}
			...on GQLDog { 
				name
			}
		}
	}'.
	expectedResult := '{
  "data": {
		"firstExtendedSearchObject": { 
	 		"x": 2.4,
			"y": 4.5
	 	}
  }
}'.
	expectedResult2 := '{
  "data": {
		"firstExtendedSearchObject": { 
			"origin": { 
	 			"x": 2.4,
				"y": 5
			}
	 	}
  }
}'.
	expectedResult3 := '{
  "data": {
		"firstExtendedSearchObject": { 
			"nickname": "misi"
	 	}
  }
}'.
	expectedResult4 := '{
  "data": {
		"firstExtendedSearchObject": { 
			"name": "Firulais"
	 	}
  }
}'.
	result := GraphQLPlatform current jsonFromString: (self jsonRequest: request).
	self assert: ((result = (GraphQLPlatform current jsonFromString: expectedResult)) or: 
	((result = (GraphQLPlatform current jsonFromString: expectedResult2)) or:
	((result = (GraphQLPlatform current jsonFromString: expectedResult3)) or: 
	[ result = (GraphQLPlatform current jsonFromString: expectedResult4) ] ))).

	schema := self validateSchemaOf: dictSchema withKey: 'unionExtension'.
	request := '{
		firstExtendedSearchObject { 
			...on Point { 
				y
			}
			...on Rectangle { 
				corner { 
					x
					y
				}
			}
			...on GQLCat { 
				name
				nickname
			}
			...on GQLDog { 
				name
			}
		}
	}'.
	expectedResult := '{
  "data": {
		"firstExtendedSearchObject": {
			"y": 4.5
	 	}
  }
}'.
	expectedResult2 := '{
  "data": {
		"firstExtendedSearchObject": { 
			"corner": { 
	 			"x": 4,
				"y": 5
			}
	 	}
  }
}'.
	expectedResult3 := '{
  "data": {
		"firstExtendedSearchObject": { 
			"name": "Misi",
			"nickname": "misi"
	 	}
  }
}'.
	expectedResult4 := '{
  "data": {
		"firstExtendedSearchObject": { 
			"name": "Firulais"
	 	}
  }
}'.
	result := GraphQLPlatform current jsonFromString: (self jsonRequest: request).
	self assert: ((result = (GraphQLPlatform current jsonFromString: expectedResult)) or: 
	((result = (GraphQLPlatform current jsonFromString: expectedResult2)) or:
	((result = (GraphQLPlatform current jsonFromString: expectedResult3)) or: 
	[ result = (GraphQLPlatform current jsonFromString: expectedResult4) ] ))).
]
