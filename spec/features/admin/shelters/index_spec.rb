require 'rails_helper'

RSpec.describe 'the admin shelters index' do
  it 'lists all the shelters in reverse alphabetical order by name' do
    shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter2 = Shelter.create(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 10)
    shelter3 = Shelter.create(name: 'Arvada shelter', city: 'Arvada, CO', foster_program: false, rank: 7)
    
    visit '/admin/shelters'

    expect(shelter2.name).to appear_before(shelter1.name)
    expect(shelter1.name).to appear_before(shelter3.name)
  end
  
  it 'lists all the shelters with pending applications' do
    shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter2 = Shelter.create(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 10)
    pet1 = Pet.create!(name: 'Joey', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter1.id)
    application = Application.create!(name: 'Andrew',
      street_address: '112 Greenbrook',
      city: 'Denver',
      state: 'CO',
      zipcode: '80207',
      description: 'Happy, friendly, cool',
      status: 'Pending',
    )
    application_pet = ApplicationPet.create!(application_id: application.id, pet_id: pet1.id)
    
    visit '/admin/shelters'
    expect(page).to have_content("Shelters with Pending Applications")
    within "#shelters_with_pending_applications" do
      expect(page).to have_content('Aurora shelter')
      expect(page).to_not have_content('Denver shelter')
    end
  end
  
  it 'has links to each shelter' do
    shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    shelter2 = Shelter.create(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 10)
    
    visit '/admin/shelters'
    click_link "Aurora shelter"
    expect(current_path).to eq("/admin/shelters/#{shelter1.id}")
    
    visit '/admin/shelters'
    click_link "Denver shelter"
    expect(current_path).to eq("/admin/shelters/#{shelter2.id}")
  end

  it 'lists all the shelters with pending applications alphabetically' do
    shelter2 = Shelter.create(name: 'Denver shelter', city: 'Denver, CO', foster_program: true, rank: 10)
    shelter1 = Shelter.create(name: 'Aurora shelter', city: 'Aurora, CO', foster_program: false, rank: 9)
    pet1 = Pet.create!(name: 'Joey', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter1.id)
    application1 = Application.create!(name: 'Andrew',
      street_address: '112 Greenbrook',
      city: 'Denver',
      state: 'CO',
      zipcode: '80207',
      description: 'Happy, friendly, cool',
      status: 'Pending',
    )
    pet2 = Pet.create!(name: 'Bear', age: 2, breed: 'Poodle', adoptable: true, shelter_id: shelter2.id)
    application2 = Application.create!(name: 'Andrew',
      street_address: '112 Greenbrook',
      city: 'Denver',
      state: 'CO',
      zipcode: '80207',
      description: 'Happy, friendly, cool',
      status: 'Pending',
    )
    application_pet1 = ApplicationPet.create!(application_id: application1.id, pet_id: pet1.id)
    application_pet2 = ApplicationPet.create!(application_id: application2.id, pet_id: pet2.id)
    
    visit '/admin/shelters'
    expect(page).to have_content("Shelters with Pending Applications")
    within "#shelters_with_pending_applications" do
      expect('Aurora shelter').to appear_before('Denver shelter')
    end
  end
end