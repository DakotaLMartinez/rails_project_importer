desc "Run the batch importer to get all the new batches"
task :batch_import => :environment do
  BatchImporter.import
end