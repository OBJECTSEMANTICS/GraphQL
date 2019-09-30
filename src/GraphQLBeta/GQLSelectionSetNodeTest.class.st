"
A GQLSelectionSetNodeTest is a test class for testing the behavior of GQLSelectionSetNode
"
Class {
	#name : #GQLSelectionSetNodeTest,
	#superclass : #TestCase,
	#instVars : [
		'selectionSet',
		'objectNode1',
		'innerEscalar',
		'objectNode2',
		'field1',
		'field2',
		'context'
	],
	#category : #'GraphQLBeta-Tests-Nodes'
}

{ #category : #running }
GQLSelectionSetNodeTest >> setUp [

	selectionSet := GQLSelectionSetNode new.
	objectNode1 := GQLNonScalarFieldNode new.
	objectNode2 := GQLNonScalarFieldNode new.
	field1 := GQLScalarFieldNode new.
	field2 := GQLScalarFieldNode new.
	context := GQLContext new.
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testCollectFieldsDistintComposed [

	| res |
	objectNode1 name: 'film'.
	innerEscalar := Array with: (GQLFieldNode new name: 'name').
	objectNode1 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	
	objectNode2 name: 'allFilms'.
	innerEscalar := Array with: (GQLFieldNode new name: 'rating').
	objectNode2 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	selectionSet selections: (Array with: objectNode1 with: objectNode2).
	
	res := selectionSet collectFields: context.
	self assert: res keys size equals: 2.
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testCollectFieldsDistintSimple [

	| res |
	field1 name: 'hello'.
	field2 name: 'text'.
	selectionSet selections: (Array with: field1 with: field2).
	
	res := selectionSet collectFields: context.
	self assert: res keys size equals: 2.
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testCollectFieldsSameComposed [

	| res |
	objectNode1 name: 'film'.
	innerEscalar := Array with: (GQLFieldNode new name: 'name').
	objectNode1 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	
	objectNode2 name: 'film'.
	innerEscalar := Array with: (GQLFieldNode new name: 'rating').
	objectNode2 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	
	selectionSet selections: (Array with: objectNode1 with: objectNode2).
	
	res := selectionSet collectFields: context.
	self assert: res keys size equals: 1.
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testCollectFieldsSameSimple [

	| res |
	field1 name: 'hello'.
	field2 name: 'hello'.
	selectionSet selections: (Array with: field1 with: field2).
	
	res := selectionSet collectFields: context.
	self assert: res keys size equals: 1.
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testFailCollectFieldsComposed [

	| res argument |
	argument := GQLArgumentNode new name: 'id'; value: '1'.
	objectNode1 name: 'film'; arguments: (Array with: argument).
	innerEscalar := Array with: (GQLFieldNode new name: 'name').
	objectNode1 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	
	objectNode2 name: 'film'.
	innerEscalar := Array with: (GQLFieldNode new name: 'rating').
	objectNode2 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	selectionSet selections: (Array with: objectNode1 with: objectNode2).
	
	self should: [ selectionSet collectFields: context ] raise: GQLException.
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testFailCollectFieldsSimple [

	| argument |
	argument := GQLArgumentNode new name: 'id'; value: '4'.
	field1 name: 'hello';
			arguments: (Array with: argument).
	field2 name: 'hello'.
	selectionSet selections: (Array with: field1 with: field2).
	
	self should: [ selectionSet collectFields: context. ] raise: GQLException.
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testFailSameShapeWithNonScalarFieldArguments [

	| argument |
	argument := GQLArgumentNode new name: 'id'; value: '1'.
	objectNode1 name: 'film'; arguments: (Array with: argument).
	innerEscalar := Array with: (GQLFieldNode new name: 'name').
	objectNode1 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	
	argument := GQLArgumentNode new name: 'id'; value: '2'.
	objectNode2 name: 'film'; arguments: (Array with: argument).
	innerEscalar := Array with: (GQLFieldNode new name: 'rating').
	objectNode2 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	
	self deny: (selectionSet sameShape: objectNode1  with: objectNode2).
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testFailSameShapeWithScalarFieldArguments [

	| argument |
	argument := GQLArgumentNode new name: 'id'; value: '4'.
	field1 name: 'hello';
			arguments: (Array with: argument).
	argument := GQLArgumentNode new name: 'id'; value: '2'.
	field2 name: 'hello';
			arguments: (Array with: argument).
	selectionSet selections: (Array with: field1 with: field2).

	self deny: (selectionSet sameShape: field1  with: field2).
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testMergeSelectionSetWith [

	objectNode1 name: 'film'.
	innerEscalar := Array with: (GQLFieldNode new name: 'name').
	objectNode1 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	
	objectNode2 name: 'film'.
	innerEscalar := Array with: (GQLFieldNode new name: 'rating').
	objectNode2 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	
	selectionSet mergeSelectionSet: objectNode1  with: objectNode2 .
	
	self assert:  objectNode1 selectionSet selections size equals: 2.
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testSameShapeWithNonScalarField [

	objectNode1 name: 'film'.
	innerEscalar := Array with: (GQLFieldNode new name: 'name').
	objectNode1 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	
	objectNode2 name: 'film'.
	innerEscalar := Array with: (GQLFieldNode new name: 'rating').
	objectNode2 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	
	self assert: (selectionSet sameShape: objectNode1  with: objectNode2).
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testSameShapeWithNonScalarFieldArguments [

	| argument |
	argument := GQLArgumentNode new name: 'id'; value: '1'.
	objectNode1 name: 'film'; arguments: (Array with: argument).
	innerEscalar := Array with: (GQLFieldNode new name: 'name').
	objectNode1 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	
	objectNode2 name: 'film'; arguments: (Array with: argument).
	innerEscalar := Array with: (GQLFieldNode new name: 'rating').
	objectNode2 selectionSet: (GQLSelectionSetNode new selections: innerEscalar).
	
	self assert: (selectionSet sameShape: objectNode1  with: objectNode2).
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testSameShapeWithScalarField [

	field1 name: 'hello'.
	field2 name: 'hello'.
	selectionSet selections: (Array with: field1 with: field2).

	self assert: (selectionSet sameShape: field1  with: field2).
]

{ #category : #'tests-accessing' }
GQLSelectionSetNodeTest >> testSameShapeWithScalarFieldArguments [

	| argument |
	argument := GQLArgumentNode new name: 'id'; value: '4'.
	field1 name: 'hello';
			arguments: (Array with: argument).
	field2 name: 'hello';
			arguments: (Array with: argument).
	selectionSet selections: (Array with: field1 with: field2).

	self assert: (selectionSet sameShape: field1  with: field2).
]
