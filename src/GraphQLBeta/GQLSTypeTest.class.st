"
A GQLSTypeTest is a test class for testing the behavior of type request validator.
"
Class {
	#name : #GQLSTypeTest,
	#superclass : #GQLAbstactTypeSystemTest,
	#category : #'GraphQLBeta-Tests-TypeValidation'
}

{ #category : #'tests-scalar' }
GQLSTypeTest >> testBooleanInputValue [
	"The only valid type is Boolean"
	| request result expectedResult |
	schema := self getSchema: 'inputBooleanType' withRoot: GQLTestSchema new.
	request := '{
		films(sortedByName: true){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"films" : [
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
	self assert: result equals: expectedResult.
	
	request := '{
		films(sortedByName: "true"){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"sortedByName\" has invalid value \"true\". Expected type \"Boolean\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 23
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		hello @skip(if:"false")
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"if\" has invalid value \"false\". Expected type \"Boolean!\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 18
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		films(sortedByName: 1){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"sortedByName\" has invalid value 1. Expected type \"Boolean\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 23
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
]

{ #category : #'tests-scalar' }
GQLSTypeTest >> testBooleanOutputValue [
	"The valid output values are: Boolean, Int. If the value of num = 0, then will be false, otherwise true"
	| request result expectedResult |
	self skip.
	schema := self getSchema: 'outputBooleanType' withRoot: GQLTestSchema new.
	
	request := '{
		totalFilms
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
    "data": {
      "totalFilms": true
    }
   }'.
	self assert: result equals: expectedResult.
	
	request := '{
		hello
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Boolean cannot represent a non boolean value: \"hello world\"",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "hello"
      ]
    }
  ],
  "data": {
    "hello": null
  }
}
	'.
	self assert: result equals: expectedResult.
	
	request := '{
		pi
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Boolean cannot represent a non boolean value: \"3.1416\"",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "pi"
      ]
    }
  ],
  "data": {
    "pi": null
  }
}
	'.
	self assert: result equals: expectedResult.
	
	request := '{
		point(x:4.6, y:7.9){
			x
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Field \"point\" must not have a selection since type \"Boolean\" has no subfields.",
      "locations": [
        {
          "line": 2,
          "column": 22
        }
      ]
    }
  ]
}
	'.
	self assert: result equals: expectedResult.
]

{ #category : #'tests-enum' }
GQLSTypeTest >> testEnumInputValue [
	| request result expectedResult |
	schema := self getSchema: 'inputEnumType' withRoot: GQLTestSchema new.
	
	request := '{
		classification(gender: ACTION)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"gender\" has invalid value ACTION. Expected type \"MovieType\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 26
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		classification(gender: SCIENCE_FICTION)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"classification" : "SCIENCE_FICTION"
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		classification(gender: "COMEDY")
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"gender\" has invalid value \"COMEDY\". Expected type \"MovieType\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 26
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		classification(gender: 1)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"gender\" has invalid value 1. Expected type \"MovieType\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 26
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
]

{ #category : #'tests-enum' }
GQLSTypeTest >> testEnumOutputValue [
	| request result expectedResult |
	self skip.
	schema := self getSchema: 'outputEnumType' withRoot: GQLTestSchema new.
	
	request := '{
		classification(gender: COMEDY)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "classification": "COMEDY"
  }
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		totalFilms
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "totalFilms": null
  },
  "errors": [
    {
      "message": "Expected a value of type \"MovieType\" but received: 7",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "totalFilms"
      ]
    }
  ]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		hello
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "hello": null
  },
  "errors": [
    {
      "message": "Expected a value of type \"MovieType\" but received: Hello World!",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "hello"
      ]
    }
  ]
}'.
	self assert: result equals: expectedResult.
	
]

