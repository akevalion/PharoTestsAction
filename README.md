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
  ActionJob:
    runs-on: ubuntu-latest
    name: CI for the action
    steps:
      - name: Cancel Previous Runs
        uses: styfle/cancel-workflow-action@0.9.0
        with:
          access_token: ${{ github.token }}
      # This method will download the .git folder very usefull to load the baseline with Metacello
      - uses: actions/checkout@v3
        with:
          fetch-depth: 0
      - name: Run pharo Tests
        id: tests
        uses: akevalion/PharoTestsAction@v1
        with:
          # removes-repo: 'Roassal, Numeric' # String separated by commas, it will remove packages using: `'Roassal*' match: package name`
          baseline: 'PharoTestsAction'
          group: 'default'
          tests: 'PharoTestsAction-Tests'
```
### Contact

Just submit an issue and I will fix the repo :D.
