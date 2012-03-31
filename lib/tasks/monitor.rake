
namespace :monitor do

  desc 'Merge multiple records per patient from source_dir into a single record per patient in dest_dir'
  task :ci_status, [] do |t, args|
    job = CI::MonitorJob.new
    job.start
  end

end