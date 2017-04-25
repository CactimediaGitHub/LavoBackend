require "rails_helper"

feature 'Create new credit transaction' do
  let!(:vendor1) { create(:vendor, name: 'Vendor 1', activated: true) }
  let!(:vendor2) { create(:vendor, name: 'Vendor 2', activated: false) }
  let!(:vendor3) { create(:vendor, name: 'Vendor 3', activated: true) }
  let!(:vendor4) { create(:vendor, name: 'false', activated: false) }

  before(:each) do

  end

  scenario 'search term present filters present' do
    visit admin_vendors_path(search: 'Vendor 3', filter: { activated: true })

    expect(page).to have_content('Vendor 3')
    expect(page).not_to have_content('Vendor 1')
    expect(page).not_to have_content('Vendor 2')
  end

  scenario 'search term present filters blank' do
    visit admin_vendors_path(search: 'Vendor 3')

    expect(page).to have_content('Vendor 3')
    expect(page).not_to have_content('Vendor 1')
    expect(page).not_to have_content('Vendor 2')
  end

  scenario 'search term blank filters present' do
    visit admin_vendors_path(filter: { activated: true })

    expect(page).to have_content('Vendor 1')
    expect(page).to have_content('Vendor 3')
    expect(page).not_to have_content('Vendor 2')
    expect(page).not_to have_content('false')
  end

  scenario 'search term "false" filters false' do
    visit admin_vendors_path(search: false, filter: { activated: false })

    expect(page).to have_content('false')
    expect(page).not_to have_content('Vendor 1')
    expect(page).not_to have_content('Vendor 2')
    expect(page).not_to have_content('Vendor 3')
  end


end