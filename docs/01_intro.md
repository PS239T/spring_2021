# Managing data and code {#intro}

## Project-oriented research

### Computational reproducibility

#### Setup


```r
pacman::p_load(
  tidyverse, # tidyverse
  here # computational reproducibility
)
```

#### Motivation 

Why do you need to make your research project computationally reproducible?

For your self-interest and public benefits. 

![](https://github.com/dlab-berkeley/efficient-reproducible-project-management-in-R/blob/master/misc/screenshot.png?raw=true)

#### RStudio 

There are two main ways of interacting with R: using the console or by using script files (plain text files that contain your code).

If R is ready to accept commands, the R console shows a `>` prompt. If it receives a command (by typing, copy-pasting or sent from the script editor using `Ctrl-Enter`; `Command-Enter` will also work on Macs), R will try to execute it, and when ready, show the results and come back with a new `>`-prompt to wait for new commands. This is the equivalent of the `$` in your terminal. 

##### Basic Syntax

**Comments**

Use `#` signs to comment. Comment liberally in your R scripts. Anything to the right of a `#` is ignored by R. For those of you familiar with other languages, there is no doc string, or equivalent to `"""` in R.

**Assignment operator**

`<-` is the assignment operator. It assigns values on the right to objects on the left. So, after executing `x <- 3`, the value of `x` is `3`. The arrow can be read as 3 **goes into** `x`.  You can also use `=` for assignments. 


```r
USweird <- "Why use lb for pound!" # Use this

"Why use lb for pound!" = USweird
```

Nonetheless, *can* does not mean you *should*. It is good practice to use `<-` for assignments. `=` should only be used to specify the values of arguments of functions. This is what Google and Hadley Wickham recommend as well. If they don't convince you enough, here's [a real example](https://csgillespie.wordpress.com/2010/11/16/assignment-operators-in-r-vs/).


```r
mean(x = 1:10) # Does it save x?
```

```
## [1] 5.5
```

```r
rm(x)
```

```
## Warning in rm(x): object 'x' not found
```

```r
mean(x <- 1:10) # Does it save x?
```

```
## [1] 5.5
```

```r
rm(x)
```

**Printing**

In R, the contents of an object can be printed by either simply executing the the object name or calling the ```print()``` function.

**Help**

* `?` + object opens a help page for that specific object
* `??` + object searches help pages containing the name of the object


```r
?mean
??mean
help(mean)

# The above three will do same. 

example(ls) # provides example for how to use ls 

help.search("visualization") # search functions and packages that have "visualization" in their descriptions
```

#### Environment 

##### Objects 

- List objects in your current environment


```r
# Create a numeric object 
x <- c(1,2,3,4,5)

# List the object 
ls()

# Remove the object 
rm(x)
```

- Remove objects from your current environment


```r
# Create an object 
x <- 5

# Remove the object 
rm(x)
```

- Remove all objects from your current environment


```r
# Create an object 
a <- 7

b <- 3

# Remove the object 
rm(list = ls())
```

- Force memory release 


```r
# Garbage collect; for more information, type ?gc() 

gc()
```

##### Packages 

`install.packages(package-name)` will download a package from one of the CRAN mirrors assuming that a binary is available for your operating system. 


```r
# From CRAN
install.packages("dplyr") 

# Load package 
library(dplyr)

# From GitHub 
devtools::install_github("jaeyk/tidytweetjson") # my own package 

# Unload package 
# detach("package:stats", unload=TRUE)
```

**Tips**

If you have multiple packages to install, then please consider using pacman package. The following is the example. First, you install pacman. Then, you load several libraries by using `p_load()` method.


```r
install.packages("pacman")

pacman::p_load(
  ggplot2,
  dplyr, 
  broom
)
```

If you don't like to use `pacman`, then the other option is to create a list (we're going to learn what is list soon).


```r
pkgs <- c("ggplot2", "dplyr", "broom")

install.packages(pkgs)
```
  
Still, we have to write two lines. The simpler, the better, right? Here's another approach that can simplify the code further.

Note that `lapply()` applies (there's a family of apply functions) a function to a list. In this case, library to pkgs. apply is an advanced concept, which is related to anonymous functions. We will learn about it later when we study functions.


```r
inst <- lapply(pkgs, library, 
               character.only = TRUE)
```

#### How to organize files in a project 

You won't be able to reproduce your project unless it is efficiently organized. 

Step 1. [**Environment**](https://environments.rstudio.com/) is part of your project. If someone can't reproduce your environment, they won't be able to run your code.

- Launch R Studio. Choose Tools > Global Options. You should not check `Restor .RData into workspace at startup` and set saving workspace option to `NEVER`.

Step 2. For each project, create a project directory named after the project. 

name_of_the_project 

- data: 
  - raw 
  - processed (all processed, cleaned, and tided)
- figures 
- packrat (optional) 
- reports (PDF, HTML, TEX, etc.,) 
- results (model outcomes, etc.,)
- scripts (i.e., functions)
- .gitignore (for Git)
- name_of_project.Rproj (for R)
- README.md (for Git) 

![Working directory structure example](https://datacarpentry.org/R-ecology-lesson/img/working-directory-structure.png)



```r
# Don't name it a project. Use a name that's more informative. For instance, us_election not my_project.

dir.create("../us_election")
```

Step 3. Launch R Studio. Choose File > New project > Browse existing directories > Create project This allows each project has its own workspace. 

Step 4. Organize files by putting them in separate subdirectories and naming them in a sensible way.

- Treat raw data as read only (raw data should be RAW!) and put in the `data` subdirectory.

    - Note that version control does not need replace backup. You still need to backup your raw data. 


```r
dir.create(here::here("us_election", "data"))
```

- Separate read-only data from processed data and put in the `processed_data` subdirectory.


```r
dir.create(here::here("us_election", "processed_data"))
```

- Put your code in the `src` subdirectory. 


```r
dir.create(here::here("us_election", "src"))
```

- Put generated outputs (e.g., tables, figures) in the `outputs` subdirectory and treat them as disposable.


```r
dir.create(here::here("us_election", "outputs"))
```

- Put your custom functions in the `functions` subdirectory. You can gather some of these functions and distribute them as an open-source library. 


```r
dir.create(here::here("us_election", "src"))
```

**Challenge**

Set a project structure for a project named "starwars". 

#### How to organize code in a R markdown file 

- In addition to environment, **workflow** is an important component of project efficiency and reproducibility. 

- What is R markdown? An R package, developed by [Yihui Xie](https://yihui.org/en/), that provides an authoring framework for data science. Xie is also a developer of many widely popular R packages such as `knitr`, [`xaringan`](https://github.com/yihui/xaringan) (cool kids use xaringan not [Beamer](https://en.wikipedia.org/wiki/Beamer_(LaTeX)) these days), `blogdown` (used to create [my personal website](https://jaeyk.github.io/)), and `bookdown` (used to create this book) among many others.

  - Many applications: [reports](https://rstudio.github.io/distill/basics.html), [presentations](https://bookdown.org/yihui/rmarkdown/xaringan.html), [dashboards](https://rmarkdown.rstudio.com/flexdashboard/), [websites](https://bookdown.org/yihui/rmarkdown/websites.html)  
  - Check out [Communicating with R markdown workshop](https://ysc-rmarkdown.netlify.app/) by [Alison Hill](https://alison.rbind.io/) (RStudio)
    - Alison Hill is a co-author of [`blogdown: Creating Websites with R Markdown.`](https://bookdown.org/yihui/blogdown/) 
  - Key strengths: dynamic reporting + reproducible science + easy deployment

```{=html}
<iframe width="560" height="315" src="https://www.youtube.com/embed/s9aWmU0atlQ" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<p>R Markdown The bigger picture - Garrett Grolemund</p>
```

```{=html}
<iframe width="560" height="315" src="https://www.youtube.com/embed/Xn5AmUf7gDQ" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<p>R-Ladies Oslo (English) - Reports to impress your boss! Rmarkdown magic - Athanasia Mowinckel</p>
```

- R Markdown basic syntax 


```r
# Header 1
## Header 2
### Header 3
```

- Use these section headers to indicate workflow.


```r
# Import packages and data
# Tidy data
# Wrangle data
# Model data
# Visualize data
```

- Press `ctrl + shift + o`. You can see a document outline based on these headers. This is a nice feature for finding code you need to focus. 

- If your project's scale is large, then divide these sections into files, number, and save them in `code` subdirectory. 

   - 01_wrangling.Rmd
   - 02_modeling.Rmd 
   ... 

#### Making a project computationally reproducible

- `setwd()`: set a working directory. 

- Note that using `setwd()` is not a reproducible way to set up your project. For instance, none will be able to run the following code except me.


```r
# Set a working directory 
setwd("/home/jae/starwars")

# Do something 
ggplot(mtcars, aes(x = mpg, y = wt)) +
   geom_point()

# Export the object. 
# dot means the working directory set by setwd()
ggsave("./outputs/example.png") # This is called relative path 
```

- Instead, learn how to use `here()`'.

   - Key idea: separate workflow (e.g., workspace information) from products (code and data). For more information, read Jenny Bryan's wonderful piece on [project-oriented workflow](https://www.tidyverse.org/blog/2017/12/workflow-vs-script/).

   - Example 


```r
# New: Reproducible 

ggplot(mtcars, aes(x = mpg, y = wt)) +
   geom_point()

ggsave(here("project", "outputs", "example.png"))
```

   - How `here` works 

   `here()` function shows what's the top-level project directory. 


```r
here::here()
```
   - Build a path including subdirectories 


```r
here::here("project", "outputs")
           #depth 1   #depth 2
```
   - How `here` defines the top-level project directory. The following list came from [the here package vignette](https://github.com/jennybc/here_here)).

      - Is a file named .here present?
      - Is this an RStudio Project? (**Note that we already set up an RStudio Project!** So, if you use RStudio's project feature, then you are ready to use `here`.)
      - Is this an R package? Does it have a DESCRIPTION file?
      - Is this a remake project? Does it have a file named `remake.yml`?
      - Is this a projectile project? Does it have a file named `.projectile`?
      - Is this a checkout from a version control system? Does it have a directory named `.git` or `.svn`? Currently, only Git and Subversion are supported.

      - If there's no match then use `set_here()` to create an empty `.here` file. 

**Challenge**

1. Can you define computational reproducibility? 
2. Can you explain why sharing code and data is not enough for computational reproducibility? 

### Version control (Git and Bash)

![](https://github.com/dlab-berkeley/BashGit/raw/master/octobash.png)

#### What Is Bash?

##### Unix

UNIX is an operating system which was first developed by AT & T employees at Bell Labs (1969-1971).  Bell Labs canceled the project (MULTICS) but was continued by the employees worked in a smaller scale. The new project was named UNICS (Uniplexed Information and Computation System) and then renamed UNIX. Due to [the anti-trust issue](https://en.wikipedia.org/wiki/Breakup_of_the_Bell_System), AT & T gave away UNIX in 1975. Berkeley is one of the main places where UNIX was developed. [The Berkeley Software Distribution](https://en.wikipedia.org/wiki/Berkeley_Software_Distribution), one of the branches of UNIX, came out it 1977.

From Mac OS X to Linux, many of current operation systems are some versions of UNIX. 

For more information on the history of UNIX, see [this link](https://docs.google.com/presentation/d/1kKt9V6rom55hU6SJ2_3nGluobjtScptlnJV9YFe6Jz4/pub?start=false&loop=false&delayms=3000&slide=id.g163c5ae2ce_0_17).

![Unix history](https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Unix_history-simple.svg/1200px-Unix_history-simple.svg.png)

##### Kernel

The kernel of UNIX is the hub of the operating system: it allocates time and memory to programs and handles the [filestore](http://users.ox.ac.uk/~martinw/unix/chap3.html) (e.g., files and directories) and communications in response to system calls. 

##### Shell

The shell is an interactive program that provides an interface between the user and the kernel. The shell interprets commands entered by the user or supplied by a shell script, and passes them to the kernel for execution. 

As an illustration of the way that the shell and the kernel work together, suppose a user types `rm myfile` (which has the effect of removing the file *myfile*). The shell searches the filestore for the file containing the program `rm`, and then requests the kernel, through system calls, to execute the program `rm` on *myfile*. When the process `rm myfile` has finished running, the shell then returns the UNIX prompt % to the user, indicating that it is waiting for further commands.

We'll talk more about shells in a little bit.

##### Human-Computer interfaces

At a high level, computers do four things:

-   run programs
-   store data
-   communicate with each other
- interact with us

  They can do the last of these in many different ways, including direct brain-computer links and speech interfaces. Since these are still in their infancy, most of us use windows, icons, mice, and pointers. These technologies didn't become widespread until the 1980s, but their roots go back to [Doug Engelbart who received his Ph.D. in electrical engineering from the University of California, Berkeley in 1955 and was hired as an assistant professor at the same department for a year. He then left academia and joined the tech industry and became one of the founding fathers in HCI field (mouse, hypertext, GUI, etc.,).

Going back even further, the only way to interact with early computers was to rewire them. But in between, from the 1950s to the 1980s, most people used line printers. These devices only allowed input and output of the letters, numbers, and punctuation found on a standard keyboard, so programming languages and interfaces had to be designed around that constraint.

##### The Command Line

This kind of interface is called a **command-line interface**, or CLI,
to distinguish it from the **graphical user interface**, or GUI, that most people now use.

The heart of a CLI is a **read-evaluate-print loop**, or REPL: when the user types a command and then presses the enter (or return) key, the computer reads it, executes it, and prints its output. The user then types another command,
and so on until the user logs off.

As William Shotts the author of *[The Linux Command Line](http://linuxcommand.org/tlcl.php)* put it: 
>graphical user interfaces make easy tasks easy, while command line interfaces make difficult tasks possible.

##### The Shell

This description makes it sound as though the user sends commands directly to the computer, and the computer sends output directly to the user. In fact,
there is usually a program in between called a **command shell**.

What the user types goes into the shell; it figures out what commands to run and orders the computer to execute them. 

Note, the reason why the shell is called *the shell*: it encloses the operating system in order to hide some of its complexity and make it simpler to interact with. 

A shell is a program like any other. What's special about it is that its job is to run other programs rather than to do calculations itself. The commands are themselves programs: when they terminate, the shell gives the user another prompt ($ on our systems).

##### Bash

The most popular Unix shell is **Bash**, the Bourne Again Shell (so-called because it's derived from a shell written by Stephen Bourne --- this is what passes for wit among programmers). Bash is the default shell on most modern implementations of **Unix**, and in most packages that provide Unix-like tools for Windows.

##### Why Shell?

Using Bash or any other shell sometimes feels more like programming than like using a mouse. Commands are terse (often only a couple of characters long), their names are frequently cryptic, and their output is lines of text rather than something visual like a graph. 

On the other hand, the shell allows us to combine existing tools in powerful ways with only a few keystrokes and to set up pipelines to handle large volumes of data automatically.

In addition, the command line is often the easiest way to interact with remote machines. As clusters and cloud computing become more popular for scientific data crunching, being able to drive them is becoming a necessary skill.

##### Our first command

The part of the operating system responsible for managing files and directories is called the **file system**. It organizes our data into files, which hold information, and directories (also called "folders"), which hold files or other directories.

Several commands are frequently used to create, inspect, rename, and delete files and directories. To start exploring them, let's open a shell window:

```shell
$
```

The dollar sign is a **prompt**, which shows us that the shell is waiting for input; your shell may show something more elaborate.

Type the command `whoami`, then press the Enter key (sometimes marked Return) to send the command to the shell.

The command's output is the ID of the current user, i.e., it shows us who the shell thinks we are:

```shell
$ whoami

oski
```

More specifically, when we type `whoami` the shell:

1.  finds a program called `whoami`,
2.  runs that program,
3.  displays that program's output, then
4.  displays a new prompt to tell us that it's ready for more commands.

##### Communicating to other systems

In the next unit, we'll be focusing on the structure of our own operating systems. But our operating systems rarely work in isolation; often, we are relying on the Internet to communicate with others! You can visualize this sort of communication within your own shell by asking your computer to `ping` (based on the old term for submarine sonar) an IP address provided by Google (8.8.8.8); in effect, this will test whether your Internet (thanks Airbears2) is working. 

```shell
$ ping 8.8.8.8
```

Note: Windows users may have to try a slightly different alternative:

```shell
$ ping -t 8.8.8.8
```

Your computer will begin continuously pinging this IP address and reporting back the "latency," or how long it took for the ping data packet to go to that IP address and back. If your Internet isn't working, it will instead report an error saying "No route to host." 

Ping runs continuously, so when we want it to stop, we have to manually tell the kernel to stop executing the ping command. We do this simply by typing ctrl+c. 

(Thanks [Paul Thissen](http://www.paulthissen.org/) for the suggestion!)

##### File system organization

Next, let's find out where we are by running a command called `pwd` (**print working directory**).

At any moment, our **current working directory** is our current default directory, i.e., the directory that the computer assumes we want to run commands in  unless we explicitly specify something else.

Here, the computer's response is `/home/oski`, which is the **home directory**:

```shell
$ pwd

/home/oski
```

> #### Home Directory
>
> The home directory path will look different on different operating systems. On Linux it will look like `/home/oski`, and on Windows it will be similar to `C:\Documents and Settings\oski`. Note that it may look slightly different for different versions of Windows.

> #### Alphabet Soup
>
> If the command to find out who we are is `whoami`, the command to find out where we are ought to be called `whereami`, so why is it `pwd` instead? The usual answer is that in the early 1970s, when Unix was
> first being developed, every keystroke counted: the devices of the day were slow, and backspacing on a teletype was so painful that cutting the number of keystrokes in order to cut the number of typing mistakes was actually a win for usability. The reality is that commands were added to Unix one by one, without any master plan, by people who were immersed in its jargon. The result is as inconsistent as the roolz uv Inglish speling, but we're stuck with it now. 
>
> The good news: because these basic commands were so integral to the development of early Unix, they have stuck around, and appear (in some form) in almost all programming languages.

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
> When it appears at the front of a file or directory name, it refers to the root directory. When it appears *inside* a name, it's just a separator.

##### Listing

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
> You may have noticed that all of our's files' names are "something dot something". This is just a convention: we can call a file `file` or almost anything else we want. However, most people use two-part names most of the time to help them (and their programs) tell different kinds of files apart. The second part of such a name is called the **filename extension**, and indicates what type of data the file holds: 
> `.txt` signals a plain text file, `.pdf` indicates a PDF document, `.cfg` is a configuration file full of parameters for some program or other, and so on.
>
> This is just a convention, albeit an important one. Files contain bytes: it's up to us and our programs to interpret those bytes according to the rules for PDF documents, images, and so on.
>
> Naming a PNG image of a whale as `whale.mp3` doesn't somehow magically turn it into a recording of whalesong, though it *might* cause the operating system to try to open it with a music player when someone double-clicks it.

Now let's take a look at what's in your `Desktop` directory by running `ls -F data`, i.e., the command `ls` with the **arguments** `-F` and `PS239T`. The second argument --- the one *without* a leading dash --- tells `ls` that we want a listing of the files in something other than our current working directory:

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

If we run `ls -F /Desktop` (*with* a leading slash) we get a different answer, because `/Desktop` is an **absolute path**:

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

Use relative paths (e.g., ../PS239T/references.md) whenever it's possible so that your code is not dependable on how your system is configured. 

##### Moving around

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

##### Tab completion

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



##### Writing your first shell script 

Write a shell script that creates a directory called `/pdfs` under `/Download` directory, then find PDF files in `/Download` and copy those files to `pdfs`. This shell script creates a backup.

```bash

#!/bin/sh

mkdir /home/jae/Downloads/pdfs 

cd Download

cp *.pdf pdfs/ 

echo "Copied pdfs"

```

#### Git and GitHub

##### Version control system 

![Why you should do version control](https://i2.wp.com/cdn-images-1.medium.com/max/399/1*7HHA_UkjUK7wp7qP4CYu1g.png?zoom=1.75&w=456&ssl=1)


According to [Github Guides](https://guides.github.com), a versin control system "tracks the history of changes as people and teams collaborate on projects together". Specifically, it helps to track the following information:

* Which changes were made?
* Who made the changes?
* When were the changes made?
* Why were changes needed?

Git is a case of a [distributed version control system](https://en.wikipedia.org/wiki/Distributed_version_control), common in open source and commercial software development. This is no surprising given that Git [was originally created](https://lkml.org/lkml/2005/4/6/121) to deal with Linux kernal development. 

* If you're curious about how the Intenret works, learn one of the key ideas of the Internet: [end-to-end principle](https://en.wikipedia.org/wiki/End-to-end_principle). This also explains why [net neutrality](https://en.wikipedia.org/wiki/Net_neutrality) matters. 

The following images, from [Pro Git](git-scm.com), show how a centralized (e.g., CVS, Subversion, and Perforce) and decentralized VCS (e.g., Git, Mercurial, Bazzar or Darcs) works differently. 

![Centralized version control system](https://git-scm.com/book/en/v2/images/centralized.png)

Figure 2. Centralized VCS.

![Decentralized version control system](https://git-scm.com/book/en/v2/images/distributed.png)

Figure 3. Decentralized VCS.

For more information on the varieties of version control systems, please read [Petr Baudis's review](https://pdfs.semanticscholar.org/4490/4c70bc91e1bed4fe02b9e2282f031b7c90ea.pdf) on that subject.


![Figure 2.1. A schematic git workflow from Healy's "The Plain Person’s Guide to Plain Text Social Science"](https://plain-text.co/figures/git-basic.png)


##### Setup 

We'll start with telling Git who you are.

```shell
$ git config --global user.name "Firstname Lastname"
$ git config --global user.email username@company.extension
```
##### Making a repository 

Create a new directory and move to it. 

```shell 
$ mkdir code_exercise 
$ cd code_exercise 
```


```shell
$ git init 
```

Alternatively, you can create a Git repository via Github and then clone it on your local machine. 


```shell
$ git clone /path/to/repository
```

If you're unfamiliar with basic Git commands, then please refer to [this Git cheet sheet](http://rogerdudler.github.io/git-guide/files/git_cheat_sheet.pdf).

##### Commit changes 

These feature show how Git works as a version control system. 

If you edited files or added new ones, then you need to update your repository. In Git terms, this action is called committing changes. 


```shell
$ git add . # update every change. In Git terms, you're staging. 
$ git add file_name # or stage a specific file.
$ git commit -m "your comment" # your comment for the commit. 
$ git push origin master # commit the change. Origin is a defaul name given to a server by Git. 
```

Another image from [Pro Git](https://git-scm.com/about/staging-area) well illustrates this process.

![Git Workflow](https://git-scm.com/images/about/index1@2x.png)

##### Other useful commands for tracking history


```shell
$ git diff # to see what changed (e.g., inside a file)
$ git log # to track who committed what
$ git checkout the commit hash (e.g., a5e556) file name (fruit_list.txt) # to recover old files 
$ git revert 1q84 # revert to the previous commit 
```

#####  Doing other than adding 


```shell
$ git rm file_name # remove 
$ git mv old_file_name new_file_name # rename a file 
```

##### Push and pull (or fetch)

These features show how Git works as a collaboration tool. 

If you have not already done, let's clone PS239T directory on your local machine.


```shell
$ git clone https://github.com/jaeyk/PS239T # clone 
```

Then, let's learn more about the repository.


```shell
$ git remote -v 
```

Previously, we learned how to send your data save in the local machine to the remote (the Github server). You can do that by editing or creating files, committing, and then typing **git push**. 

Instead, if you want to update your local data with the remote data, then you can type **git pull origin** (something like pwd in bash). Alternatively, you can use fetch (retrieve data from a remote). When you do that, Git retrieves the data and merge it into your local data.


```shell
$ git fetch origin
```

##### Branching 

It's an advanced feature of Git's version control system that allows developers to "diverge from the main line of development and continue to do work without messing with that main line" according to [Scott Chacon and Ben Straub](https://git-scm.com/book/en/v1/Git-Branching). 

If you start working on a new feature, then create a new branch. 


```shell
$ git branch new_features
$ git checkout new_features
```

You can see the newly created branch by typing **git branch**.

In short, branching makes Git [works like](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics) a mini file system.

##### Collaborations 

Two options. 

* Sharing a repository (suitable for a private project).
* Fork and pull (suitable for an open source project). 
    ​    * The one who maintains the repository becomes the maintainer. 
    ​    * The others can [fork](https://help.github.com/articles/about-forks/), make changes, and even [pull](https://help.github.com/articles/about-pull-requests/) them back.

##### Other stuff 


```shell
$ git status # show the status of changes 
$ git branch # show the branch being worked on locally
$ git merge # merge branches 
$ git reset --hard # restore the pristine version
$ git commit -a -m "additional backup" # to save the state again
```



##### Deployment: GitHub Pages 

##### Tracking progress: GitHub Issues 

##### Project management: GitHub Dashboards

## Writing code: How to code like a professional

### Write readable code

- What is code style?

> Every major open-source project has its own style guide: a set of conventions (sometimes arbitrary) about how to write code for that project. It is much easier to understand a large codebase when all the code in it is in a consistent style. - [Google Style Guides](https://google.github.io/styleguide/) 

```{=html}

<iframe width="560" height="315" src="https://www.youtube.com/embed/UjhX2sVf0eg" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
allowfullscreen></iframe>

<p>10 Tips For Clean Code - Michael Toppa</p>

```

- How to avoid smelly code? 

  - Check out [the code-smells Git repository](https://github.com/jennybc/code-smells-and-feels#readme) by Jenny Bryan. 
  
```{=html}
<iframe width="560" height="315" src="https://www.youtube.com/embed/7oyiPBjLAWY" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

<p> Code smells and feels - Jenny Bryan</p>

<p> "Code smell" is an evocative term for that vague feeling of unease we get when reading certain bits of code. It's not necessarily wrong, but neither is it obviously correct. We may be reluctant to work on such code, because past experience suggests it's going to be fiddly and bug-prone. In contrast, there's another type of code that just feels good to read and work on. What's the difference? If we can be more precise about code smells and feels, we can be intentional about writing code that is easier and more pleasant to work on. I've been fortunate to spend the last couple years embedded in a group of developers working on the tidyverse and r-lib packages. Based on this experience, I'll talk about specific code smells and deodorizing strategies for R. - Jenny Bryan</p>
```

- Naming matters 

  - When naming files, remember the following three rules:
      - Machine readable (avoid spaces, punctuation, periods, and any other special characters except _ and -)
      - Human readable (should be meaningful. No text1, image1, etc.,)
      - Ordering (e.g., 01, 02, 03,  ... )
    


```r
# Good
fit_models.R

# Bad
fit models.R
```

  - When naming objects:
      - Don't use special characters.
      - Don't capitalize.


```r
# Good 
day_one
    
# Bad 
DayOne
```

  - When naming functions:
      - Don't use special characters.
      - Don't capitalize.
      - Use `verbs` instead of `nouns`. (Functions do something!)
    

```r
# Good 
run_rdd 

# Bad 
rdd
```
    
- Spacing 


```r
# Good
x[, 1] 

mean(x, na.rm = TRUE) 

# Bad

x[,1]

mean (x, na.rm = TRUE)
```

- Indenting 


```r
# Good
if (y < 0) {
  message("y is negative")
}

# Bad
if (y < 0) {
message("Y is negative")}
```

- Long lines


```r
# Good
do_something_very_complicated(
  something = "that",
  requires = many,
  arguments = "some of which may be long"
)

# Bad
do_something_very_complicated("that", requires = many, arguments =
                              "some of which may be long"
                              )
```

- Comments 
   - Use comments to explain your decisions. 
   - But, show your code; Do not try to explain your code by comments.
   - Also, try to comment out rather than delete the code that you experiment with. 


```r
# Average sleep hours of Jae
jae %>%
  # By week
  group_by(week) %>%
  # Mean sleep hours 
  summarise(week_sleep = mean(sleep, na.rm = TRUE))
```

- Pipes (chaining commands)


```r
# Good
iris %>%
  group_by(Species) %>%
  summarize_if(is.numeric, mean) %>%
  ungroup() %>%
  gather(measure, value, -Species) %>%
  arrange(value)

# Bad
iris %>% group_by(Species) %>% summarize_all(mean) %>%
ungroup %>% gather(measure, value, -Species) %>%
arrange(value)
```

- Additional tips 

- Use `lintr` to check whether your code complies with a recommended style guideline (e.g., `tidyverse`) and `styler` package to format your code according to the style guideline.

![how lintr works](https://camo.githubusercontent.com/6cb80270269165a8d3046d2da03cbf2b8f19ee2f/687474703a2f2f692e696d6775722e636f6d2f61635632374e562e676966)

### Write reusable code 

- Pasting 

> Copy-and-paste programming, sometimes referred to as just pasting, is the production of highly repetitive computer programming code, as produced by copy and paste operations. It is primarily a pejorative term; those who use the term are often implying a lack of programming competence. It may also be the result of technology limitations (e.g., an insufficiently expressive development environment) as subroutines or libraries would normally be used instead. However, there are occasions when copy-and-paste programming is considered acceptable or necessary, such as for boilerplate, loop unrolling (when not supported automatically by the compiler), or certain programming idioms, and it is supported by some source code editors in the form of snippets. - [Wikipedia](https://en.wikipedia.org/wiki/Copy-and-paste_programming) 

- It's okay for pasting for the first attempt to solve a problem. But if you copy and paste three times (a.k.a. [Rule of Three](https://en.wikipedia.org/wiki/Rule_of_three_(computer_programming)) in programming), something's wrong. You're working too hard. You need to be lazy. What do I mean and how can you do that?

- The following exercise was inspired by [Wickham's example](http://adv-r.had.co.nz/Functional-programming.html).

- Let's imagine `df` is a survey dataset. 

    - `a, b, c, d` = Survey questions 

    - `-99`: non-responses 
    
    - Your goal: replace `-99` with `NA` 
    

```r
# Data

set.seed(1234) # for reproducibility 

df <- tibble("a" = sample(c(-99, 1:3), size = 5 , replace= TRUE),
             "b" = sample(c(-99, 1:3), size = 5 , replace= TRUE),
             "c" = sample(c(-99, 1:3), size = 5 , replace= TRUE),
             "d" = sample(c(-99, 1:3), size = 5 , replace= TRUE))
```


```r
# Copy and paste 
df$a[df$a == -99] <- NA
df$b[df$b == -99] <- NA
df$c[df$c == -99] <- NA
df$d[df$d == -99] <- NA

df
```

```
## # A tibble: 5 x 4
##       a     b     c     d
##   <dbl> <dbl> <dbl> <dbl>
## 1     3     3     3     1
## 2     3     2     3     1
## 3     1    NA     1     2
## 4     1    NA     2     1
## 5    NA     1     1     3
```

- Using a function 
   - function: input + computation + output 
   - If you write a function, you gain efficiency because you don't need to copy and paste the computation part. 


```r
# Create a custom function
fix_missing <- function(x) { # INPUT
  x[x == -99] <- NA # COMPUTATION
  x # OUTPUT 
}

# Apply the function to each column (vector)
# This iterated part can and should be automated.
df$a <- fix_missing(df$a)
df$b <- fix_missing(df$b)
df$c <- fix_missing(df$c)
df$d <- fix_missing(df$d)

df
```

- Automation
   - Many options for automation in R: `for loop`, `apply` family, etc. 
   - Here's a tidy solution comes from `purrr` package.
   - The power and joy of one-liner. 


```r
df <- purrr::map_df(df, fix_missing) # What is this magic? We will unpack the blackbox (`map_df()`) later.

df
```

- Takeaways

1. Your code becomes more reusable, when it's easier to **change, debug, and scale up**. Don't repeat yourself and embrace the power of lazy programming. 

> Lazy, because only lazy programmers will want to write the kind of tools that might replace them in the end. Lazy, because only a lazy programmer will avoid writing monotonous, repetitive code—thus avoiding redundancy, the enemy of software maintenance and flexible refactoring. Mostly, the tools and processes that come out of this endeavor fired by laziness will speed up the production. -  [Philipp Lenssen](http://blogoscoped.com/archive/2005-08-24-n14.html)
  
2. Only when your code becomes **reusable**, you would become **efficient** in your data work. Otherwise, you need to start from scratch or copy and paste, when you work on a new project.

> Code reuse aims to save time and resources and reduce redundancy by taking advantage of assets that have already been created in some form within the software product development process.[2] The key idea in reuse is that parts of a computer program written at one time can be or should be used in the construction of other programs written at a later time. - Wikipedia 

### Test your code systematically 

## Asking questions: Minimal reproducible example

### How to create a minimal reproducible example

- Chances are you're going to use StackOverFlow a lot to solve a pressing problem you face. However, other can't understand/be interested in your problem unless you can provide an example which they can understand with minimal efforts. Such example is called a minimal reproducible example. 

- Read [this StackOverFlow post](https://stackoverflow.com/questions/5963269/how-to-make-a-great-r-reproducible-example) to understand the concept and best practices.

- Simply put, a MRE consists of the following items:

    - A minimal dataset 
    - The minimal burnable code
    - The necessary information on package, R version, system (use `sessionInfo()`)
    - A seed for reproducibility (`set.seed()`), if you used a random process. 

## References

- Project-oriented research 

   - Computational reproducibility 

      - ["Good Enough Practices in Scientific Computing"](https://github.com/swcarpentry/good-enough-practices-in-scientific-computing/blob/gh-pages/good-enough-practices-for-scientific-computing.pdf) by PLOS
      
      - [Project Management with RStudio](https://swcarpentry.github.io/r-novice-gapminder/02-project-intro/) by Software Carpentry
      
      - [Initial steps toward reproducible research](https://kbroman.org/steps2rr/) by Karl Broman
      
   - Version control 
   
      - [Version Control with Git](https://swcarpentry.github.io/git-novice/) by Software Carpentry
   
      - [The Plain Person’s Guide to Plain Text Social Science](http://plain-text.co/) by Kieran Healy 
      
- Writing code 

   - Style guides 
      - R 
         - [Google's R style guide](https://google.github.io/styleguide/Rguide.xml)
         - [R code style guide](http://r-pkgs.had.co.nz/r.html) by Hadley Wickham 
         - [The tidyverse style guide](http://style.tidyverse.org/) by Hadley Wickham
      - Python 
         - [Google Python Style Guide](https://github.com/google/styleguide/blob/gh-pages/pyguide.md)
         - [Code Style](https://docs.python-guide.org/writing/style/#zen-of-python) by the Hitchhiker's Guide to Python
