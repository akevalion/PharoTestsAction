Extension { #name : #TestFailure }

{ #category : #'*PharoTestsAction' }
TestFailure >> actionAnnounce: aTestCase toResult: aTestResult [
	aTestResult addFailure: aTestCase.
	self pass
]
