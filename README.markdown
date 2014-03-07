# Demo Application for a Data Repository

Built with Sufia, this app will process data files in the background and add the metadata back to the object.
Right now, data files are identified by their extension, with *.txt, *.csv and *.tsv files being processed.
The jobs are basic, but can be chained together so certain files get more specific metadata added than others.

### What's next?

There are a couple things we're looking to add, including:

* Distributed Redis.
* External Files with AWS
* Fedora 4
* Access Controls
* Tests
