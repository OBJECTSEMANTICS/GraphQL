"
https://facebook.github.io/graphql/draft/#sec-Validation.Fields
"
Class {
	#name : #GQLZGeneralTest,
	#superclass : #GQLTestValidation,
	#category : #'GraphQLBeta-Tests-Validation'
}

{ #category : #initialization }
GQLZGeneralTest >> setUp [
	schema := self parseSchema: GQLTestQueryType schema.
	rootInstance := GQLTestQueryType new.
	schema root: rootInstance.
	compareJson := false.
]

{ #category : #tests }
GQLZGeneralTest >> test01FieldInvalidQuery [
	| result |
	compareJson := true.
	result := self jsonRequest: '# INVALID: bestActor does not exist on GQLTestFilm
{
	films {
		name
		bestActor
	}
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Cannot query field \"bestActor\" on type \"GQLTestFilm\"",
			"locations" : [
				{
					"line" : 5,
					"column" : 3
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLZGeneralTest >> test02InvalidRecursiveFragment [
	| result |
	compareJson := true.
	result := self jsonRequest: '
#Invalid fragment cant have recursive
{
	films {
		...foo
	}
}
fragment foo on GQLTestFilm{
	id
	... bar
}
fragment bar on GQLTestFilm{
	name
	... foo
}
'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Cannot spread fragment \"foo\" with itself via bar",
			"locations" : [
				{
					"line" : 10,
					"column" : 6
				}
			]
		},
		{
			"message" : "Cannot spread fragment \"bar\" with itself via foo",
			"locations" : [
				{
					"line" : 14,
					"column" : 6
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLZGeneralTest >> test03FielsAsScalar [
	| result |
	compareJson := true.
	result := self jsonRequest: '# INVALID: hero is not a scalar, so fields are needed
{
  films
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Field \"films\" on type \"[GQLTestFilm]\" must have selection of subfields. Did you mean \"films { ... }\"?",
			"locations" : [
				{
					"line" : 3,
					"column" : 3
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLZGeneralTest >> test04ScalarWithFields [
	| result |
	compareJson := true.
	result := self jsonRequest: '# INVALID: name is a scalar, so fields are not permitted
{
  films {
    name {
      firstCharacterOfName
    }
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Field \"name\" must not have selection since type \"String\" has no subfields.",
			"locations" : [
				{
					"line" : 4,
					"column" : 10
				}
			]
		}
	]
}'
]

{ #category : #tests }
GQLZGeneralTest >> test05InvalidField [
	| result |
	compareJson := true.
	result := self jsonRequest: '# INVALID: primaryFunction does not exist on Character
{
  films {
    name
    primaryFunction
  }
}'.
	self assert: result equals: '{
	"errors" : [
		{
			"message" : "Cannot query field \"primaryFunction\" on type \"GQLTestFilm\"",
			"locations" : [
				{
					"line" : 5,
					"column" : 5
				}
			]
		}
	]
}'.
]

{ #category : #tests }
GQLZGeneralTest >> test06GeneralInstrospectionQuery [
	| result |
	compareJson := true.
	result := GraphQL new 
		shouldValidate: true;
		handleRequest: '
query IntrospectionQuery {
	__schema {
		queryType { name }
		mutationType { name }
		subscriptionType { name }
		types {
		...FullType
		}
		directives {
			name
			description
			locations
			args {
			...InputValue
			}
		}
	}
}
fragment FullType on Type {
      kind
      name
      description
      fields(includeDeprecated: true) {
        name
        description
        args {
          ...InputValue
        }
        type {
          ...TypeRef
        }
        isDeprecated
        deprecationReason
      }
      inputFields {
        ...InputValue
      }
      interfaces {
        ...TypeRef
      }
      enumValues(includeDeprecated: true) {
        name
        description
        isDeprecated
        deprecationReason
      }
      possibleTypes {
        ...TypeRef
      }
    }

    fragment InputValue on InputValue {
      name
      description
      type { ...TypeRef }
      defaultValue
    }

    fragment TypeRef on Type {
      kind
      name
      ofType {
        kind
        name
        ofType {
          kind
          name
          ofType {
            kind
            name
            ofType {
              kind
              name
              ofType {
                kind
                name
                ofType {
                  kind
                  name
                  ofType {
                    kind
                    name
                  }
                }
              }
            }
          }
        }
      }
    }'.
	
	self deny: (result includesKey: 'errors').
]

{ #category : #tests }
GQLZGeneralTest >> test07GeneralRequest [
	| result |
	compareJson := true.
	result := GraphQL new 
		operation: 'm1';
		variables: '{"person":{name:"Andre"},"prefix":"Abst"}';
		shouldValidate: true;
		handleRequest: '
		#comment of op1
query op1($person: PersonInput={name:"Alex"}){
  ...fr
  helloMessage(to:$person)
  filmsOn(gender:ACTION){
    rating
    ...fr2
    director{
      __typename
      ...fr2
    }
  }
  #comment inside
	dirAndF: directorsAndFilms{
    #inline fragment
    ...on namedItem{
      __typename
      name
    }
  }
}
#comment in m1
mutation m1{
  createPoint(x: 2, y:5){
    x
    y
  }
}
#comment in m2
mutation m2{
  createRectangle(left:3, right:5, top:6,bottom:1){
    origin{
      x @skip(if:true)
      y
    }
    corner{
      x
      y
    }
  }
}
#comment in op2
query op2($prefix:String){
  ...fr
  allClassesStarting(with: $prefix){
    ...fr2
  }
  #comment inside
}
#comment of fragment fr
fragment fr on GQLQuery{
  __typename
  #fragment spread
  hi: hello
}

fragment fr2 on namedItem{
  #comment of field before
  name
  #comment of field after
}'.
	
	self deny: (result includesKey: 'errors').
]

{ #category : #'tests - coercion' }
GQLZGeneralTest >> testBooleanInputCoercion [
	"https://facebook.github.io/graphql/draft/#sec-Boolean"
	| type value coercedValue |
	type := GQLSBooleanTypeNode new.
	
	value := GQLBooleanNode new value: 'true'.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue value equals: 'true'.
	
	value := GQLNullNode new.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue value equals: nil.
	
	value := GQLIntNode new value: '0'.
	self should: [ coercedValue := type coerceValue: value on: nil. ] raise: Error.
	
]

{ #category : #'tests - coercion' }
GQLZGeneralTest >> testDemoCoercion [
	| result |
	compareJson := true.
	result := self jsonRequest: '
{
	listOfInts(ints: 0)
}'.
	self assert: result equals:'{
	"data" : {
		"listOfInts" : [
			0
		]
	}
}'
]

{ #category : #'tests - coercion' }
GQLZGeneralTest >> testFloatInputCoercion [
	"https://facebook.github.io/graphql/draft/#sec-Float"
	| type value coercedValue |
	type := GQLSFloatTypeNode new.
	
	value := GQLFloatNode new value: '3.1416'.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue value equals: '3.1416'.
	
	value := GQLNullNode new.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue value equals: nil.
	
	value := GQLStringNode new value: '0'.
	self should: [ coercedValue := type coerceValue: value on: nil. ] raise: Error.
	
	value := GQLIntNode new value: '2147483648'.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue value equals: '2147483648.0'.
	
	
]

{ #category : #'tests - coercion' }
GQLZGeneralTest >> testIDInputCoercion [
	"https://facebook.github.io/graphql/draft/#sec-Boolean"
	| type value coercedValue |
	type := GQLSIDTypeNode new.
	value := GQLIntNode new value: '123456'.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue value equals: '123456'.
	
	value := GQLNullNode new.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue value equals: nil.
	
	value := GQLStringNode new value: '"123456"'.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue value equals: '"123456"'.
	
	value := GQLBooleanNode new value: 'true'.
	self should: [ coercedValue := type coerceValue: value on: nil. ] raise: Error.
	
]

{ #category : #'tests - coercion' }
GQLZGeneralTest >> testInputObjectCoercion [
	"https://facebook.github.io/graphql/draft/#sec-Input-Objects"
	| type value coercedValue |
	type := GQLSInputObjectTypeNode new
		name: 'foo';
		addFields: (Array 
			with: (GQLSInputObjectFieldNode new 
				name: 'a'; 
				type: GQLSStringTypeNode new)
			with: (GQLSInputObjectFieldNode new 
				name: 'b'; 
				type: (GQLSNonNullTypeNode new 
					wrappedType: GQLSIntTypeNode new)) ).
	"literal { a: 'abc', b: 123 }"
	value := GQLObjectNode new objectFields: (Array 
		with: (GQLObjectFieldNode new 
			name: 'a';
			value: (GQLStringNode new value: '"abc"'))
		with: (GQLObjectFieldNode new 
			name: 'b';
			value: (GQLIntNode new value: '123'))).
			
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue asString equals: '{a: "abc", b: 123}'.
	
	(value objectFields at: 1) value: GQLNullNode new.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue asString equals: '{a: null, b: 123}'.
	
	value objectFields: (Array with: 
		(GQLObjectFieldNode new
			name: 'b';
			value: (GQLIntNode new value: '123'))).
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue asString equals: '{b: 123}'.
	
	value objectFields: (Array 
		with: (GQLObjectFieldNode new 
			name: 'a';
			value: (GQLVariableNode new value: 'var'))
		with: (GQLObjectFieldNode new
			name: 'b';
			value: (GQLIntNode new value: '123'))).
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue asString equals: '{a: $var, b: 123}'.

	value := GQLVariableNode new value: 'var'.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue asString equals: '$var'.
	
	value := GQLStringNode new value: '"abc123"'.
	self should: [ type coerceValue: value on: nil ] raise: Error.
	

	
]

{ #category : #'tests - coercion' }
GQLZGeneralTest >> testIntInputCoercion [
	"https://facebook.github.io/graphql/draft/#sec-Int"
	| type value coercedValue |
	type := GQLSIntTypeNode new.
	
	value := GQLIntNode new value: '0'.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue value equals: '0'.
	
	value := GQLNullNode new.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue value equals: nil.
	
	value := GQLStringNode new value: '0'.
	self should: [ coercedValue := type coerceValue: value on: nil. ] raise: Error.
	
	value := GQLIntNode new value: '2147483648'.
	self should: [ coercedValue := type coerceValue: value on: nil. ] raise: Error.
	
	
]

{ #category : #'tests - coercion' }
GQLZGeneralTest >> testListInputCoercion [
	"https://facebook.github.io/graphql/draft/#sec-Type-System.List"
	| type value coercedValue |
	type := GQLSListTypeNode new
		wrappedType: GQLSIntTypeNode new.
	
	value := GQLListNode new value: (Array 
		with: (GQLIntNode new value: '1')
		with: (GQLIntNode new value: '2')
		with: (GQLIntNode new value: '3') ).
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue asString equals: '[1, 2, 3]'.
	
	value := GQLListNode new value: (Array 
		with: (GQLIntNode new value: '1')
		with: (GQLStringNode new value: '"b"')
		with: (GQLIntNode new value: '3') ).
	self should: [ type coerceValue: value on: nil ] raise: Error.
	
	value := GQLIntNode new value: '1'.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue asString equals: '[1]'.
	
	value := GQLNullNode new.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue asString equals: 'null'.
	
	type := GQLSListTypeNode new 
		wrappedType: (GQLSListTypeNode new
			wrappedType: GQLSIntTypeNode new).
			
	value := GQLListNode new value: (Array 
		with: (GQLListNode new value: (Array 
			with: (GQLIntNode new value: '1') ) )
		with: (GQLListNode new value: (Array 
			with: (GQLIntNode new value: '2')
			with: (GQLIntNode new value: '3' ) ) ) ).
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue asString equals: '[[1], [2, 3]]'.
	
	value := GQLListNode new value: (Array 
		with: (GQLIntNode new value: '1')
		with: (GQLIntNode new value: '2')
		with: (GQLIntNode new value: '3') ).
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue asString equals: '[[1], [2], [3]]'.
	
	value := GQLIntNode new value: '1'.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue asString equals: '[[1]]'.
]

{ #category : #'tests - coercion' }
GQLZGeneralTest >> testStringInputCoercion [
	"https://facebook.github.io/graphql/draft/#sec-String"
	| type value coercedValue |
	type := GQLSStringTypeNode new.
	
	value := GQLStringNode new value: '"3.1416"'.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue value equals: '"3.1416"'.
	
	value := GQLNullNode new.
	coercedValue := type coerceValue: value on: nil.
	self assert: coercedValue value equals: nil.
	
	value := GQLIntNode new value: '0'.
	self should: [ coercedValue := type coerceValue: value on: nil. ] raise: Error.
	
]
