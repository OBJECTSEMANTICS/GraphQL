"
I represent a int type.
"
Class {
	#name : #GQLSIntTypeNode,
	#superclass : #GQLSScalarTypeNode,
	#classInstVars : [
		'MIN',
		'MAX'
	],
	#category : #'GraphQLBeta-NodesSchema'
}

{ #category : #'class initialization' }
GQLSIntTypeNode class >> initialize [
	super initialize.
	"https://facebook.github.io/graphql/October2016/#sec-Int"
	MAX := 2 raisedTo: 31.
	MIN := MAX negated.
	MAX := MAX -1.
]

{ #category : #accessing }
GQLSIntTypeNode class >> max [
	^ MAX
]

{ #category : #accessing }
GQLSIntTypeNode class >> min [
	^ MIN
]

{ #category : #testing }
GQLSIntTypeNode >> basicCoerce: value on: schema [
	^ value class = GQLIntNode and: [ 
		value value asNumber between: self class min and: self class max ]
]

{ #category : #initialization }
GQLSIntTypeNode >> initialize [
	super initialize.
	name := 'Int'
]
