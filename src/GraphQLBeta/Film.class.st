"
I am a basic object film for this demo of graphql
"
Class {
	#name : #Film,
	#superclass : #Object,
	#instVars : [
		'name',
		'rating',
		'director',
		'gender'
	],
	#category : #'GraphQLBeta-Demo'
}

{ #category : #'instance creation' }
Film class >> name: aName rating: aRating director: aDirector gender: aGender [

	| inst |
	inst := self new.
	inst name: aName;
		rating: aRating;
		director: aDirector;
		gender: aGender.
	^ inst
]

{ #category : #accessing }
Film >> director [
	^ director
]

{ #category : #accessing }
Film >> director: aPerson [
	director := aPerson
]

{ #category : #accessing }
Film >> gender [

	^ gender
]

{ #category : #accessing }
Film >> gender: aGender [

	gender := aGender
]

{ #category : #accessing }
Film >> name [
	^ name
]

{ #category : #accessing }
Film >> name: aString [
	name := aString
]

{ #category : #accessing }
Film >> rating [
	^ rating
]

{ #category : #accessing }
Film >> rating: aInt [
	rating := aInt
]
