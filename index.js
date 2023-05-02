const core = require('@actions/core');
const github = require('@actions/github');
const {execSync} = require('child_process');

const path = require('path');
const fs = require('fs');

function run(command){
    console.log('Running: '+command);
    const res = execSync(command);
    return res;
}
try {
    // `repo` input defined in action metadata file
    const nameToGreet = core.getInput('removes-repo');
    
    const time = (new Date()).toTimeString();
    core.setOutput("time", time);
    // Get the JSON webhook payload for the event that triggered the workflow
    //const payload = JSON.stringify(github.context.payload, undefined, 2)
    //console.log(`The event payload: ${payload}`);

    //console.log(`Removing: ${nameToGreet}`);
    console.log(run ('curl -L https://get.pharo.org/64/alpha+vm | bash'))
    const file = path.join(__dirname, '/runTest.st');
    //console.log(file);
    const rest = run ('./pharo --headless Pharo.image '+file);
    console.log(new Buffer.from(rest).toString());
    console.log('\e[31mRed Text\e[0m \e[32mGreen Text\e[0m');
    console.log('\x1b[36m%s\x1b[0m', 'I am cyan');
  } catch (error) {
    core.setFailed(error.message);
  }