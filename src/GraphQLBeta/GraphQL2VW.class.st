"
I'm a export graphql to Visual Works

Public API and Key Messages

- initialize
 
The script for export graphql is:

GraphQL2VW new exportPackages
	

"
Class {
	#name : #GraphQL2VW,
	#superclass : #Object,
	#category : #'GraphQLBeta-Exporter'
}

{ #category : #exporting }
GraphQL2VW >> codeToLoadParcels7dot4 [
	<script: 'self new codeToLoadParcels7dot4'>
	GTPlayground openContents: '
"Execute in a Visualworks playground 7.4"

| dir file |
dir := Dialog requestDirectoryName: ''Choose the graphql parcels directory''.
dir ifEmpty: [^ self].
dir:= dir, (String with: Filename separator).
#(''PetitExtensions'' ''PetitParser'' ''PetitTests''
 ''GraphQLBeta'' ''GraphQLExtensions'' ''GraphQLBetaDemoSite'') do: [:fn | 
 file := dir, fn, ''.pcl''.

 file asFilename exists ifFalse: [self error: ''Missing parcel!'', file asString].
 Parcel loadParcelFrom: file asFilename
  ].'
]

{ #category : #exporting }
GraphQL2VW >> codeToSort [
	<script: 'self new codeToSort'>
	GTPlayground openContents: '
"Execute in a Visualworks playground after load the file.st"
| main classes cat pkg |
main := Registry bundleNamed: ''GraphQLBeta''.
classes := main allClasses.
packages := Dictionary new.

classes do: [ :cls |  
	cat := cls myClass category asString.
	(cat startsWith: ''GraphQL'') ifTrue: [
		pkg := packages at: cat ifAbsentPut: [ | p |
			p := Registry packageNamedOrCreate: cat.
			main addItem: p.
			p ].
		XChangeSet current moveWholeClass: cls toPackage: pkg
	] ]'
]

{ #category : #exporting }
GraphQL2VW >> exportPackages [
	<script: 'self new exportPackages'>
	self exporter export
]

{ #category : #exporting }
GraphQL2VW >> exporter [
	| cls blacklist res |
	cls := Smalltalk classOrTraitNamed: 'Pharo2VW'.
	cls ifNil: [ ^ nil ].
	blacklist :=  {
			GQLException >> #raise.
			ZnRequest >> #queryAt:ifAbsent:.
			ZnRequest >> #urlString  } asOrderedCollection.
	res := cls exporter
		namespace: #GraphQLBeta;
		packages: {'GraphQLBeta'} 
			without: {'GraphQLBeta-Exporter'. 'GraphQLBeta-Pharo'};
		externalNamespaces: #(#PetitParser #PetitTests);
		yourself.
	res methods do: [ :met | 
		(met hasLiteral: #skip) ifTrue: [ blacklist add: met ]].
	res methodsBlacklist: blacklist.
	^ res 
	
	

]
