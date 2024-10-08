class User < ApplicationRecord
  validates :email, presence: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/ }
  validates :password, presence: true, if: :password_required?
  validate :password_length, if: -> { password.present? }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :facebook, :google_oauth2, :github ]

  has_many :carts
  has_many :orders

  def self.get_user_from_session(session)
    if session[:user_id]
      @user = User.find_by(id: session[:user_id])
      return @user if @user
    end
  end

  def self.from_omniauth(auth)
    user =  User.where(provider: auth.provider, uid: auth.uid, email: auth.info.email).first_or_initialize
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      if auth.provider == 'github'
        user.first_name = auth.info.name.split.first
        user.last_name = auth.info.name.split.last
      else
        user.first_name = auth.info.first_name
        user.last_name = auth.info.last_name
      end
      user.avatar_url = auth.info.image
    if user.valid?
      user.save!
      user
    else
        user.errors.messages
    end
  end

  def generate_password_reset_token
    self.reset_password_token = SecureRandom.urlsafe_base64
    self.reset_password_sent_at = Time.zone.now
    save!
  end

  def password_reset_expired?
    reset_password_sent_at.present? && reset_password_sent_at < 2.hours.ago
  end

  private

  def password_required?
    new_record? || password.present?
  end

  def password_length
    errors.add(:password, 'is too short (minimum is 6 characters)') if password.length < 6
  end
end
