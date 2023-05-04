Extension { #name : #Error }

{ #category : #'*PharoTestsAction' }
Error >> actionAnnounce: aTestCase toResult: aTestResult [

	aTestResult addError: aTestCase.
	self pass
]
