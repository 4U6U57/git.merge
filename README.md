# gitmerge.sh

[![Join the chat at https://gitter.im/4U6U57/gitmerge](https://badges.gitter.im/4U6U57/gitmerge.svg)](https://gitter.im/4U6U57/gitmerge?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

Git repository merging utility

## Installation
This script requires a Unix enviornment running Bash. This is available out of
the box on most Linux distros, BSD installations, and macOS. It can be
installed as a subsystem for Windows by enabling it under Additional Features.

To install it, simply run
```
git clone http://github.com/4U6U57/gitmerge ~/bin/
cd ~/bin/gitmerge
make install
```

This assumes that the `~/bin/` directory is in your `$PATH`.

## Usage
Simply run `gitmerge.sh` in the directory you would like to create the merged
repository. Use "." if you would like to use the current directory.

## File Input
Format a file using the regular language below for automated merging, running the 
program with input redirect like so: `gitmerge.sh < FILE`

```
$MERGE_NAME
($DOWNLOAD_URL ($DIRECTORY_NAME)?)*

($UPLOAD_URL)?
(y)?
```

where
- `$MERGE_NAME` is the directory name of the base repo (the one you would like to
  merge others into)
- `$DOWNLOAD_URL` is the git clone URL, either in SSH or HTML form, of each repo
  you would like to merge into the base repo. Each URL should be on its own
  line. Examples of repo URLs below:
   * `git@github.com:4U6U57/gitmerge`
   * `http://github.com/4U6U57/gitmerge`
- `$DIRECTORY_NAME` is the optional name of the subdirectory in which the
  merged repo will be moved to. If none is provided, the default will be used
  (default for the `git clone` command)
- `$UPLOAD_URL` is the optional git clone URL of where you would like to push
  the final merged repo when it is completed. Note that there must be exactly
  one blank line in between the last `$DOWNLOAD_URL` and the `$UPLOAD_URL`
- `y` is the literal letter `y`, placed on the line after the `$UPLOAD_URL` if
  you would like to delete the base repo directory after pushing it

Here is an example file, merging in the repo *gitmerge* into the subdirector *merge*, 
and repo *vimrc* into the default subdirectory name (*vimrc*), and then uploading it 
to the repo *example.merge* while keeping the local contents.

```
example
git@github.com:4U6U57/gitmerge merge
http://bitbucket.org/4U6U57/vimrc

git@github.com:4U6U57/example.merge
```
