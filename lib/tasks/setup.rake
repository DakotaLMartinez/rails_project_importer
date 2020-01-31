desc "Run this command once on setup to add batches and project data"
task :setup => :environment do
  Rake::Task["db:migrate"].invoke
  Rake::Task["batch_import"].invoke
  Rake::Task["project_import"].invoke
end