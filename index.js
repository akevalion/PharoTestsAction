const core = require('@actions/core');
const github = require('@actions/github');
const {execSync} = require('child_process');

const path = require('path');
const fs = require('fs');
function trace(anObject){
    return new Buffer.from(anObject).toString()
}
function run(command){
    console.log('Running: '+command);
    const res = execSync(command);
    return res;
}
try {
    // `repo` input defined in action metadata file
    const repositoriesToRemove = core.getInput('removes-repo');
    const baseline = core.getInput('baseline');
    const group = core.getInput('group');
    const tests = core.getInput('tests');

    const time = (new Date()).toTimeString();
    core.setOutput("time", time);

    // Get the JSON webhook payload for the event that triggered the workflow
    //const payload = JSON.stringify(github.context.payload, undefined, 2)
    //console.log(`The event payload: ${payload}`);
    process.env['ACTION_REGEX_STRING'] = repositoriesToRemove;
    process.env['ACTION_BASELINE'] = baseline;
    process.env['ACTION_GROUP'] = group;
    process.env['ACTION_TESTS'] = tests;

    console.log(run ('curl -L https://get.pharo.org/64/alpha+vm | bash'))
    let file =  path.join(__dirname, '/runTest.st');
    const commads = [ 
        'cd '+__dirname,
        'git init && git add -A',
        'git config --global user.name "David504"',
        'git config --global user.email "david504@bass.slap"',
        'git commit -m "Bass"'];
    run(commands.join(' && '));
    //run('git init'); 
    //run('git add -A'); 
    //run('git config --global user.name "David504"')
    //run('git config --global user.email "david504@bass.slap"')
    //run('git commit -m "Bass"'); 

    const rest = run ('./pharo --headless Pharo.image ' + file);

    const errorFile = path.join('/tmp', '/testError.txt');
    if (fs.existsSync(errorFile)){
        console.log('\x1b[31m', 'Some Errors :V');
        console.log(trace(rest));
        console.log('\x1b[31m', fs.readFileSync(errorFile, 'utf8'));
        core.setFailed(`Here be dragons!
                 ___====-_  _-====___
           _--^^^#####//      \\\\#####^^^--_
        _-^##########// (    ) \\\\##########^-_
       -############//  |\\^^/|  \\\\############-
     _/############//   (@::@)   \\\\############\\_
    /#############((     \\\\//     ))#############\\
   -###############\\\\    (oo)    //###############-
  -#################\\\\  / VV \\  //#################-
 -###################\\\\/      \\//###################-
_#/|##########/\\######(   /\\   )######/\\##########|\\#_
|/ |#/\\#/\\#/\\/  \\#/\\##\\  |  |  /##/\\#/  \\/\\#/\\#/\\#| \\|
\`  |/  V  V  \`   V  \\#\\| |  | |/#/  V   '  V  V  \\|  '
   \`   \`  \`      \`   / | |  | | \\   '      '  '   '
                    (  | |  | |  )
                   __\\ | |  | | /__
                  (vvv(VVV)(VVV)vvv)`);
    }else {
        console.log(trace(rest));
        console.log('\x1b[32m', 'All test Passed!');
    }
  } catch (error) {
    core.setFailed(error.message);
  }