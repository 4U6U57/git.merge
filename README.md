# gitmerge.sh
Git repository merging utility

## Installation
This script requires a Unix enviornment running Bash (available for Linux,
macOS, and Windows Insider Preview Fast).

To get it, simply run
```
git clone http://github.com/4U6U57/gitmerge ~/bin/
```

Then, run it from wherever you want with `~/bin/gitmerge/gitmerge.sh` (add
`~/bin/gitmerge` to your PATH to make it easier).

## Usage
Simply run `~/bin/gitmerge` in the directory you would like to 

## File Input
Format a file as follows, for automated merging, then run with input redirect
like so `~/bin/gitmerge < FILE`

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
  line. Examples are below:
   * `git@github.com:4U6U57/gitmerge`
   * `http://github.com/4U6U57/gitmerge`
* `[DIRECTORY_NAME]` is the optional name of the subdirectory in which the
  merged repo will be moved to. If none is provided, the default will be used
  (default for the `git clone` command)
* `[UPLOAD_URL]` is the optional git clone URL of where you would like to push
  the final merged repo when it is completed. Note that there must be exactly
  one blank line in between the last `DOWNLOAD_URL` and the `UPLAOD_URL`
* `[y]` is the literal letter `y`, placed on the line after the `UPLOAD_URL` if
  you would like to delete the base repo directory after pushing it
