const core = require('@actions/core')
const github = require('@actions/github')
const {exec} = require('child_process')
try {
    // `repo` input defined in action metadata file
    const nameToGreet = core.getInput('removes-repo');
    console.log(`Removing: ${nameToGreet}`);
    const time = (new Date()).toTimeString();
    core.setOutput("time", time);
    // Get the JSON webhook payload for the event that triggered the workflow
    const payload = JSON.stringify(github.context.payload, undefined, 2)
    console.log(`The event payload: ${payload}`);

    exec('sh ./run.sh', (error,stdout, stderr)=> {
        if (error) {
            console.log(`error: ${error.message}`);
            return;
        }
        if (stderr) {
            console.log(`stderr: ${stderr}`);
            return;
        }
        console.log(`stdout: ${stdout}`);
    } );

  } catch (error) {
    core.setFailed(error.message);
  }