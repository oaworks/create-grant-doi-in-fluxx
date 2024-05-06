# Project Title

Creating Crossref Grant DOIs via Fluxx Workflow Button

# Description

This code script enables Fluxx clients to create a Crossref Grant DOI by the click of a button, without leaving the Fluxx dashboard.  In particular, this is a workflow button on the Grant Request model, with a custom Ruby code script inserted in the "Before Validation" code block of a chosen workflow state.  The function is shown in the following 50-second video.

https://github.com/oaworks/create-grant-doi-in-fluxx/assets/166541311/814bb1bf-f787-4cae-8415-b47a7e0cdb55


# Context

Many funders use [Fluxx Grantmaker](https://www.fluxx.io) (Fluxx) as their Grant Management System (GMS).  Many funders also use Crossref to mint [Digital Object Identifiers](https://www.doi.org) (DOIs) for their grants.  This practice comes with several benefits, described for instance [here](https://www.crossref.org/community/grants/) and [here](https://osf.io/pv96e).  

Crossref provides an overview of the process and requirements [here](https://www.crossref.org/documentation/research-nexus/grants/).  They offer several methods of uploading the metadata required for a grant DOI, including an [online grant registration form](https://www.crossref.org/documentation/register-maintain-records/grant-registration-form/) and [direct XML deposit](https://www.crossref.org/documentation/register-maintain-records/direct-deposit-xml/).  For the latter, a markup guide can be found [here](https://www.crossref.org/documentation/schema-library/markup-guide-record-types/grants/).  

The code written in this project offers another method, which allows Fluxx clients to mint a grant DOI with Crossref by the click of a button in a typical Fluxx dashboard.  


# Getting Started / Dependencies

This code is written with Fluxx users in mind.  To use the code, you or your organization must be a Fluxx client, and must also be a member of Crossref.  Fluxx demos are available [here](https://www.fluxx.io/products/grantmaker-fluxx-grants-management-software).  Crossref membership information is available [here](https://www.crossref.org/members-area/).  

**From Crossref**
With a Crossref account, Fluxx users will need their Crossref login credentials, their unique Crossref DOI prefix, and their Open Funder Registry ID.  These will all be inserted into the code script, as demonstrated in the 'Code Tour' video, embedded below. 

**From Fluxx:** To use the code successfully, Fluxx users will need a Grant Request form with field values that can be mapped to the data required by Crossref for a grant DOI. The required fields are marked as 'required' in the 'limits' column of Crossref's tables on [this page](https://www.crossref.org/documentation/schema-library/markup-guide-record-types/grants/).  On that same page can also be found several optional fields. However, this particular code script accommodates only the minimum required fields.

When the required fields have been identified in Fluxx, the 'back-end names' of those fields must be copied and pasted into the code script, as demonstrated in the 'Code Tour' embedded below.  Finally, two new fields must be created in Fluxx.  These are for storing the Crossref DOI and Crossref confirmation message.  These fields are also pointed out in the video embedded below.

**From Comms or IT:**
One of Crossref's required fields is a grant-specific URL.  In order to avoid manually entering this URL into the Fluxx form before running this code, the code uses a convention described below.  It is up to you to ensure that your comms team uses this same convention when creating the URL for each grant.

In the "fixed values" section of the code, you will be asked to provide your URL prefix.  For example, this may be: 'https://www.your-foundation.org/grants/'.  This is the non-unique portion of your grant URLs.  Then, in the 'substitutions' section, the code creates the unique part by using a lower-case version of the project title, replacing all spaces between words with dashes.

You may edit this convention in the code, of course.  But whatever convention you choose to use, it is up to you to ensure that your comms team uses the same convention when creating the URL for each grant.

**Code Tour:**

A walk-through of the code script is embedded below.  

https://github.com/oaworks/create-grant-doi-in-fluxx/assets/166541311/acac19aa-679c-4a92-bafe-93b40ebcf955


# Testing & Installing

When the code script has been customized with the Fluxx user's Crossref credentials and back-end names, the code can be dropped in the 'Before Validation' code block of the workflow state in which the DOI should be created.  This process is demonstrated in the attached 'Demo' video, embedded below.

https://github.com/oaworks/create-grant-doi-in-fluxx/assets/166541311/94764b69-0a4f-4f95-90c8-02353baea28f

Before installation in a Fluxx 'production' admin panel, it is recommended that the code first be tested in a Fluxx 'pre-production' environment.  Similarly, the code can also be tested in Crossref's [test site](https://www.crossref.org/documentation/register-maintain-records/direct-deposit-xml/testing-your-xml/) before being redirected to Crossref's live site.  The test site is demonstrated in the 'Demo' video above.  When the Fluxx client is ready to redirect the XML file to Crossref's live site, the code script comments explain the one change necessary. 

To check for errors on Fluxx's side, the code can be triggered by entering a Grant Request record ID into the "Test Before Validation Block" field, directly below where the code is pasted in the Admin Panel.  To check for errors on Crossref's side, simply visit your personal "Submission Administration" page.  Once the code has passed initial testing, errors can be monitored ongoingly by reading the confirmation messages sent by Crossref.  These emails typically arrive within a few hours of running the code script, and sometimes arrive within just a few minutes.


# Executing Program

When the code script has been dropped in the "Before Validation" code block for a particular workflow state, all Grant Request records landing in that state will run the script before being saved in that location.  No other action is required.

When the code runs successfully, a confirmation message is saved in the Fluxx client's predetermined field of the Grant Request form.  Similarly, if the code runs unsuccessfully, an error message will be saved to the same predetermined field in the Grant Request form.  This is also mentioned in the code comments, and also in each embedded video.


# Authors

This project was directed by Syman Stevens of Co-Creative Consulting, LLC.  The primary code author was Stephen Brandon of [Brandon IT Consulting](https://brandonitconsulting.co.uk). 


# Acknowledgments

This project was funded by [OA.Works](https://oa.works), a non-profit project building tools so that open access is easy and equitable.  Thanks are due to Fluxx for providing access to the test environment shown in the demo, and also to Crossref for providing access to the test environment also shown in the demo.  


# License

This project is licensed under an MIT License.  See the LICENSE.md file for details.


# Version History

* 1.0
    * Initial Release.

* Ideas for Improvement:
    * Add an automatic check via Crossref's [file checker](https://www.crossref.org/02publishers/parser.html).
    * Add ORCID field (simple), validating with ORCID along the way (interesting).
    * Add ROR field (simple) validating with ROR along the way (interesting).
    * Accommodate multiple team members listed a "Related User 1, 2, and 3".
    * Accommodate multiple team members listed in "Team Members" dynamic model.
    * Accommodate grants being distributed in multiple currencies.
    * Edit code to be run as a 'method' for bulk submission of multiple grant DOIs.
