# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  first_name                 :string(60)
#  last_name                  :string(60)
#  email                      :string(80)       default(""), not null
#  encrypted_password         :string(255)      default(""), not null
#  password_salt              :string(255)
#  reset_password_token       :string(255)
#  reset_password_sent_at     :datetime
#  remember_created_at        :datetime
#  sign_in_count              :integer          default(0)
#  current_sign_in_at         :datetime
#  last_sign_in_at            :datetime
#  current_sign_in_ip         :string(255)
#  last_sign_in_ip            :string(255)
#  confirmation_token         :string(255)
#  confirmed_at               :datetime
#  confirmation_sent_at       :datetime
#  unconfirmed_email          :string(255)
#  failed_attempts            :integer          default(0)
#  locked_at                  :datetime
#  profile_image_file_name    :string(255)
#  profile_image_content_type :string(255)
#  profile_image_file_size    :integer
#  profile_image_updated_at   :datetime
#  profile_image_fingerprint  :string(255)
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#

class User < ActiveRecord::Base
  include AttachableFile
  include Uuidable
  
  # ---------------------------------------------------------------------------------
  # Authentication
  # ---------------------------------------------------------------------------------
  devise  :database_authenticatable, :trackable, :validatable, :lockable,
          :registerable, :recoverable, :confirmable, :rememberable, #:omniauthable,
          :lock_strategy => :failed_attempts, :unlock_strategy => :time, :maximum_attempts => 5, :unlock_in => 5.seconds,   # lockable
          :remember_for => 1.week, :extend_remember_period => true,                                                         # rememberable
          :allow_unconfirmed_access_for => 3.days                                                                          # confirmable
          # :omniauth_providers => []                                                                                         # omniauth
         
         

  # ---------------------------------------------------------------------------------
  # Attributes
  # ---------------------------------------------------------------------------------
  attr_accessible   :email, :first_name, :last_name, :password, :password_confirmation, :remember_me, :profile_image
  
  has_public_id :public_id, prefix:'MEM', length:20
  
  has_attachable_file :profile_image, :path => ':rails_env/:class/:attachment/:id/:hash.:extension',
                      :hash_data => ":class/:attachment/:id/:fingerprint-:style",
                      :s3_host_alias => AppConfig.domains.media_cdn,
                      :styles => { 
                        :medium => { geometry: "300x300>", format: 'jpg', convert_options: "-strip" }, 
                        :thumb  => { geometry: "100x100>", format: 'jpg', convert_options: "-strip" }}

  
  
  # ---------------------------------------------------------------------------------
  # Associations
  # ---------------------------------------------------------------------------------
  has_many :block_requests,                                     inverse_of: :requester
  has_many :groups,            :through => :group_memberships#,  inverse_of: :members
  has_many :group_memberships, :dependent => :destroy,          inverse_of: :member do
    
    # association wrapped in #membership_in(group)
    def for_group(group)
      group_id = group.is_a?( Group ) ? group.id : group
      where(group_id:group_id).first
    end
  end 
  
  # ---------------------------------------------------------------------------------
  # Validations
  # ---------------------------------------------------------------------------------
  validates_presence_of :email, :first_name, :last_name
  validates_length_of   :email, :within => 0..80
  validates_format_of   :email, :with => /.+@.+\..+/, :message => "looks wrong" #anything@anything.anything
  validates_length_of   :first_name, :last_name, :within => 0..60
  validates_attachment  :profile_image, :size => { :in => 0..10.megabytes }
    #, :presence => true,
    # :content_type => { :content_type => "image/jpg" }
    
    
  # ---------------------------------------------------------------------------------
  # Scopes
  # ---------------------------------------------------------------------------------
  
  
  
  # ---------------------------------------------------------------------------------
  # Methods
  # ---------------------------------------------------------------------------------
  
  def name
    "#{first_name} #{last_name}"
  end
  
  # returns a GroupMembership
  def membership_in(group)
    group_memberships.for_group(group)
  end
end
