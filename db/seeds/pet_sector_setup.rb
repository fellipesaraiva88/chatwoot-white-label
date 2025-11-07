# Pet Sector Setup Seeds for Auzap
# This file contains pre-configured data for veterinary clinics, pet shops, and pet service businesses

Rails.logger.info 'Starting Pet Sector setup...'

# Only run if there are accounts in the system
if Account.count.positive?
  Account.find_each do |account|
    Rails.logger.info "Setting up Pet Sector data for account: #{account.name}"

    # ===================================
    # LABELS (Etiquetas para organização)
    # ===================================
    pet_labels = [
      { title: 'vaccination', color: '#10B981', description: 'Vaccination appointments and reminders', show_on_sidebar: true },
      { title: 'emergency', color: '#EF4444', description: 'Pet emergency cases requiring immediate attention', show_on_sidebar: true },
      { title: 'routine-checkup', color: '#3B82F6', description: 'Regular wellness and check-up appointments', show_on_sidebar: true },
      { title: 'grooming', color: '#8B5CF6', description: 'Pet grooming services and appointments', show_on_sidebar: true },
      { title: 'surgery', color: '#F59E0B', description: 'Surgical procedures and post-operative care', show_on_sidebar: true },
      { title: 'dental', color: '#06B6D4', description: 'Dental care and cleaning services', show_on_sidebar: true },
      { title: 'lab-results', color: '#EC4899', description: 'Laboratory test results and follow-up', show_on_sidebar: true },
      { title: 'medication-refill', color: '#6366F1', description: 'Prescription refill requests', show_on_sidebar: false },
      { title: 'pet-boarding', color: '#14B8A6', description: 'Pet hotel and boarding services', show_on_sidebar: false },
      { title: 'training', color: '#F97316', description: 'Pet training and behavior consultation', show_on_sidebar: false },
      { title: 'adoption', color: '#84CC16', description: 'Pet adoption inquiries', show_on_sidebar: false },
      { title: 'nutrition', color: '#A855F7', description: 'Pet nutrition and diet consultation', show_on_sidebar: false },
      { title: 'follow-up', color: '#0EA5E9', description: 'Post-treatment follow-up appointments', show_on_sidebar: true },
      { title: 'new-patient', color: '#22C55E', description: 'New pet patient registration', show_on_sidebar: true }
    ]

    pet_labels.each do |label_attrs|
      label = account.labels.find_or_initialize_by(title: label_attrs[:title])
      label.assign_attributes(label_attrs.except(:title))
      label.save! if label.new_record? || label.changed?
    end

    Rails.logger.info "  ✓ Created #{pet_labels.count} pet-focused labels"

    # ===================================
    # CUSTOM ATTRIBUTES - CONTACT (Tutor/Pet Owner)
    # ===================================
    contact_attributes = [
      {
        attribute_display_name: 'Pet Name',
        attribute_key: 'pet_name',
        attribute_description: 'Name of the pet',
        attribute_display_type: 'text',
        attribute_model: 'contact_attribute'
      },
      {
        attribute_display_name: 'Pet Species',
        attribute_key: 'pet_species',
        attribute_description: 'Species of the pet (Dog, Cat, Bird, etc.)',
        attribute_display_type: 'list',
        attribute_model: 'contact_attribute',
        attribute_values: ['Dog', 'Cat', 'Bird', 'Rabbit', 'Hamster', 'Guinea Pig', 'Reptile', 'Fish', 'Other']
      },
      {
        attribute_display_name: 'Pet Breed',
        attribute_key: 'pet_breed',
        attribute_description: 'Breed of the pet',
        attribute_display_type: 'text',
        attribute_model: 'contact_attribute'
      },
      {
        attribute_display_name: 'Pet Age',
        attribute_key: 'pet_age',
        attribute_description: 'Age of the pet (in years)',
        attribute_display_type: 'number',
        attribute_model: 'contact_attribute'
      },
      {
        attribute_display_name: 'Pet Weight',
        attribute_key: 'pet_weight',
        attribute_description: 'Weight of the pet (in kg)',
        attribute_display_type: 'number',
        attribute_model: 'contact_attribute'
      },
      {
        attribute_display_name: 'Pet Gender',
        attribute_key: 'pet_gender',
        attribute_description: 'Gender of the pet',
        attribute_display_type: 'list',
        attribute_model: 'contact_attribute',
        attribute_values: ['Male', 'Female', 'Neutered Male', 'Spayed Female']
      },
      {
        attribute_display_name: 'Allergies',
        attribute_key: 'pet_allergies',
        attribute_description: 'Known allergies or sensitivities',
        attribute_display_type: 'text',
        attribute_model: 'contact_attribute'
      },
      {
        attribute_display_name: 'Current Medications',
        attribute_key: 'pet_medications',
        attribute_description: 'Current medications the pet is taking',
        attribute_display_type: 'text',
        attribute_model: 'contact_attribute'
      },
      {
        attribute_display_name: 'Last Vaccination Date',
        attribute_key: 'last_vaccination_date',
        attribute_description: 'Date of last vaccination',
        attribute_display_type: 'date',
        attribute_model: 'contact_attribute'
      },
      {
        attribute_display_name: 'Preferred Vet',
        attribute_key: 'preferred_vet',
        attribute_description: 'Preferred veterinarian name',
        attribute_display_type: 'text',
        attribute_model: 'contact_attribute'
      },
      {
        attribute_display_name: 'Pet Insurance',
        attribute_key: 'has_pet_insurance',
        attribute_description: 'Does the pet have insurance?',
        attribute_display_type: 'checkbox',
        attribute_model: 'contact_attribute'
      },
      {
        attribute_display_name: 'Insurance Provider',
        attribute_key: 'insurance_provider',
        attribute_description: 'Name of pet insurance provider',
        attribute_display_type: 'text',
        attribute_model: 'contact_attribute'
      }
    ]

    contact_attributes.each do |attr|
      custom_attr = account.custom_attribute_definitions.find_or_initialize_by(
        attribute_key: attr[:attribute_key],
        attribute_model: attr[:attribute_model]
      )
      custom_attr.assign_attributes(attr.except(:attribute_key, :attribute_model))
      custom_attr.save! if custom_attr.new_record? || custom_attr.changed?
    end

    Rails.logger.info "  ✓ Created #{contact_attributes.count} contact custom attributes"

    # ===================================
    # CUSTOM ATTRIBUTES - CONVERSATION (Atendimento)
    # ===================================
    conversation_attributes = [
      {
        attribute_display_name: 'Service Type',
        attribute_key: 'service_type',
        attribute_description: 'Type of service requested',
        attribute_display_type: 'list',
        attribute_model: 'conversation_attribute',
        attribute_values: ['Consultation', 'Vaccination', 'Surgery', 'Grooming', 'Dental', 'Emergency', 'Lab Test', 'Follow-up', 'Boarding', 'Training']
      },
      {
        attribute_display_name: 'Appointment Date',
        attribute_key: 'appointment_date',
        attribute_description: 'Scheduled appointment date and time',
        attribute_display_type: 'date',
        attribute_model: 'conversation_attribute'
      },
      {
        attribute_display_name: 'Pet Condition',
        attribute_key: 'pet_condition',
        attribute_description: 'Current condition of the pet',
        attribute_display_type: 'list',
        attribute_model: 'conversation_attribute',
        attribute_values: ['Stable', 'Under Observation', 'Critical', 'Recovering', 'Healthy']
      },
      {
        attribute_display_name: 'Assigned Vet',
        attribute_key: 'assigned_vet',
        attribute_description: 'Veterinarian assigned to this case',
        attribute_display_type: 'text',
        attribute_model: 'conversation_attribute'
      },
      {
        attribute_display_name: 'Estimated Cost',
        attribute_key: 'estimated_cost',
        attribute_description: 'Estimated cost of service',
        attribute_display_type: 'currency',
        attribute_model: 'conversation_attribute'
      },
      {
        attribute_display_name: 'Treatment Notes',
        attribute_key: 'treatment_notes',
        attribute_description: 'Notes about treatment or procedure',
        attribute_display_type: 'text',
        attribute_model: 'conversation_attribute'
      },
      {
        attribute_display_name: 'Requires Follow-up',
        attribute_key: 'requires_followup',
        attribute_description: 'Does this case need a follow-up?',
        attribute_display_type: 'checkbox',
        attribute_model: 'conversation_attribute'
      },
      {
        attribute_display_name: 'Follow-up Date',
        attribute_key: 'followup_date',
        attribute_description: 'Date for follow-up appointment',
        attribute_display_type: 'date',
        attribute_model: 'conversation_attribute'
      }
    ]

    conversation_attributes.each do |attr|
      custom_attr = account.custom_attribute_definitions.find_or_initialize_by(
        attribute_key: attr[:attribute_key],
        attribute_model: attr[:attribute_model]
      )
      custom_attr.assign_attributes(attr.except(:attribute_key, :attribute_model))
      custom_attr.save! if custom_attr.new_record? || custom_attr.changed?
    end

    Rails.logger.info "  ✓ Created #{conversation_attributes.count} conversation custom attributes"

    # ===================================
    # CANNED RESPONSES (Respostas Prontas)
    # ===================================
    canned_responses = [
      {
        short_code: 'welcome',
        content: "Hello! 👋 Welcome to our pet care team. How can we help you and your pet today?"
      },
      {
        short_code: 'hours',
        content: "Our clinic hours:\n📅 Monday - Friday: 8:00 AM - 6:00 PM\n📅 Saturday: 9:00 AM - 1:00 PM\n📅 Sunday: Closed\n\n🚨 For emergencies, please call: [EMERGENCY_NUMBER]"
      },
      {
        short_code: 'emergency',
        content: "🚨 For pet emergencies, please call us immediately at [EMERGENCY_NUMBER] or visit our clinic right away. We're here to help!"
      },
      {
        short_code: 'appointment',
        content: "I'd be happy to schedule an appointment for your pet! What date and time works best for you? We have availability:\n• Morning slots: 9:00 AM - 12:00 PM\n• Afternoon slots: 2:00 PM - 5:00 PM"
      },
      {
        short_code: 'vaccination',
        content: "Vaccination schedule for pets:\n🐕 Dogs: DHPP, Rabies, Bordetella, Leptospirosis\n🐈 Cats: FVRCP, Rabies, FeLV\n\nWould you like to schedule a vaccination appointment?"
      },
      {
        short_code: 'pricing',
        content: "Here are our service rates:\n• Consultation: $[PRICE]\n• Vaccination: $[PRICE]\n• Grooming: $[PRICE]\n• Dental Cleaning: $[PRICE]\n\nFor detailed pricing on other services, please let us know what you need!"
      },
      {
        short_code: 'results',
        content: "Lab results typically take 24-48 hours. We'll contact you as soon as they're ready. You can also check your results through our patient portal."
      },
      {
        short_code: 'medication',
        content: "For medication refills, please provide:\n1. Your pet's name\n2. Medication name\n3. Last prescription date\n\nWe'll have it ready for pickup within 24 hours."
      },
      {
        short_code: 'grooming',
        content: "Our grooming services include:\n✂️ Bath & Brush\n✂️ Full Groom (bath, trim, nail clipping)\n✂️ Nail Trim Only\n✂️ Teeth Brushing\n\nWhich service would you like to book?"
      },
      {
        short_code: 'boarding',
        content: "Pet boarding information:\n🏨 Climate-controlled rooms\n🏨 24/7 supervision\n🏨 Daily walks and playtime\n🏨 Medications administered\n\nRates: $[PRICE] per night. When would you like to board your pet?"
      },
      {
        short_code: 'neuter',
        content: "Spay/Neuter information:\n• Best age: 6-9 months\n• Pre-surgery exam required\n• Same-day procedure\n• Post-op care instructions provided\n\nWould you like to schedule a consultation?"
      },
      {
        short_code: 'dental',
        content: "Pet dental care is important! Signs your pet may need dental work:\n🦷 Bad breath\n🦷 Yellow/brown teeth\n🦷 Difficulty eating\n🦷 Bleeding gums\n\nWe offer dental exams and cleanings. Shall we schedule one?"
      },
      {
        short_code: 'thankyou',
        content: "Thank you for trusting us with your pet's care! 🐾 If you have any other questions, feel free to reach out anytime."
      },
      {
        short_code: 'followup',
        content: "Your pet's follow-up appointment is scheduled for [DATE] at [TIME]. Please arrive 10 minutes early. If you need to reschedule, let us know!"
      },
      {
        short_code: 'nutrition',
        content: "For nutrition consultation, we offer:\n• Diet analysis\n• Weight management plans\n• Food allergy testing\n• Senior pet nutrition\n\nWould you like to book a consultation with our nutrition specialist?"
      },
      {
        short_code: 'training',
        content: "We offer pet training services:\n🎓 Basic obedience\n🎓 Behavioral issues\n🎓 Puppy/kitten socialization\n🎓 Advanced training\n\nGroup classes and private sessions available. Interested?"
      },
      {
        short_code: 'insurance',
        content: "We accept most major pet insurance providers. Please bring your insurance information to your appointment. We'll provide all necessary documentation for your claim."
      },
      {
        short_code: 'payment',
        content: "Payment options:\n💳 Credit/Debit cards\n💳 Cash\n💳 Pet insurance\n💳 Payment plans available for procedures over $[AMOUNT]\n\nPayment is due at time of service."
      },
      {
        short_code: 'symptoms',
        content: "To better assist you, please describe:\n1. What symptoms is your pet showing?\n2. When did symptoms start?\n3. Any recent changes in diet or behavior?\n4. Is your pet eating/drinking normally?"
      },
      {
        short_code: 'prescription',
        content: "Prescription ready for pickup! 💊\n• Please bring ID\n• Pick up within 7 days\n• Administration instructions included\n\nOur pharmacy hours: [HOURS]"
      }
    ]

    canned_responses.each do |response_attrs|
      response = account.canned_responses.find_or_initialize_by(short_code: response_attrs[:short_code])
      response.assign_attributes(response_attrs.except(:short_code))
      response.save! if response.new_record? || response.changed?
    end

    Rails.logger.info "  ✓ Created #{canned_responses.count} pet-focused canned responses"

    Rails.logger.info "✅ Pet Sector setup completed for account: #{account.name}\n"
  end
else
  Rails.logger.warn '⚠️  No accounts found. Please create an account first, then run this seed again.'
end

Rails.logger.info '🐾 Pet Sector setup finished!'
