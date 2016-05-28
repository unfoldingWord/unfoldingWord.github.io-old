# Steps-by-step for setting up a development environment

### These instructions were tested using IntelliJ/RubyMine on Ubuntu 16.04

__Install system dependencies__

    sudo apt-get update
    sudo apt-get install git git-core curl libssl-dev libreadline-dev libyaml-dev python-software-properties
    sudo apt-get install libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev libffi-dev
    sudo apt-get install zlib1g-dev build-essential patch ruby-dev liblzma-dev

__Install and configure rbenv__

    cd ~/
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(rbenv init -)"' >> ~/.bashrc
    exec $SHELL
    
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    echo 'export PATH="$HOME/.rbenv/plugins/ruby-build/bin:$PATH"' >> ~/.bashrc
    exec $SHELL
    
    git clone https://github.com/rbenv/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash

__Install ruby 2.2.2__

    rbenv install 2.2.2
    rbenv global 2.2.2
    ruby -v

__Install bundler__

    gem install bundler
    rbenv rehash

__Install jekyll__

    gem install jekyll

__Install btsync__

    sudo gedit /etc/apt/sources.list

Append the following line, then save and close:

    deb http://linux-packages.getsync.com/btsync/deb btsync non-free
    
Next, do the install

    wget http://linux-packages.getsync.com/btsync/key.asc
    sudo apt-key add key.asc
    sudo apt update
    sudo apt install btsync
    sudo systemctl enable btsync
    sudo systemctl start btsync
    systemctl status btsync

You can view the btsync gui by opening http://127.0.0.1:8888

Request a link to the unfoldingWord assets share and set it up to sync into the `/var/www/projects/unfoldingWord.github.io/assets/` directory

__Get the project from Github__

    git clone -v --progress git@github.com:unfoldingWord/unfoldingWord.github.io.git /var/www/projects/unfoldingWord.github.io

__Open the project in IntelliJ/RubyMine__

1. Start IntelliJ or RubyMine.
2. Click `File` > `New` > `Project`.
3. Select `Ruby` and click `Next`.
4. Choose `/var/www/projects/unfoldingWord.github.io` as the project location.
5. Click `Finish`.
6. Install missing gems if prompted.
7. Run `bundle install` in the IntelliJ/RubyMine terminal.

__Create a Run configuration__

1. Click `Run` > `Edit Configurations...`.
2. Click the `green plus sign` and add a new `Ruby` configuration.
3. In the `Name` field enter `Build and Serve`.
4. In the `Ruby script` field enter `/home/team43/.rbenv/versions/2.2.2/bin/jekyll`, replacing `team43` with your username.
5. In the `Script arguments` field enter `serve --no-watch`.
6. Remove everything from the `Before launch: activate tool window` list.
7. Click on the `bundler` tab and check `Run script in the context of bundle`.
8. Click `OK` to save and close the dialog.

