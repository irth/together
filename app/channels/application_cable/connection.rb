module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    def connect
      self.current_user = find_user
    end

    private

    def find_user
      if token = AuthToken.find_by(token: cookies[:token])
        token.user
      else
        reject_unauthorized_connection
      end
    end
  end
end
