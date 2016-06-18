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

# Echo Configuration
source $ExeDir/Echo.sh
EchoPrefix="$(EchoColor Cyan)$ExeName$(EchoColor):"

# Program start
Echo "$ExeName - Git repository merging utility"

case "$-" in
   *i*)
      Echo "Running in interactive mode"
      ;;
   *)
      Echo "Running in script mode"
      ;;
esac

# Find base repo
BaseName=""
if [[ -e .git ]]; then
   bash
   BaseName=$(basename pwd)
   Echo "Currently in git repo $BaseName. Would you like to use this as your base? (y,n)"
   Read -p $EchoPrefix Input
   if [[ $Input != "y" ]]; then
      Echo "Please change directories, and try again."
      Exit
   fi
   Echo "Setting up $BaseName as base."
else
   Echo "No base git repo detected, creating. What would you like to call it? (DIRECTORY)"
   Read -p $EchoPrefix BaseName
   if [[ $BaseName == "" ]]; then
      Echo "Invalid name"
      Exit
   fi
   Echo "Setting up $BaseName as new git base."
   mkdir $BaseName
   cd $BaseName
   git init
   echo -e "# $BaseName\nBase git repo created with $ExeName" > README
   git add -A
   git commit -m "[$ExeName] Initial commit"
fi

while Boolean $True; do
   ImportDir=".Import"
   rm -rf $ImportDir
   Echo "Ready for the next repo to merge into $BaseName. Enter in a URL
   (SSH/HTML), or nothing to finish. (URL [DIRECTORY])"
   Read -p $EchoPrefix RepoUrl RepoNameTemp
   if [[ $RepoUrl == "" ]]; then
      break
   fi
   if [[ $RepoNameTemp != "" ]]; then
      RepoName=$(echo $RepoNameTemp | cut -d ' ' -f 1)
   else
      RepoName=$(basename $(basename $RepoUrl) .git)
   fi
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
      Echo "Error cloning in $RepoUrl"
   fi
done
