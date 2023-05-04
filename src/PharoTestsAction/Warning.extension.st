Extension { #name : #Warning }

{ #category : #'*PharoTestsAction' }
Warning >> actionAnnounce: aTestCase toResult: aTestResult [
	aTestResult addFailure: aTestCase.
	self pass
]
