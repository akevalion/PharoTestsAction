| env cout file last |
env := Smalltalk os environment.
cout := Stdio stdout.
actionRepo := FileLocator workingDirectory absolutePath pathString.
cout << 'loading: ' << actionRepo.
cout crlf.
repoPath := env at: 'GITHUB_WORKSPACE'.
FileLocator workingDirectory allChildren do: [ :f | 
cout << f absolutePath pathString.
cout crlf ].
"[ Metacello new
    baseline: 'PharoTestsAction';
    repository: 'gitlocal://', actionRepo;
    load ] on: MCMergeOrLoadWarning do: [:warning | warning load ]."

cout << repoPath.
file := '/tmp/testError.txt' asFileReference writeStream.
file << 'se mamo'.
file close.
SmalltalkImage current quitPrimitive