| env cout |

env := Smalltalk os environment.
cout := Stdio stdout.
cout << '\e[31mRed Text\e[0m \e[32mGreen Text\e[0m'.
cout crlf.
cout << ((env at: 'GITHUB_WORKSPACE' ifAbsent: [ 'nogithub'])).

SmalltalkImage current quitPrimitive