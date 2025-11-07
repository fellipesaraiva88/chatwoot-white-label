# == Schema Information
#
# Table name: evolution_api_configs
#
#  id             :bigint           not null, primary key
#  account_id     :bigint           not null
#  api_url        :string           not null
#  api_key        :string           not null
#  instance_name  :string
#  enabled        :boolean          default(TRUE)
#  auto_sync      :boolean          default(TRUE)
#  sync_settings  :jsonb            default({})
#  last_synced_at :datetime
#  last_sync_error :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class EvolutionApiConfig < ApplicationRecord
  belongs_to :account

  validates :api_url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'must be a valid URL' }
  validates :api_key, presence: true
  validates :instance_name, uniqueness: { scope: :account_id }, allow_nil: true

  encrypts :api_key

  scope :enabled, -> { where(enabled: true) }
  scope :auto_sync_enabled, -> { where(auto_sync: true, enabled: true) }

  def sync_now
    EvolutionApi::SyncService.new(self).perform
  rescue StandardError => e
    update(last_sync_error: e.message)
    raise
  end

  def test_connection
    EvolutionApi::ConnectionTestService.new(self).test
  end

  def formatted_api_url
    api_url.chomp('/')
  end
end
