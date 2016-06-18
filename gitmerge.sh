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
trap "Exit" SIGHUP SIGINT SIGTERM
Error() {
   Echo "$(EchoColor Red)$@$(EchoColor)"
   Exit
}

# Echo Configuration
source $ExeDir/Echo.sh
EchoPrefix="$(EchoColor Cyan)$ExeName$(EchoColor):"
ReadPrefix="$(EchoColor Yellow)$ExeName$(EchoColor)$"

# Program start
Echo "$ExeName - Git repository merging utility"

# Find base repo
BaseName=""
Echo "Enter in the name of the base repo directory to be created. (DIRECTORY)"
Read -p $ReadPrefix -t 15 BaseName
if [[ $BaseName == "" ]]; then
   Error "Invalid name for directory"
elif [[ $BaseName == "." ]]; then
   Echo "Using the current directory as the base repo directory."
   BaseDir=$(pwd)
   BaseName=$(basename $BaseDir)
elif [[ -e $BaseName ]]; then
   Error "Directory $BaseName already exists"
else
   Echo "Setting up $BaseName as new git base."
   mkdir $BaseName
   cd $BaseName
   BaseDir=$(pwd)
fi

# Initializing base repo, if necessary
if [[ ! -e .git/ ]]; then
   git init
   echo -e "# $BaseName\nBase git repo created with $ExeName" > README
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
   Echo "Cloning in $RepoUrl into $RepoName"
   git clone $RepoUrl $ImportDir
   if [[ -e $ImportDir ]]; then
      cd $ImportDir
      mkdir .$RepoName
      mv * .$RepoName
      mv .$RepoName $RepoName
      git add -A
      git commit -m "[$ExeName] Moving $RepoName to subdirectory"
      cd ..
      git remote add -f Import $ImportDir
      rm -rf $ImportDir
      git merge Import/master -m "[$ExeName] Merging $RepoName into $BaseName"
      git remote rm Import
      git add -A
      git commit -m "[$ExeName] Finalizing $RepoName"
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
   git remote add origin $BaseUrl
   git push origin master
fi
Exit