{ #category : #'tests-scalar' }
GQLSTypeTest >> testFloatInputValue [
	"The only valid input type is Float, Int"
	| request result expectedResult |
	schema := self getSchema: 'inputFloatType' withRoot: GQLTestSchema new.
	
	request := '{
		point(x:2, y:3){
			x
			y
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"point" : {
			"x" : 2.0,
			"y" : 3.0
		}
	}
}'.
	
	self assert: result equals: expectedResult.

	request := '{
		point(x:"2.3", y:3.4){
			x
			y
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"x\" has invalid value \"2.3\". Expected type \"Float\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 11
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		point(x:"2.1", y:"3.4"){
			x
			y
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"x\" has invalid value \"2.1\". Expected type \"Float\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 11
				}
			]
		},
		{
			"message" : "Argument \"y\" has invalid value \"3.4\". Expected type \"Float\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 20
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
]

{ #category : #'tests-scalar' }
GQLSTypeTest >> testFloatOutputValue [
	"The valid output type is: Int, Float, Boolean"
	| request response expectedResult |
	self skip.
	schema := self getSchema: 'outputFloatType' withRoot: GQLTestSchema new.

	request := '{
		asText(number: 2.3)
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
    "data": {
      "asText": 2.3
    }
   } 
	'.
	self assert: response equals: expectedResult.
	
	request := '{
		totalFilms
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
    "data": {
      "totalFilms": 7
    }
   } '.
	self assert: response equals: expectedResult.

	request := '{
		isEven(number: 2.3)
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
	"data": {
      "isEven": 1
    }
	}'.
	self assert: response equals: expectedResult.
	
	request := '{
		hello
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Float cannot represent non numeric value: \"hello world\"",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "hello"
      ]
    }
  ],
  "data": {
    "hello": null
  }
}'.
	self assert: response equals: expectedResult.

	request := '{
		point(x: 2.6, y: 5.7){
			x
		}
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Field \"point\" must not have a selection since type \"Float\" has no subfields.",
      "locations": [
        {
          "line": 2,
          "column": 13
        }
      ]
    }
  ]
}'.
	self assert: response equals: expectedResult.
	
	request := '{
		point(x: 1.5, y: 5.7)
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Float cannot represent non numeric value: {x: 1.5, y: 5.7}",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "point"
      ]
    }
  ],
  "data": {
    "point": null
  }
}'.
	self assert: response equals: expectedResult.
]

