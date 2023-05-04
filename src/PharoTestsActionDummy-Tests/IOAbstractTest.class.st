Class {
	#name : #IOAbstractTest,
	#superclass : #TestCase,
	#category : #'PharoTestsActionDummy-Tests'
}

{ #category : #tests }
IOAbstractTest >> testBasic [
	"no errors"
	
]

{ #category : #tests }
IOAbstractTest >> testError [
	1/0
]

{ #category : #tests }
IOAbstractTest >> testFailure [
	self assert: 1 equals: 0
]

{ #category : #tests }
IOAbstractTest >> testSkip [
	self skip
]
