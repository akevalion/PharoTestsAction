Extension { #name : #TestSuite }

{ #category : #'*PharoTestsAction' }
TestSuite >> run: result block: aBlock set: set [
	CurrentExecutionEnvironment runTestsBy: [
		self setUp.
		[
			self tests do: [:each |
				each run: result block: aBlock set: set.
				self announceTest: each.
				self changed: each
			]
		] ensure:[
			self tearDown.
		]
	]
	
]

{ #category : #'*PharoTestsAction' }
TestSuite >> runWithAction: set block: aBlock [
	| result |
	result := self resultClass new.
	self run: result block: aBlock set: set.
	
	^ result
]
