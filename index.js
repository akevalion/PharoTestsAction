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
    const rest = run ('./pharo --headless Pharo.image '+file);
    const errorFile = path.join('/tmp', '/testError.txt');
    if (fs.existsSync(errorFile)){
        console.log(new Buffer.from(rest).toString());
        console.log('\x1b[41m', fs.readFileSync(errorFile, 'utf8'));
    }else {
        console.log('\x1b[42m', 'All test Passed!');
    }
  } catch (error) {
    core.setFailed(error.message);
  }