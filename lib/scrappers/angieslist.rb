class Angieslist < AbstractScrapper

  def search_business(data)
    Watir::Wait.until {watir.div(:class , 'RegistrationLightbox').exist? }
    result_count = watir.table(:class, 'wide100percent').rows.length

    for n in 1...result_count
      result = watir.table(:class, 'wide100percent')[n].text
      if result.include?(data[ 'business' ])
        watir.table(:class, 'wide100percent')[n].image(:alt,'Select').click
        matching_result = true
        break
      end
    end
    return matching_result
  end

  def execute
    #page_url = 'https://business.angieslist.com/Registration/SimpleRegistration.aspx'
    #form_page = agent.get(page_url)
    #search_form = form_page.form('aspnetForm')
    #search_form.field_with(:name => "ctl00$ContentPlaceHolderMainContent$SimpleRegistrationWizard$FindCompanyControl$CompanyName").value = @data['business']
    #search_form.field_with(:name => "ctl00$ContentPlaceHolderMainContent$SimpleRegistrationWizard$FindCompanyControl$CompanyZip").value = @data['zip']
    #
    #search_results = search_form.submit()
    #puts search_results.body
    #
    ##'__EVENTTARGET' => 'ctl00$ContentPlaceHolderMainContent$SimpleRegistrationWizard$FindCompanyControl$SearchByNameSubmitButton',
    #return {
    #    'status' => :listed
    #}

    # OLD
    watir.goto( 'https://business.angieslist.com/Registration/Registration.aspx' )
    watir.text_field(:id => /CompanyName/).set data[ 'business' ]
    watir.text_field(:id => /CompanyZip/).set data[ 'zip' ]
    watir.image(:alt,'Search').click
    Watir::Wait.until { watir.div(:id => 'ctl00_ContentPlaceHolderMainContent_SimpleRegistrationWizard_SelectCompanyControl_SelectACompanyContainer') }
    @error_msg = watir.span(:class,'errortext')

    if search_business(data)
      return {
          'status' => :listed
      }
      businessFound = [:listed,:unclaimed]
    else
      businessFound = [:unlisted]
    end

    [true, businessFound]

  end
end