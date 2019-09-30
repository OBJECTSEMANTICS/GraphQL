"
A GQLSingleAnonimousQueryEvaluatorTest is a test class for testing the behavior of GQLSingleAnonimousQueryEvaluator
"
Class {
	#name : #GQLSingleAnonimousQueryEvaluatorTest,
	#superclass : #GQLTest,
	#category : #'GraphQLBeta-Tests-Grammar'
}

{ #category : #'tests-accessing' }
GQLSingleAnonimousQueryEvaluatorTest >> requestEvaluator [

	^ GQLSingleAnonimousQueryEvaluator
]

{ #category : #'tests-accessing' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocument [
	| request document |
	request := '{
		hello
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	
	self assert: document class equals: GQLDocumentNode.
	self assert: document operations first class equals: GQLSelectionSetNode.
	self assert: document operations first selections first class equals: GQLScalarFieldNode.
	self assert: document operations first selections first name equals: 'hello'.

	request := '{
		hello
		films { 
			name
			rating
		}
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.

	self assert: document class equals: GQLDocumentNode.
	self assert: document operations first class equals: GQLSelectionSetNode.
	self assert: document operations first selections first class equals: GQLScalarFieldNode.
	self assert: document operations first selections second class equals: GQLNonScalarFieldNode.
	self assert: document operations first selections first name equals: 'hello'.
	self assert: document operations first selections second name equals: 'films'.
	
	"object inner fields"	
	self assert: ((document operations first selections second) selectionSet selections at:1) class equals: GQLScalarFieldNode.
	self assert: ((document operations first selections second) selectionSet selections at:1) name equals: 'name'.
	self assert: ((document operations first selections second) selectionSet selections at:2) class equals: GQLScalarFieldNode.
	self assert: ((document operations first selections second) selectionSet selections at:2) name equals: 'rating'.

	

]

{ #category : #'tests-fieldsNonScalar' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentComposePosition [
	| request document fields selectionSet |
	request := '{
		hello
		films { 
			name
			rating
		}
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	fields := document operations first selections.
	selectionSet := fields second selectionSet selections.
	
	self assert: fields first position equals: 5.
	self assert: fields second position equals: 13.
	self assert: selectionSet first position equals: 25.
	self assert: selectionSet second position equals: 33.
]

{ #category : #'tests-fieldsNonScalar' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentComposedWithArguments [
	| request document selectionSet |
	request := '{
		hello(name: "Luke")
		films { 
			name (capitalize:true, prefix: "Film ")
			rating
		}
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	selectionSet := document operations first.
	self assert: document class equals: GQLDocumentNode.
	self assert: selectionSet class equals: GQLSelectionSetNode.
	self assert: (selectionSet selections at: 1) class equals: GQLScalarFieldNode.
	self assert: (selectionSet selections at: 1) name equals: 'hello'.
	
	self assert: (selectionSet selections at: 2) class equals: GQLNonScalarFieldNode.
	self assert: (selectionSet selections at: 2) name equals: 'films'.
	
	"arguments"
	self assert: ((selectionSet selections at: 1) arguments at: 1) class 
	     equals: GQLArgumentNode.
	self assert: ((selectionSet selections at: 1) arguments at: 1) name 
	     equals: 'name'.
	self assert: ((selectionSet selections at: 1) arguments at: 1) value class 
	     equals: GQLStringNode.
	
	"object inner fields"	
	self assert: ((selectionSet selections at: 2) selectionSet selections at:1) class equals: GQLScalarFieldNode .
	self assert: ((selectionSet selections at: 2) selectionSet selections at:1) name equals: 'name'.
	self assert: ((selectionSet selections at: 2) selectionSet selections at:2) class equals: GQLScalarFieldNode.
	self assert: ((selectionSet selections at: 2) selectionSet selections at:2) name equals: 'rating'.
	"arguments"
	self assert: (((selectionSet selections at: 2) selectionSet selections at:1) arguments at: 1) class 
		  equals: GQLArgumentNode.
	self assert: (((selectionSet selections at: 2) selectionSet selections at:1) arguments at: 1) name 
		  equals: 'capitalize'.
	self assert: (((selectionSet selections at: 2) selectionSet selections at:1) arguments at: 2) name 
		  equals: 'prefix'.

	

]

{ #category : #'tests-introspection' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentComposedWithSchema [
	| document selection |
	document := GQLSingleAnonimousQueryEvaluator parse: '{
		__schema{
			types{
				id
			}
			otherField
		}
	}'.
	self assert: document class equals: GQLDocumentNode.
	self assert: document operations first class equals: GQLSelectionSetNode.
	selection := document operations first selections first.
	self assert: selection class equals: GQLSchemaFieldNode.
	self assert: selection name equals: '__schema'.
	self assert: (selection selectionSet selections collect: [:select | select name]) equals: #('types' 'otherField').
]

