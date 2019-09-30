Extension { #name : #TestResource }

{ #category : #'*GraphQLBeta' }
TestResource class >> visualworksName [
	^ self == TestResource ifTrue: ['Smalltalk.SUnit.TestResource'] ifFalse: [self name]
]
