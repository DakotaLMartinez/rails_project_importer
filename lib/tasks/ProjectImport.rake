desc "Run the project importer to get all the projects"
task :project_import => :environment do
  Batch.all.each do |batch|
    if batch.iteration || batch.name
      results = batch.fetch_projects
      puts "#{batch.iteration}: #{results.length} projects imported"
    end
  end
end