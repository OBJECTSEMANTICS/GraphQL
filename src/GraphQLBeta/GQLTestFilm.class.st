"
I represent a film to test the graphql request.

Public API and Key Messages

- id   
- initialize:name:rating:
- name
- rating
- toDictionary

Internal Representation and Key Implementation Points.

    Instance Variables
	filmName:		<String>
	id:		<String>
	rating:		<Integer>

Example
	GQLTestFilm new: 1 name: 'Bella' rating: 7
"
Class {
	#name : #GQLTestFilm,
	#superclass : #GraphQLObject,
	#instVars : [
		'id',
		'filmName',
		'rating',
		'film',
		'description',
		'gender'
	],
	#category : #'GraphQLBeta-Test-Utils'
}

{ #category : #'instance creation' }
GQLTestFilm class >> new: id name: filmName rating: rating gender: gender [
	| inst |
	inst := self new.
	inst initialize: id name: filmName rating: rating gender: gender.
	^ inst.
	
]

{ #category : #accessing }
GQLTestFilm >> description [
	^ description
]

{ #category : #accessing }
GQLTestFilm >> description: anObject [
	description := anObject
]

{ #category : #accessing }
GQLTestFilm >> film [
	^film
	
	

]

{ #category : #accessing }
GQLTestFilm >> filmName [
	^ filmName
]

{ #category : #accessing }
GQLTestFilm >> filmName: anObject [
	filmName := anObject
]

{ #category : #accessing }
GQLTestFilm >> gender [
	^ gender
]

{ #category : #accessing }
GQLTestFilm >> gender: anObject [
	gender := anObject
]

{ #category : #accessing }
GQLTestFilm >> id [
	^ id
	
	

]

{ #category : #accessing }
GQLTestFilm >> id: anObject [
	id := anObject
]

{ #category : #initialization }
GQLTestFilm >> initialize: anId name: aString rating: aNumber gender: aGender [
	id := anId.
	filmName := aString.
	rating := aNumber.
	description := aString.
	gender := aGender.
	film := GQLFilm new initialize: aString id: anId .
	

]

{ #category : #accessing }
GQLTestFilm >> name [
	^ filmName 
	

]

{ #category : #accessing }
GQLTestFilm >> name: aName [
	self filmName: aName
]

{ #category : #accessing }
GQLTestFilm >> rating [
	^ rating
	
	

]

{ #category : #accessing }
GQLTestFilm >> rating: aRating [
	rating := aRating 
]

{ #category : #accessing }
GQLTestFilm >> toDictionary [
	^ Dictionary new 
		at: #id put: id;
		at: #name put: filmName;
		at: #rating put: rating
	

]
