const core = require('@actions/core')
const github = require('@actions/github')
const {execSync} = require('child_process')
try {
    // `repo` input defined in action metadata file
    const nameToGreet = core.getInput('removes-repo');
    console.log(`Removing: ${nameToGreet}`);
    const time = (new Date()).toTimeString();
    core.setOutput("time", time);
    // Get the JSON webhook payload for the event that triggered the workflow
    const payload = JSON.stringify(github.context.payload, undefined, 2)
    console.log(`The event payload: ${payload}`);

    console.log(execSync('curl -L https://get.pharo.org/64/alpha+vm | bash'));
    console.log(execSync('ls'));
    //console.log('./pharo --headless Pharo.image ./scripts/runTest.st');

  } catch (error) {
    core.setFailed(error.message);
  }