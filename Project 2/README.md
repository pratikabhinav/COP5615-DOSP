# Project2 : GOSSIP SIMULATOR

**Group members**

1. Abhinav Pratik, 1019-4316, pratikabhinav@ufl.edu
2. Anubhav Jha, 4339-3979, ajha1@ufl.edu

# Project Definition

- Goal of the project is to implement gossip and push sum algorithms and observe its behavior for various network topologies.

- Topologies implemented are : 
  1. Full (full)
  2. 3D (3d)
  3. Random 2D (rand2d)
  4. Imperferct 2D (imp2d)
  5. Line (line)
  6. Imperfect line (impline)

Note: We were not able to implement sphere topology.

- Algorithms implemented are :
  1. Gossip
  2. Push-Sum Algorithm

# Execution Steps

> Compile

```
mix clean
```

```
mix escript.build
```
 
> Run

``` 
escript project2 <Number Of Nodes> <Topology Type> <Algorithm>
```

The code requires three arguments: 

* arg1 : Number Of Nodes - Number of nodes to be simulated. Please refer to maximum number of nodes for each topology below.

* arg2 : Topology Type - Select from full, line, impline, rand2d, imp2d, 3d"
* arg3 : Algorithm - Pick from gossip OR push-sum

- Note : For rand2d and imp2d number of nodes will be rounded to nearest perfect square. And to the nearest cube for 3d.


# Largest network dealt with for Gossip

  1. Full (full) - 10000
  2. 3D (3d) - 10000
  3. Random 2D (rand2d) - 10000
  4. Imperferct 2D (imp2d) - 10000
  5. Line (line) - 10000
  6. Imperfect line (impline) - 10000
- Note : Gossip works for higher number of nodes as well. But we stuck with 10000 which gave a respectable time for each network.

# Largest network dealt with for PushSum

  1. Full (full) - 1000
  2. 3D (3d) - 1000
  3. Random 2D (rand2d) - 1000
  4. Imperferct 2D (imp2d) - 1000
  5. Line (line) - 1000
  6. Imperfect line (impline) - 1000



