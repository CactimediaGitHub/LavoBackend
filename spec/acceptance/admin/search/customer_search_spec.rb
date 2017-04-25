require "rails_helper"

feature 'Create new credit transaction' do
  let!(:customer1) do
    create(:customer, name: 'customer 1', activated: true)
  end
  let!(:customer2) { create(:customer, name: 'customer 2', activated: false) }
  let!(:customer3) { create(:customer, name: 'customer 3', activated: true) }
  let!(:customer4) { create(:customer, name: 'false', activated: false) }

  scenario 'search term present filters present' do
    visit admin_customers_path(search: 'customer 3', filter: { activated: true })

    expect(page).to have_content('customer 3')
    expect(page).not_to have_content('customer 1')
    expect(page).not_to have_content('customer 2')
  end

  scenario 'search term present filters blank' do
    visit admin_customers_path(search: 'customer 3')

    expect(page).to have_content('customer 3')
    expect(page).not_to have_content('customer 1')
    expect(page).not_to have_content('customer 2')
  end

  scenario 'search term blank filters present' do
    visit admin_customers_path(filter: { activated: true })

    expect(page).to have_content('customer 1')
    expect(page).to have_content('customer 3')
    expect(page).not_to have_content('customer 2')
    expect(page).not_to have_content('false')
  end

  scenario 'search term "false" filters false' do
    visit admin_customers_path(search: false, filter: { activated: false })

    expect(page).to have_content('false')
    expect(page).not_to have_content('customer 1')
    expect(page).not_to have_content('customer 2')
    expect(page).not_to have_content('customer 3')
  end


end