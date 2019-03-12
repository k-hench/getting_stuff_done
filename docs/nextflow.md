---
output: html_document
css: highlight.css
editor_options:
  chunk_output_type: console
---



# Nextflow

This is awesome!
[*Nextflow*](https://www.nextflow.io/index.html) provides a neat way to develop and structure the *entire workflow* of you analysis in a *single script*.
It makes a huge difference for one aspect I mentioned in Chapter 2:

*"Apart from the scripts you ran, people need to know what to run when and where."*
*"At least for me, it is usually quite hard even to recall the exact order of my own scripts needed for a complex data analysis [...] when I come back half a year later[...]."*

Apart from this using Nextflow can save you *a lot* of mindless typing when doing different versions of a similar analysis.
The drawback is that you need to get a basic Idea of yet another language (Nextflow is based on [*groovy*](https://en.wikipedia.org/wiki/Apache_Groovy)).

But the Nextflow [documentation](https://www.nextflow.io/docs/latest/index.html) is pretty good.
Reading through the manual took me quite some time but the time I saved since then more than compensated pretty quickly.
Also, if you have questions beyond what is covered in the manual, the help provided on [*gitter*](https://gitter.im/nextflow-io/nextflow) is amazing.
So far any question I asked there was solved within about 30 min!
(Of course it important not to spam the people there with unnecessary questions - so first: *RTFM*)

## Basics

The basic Idea of Nextflow is that it will connect different task that you do within *bash* (or any other scripting language) in an organized but dynamic manner.
It then manages your analysis for you (waiting for job *A* to finish before submitting job *B*) and can manage quite a lot of different cluster scheduling systems.
You can use it from the very beginning of your project since it is able to resume a previous run:
So if you first implement *job A* and then (while *job A*) is running write *job B* you can simply update your nextflow script.
If you then resume the run, nextflow will remember that it already ran *job A* and start with *job B* straight away.
This is also great if you later need to change a *middle part* of your analysis - nextflow will basically only rerun what is needed downstream from the the point that you changed.
This is super convenient.

To run a nextflow pipeline I usually prepare two scripts:

- `analysis.nf`: this is the actual pipeline 
- `nextflow.config`: this is the configuration script (important on the cluster, for small local test not so much)

### The pipeline script

The `analysis.nf` is where you put together you analysis.
For me, this means that it is basically a series interconnected *bash* snippets.

The nextflow script is build from three types of building blocks:

- *Processes*: the *bash* snippets that contain the code I would otherwise type into the terminal
- *Channels*: streams of files you put through you pipeline, or streams of parameter values you want vary within your analysis
- *Operators*: connect the different Processes and Channels using logic (linear, crosses), or modify a channel along the way (filtering, merging, sorting)

**Processes**

A nextflow process looks like this:

<div class="kclass">

<div class="sourceCode">
<pre class="sourceCode">
<code class="sourceCode"><span class="hl kwa">process</span> gather_depth <span class="hl opt">{</span>
	label <span class="hl str">&apos;L_loc_test_script&apos;</span>
	publishDir <span class="hl str">&quot;export_folder&quot;</span><span class="hl opt">,</span> mode<span class="hl kwe">:</span> <span class="hl str">&apos;copy&apos;</span>

	<span class="hl kwb">input</span><span class="hl kwe">:</span>
	<span class="hl kwd">set</span> <span class="hl kwc">val</span><span class="hl opt">(</span> input_val <span class="hl opt">),</span> <span class="hl kwc">file</span><span class="hl opt">(</span> input_file <span class="hl opt">)</span> <span class="hl kwd">from</span> input_channel

	<span class="hl kwb">output</span><span class="hl kwe">:</span>
	<span class="hl kwc">file</span><span class="hl opt">(</span> <span class="hl str">&quot;${input_val}.txt&quot;</span> <span class="hl opt">)</span> <span class="hl kwd">into</span> output_channel
	
	<span class="hl kwb">script</span><span class="hl kwe">:</span>
	<span class="hl str">&quot;&quot;</span><span class="hl str">&quot;</span>
<span class="hl str">	 sed &apos;s/X-TAG-X/${input_val}/g&apos; ${input_file} &gt; ${input_val}.txt</span>
<span class="hl str">   cat \$HOME/signature.txt &gt;&gt; ${input_val}.txt</span>
<span class="hl str">	 &quot;</span><span class="hl str">&quot;&quot;</span>
<span class="hl opt">}</span>
</code>
</pre>
</div>

This breaks down into different compartments: 


<div class="sourceCode">
<pre class="sourceCode">
<code class="sourceCode"><span class="hl kwa">process</span> <span class="hl com">/* &lt;process_name&gt; */</span> <span class="hl opt">{</span>
	<span class="hl com">/* &lt;config section&gt; */</span>

	<span class="hl kwb">input</span><span class="hl kwe">:</span>
	<span class="hl com">/* &lt;input channel&gt; */</span>

	<span class="hl kwb">output</span><span class="hl kwe">:</span>
	<span class="hl com">/* &lt;output channel&gt; */</span>
	
	<span class="hl kwb">script</span><span class="hl kwe">:</span> <span class="hl com">/* &lt;task&gt; */</span>
	<span class="hl str">&quot;&quot;</span><span class="hl str">&quot;</span>
<span class="hl str">    # some bash code</span>
<span class="hl str">    &quot;</span><span class="hl str">&quot;&quot;</span>
<span class="hl opt">}</span>
</code>
</pre>
</div>

In the **config section** we can assign the process to a label (to use specific config settings defined in `nextflow.config`).
Here we can also specify if we want to collect the output of the script outside of the `work` folder which is used by nextflow for the execution of the code.
You can also activate conda environments or load modules for this process here.

The **input** and **output** sections are used to connect the individual processes and to manage the flow of files and values from process to process.

The **script** section contains the actual code to run.
Here, you write the actual bash code of the pipeline.

Careful when using bash variables (eg `$WORK`) within nextflow.
Nextflow itself uses the dollar sign (`$`) to assign its own variables (eg `${input_val}`) in the example scripts.
These are evaluated before the scripts is run and replaced by the appropriate file/value.
If you want to use bash variables that are supposed to be evaluated when the script is actually run, you need to conserve the dollar sign by *escaping* the dollar sign (`cat \$HOME/signature.txt` instead of `cat $HOME/signature.txt`).  

**Channels**  

These are the streams of *files* or *values*.
One channel could be eg. all the sequencing files you need to process, while another one could be all the values of an input parameter of of a model that you wish to test for different input settings.

Channels connect the different processes and Nextflow basically follows development of the stating channels during the development through the different steps of your pipeline.
You feed a channel into a process in the *input* section, while the *output* section emits a new channel.
</div>


At the start of your pipeline you will need to define some channels like this:


<div class="sourceCode">
<pre class="sourceCode">
<code class="sourceCode"><span class="hl kwa">Channel</span>.from<span class="hl opt">(</span> <span class="hl str">&apos;A&apos;</span> <span class="hl str">&apos;B&apos;</span> <span class="hl str">&apos;C&apos;</span> <span class="hl opt">)</span>
<span class="hl kwa">Channel</span>.from<span class="hl opt">( (</span><span class="hl str">&apos;01&apos;</span>..<span class="hl str">&apos;09&apos;</span><span class="hl opt">) + (</span><span class="hl str">&apos;10&apos;</span>..<span class="hl str">&apos;19&apos;</span><span class="hl opt">))</span>
<span class="hl kwa">Channel</span>.fromPath<span class="hl opt">(</span> <span class="hl str">&apos;genotypes.vcf.gz&apos;</span> <span class="hl opt">)</span>
<span class="hl kwa">Channel</span>.fromPath<span class="hl opt">(</span> <span class="hl str">&apos;sequencing_data/*.fq.gz&apos;</span> <span class="hl opt">)</span>
</code>
</pre>
</div>

**Operators**  

Operators contain the *actions/logic* that connects different elements of your pipeline.
You can use them to modify your channels by exposing them to filtering, transfomiations, splitting, merging.
We allready saw two operators in the example above (`.from()` & `.fromPath()`).
So you can see that the have form of *dot*-*name()* (or *dot*-*name{}* ).

Operators (besides `.from()`, `.fromPath()` $ `.fromFilePairs()`) I frequently use are:

<div class="row kclass"><div class="column">
- `.splitCsv()`: read csv (combined variables)
- `.set{}`: channel name (single copy)
- `.into{}`: channel name (multiple copys)
- `.map{}`: transform channel content
</div><div class="column">
- `.collect()`: collapse the channel
- `.combine()`: cross of two channels
- `.join()`: merge two channels (sorted)
- `.groupTuple()`: collapse the channel (sorted)
</div></div>

## A quick example

I want to create a quick example of the power of nextflow.
Therefore lets assume we have to do a analysis where we have a set of populations that need to be compared pairewise (eg. calculate pairwise *F<sub>ST</sub>* along the genome).
After this you want to do a running average using different window sizes.

*I will use dummy commands here to show the workings of nextflow rather than doing an meaningful analysis*:

```sh
cd ~/root_folder
echo "I am the input data" > data_file.txt
```

The beauty of nextflow is that you basically just have to write the script for a single case.
(You can check the complete nextflow on the [demo_root_folder reopsitory](https://github.com/k-hench/demo_root_folder))
First we initialize the different *Channels* within our pipeline script.

<div class="kclass">

<div class="sourceCode">
<pre class="sourceCode">
<code class="sourceCode"><span class="hl kwa">Channel</span>
	.fromPath<span class="hl opt">(</span><span class="hl str">&quot;data_file.txt&quot;</span><span class="hl opt">)</span>
	.set<span class="hl opt">{</span> data_channel <span class="hl opt">}</span>

<span class="hl kwa">Channel</span>
	.from<span class="hl opt">( [[</span><span class="hl num">1</span><span class="hl opt">,</span> <span class="hl str">&quot;popA&quot;</span><span class="hl opt">], [</span><span class="hl num">2</span><span class="hl opt">,</span> <span class="hl str">&quot;popB&quot;</span><span class="hl opt">], [</span><span class="hl num">3</span><span class="hl opt">,</span> <span class="hl str">&quot;popC&quot;</span><span class="hl opt">]] )</span>
	.into<span class="hl opt">{</span> pop_channel1<span class="hl kwe">;</span> pop_channel2 <span class="hl opt">}</span>

<span class="hl kwa">Channel</span>
	.from<span class="hl opt">(</span> <span class="hl str">&quot;10kb&quot;</span> <span class="hl str">&quot;50kb&quot;</span> <span class="hl opt">)</span>
	.set<span class="hl opt">{</span> span_channel <span class="hl opt">}</span>
</code>
</pre>
</div>

Then, we combine the different channels using operators:


<div class="sourceCode">
<pre class="sourceCode">
<code class="sourceCode">data_channel                 <span class="hl com">/* start with the raw data */</span>
	.combine<span class="hl opt">(</span> pop_channel1 <span class="hl opt">)</span>  <span class="hl com">/* add pop1 to data */</span>
	.combine<span class="hl opt">(</span> pop_channel2 <span class="hl opt">)</span>  <span class="hl com">/* cross with pop2 */</span>
	.filter<span class="hl opt">{</span> <span class="hl kwc">it</span><span class="hl opt">[</span><span class="hl num">1</span><span class="hl opt">] &lt;</span> <span class="hl kwc">it</span><span class="hl opt">[</span><span class="hl num">3</span><span class="hl opt">] }</span>  <span class="hl com">/* discad the upper triangle of the cross */</span>
	.map<span class="hl opt">{</span> <span class="hl kwc">it</span><span class="hl opt">[</span><span class="hl num">0</span><span class="hl opt">,</span><span class="hl num">2</span><span class="hl opt">,</span><span class="hl num">4</span><span class="hl opt">]}</span>          <span class="hl com">/* select only data &amp; pops (remove indexes) */</span>
	.combine<span class="hl opt">(</span> span_channel <span class="hl opt">)</span>  <span class="hl com">/* cross with sensitivities */</span>
	.set<span class="hl opt">{</span> pairs_channel <span class="hl opt">}</span>     <span class="hl com">/* name output channel */</span>
</code>
</pre>
</div>

Finally, we run the actual bash commands:


<div class="sourceCode">
<pre class="sourceCode">
<code class="sourceCode"><span class="hl kwa">process</span> run_pairewise <span class="hl opt">{</span>
	publishDir <span class="hl str">&quot;output/${span}&quot;</span><span class="hl opt">,</span> mode<span class="hl kwe">:</span> <span class="hl str">&apos;copy&apos;</span>

	<span class="hl kwb">input</span><span class="hl kwe">:</span>
	<span class="hl kwd">set</span> <span class="hl kwc">file</span><span class="hl opt">(</span> data <span class="hl opt">),</span> <span class="hl kwc">val</span><span class="hl opt">(</span> pop1 <span class="hl opt">),</span> <span class="hl kwc">val</span><span class="hl opt">(</span> pop2 <span class="hl opt">),</span> <span class="hl kwc">val</span><span class="hl opt">(</span> span <span class="hl opt">)</span> <span class="hl kwd">from</span> pairs_channel

	<span class="hl kwb">output</span><span class="hl kwe">:</span>
	<span class="hl kwc">file</span><span class="hl opt">(</span> <span class="hl str">&quot;step1.${pop1}-${pop2}.${span}.txt&quot;</span> <span class="hl opt">)</span> <span class="hl kwd">into</span> step1_channel

	<span class="hl kwb">script</span><span class="hl kwe">:</span>
	<span class="hl str">&quot;&quot;</span><span class="hl str">&quot;</span>
<span class="hl str">	cat ${data} &gt; step1.${pop1}-${pop2}.${span}.txt                 # check data content</span>
<span class="hl str">	echo &quot;</span><span class="hl kwf">${pop1} vs. ${pop2}&quot; &gt;&gt; step1.${pop1}-${pop2}.${span}</span>.txt # run pairewise <span class="hl str">&apos;fst&apos;</span>
	echo <span class="hl str">&quot;-- ${span} --&quot; &gt;&gt; step1.${pop1}-${pop2}.${span}.txt       # running average</span>
<span class="hl str">	&quot;</span><span class="hl str">&quot;&quot;</span>
<span class="hl opt">}</span>
</code>
</pre>
</div>

That's all it takes:

```sh
cd ~/root_folder
ls -1
#> analysis.Rproj
#> analysis_twisst.nf
#> data
#> data_file.txt
#> docs
#> logo.svg
#> nextflow.config
#> py
#> R
#> README.md
#> sh
nextflow run analysis_twisst.nf 
#> N E X T F L O W  ~  version 0.31.1
#> Launching `analysis_twisst.nf` [gloomy_goldstine] - revision: 5e861dc34e
#> [warm up] executor > local
#> [d7/fccc1d] Submitted process > run_pairewise (1)
#> [5d/285ab0] Submitted process > run_pairewise (4)
#> [90/f10c05] Submitted process > run_pairewise (2)
#> [5c/371178] Submitted process > run_pairewise (3)
#> [79/c63706] Submitted process > run_pairewise (5)
#> [4a/ccae53] Submitted process > run_pairewise (6)
ls -1a
#> .
#> ..
#> analysis.nf
#> analysis.Rproj
#> data
#> data_file.txt
#> docs
#> .git
#> .gitignore
#> logo.svg
#> .nextflow         <- folder created by nextflow
#> nextflow.config
#> .nextflow.log     <- logfile created by nextflow
#> output            <- folder created by nextflow
#> py
#> R
#> README.md
#> sh
#> work              <- folder created by nextflow
tree output/
#> output/
#> ├── 10kb
#> │   ├── step1.popA-popB.10kb.txt
#> │   ├── step1.popA-popC.10kb.txt
#> │   └── step1.popB-popC.10kb.txt
#> └── 50kb
#>     ├── step1.popA-popB.50kb.txt
#>     ├── step1.popA-popC.50kb.txt
#>     └── step1.popB-popC.50kb.txt
#> 
#> 2 directories, 6 files
cat output/10kb/step1.popA-popC.10kb.txt 
#> I am the input data
#> popA vs. popC
#> -- 10kb --
```

We can see that the three pair wise comparison were completed for both averaging sensitivities,
since all the expected output files show up in the output folder.

But nextflow created a few more files and folders:

- `.nextflow`: the folder where nextflow does its houskeeping
- `.nextflow.log`: the log of the nextflow run
- `output`: the output folder (we specifically asked for this one within the process)
- `work`: the folder where nextflow executes the scripts. The weired prefixes (eg. `[d7/fccc1d]`) in the terminal output refer to subdirectories of `work`

Of course I don not want *git* to remember the whole messy nextflow inner workings (the scripts is enough).
So, I quickly add those files to the `.gitignore` (make sure to use double `>>`!).

```sh
echo ".nextflow*" >> .gitignore
echo "work" >> .gitignore
echo "output" >> .gitignore
```

Now, we made some changes - so lets uppdate the repository (and github).
First, ony the `.gitignore`. 

```sh
git status
#> On branch master
#> Your branch is up-to-date with 'origin/master'.
#> Changes not staged for commit:
#>   (use "git add/rm <file>..." to update what will be committed)
#>   (use "git checkout -- <file>..." to discard changes in working directory)
#> 
#> 	modified:   .gitignore
#> 	modified:   analysis.nf
#> 
#> Untracked files:
#>   (use "git add <file>..." to include in what will be committed)
#> 
#> 	data_file.txt
#> 
#> no changes added to commit (use "git add" and/or "git commit -a")
git add .gitignore
git commit -m "update .gitignore"
#> [master 5de89de] update .gitignore
#>  1 file changed, 3 insertions(+)
```

Then we add the rest:

```sh
git status
#> On branch master
#> Your branch is ahead of 'origin/master' by 1 commit.
#> Changes not staged for commit:
#>   (use "git add/rm <file>..." to update what will be committed)
#>   (use "git checkout -- <file>..." to discard changes in working directory)
#> 
#> 	modified:   analysis.nf
#> 
#> Untracked files:
#>   (use "git add <file>..." to include in what will be committed)
#> 
#> 	data_file.txt
#> 
#> nothing added to commit but untracked files present (use "git add" to track)
git add .
git commit -m 'pipeline update'
#> [master 557d3d7] pipeline update
#>  2 files changed, 41 insertions(+)
#>  create mode 100644 data_file.txt
git status
#> On branch master
#> Your branch is ahead of 'origin/master' by 2 commits.
#>   (use "git push" to publish your local commits)
#> nothing to commit, working directory clean
git push origin master
#> Counting objects: 13, done.
#> Delta compression using up to 4 threads.
#> Compressing objects: 100% (10/10), done.
#> Writing objects: 100% (13/13), 1.74 KiB | 0 bytes/s, done.
#> Total 13 (delta 4), reused 0 (delta 0)
#> remote: Resolving deltas: 100% (4/4), completed with 1 local object.
#> To https://github.com/k-hench/demo_root_folder.git
#>    d8b99be..557d3d7  master -> master
```
</div>

<div class="cluster">
Now, in the *real world*, I woud write the nextflow script locally.
Then I would comit my changes to github and pull them onto the cluster from there.
Finally I would run nextflow on the cluster (`nextflow run analysis.nf`).
</div>

## Managing the workflow on the cluster 

The nice thing about running nextflow on the cluster is, that it works pretty much the same as locally - so you don't have to deal with submitting jobs because nextflow will take care of this.

- screen

## The config script

The `nextflow.config` sets up some global setting for your nextflow run.
To use the NEC computer cluster from Uni Kiel, I add this section to the config script:

<div class="kclass">
```
env.BASE_DIR = "$WORK/project_dir"

process {
   executor = 'nqsii'
   queue = 'clmedium'
   cpus = 1
   memory = 4.GB
   time = { 1.h * task.attempt }
   errorStrategy = { task.exitStatus == Integer.MAX_VALUE ? 'retry' : 'finish' }
   maxRetries = 1
   maxErrors = '-1'
   
   	 withLabel: "L_loc.*" {
	 executor='local'
	 }

	 withLabel: "L_20g15m_.*" {
       queue = 'clexpress'
       memory = 20.GB
       time = { 15.m * task.attempt }
    }
    
    withLabel: "L_---_.*" {
       clusterOptions = '---'
       queue = '---'
       memory = ---.GB
       cpus = ---
       time = { ---.h * task.attempt }
    }
}

trace { enabled = true }
report { enabled = true }
```
</div>

So, I set at few defaults for the jobs, and then stat defining different the types of processes that I reference within the `analysis.nf` script.
Please refer to [nextflow documentation](https://www.nextflow.io/docs/latest/config.html#scope-process) for the different options set within the process section.

Apart from this, I also provide the path to the project folder and turn the *trace* and the *report* on by default.

--------
