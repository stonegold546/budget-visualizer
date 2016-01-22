require 'rake/testtask'
require 'config_env/rake_tasks'

task default: :spec

desc 'Run all tests'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
end

desc 'default config task'
task :config do
  require 'config_env'
  ConfigEnv.path_to_config("#{__dir__}/config/config_env.rb")
end

namespace :queue do
  require 'aws-sdk'

  desc 'Create Shoryuken queue'
  task create: [:config] do
    sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])

    begin
      sqs.create_queue(queue_name: 'kandianying_moocher')
      puts "Queue created in #{ENV['AWS_REGION']}"
    rescue => e
      puts "Error creating queue: #{e}"
    end
  end

  desc 'Delete Shoryuken queue'
  task delete: [:config] do
    sqs = Aws::SQS::Client.new(region: ENV['AWS_REGION'])

    begin
      queue_url = sqs.get_queue_url(queue_name: 'kandianying_moocher')
      queue_url = queue_url.to_h[:queue_url]
      sqs.delete_queue(queue_url: queue_url)
      puts "Queue deleted from #{ENV['AWS_REGION']}"
    rescue => e
      puts "Error deleting queue: #{e}"
    end
  end
end
