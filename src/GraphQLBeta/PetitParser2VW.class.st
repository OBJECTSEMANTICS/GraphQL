"
I'm a export petit parser to Visual Works

Public API and Key Messages

- initialize
 
The script for export petit parser is:

PetitParser2VW new exportPackages
	

"
Class {
	#name : #PetitParser2VW,
	#superclass : #Object,
	#category : #'GraphQLBeta-Exporter'
}

{ #category : #exporting }
PetitParser2VW >> exportPackages [
	<script: 'self new exportPackages'>
	self exporter export
]

{ #category : #exporting }
PetitParser2VW >> exporter [
	| cls |
	cls := Smalltalk classOrTraitNamed: 'Pharo2VW'.
	cls ifNil: [ ^ nil ].
	^ cls exporter
		namespace: #PetitParser;
		methodsBlacklist: (PPParser allMethods select: [ :cm | cm package name ~= #PetitParser ]);
		packages: {'PetitParser'};
		externalNamespaces:  #(#PetitParser)
		yourself.
		
	

]
