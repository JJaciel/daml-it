# Daml Testing - transcript

Testing is integral to building high quality software, and Daml offers many tools and techniques to make sure that you can test your code extensively. So let's look at some of those tools and techniques to test Daml templates. Let's start with the tools available in the Daml SDK. The first one is scripts.

## Scripts

We've already seen how scripts help us define test scenarios that simulate parts of a business workflow. These scripts run against a ledger and allow us to see how code inside templates will behave in a simulated environment. When we run the scripts in Visual Studio Code as part of the Daml SDK, we're running them against a test ledger or temporary ledger.

We can also run scripts using the command line interface or CLI, against a temporary ledger to run them against an actual ledger. We start a Daml sandbox and run the scripts in that sandbox. Daml Sandbox, also called the Canton Sandbox, or just sandbox is an instance of an in-memory Canton Ledger, which is used for development environments.

We can also use a running sandbox with a running ledger. Let's look at each of these one by one. We'll start with a simple template bank account that has one choice deposit and use it for our test cases. In the script, written in the test scripts dot Daml, we create two parties, bank and Alice submit a command, create a bank account, and then exercise the deposit choice on it.

Given the setup, we can use the script view by simply running the. It gives us several table views with or without archived contracts and detailed disclosure. It also gives us a detailed transaction tree view that shows the sequence of actions committed to the ledger. But if we want to run more than one script, then we can run them from the command line.

## Daml test

Daml test is a tool that runs all test scripts in the specified file or in all Daml files in the current project folder, and produces a test coverage report as the output on the console. As you can see here, the test summary shows details such as number of active contracts, transactions, and test coverage metrics.

Also note that although we have only one choice in our template, the report says that there are two internal template choices defined and only one is exercised. The second choice here is archive, which is implicitly defined in all templates. As our script doesn't test it, the report indicates that it has not been tested.

```sh
# run all tests
daml test

# run a specific file
daml test --files [file]
```

## Sandbox

You can have multiple files that have test scripts written in them. If you want to run only one test file, you can use the files option. The next approach to run our scripts is to use a Canton Sandbox. The Daml Sandbox, or a sandbox for short is a simple ledger that enables rapid prototyping By simulating a Canton Ledger locally, we can use it for testing in two ways.

- The first way has four steps, 
    - starting with compiling our Daml code, including templates and scripts into a DAR file. 
    - Then we start the Canton Sandbox, 
    - upload the DAR file onto it, 
    - and then run Daml test as before. 

- The second option is to use Daml start, which is also available as a tool from the Daml assistant.
```sh
daml start # does the same steps as the first way
```
It 
- creates the DAR file, 
- starts the Canton Sandbox, 
- uploads the dar, 
- and then runs the test. 

At this point, it's important to look at our daml.yaml file, which comes from the predefined Daml Project template installed with the Daml SDK that we used as a starting point for our Daml project. 

## Daml.yaml
Daml.yaml is the project config file that must be in the root of your project directory as shown in the example here. It lists the current SDK version, project folder, name, name of the initialization script, version of the DAR files to be created and project dependencies. The Daml Start tool uses the init script to initialize the sandbox, creating an init script for initializing. The sandbox isn't a topic we'll focus on at this point, and for now, if we try to build this Main.daml as it's been written, it'll throw an error.
```yaml
# for config file options, refer to
# https://docs.daml.com/tools/assistant.html#project-config-file-daml-yaml

sdk-version: 2.6.4
name: daml-lab-1
source: daml
init-script: Main:setup # The Daml Start tool uses the init script to initialize the sandbox
version: 0.0.1 # Version of the DAR files
dependencies:
  - daml-prim
  - daml-stdlib
  - daml-script
```

So let's comment it out for now so that the error goes away. And now before we go any further, let's revisit these two options in a bit more detail using our Learn Daml project as an example. Once we have our bank service template and the test scripts written out in Main.daml, we can start the terminal in Visual Studio Code by pressing control, back tick, or choosing the new terminal option from the IDE.
```text
control + `
```

Since we're in the project directory, we can say Daml build, which compiles all the Daml code into a DAR file or Daml archive file. Notice that the version number of the DAR file will depend on the version number you provide in the Daml yaml. Then we start Daml Sandbox, which will give us a message when the Canton Sandbox is ready.

## Running tests manually
```sh
# compiles all the daml code into a DAR file or Daml archive file
daml build

# start the canton sandbox
daml sandbox
```

in a new terminal
```sh
# upload DAR file into the sandbox ledger
daml ledger upload-dar
# run the tests
daml test
```

Notice that if it goes well, the Canton Sandbox is ready and listening at a default port of 6865. You can make it run on a different port by specifying a port number, but let's use the default port for now. You do wanna make sure this port is free otherwise, or you'll see an error message indicating that the port is already being used.

At this point, you need to leave this terminal running and open another terminal where we'll say Daml Ledger upload dar. Once you see a message that the DAR uploaded successfully, you can run Daml test. This should give you the test summary report. The second option for running scripts on a Canton Sandbox, as we discussed, is pretty straightforward.

## Daml start

We simply say, Daml start. This will carry out compiling, starting the Canton Ledger and uploading the DAR. Once it's done, you can open up another terminal window and run Daml test. As before, you'll see the test summary report when you use Daml Start. 

## Running tests with daml start
```sh
daml start

# in a new terminal
daml test
```

## Navigator

It also starts the Navigator app on port 7500. Navigator is a front end app that can be used to connect to any Canton Ledger and modify the ledger.

We use it during Daml development as yet another tool to explore the flow and implications of the Daml models. It comes bundled with the Daml SDK. When you run Daml start, it'll open your browser in a new tab and display a login page with a choose your Role dropdown. 

## Review

So let's review what we covered in this lesson, we looked at Daml scripts and how they can be used to conduct extensive testing of the code written in Daml templates.

These scripts can be run in a few different ways. If we want to test at a script level, we can run the script within the IDE to perform unit testing, which is the most granular level of script execut. We can run the scripts from a command line interface or CLI using Daml assistance tools. For example, Daml test.

This option allows us to run scripts at a file level. We can run all the scripts in a file or all scripts within all the files in a project. If we want to run our scripts against a Canton Sandbox environment, then Daml offers two ways to do that. Using a set of tools and sequence Daml build Daml sand.

Daml upload DAR and then Daml test or using Daml start, followed by Daml.