| env cout file |
env := Smalltalk os environment.
cout := Stdio stdout.
last := CommandLineArguments default arguments last.
cout << 'loading: ' << last.
cout crlf.
repoPath := env at: 'GITHUB_WORKSPACE'.
[ Metacello new
    baseline: 'PharoTestsAction';
    repository: 'gitlocal://', last;
    load ] on: MCMergeOrLoadWarning do: [:warning | warning load ].

cout << repoPath.
file := '/tmp/testError.txt' asFileReference writeStream.
file << 'se mamo'.
file close.
SmalltalkImage current quitPrimitive