Class {
	#name : #GQLSSchemaNodeExtensionTest,
	#superclass : #GQLTestExtension,
	#instVars : [
		'dictSchema',
		'dictOfInvalidSchema'
	],
	#category : #'GraphQLBeta-Tests-Nodes'
}

{ #category : #initialization }
GQLSSchemaNodeExtensionTest >> setUp [
	dictSchema := self initDictSchema.
	dictOfInvalidSchema := self initDictOfInvalidSchema 
	
]

{ #category : #tests }
GQLSSchemaNodeExtensionTest >> testFailValidSchemaWithInputObjectypeExtension [

	self assert: (self validateSchemaOf: dictOfInvalidSchema withKey: 'wrongInputObjectExtensManySchemas') class: GQLValidationException.
	
	self assert: (self validateSchemaOf: dictOfInvalidSchema withKey: 'wrongInputObjectExtensionOneSchema') class: GQLValidationException.
]

{ #category : #tests }
GQLSSchemaNodeExtensionTest >> testFailValidSchemaWithInterfTypeExtension [

	self assert: (self validateSchemaOf: dictOfInvalidSchema withKey: 'wrongInterfaceExtensManySchemas') class: GQLValidationException.
	
	self assert: (self validateSchemaOf: dictOfInvalidSchema withKey: 'wrongInterfaceExtensOneSchema') class: GQLValidationException.
]

{ #category : #tests }
GQLSSchemaNodeExtensionTest >> testFailValidSchemaWithObjTypeExtension [

	self assert: (self validateSchemaOf: dictOfInvalidSchema withKey: 'wrongDefinedObjExtensionManySchemas') class: GQLValidationException.
	
	self assert: (self validateSchemaOf: dictOfInvalidSchema withKey: 'wrongDefinedObjExtensionOneSchema') class: GQLValidationException.
	
	self assert: (self validateSchemaOf: dictOfInvalidSchema withKey: 'wrongDefinedObjExtensWithInterface') class: GQLValidationException.
	
	self assert: (self validateSchemaOf: dictOfInvalidSchema withKey: 'wrongDefinedObjectExtensWithResolvers') class: GQLValidationException.
]

{ #category : #tests }
GQLSSchemaNodeExtensionTest >> testFailValidSchemaWithUnionTypeExtension [

	self assert: (self validateSchemaOf: dictOfInvalidSchema withKey: 'wrongUnionExtensionManySchemas') class: GQLValidationException.
	
	self assert: (self validateSchemaOf: dictOfInvalidSchema withKey: 'wrongUnionExtensionOneSchema') class: GQLValidationException.
]

{ #category : #tests }
GQLSSchemaNodeExtensionTest >> testFailValidateSchemaWithEnumTypeExtension [

	self assert: (self validateSchemaOf: dictOfInvalidSchema withKey: 'wrongEnumExtensionManySchemas') class: GQLValidationException.
	
	self assert: (self validateSchemaOf: dictOfInvalidSchema withKey: 'wrongEnumExtensionOneSchema') class: GQLValidationException.
]

{ #category : #tests }
GQLSSchemaNodeExtensionTest >> testValidateSchemaWithEnumTypeExtension [

	self assert: (self validateSchemaOf: dictSchema withKey: 'apartEnumExtension') class: GQLSSchemaNode.
	
	self assert: (self validateSchemaOf: dictSchema withKey: 'enumExtension') class: GQLSSchemaNode.
]

{ #category : #tests }
GQLSSchemaNodeExtensionTest >> testValidateSchemaWithInputObjectypeExtension [

	self assert: (self validateSchemaOf: dictSchema withKey: 'apartInputObjectExtension') class: GQLSSchemaNode.
	
	self assert: (self validateSchemaOf: dictSchema withKey: 'inputObjectExtension') class: GQLSSchemaNode.
]

{ #category : #tests }
GQLSSchemaNodeExtensionTest >> testValidateSchemaWithInterfaceTypeExtension [

	self assert: (self validateSchemaOf: dictSchema withKey: 'apartInterfaceExtension') class: GQLSSchemaNode.
	
	self assert: (self validateSchemaOf: dictSchema withKey: 'apartInterfaceExtensionWithObExt') class: GQLSSchemaNode.
	
	self assert: (self validateSchemaOf: dictSchema withKey: 'interfaceExtension') class: GQLSSchemaNode.
]

{ #category : #tests }
GQLSSchemaNodeExtensionTest >> testValidateSchemaWithObjectTypeExtension [

	self assert: (self validateSchemaOf: dictSchema withKey: 'apartObjectExtensWithFieldDef') class: GQLSSchemaNode.
	
	self assert: (self validateSchemaOf: dictSchema withKey: 'objectExtensWithFieldDef') class: GQLSSchemaNode.
	
	self assert: (self validateSchemaOf: dictSchema withKey: 'objectExtensWithInterface') class: GQLSSchemaNode.
	
	self assert: (self validateSchemaOf: dictSchema withKey: 'objectExtensWithExtInterface') class: GQLSSchemaNode.
	
	self assert: (self validateSchemaOf: dictSchema withKey: 'objectExtensWithOtherResolver') class: GQLSSchemaNode.
]

{ #category : #tests }
GQLSSchemaNodeExtensionTest >> testValidateSchemaWithUnionTypeExtension [

	self assert: (self validateSchemaOf: dictSchema withKey: 'apartUnionExtension') class: GQLSSchemaNode.
	
	self assert: (self validateSchemaOf: dictSchema withKey: 'unionExtension') class: GQLSSchemaNode.
]
