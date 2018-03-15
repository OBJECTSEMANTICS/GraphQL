# GraphQL
A Smalltalk GraphQL Implementation

## Installation on VW

This project only works on VisualWorks 7.4, to install GraphQL go to the repository .... and load our project. If everything is going well, all the test must pass, except 11 test of the classes:
- GQLTypeValidatorTest
- GQLDocumentTypeValidatorTest

## Development
For the moment our application works well for request based on selection sets.

### Internals 
There are some classes very important on Visual Works for GraphQL:
- Query: It's the entry point by default of the demo. Also on the class side has defined the schema used by the demo.
- GraphQLBetaDemoSite: It's the class to start the demo, it works with the schema of the Query class, the entry point is a Query instance and returns the results on JSON.
- GraphQL: It's the class that attends request and return the answer.

If you want to add your data to the Schema, you can modify the schema method on the class side of Query. Remember that the schema is defined as a text and follows the specifications of GraphQL.
Also don't forget to create all the necessary methods (operations) on the instance side of Query to provide the answer according to the schema defined.

### Feature ideas
* [x] Complete parsing of schema.
* [x] Complete parsing of any valid request.
* [x] Interpretation of simple request based on selection sets.
#[checkbox:unchecked] Add tests for interpretation of request with fragments.
#[checkbox:unchecked] Interpretation of request with fragments.
#[checkbox:unchecked] Add tests for interpretation of any valid request.
#[checkbox:unchecked] Interpretation of any valid request.
#[checkbox:unchecked] Add tests for error handling.
#[checkbox:unchecked] Error handling.
#[checkbox:unchecked] Add tests for type checking rules.
#[checkbox:unchecked] Type checking of the rules.
#[checkbox:unchecked] Add tests for introspection.
#[checkbox:unchecked] Introspection.

# Demo
To practice with our demo follow this steps:
1. Open a workspace and write the following line:

    GraphQLBetaDemoSite demoStart
2. Open the browser and go to the url:
	**localhost:8888/**
3. Write the following request on the text area:

    {
		allFilms{
			name	
		}
	}
4. Press the button **Submit**.
5. And you will have the response for this request.
