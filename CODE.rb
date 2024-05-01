###########################################
# Step 1: Create an XML File for Crossref #
###########################################

# XML TEMPLATE:
#	- This template provides the XML file structure, as per Crossref's schema.  
#   - This particular template accommodates Crossref's minimum required fields.
#   - Field value substitutions are provided further below.

_template = '
<doi_batch xmlns="http://www.crossref.org/grant_id/0.1.1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.crossref.org/grant_id/0.1.1 https://www.crossref.org/schemas/grant_id0.1.1.xsd" version="0.1.1">
  <head>
      <doi_batch_id><<doi batch id>></doi_batch_id>
      <timestamp><<timestamp>></timestamp>
      <depositor>
          <depositor_name><<depositor name>></depositor_name>
          <email_address><<depositor email>></email_address>
      </depositor>
      <registrant><<registrant>></registrant>
  </head>
  <body>
    <grant>
      <project>
        <project-title xml:lang="en"><<project-title>></project-title>
        <investigators>
          <person role="lead_investigator">
            <givenName><<lead_investigator givenName>></givenName>
            <familyName><<lead_investigator familyName>></familyName>
            <affiliation>
              <institution><<lead_investigator institution>></institution>
            </affiliation>
          </person>
        </investigators>
        <description xml:lang="en"><<description>></description>    
        <award_amount currency="USD"><<award amount>></award_amount>
        <funding funding-type="award">
          <funder-name><<funder_name>></funder-name>
          <funder-id><<funder-id>></funder-id>
          <funding-scheme><<funding-scheme>></funding-scheme>
        </funding>
        <award-dates start-date="<<start-date>>" end-date="<<end-date>>"/>
      </project>
      <award-number><<base-request>></award-number>
      <award-start-date><<start-date>></award-start-date>
      <doi_data>
        <doi><<doi>></doi>
        <resource><<resource>></resource>
      </doi_data>
    </grant>
  </body>
</doi_batch>

'

# Fixed Values:
#   - These values will be the same for all grant DOIs.
#   - These values are called upon on the "substitutions" below.
#   - Update the information between the single-quotation marks only.

_funder_name = 'Example Foundation Name'            # Name of funding agency.
_funder_doi_prefix = '00.0000/'                     # Unique DOI prefix provided by Crossref.
_funder_id = 'https://doi.org/00.00000/000000000000'# Open Funding Registry ID.
_resource_prefix = 'https://www.example.org/here/'  # The non-unique part of this grant's URL.
_login_name = 'user_name'                           # Crossref login name.
_login_password = 'password'                        # Crossref login password.

# Calculations
#   - These values are custom-calculated for each grant DOI.
#   - These values are called upon on the "substitutions" below.
#   - Users need not make any edits to this portion of the code.

_timestamp = Time.now.strftime("%Y%m%d%H%M%S%L")    # Sets timestamp to be the current time.
_doi_batch_id = 'batch_' + model.id.to_s            # Sets 'batch_id' to be the Grant ID.


# Substitutions:
#   - These substitutions put values in the XML template above.
#   - These substitutions include the fixed values and calculations above.
#   - Update the information only on the right side of each line.

_substitutions = {
  '<<timestamp>>' => _timestamp,                        # This is a fixed value. Do not edit.
  '<<doi batch id>>' => _doi_batch_id,                  # This is a fixed value. Do not edit.
  '<<registrant>>' => _funder_name,                     # This is a fixed value. Do not edit.
  '<<funder_name>>' => _funder_name,                    # This is a fixed value. Do not edit.
  '<<funder-id>>' => _funder_id,                        # This is a fixed value. Do not edit.
  '<<depositor name>>' => model.current_user.full_name, # Sets current Fluxx user as 'depositor'.
  '<<depositor email>>' => model.current_user.email,    # Sets current Fluxx user as 'depositor'.
  '<<project-title>>' => model.project_title,           # Core field for project title.  Edit if desired.
  '<<description>>' => model.project_summary,           # Core field for project summary.  Edit if desired.
  '<<lead_investigator givenName>>' => model.grantee_org_owner.first_name,  # Sets org_owner as PI.  Edit if desired.
  '<<lead_investigator familyName>>' => model.grantee_org_owner.last_name,  # Sets org_owner as PI.  Edit if desired.
  '<<lead_investigator institution>>' => model.program_organization.name,   # Sets 'program org' as PI org.  Edit if desired.
  '<<award amount>>' => model.amount_recommended.to_s.gsub(/\.[0-9]+$/,''), # Sets amount_recommended to text.  Change field as desired, but keep '.to.s.gsub...'.
  '<<funding-scheme>>' => model.program.name || '',                         # Uses 'program' as scheme.  Or choose 'initiative', etc.
  '<<start-date>>' => model.grant_begins_at ? model.grant_begins_at.strftime("%Y-%m-%d") : '',  # Formats start-date.  Change field as desired, but keep formatting.
  '<<end-date>>' => model.grant_ends_at ? model.grant_ends_at.strftime("%Y-%m-%d") : '',        # Formats end-date.  Change field as desired, but keep formatting.
  '<<base-request>>' => model.request_id,               # Sets Fluxx request_id as "Award Number" in Crossref metadata.  Separate from DOI id, below.
  '<<doi>>' => _funder_doi_prefix + model.contig_id,    # Sets DOI suffix to be the Fluxx contig_id.                      
  '<<resource>>' => _resource_prefix + model.project_title.downcase.gsub(/[^a-z0-9]/,' ').squeeze(' ').strip.gsub(' ','-') # Sets URL suffix to be lower-case project title with dashes between words.
  }


# Cleanup and Encoding:

_final = _template                                                      # Starts with the "template" above.
_substitutions.each do |_key, _value|                                   # Loops through all substitutions.
  _value = (_value === nil) ? '' : _value                               # Converts nil values to empty strings.
  _final = _final.gsub(_key, _value.to_s.strip.encode(:xml => :text))   # Ensures that values are xml-encoded.
end
  

#########################################
# Step 2: Send the XML file to Crossref #
#########################################

uri = URI('https://test.crossref.org/servlet/deposit')
request = Net::HTTP::Post.new(uri)
form_data = [
  ['operation','doMDUpload'],
  ['login_id',ERB::Util.url_encode(_login_name)],
  ['login_passwd',ERB::Util.url_encode(_login_password)],
  ['fname',_final, {filename: 'fname'}]
]

request.set_form form_data, 'multipart/form-data'
response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
  http.request(request)
end


#######################################
# Step 3: Save this DOI info in Fluxx #
#######################################

if response.body.include? 'Your batch submission was successfully received'
  model.crossref_doi = _funder_doi_prefix + model.contig_id
  model.crossref_confirmation = "Send Successful"
  "Success with batch " + _doi_batch_id
else
  model.crossref_doi = ""
  model.crossref_confirmation = "Send Failed"
  "Failure with batch " + _doi_batch_id
end