{ #category : #'tests-introspection' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentComposedWithSchemaDirectives [
	| document selection |
	document := GQLSingleAnonimousQueryEvaluator parse: '{
		__schema @skip(if:true){
			types{
				id
			}
			otherField
		}
	}'.
	self assert: document class equals: GQLDocumentNode.
	self assert: document operations first class equals: GQLSelectionSetNode.
	selection := document operations first selections first.
	self assert: selection class equals: GQLSchemaFieldNode.
	self assert: selection name equals: '__schema'.
	self assert: selection directives first name equals: 'skip'.
	self assert: (selection selectionSet selections collect: [:select | select name]) equals: #('types' 'otherField').
]

{ #category : #'tests-introspection' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentComposedWithType [
	| document selection |
	document := GQLSingleAnonimousQueryEvaluator parse: '{
		__type(name: "SomeType"){
			name
			otherFields{
				id
			}
		}
	}'.
	self assert: document class equals: GQLDocumentNode.
	self assert: document operations first class equals: GQLSelectionSetNode.
	selection := document operations first selections first.
	self assert: selection class equals: GQLTypeFieldNode.
	self assert: selection name equals: '__type'.
	self assert: selection arguments first class equals: GQLArgumentNode.
	self assert: selection arguments first name equals: 'name'.
	self assert: (selection selectionSet selections collect: [:select | select name]) equals: #('name' 'otherFields').
]

{ #category : #'tests-introspection' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentComposedWithTypeDirectives [
	| document selection |
	document := GQLSingleAnonimousQueryEvaluator parse: '{
		__type(name: "SomeType") @include(if:false){
			name
			otherFields{
				id
			}
		}
	}'.
	self assert: document class equals: GQLDocumentNode.
	self assert: document operations first class equals: GQLSelectionSetNode.
	selection := document operations first selections first.
	self assert: selection class equals: GQLTypeFieldNode.
	self assert: selection name equals: '__type'.
	self assert: selection directives first name equals: 'include'.
	self assert: selection arguments first class equals: GQLArgumentNode.
	self assert: selection arguments first name equals: 'name'.
	self assert: (selection selectionSet selections collect: [:select | select name]) equals: #('name' 'otherFields').
]

{ #category : #'tests-fieldsFeatures' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentPosition [
	| request document fields |
	request := '{
		hello
		films
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	fields := document operations first selections.
	
	self assert: fields first position equals: 5.
	self assert: fields second position equals: 13.
]

{ #category : #'tests-fragmentSpread' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentSimpleComposedFragmentSpread [
| request document fragmentSpread |
	request := '{
		...named
		hello
	}
	fragment named on Person{
		...other @skip(if : true)
		hello(arg : 1) 
	}
	fragment other on Droid{
		name
	}
	'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	fragmentSpread := document operations first selections first.
	self assert: document class equals: GQLDocumentNode.
	self assert: fragmentSpread class equals: GQLFragmentSpreadNode.
	self assert: fragmentSpread name: 'named'.
	fragmentSpread := document fragments first selectionSet selections first.
	self assert: fragmentSpread class equals: GQLFragmentSpreadNode.
	self assert: fragmentSpread name: 'other'.
	self assert: fragmentSpread directives first class: GQLSkipDirectiveNode.
]

{ #category : #'tests-inlineFragment' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentSimpleComposedInlineFragment [
| request document inline |
	request := '{
		...{
		 name
		 ...{
			hello(arg : 1) 
		 }
		}
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	inline := document operations first selections first.
	self assert: document class equals: GQLDocumentNode.
	self assert: inline class equals: GQLInlineFragmentNode.
	self assert: inline typeCondition equals: nil.
	self assert: inline directives equals: #().
	self assert: inline selectionSet selections first name equals:'name'.
	inline := inline selectionSet selections second.
	self assert: inline class equals: GQLInlineFragmentNode.
	self assert: inline selectionSet selections first name equals:'hello'.
]

{ #category : #'tests-fragment' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentSimpleFragmentDefinition [
| request document fragment |
	request := '{
		hello (name: "Luke")
	}
	fragment named on Person{
		name @skip(if : false)
		hello(arg : 1) 
	}
	fragment other on Droid{
		name
	}
	'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	fragment := document fragments first.
	self assert: document class equals: GQLDocumentNode.
	self assert: fragment class equals: GQLFragmentNode.
	self assert: fragment name: 'named'.
	self assert: fragment typeCondition class: GQLSNamedTypeNode.
	self assert: fragment typeCondition name: 'Person'.
	self assert: fragment selectionSet selections size equals: 2.
	self assert: fragment selectionSet selections first name: 'name'.
	self assert: fragment selectionSet selections second name: 'hello'.
	fragment := document fragments second.
	self assert: fragment class equals: GQLFragmentNode.
	self assert: fragment name: 'other'.
	self assert: fragment typeCondition class: GQLSNamedTypeNode.
	self assert: fragment typeCondition name: 'Droid'.
	self assert: fragment selectionSet selections size equals: 1.
	self assert: fragment selectionSet selections first name: 'name'.
]

