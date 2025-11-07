class EvolutionApi::SyncService < EvolutionApi::BaseService
  def perform
    return unless config.enabled?

    Rails.logger.info "Starting Evolution API sync for account #{config.account_id}"

    instances = fetch_instances
    sync_instances_to_inboxes(instances)

    config.update!(
      last_synced_at: Time.current,
      last_sync_error: nil
    )

    Rails.logger.info "Evolution API sync completed for account #{config.account_id}"

    { success: true, synced_instances: instances.count }
  rescue StandardError => e
    Rails.logger.error "Evolution API sync failed: #{e.message}"
    config.update!(last_sync_error: e.message)
    raise
  end

  private

  def fetch_instances
    response = http_client.get(
      api_url('/instance/fetchInstances'),
      headers: request_headers
    )

    handle_response(response) || []
  end

  def sync_instances_to_inboxes(instances)
    instances.each do |instance_data|
      next unless instance_data['instance']&.dig('instanceName')

      sync_instance_to_inbox(instance_data)
    end
  end

  def sync_instance_to_inbox(instance_data)
    instance_name = instance_data['instance']['instanceName']
    phone_number = extract_phone_number(instance_data)

    # Find or create inbox for this Evolution instance
    inbox = find_or_create_inbox(instance_name, phone_number)

    # Update inbox settings with Evolution data
    update_inbox_settings(inbox, instance_data)
  end

  def find_or_create_inbox(instance_name, phone_number)
    # Look for existing inbox by name or create new one
    config.account.inboxes.find_or_initialize_by(
      name: "Evolution: #{instance_name}"
    ).tap do |inbox|
      if inbox.new_record?
        inbox.channel = create_api_channel(instance_name, phone_number)
        inbox.save!
      end
    end
  end

  def create_api_channel(instance_name, phone_number)
    Channel::Api.create!(
      account: config.account,
      additional_attributes: {
        evolution_instance: instance_name,
        evolution_phone: phone_number,
        webhook_url: "#{config.formatted_api_url}/webhook/chatwoot"
      }
    )
  end

  def update_inbox_settings(inbox, instance_data)
    inbox.update(
      additional_attributes: inbox.additional_attributes.merge(
        evolution_instance: instance_data['instance']['instanceName'],
        evolution_status: instance_data['instance']['status'],
        evolution_phone: extract_phone_number(instance_data),
        last_evolution_sync: Time.current.to_s
      )
    )
  end

  def extract_phone_number(instance_data)
    instance_data.dig('instance', 'owner') ||
      instance_data.dig('instance', 'profilePicture') ||
      'Unknown'
  end
end
