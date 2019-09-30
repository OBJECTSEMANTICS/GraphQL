Extension { #name : #ZnRequest }

{ #category : #'*GraphQLBeta' }
ZnRequest >> queryAt: key ifAbsent: block [
	^ self requestLine uri query at: key ifAbsent: block
]

{ #category : #'*GraphQLBeta' }
ZnRequest >> urlString [
	^ self requestLine uriPathQueryFragment 
]
