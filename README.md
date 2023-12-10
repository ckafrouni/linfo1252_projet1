# LINFO1252_projet1

## Description

Project conducted in the context of the `LINFO1252 Systèmes informatiques` course.
The idea is to evaluate and discuss the performance of multithreads applications that use synchronization primitives.

In that regard, the considered problem sets are:

- the dining philosopher ;
- the readers/writers ;
- the producers/consumers ;
- the lock/unlock ;

## Usage

This section explains how to use this project.

### Building

You can build all applications using the following command:

```shell
make
```

#### Testing

A script named `experiments.sh` is used to run and benchmark the applications. You can run it using on its own `./experiments.sh` or using the following command:

```shell
make studsrv
```

which will mimic the `Inginious` environment.

The script will output the results of the selected tests in *stdout*. You will have to copy/paste them in a *csv* file in a data directory.

### Plotting

After retrieving data as text and putting them in files of the form `*_<lock_type>.csv`, in the `data/{inginious/local}` directory. You can plot the results with the following command:

```shell
make plot # will plot the results of either the local or the inginious tests depending on the data directory specified in the Makefile
```

## Authors

@Bousmar Cyril (<https://forge.uclouvain.be/CyrilBousmar>)
@Kafrouni Christophe (<https://forge.uclouvain.be/ckafrouni>)
