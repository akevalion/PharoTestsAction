| env cout file last repoPath actionRepo regExp baseline group tests |
env := Smalltalk os environment.
cout := Stdio stdout.
regExp := env at: 'ACTION_REGEX_STRING'.
baseline := env at: 'ACTION_BASELINE'.
group := env at: 'ACTION_GROUP'.
tests := env at: 'ACTION_TESTS'.

"actionRepo := '/home/runner/work/_actions/akevalion/PharoTestsAction/v1'."
actionRepo := CommandLineArguments default arguments last asFileReference parent absolutePath pathString.
actionRepo asFileReference allChildren do: [:each | cout << each absolutePath pathString; crlf ].
cout << 'Loading action repository: ' << ('gitlocal://', actionRepo).
cout crlf;
    << regExp;crlf;
    << baseline;crlf;
    << group; crlf;
    << tests; crlf.
[Metacello new
    baseline: 'PharoTestsAction';
    repository: 'gitlocal://', actionRepo;
    load ] onErrorDo: [:ex | cout << ex signalerContext longStack ].

"This object can create an error file to know if tests are good or not, and its used by index.js"
"IOPharoTestsRunner new
    remove: regExp;
    load: baseline group: group;
    runTests."

SmalltalkImage current quitPrimitive