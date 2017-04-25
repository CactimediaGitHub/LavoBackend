require 'immigrant'

Immigrant.ignore_keys = [
  { from_table: 'reviews', column: 'reviewer_id' },
  { from_table: 'reviews', column: 'reviewable_id' },
  { from_table: 'shippings', column: 'address_id' },
  { from_table: 'payments', column: 'order_id' },
  { from_table: 'payments', column: 'vendor_id' },
]