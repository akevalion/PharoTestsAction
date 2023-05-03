| env cout file last repoPath actionRepo regExp baseline |
env := Smalltalk os environment.
cout := Stdio stdout.
regExp := env at: 'ACTION_REGEX_STRING'.
baseline := env at: 'ACTION_BASELINE'.
group := env at: 'ACTION_GROUP'.
"actionRepo := '/home/runner/work/_actions/akevalion/PharoTestsAction/v1'."
actionRepo := 'github://akevalion/PharoTestsAction'.
cout << 'loading repo from action: ' << actionRepo.
cout crlf.
[ Metacello new
    baseline: 'PharoTestsAction';
    repository: actionRepo;
    load ] on: MCMergeOrLoadWarning do: [:warning | warning load ].

IOPharoTestsRunner new
    remove: regExp;
    load: baseline group: group;
    runTests.

SmalltalkImage current quitPrimitive