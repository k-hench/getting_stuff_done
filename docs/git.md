---
output: html_document
editor_options:
  chunk_output_type: console
---

# Git

This chapter should actually simply read *"use [version control](https://en.wikipedia.org/wiki/Version_control)"*.
[*Git*](https://git-scm.com/book/en/v2/Getting-Started-About-Version-Control) just happens to be the most commonly used software to implement version control.
Again, I do not intend to write another redundant git tutorial but simply want to show how I currently use git.
(*Honestly, I'm still learning this myself and I'm sure peaple who actually know this stuff are likely to get a temper tantrum or a fit of laughter when reading this...*)

If you want to get a proper git introduction, please read the [manual](https://git-scm.com/doc) and/or do [an](https://git-scm.com/docs/gittutorial) [actual](https://www.tutorialspoint.com/git/index.htm) [tutorial](https://try.github.io/).

So, how do I integrate git into my work?
In the introduction I recommended to keep your whole project within a single folder.
We will now turn this folder into a *git repository*.
This means, we'll use **git** to keep track of the changes that happen within this project folder.
To do this, we will take *snapshots* of our project every time we feel like we made some progress.
Later, we will be able to come back to any time point of which we have a snapshot (it's a little like saving a computer game...).

## Get started

We are going back to our example project folder (`~/root_folder`) of the chapter 2.
All of the git commands have the structure `git [command] <options>`.
To turn the folder into a git repository we run:

```sh
cd ~/root_folder
git init
#> Initialized empty Git repository in /home/khench/root_folder/.git/
```

No, we can check the current status of the repository:

<div class="kclass">
```sh
git status
#> On branch master
#>
#> Initial commit
#>
#> Untracked files:
#>   (use "git add <file>..." to include in what will be committed)
#>
#>     .gitignore
#>     README.md
#>     analysis.Rproj
#>     analysis_twisst.nf
#>     data/
#>     nextflow.config
#>     sh/
```
</div>

You'll see that git is aware of all the files (empty folders are omitted) in the folder.
But at this stage the filed are not tracked yet.

## gitignore

At this point it makes sense to talk about why we need the file `.gitignore`.
As I mentioned before, the huge benefit of git is that it will enable us later to come back to previous versions of our project since we *save* snapshots throughout the development of the project.

Of course this means that all these versions (or at least the *changes* within the files) need to be stored at some place.
So basically we have to deal with a trade-of where we have to choose between tracking as much as possible keeping our repository at a manageable size.  
Luckily the most important files to keep track of (in my opinion) are also the smallest, while the largest files might actually be omitted without any issue.
That is because your actual work - the scripts that you develop for your analysis are small text files.
In contrast to this, you raw data might be huge - but it is static and does not necessarily need to be tracked.
You will very likely deposit this data anyways at an external data base like eg. [dryad](https://www.datadryad.org/), [SRA](https://www.ncbi.nlm.nih.gov/sra) or [ENA](https://www.ebi.ac.uk/ena).
And after all, the whole point of our efforts is to provide *reproducible scripts* to get to our *final results* starting with the *raw data*.

I therefore recommend to exclude the data folder from the list of files that git keeps track of.
We still want to keep them within the project folder because things get messy when you address directories outside the repository. Other people would not be able to recreate your file structure anymore.
Because of this we simply add the data folder to the `.gitignore` file (using a text editor).
This is basically a blacklist of files & directories that *"git ignores"*.

I want to do this at the very beginning to not have any traces of the huge files within the history of the repository.

`.gitignore` now looks like this:
```sh
cat .gitignore 
#> data
```

Now we first add the `.gitignore` to the tracked files and only add the rest later.
We need to have the `.gitignore` in effect first - otherwise the `data` folder will not be omitted:

<div class="kclass">
```sh
git add .gitignore
git status
#> On branch master
#> 
#> Initial commit
#> 
#> Changes to be committed:
#>   (use "git rm --cached <file>..." to unstage)
#> 
#> 	new file:   .gitignore
#> 
#> Untracked files:
#>   (use "git add <file>..." to include in what will be committed)
#> 
#> 	README.md
#> 	analysis.Rproj
#> 	analysis_twisst.nf
#> 	nextflow.config
#> 	sh/
```
</div>

So, now the changes in `.gitignore` are *staged for a commit* - the file is ready for a snapshot.
To save this snapshot we run:

<div class="kclass">
```sh
git commit -m "init gitignore"
#> [master (root-commit) 575e91f] init gitignore
#>  1 file changed, 1 insertion(+)
#>  create mode 100644 .gitignore
git status 
#>  On branch master
#>  Untracked files:
#>    (use "git add <file>..." to include in what will be committed)
#>  
#>  	README.md
#>  	analysis.Rproj
#>  	analysis_twisst.nf
#>  	nextflow.config
#>  	sh/
#>  
#>  nothing added to commit but untracked files present (use "git add" to track)
```
</div>

Now we see two things:

- `.gitignore` does not show up in the `git status` report. There are no changes in this file since the last commit.
- The `data` folder does not show up in the `git status` report. Our `.gitignore` apears to be in effect.

So, at this point we can add and commit the rest of the files:

<div class="kclass">
```sh
git add .
git status
#> On branch master
#> Changes to be committed:
#>   (use "git reset HEAD <file>..." to unstage)
#> 
#> 	new file:   README.md
#> 	new file:   analysis.Rproj
#> 	new file:   analysis_twisst.nf
#> 	new file:   nextflow.config
#> 	new file:   sh/script.sh
git commit -m "init repo"
#> [master a9f87c1] init repo
#>  5 files changed, 6 insertions(+)
#>  create mode 100644 README.md
#>  create mode 100644 analysis.Rproj
#>  create mode 100644 analysis_twisst.nf
#>  create mode 100644 nextflow.config
#>  create mode 100644 sh/script.sh
git status
#> On branch master
#> nothing to commit, working directory clean
```
</div>

## Conecting to *github*

## Using git with Atom
