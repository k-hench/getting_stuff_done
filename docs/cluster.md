---
output: html_document
editor_options:
  chunk_output_type: console
---


```
## ── Attaching packages ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse 1.2.1 ──
```

```
## ✔ ggplot2 3.1.0.9000     ✔ purrr   0.3.0     
## ✔ tibble  2.0.1          ✔ dplyr   0.7.8     
## ✔ tidyr   0.8.2          ✔ stringr 1.4.0     
## ✔ readr   1.3.1          ✔ forcats 0.3.0
```

```
## ── Conflicts ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
## ✖ dplyr::filter() masks stats::filter()
## ✖ dplyr::lag()    masks stats::lag()
```

# Cluster

--------
<center>
*This Chapter is very much tailored to the [NEC computer cluster of the University Kiel (Germany)](https://www.rz.uni-kiel.de/en/our-portfolio/hiperf/nec-linux-cluster?set_language=en) operation on the batch system ([NQSII](https://wickie.hlrs.de/platforms/index.php/NEC_SX-ACE_Batch_System)).*
*On any other cluster, things are going to be differet - talk to your IT department...*
</center>
--------
At this point we are going to talk about how to work on the computer cluster (of the University Kiel).
Usually, we want to work there because:

<center>
We have to deal with **LOTS** of data and this would kill our laptop  
or  
We have to run a job for **VERY LONG** (and we need the laptop for a presentation that's due tomorrow...)  
or  
We have **MANY** jobs and running the on after the other would take ages  
</center>

So the cluster is capable of doing *many* *work heavy* jobs *for a long time*.
But to use it we need:

- an account on the cluster (+ password) - lets assume it is smomw000 for now
- `ssh` should already be installed (check `which ssh` in the command line)
- an internet connection (and access to either the Uni or the GEOMAR network)
- (`sshfs` for mounting the cluster)

So, I recommend to check at this point that you check if you have `sshfs` installed - I guess not.
If `which sshfs` returns a path (eg: `/usr/bin/ssh`) your all set, if it returns a blank line you need to install the program:

- **Ubuntu**: `sudo apt-get install sshfs`
- **Mac**: You'll need to download and install two packages ([osxfuse](https://osxfuse.github.io/) and the current version of [sshfs-x.x.x.pkg](https://github.com/osxfuse/sshfs/releases))
- **Windows**: Honestly, I don't know.
But [these instuctions](https://github.com/billziss-gh/sshfs-win) look like they should work. Good luck...

Now if you double check `which sshfs` should return a path.

## Login

As mentioned before to use the cluster you need the command line - all the work on the cluster is going to happen there.
The log in command looks like this:

```sh
# ssh <username>@<hostadress>
ssh smomw000@nesh-fe.rz.uni-kiel.de
```

When you log in for the first time, you will be asked to confirm that this is a secure connection.  
Then you will need to type in you password and that's basically it:

<div class="kclass cluster">
```
Last login: Fri Mar  8 20:54:44 2019 from XXX.XXX.XXX.XXX
*****************************************************************************************
*                   Welcome to the hybrid NEC HPC-system at RZ CAU Kiel                 *
*                                                                                       *
* Documentation:                                                                        *
* SX-ACE vector system: https://www.rz.uni-kiel.de/de/angebote/hiperf/nec-sx-ace        *
* Linux-Cluster:        https://www.rz.uni-kiel.de/de/angebote/hiperf/nec-linux-cluster *
*                                                                                       *
* Support:              mailto:hpcsupport@rz.uni-kiel.de                                *
*****************************************************************************************
* Your current quota on $WORK=/sfs/fs2/work-geomar7/smomw000:                           *
*                   [used] |       [soft] |       [hard] |     [grace period]           *
* disk space:        x.xxT |        x.xxT |        x.xxT |          none [-1]           *
* inodes:            xxxxx |        xxxxx |       xxxxxx |          none [-1]           *
*****************************************************************************************
$ |
```
<center>
*(As a convention I will use black code blocks when talking about the cluster.*
*The code blocks you are used to will continue to refer to the command line on your laptop.)*
</center>

Now you are on the cluster and you can work just the same as on the command line on your local machine.  
If you want to leave the cluster, all you need to do is type `exit`.
</div>

At this point it is probably a good idea to look at the [documentation](https://www.rz.uni-kiel.de/en/our-portfolio/hiperf/nec-linux-cluster?set_language=en) of the cluster by the HPC-Support team if you have not done so already.

Most of what I will cover below is actually described there in more depth and up to date (and by people who actually know the system way better).

### File system
<div class="cluster">
You should be aware that on the cluster you have access to several directories:

- `$HOME`: `/sfs/fs6/home-geomar/smomw000`
- `$WORK`: `/sfs/fs2/work-geomar7/smomw000`
- `$TAPE_CACHE`: `/nfs/tape_cache/smomw000`

The different directories differ in way they are backuped and by the amount of space you can use.
They should be used for different tasks: 

In the `$HOME` are mostly things that you need to *configure* your account.
On example is the start up script for your cluster account (`.bashrc`).
You might collect configuration content for other programs there as well (eg. `R`,`py` or `miniconda2`).
It should not be used to store large amounts of data or to actually do work there.

The `$WORK` directory is where you will spend your time.
Here you can store your data and do the *heavy lifting* run your projects.
It is also the only directory where you should run [batch jobs](#batch).

When you are done with a project and don't need to access your file regularly anymore you can store them on `$TAPE_CACHE`.
This basically the *archive*.  
You should prepare your data into neat packages (don't just dump you messy folders with a huge collection of loose scripts here - pack the collection into a single `tar` file first: `tar -zcvf messy_folder.tar.gz messy_folder`). Pleas read the recommendations within the cluster [documentation](https://www.rz.uni-kiel.de/en/our-portfolio/hiperf/nec-linux-cluster?set_language=en).
</div>

## Mounting

One of the first things you might ask yourself is how to get you data onto the cluster.
For this purpose we installed `shhfs` at the beginning of this chapter.

I like to think of the usage of `shhfs` like plugging in a flash drive.
But before we can use it, we need create an empty folder:

```sh
mkdir ${HOME}/mnt # Remember: This is on your local machine.
```
<div class="cluster">
This out virtual *USB slot* - after mounting the cluster the files of the cluster are going to show up here on your laptop.

We also need to think about which directory of the cluster we want to mount.
By default the `$HOME` directory of the user will be mounted.
But as mentioned above, that's not were we are supposed to dump our data.
Also, once we have mounted a directory we will not be able to go *up in the path*. 
That means we will not be able to access `/sfs/fs6/home-geomar/` when mounting `/sfs/fs6/home-geomar/smomw000`.
Because of this, we will need to mount the `$WORK` directory directly:
</div>
```sh
# sshfs <username>@<hostadress>:</path/on/cluster> <local/path>
sshfs smomw000@nesh-fe.rz.uni-kiel.de:/sfs/fs2/work-geomar7/smomw000 $HOME/mnt
```
<div class="cluster">
Now, the content of your `$WORK` directory should show up in your finder/windows explorer.
</div>
You can now copy data either by *copy & paste* in your finder, or using `cp large_data_file.vcf.gz $HOME/mnt`.

To unmount the you can try to *eject* it (similar to a Flash drive) or type `fusermount -u ~/mnt`.

## Working

Working on the cluster is generally not different to working ton the command line locally.

### Software

The one exception to this is when you need new software that is not installed.
That is because you do not have admin rights on the cluster - this makes installing new software harder (s. [3.7. Installing new software](#3.7)).

<div class="cluster">
Luckily, there is more stuff installed than you might realize at first - it is just not activated yet.
To see whats available run `module avail`:
```
------------------------------ /sfs/fs5/sw/modules/sxcrosscompiling ------------------------------
MathKeisan/4.0.3(default) fview                     sxf03/rev061(default)
crosscompiler             mpisx/10.2.4(default)     sxf90/rev534(default)
crosscompiler.nec         netcdf_4.1.1_sx
crosskit/r211(default)    sxc++/rev112(default)

-------------------------------- /sfs/fs5/sw/modules/x86compilers --------------------------------
gcc5.3.0       intel16.0.4    intelmpi16.0.4 java1.8.0      llvm6.0.0
gcc7.2.0       intel17.0.4    intelmpi17.0.4 llvm4.0.1

-------------------------------- /sfs/fs5/sw/modules/x86libraries --------------------------------
boost1.65.0              hdf5-1.8.19intel         pcre2-10.21
curl7.55.1               hdf5parallel-1.8.19      pcre8.41
eigen3.3.4               hdf5parallelintel-1.8.19 pnetcdf1.8.1
fftw3.3.6                jags4.3.0                pnetcdf1.8.1intel
fftw3.3.6intel           lapack3.8.0              proj4.9.3
gdal2.2.3                ncurses6.0               readline7.0
geos3.6.2                netcdf4.4.1              szip2.1.1
glib2.52.3               netcdf4.4.1intel         udunits2.2.25
gsl2.4                   netcdf4.4.1paraintel     xz5.2.3
hdf5-1.8.19              openssl1.0.2             zlib1.2.11

-------------------------------- /sfs/fs5/sw/modules/x86software ---------------------------------
R3.4.1                 espresso5.4.0          matlab2015a_geomar     petsc3.6.1intel-debug
R3.5.1                 espresso6.2.1          matlab2017a            petsc3.7.6
R3.5.2                 espresso6.2plumed      matlab2017a_geomar     petsc3.7.6-debug
abaqus2018             fastqpair12.2017       matlab2018b            petsc3.7.6intel
adf2017.110            ferret6.72             matlab2018b_geomar     petsc3.7.6intel-debug
adf2017.110intel       ferret6.82             megahit1.1.3           plumed2.4.0
allpathslg52488        ferret7.2              metawrap1.0.2          plumed2.4.0intel
amos3.1.0              ferret7.4test          molpro2015             pyferret7.4.3
beat1.0                fomosto-qssp2017       mothur1.39.5           python2.7.13
blender2.79            g09d01                 mothur1.40.0           python3.6.2
blender2.79a           g16a03                 mummer3.23             salmon0.12.0
blender2.79b           glpk4.61               nciplot3.0             samtools1.5
bowtie2-2.3.3          gmt5.4.2               ncl6.4.0               spades3.12.0
bwa0.7.17              gnuplot5.0.7           nco4.6.8               specfem3d3.0
cactus7.2018           grace5.1.9             ncview1.2.7            specfem3d3.0mpi
cdo1.9.0               grib_api1.23.1         octave4.2.1            star2.6.0a
comsol5.3a-tetra       hail0.2                octopus7.1             transrate1.0.3
comsol5.4-tetra        interproscan5.30-69.0  openmolcas4.2017       turbomole7.2
comsol5.4s-tetra       jasper2.0.14           openmolcas4.2017serial turbomole7.2mpi
cp2k5.1                lammps17               perl5.26.0             turbomole7.2smp
cplex                  matlab2011b_geomar     perl5.26.0threads
cufflinks2.2.1         matlab2015a            petsc3.6.1intel

---------------------------------- /sfs/fs5/sw/modules/x86tools ----------------------------------
bzip2-1.0.6  cmake3.9.1   imake1.0.7   mc4.8.19     parallel     use.own
cmake3.12.1  git2.14.1    libtool2.4.6 miniconda3   sensors3.4.0
```

You can activate these *modules* by running eg. `module load R3.5.2` (and later deactivate it with `module unload R3.5.2`).

If you look at the very end of the list you will find `miniconda3`.
</div>

This is quite a relief because this means you should be able to use conda as package manager to install most of the software you need (especially when coupled with [bioconda](https://bioconda.github.io/)).
(*Unfortunately conda apears to be suuuper slow lately. This is annoying but is still works. And I think in most cases it is still way faster than installing all dependencies of your software by hand.*)

If the software is not part of the *modules* and if you can't find it using conda you will have to install it manually. Sorry.

### Batch scripts
<a name="batch"></a>

I like to think of the cluster as a kind of hotel - the cluster is a *collection of many computers* like a hotel is a collection of many rooms.
Yet when you enter the hotel, you don't walk into a room directly but you enter the *lobby*.
On the cluster it is the same: When you log in using `ssh` you are on the login node (the *"front end"*).
Here you are not alone, but all users of the cluster share it simultaneously.

It is totally fine to hang out in the lobby as long as don't block it with 15 busloads of luggage.

This is supposed to mean that, while you can organize you files on the login node and also to try small paths, as soon as you start to work *seriously* you should use *batch jobs* (*rent one/several rooms*).

### Preparation

Running a batch job is easy.
Instead of running commands interactively, you write them into a script and add a small header.
This has the additional benefit that later you will remember exactly what you have done.

So instead of this:
<div class="cluster">
```sh
cd $WORK
mkdir test_folder
echo "test" > test_folder/test.txt
```
</div>

We write this script (`test.sh`):
```sh
#!/bin/bash
#PBS -b 1                       # number of threads
#PBS -l cpunum_job=1            # number of nodes
#PBS -l elapstim_req=00:00:30   # requested runtime (hh:mm:ss)
#PBS -l memsz_job=1gb           # requested memory
#PBS -N testjob                 # job name
#PBS -o stdstderr.out           # file for standard-output 
#PBS -j o                       # join stdout/stderr
#PBS -q clexpress               # requested batch class

cd $WORK
mkdir test_folder
echo "test" > test_folder/test.txt
```
<div class="cluster">
You can write this script either using one of the command line text editors (`emacs`/`nano`/`vim`) or you can prepare it locally (eg. within **atom**) and copy it onto the mounted cluster.

Once the script is located on the cluster (eg. on `$WORK`) you can *submit* the job:
```sh
cd $WORK
qsub test.sh
```
</div>

Depending on the resources needed for the job you submit, you will choose a different *batch class*:


Batch class    max. runtime   cores per node   max. memory   max. nodes
------------  -------------  ---------------  ------------  -----------
clexpress           2 hours               32        192 GB            2
clmedium           48 hours               32        192 GB          120
cllong            100 hours               32        192 GB           50
clbigmem          200 hours               32        384 GB            8
clfo2             200 hours               24        128 GB           18
feque                1 hour               32        750 GB            1

### Monitor batch jobs
<div class="kclass cluster">

After submitting a batch job you might be interested in its current status.
You can get a summary of all your currently queuing and running jobs using `qstat`:

```
RequestID       ReqName  UserName Queue     Pri STT S   Memory      CPU   Elapse R H M Jobs
--------------- -------- -------- -------- ---- --- - -------- -------- -------- - - - ----
000000.ace-ssio test     smomw000 clexpress   0 RUN -   00.13G   122.70        1 Y Y Y    1 
```

If you want to see what is going on on the entire cluster you can run `qstatall` to see *all* currently queuing and running jobs.

I you want to get a peek into the latest output *within* the job you ca use:

- `qcat -e <jobid>`: the latest error messages (the *stderr* output)
- `qcat -o <jobid>`: the latest output messages (the *stdout* output)
- `qcat <jobid>`: the original script that was submitted

If you want to see more lines you can use the flag `-n`.
The `<jobid>` is the number before *".ace-ssio"*.
An example would be `qcat -n 25 -e 000000`.

If you are impatient (like me) you will find yourself retyping `qcat` over and over.
(*If you need to repeat a command use the `<arrow up>` key on your keyboard!*)
This can be tiresome. It is way easier to use the command `watch`.
The following line will re-execute `qcat` every 3 seconds until you interrupt it by pressing `<ctrl><c>`:

```sh
watch -n 3 "qstat -n 25 -e 000000"
```

Once your job is done you will find the file `stdstderr.out` within the directory where you submitted the original script (where you ran `qsub script.sh`).
</div>
--------
