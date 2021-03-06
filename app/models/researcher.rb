class Researcher
  include Mongoid::Document
  rolify
  include Mongoid::Slug
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  after_create :assign_role

  has_and_belongs_to_many :papers


  devise :database_authenticatable, :registerable, :validatable#,:confirmable,:recoverable,:omniauthable, :omniauth_providers => [:gplus]

  #, :rememberable, :trackable

  ## Database authenticatable
  field :email,              type: String, default: ""
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  #field :reset_password_token,   type: String
  #field :reset_password_sent_at, type: Time

  ## Rememberable
  #field :remember_created_at, type: Time

  ## Trackable
  #field :sign_in_count,      type: Integer, default: 0
  #field :current_sign_in_at, type: Time
  #field :last_sign_in_at,    type: Time
  #field :current_sign_in_ip, type: String
  #field :last_sign_in_ip,    type: String

  ## Confirmable
  #field :confirmation_token,   type: String
  #field :confirmed_at,         type: Time
  #field :confirmation_sent_at, type: Time
  #field :unconfirmed_email,    type: String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time


  #field :_id, type: String, default: ->{ username }
  field :general_info,         type:String
  field :phone,                type:String
  field :address,              type:String
  field :birthdate,            type:Date
  ## Lockable
  # field :failed_attempts, type: Integer, default: 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    type: String # Only if unlock strategy is :email or :both
  # field :locked_at,       type: Time


  #field :_id, type: String, default: ->{ username }

  mount_uploader :avatar,AvatarUploader
  field :description
  field :address  
  field :websiteurl
  field :username, type: String
  slug :username
  field :provider,type: String
  field :uid,type: String
  field :likes ,type: Array

  #index({email: 1},{unique: true})
  #index({username: 1},{unique: true})
  #index({likes: 1})
  def self.new_with_session(params, session)
    super.tap do |researcher|
      if data = session["devise.gplus"] && session["devise.gplus"]["extra"]["raw_info"]
        researcher.email = data["email"] if researcher.email.blank?
      end
    end
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |researcher|
      researcher.email = auth.info.email
      researcher.password = Devise.friendly_token[0,20]
    end
  end

  def assign_role
    self.add_role "researcher"
  end

end
