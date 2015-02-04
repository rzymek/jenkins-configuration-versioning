#!/bin/bash
# https://github.com/rzymek/jenkins-configuration-versioning
# Jenkins Configuraitons Directory
cd $JENKINS_HOME

git init #Running git init in an existing repository is safe
# Add general configurations, job configurations, and user content
git add -- *.xml jobs/*/*.xml userContent/*

# only add user configurations if they exist
if [ -d users ]; then
    user_configs=`ls users/*/config.xml`

    if [ -n "$user_configs" ]; then
        git add $user_configs
    fi
fi

# mark as deleted anything that's been, well, deleted
to_remove=`git status | grep "deleted" | awk '{print $3}'`

if [ -n "$to_remove" ]; then
    git rm --ignore-unmatch $to_remove
fi

git config user.name "Jenkins"
git config user.email "jenkins@`hostname`"
git commit -m "Automated Jenkins commit" 

#Setup remote using
# git remote add origin [url]
#Then uncomment:
# git push -q origin master
