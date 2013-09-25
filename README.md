# Jakarta.pm.org Website

Website for the Jakarta Perl Mongers group.  http://jakarta.pm.org

This website will serve two purposes:

First, it is to serve as a support/promote the use of the Perl language in Indonesia.

Second, it is to serve as an example of how to properly build, test, document and deploy a small web application using the Catalyst Framework.
This site will have a small number of features (users, calendar, news), I'll try to demonstrate as many commonly-used technologies as possible


## Technologies Covered

* Form Handling with [HTML::FormHandler](http://search.cpan.org/dist/HTML-FormHandler/lib/HTML/FormHandler.pm)
* Automatic Sitemaps [Catalyst::Plugin::Sitemap](http://search.cpan.org/~yanick/Catalyst-Plugin-Sitemap-1.0.0/lib/Catalyst/Plugin/Sitemap.pm)
* Authentication/Authorization with [Catalyst::Plugin::Authentication](http://search.cpan.org/~bobtfish/Catalyst-Plugin-Authentication-0.10023/lib/Catalyst/Plugin/Authentication.pm)
    * Securing password data with salted SHA-1 hash [Crypt::SaltedHash](http://search.cpan.org/~gshank/Crypt-SaltedHash-0.09/lib/Crypt/SaltedHash.pm)
    * Simple roles implementation [Catalyst::Plugin::Authorization::Roles](http://search.cpan.org/~bobtfish/Catalyst-Plugin-Authorization-Roles-0.09/lib/Catalyst/Plugin/Authorization/Roles.pm)
* Enforcing SSL within a controller [Catalyst::Plugin::RequireSSL](http://search.cpan.org/~mramberg/Catalyst-Plugin-RequireSSL-0.07/lib/Catalyst/Plugin/RequireSSL.pm) 
* E-Mail Sending 
    * Plaintext [Catalyst::View::Email](http://search.cpan.org/~dhoss/Catalyst-View-Email-0.33/lib/Catalyst/View/Email.pm)
    * Templated [Catalyst::View::Email::Template](http://search.cpan.org/~dhoss/Catalyst-View-Email-0.33/lib/Catalyst/View/Email/Template.pm)
* Templated HTML with [Template::Toolkit](http://www.template-toolkit.org)
* Localization 
    * Content Localization [Catalyst::Plugin::I18N](http://search.cpan.org/~bobtfish/Catalyst-Plugin-I18N-0.10/lib/Catalyst/Plugin/I18N.pm)
    * URL Localization [Catalyst::Plugin::I18N::Request](http://search.cpan.org/~bricas/Catalyst-Plugin-I18N-Request-0.08/lib/Catalyst/Plugin/I18N/Request.pm)
* Working with database models [DBIx::Class](http://search.cpan.org/~ribasushi/DBIx-Class-0.08250/lib/DBIx/Class.pm)


## Installing the Prerequisites  

### Windows

On Windows, I run [Strawberry Perl](). (I've used Active Perl as well.. the choice between the 
two is fairly arbitrary.  They both work great.).  
On Mac or Linux, chances are you've got Perl 5.10+ so you're already in good shape.

1. On Windows, you need to install nmake. You can get this application by installing the Windows SDK (google it) .. Then you're going to need to find the path to nmake.exe (It'll be something like C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\bin) and add it to your user or system PATH variable.
2. Clone this repo
3. Install MySQL and deploy the workbench model included at the project root
4. Navigate to the project root and run the following commands (install all the optional components when prompted):

```
C:\myapp> perl Makefile.PL
C:\myapp> nmake
C:\myapp> nmake install
```

### Linux and Mac OSx

1. Make sure you've got GNU make installed and it's added to the PATH of your favorite shell.
2. Clone this repo with git to your local machine.  
3. Install MySQL and deploy the workbench model included at the project root.
4. Navigate to the project root and run the following commands (install all the optional components when prompted):

```
$ perl ./Makefile.PL
$ sudo make
$ sudo make install
```


Rebuilding The Database Schema
--------

I'm the type of person who likes building a database schema with boxes and lines, rather than creating my model classes first, so
my standard approach when using MySQL is to build a MySQL Workbench model and make all my changes through that.. Then to sync
those to whichever database I'm working with.  DBIx::Class has a neat way to dump all these into model classes (and catalyst adds
to this to create your Model along with your Schema dump).

(On Windows.. on OSx or Linux just reverse the slash in script\jakartapm...)

```
C:\myapp> perl script\jakartapm_create.pl model SiteDB DBIC::Schema JakartaPM::Schema::SiteDB create=static dbi:mysql:jakartapm root
```
