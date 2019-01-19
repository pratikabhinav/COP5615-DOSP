# Project3 : CHORD PROTOCOL

**Group members**

1. Abhinav Pratik, 1019-4316, pratikabhinav@ufl.edu
2. Anubhav Jha, 4339-3979, ajha1@ufl.edu

# Project Definition

- The goal of the project is to implement the network join and routing as described in the Chord paper (Section 4) and encode the simple application that associates a key (same as the ids used in Chord) with a string.



# Execution Steps (Have Elixir 1.5.0 installed)

> Compile

```
mix clean
```

```
mix escript.build
```
 
> Run

``` 
escript project3 <Number of nodes> <Number of requests>
```

The code requires two arguments: 

* arg1 : Number Of Nodes - Number of nodes to be simulated. Please refer to maximum number of nodes of section below.

* arg2 : Number of requests that each node will make.

# Sample inputs/outputs

* aj26@DESKTOP-DIAEUJ2:/mnt/c/Users/ajanu/Documents/course/dosp/Project3$ escript project3 10000 10\
Average hops: 3.58639

* aj26@DESKTOP-DIAEUJ2:/mnt/c/Users/ajanu/Documents/course/dosp/Project3$ escript project3 20000 20\
Average hops: 3.6121175

* aj26@DESKTOP-DIAEUJ2:/mnt/c/Users/ajanu/Documents/course/dosp/Project3$ escript project3 30000 25\
Average hops: 3.633388

* aj26@DESKTOP-DIAEUJ2:/mnt/c/Users/ajanu/Documents/course/dosp/Project3$ escript project3 50000 60\
Average hops: 3.641244

* aj26@DESKTOP-DIAEUJ2:/mnt/c/Users/ajanu/Documents/course/dosp/Project3$ escript project3 75000 75\
Average hops: 3.6446771555555557

* aj26@DESKTOP-DIAEUJ2:/mnt/c/Users/ajanu/Documents/course/dosp/Project3$ escript project3 100000 100\
Average hops: 3.6488904



# Largest network dealt with

-aj26@DESKTOP-DIAEUJ2:/mnt/c/Users/ajanu/Documents/course/dosp/Project3$ escript project3 200000 25\
Average hops: 3.6577196
