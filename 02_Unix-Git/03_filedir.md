
# The Unix Shell: 3. Files and Directories

> ### Learning Objectives
>
> *   Explain the similarities and differences between a file and a directory.
> *   Translate an absolute path into a relative path and vice versa.
> *   Construct absolute and relative paths that identify specific files and directories.
> *   Explain the steps in the shell's read-run-print cycle.
> *   Identify the actual command, flags, and filenames in a command-line call.
> *   Demonstrate the use of tab completion, and explain its advantages.


### 1. File System Organization

Next, let's find out where we are by running a command called `pwd` (**print working directory**).

At any moment, our **current working directory** is our current default directory, i.e., the directory that the computer assumes we want to run commands in  unless we explicitly specify something else.

Here, the computer's response is `/home/oski`, which is the **home directory**:

```shell
$ pwd

/home/oski
```

> #### Home Directory
> 
> The home directory path will look different on different operating systems. 
> On Linux it will look like `/home/oski`, and on Windows it will be similar 
> to `C:\Documents and Settings\oski`. Note that it may look slightly 
> different for different versions of Windows.

> #### Alphabet Soup
> 
> If the command to find out who we are is `whoami`, the command to find
> out where we are ought to be called `whereami`, so why is it `pwd`
> instead? The usual answer is that in the early 1970s, when Unix was
> first being developed, every keystroke counted: the devices of the day
> were slow, and backspacing on a teletype was so painful that cutting the
> number of keystrokes in order to cut the number of typing mistakes was
> actually a win for usability. The reality is that commands were added to
> Unix one by one, without any master plan, by people who were immersed in
> its jargon. The result is as inconsistent as the roolz uv Inglish
> speling, but we're stuck with it now. 
> 
> The good news is: because these basic commands were so integral to the 
> development of early Unix, they have stuck around, and appear (in some form) 
> in almost all programming languages.

To understand what a "home directory" is, let's have a look at how the file system as a whole is organized. At the top is the **root directory** that holds everything else.

We refer to it using a slash character `/` on its own; this is the leading slash in `/home/oski`.

