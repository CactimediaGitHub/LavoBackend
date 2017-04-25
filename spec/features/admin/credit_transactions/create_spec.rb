require "rails_helper"

feature 'Create new credit transaction' do
  let!(:customer) { create(:customer, name: 'Name', surname: 'Surname') }

  before(:each) do
    visit admin_credit_transactions_path
  end

  scenario 'user can create Credit Transaction' do
    click_link('New credit transaction')
    select "#{customer.full_name}", from: "credit_transaction[customer_id]"
    fill_in 'credit_transaction[amount]', with: '10.05'
    fill_in 'credit_transaction_note', with: 'Some text'
    find('input[type="submit"]').click

    expect(page).to have_content 'CreditTransaction was successfully created.'
    expect(page).to have_content 'New credit transaction'
    expect(page).to have_content '10.05 AED'
    expect(CreditTransaction.last.amount).to eq 1005
  end
end
