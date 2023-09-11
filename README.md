# pushgit
Helper script to make git commits to (private) repositories easier, especially on a new system.
It does the following:
- creates a sample config file named .pushgit.conf in the directory where the script is located.
- reads github userdata from config file
- sets initial git.user and git.email environment variables from config file
- asks for repositorie's name
- makes initial clone of repository before first commit
- adds all files in the repositories subfolder
- asks for a commit message (and optionally a branch name)
- commits the repository with provided token authentication

Since pushgit treats itself the same just as any other repository, it creates any repository directories in it's parent folder. 
That means when you clone it into /home/(user name)/git/ and thereby creating /home/(user name)/git/pushgit/, still all new repositories managed with this go into /home/(user name)/git/, no matter where pushgit is called from. 
So you could just add it to your $PATH and call it from anywhere, if wanted.

Usage:
pushgit [repository name] "[commit message]" "[branch name]"
If arguments are provided, the first argument is treated as the repositorie's name and the second one ist used as the commit message (don't forget to enclose it between "", otherwise every word will be treated as an argument), whereas the third one can be supplied as a branch name, if not using main branch.
If no arguments are provided, they will be saked for by the script.