{ #category : #'tests-fragmentSpread' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentSimpleFragmentSpread [
| request document fragmentSpread |
	request := '{
		...named
		...other @skip(if : true)
		hello
	}
	fragment named on Person{
		name @skip(if : false)
		hello(arg : 1) 
	}
	fragment other on Droid{
		name
	}
	'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	fragmentSpread := document operations first selections first.
	self assert: document class equals: GQLDocumentNode.
	self assert: fragmentSpread class equals: GQLFragmentSpreadNode.
	self assert: fragmentSpread name: 'named'.
	fragmentSpread := document operations first selections second.
	self assert: fragmentSpread class equals: GQLFragmentSpreadNode.
	self assert: fragmentSpread name: 'other'.
	self assert: fragmentSpread directives first class: GQLSkipDirectiveNode.
]

{ #category : #'tests-inlineFragment' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentSimpleInlineFragment [
| request document inline |
	request := '{
		...{
		name @skip(if : false)
		hello(arg : 1) 
		}
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	inline := document operations first selections first.
	self assert: document class equals: GQLDocumentNode.
	self assert: inline class equals: GQLInlineFragmentNode.
	self assert: inline typeCondition equals: nil.
	self assert: inline directives equals: #().
	self assert: inline selectionSet selections first name equals:'name'.
	self assert: inline selectionSet selections second name equals:'hello'.
]

{ #category : #'tests-inlineFragment' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentSimpleInlineFragmentDirectives [
| request document inline |
	request := '{
	   hello
		... on Film @skip(if:true){
		name @skip(if : false)
		hello(arg : 1) 
		}
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	inline := document operations first selections second.
	self assert: document class equals: GQLDocumentNode.
	self assert: inline class equals: GQLInlineFragmentNode.
	self assert: inline typeCondition class equals: GQLSNamedTypeNode.
	self assert: inline typeCondition name equals: 'Film'.
	self assert: inline directives first class equals: GQLSkipDirectiveNode.
	self assert: inline selectionSet selections first name equals:'name'.
	self assert: inline selectionSet selections second name equals:'hello'.
]

{ #category : #'tests-inlineFragment' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentSimpleInlineFragmentType [
| request document inline |
	request := '{
		... on Film{
		name @skip(if : false)
		hello(arg : 1) 
		}
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	inline := document operations first selections first.
	self assert: document class equals: GQLDocumentNode.
	self assert: inline class equals: GQLInlineFragmentNode.
	self assert: inline typeCondition class equals: GQLSNamedTypeNode.
	self assert: inline typeCondition name equals: 'Film'.
	self assert: inline directives equals: #().
	self assert: inline selectionSet selections first name equals:'name'.
	self assert: inline selectionSet selections second name equals:'hello'.
]

{ #category : #'tests-fieldsScalar' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentSimpleWithArguments [
	| request document selectionSet |
	request := '{
		hello (name: "Luke")
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	selectionSet := document operations first.
	self assert: document class equals: GQLDocumentNode.
	self assert: selectionSet class equals: GQLSelectionSetNode.
	self assert: selectionSet selections first class equals: GQLScalarFieldNode.
	self assert: selectionSet selections first name equals: 'hello'.
	
	self assert: ((selectionSet selections at: 1) arguments at: 1) class equals: GQLArgumentNode.
	self assert: ((selectionSet selections at: 1) arguments at: 1) name equals: 'name'.
	self assert: ((selectionSet selections at: 1) arguments at: 1) value class equals: GQLStringNode.
	
]

{ #category : #'tests-fieldsScalar' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentSimpleWithArgumentsAndDirective [
	| request document selectionSet |
	request := '{
		hello (name: "Luke") @include(if : true)
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	selectionSet := document operations first.
	self assert: document class equals: GQLDocumentNode.
	self assert: selectionSet class equals: GQLSelectionSetNode.
	self assert: selectionSet selections first class equals: GQLScalarFieldNode.
	self assert: selectionSet selections first name equals: 'hello'.
	
	self assert: ((selectionSet selections at: 1) arguments at: 1) class equals: GQLArgumentNode.
	self assert: ((selectionSet selections at: 1) arguments at: 1) name equals: 'name'.
	self assert: ((selectionSet selections at: 1) arguments at: 1) value class equals: GQLStringNode.
	self assert: (selectionSet selections at: 1) directives size equals: 1.
	self assert: (selectionSet selections at: 1) directives first class: GQLIncludeDirectiveNode.
	self assertArguments: (selectionSet selections at: 1) directives first 
				withNames: #('if').
	self assertArguments: (selectionSet selections at: 1) directives first 
				withValues: #('true').
]

