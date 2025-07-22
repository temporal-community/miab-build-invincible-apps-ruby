require 'sinatra/base'
require 'temporalio/client'
require 'json'
require 'securerandom'

require_relative '../lib/ip_geolocate'

class App < Sinatra::Base
  configure do
    set :public_folder, File.join(File.dirname(__FILE__), 'views')
    set :temporal_client, Temporalio::Client.connect('localhost:7233', 'default')
  end

  # Execute the Temporal Workflow
  def start_workflow(name)
    settings.temporal_client.execute_workflow(
      IPGeolocate::GetAddressFromIPWorkflow,
      name, # Workflow input
      id: "workflow-ip-geolocate-#{SecureRandom.uuid}",
      task_queue: IPGeolocate::TASK_QUEUE_NAME
    )
  end

  # Handle HTMX form submission
  post '/submit' do
    begin
      name = params[:name]
      result = start_workflow(name)
      "<p>#{result}</p>"
    rescue StandardError
      "<p>An error occurred</p>"
    end
  end

  # Handle API request for cURL
  post '/api' do
    content_type :json
    begin
      request_body = JSON.parse(request.body.read)
      puts request_body
      result = start_workflow(request_body['name'])
      result.to_json
    rescue StandardError => e
      status 500
      "An error occurred: #{e.message}".to_json
    end
  end

  # render root route
  # In production, use your front-end server to serve this.
  if development?
    get '/' do
      redirect to('/index.html')
    end
  end

end