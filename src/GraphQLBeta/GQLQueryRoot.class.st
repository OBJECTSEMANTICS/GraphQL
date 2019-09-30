"
I am a utility class for test validations
"
Class {
	#name : #GQLQueryRoot,
	#superclass : #Object,
	#category : #'GraphQLBeta-Test-Utils'
}

{ #category : #accessing }
GQLQueryRoot class >> schema [
	^ 
'enum DogCommand { SIT, DOWN, HEEL }
schema { 
	query: GQLQueryRoot
}
type GQLDog implements GQLPet{
  name: String!
  nickname: String
  barkVolume: Int
  doesKnowCommand(dogCommand: DogCommand!): Boolean!
  isHousetrained(atOtherHomes: Boolean): Boolean!
  owner: GQLHuman
}

interface GQLSentient {
  name: String!
}

type GQLAlien implements GQLSentient {
  name: String!
  homePlanet: String
}

interface GQLPet {
  name: String!
}

type GQLHuman implements GQLSentient {
  name: String!
}

enum CatCommand { JUMP }

type GQLCat implements GQLPet {
  name: String!
  nickname: String
  doesKnowCommand(catCommand: CatCommand!): Boolean!
  meowVolume: Int
}

union CatOrDog = GQLCat | GQLDog
union DogOrHuman = GQLDog | GQLHuman
union HumanOrAlien = GQLHuman | GQLAlien
type GQLArguments {
	singleID(id: ID): Boolean
	singleString(string: String): String
	multipleReqs(x: Int!, y: Int!): Int!
	booleanArgField(booleanArg: Boolean): Boolean
	floatArgField(floatArg: Float): Float
	intArgField(intArg: Int): Int
	nonNullBooleanArgField(nonNullBooleanArg: Boolean!): Boolean!
	booleanListArgField(booleanListArg: [Boolean]!): [Boolean]
	nonNullBooleanListField(nonNullBooleanListArg: [Boolean]!): [Boolean]
	optionalNonNullBooleanArgField(optionalBooleanArg: Boolean!): Boolean!
}
input GQLDogInput{
	name: String
	complex: GQLComplexInput
}
input GQLComplexInput{
	foo: Int
	bar: String!
}
type GQLQueryRoot {
	findDog(complex: GQLDogInput): GQLDog
	findDogNotNull(complex: GQLDogInput!): GQLDog
	dog: GQLDog
	human: GQLHuman
	pet: GQLPet
	catOrDog: CatOrDog
	arguments: GQLArguments
	booleanList(booleanListArg: [Boolean!]): [Boolean]
}'
]

{ #category : #public }
GQLQueryRoot >> arguments [
	^ GQLArguments new
]

{ #category : #public }
GQLQueryRoot >> booleanListBooleanListArg: list [
	^ list 
]

{ #category : #public }
GQLQueryRoot >> cat [
	^ GQLCat new 
		name: 'Mishi';
		nickname: 'Gatencio';
		meowVolume: 3
]

{ #category : #public }
GQLQueryRoot >> catOrDog [
	^ self cat
]

{ #category : #public }
GQLQueryRoot >> dog [
	^ GQLDog new 
		name: 'lobo';
		nickname: 'lobito';
		barkVolume: 10;
		owner: self human
]

{ #category : #public }
GQLQueryRoot >> findDogComplex: input [
	^ self dog
]

{ #category : #public }
GQLQueryRoot >> findDogNotNullComplex: input [
	^ input
]

{ #category : #public }
GQLQueryRoot >> human [
	^ GQLHuman new name: 'Akevalion'
]

{ #category : #public }
GQLQueryRoot >> pet [
	^ self dog
]