{ #category : #'tests-scalar' }
GQLSTypeTest >> testIDInputValue [
	"The defined input values as ID accept: Int, String. The rest values give error"
	| request result expectedResult |
	schema := self getSchema: 'inputIDType' withRoot: GQLTestSchema new.
	request := '{
		filteredFilm(id:1){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"filteredFilm" : {
			"name" : "harry potter y la piedra filosofal"
		}
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		filteredFilm(id:"1"){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"filteredFilm" : {
			"name" : "harry potter y la piedra filosofal"
		}
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		filteredFilm(id:2.0){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"id\" has invalid value 2.0. Expected type \"ID\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 19
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		filteredFilm(id:true){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"id\" has invalid value true. Expected type \"ID\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 19
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
]

{ #category : #'tests-scalar' }
GQLSTypeTest >> testIDOutputValue [
	"The valid output values (String, Int, Float) as ID, return the value as String "
	| request result expectedResult |
	self skip.
	schema := self getSchema: 'outputIDType' withRoot: GQLTestSchema new.
	request := '{
		hello
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
   "data": {
     "hello": "hello world"
   }
  }'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		totalFilms
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
   "data": {
     "totalFilms": "7"
   }
  }'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		pi
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
    "data": { 
		"pi": "3.1416"
    }
   }'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		isEven(number: 3)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "ID cannot represent value: false",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "isEven"
      ]
    }
  ],
  "data": {
    "isEven": null
  }
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		point(x: 2.7, y: 5.7){
			y
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Field \"point\" must not have a selection since type \"ID\" has no subfields.",
      "locations": [
        {
          "line": 2,
          "column": 24
        }
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		point(x: 2.7, y: 5.7){
			y
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "ID cannot represent value: {x: 2.7, y: 5.7}",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "point"
      ]
    }
  ],
  "data": {
    "point": null
  }
}'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #'tests-input object' }
GQLSTypeTest >> testInputObjectInputValue [
	| request result expectedResult | 
	
	schema := self getSchema: 'inputInputObject' withRoot: GQLTestSchema new.
	request := '{
		informationInput(film: { id: 1, filmName: "Rambo" }){
			description
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"informationInput" : {
			"description" : "Rambo"
		}
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		inform(film: null, id: 1){
			filmName
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"inform" : {
			"filmName" : "harry potter y la piedra filosofal"
		}
	}
}'.
	self assert: result equals: expectedResult.
	request := '{
		informationInput(film: { id: 1 }){
			description
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"informationInput" : {
			"description" : "harry potter y la piedra filosofal"
		}
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		inform(id: 1){
			filmName
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"inform" : {
			"filmName" : "harry potter y la piedra filosofal"
		}
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		informationInput(film: 1){
			description
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"film\" has invalid value 1. Expected type \"GQLTestFilmInput\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 26
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		informationInput(film: {id: 1, filmName: 1}){
			description
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Expected type String, found 1.",
			"locations" : [
				{
					"line" : 2,
					"column" : 34
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		informationInput(film: {id: 1, type: "Action"}){
			description
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Field \"type\" is not defined by type GQLTestFilmInput",
			"locations" : [
				{
					"line" : 2,
					"column" : 34
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		informationInput(film: { filmName: "Rambo" }){
			description
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"informationInput" : {
			"description" : "Rambo"
		}
	}
}'.
	self assert: result equals: expectedResult.
	
]

{ #category : #'tests-input object' }
GQLSTypeTest >> testInputObjectOutputValue [
	| request result expectedResult |
	self skip.
	schema := self getSchema: 'outputInputObject' withRoot: GQLTestSchema new.
	request := '{
		information(film: { id: 1, filmName: "Rambo" }){
			filmName
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := ''. "error to evaluate the schema, because an input object never must be an output"
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #'tests-scalar' }
GQLSTypeTest >> testIntInputValue [
	"The only valid input type is Int"
	| request response expectedResult |
	schema := self getSchema: 'inputIntType' withRoot: GQLTestSchema new.
	request := '{
		filmsWith(rating:"1"){
			name
		}
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"rating\" has invalid value \"1\". Expected type \"Int\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 20
				}
			]
		}
	]
}'.
	self assert: response equals: expectedResult.
	
	request := '{
		isEven(number: 1.34)
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"number\" has invalid value 1.34. Expected type \"Int\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 18
				}
			]
		}
	]
}'.
	self assert: response equals: expectedResult.
	
	request := '{
		isEven(number: true)
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"number\" has invalid value true. Expected type \"Int\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 18
				}
			]
		}
	]
}'.
	self assert: response equals: expectedResult.
	
	request := '{
		isEven(number: 2147483648)
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"number\" has invalid value 2147483648. Expected type \"Int\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 18
				}
			]
		}
	]
}'.
	self assert: response equals: expectedResult. 
	
	request := '{
		isEven(number: -2147483649)
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"number\" has invalid value -2147483649. Expected type \"Int\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 18
				}
			]
		}
	]
}'.
	self assert: response equals: expectedResult.
]

{ #category : #'tests-scalar' }
GQLSTypeTest >> testIntOutputValue [
	"The valid output type is: (Int, Boolean, num as String)"
	| request response expectedResult |
	self skip.
	schema := self getSchema: 'outputIntType' withRoot: GQLTestSchema new.
	request := '{
		squareRoot(of:3.1)
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Int cannot represent non-integer value: 3.1",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "squareRoot"
      ]
    }
  ],
  "data": {
    "squareRoot": null
  }
  }
	'.
	self assertJSONEquals: response and: expectedResult.
	
	request := '{
		isEven(number: 1.34)
	}'.
	response := self jsonRequest: request.
	expectedResult := '{
    "data": {
      "isEven": 1
    }
   } 
	'.
	self assertJSONEquals: response and: expectedResult. 
	
	request := '{
		asText(number: 10)
	}'.
	response := self jsonRequest: request.
	expectedResult := '{ 
	 "data": {
      "asText": 10
    }
	}  
	'.
	self assertJSONEquals: response and: expectedResult. 
	
]

