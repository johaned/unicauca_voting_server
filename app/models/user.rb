class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,               type: String
  field :username,           type: String
  field :password_encrypted, type: String

  has_one :session_manager

  validates :username, :uniqueness => true

  # It sets a new real password as a password encrypted
  #
  # @param password [String]
  def password=(password)
    self.password_encrypted = Digest::SHA1.hexdigest password
  end

  # It sets a new password encrypted
  #
  # @param password_encrypted [String], password encrypted must be using SHA1 algorithm
  def password_encrypted=(password_encrypted)
    if /^\b([a-f0-9]{40})\b/ === password_encrypted
      self[:password_encrypted] = password_encrypted
    else
      raise 'password must be encrypted in SHA1'
    end
  end
end
