# Codon Hooks - We are the build server

## Introduction

These two git hooks provide the functionality of the Heroku codon build server, they
are implemented in Bash for simplicity. The pre-signed S3 URL to download the repo
and a pre-signed PUT URL for the updated repo and compiled slug are provided to
the job via environment variables (as part of the dyno execution manifest). The 
hooks are mount binded on the repo/hooks directory during dyno creation to avoid
duplication and to propagate hook changes without complexity.

The dynohost runs git-receive-pack and thus these hooks  under the non-privilege 
rukouser account in an LXC dyno just like a provision dyno.

## Requirements

Tested on Linux 3.2 using Bash 4

On a fresh Ubuntu 12.04 LTS instance:  
```
apt-get install git
apt-get install curl
```

Please share experiences with CentOS, Fedora, OS X, FreeBSD etc...   
Note: buildpacks might have environment dependencies that you need to add to the host OS.

***
i.e. ruby buildpack wont be supported unless you have installed ruby in host, even
though you might vendor Ruby with your project the Ruby buildpack relies on Ruby.

I couldnt get the buildpack for ruby to work using the default 1.8x, instead I 
installed 1.9.1 on the host and changes /etc/alternatives/ruby to point to that,
as /etc/alternatives is bind mounted into the lxc container.
***

## Installation

Step 1:
```
sudo apt-get install libltdl7 # for php buildpack to work
git clone https://github.com/openruko/codonhooks.git codonhooks  
```
Step 2:

Configure dynohost CODONHOOKS_PATH env var to point to this checkout directory.

## Environment Variables

Passed through from the API server to the dynohost to ps-run to git-receive-pack
and finally to the hooks.

## Help and Todo 

Make more resilent regarding error handling, log and report errors.

## Tests

To test codonhooks first create `/app` dir owned by your user. It is needed by php buildpack
```
sudo mkdir /app
sudo chown $USER. /app
./run-tests.sh
```

## License

codonhooks and other openruko components are licensed under MIT.  
[http://opensource.org/licenses/mit-license.php](http://opensource.org/licenses/mit-license.php)

## Authors and Credits

Matt Freeman  
[email me - im looking for some remote work](mailto:matt@nonuby.com)  
[follow me on twitter](http://www.twitter.com/nonuby )