{ #category : #'tests-interface' }
GQLSTypeTest >> testInterfaceOutputValue [
	| request result expectedResult |
	
	schema := self getSchema: 'outputInterfaceType' withRoot: GQLTestSchema new.
	request := '{
		entities{
		   name
			... on GQLCat{
			   nickname
		   }
		   ... on GQLTestFilm{
		      rating
		   }
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "entities": [
      {
        "name": "Rambo",
		  "rating": 5
      },
      {
        "name": "Harry Potter",
		  "rating": 7
      },
      {
        "name": "Misi",
		  "nickname": "Misifus"
      },
      {
        "name": "Figaro",
		  "nickname": "Figaro"
      },
      {
        "name": "Minino",
	  	  "nickname": "Mini"
      }
    ]
  }
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		entity{
		   name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"entity" : {
			"name" : "Rambo"
		}
	}
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		entities{
		   name
			rating
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Cannot query field \"rating\" on type \"NamedEntity\". Did you mean to use an inline fragment on \"GQLTestFilm\"?",
      "stack": [
        "Cannot query field \"rating\" on type \"NamedEntity\". Did you mean to use an inline fragment on \"GQLTestFilm\"?",
        "",
        "GraphQL request (4:4)",
        "3:     name",
        "4:     rating",
        "       ^",
        "5:   }"
      ]
    }
  ]
}'.
]

{ #category : #'tests-wrapping types' }
GQLSTypeTest >> testListInputValue [
	"The valid input is: [item] or just an item of list"
	
	| request result expectedResult |
	self skip.
	schema := self getSchema: 'inputList' withRoot: GQLTestSchema new.
	request := '{
		filmsOn(genders: [ACTION, COMEDY]){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"filmsOn" : [
			{
				"name" : "rambo"
			},
			{
				"name" : "annie"
			}
		]
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		filmsOn(genders: [ACTION]){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"filmsOn" : [
			{
				"name" : "rambo"
			}
		]
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		nameGenders(listGender: null)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"nameGenders" : null
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		nameGenders(listGender: ACTION)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"nameGenders" : [
			"ACTION"
		]
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		listOf(arrays: [ [ 1, 2 ], [ 2, 3 ], [ 3, 4 ] ])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"listOf" : [
			[
				1,
				2
			],
			[
				2,
				3
			],
			[
				3,
				4
			]
		]
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		listOf(arrays: [ 1, 2 ])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"arrays\" has invalid value [1, 2]. Expected type \"[[Int]]\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 18
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		listOf(arrays: 1)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "listOf": [
      [
        1
      ]
    ]
  }
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		listOf(arrays: null)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "listOf": null
  }
}'.
	self assert: result equals: expectedResult.
	request := '{
		filmsOn(genders: 1){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Expected type [MovieType], found 1.",
      "locations": [
        {
          "line": 3,
          "column": 19
        }
      ]
    }
  ]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		filmsOn(genders: [COMEDY, 1){
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Expected type Episode, found 1.",
      "locations": [
        {
          "line": 10,
          "column": 31
        }
      ]
    }
  ]
}'.
	self assert: result equals: expectedResult.
	
]

