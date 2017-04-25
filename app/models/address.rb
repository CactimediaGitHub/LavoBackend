class Address < ApplicationRecord
  include FilterablePgSearchScope

  belongs_to :customer

  validates :address1, :city, :human_name, presence: true
  validate :country_is_iso_compliant

  pg_search_scope(:search,
    against: [:address1, :address2, :city, :country, :nearest_landmark],
    associated_against: {
      customer: [:name, :surname],
    },
  )

  def self.permitted_attributes
    %i(id address1 address2 city country nearest_landmark human_name)
  end

  def to_s
    "#{address1}, #{address2}, #{nearest_landmark} #{city}, #{country}"
  end

  private

  def country_is_iso_compliant
    # TODO: i18n
    errors.add(:country, 'must be 2 characters (ISO 3166-1)') unless ISO3166::Country[country]
  end
end
