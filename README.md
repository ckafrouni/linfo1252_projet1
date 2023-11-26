# LINFO1252_projet1

## Description
Project conducted in the context of the `LINFO1252 Systèmes informatiques` course.
The idea is to evaluate and discuss the performance of multithreads applications that use synchronization primitives.

In that regard, the three considered applications are:
- the problem of the philosopher ;
- the problem of readers/writers ;
- the problem of producers/consumers.

## Usage

### All in one script
A script, `experiments.sh` allows to compile the `.c` code and run all the tests. This will produce graphs on the performance of the code.

It can be run directly from the `root` directory, using this command:
```shell
bash experiments.sh
```

After the run, performs a `make clean`.

**Alternatively**by using the following:
```shell
make run
```

### Actions on specific targets
Using the make file, you can perform the same actions separetely.

#### Building
You can build all applications using the following command:
```shell
make
```

**Or**, you can target a specific build using the following:
```shell
make build_philosophers
```

```shell
make build_producers_consumers
```

```shell
make build_readers_writers
```

#### Testing
You can test the performance of the execution of all applications using the following command:
```shell
make test
```

**Or**, you can target a specific test using the following:
```shell
make test_philosophers
```

```shell
make test_producers_consumers
```

```shell
make test_readers_writers
```

#### Cleaning
To clean all executables, run the following command:
```shell
make clean
```

## TODO

- [ ] readers/writers was modified to unblock the code, but why is the code from previous TP not valid ?
- [ ] why would producers/consumers fail and block for values `2 4` or `4 2` ?
- [ ] modify `rand()` in producers/consumers to prevent overflow and get good results.
- [ ] what is the use of `make test` since we need `experiments.sh` ?
- [ ] should we use `barplot` instead of `lineplot` ?

## Authors
@Bousmar Cyril (https://forge.uclouvain.be/CyrilBousmar)
@Kafrouni Christophe (https://forge.uclouvain.be/ckafrouni)