{ #category : #'tests-fieldsScalar' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentSimpleWithArgumentsAndDirectives [
	| request document selectionSet |
	request := '{
		hello (name: "Luke") @include(if : true) @skip(if : false)
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	selectionSet := document operations first.
	self assert: document class equals: GQLDocumentNode.
	self assert: selectionSet class equals: GQLSelectionSetNode.
	self assert: selectionSet selections first class equals: GQLScalarFieldNode.
	self assert: selectionSet selections first name equals: 'hello'.
	
	self assert: ((selectionSet selections at: 1) arguments at: 1) class equals: GQLArgumentNode.
	self assert: ((selectionSet selections at: 1) arguments at: 1) name equals: 'name'.
	self assert: ((selectionSet selections at: 1) arguments at: 1) value class equals: GQLStringNode.
	self assert: (selectionSet selections at: 1) directives size equals: 2.
	self assert: (selectionSet selections at: 1) directives first class: GQLIncludeDirectiveNode.
	self assertArguments: (selectionSet selections at: 1) directives first 
				withNames: #('if').
	self assertArguments: (selectionSet selections at: 1) directives first 
				withValues: #('true').
	self assert: (selectionSet selections at: 1) directives second class: GQLSkipDirectiveNode.
	self assertArguments: (selectionSet selections at: 1) directives second 
				withNames: #('if').
	self assertArguments: (selectionSet selections at: 1) directives second 
				withValues: #('false').
]

{ #category : #'tests-introspection' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentSimpleWithTypename [
	| request document selectionSet |
	request := '{
		__typename
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	selectionSet := document operations first.
	self assert: document class equals: GQLDocumentNode.
	self assert: selectionSet class equals: GQLSelectionSetNode.
	self assert: selectionSet selections first class equals: GQLTypenameFieldNode.
	self assert: selectionSet selections first name equals: '__typename'.
	
]

{ #category : #'tests-introspection' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentSimpleWithTypenameDirectives [
	| document selectionSet |
	document := GQLSingleAnonimousQueryEvaluator parse: '{
		__typename @include(if:true)
	}'.
	selectionSet := document operations first.
	self assert: document class equals: GQLDocumentNode.
	self assert: selectionSet class equals: GQLSelectionSetNode.
	self assert: selectionSet selections first class equals: GQLTypenameFieldNode.
	self assert: selectionSet selections first name equals: '__typename'.
	self assert: selectionSet selections first directives first name equals: 'include'.
	
	document := GQLSingleAnonimousQueryEvaluator parse: '{
		__typename @skip(if:true)
	}'.
	selectionSet := document operations first.
	self assert: document class equals: GQLDocumentNode.
	self assert: selectionSet class equals: GQLSelectionSetNode.
	self assert: selectionSet selections first class equals: GQLTypenameFieldNode.
	self assert: selectionSet selections first name equals: '__typename'.
	self assert: selectionSet selections first directives first name equals: 'skip'.
	
	
]

{ #category : #'tests-fieldsFeatures' }
GQLSingleAnonimousQueryEvaluatorTest >> testDocumentWithArgumentsPosition [
	| request document fields arguments |
	request := '{
		hello (name : "Luke")
	}'.
	document := GQLSingleAnonimousQueryEvaluator parse: request.
	fields := document operations first selections.
	arguments := fields first arguments.
	
	self assert: fields first position equals: 5.
	self assert: arguments first position equals: 12.
]

{ #category : #'tests-fieldsFeatures' }
GQLSingleAnonimousQueryEvaluatorTest >> testFieldsAlias [
	| document userField subField |
	document := self parseRequest: '{
  				user(id: 4) {
    					name
    					smallPic: profilePic(size: 64)
    					bigPic: profilePic(size: 1024)
  			}
		}'.
	self assert: document class: GQLDocumentNode.
	userField := document operations first selections first.
	self assert: userField class: GQLNonScalarFieldNode.
	self assert: userField name: 'user'.
	self assert: userField arguments first name: 'id'.
	self assertSelections: userField withNames: #('name' 'profilePic' 'profilePic').
	subField := userField selectionSet selections second.
	self assert: subField alias equals: 'smallPic'.
	self assertArguments: subField withValues: #('64').
	subField := userField selectionSet selections third.
	self assert: subField alias equals: 'bigPic'.
	self assertArguments: subField withValues: #('1024').
	
]
