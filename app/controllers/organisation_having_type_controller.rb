class OrganisationHavingTypeController < ApplicationController

  def index
    organisation = params[:organisation]
    @organisation = Organisation.find( organisation )
    
    @organisation_types = OrganisationType.find_by_sql(
      [
        "
          SELECT ot.*
          FROM organisation_types ot, organisation_typings ott
          WHERE ot.id = ott.organisation_type_id
          AND ott.organisation_id = ?
          ORDER BY ot.label
        ", @organisation
      ]
    )
    
    respond_to do |format|
      format.csv {
        csv_response_headers( "#{@organisation.label} organisation types" )
      }
      format.html {
      
        @parent_organisation = Organisation.find( @organisation.parent_organisation_id ) if @organisation.parent_organisation_id
    
        @page_title = "#{@organisation.label} - organisation types"
        @multiline_page_title = "#{@organisation.label} <span class='subhead'>Organisation types</span>".html_safe
        @description = "#{@organisation.label} organisation types."
        @csv_url = organisation_having_type_list_url( :format => 'csv' )
        @crumb << { label: 'Organisations', url: organisation_list_url }
        @crumb << { label: @organisation.label, url: organisation_show_url }
        @crumb << { label: 'Types', url: nil }
        @section = 'organisations'
        @subsection = 'types'
      }
    end
  end
end
