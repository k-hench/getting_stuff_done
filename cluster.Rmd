---
output: html_document
editor_options:
  chunk_output_type: console
---

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
- `ssh` should allready be installed (check `which ssh` in the command line)
- an internet connection (and access to either the Uni or the GEOMAR network)
- (`sshfs` for mounting the cluster)

So, I recommend to check at this point that you check if you have `sshfs` installed - I guess not.
If `which sshfs` returns a path (eg: `/usr/bin/ssh`) your all set, if it returns a blank line you need to install the program:

**Ubuntu**:  
```sh
sudo apt-get install sshfs
```

**Mac**:  
You'll need to download and install two packages ([osxfuse](https://osxfuse.github.io/) and the current version of [sshfs-x.x.x.pkg](https://github.com/osxfuse/sshfs/releases))

**Windows**  
Honestly, I don't know.
But [these instuctions](https://github.com/billziss-gh/sshfs-win) look like they should work. Good luck...

Now if you double check `which sshfs` should return a path.


## Login

As mentioned before to use the cluster you need the command line.
So to log in, open the terminal and t

### File system

## Mounting

## Working

### Software 

- Modules
- conda

### Batch scripts

- concept

- types
- scrip structure
- submit & mointor
  - qsub
  - qcat -e/-o
  - qdel
  - watch
  - screen (email)


