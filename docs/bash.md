---
output: html_document
editor_options:
  chunk_output_type: console
---



# Bash

The *Bourne-again shell* ([bash](https://en.wikipedia.org/wiki/Bash_%28Unix_shell%29)) is usually the programming language that you will use when running the command line.

To be efficient you will therefore need some knowledge of this language. I do not intend to rewrite the 1254th tutorial on *"How to use bash"* since there are [allready](https://www.bash.academy/) [lots](https://www.learnshell.org/) [of](http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO.html) [tutorials](https://www.shellscript.sh/) [online](https://www.codecademy.com/learn/learn-the-command-line) (again - google is your friend here...).

Here I will give a small overview and simply list the common patterns/issues/programs and the way I deal with them in bash:

## Commands/Programs (I/II)

The first thing you need to know is *how to navigate* using the command line.

The following commands help you with that:

- `pwd` is short for "print working directory" and reports the location on your file system where the command line is currently operating (this tells you *where you are*)
- `ls` will print the content (the files & folders) of the current directory (*what is around you*)
- `cd` is short for "change directory" and allows you to change your working directory (*move around*)
- `echo` allows you to print some text as output (it allows you to *speak*)
- `./` is the current directory
- `..` is the *parent* directory (the directory which contains the current directory)

With this you can do the most basic navigation.
In our assumed project this could look like this:


```bash
pwd
#> /home/khench/root_folder
```

```bash
ls
#> analysis.Rproj
#> analysis_twisst.nf
#> data
#> docs
#> logo.svg
#> nextflow.config
#> py
#> R
#> README.md
#> sh
```

```bash
cd data
pwd
#> /home/khench/root_folder/data
```


```bash
ls
#> genotypes.vcf.gz
#> table1.txt
#> table2.txt
```

```bash
cd ..
ls
#> analysis.Rproj
#> analysis_twisst.nf
#> data
#> docs
#> logo.svg
#> nextflow.config
#> py
#> R
#> README.md
#> sh
```


One thing that makes your life easier when using the command line is the <tab> key on your keyboard.
If you don't know what it does *try it*.
It's basically an auto-complete for your input.

If eg. you are sitting in the `root_folder` and want to move to `root_folder/data` all you need to type is `root_folder/da<tab>` and it will auto-complete to `root_folder/data`.
Typing `root_folder/d<tab>` will not be enough since this is ambiguous since it might complete to either `root_folder/data` or `root_folder/docs`.
Of course, in this example we only saved a single key stroke, but in *real life* <tab> can save you a lot of (mis-)typing.

## Paths

A *path* is a location on your file system - it is quite similar to a URL in your web browser.
It can either point to a file or to folder.

We have seen this before: the command `pwd` prints the *path* to the current working directory.

Generally we need to be aware of two different types - *absolute* vs. *relative* paths:

An absolute path looks something like this:

`/home/khench/root_folder` (Note the leading slash `/home...`.)

This is what the type of path that `pwd` reports and it will always point to the same location on your file system regardless of the directory you are currently operating in. That is because the leading slash points to the root folder of your file system (not of your project) which is an *absolute* position.

The disadvantage of absolute paths is that *things can change*: you might move your project folder to a different location (backup on external hard drive) or share with collaborators. In these cases your path will point to a file/location that does not exist - it is basically a *broken link*.

Therefore in some cases the use of *relative paths* is useful.
Relative paths indicate the location of a file/folder *relative to your current working directory*.

We used this for example in the command `cd data` (short for `cd ./data`).
Here, there is no leading slash - instead the path starts directly with the folder name or with the current directory (`./`)

So to get from the `root_folder` into the `data` folder we can use either of the two commands:

- `cd data` (relative path)
- `cd /home/khench/root_folder/data`  (absolute path)

## Variables

Variables are *containers for something else*. You can for example store some text in a variable.
Later you can access this "information".
Therefore you have to address the variable name and put it behind a dollar sign:


```bash
VAR="some text"
echo ${VAR}
#> some text
```

(There are two equivalent notations: `$VAR` and `${VAR}`.
The notation with curly brackets helps if your variable name is more complex since the start and end of the name is exactly defined.)

Variables are often used to store important paths.
You could for example store the (absolute) location of your project folder in a Variable (`PROJ="/home/khench/root_folder"`) in some sort of configuration script and then use the variable to navigate (`cd $PROJ/data`).
That way you only need to update the location of the project folder in a single place in case it needs to be updated.

There are quite a view variables that are already defined on your computer and it is good to be aware of these.
Two important ones are `$HOME` and `$PATH`.

`$HOME` directs to the home folder of the user (often you can also use `~/` as an equivalent to `$HOME/`):


```bash
echo ${HOME}
test='asre'
#> /home/khench
```

`$PATH` often not a directory but a collection of directories separated by a colon:

```sh
/usr/bin:/usr/local/bin:/home/khench/bin
```

The `$PATH` is a super important variable - it the register of directories where your computer looks for installed software.
Every command that you type into the command line (eg. `cd` or `ls`) is a program that is located in one of the folders within your `$PATH`.

You can still run programs that are located elsewhere, but if you do so you need to specify the *absolute path* of this program (`/home/khench/own/scripts/weird_script.py` instead of just `weird_script.py`).

We will discuss [later](#later) how to extend the `$PATH` in case you want to include a custom software folder if you need to install stuff manually.

## Scripts

So far, we have been working interactively on the command line.
That is we typed directly into the terminal and observed the direct output.
But I claimed before that one of the advantages of the command line is that reproducible and the possibility to protocol the work on the command line.
One aspects of this is the ability to store your workflow in scripts.
If you use a script to store bash commands the conventional suffix is `.sh` (eg: `script.sh`).
Additionally it is useful to add a header line that points to the location of bash itself (usually one of the two):

```sh
#!/bin/bash
or
#!/usr/bin/env bash
```

A full (admittedly quite silly) script might look like this:

```sh
#!/usr/bin/env bash

cd /home/khench/root_folder
ls
echo " --------------- "
pwd
```

Provided the script is located in our `sh` folder you can run it like this:


```bash
bash /home/khench/root_folder/sh/script.sh
#> analysis.Rproj
#> analysis_twisst.nf
#> data
#> docs
#> logo.svg
#> nextflow.config
#> py
#> R
#> README.md
#> sh
#>  --------------- 
#> /home/khench/root_folder
```

The big benefit of using bash scripts is that you will be able to remember later what you are doing right now.
A workflow that you do interactively is basically *gone* in the sense that you will never be able to remember it exactly.

As with the paths there is one script that you should be aware of - your bash start up script.
This is a hidden file (`.bashrc` or `.bash_profile`)located in your `$HOME` folder.
This script is run every time when you open the terminal and will be important [later](#later).

## Commands/Programs (II/II)

### Flags

One important feature of most command line programs is the usage of *flags*.
These are (optional) parameters that alter they way a program operates an are invoked with `-` or `--` (depending on the program):


```bash
ls -l
#> total 164
#> -rw-rw-r-- 1 khench khench      0 Mär  7 15:47 analysis.Rproj
#> -rw-rw-r-- 1 khench khench      0 Mär  7 15:47 analysis_twisst.nf
#> drwxrwxr-x 2 khench khench   4096 Mär 11 19:09 data
#> drwxrwxr-x 2 khench khench   4096 Mär  7 15:47 docs
#> -rw-rw-r-- 1 khench khench 142065 Jul 12  2018 logo.svg
#> -rw-rw-r-- 1 khench khench      0 Mär  7 15:47 nextflow.config
#> drwxrwxr-x 2 khench khench   4096 Mär  7 15:48 py
#> drwxrwxr-x 2 khench khench   4096 Mär  7 15:48 R
#> -rw-rw-r-- 1 khench khench    439 Mär 11 17:13 README.md
#> drwxrwxr-x 2 khench khench   4096 Mär  7 17:25 sh
```


```bash
ls -lth
#> total 164K
#> drwxrwxr-x 2 khench khench 4,0K Mär 11 19:09 data
#> -rw-rw-r-- 1 khench khench  439 Mär 11 17:13 README.md
#> drwxrwxr-x 2 khench khench 4,0K Mär  7 17:25 sh
#> drwxrwxr-x 2 khench khench 4,0K Mär  7 15:48 R
#> drwxrwxr-x 2 khench khench 4,0K Mär  7 15:48 py
#> -rw-rw-r-- 1 khench khench    0 Mär  7 15:47 nextflow.config
#> drwxrwxr-x 2 khench khench 4,0K Mär  7 15:47 docs
#> -rw-rw-r-- 1 khench khench    0 Mär  7 15:47 analysis.Rproj
#> -rw-rw-r-- 1 khench khench    0 Mär  7 15:47 analysis_twisst.nf
#> -rw-rw-r-- 1 khench khench 139K Jul 12  2018 logo.svg
```

Arguably one of the most important flags for most programs is `-help`/`--help`.
As you might guess this will print the documentation for most programs.
Often this includes an example of the input the program expects, as well as all the options available.

### More commands/programs

Apart from the most basic commands needed for *navigating* within the command line, I want to list the commands I personally use most frequently to actually *do stuff*:


#### Operators

```sh
#     # comment code (stuff here is not executed)
>     # redirect output into file (overrides existing file)
>>    # append existing file (creates new file if not yet existent)
1>    # redirect stdout to file (1>> append)
2>    # redirect stderr to file (2>> append)
2>&1  # redirects stderr to stdout
&>    # redirect both stdout and stderr to file
|     # the 'pipe': combine commands (THIS ONE IS IMPORTANT)
*     # wildcard/joker: ls *.txt lists all files ending int '.txt'
\     # linebreak: continue a command on a new line (to avoid horribly long commands)
```

It is important to be aware of several [*channels*](http://tldp.org/LDP/abs/html/io-redirection.html) that are being used within bash:

- **stdin**: usually what you type into the terminal
- **stdout**: output created by a program
- **stderr**: errors created by a program

You can use the operators described above to log for example errors and/or output of a program in a log file. 

#### Reading Text
```sh
echo (-e, "\n", "\t" )     # print text to stdout, -e allows special chracters eg newline & tab
cat                        # read a text file and print to stdout
zcat                       # read a gz-compressed text file and print to stdout
less ("/")                 # read a text interactively (type "/" to search for a pattern)
head (-n,  -n -1)          # print the first (-n) lines of a text file (-1: everything but the last (1) lines)
tail (-n , -n +2)          # print the last (-n) lines of a text file (2+: everything starting at line (2))
grep (-v, -w, -i, 'a\|b')  # search for line (-v not) containing pattern within text file (a "or" b)
wc (-l, -c)                # count lines/chracters within text file
```
#### Text manipulation (table like text files)
```sh
paste         # combine columns 
sort          # sort textfiles based on specific column
```

#### Text manipulation (table like text files)
```sh
sed           # search and replace
awk           # power horse: filter rows, combines culumns, complex operations
cut (-c, -f)  # print selective columns/charaters of each row
```

In my opinion especially `sed` & `awk` are extremely powerful commands. 
I will give a few usage examples at the very [end](#end) of this section.

#### Text editors

There are several  actual text editors for the command line:

- [emacs](https://www.gnu.org/software/emacs/)
- [nano](https://www.nano-editor.org/)
- [vim](https://www.vim.org/)

All have their own *fan base*.
It makes sense to learn how to use at least one of those - basically all will require to learn a handful of key-combinations.

#### Organizing files
```sh
mkdir              # create new directory
ln (-s)            # create link to file/directory
rm (-r)            # delete file/directory
mv                 # move/rename file/directory
wget <URL>         # download file
gzip               # compress file (file.txt -> file.txt.gz)
gunzip             # decompress file (file.txt.gz -> file.txt)
tar (-zcvf/-zxvf)  # (de)compress folder (folder -> folder.tar.gz)
```

#### Organizing software
```sh
which (programm_name)  # look for the programm called "programm_name" and print its path
bash (script.sh)       # run "script.sh" within own bash session 
source (script.sh)     # run "script.sh" within current bash session 
```

## Loops

Sometimes you need to do one thing multiple times.
Or almost the same thing and just modify a single parameter.
In this case you can use loops instead of manual copy-and-paste.
There are two loops that you should know:

- `for`
- `while`


```bash
for k in A B C; do echo $k; done
#> A
#> B
#> C
```

You and use bash commands to create the sequence to loop over by using `$(command)` (eg: `$(ls *.txt)`).


```bash
for k in $(seq -w 9 11); do echo "LG"$k; done
#> LG09
#> LG10
#> LG11
```


You can also loop over the content of a file:


```bash
cat data/table1.txt
#> line1
#> line2
#> line3
```

```bash
Z=1
for k in $(cat data/table1.txt); do echo "--- $Z ----"; echo $k; Z=$(($Z + 1));  done
#> --- 1 ----
#> line1
#> --- 2 ----
#> line2
#> --- 3 ----
#> line3
```

Yet this might give unexpected results when your file contains whitespaces (looping over a table): 

```bash
cat data/table2.txt
#> A	1
#> B	2
#> C	3
```

```bash
Z=1
for k in $(cat data/table2.txt); do echo "--- $Z ----"; echo $k; Z=$(($Z + 1));  done
#> --- 1 ----
#> A
#> --- 2 ----
#> 1
#> --- 3 ----
#> B
#> --- 4 ----
#> 2
#> --- 5 ----
#> C
#> --- 6 ----
#> 3
```

In this case you can switch to `while`:

```bash
Z=1
while read k; do echo "--- $Z ----"; echo $k; Z=$(($Z + 1)); done < data/table2.txt
#> --- 1 ----
#> A 1
#> --- 2 ----
#> B 2
#> --- 3 ----
#> C 3
```

I use this pattern to read in parameters eg. for a function call within the loop:


```bash
while read k; do 
P1=$(echo $k | awk '{print $1}');
P2=$(echo $k | awk '{print $2}');
echo "parameter 1: ${P1}, parameter 2: ${P2}"
done < data/table2.txt
#> parameter 1: A, parameter 2: 1
#> parameter 1: B, parameter 2: 2
#> parameter 1: C, parameter 2: 3
```

## Installing new software

<a name="later"></a>
**This is hell!**
Installing new software is what can take up a huge portion of your time & sanity.
That is because most new programs that you want to install will not work straight *out of the box* but depend on 17 other programs, packages and libraries and all of course in specific versions winch contradict each other. These dependencies will then of course not work straight *out of the box* but depend on ... (You get the idea - right?)

Ok, I might exaggerate a little here but not much...

Therefore, whenever possible try to use package managers. These are programs that try to keep track of your software and - well - to *manage* the whole dependency hell for you.

Depending on your OS, there are different package managers available for you:

- Mac: [homebrew](https://brew.sh/)
- Ubuntu: apt-get (comes with the OS)
- Universal: [conda](https://conda.io/en/latest/)/[bioconda](https://bioconda.github.io/)

(Conda & especially bioconda are generally pretty useful, but lately they seem a little *buggy*.
That is, lately the take ages to load and their 'catalog' might not contain the *bleding edge* version of the program you're looking for.)

Yet, sometimes the program you need is not available using package managers.
In those cases you will have to bite the bullet and install the manually.
How to do this exactly varies case by case, but a common theme to *compile a program from source* is the following:

- `./configure`
- `make`
- `make install`

One example here would be the installation of [Stacks](http://catchenlab.life.illinois.edu/stacks/manual/#install):

```sh
wget http://catchenlab.life.illinois.edu/stacks/source/stacks-2.3d.tar.gz # downloading the software
tar xfvz stacks-2.3d.tar.gz                                               # decompressing the folder
cd stacks-2.3d                                                            # navigate into the folder
./configure
make
sudo make install
```

You might notice that here we used `sudo make install` instead of `make install`.
This means that to execute this command we need admin rights - no problem on your laptop, but on the cluster this is a no-go.
We'll talk about this later.

The (naive) way I like to picture the installation is by comparing it to building IKEA furniture:

- `./configure`: Your computer *reads the IKEA manual* and checks that is has all the tools needed to build the piece
- `make`: Your computer unpacks the pieces and *puts the closet together* (it is now standing in your workshop)
- `make install`: You put the closet into the bedroom (which is where you will be looking for your *cloths*)

The point with `make install` is that it puts the compiled software into one of the standard folders within your `$PATH` so that the computer can find it.
But since these folders are quite important the average user is not allowed to modify them - you need *admin rights* (`sudo ...`,*"become root"*) to do this.

As mentioned before , this is possible if you own the computer, but on the cluster this will not be the case.

The work-around is to create a custom folder that you *can acess* and to collect the manually installed software there instead.

Lets say your software folder is `/home/khench/software`.
This would change your installation procedure to the following:

```sh
./configure --prefix="/home/khench/software"
make
make install # no 'sudo' needed since I 'own' the target folder
```

This will place the compiled software into `/home/khench/software` or `/home/khench/software/bin`.
Our problem is only half solved at this point, since the computer still does not find the software.
Assuming the program is called `new_program`, running `which new_program` will still return a blank line at this point.

Therefore, we need to add `/home/khench/software` & `/home/khench/software/bin` to our `$PATH`.
To do this we add the following line to our bash start-up script (`$HOME/.bashrc` or `$HOME/.bash_profile`):

```sh
export PATH=$PATH:/home/khench/software:/home/khench/software/bin
```

We append the existing `$PATH` with our two custom directories.
Note that the start-up script is a *start-up* script - the changes will come into effect once we restart the terminal but they will not effect the running session.
To update the current session we need to run the start-up script manually (`source $HOME/.bashrc` or `source $HOME/.bash_profile`).

At this point the following should work:

```sh
which new_program
#> /home/khench/software/bin/new_program
```

I usually like to double check that the program will open properly by calling the program help after installing.

```sh
new_program -help
#> Program: new_program (Program for demonstation purposes)
#> Version: 0.1.2
#> 
#> Usage:   new_program <options> input_file 
#> 
#> Options: -option1        program option 1
#>          -option2        program option 1
#>          -help           display this help text
```

If this does not produce an error but displays the help text, the program should generally work.

-------------------------

## Appendix (`sed` and `awk` examples)
<a name="end"></a>

A large portion of bioinformatics is dealing with plain text files.
The programs `sed` and `awk` are very powerful for this and can really help you working efficiently.
I sure you can do way more using these two commands if you dig into their manuals, but here is how I usually use them:

### `sed`

This is my go-to *search & replace* function.
I use it to reformat sample names from genotype files (<sampleid><species><population> -> <sampleid>), reformat variable within a bash pipeline, transform whitespaces ("\t" -> "\n"; " " -> "\t") and similar tasks:

#### Basics

The basic structure looks like `sed 's/pattern/replace/g' <input file>`.
Here the `s/` activates the *search & replace mode*, the `/pattern/` is the old content (*search*), the `/replace/` is the new content (*replace*) and the `/g` indicates that you want to replace *all occurences* (*globally*) of the patterns within every line of the text.
In contrast  `sed 's/pattern/replace/'` would only replace the first occurrence of the pattern within each line.


```bash
cat data/table1.txt
#> line1
#> line2
#> line3
```

```bash
sed 's/line/fancy new content\t/g' data/table1.txt
#> fancy new content	1
#> fancy new content	2
#> fancy new content	3
```

In cases where you need to replace a slash ("/") you can use a different delimiter.
The following commands are equivalent and I believe there are many more options:

- `s/pattern/replace/g`
- `s=pattern=replace=g`
- `s#pattern#replace#g`

You can also replace several patterns in one command (one after the other) by separating them with a semicolon (`sed 's/pattern1/replace1/g; s/pattern2/replace2/g'`). 

When using `sed` in a bash pipeline is looks like this:


```bash
echo -e "sequence1:\tATGCATAGACATA" | \
sed 's/^/>/; s/:\t/\n/' |
gzip > data/test.fa.gz

zcat data/test.fa.gz & rm data/test.fa.gz
#> >sequence1
#> ATGCATAGACATA
```

Generally (also eg. when using `grep`), there are two important special characters:

- `^`: the *start* of a line 
- `$`: the *end* of a line

So, in the example above (`sed 's/^/>/'`) we introduced a ">" at the start of each line (before crating *new* lines by introducing a line break `\n`)

#### Wildcards

So far we have *replaced* patterns in a destructive manner.
By this I mean that after using `sed` the pattern is *replaced* and thus gone.
But sometimes you don't want to *delete* the pattern you are looking for but to merely *modify* it.
Of course you could argue that all you need to do is to write eg:


```bash
echo -e "pattern1234 & pattern3412 & pattern1643" | \
sed 's/pattern/pattern replace/g'
#> pattern replace1234 & pattern replace3412 & pattern replace1643
```

But this only works when we know *exactly* what we are looking for.
To be more precise so far we did not really do `s/pattern/replace/g` but more something like `s/name/replace/g`.
By this I mean that we searched for an exact string (what I call a *name*), while a *pattern* can be more ambiguous by using *wildcards* and *regular expressions* (`.*`,`[123]` ,`[0-9]`, `[0-9]*`, `[A-Z]*`,`[a-z]*`):

We could for example replace all (lowercase) words followed the combination of numbers starting with "1":


```bash
echo -e "word1234 & name3412 & string1643 & strinG1643" | \
sed 's/[a-z][a-z]*1[0-9]*/---/g'
#> --- & name3412 & --- & strinG1643
```

#### Modifying matches

Now in this case, we *don't* know the exact string that we are going to replace - we only know the *pattern*.
So if we want to modify but avoid deleting it we need a different method to capture the detected pattern.
To do this we fragment the search pattern using `\(pattern\)` or  `\(pat\)\(tern\)`.
The patterns declared like `s/\(pattern\)/` will still be found just like in `s/pattern/`, but now we can access the matched pattern using `\1` (*pattern*) or `\1` (*pat*) & `\2` (*tern*) in the replace section:


```bash
echo -e "word1234 & name3412 & string1643 & strinG1643" | \
sed 's/\([a-z][a-z]*\)1\([0-9]*\)/\1-->1\2/g'
#> word-->1234 & name3412 & string-->1643 & strinG1643
```

### `awk`

I feel like `awk` is more like its own programming language than just a unix command - it can be super useful.
I usually use it when *"I need to work with columns"* within a bash pipeline.
This could be eg. add in two columns or add a string to a column based on a condition.
I'm afraid this is almost an insult to the program because I sure you can do waaay cooler things that this - alas, so far I could not get past [RTFM](https://en.wikipedia.org/wiki/RTFM).

#### Basics

The basic structure of `awk` looks like:

```sh
awk <definig variables> 'condition {action} condition {action}...' input_file
```

The most simple (and useless) version is to emulate `cat`:


```bash
awk '{print}' data/table2.txt
#> A	1
#> B	2
#> C	3
```

The first thing to know about `awk` is how to address the individual columns.
By default `awk` uses any whitespace (`" "` & `"\t"`) as column delimiter.
`$0` is the whole line, `$1` is the first column, `$2` is the second ...

Reading a `"\t"` delimited table:

```bash
awk '{print $2}' data/table2.txt
#> 1
#> 2
#> 3
```


```bash
awk '{print $2"-input-"$1}' data/table2.txt
#> 1-input-A
#> 2-input-B
#> 3-input-C
```

Space `" "` is also delimiter:

```bash
sed 's/^/new_first_column /' data/table2.txt | \
awk '{print $2"-input-"$1}'
#> A-input-new_first_column
#> B-input-new_first_column
#> C-input-new_first_column
```

#### Conditions

The second thing to know is how to add a condition to a action:


```bash
awk '$2 >= 2 {print}' data/table2.txt
#> B	2
#> C	3
```

Combining conditions with logical *and*:

```bash
awk '$2 >= 2 && $1 == "C" {print}' data/table2.txt
#> C	3
```

Combining conditions with logical *or*:

```bash
awk '$2 >= 2 || $1 == "A" {print}' data/table2.txt
#> A	1
#> B	2
#> C	3
```

Different actions for different cases:

```bash
awk '$2 < 2 {print $1"\t"$2*-1} $2 >= 2 {print $1"\t"$2*10}' data/table2.txt
#> A	-1
#> B	20
#> C	30
```


```bash
awk '$2 < 2 {print $0"\tFAIL"} $2 >= 2 {print $0"\tPASS"}' data/table2.txt
#> A	1	FAIL
#> B	2	PASS
#> C	3	PASS
```

In `awk`, `"NR"` stands for the *row number* and `"NF"` stands for the *numbers of fields* (columns) within that row:


```bash
echo -e "1\n1 2\n1 2 3\n1 2 3 4\n1 2 3" | \
awk 'NR > 2 {print NF}'
#> 3
#> 4
#> 3
```

#### Variables

One to be aware of is the use of variables within `awk`.
You might have noticed that the columns within `awk` look like bash variables ( eg. `$1`).
But if you try to use a bash variable within `awk` this will fail:


```bash
echo "test" | \
awk '{print $HOME"--"$1}'
#> test--test
```

This is not what we expected - that would have been:


```bash
echo "$HOME--test"
#> /home/khench--test
```

The issue here is the use of different quotation marks (single `''` vs. double `""`).
In short - the `awk` command needs to be wrapped in single quotes, but within these, bash variables don't work:


```bash
echo '$HOME'
#> $HOME
```

vs.


```bash
echo "$HOME"
#> /home/khench
```

To get around this we can pass the variable to `awk` *before* the use of the single quotes:


```bash
echo "test" | \
awk -v h=$HOME '{print h"--"$1}'
#> /home/khench--test
```

Basically you can store anything within a `awk` variable and use it within `awk`:


```bash
awk -v x=9 -v y="bla" '$2 < 2 {print $0"\t"x} $2 >= 2 {print $0"\t"y}' data/table2.txt
#> A	1	9
#> B	2	bla
#> C	3	bla
```

One special `awk` variable is "OFS".
This is the field delimiter and it can be set like any other variable.
The following two examples are equivalent (but one is way easier to read/write).


```bash
echo "A" | \
awk '{print $1"\t"$1"_second_column\tmore_content\t"$1"_last_column"}'
#> A	A_second_column	more_content	A_last_column
```


```bash
echo "A" | \
awk -v OFS="\t" '{print $1,$1"_second_column","more_content",$1"_last_column"}'
#> A	A_second_column	more_content	A_last_column
```

### Bash one-liners

By combining the programs `awk`, `cat`, `cut`, `grep` and `sed` using the pipe `|` you can build quite concise and specific commands (*one-liners*) to deal with properly formatted data.
Over the years I collected some combinations that I regularly use to deal with different types of bioinformatic data.
You can find them together with some more useful bash examples within the `oneliners.md` file in the [source repository of this document](https://github.com/k-hench/getting_stuff_done/blob/master/oneliners.md).

--------
