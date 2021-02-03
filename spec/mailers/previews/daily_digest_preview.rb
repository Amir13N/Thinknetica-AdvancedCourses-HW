# Preview all emails at http://localhost:3000/rails/mailers/daily_digest
class DailyDigestPreview < ActionMailer::Preview
  def digest(user)
    mail to: user.email
  end
end