{ #category : #'tests-wrapping types' }
GQLSTypeTest >> testListNotNullInputValue [
	"The only valid type is a not null list"
	| request result expectedResult |
	schema := self getSchema: 'inputListNotNullValue' withRoot: GQLTestSchema new.
	request := '{
		totalInformation(film: [  ]){
			description
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "totalInformation": []
  }
}'.
	self assertJSONEquals: result and: expectedResult. 
	
	request := '{
		totalInformation(film: null){
			description
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"film\" has invalid value null. Expected type \"[GQLTestQueryTypeInput]!\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 26
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.

	request := '{
		totalInformation(film: [{description: "Rambo"}, {description: "Terminator"}, null]){
			description
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"totalInformation" : [
			{
				"description" : "Rambo"
			},
			{
				"description" : "Terminator"
			},
			null
		]
	}
}'.
	self assert: result equals: expectedResult.

	request := '{
		nameGenders(listGender: [COMEDY, SCIENCE_FICTION])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "nameGenders": [
      "COMEDY",
      "SCIENCE_FICTION"
    ]
  }
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		nameGenders(listGender: [ COMEDY, null ])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"listGender\" has invalid value [COMEDY, null]. Expected type \"[MovieType!]\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 27
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		listOf(arrays: [[1, 2, 3], [3, 4, 5]])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "listOf": [
      [
        1,
        2,
        3
      ],
      [
        3,
        4,
        5
      ]
    ]
  }
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		listOf(arrays: null)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"arrays\" has invalid value null. Expected type \"[[Int!]!]!\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 18
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		listOf(arrays: [ null ])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"arrays\" has invalid value [null]. Expected type \"[[Int!]!]!\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 18
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		listOf(arrays: [[1, null]])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"arrays\" has invalid value [[1, null]]. Expected type \"[[Int!]!]!\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 18
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
]

{ #category : #'tests-wrapping types' }
GQLSTypeTest >> testListNotNullOutputValue [
	| request result expectedResult |
	self skip.
	schema := self getSchema: 'outputListNotNullValue' withRoot: GQLTestSchema new.
	request := '{
		listOf(arrays: [[1, 2], [2, 3]])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "listOf": [
      [
        1,
        2
      ],
      [
        2,
        3
      ]
    ]
  }
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		listOf(arrays: null)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": null,
  "errors": [
    {
      "message": "Cannot return null for non-nullable field GQLTestSchema.listOf.",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "listOf"
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.

	request := '{
		listOf(arrays: [null])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": null,
  "errors": [
    {
      "message": "Cannot return null for non-nullable field Query.list.",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "list",
        0
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.

	request := '{
		listOf(arrays: [[1, 2], null])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": null,
  "errors": [
    {
      "message": "Cannot return null for non-nullable field Query.list.",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "list",
        1
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := 'listOf(arrays: [[1, 2, null]])'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": null,
  "errors": [
    {
      "message": "Cannot return null for non-nullable field Query.list.",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "list",
        0,
        2
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #'tests-wrapping types' }
GQLSTypeTest >> testListOutputValue [
	| request result expectedResult |
	self skip.
	schema := self getSchema: 'outputList' withRoot: GQLTestSchema new.
	
	request := '{
		listOf(arrays: [ [ 1, 2 ], [ 2, 3 ] ])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "listOf": [
      [
        1,
        2
      ],
      [
        2,
        3
      ]
    ]
  }
}'.
	self assertJSONEquals: result and: expectedResult. 

	request := '{
		filmsWith(rating: 5){
			filmName
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "filmsWith": [ 
		{ 
			"filmName": "terminator"
		}, 
		{ 
			"filmName": "rambo"
		},
		{
			"filmName": "robocop" 
		}
	 ]
  }
}'.
	self assertJSONEquals: result and: expectedResult.

	request := '{
		filmsWithNull(rating: 5){
			filmName
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "filmsWithNull": [ 
		{ 
			"filmName": "terminator"
		}, 
		{ 
			"filmName": "rambo"
		},
		{
			"filmName": "robocop" 
		},
		null
	 ]
  }
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		hello
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "hello": null
  },
  "errors": [
    {
      "message": "Expected Iterable, but did not find one for field GQLTestSchema.hello.",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "hello"
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		totalFilms
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "totalFilms": null
  },
  "errors": [
    {
      "message": "Expected Iterable, but did not find one for field GQLTestSchema.totalFilms.",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "totalFilms"
      ]
    }
  ]
}'.
	self assertJSONEquals: request and: expectedResult.
	
		schema := self getSchema: 'invalidOutputListString' withRoot: GQLTestQueryType new.
	request := '{
		listOf(arrays: [ [ 1, 2 ], [ 2, 3 ] ])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "listOf": [
      [
        "1",
        "2"
      ],
      [
        "2",
        "3"
      ]
    ]
  }
}'.
	self assertJSONEquals: result and: expectedResult.
	
	schema := self getSchema: 'invalidOutputListBoolean' withRoot: GQLTestSchema new.
	request := '{
		listOf(arrays: [ [1], [2], [ 0 ] ])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "listOf": [
      [
        true
      ],
      [
        true
      ],
      [
        false
      ]
    ]
  }
}'.
	self assertJSONEquals: result and: expectedResult.
	
	schema := self getSchema: 'invalidOutputListEnum' withRoot: GQLTestSchema new.
	request := '{
		listOf(arrays: [ [1], [2], [ 0 ] ])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "listOf": [
      [
        null
      ],
      [
        null
      ],
      [
        null
      ]
    ]
  },
  "errors": [
    {
      "message": "Expected a value of type \"MovieType\" but received: 1",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "listOf",
        0,
        0
      ]
    },
    {
      "message": "Expected a value of type \"MovieType\" but received: 2",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "listOf",
        1,
        0
      ]
    },
    {
      "message": "Expected a value of type \"MovieType\" but received: 0",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "listOf",
        2,
        0
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #'tests-wrapping types' }
GQLSTypeTest >> testNotNullInputValue [
	| request result expectedResult |
	schema := self getSchema: 'inputNotNullValue' withRoot: GQLTestSchema new.
	request := '{
		helloTo(name: null)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"name\" has invalid value null. Expected type \"String!\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 17
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.

	request := '{
		isEven(number: null)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"number\" has invalid value null. Expected type \"Int!\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 18
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.

	request := '{
		point(x: null){
			x
			y
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"x\" has invalid value null. Expected type \"Float!\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 12
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		point(x: 2.6){
			x
			y
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"point" : {
			"x" : 2.6,
			"y" : null
		}
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		nameGenders(listGender: [null])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"nameGenders" : null
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		listOf(arrays: [ [ 1, 2 ], [ 2, 3 ], [ 3, 4 ] ])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"listOf" : [
			[
				1,
				2
			],
			[
				2,
				3
			],
			[
				3,
				4
			]
		]
	}
}'.
	self assert: result equals: expectedResult.
	request := '{
		listOf(arrays: [ 1, 2 ])
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"listOf" : [
			[
				1
			],
			[
				2
			]
		]
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		listOf(arrays: 1)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data" : {
		"listOf" : [
			[
				1
			]
		]
	}
}'.
	self assert: result equals: expectedResult.
	
	request := '{
		listOf(arrays: null)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"arrays\" has invalid value null. Expected type \"[[Int!]!]!\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 18
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
]

