Jakarta.pm.org Website
=========

Website for the Jakarta Perl Mongers group.  http://jakarta.pm.org

This website will serve two purposes:

First, it is to serve as a support/promote the use of the Perl language in Indonesia.

Second, it is to serve as an example of how to properly build, test, document and deploy a small web application using the Catalyst Framework.
This site will have a small number of features (users, calendar, news), I'll try to demonstrate as many commonly-used technologies as possible

* News
** Trusted site admins can post site news/announcements
** Authenticated users will be permitted to post comments -- considering using disqus
** Comments can be moderated by trusted users
** Authenticated users can flag comments they see as inappropriate
* Event Calendar
** Serialization into iCal format
* i18n support + translation files for both English and Bahasa
** demonstrate how to localize urls as well
* Authentication through Catalyst::Plugin::Authentication 
* Use of HTML::FormHandler for all forms processing
* TemplateToolkit template usage/configuration
* Demonstrate AJAX usage within the framework
* Demonstrate e-mailer + account verification functions with sendmail
