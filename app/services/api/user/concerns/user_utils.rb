require 'active_support/concern'

module API::User::Concerns::UserUtils
  extend ActiveSupport::Concern

  included do
  end

  class_methods do

    def find_user(args={})
      [Customer, Vendor].find do |klass|
        user = klass.find_by(args)
        break(user) if user.present?
      end
    end

  end

  def user_by_token_or_email(token, email, options={})
    klass = options.fetch(:klass, Customer)

    relation = klass.joins(:http_token).references(:http_tokens)

    relation.where(http_tokens: { key: token }).or(
    relation.where(email: email)).
    first
  end

  def user_by_email(email, options={})
    klass = options.fetch(:klass, Customer)
    klass.find_by(email: email)
  end

end