{ #category : #'tests-wrapping types' }
GQLSTypeTest >> testNotNullOutputValue [
	| request result expectedResult |
	self skip.
	schema := self getSchema: 'outputNotNullValue' withRoot: GQLTestSchema new.
	request := '{
		filmsWith(rating: -1){
			filmName
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": null,
  "errors": [
    {
      "message": "Cannot return null for non-nullable field GQLTestSchema.filmsWith.",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "filmsWith"
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.

	request := '{
		point(x: null, y: null){
			x
			y
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": null,
  "errors": [
    {
      "message": "Cannot return null for non-nullable field GQLTestSchema.point.",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "point"
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.

	request := '{
		helloTo(name: null)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": null,
  "errors": [
    {
      "message": "Cannot return null for non-nullable field QQLTestSchema.helloTo.",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "helloTo"
      ]
    }
  ]
}'.
	self assertJSONEquals: request and: expectedResult.
]

{ #category : #'tests-object' }
GQLSTypeTest >> testObjectTypeOutputValue [
	| request result expectedResult |
	self skip.
	schema := self getSchema: 'outputObjectType' withRoot: GQLTestSchema new.
	
	request := '{
		hello{
			x
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "hello": {
      "x": null
    }
  }
}'.
	self assertJSONEquals: result and: expectedResult.

	request := '{
		point(x: 3.5, y: 6.5)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Field \"point\" of type \"Point\" must have a selection of subfields. Did you mean \"point { ... }\"?",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		point(x: 3.5, y: 6.5){
			z
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Cannot query field \"z\" on type \"Point\". Did you mean \"x\" or \"y\"?",
      "locations": [
        {
          "line": 3,
          "column": 4
        }
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		cats{
			name
			nickname
		}
	}'.
	expectedResult := '{
  "errors": [
    {
      "message": "Cannot query field \"nickname\" on type \"GQLCat\".",
      "locations": [
        {
          "line": 4,
          "column": 4
        }
      ]
    }
  ]
}'.
]

{ #category : #'tests-scalar' }
GQLSTypeTest >> testStringInputValue [
	"The only valid input type is String"
	| request resValidator expectedResult |
	schema := self getSchema: 'inputStringType' withRoot: GQLTestSchema new.
	request := '{
		helloTo(name: COMEDY)
	}'.
	resValidator := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"name\" has invalid value COMEDY. Expected type \"String\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 17
				}
			]
		}
	]
}'.
	self assert: resValidator equals: expectedResult.
	
	request := '{
		helloTo(name: Alex)
	}'.
	resValidator := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"name\" has invalid value Alex. Expected type \"String\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 17
				}
			]
		}
	]
}'.
	self assert: resValidator equals: expectedResult.
	
	request := '{
		helloTo(name: 1)
	}'.
	resValidator := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"name\" has invalid value 1. Expected type \"String\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 17
				}
			]
		}
	]
}'.
	self assert: resValidator equals: expectedResult.
	
	request := '{
		helloTo(name: true)
	}'.
	resValidator := self jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Argument \"name\" has invalid value true. Expected type \"String\".",
			"locations" : [
				{
					"line" : 2,
					"column" : 17
				}
			]
		}
	]
}'.
	self assert: resValidator equals: expectedResult.
]

