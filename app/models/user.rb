class User < ActiveRecord::Base
  before_validation :check_role
  validates :username, presence: true
  acts_as_voter
  has_many :visits, class_name: "Ahoy::Visit"
  has_many :events, class_name: "Ahoy::Event"
  has_many :favorites
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable,
         :omniauthable, omniauth_providers: [:twitter]
  enum gender_types: { 
      not_telling: 0,
      male: 1,
      female: 2,
      other: 3
      }
  enum font_types: {
    Grey: "#808080",
    Blue: "#0000ff", 
    Yellow: "#ffff00", 
    Green: "#66ff66", 
    Fuchsia: "#ff00ff", 
    Red: "#ff0000"
  }
      
  def self.create_from_provider_data(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      puts(auth)
      user.username = auth.info.nickname
      user.first_name  = auth.info.name              # assuming the user model has a name
      if auth.info.mail != nil
        user.email = auth.info.email
      else
        user.email = ""
      end
      user.password = Devise.friendly_token[0, 20].first(8)
      user.provider = auth.provider
      if auth.info.description != nil
        user.bio = auth.info.description
      end
      # If you are using confirmable and the provider(s) you use validate emails, 
      # uncomment the line below to skip the confirmation emails.
      user.skip_confirmation!
      if auth.info.image != nil
        user.providerimg = auth.info.image
      end
    end
  end

  def email_required?
    super && provider.blank?
  end

  def active_for_authentication?
    super && !self.banned?
  end

  def inactive_message
    active_for_authentication? ? super : :locked
  end

  private

  def check_role
    unless self.role == "A" || self.role == "M" || self.role == "U"
      self.update(role: "U")
    end
  end
end
  
