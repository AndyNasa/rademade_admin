class RademadeAdmin::Login

  def self.admin(params)
    params.require( :data ).permit([:email, :password])
    user = User.where(:email => params[:data][:email]).first
    error('There is no users with such email', :email) unless user.is_a? User
    error('Incorrect password', :password) unless user.valid_password? params[:data][:password]
    error('Access denied', :email) unless user.admin?
    user
  end

  def self.error(message, field)
    raise Error.new( message, field )
  end

end