"
I'm a export petit tests to Visual Works

Public API and Key Messages

- initialize
 
The script for export petit tests is:

PetitTests2VW new exportPackages
	

"
Class {
	#name : #PetitTests2VW,
	#superclass : #Object,
	#category : #'GraphQLBeta-Exporter'
}

{ #category : #exporting }
PetitTests2VW >> exportPackages [
	<script: 'self new exportPackages'>
	self exporter export
]

{ #category : #exporting }
PetitTests2VW >> exporter [
	| cls |
	cls := Smalltalk classOrTraitNamed: 'Pharo2VW'.
	cls ifNil: [ ^ nil ].
	^ cls exporter
		namespace: #PetitTests;
		methodsBlacklist: {PPTokenTest >> #testValue};
		packages: {'PetitTests'};
		externalNamespaces:  #(#PetitParser)
		yourself.
		
	

]
