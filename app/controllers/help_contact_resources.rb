class MdaApi < Sinatra::Base

  get '/help_contacts' do
      @help_contacts = HelpContact.where({})
      @help_contacts = @help_contacts.where(application: params[:application]) unless params[:application].blank?
      @help_contacts.to_json( { only: [:contact_name, :phone ] }  )
  end

end
