| env cout file last repoPath actionRepo|
env := Smalltalk os environment.
cout := Stdio stdout.
"actionRepo := '/home/runner/work/_actions/akevalion/PharoTestsAction/v1'."
actionRepo := 'github://akevalion/PharoTestsAction'.
cout << 'loading: ' << actionRepo.
cout crlf.
repoPath := env at: 'GITHUB_WORKSPACE'.
"actionRepo asFileReference allChildren do: [ :f | 
cout << f absolutePath pathString.
cout crlf ]."
[ Metacello new
    baseline: 'PharoTestsAction';
    repository: actionRepo;
    load ] on: MCMergeOrLoadWarning do: [:warning | warning load ].

cout << repoPath.
file := '/tmp/testError.txt' asFileReference writeStream.
file << 'se mamo'.
file close.
SmalltalkImage current quitPrimitive