Inside that directory are several other directories: `bin` (which is where some built-in programs are stored), `data` (holding miscellaneous data files) `etc` (where local configuration files are stored), `tmp` (for temporary files that don't need to be stored long-term), and so on.

> If you're working on a Mac, the file structure will look similar, but not 
> identical. The following image shows a file system graph for the typical Mac.

![File Directory](https://swcarpentry.github.io/shell-novice/fig/home-directories.svg)

We know that our current working directory `/home/oski` is stored inside `/home` because `/home` is the first part of its name. Similarly, we know that `/home` is stored inside the root directory `/` because its name begins with `/`.

> #### Path
> 
> Notice that there are two meanings for the `/` character.
> When it appears at the front of a file or directory name,
> it refers to the root directory. When it appears *inside* a name,
> it's just a separator.

### 2. Listing

Let's see what's in your home directory by running `ls` (**list files and directories):

```shell
$ ls

Applications		Dropbox			Pictures
Creative Cloud Files	Google Drive		Public
Desktop			Library			Untitled.ipynb
Documents		Movies			anaconda
Downloads		Music			file.txt
```

`ls` prints the names of the files and directories in the current directory in alphabetical order, arranged neatly into columns.

We can make its output more comprehensible by using the **flag** `-F`, which tells `ls` to add a trailing `/` to the names of directories:

```shell
$ ls -F

Applications		Dropbox			Pictures
Creative Cloud Files	Google Drive		Public
Desktop			Library			Untitled.ipynb
Documents		Movies			anaconda
Downloads		Music			file.txt
```

And note that there is a space between `ls` and `-F`: without it, the shell thinks we're trying to run a command called `ls-F`, which doesn't exist.

> #### What's In A Name?
> 
> You may have noticed that all of our's files' names are "something dot
> something". This is just a convention: we can call a file `file` or
> almost anything else we want. However, most people use two-part names
> most of the time to help them (and their programs) tell different kinds
> of files apart. The second part of such a name is called the
> **filename extension**, and indicates what type of data the file holds: 
> `.txt` signals a plain text file, `.pdf` indicates a PDF document, `.cfg` is 
> a configuration file full of parameters for some program or other, and so on.
>
> This is just a convention, albeit an important one. Files contain
> bytes: it's up to us and our programs to interpret those bytes
> according to the rules for PDF documents, images, and so on.
>
> Naming a PNG image of a whale as `whale.mp3` doesn't somehow
> magically turn it into a recording of whalesong, though it *might*
> cause the operating system to try to open it with a music player
> when someone double-clicks it.

Now let's take a look at what's in your `Desktop` directory by running `ls -F data`, i.e., the command `ls` with the **arguments** `-F` and `PS239T`. The second argument --- the one *without* a leading dash --- tells `ls` that
we want a listing of the files in something other than our current working directory:

```shell
$ ls -F PS239T

01_Introduction/			10_python-basics/
02_Unix-Bash/				11_FINAL PROJECTS/
03_r-basics/				12_text-analysis-python/
04_r-data-analysis/			13_text-analysis-r/
05_r-visualization/			14_machine-learning/
06_APIs/				15_machine-learning-applications/
07_html-css-javascript/			A_Syllabus.md
08_webscraping/				B_Install.md
09_qualtrics-mturk/			README.md
```

The output shows us that there are three files and fifteen sub-sub-directories. Organizing things hierarchically in this way helps us keep track of our work: it's possible to put hundreds of files in our home directory, just as it's possible to pile hundreds of printed papers on our desk, but it's a self-defeating strategy.

Notice, by the way that we spelled the directory name `Desktop`. It doesn't have a trailing slash: that's added to directory names by `ls` when we use the `-F` flag to help us tell things apart. And it doesn't begin with a slash because it's a **relative path**, i.e., it tells `ls` how to find something from where we are, rather than from the root of the file system.

> #### Parameters vs. Arguments
>
> According to [Wikipedia](https://en.wikipedia.org/wiki/Parameter_(computer_programming)#Parameters_and_arguments),
> the terms **argument** and **parameter** mean slightly different things.
> In practice, however, most people use them interchangeably or inconsistently,
> so we will too.

If we run `ls -F /Desktop` (*with* a leading slash) we get a different answer,
because `/Desktop` is an **absolute path**:

```shell
$ ls -F /Desktop

ls: /Desktop: No such file or directory
```

The leading `/` tells the computer to follow the path from the root of the file system, so it always refers to exactly one directory, no matter where we are when we run the command.

What if we want to change our current working directory? Before we do this, `pwd` shows us that we're in `/home/oski`, and `ls` without any arguments shows us that directory's contents:

```shell
$ pwd

/home/oski (/Users/rachel)

$ ls

Applications		Dropbox			Pictures
Creative Cloud Files	Google Drive		Public
Desktop			Library			Untitled.ipynb
Documents		Movies			anaconda
Downloads		Music			file.txt
```

### 3. Moving Around

We can use `cd` (**change directory**) followed by a directory name to change our working directory. 

```shell
$ cd Desktop
```

`cd` doesn't print anything, but if we run `pwd` after it, we can see that we are now in `/home/oski/Desktop`.

If we run `ls` without arguments now, it lists the contents of `/home/oski/Desktop`, because that's where we now are:

```shell
$ pwd

/home/oski/Desktop

```

We now know how to go down the directory tree: how do we go up? We could use an absolute path:

```shell
$ cd /home/oski/
```

but it's almost always simpler to use `cd ..` to go up one level:

```shell
$ pwd

/home/oski/Desktop

$ cd ..
```

`..` is a special directory name meaning "the directory containing this one",
or more succinctly, the **parent** of the current directory. Sure enough, if we run `pwd` after running `cd ..`, we're back in `/home/oski/`:

```shell
$ pwd

/home/oski/
```

The special directory `..` doesn't usually show up when we run `ls`. If we want to display it, we can give `ls` the `-a` flag:

```shell
$ ls -a

.		.localized	Shared
..		Guest		rachel
```

`-a` stands for "show all"; it forces `ls` to show us file and directory names that begin with `.`, such as `..`.

> #### Hidden Files: For Your Own Protection
> 
> As you can see, a bunch of other items just appeared when we enter `ls -a`. 
> These files and directories begin with `.` followed by a name. These are 
> usually files and directories that hold important programmatic information,
> not usually edited by the casual computer user. They are kept hidden so that
> users don't accidentally delete or edit them without knowing what they're
> doing.

As you can see, it also displays another special directory that's just called `.`, which means "the current working directory". It may seem redundant to have a name for it, but we'll see some uses for it soon.

> #### Phone Home
> 
> If you ever want to get to the home directory immediately, you can use the 
> shortcut `~`. For example, type `cd ~` and you'll get back home in a jiffy. 
> `~` will also stand in for your home directory in paths, so for instance 
> `~/Desktop` is the same as `/home/oski/Desktop`. This only works if it is 
> the first character in the path: `here/there/~/elsewhere` is not 
> `/home/oski/elsewhere`.

### 4. Tab Completion
If you are in you home directory, you can see what files you have on your `Desktop` using the command:

```shell
$ ls ~/Desktop
```

This is a lot to type, but she can let the shell do most of the work. If she types:

```shell
$ ls ~/Des
```

and then presses tab, the shell automatically completes the directory name for her:

```shell
$ ls ~/Desktop
```

Pressing tab again does nothing, since there are multiple possibilities. Pressing tab twice brings up a list of all the files and directories, and so on.

This is called **tab completion**, and we will see it in many other tools as we go on.

> ####  Quick File Paths
> 
> If you quickly need the path of a file or directory, you can also copy the 
> file/directory in the GUI and paste.The full path of the file or directory 
> will appear. 

## Exercises

#### Challenge 1

1. Change your working directory to the place where you want to clone the `PS239T` materials. 
2. type `git clone https://github.com/jaeyk/PS239T.git` 
3. `cd` into the `PS239T/02_Unix-Bash` sub-directory.
2. list the files in the directory

#### Challenge 2

What does the command `cd` without a directory name do?

1.  It has no effect.
2.  It changes the working directory to `/`.
3.  It changes the working directory to the user's home directory.
4.  It produces an error message.

#### Challenge 3

What does the command `ls` do when used with the -s arguments?



