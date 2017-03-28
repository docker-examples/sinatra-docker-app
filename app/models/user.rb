require 'bcrypt'
require 'rqrcode'
class User < ActiveRecord::Base
  APPLICATIONS = [ 'CampLeader', 'Staff', 'StaffMonitoring' ]
  TOKEN_LIFE = 15 * 60 #token valid for 15 minutes or logout event
  STATUS = { present: 'Present', not_in_place: 'Not In Place', absent: 'Absent' }

  mount_uploader :profile_photo, AvatarUploader

  
  validates :username, :role, presence: true
  validates :username, uniqueness: true, allow_blank: true
  validates :username, format: { without: /\s/,
                                 message: 'blank spaces are not allowed.' }, allow_blank: true
  validates :password, :confirmation => true
  validates :password, length: { :in => 6..20 }, :on => :create
  validates :national_id, uniqueness: true, allow_blank: true
  validates :application, inclusion: { in: APPLICATIONS,
            message: "status must be inclusive of [#{APPLICATIONS.join(', ')}]" }
 
  before_save :encrypt_password

  scope :token_expired, -> { where('expires <= ?', Time.zone.now.to_i) }
  scope :for_app, -> (app) { where( application: app ) } #TODO needs clerification

  
  def self.authenticate(username, password)
    user = find_by(username: username)
    if user && user.encrypted_password == BCrypt::Engine.hash_secret(password, user.salt)
      return user
    else
      return nil
    end
  end


  def qr_code_url
     HOST_PATH + "qr_code/#{self.id()}.png"
  end

  def logged_in?
    !self.access_token.blank? && !self.token_expired?
  end


  # Prepares the object before save
  def generate_token
    self.status = STATUS[:present]
    self.access_token = SecureRandom.urlsafe_base64(45, true)
    self.expires = Time.zone.now.to_i + TOKEN_LIFE
    self.login_time = Time.zone.now
    self.user_events.build(event_name: 'Login', event_time: Time.zone.now)
    save
    self.access_token
  end

# Prepares the object before save
  def refresh_time
    self.update_column( :expires, Time.zone.now + TOKEN_LIFE )
  end

# Prepares the object before save
  def logout
    self.status = STATUS[:absent]
    self.logout_time = Time.zone.now
    self.access_token = nil
    self.expires = Time.zone.now.to_i - 60
    self.user_events.build(event_name: 'Logout', event_time: Time.zone.now)
    save
  end

  # Check is the token has expires
  def token_expired?
    self.expires < Time.zone.now.to_i
  end

  def generate_qr_code
    if self.name
      qrcode = RQRCode::QRCode.new(self.name)
      png = qrcode.as_png()
      file_path = "public/qr_code/#{self.id()}.png"
      IO.write(file_path, png.to_s)
      update_column :qr_code, "qr_code/#{self.id()}.png"
    end
  end


private
  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.encrypted_password= BCrypt::Engine.hash_secret(password, salt)
    end
  end

end
