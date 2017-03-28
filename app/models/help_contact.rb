class HelpContact < ActiveRecord::Base

  validates :application, :contact_name, :phone, presence: true

end
