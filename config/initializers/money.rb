require 'money'

curr = {
  priority:        100,
  iso_code:        "AED",
  iso_numeric:     "784",
  name:            "United Arab Emirates dirham",
  symbol:          "AED",
  subunit:         "Cent",
  subunit_to_unit: 100,
  separator:       ".",
  delimiter:       ","
}

Money::Currency.register(curr)
Money.default_currency = Money::Currency.new("AED")
