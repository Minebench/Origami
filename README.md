Origami
==

![Origami Logo](logo.png)

Custom paper fork used by [Minebench.de](https://minebench.de). The fork is based off of
 the framework used in [Spottedleaf's Concrete](https://github.com/Spottedleaf/Concrete)
  which is based off of [aikar's EMC framework](https://github.com/starlis/empirecraft).

## Contact
[IRC](http://moep.tv/chat) | [Website](https://minebench.de/)

## License
The PATCHES-LICENSE file describes the license for api & server patches, 
found in `./patches/api` and `./patches/server`.

Everything else is licensed under the MIT license. 
See https://github.com/Spottedleaf/Concrete, https://github.com/starlis/empirecraft
and https://github.com/electronicboy/byof for the license of material used/modified by this project.

## Plugin developers
In order to use Origami as a dependency just add the following repo and dependency to your pom:

Origami maven repository:
 ```xml 
<repository>
    <id>origami-repo</id>
    <url>https://repo.minebench.de/</url>
</repository>
```
Origami-API maven dependency:
```xml
<dependency>
    <groupId>de.minebench.origami</groupId>
    <artifactId>origami-api</artifactId>
    <version>1.14.4-R0.1-SNAPSHOT</version>
    <scope>provided</scope>
 </dependency>
 ```

## Building and setting up
Run the following commands in the root directory:

```
git submodule init
git submodule update
./origami up
./origami patch
```

This should initialize the repo such that you can now start modifying and creating 
patches. The folder `Origami-API` is the api repo and the `Origami-Server` folder
is the server repo and will contain the source files you will modify.

#### Creating a patch
Patches are effectively just commits in either `Origami-API` or `Origami-Server`. 
To create one, just add a commit to either repo and run `./origami rb`, and a 
patch will be placed in the patches folder. Modifying commits will also modify its 
corresponding patch file.


#### Building

Use the command `./origami build` to build the api and server. Compiled jars
will be placed under `Origami-API/target` and `Origami-Server/target`.

#### Updating Paper upstream

Switch into the directory of the Paper submodule and pull changes in from the 
repository, then run `./origami up` and `./origami rb`.