{ #category : #'tests-scalar' }
GQLSTypeTest >> testStringOutputValue [
	"The valid output types are: (String, Int, Float, Boolean)"
	| request result expectedResult |
	self skip.
	schema := self getSchema: 'outputStringType' withRoot: GQLTestSchema new.
	
	request := '{
		hello
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
	"data": { 
		"hello" : "hello world"
	 }
	}
	'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		hell
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Cannot query field \"hell\" on type \"GQLTestSchema\". Did you mean \"hello\"?",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		totalFilms
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
    "data": {
      "totalFilms": "7"
    }
   }
	'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		isEven(number: 4)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
    "data": {
      "isEven": "true"
    }
   }
	'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		pi
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
    "data": {
      "pi": "3.1416"
    }
   }
	'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		point(x:2.3, y:5.6)
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "String cannot represent value: {x: 2.3, y: 5.6}",
      "locations": [
        {
          "line": 2,
          "column": 3
        }
      ],
      "path": [
        "point"
      ]
    }
  ],
  "data": {
    "point": null
  }
}
	'.
	self assertJSONEquals: result and: expectedResult.
]

{ #category : #'tests-union' }
GQLSTypeTest >> testUnionOutputValue [
	| request result expectedResult expectedResult2 |
	
	schema := self getSchema: 'outputUnionType' withRoot: GQLTestSchema new.
	request := '{
		firstSearchObject{
			name
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Cannot query field \"name\" on type \"SearchObject\"",
      "locations": [
        {
          "line": 3,
          "column": 4
        }
      ]
    }
  ]
}'.
	self assertJSONEquals: result and: expectedResult.
	
	request := '{
		firstSearchObject{
			... on Point{
				x
			}
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "firstSearchObject": {
        "x": 2.4
    }
  }
}'.
	expectedResult2 := '{
  "data": {
    "firstSearchObject": {  }
  	 }
	}'.
	result := (GraphQLPlatform current jsonFromString: result).
	self assert: ((result = (GraphQLPlatform current jsonFromString: expectedResult)) or: 
	[ result = (GraphQLPlatform current jsonFromString: expectedResult2)]).
	
	request := '{
		firstSearchObject{
			... on Point{
				x
			}
			... on Rectangle{
				origin { 
					y
				}
			}
		}
	}'.
	result := self jsonRequest: request.
	expectedResult := '{
  "data": {
    "firstSearchObject": {
        "x": 2.4
    }
  }
}'.
	expectedResult2 := '{
	"data": { 
		"firstSearchObject": { 
			"origin": { 
				"y": 5
			 }
		 }
	 }
	}'.
	result := (GraphQLPlatform current jsonFromString: result).
	self assert: (result = (GraphQLPlatform current jsonFromString: expectedResult) or: 
	[ result = (GraphQLPlatform current jsonFromString: expectedResult2)]).
]

