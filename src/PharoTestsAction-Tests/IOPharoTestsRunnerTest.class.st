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

{ #category : #running }
IOPharoTestsRunnerTest >> setUp [
	super setUp.

	runner := IOPharoTestsRunner new
]

{ #category : #tests }
IOPharoTestsRunnerTest >> testOneEqOne [
	self assert: 1 equals: 1.
]

{ #category : #tests }
IOPharoTestsRunnerTest >> testSplitString [
	| res |
	res := runner splitString: 'roassal, numeric'.
	self assert: res asArray equals: { 'roassal'. 'numeric' }.
]
