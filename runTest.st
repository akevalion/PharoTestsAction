| env cout file |
env := Smalltalk os environment.
cout := Stdio stdout.
cout crlf.
cout << ((env at: 'GITHUB_WORKSPACE' ifAbsent: [ 'nogithub'])).
file := '/tmp/testError.txt' asFileReference writeStream.
file << 'se mamo'.
file close.
SmalltalkImage current quitPrimitive