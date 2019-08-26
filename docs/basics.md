---
output: html_document
editor_options:
  chunk_output_type: console
---

# Basic setup

## Organization

Generally, I like to keep stuff together if it is used within the same project.
This means that I recommend to create *one* project folder for each of your projects.
I call this folder the *root folder* of the projects.
This folder will later be equivalent to the git repository and the RStudio projects.

Keeping everything needed for the analysis within a single folder has the advantage that you can easily share you work once your project is done.
This makes it easy to include your actual analysis within your paper/ report.
My personal standard is to (try to) provide all information needed to recreate my studies *from raw data to the final figures*.

This asks for more than a loose collection of programming scripts: Apart from the scripts you ran, people need to know what to run *when and where*.
At least for me, it is usually quite hard even to recall the exact order of my own scripts needed for a complex data analysis (eg. the genotyping process of sequencing data) when I come back half a year later (trying to put together the final version of the methods for a publication).
So for someone else it is basically impossible to know how to combine the individual steps of your analysis unless you *really* make an effort to help them.

A first step to make your analysis better understandable is to have a clear structure for your files - having a single project folder is the first step.
So, my projects usually look something like this:

```
root_folder
├── analysist.nf          # The nextflow pipeline with the project
├── analysis.Rproj        # The RStudio project for the project
├── data                  # Folder containing the raw input data
├── docs                  # Folder containing the documentation of the project
├── .git                  # The housekeeping folder of git
├── .gitignore            # List with files that git ignores
├── nextflow.config       # nextflow configuration of the project
├── py                    # Folder containing the python scripts used during analysis
├── R                     # Folder containing the R scripts used during analysis
├── README.md             # Basic readme for the project
└── sh                    # Folder containing the bash scripts used during analysis
```
## Tools

When it comes to the working environment many decisions are ultimately a question of personal taste.
Nevertheless, in the following I want to recommend three main pillars of my working environment that I think are essential for bioinformatics.

### The command line

![](img/cl.svg)

If you're doing bioinformatics you *will* need to use *the command line* - this is where all the interesting stuff happens.
Many programs that are commonly used can only be run from *the command line*.
And if you want to do serious computations using a computer cluster this requires that you use *the command line*.

When using the command line, you simply change the way you communicate with your computer:
The basic idea here is to replace your mouse with your keyboard - instead of clicking things you write commands.
Yet there are many things that you can do both using the command line or the mouse (eg. creating/ managing folders & files), so the need to write down everything into a "black box" might seem a little tedious at first. Still, we use the command line because there are some things that you can only do there. A second huge benefit is that you can protocol everything you do.

#### Linux/ Mac

If your OS happens to be [Mac](https://support.apple.com/en-ca/guide/terminal/welcome/mac) or Linux ([Ubuntu](https://www.ubuntubeginner.com/ubuntu-terminal-basics/)) you are lucky when it comes to the command line since the command line is a native unix environment. So all you have to do is to look for the *Terminal* within you preinstalled programs and open it.

Yet on Mac you will need to install [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12) to unlock the full potential of the command line.
This is quite big and might take some time - sorry...

#### Windows

Unfortunately, Windows does not come with a (bash-) Terminal out of the box.
So if you are using Windows, you will need to install [Cygwin](https://cygwin.com/) to be able to use all the tools of the command line.

Beware that Cygwin will only be able to access a sub directory of you file system - your project folder should be placed within that directory.


In such a case (as in most programming related issues) [google](https://www.google.com)/[duckduckgo](https://duckduckgo.com) is your friend....

### Atom (Text editor/ project manager)

To manage your project I recommend using [**Atom**](https://atom.io/).
This is where I keep track of the entire project, write the pipelines for my analysis, communicate with [github](https://github.com/) - in short this my main working environment.
It is cross-platform (Linux/Mac/Windows), integrates git and has a ton of extensions so you can basically puzzle together all the functions you could ever ask for.

Yet, I also use gedit (the native text editor) for *quick and dirty* work and a simple text editor (Mac: textedit, Windows: Notepad) has its value.
Sometimes Atom is simply an overkill.

### RStudio

By now I think **R** and [**RStudio**](https://www.rstudio.com/) are almost synonymous for most users.
In my opinion there is no reason not to use Rstudio to develop your R scripts.

That said, I view RStudio as a workshop.
I use it when I want to work with R *interactively* - that is for data exploration or to *devellop* R scripts.
My ultimate goal for *shareable*/*reproducible* content (eg. scripts for figures in publications) are standalone R scripts.
These are executable from the command line and run from start to end without interactive fiddling, eg:

```sh
Rscript --vanilla script.R
or
Rscript --vanilla script.R input_file.txt output_figure.pdf
```

So much for now, we're going to talk more about R later....

### Disclaimer

I happen to use Ubuntu on my Laptop and sometimes there are minor differences between commands run under Linux/Mac/Windows.
If you encounter weird error this might be the source of the problem.
I ran into issues eg. when using `awk` or `sed` - we will talk about these later.

Also, due to my educational history you will find this tutorial to be quite **R**-centric.
This mostly reflects my own skill set and so, many helpful tools especially in the **python** world are not covered here.

--------
