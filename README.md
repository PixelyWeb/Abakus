Abakus
======

1. Overview
===========

Abakus is a powerful tool which allows you to real-time analyse log files and extracting valuables information.  It applies user defined filters based on .regular expression. which permits to extract whatever data you want.
Some additional added-value is Abakus ability to process basic calculations on each data and perform also some .lines. or .columns aggregation. on predefined timeslots in the file. 
It also handles different data types : number, string and date.
It can be used in .event mode. where it performs real-time data analysis in logstream (???). The event, corresponding to a counter can also be sent through syslog. 
The output format can be entirely customized to permits you to connect Abakus to your preferred data storage application.
For example, let.s take a case where I want to store my data directly onto a MySQL database.
I can configure the output format of Abakus for giving me directly the SQL statements to store the data: 

    format=.INSERT INTO events_avg (`timestamp`, `metric`, `value`) 
    VALUES (`my_metric[timestamp]`, ` my_metric [name]`, ` my_metric [avg]`);  .

2. Prerequisites
================

Abakus is written in perl. You should have at minimum perl v5.8.8 on your machine. 
You must also have installed the .perl-Curses. library and the Date::Format CPAN package.

3. Installation
====================

The installation is quite simple! Abakus doesn.t need to be compiled, so you just have to uncompress it wherever you want.
And obviously give it some execution rights. 

4. Usage
========

To call Abakus you simply do: 
 
      ./abakus .e <my/filters/file/path>
    Here.s the options:		
                    -c <file> : capture the matched results and write it in a file
    				-d : activate the debug mode
    				-f <file>: the path of file to parse
    				-h : print this help menu
    				-i <time(ms)>: the time interval to parse
    				-r <date>: the reference date from where to parse. the date format should 
                    be YYYY MM DD HH mi s.
    				-e <file>: specify a filters file. The filters file permits you to define 
                    your key filters, the output format and also the date format to analyze.

