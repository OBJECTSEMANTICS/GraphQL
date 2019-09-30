"
I have a test on heroes for test resources
"
Class {
	#name : #GraphQLHeroTest,
	#superclass : #GQLTest,
	#category : #'GraphQLBeta-Test-Utils'
}

{ #category : #tests }
GraphQLHeroTest >> createHeroClass [
	| c |
	c := Object
		subclass: 'Hero'
		instanceVariableNames: 'name planet'
		classVariableNames: ''
		package: 'DummyPackage'.
	c compile: 'name ^ name'.
	c
		compile:
			'name: aString
	name := aString'.
	c compile: 'planet ^ planet'.
	c
		compile:
			'planet: aString
	planet := aString'.
	^ c
]

{ #category : #accessing }
GraphQLHeroTest >> heroes [
	| c clazz |
	c := OrderedCollection new.
	clazz := GraphQLPlatform current classAt: #Hero.
	c
		add: (clazz new name: 'Superman'; planet: 'Krypton');
		add: (clazz new name: 'Mars pathfinder'; planet: 'Mars');
		add: (clazz new name: 'Curiosity'; planet: 'Mars');
		add: (clazz new name: 'Philae'; planet: 'comet 67P/Churyumov–Gerasimenko').
	^ c
]

{ #category : #accessing }
GraphQLHeroTest >> schema [
	^ '
	schema{
		query: GraphQLHeroTest
	}
	type GraphQLHeroTest{
		heroes: [ Hero ]
	},
	type Hero{
		name : String
		planet : String
	}'
]

{ #category : #tests }
GraphQLHeroTest >> testOnHero [
	| c g res pkg |
	c := self createHeroClass.
	g := GraphQL new.
	g rootInstance: self.
	g createSchema: self schema.
	res := g
		handleRequest:
			'
{
	heroes{
		name
		planet	
	}
}'.
	res := res at: 'data'.
	self assert: (res at: 'heroes') class equals: OrderedCollection.
	c removeFromSystem.
	pkg := 'DummyPackage' asPackageIfAbsent: [  ].
	pkg ifNotNil: [ pkg removeFromSystem ]
]
