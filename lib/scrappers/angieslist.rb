class AngiesList < AbstractScrapper
  # https://business.angieslist.com/Registration/SimpleRegistration.aspx plus parametres for POST HTTP request
  # Request:
  # - Business name
  # - ZIP
  # Sort:
  # - Business name
  # - ZIP
  # - Business phone number

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
      next unless match_name?(item.search(".//td[3]/span"), @data['business'])

      # Sort by business phone number
      businessPhone = item.search(".//td[5]/span").text.strip
      if !@data['phone'].blank?
        next unless  phone_form(@data['phone']) == phone_form(businessPhone)
      end

      return {
        'status' => :listed,
        'listed_name' => item.search(".//td[3]/span").text.strip,
        'listed_address' => item.search(".//td[6]/span").text.strip,
        'listed_phone' => businessPhone,
        'listed_url' => ''
      }
    end

    return {'status' => :unlisted}
  end
  
end
