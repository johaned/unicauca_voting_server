class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name,               type: String
  field :username,           type: String
  field :password_encrypted, type: String

  def password=(password)
    self.password_encrypted = Digest::SHA1.hexdigest password
  end

  def password_encrypted=(encrypted_password)
    if /^\b([a-f0-9]{40})\b/ === encrypted_password
      self[:password_encrypted] = encrypted_password
    else
      raise 'password must be encrypted in SHA1'
    end
  end
end
