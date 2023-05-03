baselines
baseline: spec
	<baseline>
	spec for: #common do: [
		spec 
			package: #'PharoTestsAction';
			package: #'PharoTestsAction-Tests';
			group: 'default' with: #('PharoTestsAction' 'PharoTestsAction-Tests').
	].