class CreateEvolutionApiConfigs < ActiveRecord::Migration[7.0]
  def change
    create_table :evolution_api_configs do |t|
      t.references :account, null: false, foreign_key: true, index: true
      t.string :api_url, null: false
      t.string :api_key, null: false
      t.string :instance_name
      t.boolean :enabled, default: true
      t.boolean :auto_sync, default: true
      t.jsonb :sync_settings, default: {}
      t.datetime :last_synced_at
      t.text :last_sync_error

      t.timestamps
    end

    add_index :evolution_api_configs, [:account_id, :instance_name], unique: true, name: 'index_evolution_configs_on_account_and_instance'
  end
end
