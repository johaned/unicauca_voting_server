class SessionManager
  include Mongoid::Document
  include Mongoid::Timestamps

  field :token,              type: String
  field :devices_authorized, type: Array, default: []

  belongs_to :user

  validates :token, :uniqueness => true

  # Queries the current user using token and user_agent fields
  #
  # @param token [String]
  # @param user_agent [String]
  #
  # @return [User], if token and user_agent params don't match ocurrencies
  # this method returns a nil object
  def self.current_user(token, user_agent)
    self.where(token: token, :devices_authorized.in => [user_agent]).try(:first).try(:user)
  end

  # defines a flow to authenticate and associate a SessionManager instance with
  # the current user account. Also, it pushes a device only if it is not already
  # referenced
  #
  # @param username [String]
  # @param password [String]
  # @param user_agent [String], device that user connects
  #
  # @return [Hash], with result of process
  # e.g.
  # {
  #  code: 200,
  #  msg: 'session was approved successfully',
  #  token: 'WnMqJzPxBsIdokijwcKKUIXopnFhqWzFVnUxYTfiRGOoTnKurO'
  # }
  def self.authenticate(username, password, user_agent)
    response = {}
    user = user_account username, password
    if user.present?
      session_manager = user.session_manager.present? ? user.session_manager : associate_token(user)
      session_manager.associate_user_agent user_agent
      response[:code] = 200
      response[:msg] = 'session was approved successfully'
      response[:token] = session_manager.token
    else
      response[:code] = 401
      response[:msg] = 'session was rejected'
    end
    response
  end

  # associates a new device to session manager only if this is not already associated
  #
  # @param user_agent [String], device's name related to new session
  def associate_user_agent(user_agent)
    update_attribute(:devices_authorized, self.devices_authorized << user_agent) unless self.devices_authorized.try(:include?, user_agent)
  end

  # Checks if username:password pair exists
  #
  # @param username [string]
  # @param password [String]
  #
  # @return [User]
  def self.user_account(username, password)
    password_encrypted = Digest::SHA1.hexdigest password
    User.where(username: username, password_encrypted: password_encrypted).first
  end

  # creates a new session manager for User account
  #
  # @param user [User]
  #
  # @return [SessionManager]
  def self.associate_token(user)
    user.create_session_manager(token: generate_token)
  end

  # Generates a new unique token
  #
  # @return [String]
  def self.generate_token
    input = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
    token = (0...50).map { input[rand(input.length)] }.join
    generate_token if self.where(token: token).exists?
    token
  end

end
