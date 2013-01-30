class User < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation
  validates :name, presence: true, uniqueness: true
  has_secure_password

  # If after we’ve deleted the user, there are no users left in the
  #database, we will roll the transaction back (raising an exception does that), restoring the user we just deleted.
  after_destroy :ensure_an_admin_remains

  private
  def ensure_an_admin_remains
    if User.count.zero?
      raise "Can't delete last user"
    end
  end

end