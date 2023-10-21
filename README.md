# Assassin

## config

Create a config file in this folder with the name `assassin.conf` and the following contents:
```sh
#!/bin/bash                                # Set the environment vars with bash
export PASSWORD_FILE=path/to/passwd        # Path to a file containing the brno.assassin.cz password on a single line (relative to this dir)
export COOKIES_FILE=path/to/cookies        # Path to a file where the login script will store the session cookies (relative to this dir)
export HXSELECT=/path/to/hxselect          # path to the hxselect executable (from html-xml-utils) Defaults to searching the PATH for "hxselect"
```

## Usage

* Log in to the website using `login.sh <username>`
* Fetch family leaderboard: `rodiny.sh <webhook_url>` 
* Fetch players leaderboard: `hraci.sh <webhook_url>`

## Crontab

You can install crontabs to have the script run at periodic intervals

* Remember to set the `ASSASSIN_ROOT` env var to this directory

### Example

```crontab
5 0 * * * ASSASSIN_ROOT=/home/dave/assassin /home/dave/assassin/login.sh dave
6 0 * * * ASSASSIN_ROOT=/home/dave/assassin /home/dave/assassin/rodiny.sh example.com
6 0 * * * ASSASSIN_ROOT=/home/dave/assassin /home/dave/assassin/hraci.sh example.com
```