{ #category : #'tests-variables' }
GQLSTypeTest >> testVariableInputObjectInputValue [
	| request result expectedResult variables |
	schema := self getSchema: 'inputVariable' withRoot: GQLTestSchema new.
	
	request := 'query operation1($testFilm: GQLTestFilmInput!){
		informationInput(film: $testFilm){
			description
		}
	}'.
	variables := '{"testFilm": {id: 1, filmName: "Rambo"}}'.
	result := self operation: 'operation1' variables: variables jsonRequest: request.
	expectedResult := '{
	"data" : {
		"informationInput" : {
			"description" : "Rambo"
		}
	}
}'.
	self assert: result equals: expectedResult.
	
	request := 'query operation1($testFilm: GQLTestFilmInput!){
		informationInput(film: $testFilm){
			description
		}
	}'.
	variables := '{"testFilm": {id: 1, filmName: "Rambo"}}'.
	result := self operation: 'operation1' variables: variables jsonRequest: request.
	expectedResult := '{
	"data" : {
		"informationInput" : {
			"description" : "Rambo"
		}
	}
}'.
]

{ #category : #'tests-variables' }
GQLSTypeTest >> testVariableInputValue [
	| request result expectedResult variables |
	schema := self getSchema: 'inputNotNullValue' withRoot: GQLTestSchema new.
	
	request := 'query operation1($name: String!){
		helloTo(name: $name)
	}'.
	variables := '{"name": "Alex"}'.
	result := self operation: 'operation1' variables: variables jsonRequest: request.
	expectedResult := '{
	"data" : {
		"helloTo" : "hello Alex"
		}
	}'.
	self assert: result equals: expectedResult.
	
	request := 'query operation1($num: String){
		isEven(number: $num)
	}'.
	variables := '{"num": 13}'.
	result := self operation: 'operation1' variables: variables jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Variable \"$num\" got invalid value 13. Expected type \"String\".",
			"locations" : [
				{
					"line" : 1,
					"column" : 18
				}
			]
		},
		{
			"message" : "Variable \"num\" of type \"String\" used in position expecting type \"Int!\".",
			"locations" : [
				{
					"line" : 1,
					"column" : 18
				},
				{
					"line" : 2,
					"column" : 18
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
	
	request := 'query operation1($num: Int){
		isEven(number: 3)
	}'.
	variables := '{"num": 3}'.
	result := self operation: 'operation1' variables: variables jsonRequest: request.
	expectedResult := '{
  "errors": [
    {
      "message": "Variable \"$num\" is never used in operation \"operation1\".",
      "locations": [
        {
          "line": 3,
          "column": 11
        }
      ]
    }
  ]
}'.
	
	request := 'query operation1($num: Int=2.3){
		isEven(number: $num)
	}'.
	variables := ''.
	result := self operation: 'operation1' variables: variables jsonRequest: request.
	expectedResult := '{
	"errors" : [
		{
			"message" : "Variable \"num\" of type \"Int\" used in position expecting type \"Int!\".",
			"locations" : [
				{
					"line" : 1,
					"column" : 18
				},
				{
					"line" : 2,
					"column" : 18
				}
			]
		},
		{
			"message" : "Expected type Int, found 2.3.",
			"locations" : [
				{
					"line" : 1,
					"column" : 28
				}
			]
		}
	]
}'.
	self assert: result equals: expectedResult.
]
