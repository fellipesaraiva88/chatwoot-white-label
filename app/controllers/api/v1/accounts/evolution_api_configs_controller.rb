class Api::V1::Accounts::EvolutionApiConfigsController < Api::V1::Accounts::BaseController
  before_action :check_authorization
  before_action :set_config, only: [:show, :update, :destroy, :test_connection, :sync_now]

  def index
    @configs = Current.account.evolution_api_configs.order(created_at: :desc)
  end

  def show; end

  def create
    @config = Current.account.evolution_api_configs.new(config_params)

    if @config.save
      render json: @config, status: :created
    else
      render json: { errors: @config.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @config.update(config_params)
      render json: @config
    else
      render json: { errors: @config.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @config.destroy
    head :no_content
  end

  def test_connection
    result = @config.test_connection

    if result[:success]
      render json: result
    else
      render json: result, status: :unprocessable_entity
    end
  end

  def sync_now
    result = @config.sync_now

    render json: {
      success: true,
      message: 'Sync completed successfully',
      data: result
    }
  rescue StandardError => e
    render json: {
      success: false,
      message: e.message
    }, status: :unprocessable_entity
  end

  private

  def set_config
    @config = Current.account.evolution_api_configs.find(params[:id])
  end

  def config_params
    params.require(:evolution_api_config).permit(
      :api_url,
      :api_key,
      :instance_name,
      :enabled,
      :auto_sync,
      sync_settings: {}
    )
  end

  def check_authorization
    authorize :evolution_api_config
  end
end
