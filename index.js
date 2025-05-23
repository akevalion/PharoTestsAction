const core = require('@actions/core');
const github = require('@actions/github');
const {execSync, spawn} = require('child_process');

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
function dragon(){
    return `Here be dragons!
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
                  (vvv(VVV)(VVV)vvv)`;
}

try {
    // `repo` input defined in action metadata file
    const repositoriesToRemove = core.getInput('removes-repo');
    const baseline = core.getInput('baseline');
    const group = core.getInput('group');
    const tests = core.getInput('tests');
    let pharoVM = core.getInput('pharo').toLowerCase();
    
    process.env['ACTION_REGEX_STRING'] = repositoriesToRemove;
    process.env['ACTION_BASELINE'] = baseline;
    process.env['ACTION_GROUP'] = group;
    process.env['ACTION_TESTS'] = tests;

    const time = (new Date()).toTimeString();
    core.setOutput("time", time);

    const map = {
        "pharo9": "90+vm",
        "pharo10": "100+vm",
        "pharo11": "110+vm",
        "pharo12": "120+vm",
    };
    if(map[pharoVM] == undefined)
        pharoVM = '64/alpha+vm';
    else
        pharoVM = map[pharoVM];

    run ('curl -L https://get.pharo.org/' + pharoVM +' | bash');
    
    const commands = [ 
        'cd '+__dirname,
        'git -c init.defaultBranch=master init',
        'git add -A',
        'git config --global user.name "David504"',
        'git config --global user.email "david504@bass.slap"',
        'git commit -m "Bass"'];

    run(commands.join(' && '));//this will fix .git folder and the runTests.st can load this current version into the image

    let file = path.join(__dirname, '/runTest.st');
    console.log('Running: '+'./pharo --headless Pharo.image ' + file);
    var eva = spawn('./pharo', ['--headless', 'Pharo.image', file]);
    eva.stdout.on('data', function(msg){
        process.stdout.write(msg);
    });
    eva.stderr.on('data', function(msg){
        process.stdout.write(msg);
    });
    eva.on('exit', function(code){
        const errorFile = path.join('/tmp', '/testError.txt');
        if (fs.existsSync(errorFile)){
            console.log('\x1b[31m', 'Some Errors :V');
            //console.log(trace(eva);
            console.log('\x1b[31m', fs.readFileSync(errorFile, 'utf8'));
            core.setFailed(dragon());
        }else {
            console.log(`Pharo exited with code: ${code}`);
            console.log('\x1b[32m', 'All test Passed!');
        }
    });
    
} catch (error) {
    core.setFailed(error.message);
}
