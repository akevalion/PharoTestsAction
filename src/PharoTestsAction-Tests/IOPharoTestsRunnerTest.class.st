"
An IPPharoTestsRunnerTest is a test class for testing the behavior of IPPharoTestsRunner
"
Class {
	#name : #IOPharoTestsRunnerTest,
	#superclass : #TestCase,
	#instVars : [
		'runner'
	],
	#category : #'PharoTestsAction-Tests'
}

{ #category : #tests }
IOPharoTestsRunnerTest >> dummyCoutString [
	^ 'IO: Running tests for `PharoTestsActionDummy-Tests`
IO: TESTS RESULTS
IO: 1 test classes in total
IO: 1 passed test methods
IO: 1 error test methods
IO: 1 failures test methods
IO: 1 skip test methods
IO: 4 test methods in total
IO: Running tests completed!
' copyReplaceAll: String cr with: String crlf.
]

{ #category : #running }
IOPharoTestsRunnerTest >> setUp [
	super setUp.

	runner := IOPharoTestsRunner new
]

{ #category : #tests }
IOPharoTestsRunnerTest >> testRunTests [
	| stream error |
	"Dummy test should not be part of the ci process"
	stream := WriteStream on: ''.
	error := WriteStream on: ''.
	IOPharoTestsRunner new 
		cout: stream;
		runTests: 'PharoTestsActionDummy-Tests' onErrorStream: error.
	self assert: stream contents equals: self dummyCoutString.

	{
		'Error: IOAbstractTest>>#testError'.
		'Error: IOAbstractTest>>#testFailure'
	} do: [ :each |
		self assert: (error contents includesSubstring: each).
		 ].
]

{ #category : #tests }
IOPharoTestsRunnerTest >> testSplitString [
	| res |
	res := runner splitString: 'roassal, numeric'.
	self assert: res asArray equals: { 'roassal'. 'numeric' }.
]
