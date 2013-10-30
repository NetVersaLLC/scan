class Angieslist < AbstractScrapper

  def search_business
  end

  def execute
    watir.goto( 'https://business.angieslist.com/Registration/SimpleRegistration.aspx' )
    watir.image(:alt,'Search').wait_until_present
    watir.text_field(:id => /CompanyName/).set @data[ 'business' ]
    watir.text_field(:id => /CompanyZip/).set @data[ 'zip' ]
    watir.image(:alt,'Search').click
    watir.div(:class, 'RegistrationLightbox').wait_until_present
    #@error_msg = watir.span(:class,'errortext')


    result_count = watir.table(:class, 'wide100percent').rows.length

    for n in 1...result_count
      result = watir.table(:class, 'wide100percent')[n].text
      if result.include?(@data[ 'business' ])
        watir.table(:class, 'wide100percent')[n].image(:alt,'Select').click
        watir.div(:id, 'Step2of2Title').wait_until_present
        business_data_table = watir.element(:css => '.leftrightpaddedmargin5 table.bold')
        return {
          'status' => :listed,
          'listed_name' => business_data_table.td(:index => 1).text.strip,
          'listed_address' => business_data_table.td(:index => 3).text.strip,
          'listed_phone' => '',
        }
      end
    end
    return {
        'status' => :unlisted
    }
  end
end