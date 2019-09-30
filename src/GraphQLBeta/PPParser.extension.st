Extension { #name : #PPParser }

{ #category : #'*GraphQLBeta' }
PPParser >> performs: aBlock [

	^ PPActionParser on: self block: aBlock
]
