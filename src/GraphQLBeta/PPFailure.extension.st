Extension { #name : #PPFailure }

{ #category : #'*GraphQLBeta' }
PPFailure >> asJsonDictionary [
	| error |
	error := GQLError new
		message: 'Syntax Error: ', self message;
		locationFor: self on: context stream contents.
	^ Dictionary new 
		at: 'errors' put: (OrderedCollection new 
			add: error; yourself);
		yourself
]
