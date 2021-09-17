/*
Script to (git) cherry pick massively from different repositories.
Just replace the `projectHashMap` map with the `project`: `hash` map element.
The repositories have to be previously checked out

TODO: It can be improved by directly getting git hashes from log
*/
const { exec } = require("child_process");
const path = require("path");
const projectHashMap = {"droolsjbpm-build-bootstrap": "a49d0676","kie-soup": "508bb01","droolsjbpm-knowledge": "1b0cbae9","drools": "a1853e4ab6","optaplanner": "40235130d","lienzo-core": "a81db62","lienzo-tests": "d80f265","appformer": "e256957bb","kie-uberfire-extensions": "889fd26","jbpm": "434816a6a","kie-jpmml-integration": "f207fa2","droolsjbpm-integration": "cb9e2dfe6","kie-wb-playground": "ef7456b","kie-wb-common": "f8f5d7b7c3","drools-wb": "d8168b8c4","jbpm-designer": "1135e99eb","jbpm-work-items": "7a55dd5d","jbpm-wb": "57f471aec","optaplanner-wb": "2a3f0b8","kie-wb-distributions": "16218ff98","openshift-drools-hacep": "98f4c67b3","process-migration-service": "647e03f","optaweb-employee-rostering": "af7668b9","optaweb-vehicle-routing": "d58f565f","kie-docs": "5518bc1d"};

Object.keys(projectHashMap).forEach(project => {
    process.chdir(path.join(__dirname, project));

    const pwd = exec("pwd");
    pwd.stdout.on("data", data => {
        console.log(`[INFO][${project}] Running command on: ${data}`);
    });

    console.log(`[INFO][${project}] Cherry-picking ${projectHashMap[project]}`);
    const cherryPick = exec(`git cherry-pick ${projectHashMap[project]}` );
    cherryPick.stdout.on("data", data => {
        console.log(`[INFO][${project}] ${data}`);
    });
    cherryPick.stderr.on("data", data => {
        console.log(`[ERROR][${project}] ${data}`);
    });
    cherryPick.on("error", (error) => {
        console.log(`[ERROR][${project}] ${error}`);
    });

});

