app_dir = File.expand_path('../', File.dirname(__FILE__))

working_directory app_dir

pid '/tmp/unicorn.pid'

stderr_log_path = "#{app_dir}/log/unicorn.stderr.log"
stdout_log_path = "#{app_dir}/log/unicorn.stdout.log"

[stderr_log_path, stdout_log_path].each do |path|
  next if File.exist?(path)
  FileUtils.touch path
end

stderr_path stderr_log_path
stdout_path stdout_log_path

worker_processes 1
listen '/tmp/unicorn.sock', backlog: 64
timeout 30
