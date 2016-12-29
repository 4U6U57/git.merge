# gitmerge.sh

[![Join the chat at https://gitter.im/4U6U57/gitmerge](https://badges.gitter.im/4U6U57/gitmerge.svg)](https://gitter.im/4U6U57/gitmerge?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
Git repository merging utility

## Installation
This script requires a Unix enviornment running Bash (available for Linux,
macOS, and Windows Insider Preview Fast).

To install it, simply run
```
git clone http://github.com/4U6U57/gitmerge ~/bin/
cd ~/bin/gitmerge
make install
```

## Usage
Simply run `gitmerge.sh` in the directory you would like to create the merged
repository. Use "." if you would like to use the current directory.

## File Input
Format a file as follows, for automated merging, then run with input redirect
like so `gitmerge.sh < FILE`

```
MERGE_NAME
DOWNLOAD_URL [DIRECTORY_NAME]
DOWNLOAD_URL [DIRECTORY_NAME]
...
DOWNLOAD_URL [DIRECTORY_NAME]

[UPLOAD_URL]
[y]
```

where
* `MERGE_NAME` is the directory name of the base repo (the one you would like to
  merge others into)
* `DOWNLOAD_URL` is the git clone URL, either in SSH or HTML form, of each repo
  you would like to merge into the base repo. Each URL should be on its own
  line. Examples of repo URLs below:
   * `git@github.com:4U6U57/gitmerge`
   * `http://github.com/4U6U57/gitmerge`
* `[DIRECTORY_NAME]` is the optional name of the subdirectory in which the
  merged repo will be moved to. If none is provided, the default will be used
  (default for the `git clone` command)
* `[UPLOAD_URL]` is the optional git clone URL of where you would like to push
  the final merged repo when it is completed. Note that there must be exactly
  one blank line in between the last `DOWNLOAD_URL` and the `UPLOAD_URL`
* `[y]` is the literal letter `y`, placed on the line after the `UPLOAD_URL` if
  you would like to delete the base repo directory after pushing it

Here is an example file, merging in the repos *gitmerge* and *vimrc* into a repo
*example*, and uploading it to the repo *example.merge*. *gitmerge* is saved
into the subdirectory *merge*, and *vimrc* into the default subdirectory name.

```
example
git@github.com:4U6U57/gitmerge merge
http://bitbucket.org/4U6U57/vimrc

git@github.com:4U6U57/example.merge
```
