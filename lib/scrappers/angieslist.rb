class AngiesList < AbstractScrapper
  # https://business.angieslist.com/Registration/SimpleRegistration.aspx plus parametres for POST HTTP request
  # Search by:
  # - Business name & Zip

  def execute
    businessFound = {'status' => :unlisted}

    url = "https://business.angieslist.com/Registration/SimpleRegistration.aspx"
    agent = Mechanize.new
    agent.get(url)

    search_list = agent.post(url, {
      'ctl00%24ContentPlaceHolderMainContent%24SimpleRegistrationWizard%24AddCompanyControl%24CompanyContactLastName' => '',
      'ctl00%24ContentPlaceHolderMainContent%24SimpleRegistrationWizard%24AddCompanyControl%24CompanyContactFirstName' => '',
      'ctl00%24ContentPlaceHolderMainContent%24SimpleRegistrationWizard%24AddCompanyControl%24CompanyEmail' => '',
      'ctl00%24ContentPlaceHolderMainContent%24SimpleRegistrationWizard%24AddCompanyControl%24CompanyPhone' => '',
      'ctl00%24ContentPlaceHolderMainContent%24SimpleRegistrationWizard%24AddCompanyControl%24CompanyPostalCode' => '',
      'ctl00%24ContentPlaceHolderMainContent%24SimpleRegistrationWizard%24AddCompanyControl%24CompanyState' => '',
      'ctl00%24ContentPlaceHolderMainContent%24SimpleRegistrationWizard%24AddCompanyControl%24CompanyCity' => '',
      'ctl00%24ContentPlaceHolderMainContent%24SimpleRegistrationWizard%24AddCompanyControl%24CompanyAddress' => '',
      'ctl00%24ContentPlaceHolderMainContent%24SimpleRegistrationWizard%24AddCompanyControl%24CompanyName' => '',
      'ctl00%24ContentPlaceHolderMainContent%24SimpleRegistrationWizard%24fakeTargetId' => '',
      'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_AddCompanyControl_CategorySelections_rightlstbox_REMOVED' => '',
      'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_AddCompanyControl_CategorySelections_rightlstbox_ADDED' => '',
      'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_AddCompanyControl_CategorySelections_leftlstbox_REMOVED' => '',
      'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_AddCompanyControl_CategorySelections_leftlstbox_ADDED' => '',
      '__LASTFOCUS' => '',
      '__EVENTARGUMENT' => '',
      '__VIEWSTATE_KEY' => agent.page.forms[0]['__VIEWSTATE_KEY'],
      '__EVENTTARGET' => "ctl00$ContentPlaceHolderMainContent$SimpleRegistrationWizard$FindCompanyControl$SearchByNameSubmitButton",
      'ctl00$ContentPlaceHolderMainContent$SimpleRegistrationWizard$FindCompanyControl$CompanyName' => "#{@data['business']}", 
      'ctl00$ContentPlaceHolderMainContent$SimpleRegistrationWizard$FindCompanyControl$CompanyZip'=> "#{@data['zip']}"
    })

    search_list.search("tbody.scrollContent tr").each do |item|
      next unless item.search(".//td[3]/span").text =~ /#{@data['business']}/i

      businessFound['status'] = :listed
      businessFound['listed_name'] = item.search(".//td[3]/span")[0].content.strip
      businessFound['listed_address'] = item.search(".//td[6]/span")[0].content.strip
      businessFound['listed_phone'] = item.search(".//td[5]/span")[0].content.strip
      businessFound['listed_url'] = ''

      return businessFound
    end

    businessFound
  end
  
end
