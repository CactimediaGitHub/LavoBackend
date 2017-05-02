class ApplicationMailer < ActionMailer::Base
  default from: 'lavo@cactimedia.biz'
  layout 'mailer'
  before_action :initialize_defaults

  private

  def initialize_defaults
    @greeting = "Dear User,"
    @signature = "The Lavo Team"
  end
end
