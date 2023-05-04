Extension { #name : #Exception }

{ #category : #'*PharoTestsAction' }
Exception >> actionAnnounce: aTestCase toResult: aTestResult [

	aTestResult addError: aTestCase.
	self pass
]
