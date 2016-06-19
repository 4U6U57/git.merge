#!/bin/bash

ExeDir="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
ExeName="$(basename ${BASH_SOURCE[0]})"

# Boolean class
True=0
False=1
Boolean() {
   return $1
}

# Exit behavior
Exit() {
   Echo "Exiting program."
   exit
}
trap "Error 'Program canceled by user'" SIGHUP SIGINT SIGTERM
Error() {
   echo
   Echo "$(EchoColor Red)$@$(EchoColor)"
   if [[ $BaseDir != "" && -e $BaseDir ]]; then
      Echo "Quitting from error. Would you like to delete base repo directory $BaseName? (y/n)"
      Read -p $ReadPrefix -t 10 Input
      if [[ $Input == "y" ]]; then
         Echo "Deleting $(EchoColor Yellow)$BaseDir$(EchoColor)"
         rm -rf $BaseDir
      fi
   fi
   Exit
}

# Echo Configuration
source $ExeDir/Echo.sh
EchoPrefix="$(EchoColor Cyan)$ExeName$(EchoColor):"
ReadPrefix="$(EchoColor Yellow)$ExeName$(EchoColor)$"

# Program start
Echo "$(EchoColor Cyan)$ExeName - Git repository merging utility$(EchoColor)"

# Find base repo
BaseName=""
Echo "Enter in the name of the base repo directory to be created. (DIRECTORY)"
Read -p $ReadPrefix -t 15 BaseName
if [[ $BaseName == "" ]]; then
   Error "Invalid name for directory"
elif [[ $BaseName == "." ]]; then
   BaseDir=$(pwd)
   BaseName=$(basename $BaseDir)
   Echo "Setting up current directory $(EchoColor Yellow)$BaseName$(EchoColor) as git base."
elif [[ -e $BaseName ]]; then
   Error "Directory $BaseName already exists"
else
   Echo "Setting up $(EchoColor Yellow)$BaseName$(EchoColor) as new git base."
   mkdir $BaseName
   cd $BaseName
   BaseDir=$(pwd)
fi

# Initializing base repo, if necessary
if [[ ! -e README.md ]]; then
   Echo "No README.md found, creating"
   echo -e "# $BaseName\nBase git repo created with $ExeName\n\n## Contents\n" > README.md
fi
if [[ ! -e .git/ ]]; then
   Echo "Directory not yet set up with git, initializing"
   git init
   git add -A
   git commit -m "[$ExeName] Initial commit"
fi

# Merge in repos
while Boolean $True; do
   cd $BaseDir
   ImportDir=".Import"
   rm -rf $ImportDir
   Echo "Ready for the next repo to merge into $BaseName. Enter in a URL
   (SSH/HTML), or nothing to finish. (URL [DIRECTORY])"
   Read -p $ReadPrefix -t 30 RepoUrl RepoNameTemp
   if [[ $RepoUrl == "" ]]; then
      break
   fi
   if [[ $RepoNameTemp != "" ]]; then
      RepoName=$(echo $RepoNameTemp | cut -d ' ' -f 1)
   else
      RepoName=$(basename $(basename $RepoUrl) .git)
   fi
   if [[ -e $RepoName ]]; then
      rm -rf $BaseDir
      Error "Attempting to add subdirectory that already exists"
   fi
   Echo "Cloning $(EchoColor Yellow)$RepoUrl$(EchoColor) into $(EchoColor Yellow)$BaseName/$RepoName$(EchoColor)"
   git clone $RepoUrl $ImportDir
   if [[ -e $ImportDir ]]; then
      cd $ImportDir
      mkdir .$RepoName
      mv * .$RepoName
      mv .$RepoName $RepoName
      git add -A
      git commit -m "[$ExeName] Moving $RepoName into $BaseName/$RepoName"
      cd ..
      git remote add -f Import $ImportDir
      rm -rf $ImportDir
      git merge Import/master -m "[$ExeName] Merging $RepoName into $BaseName/$RepoName"
      git remote rm Import
      if [[ -e $RepoName/README.md ]]; then
         echo "* [$RepoName]($RepoName/README.md)" >> README.md
      elif [[ -e $RepoName/README ]]; then
         echo "* [$RepoName]($RepoName/README)" >> README.md
      else
         echo "* $RepoName" >> README.md
      fi
      git add -A
      git commit -m "[$ExeName] Finalizing $BaseName/$RepoName"
      git tag $RepoName
   else
      rm -rf $BaseDir
      Error "Error cloning in $RepoUrl, aborting"
   fi
done

# Finishing
cd $BaseDir
Echo "Successfully processed $BaseName"
Echo "Enter in a remote repository URL to push the merged repo to, or nothing to finish. (URL)"
Read -p $ReadPrefix -t 30 BaseUrl
if [[ $BaseUrl != "" ]]; then
   Echo "Pushing $(EchoColor Yellow)$BaseName$(EchoColor) to $(EchoColor Yellow)$BaseUrl$(EchoColor)"
   git remote add origin $BaseUrl
   git push origin +master
   git push -f origin --tags
   Echo "Successfully pushed $BaseName"
   Echo "Would you like to delete base repo directory $BaseName? (y/n)"
   Read -p $ReadPrefix -t 15 Input
   if [[ $Input == "y" ]]; then
      Echo "Deleting $(EchoColor Yellow)$BaseDir$(EchoColor)"
      rm -rf $BaseDir
   fi
fi
Exit
