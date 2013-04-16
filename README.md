# Maria

Maria is an engine that has CMS features with some (I'd like to think)
tricks.

Some of the most important are the following:

* Maria will serve 'assets' that are backed by a git repo, not by a DB.
* Since Maria assets are persisted by a git repo, developers can
make changes to any asset as if he was editing any other file.
* Also helps to keep following normal deployment processes.

## Quick start

Maria is an ENGINE, not a Rails app. And Engine is a friendly module
that plays nice with rack. So, since any Rails application is an Engine
with really badass steroids, any other Engine can be mounted in any
Rails application.

To see maria in action, you need to go under /spec/dummy and run rails s
from there. Dummy is just a very light rails dummy app that has Maria
mounted in it.

## Tests

So Maria comes with Spork and guard so that you can have a continuos
testing environment.

If you feel very attracted to this idea, just run:

    guard -i

This will start spork and automatically detects which file was changed
and run the test for it. Cool huh?


Spork is another gem that will load any necessary files before the tests
run and keep them so that when we run them again, we already have the
files loaded. If you're interested run in another terminal.

    spork


And then run

     rspec spec/

They will load muuuuch faster.


If you don't want any of this stuff, just run rspec as you would
normally and will work ;)


# Important concepts

## Persistence layers

Maria persists assets first in the disk and then in github repos.

The process is the following.

1. Write to disk
2. Stage file
3. Commit file
4. Push commit to remote

There are two modules that handle this persistence work. The first one
is FileControl and the other is Git.

### FileControl Module

Persist any object to disk that has a name and content. Just by
including the module into your class would make the job.

    # We need to set the root folder
    FileControl.root = '.'

    class Album
      attr_accessor :name, :content
      include FileControl
    end

    album = Album.new
    album.name = 'InRainbows'
    album.content = 'Magic'
    album.write

    # => Writes a file with name: InRainbows with content: Magic, under
          'albums/' dir


### Git Module

This module needs that the object that is including it responds to
write and file_path. In Maria we are including FileControl and then Git.
They are meant together <3

    class Album
      # .. with same as above
      include Git
    end

     a = Album.new
     a.name = 'test'
     a.content = 'foobar'
     a.stage
     a.commit
     a.push

Git needs some configuration options first before use.

    Git.remote = 'origin'
    Git.remote_url = 'remotes/origin/{branch}'
    Git.root = 'maria/app'

remote is the remote repo
remote_url is the url under the remote branches. (Find out more by doing
git branch -a) to list all branches.
Git.root is a path that will use to expand the file names.


### Assetable Base

This class pretends to mirror what ActiveRecord::Base does. You'd
inherit any new asset from this class and create the asset type module
under assetable dir.

    class Html < Assetable::Base
      asset_type :html
    end

    module Assetable::Html
      include Assetable::Template
      def asset_type
        :html
      end
      # ... and
    end


Assetable::Base comes with attributes validations and persistence
methods like `save` and `update_attributes`.


With this class now we can use other Rails modules such as
active_resource to generate forms and stuff.


# Work to be done
* Persist images, not only text assets.
* Give the end-user ( marketing people ) the chance to add variables
into the html files, such as user name or something like that.
