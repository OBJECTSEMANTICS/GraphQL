"
Baseline for https://github.com/OBJECTSEMANTICS/GraphQL
"
Class {
	#name : #BaselineOfGraphQL,
	#superclass : #BaselineOf,
	#category : #BaselineOfGraphQL
}

{ #category : #baselines }
BaselineOfGraphQL >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/ObjectProfile/GraphQL/main/'.
		spec 
			project: 'PetitParser' with: [
				spec
					className: #ConfigurationOfPetitParser;
					versionString: #'stable';
					loads: #('PetitParser' 'PetitTests');
					repository: 'http://smalltalkhub.com/mc/Moose/PetitParser/main/' ].

		spec baseline: 'NeoJSON' with: [ spec repository: 'github://svenvc/NeoJSON/repository' ].

		spec package: 'GraphQLBeta'. 
		
		spec group: 'default' with: #('PetitParser' 'NeoJSON' 'GraphQLBeta').].

]
