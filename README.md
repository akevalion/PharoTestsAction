# PharoTestsAction

This project is to test pharo code. The actions will remove packages of pharo and then will load and execute the tests.
### Installation

In pharo 11 run:

```Smalltalk
Metacello new
    baseline: 'PharoTestsAction';
    repository: 'github://akevalion/PharoTestsAction';
    load
```

### Usage

Just create a `.github/workflows/main.yml` with this content:

```yml
on: [push]

jobs:
  hello_world_job:
    runs-on: ubuntu-latest
    name: CI for the action
    steps:
        #to kill old run in the CI server
      - name: Cancel Previous Runs
        uses: styfle/cancel-workflow-action@0.9.0
        with:
          access_token: ${{ github.token }}

        # very important to use the current branch in the CI process
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
        # call this action
      - name: Run pharo Tests
        id: tests
        uses: akevalion/PharoTestsAction@v1
        with:
          # removes-repo: 'Roassal, Numeric' # String separated by commas, it will remove packages using: `'Roassal*' match: package name`
          baseline: 'PharoTestsAction'
          group: 'default'
          tests: 'PharoTests' # same as `removes-repo` it will use

```
### Contact

Just submit an issue and I will fix the repo :D.
