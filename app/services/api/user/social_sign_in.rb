class API::User::SocialSignIn
  include ActiveModel::Model
  include API::User::Concerns::UserUtils

  attr_accessor :token, :user

  def initialize(args={})
    super
    @graph = Koala::Facebook::API.new(token)
    @token_generator = args.fetch(:token_generator, ::TokenGenerator)
  end

  validates :token, presence: true
  validate :token_validity

  def performed?
    get_social_profile &&
    validate &&
    update_or_create_user
  end

  private
  attr_reader :token_generator, :graph
  attr_accessor :social_profile, :token_invalid

  # OPTIMIZE: consider storing avatar url not as remote attachment for speed reasons, include remote avatar url if avatar present in the graph
  def get_social_profile
    avatar_url =
      graph.get_picture_data(:me, type: :large).fetch("data")&.fetch("url")
    fb_user = graph.get_object(:me, fields: %w(id email first_name last_name))

    self.social_profile =
      { name: fb_user["first_name"],
        surname: fb_user["last_name"],
        email: fb_user_email(fb_user) ,
        remote_avatar_url: avatar_url }
  rescue Koala::Facebook::AuthenticationError
    self.token_invalid = true
  end

  def fb_user_email(fb_user)
    fb_user["email"] || (fb_user["id"] + '@facebook.com')
  end

  def update_or_create_user
    self.user = user_by_email(social_profile[:email])

    if user
      updates = social_profile.merge(http_token: HttpToken.new)
      user.update(updates)
    else
      self.user =
        build_with_social(social_profile) do |u|
          u.http_token = HttpToken.new
          u.activated = true
        end

      user.save
    end
  end

  def build_with_social(profile, options={}, &block)
    klass = options.fetch(:klass, Customer)
    user =
      klass.new(social_profile) do |u|
        u.password = u.password_confirmation = token_generator.password
        block.call(u)
      end
    user
  end

  def token_validity
    errors.add(:token, :invalid_token) if token_invalid
  end

end
