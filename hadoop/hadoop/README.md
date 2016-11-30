Flume Deployment Using Elasticsearch and Kibana3 in Vagrant
=

This is an example configuration of how to utilize apache flume with Elasticsearch
as a sink, and then visualize its data using Kibana.

To run the configuration:

    git clone git@github.com:mross462/Flume-Deployment
    cd Flume-Deployment
    vagrant up es worker

What it does
-
Deploys Elasticsearch and Kibana to 123.123.123.100
Deploys Flume-NG, apache, and a custom app for generating random http responses
to 123.123.123.101

How to add data from the worker to ES
-
I've put together a test script will make 10000 requests against 123.123.123.100
this will generate 10000 random http responses that are logged in the apache
log which is used as an exec source in flume. The entries are then transfer to
123.123.123.101 in logstash format so kibana can interpret them visually.

To run the script:

    vagrant ssh worker
    python /vagrant/test_script.py

How to visualize the data that is contained in ES with Kibana
-
Port 80 on the ES machine is port forwarded to 8080 on the host so Kibana can
be reached from there.

Start with an unconfigured dashboard and then add the panels and queries.
In particular for this case the histogram is a rather nice way to view the data.

http://localhost:8080/index.html#/dashboard/file/noted.json

Also it's a good idea to set a time filter. Top right hand corner.

Why did you do this
-
There are not that many resources available on how to properly deploy
and setup flume with an es sink that can be used to visualize data.

What comes next
-
Replace the exec source of tailing the apache error log with any other source,
and you now have a way to query data that is being generated by any source using
Kibana.

Video Tutorial
-
https://drive.google.com/file/d/0BwtAhMkPF0etNWJIT2MwUG1fSFk/edit?usp=sharing

===================
bin/plugin -install mobz/elasticsearch-head