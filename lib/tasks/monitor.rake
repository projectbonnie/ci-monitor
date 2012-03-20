
namespace :monitor do

  desc 'Merge multiple records per patient from source_dir into a single record per patient in dest_dir'
  task :jenkins, [] do |t, args|
    job = CI::Jenkins::MonitorJob.new
    job.start
  end

end